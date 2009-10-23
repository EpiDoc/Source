EpiDoc XSLT Stylesheets
README.txt

These stylesheets are intended for the conversion of EpiDoc-conformant TEI XML
files to XHTML + CSS. They are also used to transform the EpiDoc Guidelines
from XML to XHTML.

See the following URL for setup and use documentation:

http://epidocumentation.pbwiki.com/UsingTheStandardStyleSheets

See http://epidoc.sf.net for more information about EpiDoc.



Modifiers, system integrators and programmers need to know:

* these stylesheets are pure xsl 1.0, and have been used successfully
under most recent release versions of:
** Xalan (command line, via Apache Cocoon and via Oxygen XML editor)
** libxslt
** msxml
** lxml for python (which is running libxslt underneath)

* these stylesheets expect xml declared in the TEI namespace 
(http://www.tei-c.org/ns/1.0) and this even though right now the EpiDoc 
customization is based on the P4 version of TEI (with the borrowing
of a few P5-ish structures) -- there are a couple of xslt files in the
util directory that can be used to force namespace delcarations on a
document:
** force-namespace.xsl (supply namespace uri via a parameter)
** force-namespace-tei.xsl (the tei namespace is hard-wired)

* to start the entire transformation, you want to invoke the file
epidoc.xsl in the html subdirectory. This file imports all the other
needed xsl files.

* no files in the util directory are imported or used by the html
transform process; all of that is in the html directory. Most of the
files in the util directory are used by the EpiDoc webapp for Apache
Cocoon in processing a batch of EpiDoc files or preparing the Guildelines

* the html transformation process, which is relatively complex, has been
chunked into a number of files (and of course a number of templates). An
attempt has been made to maintain fairly logical filenames with respect
to the function of the templates in each file.

* you'll find alot of logic that's related to dealing with the 
aggressively hierarchical EpiDoc Guidelines

* there are 3 general classes of templates (and most files can be 
assigned to one of these classes as well as all the templates contained
in an individiual file will tend to belong to a single class):

    1. processing of TEI document structures and/or HTML document structures
and required header components

    2. processing of TEI inline tagging, especially the EpiDoc-conformant
elements and attribute combintations that correspond to the editorial 
interventions and observations, as well as the critical apparatus
constructed by the person(s) editing the ancient text

    3. oft-needed procedural functions, such as detecting and 
processing standard TEI attributes (like id, n, lang) for rendering in
appropriate HTML structures

Following is the main structuring outline showing which xslt file handles (or
starts the handling of) a given main structural node in the source
TEI file. If you're not familiar with the structuring of an EpiDoc TEI
document (especially the standard typed divs within the body element)
you may want to consult the appropriate portion of the EpiDoc Guidelines
at http://www.stoa.org/epidoc/gl/5/xmlencoding.html

<TEI.2> -> tei2.xsl
  <teiHeader> -> teiheader.xsl -> dohtmlheadboilerplate.xsl
    ...
  </teiHeader>
  <text> -> teitext.xsl -> dohtmlbodyboilerplate.xsl
    <body> -> teibody.xsl
      <div type="description"> -> teidiv.xsl
         ...
      </div>
      <div type="commentary"> -> teidiv.xsl
         ...
      </div>
      <div type="edition"> -> teidiv.xsl
         ...
      </div>
      ...
  </text>
</TEI.2>

Note that teidiv-epidocedition.xsl is, I think, only invoked when processing
the EpiDoc Guidelines, not a standard EpiDoc file.
  

