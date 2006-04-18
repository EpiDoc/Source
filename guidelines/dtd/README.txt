Read me for the epidoc guidelines dtd
Current dtd version shipped here (FOR *GUIDELINES* DEVELOPMENT USE ONLY) is derived from Rev 1.13.2.3 in the dtd module in sourceforge cvs (branch "sandstorm"), with changes:
* to add needed xmlns attributes and to change the lang attribute from an IDREF to CDATA. 
* to add xi:include to content models for body and div
* to add a definition for xi:include
These changes are accomplished with the gl-dtd-convert.pl perl script in the guidelines/dtd directory.

Example command line issued from within the guidelines\dtd\ directory on a windows box:

perl gl-dtd-convert.pl ..\..\dtd\tei-epidoc.dtd > .\tei-epidoc.dtd

tei-epidoc.css included for convenience of users of XMetaL and similar XML editors

24 March 2005 - TE