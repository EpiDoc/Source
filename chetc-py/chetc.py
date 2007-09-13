# -*- coding: utf-8 -*-  #
#
# File: chetc.py
#
# Chapel Hill Electronic Text Converter (CHET-C): Python version
#
# Copyright (C) 2007 by Hugh Cayless and Tom Elliott.
# Additional contributors' copyright may be designated in individual source files.
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# 
# Information about the EpiDoc community can be obtained via 
# http://epidoc.sf.net.
# 
# Funding from the Andrew W. Mellon Foundation paid for the initial 
# version of this code through a grant to Duke University and partners
# for the enhancement of the Duke Database of Documentary Greek 
# Papyri and the Papyrological Navigator web portal.
#
import os
import re
import types

RPATH = 'replacements'
ROPTIONS = 'replacements/replacement_options.txt'

replacement_files = {}
replacements = {}

def convert(source, mode):
    """Convert a python unicode string to EpiDoc markup, interpreting its
    content in accordance with a particular named style of Leiden 
    conventions.
    
    'source' contains a unicode string in Leiden; space will be normalized
    before processing
    
    'mode' contains a string indicating the name of the Leiden style
    to use; this should correspond to a key defined in the
    replacement_files dictionary
    
    The returned result is the corresponding EpiDoc xslt as a unicode string. 
    All character entities etc. are assumed to have been normalized in the 
    source string. 
    
    For examples, see doctests in tests subfolder.
    To run tests, type (at the command line):
        
        python chetc.py
        
    """
    try:
        if len(replacement_files[mode]) == 0:
            print "no replacement file for mode '%s'" % mode
    except KeyError:
        load_replacement_options(ROPTIONS)
        
    try:
        if len(replacements[mode]) == 0:
            print 'no replacements'
    except KeyError:
        load_replacements(mode)
        
    rlist = replacements[mode]
    result = source
    for regex, template in rlist:
        # parse out the unique length variables in this template and store as a list of tuples:
        # (varname, groupnum, lengthnum) -- don't know why we need a lennum
        lenvars = [(m.group(0), m.group(1), m.group(2)) for m in re.finditer(r'%g(\d)%len(\d)', template)]
        if len(lenvars) == 0:
            result = dosub(regex, template, result)
        else:
            # figure out how many matches there are
            matches = re.findall(regex, result)
            # for each match, determine the length value to use and create a more specific
            # replacement template to use with that match by replacing the length variable
            # with the calculated value
            thesetemplates = []
            for m in matches:
                thesetemplates.append(template)
                for lv in lenvars:
                    varname = lv[0]
                    groupnum = int(lv[1])
                    lengthnum = int(lv[2])
                    # determine length on this match
                    if type(m) == types.UnicodeType or type(m) == types.StringType:
                        thislen = "%s" % len(m.replace(' ', ''))
                    else:
                        thislen = m.group(groupnum)
                    # modify template accordingly
                    thesetemplates[-1] = thesetemplates[-1].replace(varname, thislen)
            i = 0
            while len(re.findall(regex, result)) > 0:
                result = dosub(regex, thesetemplates[i], result, 1)
                i += 1
                if i > 10:
                    print 'runaway!'
                    break
    return result
    
def dosub(pattern, repl, string, count=None):
    """execute a regex-based substitution using enhanced error handling"""
    try:
        if count:
            result = re.sub(pattern, repl, string, count)
        else:
            result = re.sub(pattern, repl, string)
    except:
        print 'failed regular expression substition: pattern or repl may have errors'
        print "pattern = '%s'" % pattern
        print "repl = '%s'" % repl
        print "string = '%s'" % string.encode('ascii', 'backslashreplace')
        raise
    return result
    
def load_replacement_options(filepath):
    """Load the contents of a file 
    that defines names for the various supported styles of Leidin markup
    and also points to a file of regular expressions and replacement
    templates associated with each of those style types."""
    f = open(filepath)
    rlist = f.readlines()
    f.close()
    # remove newline characters
    rlist = [line.replace('\n', '') for line in rlist if len(line.replace(' ', '')) > 0]
    # strip comments and split remaining lines into tuples
    rlist = [re.split('\s+\=\s+', line, 1) for line in rlist if line[0] != '#']
    for mode, filename in rlist:
        replacement_files[mode] = os.path.join(RPATH, filename)
        
def load_replacements(mode):
    """Load the contents of the replacement file corresponding to the value
    passed in the string parameter 'mode' into the 'replacements'
    dictionary. We expect JavaScript style regexes (for compatibility
    with the JavaScript version of chetc, so munge these to python
    style."""
    f = open(replacement_files[mode])
    rlist = f.readlines()
    f.close()
    # remove newline characters
    rlist = [line.replace('\n', '') for line in rlist]
    # strip comments and split remaining lines into tuples
    rlist = [re.split('\s+\=\s+', line, 1) for line in rlist if line[0] != '#']
    # munge backreference syntax from javascript re to python re
    rlist = [(item[0], re.sub(r'\$(\d)', r'\\\1', item[1])) for item in rlist]
    # munge unicode character reference syntax from javascript string to python string
    rlist = [(re.sub(r'(\u)(\d+)', lambda match: unichr(int(match.group(2), 16)), item[0]), item[1]) for item in rlist]
    replacements[mode] = rlist
       
def _test():
    import doctest
    doctest.testmod()
    doctest.testfile('tests/chetc_replacements_panciera.txt')
    # invoke additional doctest files here

if __name__ == "__main__":
    _test()

    
    
    
    
    
    