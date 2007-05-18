from os.path import normpath, normcase, isfile, splitdrive, splitext, split, join

import lxml.etree as etree

from etreehelps import getalltext
from texthelps import normalizetext


class Generator:
    """
    
    A class that knows how to generate static html from xml source using a processing pipeline
    provided via an external xml configuration file, the path to which (including arbitrary
    filename) is passed in as an argument. 
    
    Usage (python prompt):
    
    >>> import staticgen
    >>> g = staticgen.Generator(r'C:\TomDocs\epidocwork\epidoc-sf\guidelines\staticgen\config.xml')
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
            pipe.cycle()

class Pipe:
    """This class stores information about an individual processing pipeline, and knows how to load
    it from a configuration file pipe element (lxml) and how to execute that pipeline."""
    
    def __init__(self, parent, pelement):
        self.parent = parent
        self.generate = normalizetext(pelement.xpath("generate")[0].text)
        self.transforms = []
        for telement in pelement.xpath("transform"):
            self.transforms.append(Transform(telement))
        self.serialize = pelement.xpath("serialize")[0].attrib['type']
        self.emit = normalizetext(pelement.xpath("emit")[0].text)
        
    def cycle(self):
        gfile = join(self.parent.generatepath, self.generate)
        gtree = etree.parse(gfile)
        for t in self.transforms:
            if t.type == 'xinclude':
                gtree.xinclude()
            else:
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
        presult = etree.tostring(gtree).encode('utf-8')
        efile = join(self.parent.destpath, self.emit)
        f = open(efile, 'w')
        f.write(presult)
        f.close()
        
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
        