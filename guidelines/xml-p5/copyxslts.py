#!/usr/bin/python

__description__ = 'Copies stylesheets from example-p5-xslt and changes their default namespace'
__author__ = 'Raffaele Viglianti'
__version__ = '0.1'
__date__ = '2011/05/25'

"""
Source code put in public domain by Raffaele Viglianti, no Copyright
Use at your own risk

History:
  2011/05/25: copy files

Todo:
  
"""

import sys, os, shutil
import re

def copyFiles(start, destination):
	''' Copies stylesheets from example-p5-xslt'''
	
	styles = os.listdir(start)
	for s in styles:
		fullp = os.path.join(start,s)
		if not os.path.isdir(fullp):
			shutil.copy(fullp, destination)
	
def changeNs(where, old_pref, old, new_pref, new):
	'''Chages old namespace with prefix to new namespace with prefix'''
	styles = os.listdir(where)
	for s in styles:
		fullp = os.path.join(where,s)
		if not os.path.isdir(fullp) and fullp[-4:] == '.xsl':
			
			fileobj = file(fullp, 'r')
			text = fileobj.read()
			fileobj.close()
			
			old_full = r'xmlns:%s="%s"' % (old_pref, old)
			new_full = r'xmlns:%s="%s"' % (new_pref, new)
			
			newns_text = re.sub(old_full, new_full, text)
			
			fileobj = file(fullp, 'w')
			print >> fileobj , newns_text
			fileobj.close()
			
def createMaster(src, out):
	'''Create a master file based on one of the start-*.xsl files'''
	fileobj = file(src, 'r')
	lines = fileobj.readlines()
	fileobj.close()
	
	new_lines = []
	
	cut = False
	for l in lines:
		if not cut:
			if re.search(r'<xsl:template\s+match="/"\s*>', l):
				cut = True
			else:
				new_lines.append(l)
		elif re.search(r'</xsl:stylesheet>', l):
			new_lines.append(l)
		else:
			continue
			
	
	fileobj = file(out, 'w')
	fileobj.writelines(new_lines)
	fileobj.close()
	
def Main():
	''' Set parameters, call subroutines  '''
	
	start = '../../example-p5-xslt'
	destination = 'xslt/example-xsl-copy'
	copyFiles(start, destination)
	
	old_pref = 't'
	new_pref = old_pref
	old = 'http://www.tei-c.org/ns/1.0'
	new = 'http://www.tei-c.org/ns/Examples'
	changeNs(destination, old_pref, old, new_pref, new)
	
	src = os.path.join(destination, 'start-edition.xsl')
	out = os.path.join(destination, 'start-guidelines.xsl')
	createMaster(src, out)
	
	
if __name__ == '__main__':
    Main()