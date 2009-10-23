<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1" xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:output method="html" indent="yes" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-14                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-14                    		 -->
<!-- PURPOSE:   Common templates												 					 -->
<!-- CREATED FOR:  Epidoc demo                          					 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->


<xsl:template name="toc">
	<p>
		<a href="index.html">TOC</a>
		<xsl:text> | </xsl:text>
		<a href="persName.html">Personal Names</a>
		<xsl:text> | </xsl:text>
		<a href="placeName.html">Place Names</a>
		<xsl:text> | </xsl:text>
		<a href="numerals.html">Numerals</a>
	</p>
	<br />
</xsl:template>


</xsl:stylesheet>

