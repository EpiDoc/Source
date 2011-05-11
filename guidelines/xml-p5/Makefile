P5ROOT=http://www.tei-c.org/release/xml
LANGUAGE=en

schema: compiled
	xmllint --noent --xinclude driver.xml > tei-epidoc-full.xml
	 roma2 	--localsource=p5subset.xml tei-epidoc-full.xml .
	rm tei-epidoc-full.xml

html:	xml
	for i in ${LANGUAGE} ; do  \
	saxon  driver.xml.compiled epidoc-html.xsl  \
	 lang=$$i \
	 doclang=$$i \
	 documentationLanguage=$$i; done 
	rm driver.xml.compiled

compiled:
	curl -s -o odd2odd.xsl ${P5ROOT}/tei/stylesheet/odds2/odd2odd.xsl
	curl -s -o p5subset.xml ${P5ROOT}/tei/odd/p5subset.xml
	xmllint --xinclude driver.xml | \
	saxon  -o:driver.xml.compiled - \
		odd2odd.xsl \
	    TEIC=true \
	    localsource=`pwd`/p5subset.xml 

xml: compiled
	saxon -o:tei-epidoc-Guidelines.xml  \
	driver.xml.compiled ${P5ROOT}/tei/stylesheet/odds2/odd2lite.xsl	  \
	    autoToc=true \
	    lang=${LANGUAGE} \
	    doclang=${LANGUAGE} \
	    documentationLanguage=${LANGUAGE} 

pdftex: xml
	saxon -o:tei-epidoc.tex \
	tei-epidoc-Guidelines.xml \
	epidoc-latex.xsl lang=${LANGUAGE} doclang=${LANGUAGE} documentationLanguage=${LANGUAGE} 
	perl -p -i -e 's+http://www.tei-c.org/release/doc/tei-p5-doc/en/html/Images/++' tei-epidoc.tex

pdf: pdftex
	-xelatex tei-epidoc
	-xelatex tei-epidoc
	makeindex -s tei-epidoc.ist tei-epidoc
	-xelatex tei-epidoc
	-xelatex tei-epidoc
	mv tei-epidoc.pdf referenceManual.pdf

examples-schema: compiled
	saxon -o:exnames.xml driver.xml.compiled  makeexnames.xsl 
	saxon -o:tei-epidoc-ex.odd driver.xml.compiled odd2exodd.xsl TEIC=true
	saxon  tei-epidoc-ex.odd ${P5ROOT}/tei/stylesheet/odds2/odd2relax.xsl outputDir=. TEIC=true

validate: 
	xmllint --encode "utf-8" --noent --xinclude driver.xml > tei-epidoc-full.xml
	onvdl epidoc.nvdl tei-epidoc-full.xml

clean:
	-rm driver.xml.compiled exnames.xml tei-epidoc-ex.odd tei-epidoc-examples.rng p5subset.xml tei-epidoc-Guidelines.xml
	-rm odd2odd.xsl p5subset.xml tei-epidoc-full.xml subset.xsl tei-epidoc_en.html
