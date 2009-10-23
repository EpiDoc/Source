<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1" xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:output method="xml" indent="yes" encoding="UTF-8" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-10                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-10                    		 -->
<!-- PURPOSE:   Creates index of numerals		  									   -->
<!-- CREATED FOR:  Epidoc demo                       							 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:include href="toc.xsl" />


<xsl:key name="index" match="num" use="normalize-space(.)" />

<xsl:template match="/">
<html>
	<head>
    <title>
      <xsl:text>Index of numerals</xsl:text>
    </title>
		<style type="text/css">
		.greek { font-family: "Arial Unicode MS","Galilee Unicode Gk", "New Athena Unicode", "Athena Unicode", "Palatino Linotype", "Titus Cyberbit Basic", "Cardo", "Vusillus Old Face", "Alphabetum", "Galatia SIL", "Code 2000", "GentiumAlt", "Gentium", "Minion Pro", "GeorgiaGreek", "Vusillus Old Face Italic", "Everson Mono", "Aristarcoj", "Porson", "Legendum", "Aisa Unicode", "Hindsight Unicode", "Caslon",  "Lucida Grande", "Verdana", "Tahoma" ; }
		.indexrow {border-bottom: solid silver thin;}
		</style>
	</head>
	<body>
		<xsl:call-template name="toc" />

		<h2>
			<xsl:text>Index of numerals</xsl:text>
		</h2>
		
		
		<table>
	   	<xsl:for-each select="//num[generate-id()=generate-id(key('index', normalize-space(.))[1])]">
	   		<xsl:sort select="@value" data-type="number" />
					<tr>
						
						<td valign="top" class="indexrow">
							<b>
								<xsl:value-of select="normalize-space(.)" />
							</b>
						</td>
		    		<td valign="top" class="indexrow">
		    			<table>
		    				<xsl:for-each select="key('index', normalize-space(.))">
									<xsl:variable name="filename" select="substring-before(ancestor::dir:file/@name, '.xml')" />
									<tr>
										<td valign="top">
						    	    <a href="{$filename}.html">
						    	   	  <xsl:value-of select="$filename" />
						    	    </a>		
						    		</td>
						      	<td valign="top">
											<xsl:if test="string(@value)">
							    			<xsl:text>(</xsl:text>
							    				<xsl:value-of select="@value" />
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