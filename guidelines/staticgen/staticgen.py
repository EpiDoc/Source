import glob
from os.path import normpath, normcase, isfile, splitdrive, splitext, split, join
from os import listdir
import re

import lxml.etree as etree

from etreehelps import getalltext
from texthelps import normalizetext


class Piper:
    """
    
    A class that knows how to create static html from xml source using processing pipelines
    provided via an external xml configuration file, the path to which (including arbitrary
    filename) is passed in as an argument. 
    
    Usage (python prompt):
    
    >>> import staticgen
    >>> g = staticgen.Piper(r'C:\TomDocs\epidocwork\epidoc-sf\guidelines\staticgen\config.xml')
    >>> g.cycle()
    
    The format of the config file should be relatively self-evident from the example. Note the 
    similarities to (and differences from) a cocoon sitemap.xmap file.
    
    """
    
    def __init__(self, configpathname):
        # load and store config file
        self.pipes = []
        f = open(configpathname)
        config = f.read()
        f.close()
        self.configtree = etree.XML(config)
        try:
            self.generatepath = normpath(normcase(normalizetext(self.configtree.xpath("//generatepath")[0].text)))
        except:
            self.generatepath = ''
        try:
            self.transformpath = normpath(normcase(normalizetext(self.configtree.xpath("//transformpath")[0].text)))
        except:
            self.transformpath = ''
        try:
            self.destpath = normpath(normcase(normalizetext(self.configtree.xpath("//destpath")[0].text)))
        except:
            self.destpath = ''
        for pelement in self.configtree.xpath("//pipe"):
            self.pipes.append(Pipe(self, pelement))
        
    def cycle(self):
        for pipe in self.pipes:
            if pipe.type != 'internal':
                pipe.cycle()
            
    def find_pipe(self, pattern):
        for p in self.pipes:
            try:
                if p.pattern == pattern:
                    return p
            except:
                pass
        return None

class Pipe:
    """This class stores information about an individual processing pipeline, and knows how to load
    it from a configuration file pipe element (lxml) and how to execute that pipeline."""
    
    def __init__(self, parent, pelement):
        self.parent = parent
                
        try:
            self.type = pelement.attrib['type']
        except:
            self.type = 'normal'
        if self.type == 'internal':
            self.pattern = pelement.attrib['pattern']
        self.generator = Generator(self, pelement.xpath("generate")[0])
        self.transforms = []
        for telement in pelement.xpath("transform"):
            self.transforms.append(Transform(telement))
        try:
            self.serialize = pelement.xpath("serialize")[0].attrib['type']
        except:
            self.serialize = ''
        self.emits = []
        for eelement in pelement.xpath("emit"):
            self.emits.append(Emit(self, eelement))
        
    def cycle(self):
        print 'NEW PIPE'
        print ' - generating %s (type = %s)' % (self.generator.src, self.generator.type)
        if self.generator.type == 'directorylist':
            glist = self.generator.cycle()
            for gitem in glist:
                gfile = join(self.parent.generatepath, gitem)
                print '   - parsing %s' % gfile
                gtree = etree.parse(gfile)
                gtree = self.do_transforms(gtree)
                for e in self.emits:
                    e.cycle(gtree, gitem)
        else:
            gtree = self.generator.cycle()
            gtree = self.do_transforms(gtree)
            # note that serialization settings are ignored 
            for e in self.emits:
                e.cycle(gtree)
            if self.type == 'internal':
                return etree.XML(unicode(gtree))
        print 'PIPE COMPLETE\n'
        
    
        
    def do_transforms(self, intree):
        gtree = intree
        for t in self.transforms:
            if t.type == 'xinclude':
                print ' - xinclude transform started ...'
                
                
                internals = gtree.xpath("//*[local-name()='include' and starts-with(@href, 'cocoon:/')]")
                if len(internals) > 0:
                    
                    for internal in internals:
                        internal_pattern = internal.attrib['href'].replace('cocoon:/', '', 1)
                        ipipe = self.parent.find_pipe(internal_pattern)
                        iresult = ipipe.cycle()
                        internal_parent = internal.getparent()
                        internal_i = internal_parent.index(internal)
                        internal_parent.insert(internal_i, iresult)
                        internal_parent.remove(internal)

                gtree.xinclude()
            else:
                print ' - xslt transform started: %s ...' % t.source
                xfile = join(self.parent.transformpath, t.source)
                xdoc = etree.parse(xfile)
                xform = etree.XSLT(xdoc)
                if len(t.parameters) == 0:
                    result = xform(gtree)
                else:
                    kw = {}
                    for param in t.parameters:
                        kw[param[0]] = "'%s'" % param[1]
                    result = xform(gtree, **kw)
                gtree = result
            print '   ... transform complete'
        return gtree
        
            

class Generator:
    """This class knows how to generate various types of sources (mostly from file) for use
    later in the pipeline"""
    
    def __init__(self, parent, gelement):
        self.parent = parent
        try:
            self.type = gelement.attrib['type']
        except:
            self.type = 'file'
        self.src = gelement.attrib['src']
        params = gelement.xpath("parameter")
        self.params = []
        for param in params:
            self.params.append((param.attrib['name'], param.attrib['value']))
        
    def cycle(self):
        if self.type == 'file':
            gfile = join(self.parent.parent.generatepath, self.src)
            gtree = etree.parse(gfile)
            return gtree
        else:
            dlist = listdir(join(self.parent.parent.generatepath, self.src))
            print 'PARAMS:'
            print self.params
            exclusions = [param[1] for param in self.params if param[0] == 'exclude']
            print 'EXCLUSIONS:'
            print exclusions
            #re_exclusions = [param[1].replace(r'*',r'[^\s\.]*').replace(r'.',r'\.') for param in self.params if param[0] == 'exclude' and param[1].find('*') != -1]
            #ilist = [item for item in dlist if item not in exclusions]
            ilist = []
            for rex in exclusions:
                print rex
                rexc = re.compile(rex)
                for item in dlist:
                    # if item not in ilist:
                    m = rexc.match(item)
                    if m:
                        print ' ~~~ pruning: %s' % item
                    else:
                        print ' ~~~ APPENDING: %s' % item
                        ilist.append(item)
            if self.type=='directory':
                dxml = etree.Element("directory")
                for item in ilist:
                    f = etree.SubElement(dxml, "file")
                    f.attrib['name'] = item
                return dxml
            elif self.type=='directorylist':
                return [join(self.src, item) for item in ilist]
                
    
                
class Transform:
    """This class loads and stores information about an individual transformation element found in
    a config file processing pipe."""
    
    def __init__(self, telement):
        self.source = ''
        try:
            self.source = telement.attrib['src']
            self.type = 'xslt'
        except:
            self.type = telement.attrib['type']
        self.parameters = []
        for param in telement.xpath("parameter"):
            self.parameters.append((param.attrib['name'], param.attrib['value']))
        
class Emit:
    """This class loads and stores information about outputting data from a pipe."""
    
    def __init__(self, parent, eelement):
        self.parent = parent
        try:
            self.destination = eelement.attrib['dest']
            self.type = 'filename'
        except:
            self.type = 'file'
        self.parameters = {}
        for param in eelement.xpath("parameter"):
            self.parameters[param.attrib['name']]= param.attrib['value']
            
    def cycle(self, content, sourcename='None', encoding='utf-8'):
        econtent = etree.tostring(content).encode(encoding)
        if self.type=='filename':
            efile = join(self.parent.parent.destpath, self.destination)
        elif self.type=='file':
            efile = join(self.parent.parent.destpath, u'.'.join((splitext(split(sourcename)[-1])[0], self.parameters['extension'])))   
        f = open(efile, 'w')
        f.write(econtent)
        f.close()
        
        