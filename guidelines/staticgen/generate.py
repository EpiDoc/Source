# generate.py

import sys
import getopt
import glob
import shutil
import os.path

import staticgen

def main(argv):
    """generate epidoc guidelines for release. Use from the command line like:
        > python generate.py -c config.xml
        where config.xml is an epidoc static-gl config file
        """
    config = None
        
    try:
        opts, args = getopt.getopt(argv, "c:", ["config="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
     
    for opt, arg in opts:
        if opt in ("-c", "--config"):
            config = arg
            
    if config:
        config = os.path.normpath(os.path.normcase(config))
        if not(os.path.exists(config)):
            usage("specified config file (%s) does not exist" % config)
            sys.exit(2)
        g = staticgen.Piper(config)
        g.cycle()
        
    else:
        usage ("no config specififed")
        sys.exit(2)
        
def usage(nag="None"):
    if nag:
        print nag
    print "get a clue, user boy"
        
if __name__ == "__main__":
    main(sys.argv[1:])
    
