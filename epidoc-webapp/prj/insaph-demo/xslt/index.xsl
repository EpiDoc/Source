<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1" xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:output method="html" indent="yes" />
<xsl:strip-space elements="group w" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-09                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-09                    		 -->
<!-- PURPOSE:   Index of inscriptions in the folder							   -->
<!-- CREATED FOR:  Epidoc demo                       							 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:include href="toc.xsl" />

<xsl:template match="/">
<html>
	<head>
    <title>
      <xsl:text>Index of Inscriptions</xsl:text>
    </title>
<style type="text/css">
.greek { font-family: "Arial Unicode MS","Galilee Unicode Gk", "New Athena Unicode", "Athena Unicode", "Palatino Linotype", "Titus Cyberbit Basic", "Cardo", "Vusillus Old Face", "Alphabetum", "Galatia SIL", "Code 2000", "GentiumAlt", "Gentium", "Minion Pro", "GeorgiaGreek", "Vusillus Old Face Italic", "Everson Mono", "Aristarcoj", "Porson", "Legendum", "Aisa Unicode", "Hindsight Unicode", "Caslon",  "Lucida Grande", "Verdana", "Tahoma" ; }
</style>
	</head>
	<body>
		<xsl:call-template name="toc" />

		<h2>
			<xsl:text>List of available inscriptions</xsl:text>
		</h2>
		<table>
	   	<xsl:for-each select=".//dir:file">
	    	  <xsl:sort select="@name" order="ascending" />
	    	  <xsl:variable name="linkedfilename">
						<xsl:value-of select="substring-before(@name, '.xml')" />
	  			</xsl:variable>
	  				
	    	<tr>
	      	<td>
	    	   <a href="{$linkedfilename}.html">
	    	   	 <xsl:value-of select="$linkedfilename" />
	    	   	 <xsl:text>: </xsl:text>
	    	     <xsl:value-of select=".//title" />
	    	   </a>		
	      	</td>
	    	</tr>
	  	</xsl:for-each>
		</table>
  </body>
</html>
</xsl:template>

</xsl:stylesheet>

