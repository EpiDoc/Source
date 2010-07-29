********************************************************************************
* dtd README                                                                                              *
********************************************************************************

THIS TOOL IS DEPRECATED. The current replacement tool (as of July 2010) is the EpiDoc RelaxNG schema. Use this package at your own risk.

What it is:
        This module includes the final version of the EpiDoc Document Type Definition (DTD) that was conformant to TEI P4.
 
License:
        This software is copyright TEI, with modifications copyright all contributors (as listed in the revision histories in the files tei-epidoc-ext.dtd and tei-epidoc-ext.ent. dtdfix.pl is copyright John Lavagnino. See LICENSE.txt for license details.
 
Technical requirements and limitations:
        The so-called extension files (tei-epidoc-ext.dtd and tei-epidoc-ext.ent) were used to customize the standard TEI P4 DTD using the "TEI Pizza Chef" (http://www.tei-c.org/pizza.html). pizzachefsettings.txt records the parameters given to that tool. Post-generation by the pizza chef (tei-epidoc-pizza.dtd), the dtd was run through dtdfix.pl to sort and normalize entity, element and attribute declarations.
 
How to use it:
        tei-epidoc.dtd is the final product of the generation process. It is the only file that should be used for validation, etc. purposes.
        