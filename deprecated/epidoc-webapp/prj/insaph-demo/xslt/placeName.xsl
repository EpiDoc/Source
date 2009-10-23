<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1" xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:output method="html" indent="yes" />
<xsl:strip-space elements="group w" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-10                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-10                    		 -->
<!-- PURPOSE:   Step 3/3 Creates index of place names		 					 -->
<!-- CREATED FOR:  Epidoc demo                          					 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:include href="toc.xsl" />

<xsl:template match="/">
<html>
	<head>
    <title>
      <xsl:text>Index of place names</xsl:text>
    </title>
<style type="text/css">
.greek { font-family: "Arial Unicode MS","Galilee Unicode Gk", "New Athena Unicode", "Athena Unicode", "Palatino Linotype", "Titus Cyberbit Basic", "Cardo", "Vusillus Old Face", "Alphabetum", "Galatia SIL", "Code 2000", "GentiumAlt", "Gentium", "Minion Pro", "GeorgiaGreek", "Vusillus Old Face Italic", "Everson Mono", "Aristarcoj", "Porson", "Legendum", "Aisa Unicode", "Hindsight Unicode", "Caslon",  "Lucida Grande", "Verdana", "Tahoma" ; }
.indexrow {border-bottom: solid silver thin;}
</style>
	</head>
	<body>
		<xsl:call-template name="toc" />

		<h2>
			<xsl:text>Index of place names</xsl:text>
		</h2>
		
		
		<table>
	   	<xsl:for-each select=".//div">
	   		<xsl:sort select="head/@letter" />
		   		<xsl:sort select="head/@id" />
					<tr>
						
						<td valign="top" class="indexrow">
							<b>
								<xsl:value-of select="head" />
							</b>
						</td>
		    		<td valign="top" class="indexrow">
		    			<table>
								<xsl:for-each select="word">
									<tr>
										<td valign="top">
						    	    <a href="{epidoc}.html">
						    	   	  <xsl:value-of select="epidoc" />
				<!--
						    	   	  <xsl:text> Line: </xsl:text>
						    	   	  <xsl:value-of select="line" />
				-->
						    	    </a>		
						    		</td>
						      	<td valign="top">
											<xsl:if test="string(type)">
							    			<xsl:text>(</xsl:text>
							    				<xsl:value-of select="type" />
							    			<xsl:text>)</xsl:text>
											</xsl:if>
				    				</td>
				    			</tr>
								</xsl:for-each>
							</table>
		      	</td>
		    	</tr>
	  	</xsl:for-each>
		</table>
  </body>
</html>
</xsl:template>

</xsl:stylesheet>

