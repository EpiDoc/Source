# package.py

import sys
import getopt
import glob
import shutil
import os.path

def main(argv):
    """package epidoc guidelines for release. use from the command line like:
    > python package.py -d C:\staticgl -x C:\TomDocs\epidocwork\epidoc-sf\guidelines\src -s C:\TomDocs\epidocwork\epidoc-sf\epidoc-xsl\css
    """
    dest = None
    xmlsrc = None
    stylesrc = None
    
    try:                                
        opts, args = getopt.getopt(argv, "c:d:x:s:", ["config=", "destination=", "xmlsrc=", "stylesrc="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)                     
    
    for opt, arg in opts:
        if opt in ("-c", "--config"):
            print "xml config not supported"
        elif opt in ("-d", "--destination"):
            dest = arg
        elif opt in ("-x", "--xmlsrc"):
            xmlsrc = arg
        elif opt in ("-s", "--stylesrc"):
            stylesrc = arg
        
    if dest:
        # is dest a valid destination?
        dest = os.path.normpath(os.path.normcase(dest))
        checkdir(dest, "destination")
        if xmlsrc:
            xmlsrc = os.path.normpath(os.path.normcase(xmlsrc))
            checkdir(xmlsrc, "xml source")
            for xml in glob.glob("%s/*.xml" % xmlsrc):
                thisdest = os.path.normcase("%s/%s" % (dest, os.path.basename(xml)))
                shutil.copyfile(xml, thisdest)
                print "copying %s --> %s" % (xml, thisdest)
        if stylesrc:
            stylesrc = os.path.normpath(os.path.normcase(stylesrc))
            checkdir(stylesrc, "style (css) source")
            for css in glob.glob("%s/*.css" % stylesrc):
                thisdest = os.path.normcase("%s/%s" % (dest, os.path.basename(css)))
                shutil.copyfile(css, thisdest)
                print "copying %s --> %s" % (css, thisdest)
        
        
        
    else:
        usage("no destination specified")
        sys.exit(2)
    
def checkdir(dpath, dtype):
    if not(os.path.exists(dpath)):
        usage("specified %s (%s) does not exist" % (dtype, dpath))
        sys.exit(2)
    elif not(os.path.isdir(dpath)):
        usage("specified %s (%s) is not a directory" % (dtype, dpath))
        sys.exit(2)
        
        
def usage(nag=None):
    if nag:
        print nag
    print "get a clue, user boy"
    

if __name__ == "__main__":
    main(sys.argv[1:])