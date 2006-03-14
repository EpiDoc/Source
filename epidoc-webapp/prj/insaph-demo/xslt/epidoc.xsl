<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1">

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
<!-- PURPOSE:   Stand alone epidoc stylesheet  									   -->
<!-- CREATED FOR:  Epidoc demo                           							 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:include href="toc.xsl" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--     								VARIABLES                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --><xsl:variable name="imgroot">
	<xsl:text>../images/</xsl:text>
</xsl:variable>
<xsl:variable name="photoimgswitch" select="blah" />
<xsl:variable name="linkroot" select="deblah" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--     								TEI.2                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<xsl:template match="TEI.2">
<html>
	<head>
    <title>
      <xsl:text>Epidoc outout</xsl:text>
      <xsl:if test="teiHeader/fileDesc/titleStmt/title">
               <xsl:text>: </xsl:text>
         <xsl:value-of select="teiHeader/fileDesc/titleStmt/title" />
      </xsl:if>  
    </title>
<style type="text/css">
.greek { font-family: "Arial Unicode MS","Galilee Unicode Gk", "New Athena Unicode", "Athena Unicode", "Palatino Linotype", "Titus Cyberbit Basic", "Cardo", "Vusillus Old Face", "Alphabetum", "Galatia SIL", "Code 2000", "GentiumAlt", "Gentium", "Minion Pro", "GeorgiaGreek", "Vusillus Old Face Italic", "Everson Mono", "Aristarcoj", "Porson", "Legendum", "Aisa Unicode", "Hindsight Unicode", "Caslon",  "Lucida Grande", "Verdana", "Tahoma" ; }
</style>
	</head>
	<body>
		<xsl:call-template name="toc" />
		
    <h1 class="content">
       <xsl:apply-templates select="/TEI.2/teiHeader/fileDesc/titleStmt/title[1]" />
       <xsl:if test="/TEI.2/teiHeader/fileDesc/titleStmt/title[@type='sub']">
         <xsl:text>: </xsl:text>
         <xsl:apply-templates select="/TEI.2/teiHeader/fileDesc/titleStmt/title[@type='sub']" mode="pagehead" />
       </xsl:if> 
       
       <!-- START TEST FOR AUTHOR ETC. -->
       <xsl:if test="/TEI.2/teiHeader/fileDesc/titleStmt/author or /TEI.2/teiHeader/fileDesc/titleStmt/editor[not(starts-with(., 'Charlotte M. Rouech'))] or /TEI.2/teiHeader/fileDesc/titleStmt/author">
       <xsl:text>. </xsl:text>

       <xsl:text>(</xsl:text>
       <xsl:apply-templates select="/TEI.2/teiHeader/fileDesc/titleStmt/*[self::author|self::editor|self::respStmt]" mode="pagehead" />
       <xsl:text>)</xsl:text>
       </xsl:if> 

       <!-- END TEST FOR AUTHOR ETC. -->
    </h1>
		<xsl:apply-templates />
  </body>
</html>
</xsl:template>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--                    HEADER                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:template match="teiHeader">
</xsl:template>

<!--
<xsl:template match="titleStmt">
  <xsl:apply-templates />
</xsl:template>
-->

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--                    MAIN BODY                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:template match="body">
<xsl:choose>
	<xsl:when test="ancestor::TEI.2[@rend='toconly']">
		<p class="content"><xsl:apply-templates /></p>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="div"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--                    DIVS                            -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:template match="div">
 <xsl:choose>
  <xsl:when test="@type='metadata' and (@n='category-of-text' or @n='category-of-monument')">
    <!-- Removes categoy-text and category-monument -->    
  </xsl:when>
  <xsl:when test="@type='metadata' and (@n='photographs' or @n='transcriptions')">
    <!-- Removes image references -->    
  </xsl:when>
  <xsl:when test="@type='edition' and @n='text'">
	  <table border="0" cellspacing="0" cellpadding="0" width="90%">
      <xsl:apply-templates />
  	</table>
  </xsl:when>
  <xsl:otherwise>
    <div>
      <xsl:apply-templates />
    </div>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="div/head">
  <h3 class="content">
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="div/head" mode="count">
</xsl:template>



<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--                    CHUNK LEVEL                            -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:template match="p">
  <p class="content"><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="p" mode="multipara">
  <p class="content"><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="div/head" mode="multipara">
</xsl:template>

<xsl:template match="ab">
<xsl:choose>
<xsl:when test="ancestor::div[@type='edition' and @n='text']">
  <xsl:variable name="curr-ab" select="generate-id(self::ab)"/>
	<xsl:choose>
		<xsl:when test="descendant::cb[@rend!='block']">
			<xsl:for-each select=".//cb[@rend!='block']">
		    <xsl:variable name="cur-cb" select="generate-id(self::cb)"/>
				<tr>
					<td colspan="2" class="tableeven">
				  	<xsl:value-of select="@n" />
				  </td>
				</tr>
			  <xsl:for-each select="../lb[generate-id(preceding::cb[@rend!='block'][1])=$cur-cb]">
					<tr>
						<xsl:if test="ancestor::div[@lang='grc']">
							<xsl:attribute name="class">
								<xsl:text>greek</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<td style="width: 4em;">
							<xsl:variable name="alpha">
      					<xsl:if test="ancestor::div[descendant::cb[@rend='unit']]">
      						<xsl:if test="preceding::cb[@rend='unit'][1]">
      						  <xsl:value-of select="preceding::cb[@rend='unit'][1]/@n" />
      						</xsl:if>
      					</xsl:if>
              </xsl:variable>
							<xsl:variable name="roman">
      					<xsl:if test="ancestor::div[descendant::cb[@rend='fragment']]">
      						<xsl:if test="preceding::cb[@rend!='block'][1][@rend='fragment']">
      						  <xsl:value-of select="preceding::cb[@rend!='block'][1]/@n" />
      						</xsl:if>
      					</xsl:if>
              </xsl:variable>
							<xsl:variable name="line" select="preceding::lb[1]/@n">
              </xsl:variable>
							<a name="{$alpha}{$roman}{$line}"></a>
  							<xsl:if test="@n mod 5 = 0 and not(@n='0')">
  								<xsl:value-of select="@n"/>
  							</xsl:if>
  							&#xa0;							
						</td>
						<td>
					    <xsl:variable name="p-lb" select="generate-id(self::lb)"/>
							<xsl:for-each select="following::*[not(self::lb)][not(descendant::lb)][generate-id(ancestor::ab)=$curr-ab]|following::text()[generate-id(ancestor::ab)=$curr-ab]">
								<xsl:if test="generate-id(preceding::lb[1])=$p-lb and not(ancestor::*[not(descendant::lb)][generate-id(preceding::lb[1])=$p-lb])">
									<xsl:apply-templates select="." />
								</xsl:if>
							</xsl:for-each>
							<xsl:if test="following::lb[1][@type='worddiv']">
								<xsl:text>-</xsl:text>
						  </xsl:if>  	
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:for-each select=".//lb">
				<tr>
					<xsl:if test="ancestor::div[@lang='grc']">
						<xsl:attribute name="class">
							<xsl:text>greek</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<td style="width: 4em;">
						<xsl:variable name="alpha">
    					<xsl:if test="ancestor::div[descendant::cb[@rend='unit']]">
    						<xsl:if test="preceding::cb[@rend='unit'][1]">
    						  <xsl:value-of select="preceding::cb[@rend='unit'][1]/@n" />
    						</xsl:if>
    					</xsl:if>
            </xsl:variable>
						<xsl:variable name="roman">
    					<xsl:if test="ancestor::div[descendant::cb[@rend='fragment']]">
    						<xsl:if test="preceding::cb[@rend!='block'][1][@rend='fragment']">
    						  <xsl:value-of select="preceding::cb[@rend!='block'][1]/@n" />
    						</xsl:if>
    					</xsl:if>
            </xsl:variable>
						<xsl:variable name="line" select="@n">
            </xsl:variable>
							<a name="{$alpha}{$roman}{$line}"></a>
							<xsl:if test="@n mod 5 = 0 and not(@n='0')">
								<xsl:value-of select="@n"/>
							</xsl:if>&#xa0;
					</td>
					<td>
				    <xsl:variable name="p-lb" select="generate-id(self::lb)"/>
						<xsl:for-each select="following::*[not(self::lb)][not(descendant::lb)][generate-id(ancestor::ab)=$curr-ab]|following::text()[generate-id(ancestor::ab)=$curr-ab]">
							<xsl:if test="generate-id(preceding::lb[1])=$p-lb and not(ancestor::*[not(descendant::lb)][generate-id(preceding::lb[1])=$p-lb])">
								<xsl:apply-templates select="." />
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="following::lb[1][@type='worddiv']">
							<xsl:text>-</xsl:text>
					  </xsl:if>  	
					</td>
				</tr>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:when>
<xsl:otherwise>
  <p class="content"><xsl:apply-templates /></p>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="ab" mode="multipara">
  <p class="content"><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="cb[@rend!='block'][not(ancestor::ab)]">
	<xsl:if test="ancestor::div[@type='edition' and @n='text']">
		<tr>
			<td colspan="2" class="tableeven">
		  	<xsl:value-of select="@n" />
		  </td>
		</tr>
	</xsl:if>
</xsl:template>

<xsl:template match="lg">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="l">
  <tr>
		<xsl:if test="ancestor::div[@lang='grc']">
			<xsl:attribute name="class">
				<xsl:text>greek</xsl:text>
			</xsl:attribute>
		</xsl:if>
		<td style="width: 4em;">
			<xsl:choose>
				<xsl:when test="@n mod 5 = 0 and not(@n='0')">
					<xsl:value-of select="@n"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
  	</td>
		<td>
		  <xsl:if test="local-name(preceding-sibling::*[1])='lb'">
		  	<xsl:if test="preceding-sibling::lb[1][@n mod 5 = 0 and not(@n='0')]">
					<xsl:text>(</xsl:text><xsl:value-of select="preceding-sibling::lb[1]/@n" /><xsl:text>) </xsl:text>
				</xsl:if>
		  </xsl:if>  										
			<xsl:if test="@met='pentameter'">
				<xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="local-name(following-sibling::*[1])='lb'">
				<xsl:text> |</xsl:text>
			</xsl:if>
		</td>
	</tr>
</xsl:template>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--                    PHRASE LEVEL                           -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<xsl:template match="lb">
	<xsl:choose>
		<xsl:when test="ancestor::div[@type='edition' and @n='text']">
			<xsl:choose>
				<xsl:when test="ancestor::ab">
<!--
					<xsl:if test="@type='worddiv'">
						<xsl:text>-</xsl:text>
				  </xsl:if>  	
-->
				</xsl:when>
				<xsl:when test="ancestor::l">
					<xsl:choose>
						<xsl:when test="ancestor::w">
							<xsl:text>|</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> | </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				  <xsl:if test="@n mod 5 = 0 and not(@n='0')">
						<xsl:choose>
							<xsl:when test="ancestor::w">
								<xsl:text>(</xsl:text><xsl:value-of select="@n" /><xsl:text>)</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>(</xsl:text><xsl:value-of select="@n" /><xsl:text>) </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
				  </xsl:if>  										
				</xsl:when>
				<xsl:when test="ancestor::lg and not(ancestor::l)">
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>|</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>




<!--    ***********************************************       -->
<!--    *************   FIGURES  **********************       -->
<!--    ***********************************************       -->

<xsl:template match="figure">
<!-- =========  Find info for publication images =========== -->
<!-- e.g. abc.gif -->

<xsl:choose>
  <xsl:when test="parent::div[@n='photographs']">
  <!-- model for PHOTOS starts -->
   <td class="content" bgcolor="#eeeeee">
     <div align="center">
       <a class="content" href="{$imgroot}full/{@n}.jpg" alt="Click for full image" title="Click for full image" target="_blank">
       <img>   
           <xsl:attribute name="src"><xsl:value-of select="$imgroot" />thumb/<xsl:value-of select="@n" />.jpg</xsl:attribute>
           <xsl:attribute name="alt">Click here for full image in popup window</xsl:attribute>
           <xsl:attribute name="border">0</xsl:attribute>
       </img>
       </a>
     </div>
  </td>
  <!-- model for PHOTOS ends -->
  </xsl:when>
  <xsl:otherwise>
  <!-- model for REPRESENTATIONS starts -->
  <td class="content" bgcolor="#eeeeee" width="120">
     <div align="center">
            <a class="content" href="{$imgroot}full/{@n}.jpg" alt="Click for full image" title="Click for full image" target="_blank">
            <img>   
              <xsl:attribute name="src"><xsl:value-of select="$imgroot" />thumb/<xsl:value-of select="@n" />.jpg</xsl:attribute>
              <xsl:attribute name="alt">Click here for full image in popup window</xsl:attribute>
              <xsl:attribute name="border">0</xsl:attribute>
            </img>
            </a>
     </div>
  </td>
  <!-- model for REPRESENTATIONS ends -->
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="figure" mode="figure-caption">
 <xsl:choose>
  <xsl:when test="parent::div[@n='photographs']">
		 <xsl:apply-templates />
  </xsl:when>
  <xsl:otherwise>
    <td class="caption" bgcolor="#eeeeee" width="120" align="center">
      <xsl:apply-templates />
    </td>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--    ***********************************************       -->
<!--    *************   GREEK  **********************       -->
<!--    ***********************************************       -->

<xsl:template match="foreign[@lang='grc']|term[@lang='grc']">
  <span class="greek">
   <xsl:apply-templates />
  </span>
</xsl:template>


<xsl:template match="*[@lang='lat']">
<xsl:choose>
<xsl:when test="ancestor-or-self::div[@type='edition' and @n='text']">
   <xsl:apply-templates />
</xsl:when>
<xsl:otherwise>
   <i><xsl:apply-templates /></i>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!--    ***********************************************       -->
<!--    *************   SEARCHABLES  **********************       -->
<!--    ***********************************************       -->

<xsl:template match="persName">
 <a name="{generate-id()}"></a>
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
  <xsl:apply-templates />
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="placeName">
 <a name="{generate-id()}"></a>
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
  <xsl:apply-templates />
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="w">
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
  <xsl:apply-templates />
  <xsl:if test="preceding::cb[@rend!='block']">
  	<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="rs">
 <a name="{generate-id()}"></a>
	<xsl:apply-templates />
</xsl:template>


<!--    ***********************************************       -->
<!--    *************   LINKS  ************************       -->
<!--    ***********************************************       -->

<xsl:template match="xref">
 <a name="{generate-id()}"></a>
  <xsl:choose>
<!--Narrative-->
    <xsl:when test="@type='eAla-text'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:when test="@type='plan'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:when test="@type='bishops'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:when test="@type='governors'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:when test="@type='local-officials'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--    ***********************************************       -->
<!--    *************   BIBLIO  ************************       -->
<!--    ***********************************************       -->

<xsl:template match="bibl">
 <a name="{generate-id()}"></a>
  <xsl:choose>
    <xsl:when test="@type='hbi'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:when test="@type='abbrev'">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="bibl/title">
	<xsl:choose>
		<xsl:when test="@level='m' or @level='j'">
		  <i><xsl:apply-templates /></i>
		</xsl:when>
		<xsl:when test="@level='a' or @level='u'">
			<xsl:text>'</xsl:text><xsl:apply-templates /><xsl:text>'</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="author[ancestor::bibl[@rend='primary']][not(preceding-sibling::author)]">
  <xsl:text>&#8226;</xsl:text>
  <xsl:apply-templates />
</xsl:template>

<!--    ***********************************************       -->
<!--    *************   EDITORIAL AMENDMENTS  **********************       -->
<!--    ***********************************************       -->


<xsl:template match="unclear[@reason='damage']">
  <xsl:call-template name="subpunct">
    <xsl:with-param name="unc-len" select="string-length(.)"/>
    <xsl:with-param name="abs-len" select="string-length(.)+1"/>
  </xsl:call-template>
<!--
  <span class="epidoc-unclear">
    <xsl:apply-templates />
  </span>
  -->
</xsl:template>

<xsl:template name="subpunct">
  <xsl:param name="abs-len"/>
  <xsl:param name="unc-len"/>
  <xsl:if test="$unc-len!=0">
    <xsl:value-of select="substring(., number($abs-len - $unc-len),1)"/>
    <xsl:text>&#x0323;</xsl:text>
    <xsl:call-template name="subpunct">
      <xsl:with-param name="unc-len" select="$unc-len - 1"/>
      <xsl:with-param name="abs-len" select="string-length(.)+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="gap[@reason='omitted']">
  <xsl:text>(---)</xsl:text>
</xsl:template>

<xsl:template match="gap[@reason='ellipsis']">
  <xsl:text> ... </xsl:text>
</xsl:template>

<xsl:template match="gap">
	<xsl:if test="@reason='lost' and not(@dim='top')">
		<xsl:choose>
<!--1.-->
			<xsl:when test="preceding-sibling::*[1][@reason='lost']">
        <xsl:if test="preceding-sibling::text() and preceding-sibling::*[1][following-sibling::text()]">
  	      <xsl:variable name="curr-prec" select="generate-id(preceding-sibling::text()[1])"/>
  		    <xsl:for-each select="preceding-sibling::*[1][@reason='lost']">
    			  <xsl:choose>
    			    <xsl:when test="generate-id(following-sibling::text()[1])=$curr-prec and not(following-sibling::text()[1]=' ')">
                <xsl:text>[</xsl:text>
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
			</xsl:when>
<!--2.-->
			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1][@reason='lost']]]">
			</xsl:when>
<!--3.-->
			<xsl:when test="preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']">
			</xsl:when>
<!--4.-->
			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]">

			</xsl:when>
<!--5.-->
			<xsl:when test="preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']">
			</xsl:when>
<!--6.-->
			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]">
			</xsl:when>
<!--7.-->

			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]]">
			</xsl:when>
<!--8.-->
			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1][@reason='lost']]]]">
			</xsl:when>
<!--9.-->
				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]]">
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="following-sibling::certainty[@target=current()/@id]">
		<xsl:text>?</xsl:text>
	</xsl:if>
  <xsl:choose>
    <!-- **** condition **** -->
    <xsl:when test="@extent and @unit='character'">
			<xsl:choose>
		    <xsl:when test="@extent='1'">
		      <xsl:apply-templates />
		      <xsl:text>.</xsl:text>
		    </xsl:when>
		    <xsl:when test="@extent='2'">
		      <xsl:apply-templates />
		      <xsl:text>..</xsl:text>
		    </xsl:when>
		    <xsl:when test="number(@extent)>3">
		      <xsl:apply-templates />
		      <xsl:text>... c. </xsl:text><xsl:value-of select="@extent"/><xsl:text> ...</xsl:text>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:text>...</xsl:text>
		      <xsl:apply-templates />
		    </xsl:otherwise>
			</xsl:choose>
    </xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@extent and @unit='cm'">
      <xsl:apply-templates />
      <xsl:text>... c. </xsl:text><xsl:value-of select="@extent"/><xsl:text> cm ...</xsl:text>
    </xsl:when>
    <!-- **** default **** -->
    <xsl:otherwise>
      <xsl:text>...</xsl:text>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
	<xsl:if test="@reason='lost' and not(@dim='bottom')">
		<xsl:choose>
<!-- 1. -->
			<xsl:when test="following-sibling::*[1][@reason='lost']">
        <xsl:if test="following-sibling::text() and following-sibling::*[1][preceding-sibling::text()]">
  	      <xsl:variable name="curr-foll" select="generate-id(following-sibling::text()[1])"/>
  		    <xsl:for-each select="following-sibling::*[1][@reason='lost']">
    			  <xsl:choose>
    			    <xsl:when test="generate-id(preceding-sibling::text()[1])=$curr-foll and not(preceding-sibling::text()[1]=' ')">
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
			</xsl:when>
<!-- 2. -->
			<xsl:when test="following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']">
			</xsl:when>
<!-- 3. -->
			<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1][@reason='lost']]]">
			</xsl:when>
<!-- 4. -->
			<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]">
			</xsl:when>
<!-- 5. -->
			<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1][@reason='lost']]]]">
			</xsl:when>
<!-- 6. -->
			<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]]">
			</xsl:when>
<!-- 7. -->
			<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]]">
			</xsl:when>
<!-- 8. -->
			<xsl:when test="following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']">
			</xsl:when>
<!-- 9. -->
			<xsl:when test="current()[not(following-sibling::*)][(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]">
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>]</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="expan">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="abbr">
	<xsl:apply-templates/>
	<xsl:if test="not(parent::expan) and not(following-sibling::supplied[@reason='abbreviation'])">
		<xsl:text>(?)</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="abbr//orig">
</xsl:template>

<xsl:template match="expan//orig">
</xsl:template>

<xsl:template match="cb[@rend='block']">
	<xsl:if test="not(ancestor::w)">
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:text>|</xsl:text>
	<xsl:if test="not(ancestor::w)">
		<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="num">
  <xsl:if test="@value &gt;= 1000">
    <xsl:text>&#x0375;</xsl:text>
  </xsl:if>
  <xsl:apply-templates />
  <xsl:if test="not(@value mod 1000 = 0)">
    <xsl:text>&#x00B4;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="note">
	<xsl:choose>
		<xsl:when test="ancestor::p">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="ancestor::l">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="ancestor::ab">
			<xsl:choose>
				<xsl:when test="@rend='italic'">
					<i><xsl:apply-templates /></i>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<tr><td>&#xa0;</td><td class="note"><xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text></td></tr>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!--
	<xsl:choose>
		<xsl:when test="parent::p">
			<xsl:choose>
				<xsl:when test="ancestor::ab">
					<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<p class="content"><xsl:apply-templates /></p>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
-->

<xsl:template match="space">
	<xsl:if test="following-sibling::certainty[@target=current()/@id]">
		<xsl:text>?</xsl:text>
	</xsl:if>
  <xsl:choose>
    <!-- **** condition **** -->
    <xsl:when test="@extent='1' and @unit='character'">
      <xsl:apply-templates /><i><sup><xsl:text>v.</xsl:text></sup></i>
    </xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@unit='line'">
      <xsl:apply-templates /><i><span class="smaller"><xsl:text>vacat</xsl:text></span></i>
    </xsl:when>
    <!-- **** default **** -->
    <xsl:otherwise>
      <xsl:apply-templates /><i><span class="smaller"><xsl:text>vac.</xsl:text></span></i>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sic">
  <xsl:choose>
    <!-- **** condition **** -->
    <xsl:when test="@n='superfluous'">
      <xsl:text>{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="@n='unintelligible'">
      <span style="text-transform: uppercase ;"><xsl:apply-templates /></span>
    </xsl:when>
    <xsl:when test="@corr and string(@corr)">
      <xsl:text>&lt;</xsl:text><xsl:value-of select="@corr" /><xsl:text>&gt;</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="corr">
  <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates />
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="supplied">
  <xsl:choose>
    <!-- **** condition **** -->
    <xsl:when test="@reason='lost'">
			<xsl:choose>
<!--1.    __|__
				 |		 |
				 x		 x
-->
			<xsl:when test="preceding-sibling::*[1][@reason='lost']">
        <xsl:if test="preceding-sibling::text() and preceding-sibling::*[1][following-sibling::text()]">
  	      <xsl:variable name="curr-prec" select="generate-id(preceding-sibling::text()[1])"/>
  		    <xsl:for-each select="preceding-sibling::*[1][@reason='lost']">
    			  <xsl:choose>
    			    <xsl:when test="generate-id(following-sibling::text()[1]) = $curr-prec and not(following-sibling::text()[1]=' ')">
                <xsl:text>[</xsl:text>
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
			</xsl:when>
<!--2.  	__|__
				 |	 __|__
				 x	|			|
				 		x		 
-->
				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1][@reason='lost']]]">
				</xsl:when>
<!--3.		__|__
			 __|__	 |
			|			|	 x
				 		x		 
-->
				<xsl:when test="preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']">
				</xsl:when>
<!--4.		____|____
			 __|__	 	 __|__
			|			|	 	|	 		|
				 		x		x 
-->
				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]">

				</xsl:when>
<!--5.		____|____
			 __|__	 	   |
			|		__|__	 	 x
				 |		 |
				 			 x 
-->
				<xsl:when test="preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']">
				</xsl:when>
<!--6.		____|____
			 __|__	 	 __|__
			|		__|__	|	 		|
				 |		 |x
				 			 x 
-->
				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]">
				</xsl:when>
<!--7.		______|______
			 __|__	 	 		 __|__
			|		__|__		__|__	  |
				 |		 | |     |
				 			 x x
-->

 				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]]">
				</xsl:when>


<!--8.		______|______
			   |  	 	 		 __|__
			 	 x    		__|__	  |
				  		   |     |
				 			   x
-->

 				<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1][@reason='lost']]]]">
				</xsl:when>



<!--9.		______|______
			 __|__	 	 		 __|__
			|		  |  		__|__	  |
				  	x    |     |
				 			   x
-->
  			<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]]">
				</xsl:when>


<!-- 10. -->
  			<xsl:when test="preceding-sibling::*[1][local-name()='lb'] and preceding-sibling::*[2][local-name()='supplied' and @reason='lost']">

  			  <xsl:variable name="curr-prec-txt" select="generate-id(preceding-sibling::text()[1])"/>
  		    <xsl:for-each select="preceding-sibling::*[1][local-name()='lb']">
    			  <xsl:choose>
    			    <xsl:when test="following-sibling::text() and generate-id(following-sibling::text()[1])=$curr-prec-txt and not(following-sibling::text()[1]=' ')">
                <xsl:text>[</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="lb-prec-txt" select="generate-id(preceding-sibling::text()[1])" />
                <xsl:for-each select="preceding-sibling::*[1][@reason='lost']">
                  <xsl:choose>
          			    <xsl:when test="following-sibling::text() and generate-id(following-sibling::text()[1])=$lb-prec-txt and not(following-sibling::text()[1]=' ')">
                      <xsl:text>[</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>

  				
				</xsl:when>


				<xsl:otherwise>
					<xsl:text>[</xsl:text>
				</xsl:otherwise>
			</xsl:choose>   	
    	<xsl:if test="@cert='uncertain'">
    		<xsl:text>?</xsl:text>
	  </xsl:if>
    	<xsl:apply-templates />
			<xsl:choose>
<!-- 1. -->
				<xsl:when test="following-sibling::*[1][@reason='lost']">
          <xsl:if test="following-sibling::text() and following-sibling::*[1][preceding-sibling::text()]">
    	      <xsl:variable name="curr-foll" select="generate-id(following-sibling::text()[1])"/>
    		    <xsl:for-each select="following-sibling::*[1][@reason='lost']">
      			  <xsl:choose>
      			    <xsl:when test="generate-id(preceding-sibling::text()[1]) = $curr-foll and not(preceding-sibling::text()[1]=' ')">
                  <xsl:text>]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
				</xsl:when>
<!-- 2. -->
				<xsl:when test="following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']">
				</xsl:when>
<!-- 3. -->
				<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1][@reason='lost']]]">
				</xsl:when>
<!-- 4. -->
				<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]">
				</xsl:when>
<!-- 5. -->
 				<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1][@reason='lost']]]]">
				</xsl:when>
<!-- 6. -->
				<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]]">
				</xsl:when>
<!-- 7. -->
 				<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]]">
				</xsl:when>
<!-- 8. -->
				<xsl:when test="following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']">
				</xsl:when>
<!-- 9. -->
				<xsl:when test="current()[not(following-sibling::*)][(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]">
				</xsl:when>
<!-- 10. -->
  			<xsl:when test="following-sibling::*[1][local-name()='lb'] and following-sibling::*[2][local-name()='supplied' and @reason='lost']">

  			  <xsl:variable name="curr-prec-txt" select="generate-id(following-sibling::text()[1])"/>
  		    <xsl:for-each select="following-sibling::*[1][local-name()='lb']">
    			  <xsl:choose>
    			    <xsl:when test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1])=$curr-prec-txt and not(preceding-sibling::text()[1]=' ')">
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="lb-prec-txt" select="generate-id(following-sibling::text()[1])" />
                <xsl:for-each select="following-sibling::*[1][@reason='lost']">
                  <xsl:choose>
          			    <xsl:when test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1])=$lb-prec-txt and not(preceding-sibling::text()[1]=' ')">
                      <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
				</xsl:when>

				<xsl:otherwise>
					<xsl:text>]</xsl:text>
				</xsl:otherwise>
			</xsl:choose>    	

      </xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@reason='omitted'"><xsl:text>&lt;</xsl:text>
     	<xsl:if test="@cert='uncertain'">
    		<xsl:text>?</xsl:text>
	  </xsl:if>
     <xsl:apply-templates />
    <xsl:text>&gt;</xsl:text></xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@reason='subaudible'"><xsl:text>(</xsl:text>
     	<xsl:if test="@cert='uncertain'">
    		<xsl:text>?</xsl:text>
	  </xsl:if>
     <xsl:apply-templates />
    <xsl:text>)</xsl:text></xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@reason='abbreviation'">
      <xsl:text>(</xsl:text>
     	<xsl:if test="@cert='uncertain'">
    		<xsl:text>?</xsl:text>
	  </xsl:if>
    <xsl:apply-templates />
    <xsl:text>)</xsl:text></xsl:when>
    <!-- **** condition **** -->
    <xsl:when test="@reason='explanation'"><xsl:text>(i.e. </xsl:text>
    	<xsl:if test="@cert='uncertain'">
    		<xsl:text>?</xsl:text>
	  </xsl:if>
      <xsl:apply-templates />
    <xsl:text>)</xsl:text></xsl:when>
    <!-- **** default **** -->
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*[lang='lat']">
   <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="mark">
   <xsl:apply-templates />
   <xsl:text> </xsl:text>
   <i><span class="smaller"><xsl:value-of select="@type" /></span></i>
   <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="add">
   <u><xsl:apply-templates /></u>
</xsl:template>

<xsl:template match="del">
   <u><xsl:apply-templates /></u>
</xsl:template>

<xsl:template match="seg[@rend='||']">
   <xsl:text> || </xsl:text><xsl:apply-templates /><xsl:text> || </xsl:text>
</xsl:template>

<xsl:template match="seg[@cert='uncertain']">
   <xsl:text>?</xsl:text><xsl:apply-templates />
</xsl:template>

<xsl:template match="rdg">
	<xsl:choose>
		<xsl:when test="@resp='earlier'">	
			<xsl:choose>
				<xsl:when test="preceding-sibling::rdg[@resp='autopsy']/gap[@reason='lost'] or following-sibling::rdg[@resp='autopsy']/gap[@reason='lost']">
					<xsl:text>[</xsl:text><u><xsl:apply-templates /></u><xsl:text>]</xsl:text>					
				</xsl:when>
				<xsl:when test="preceding-sibling::rdg[@resp='autopsy']/unclear[@reason='damage'] or following-sibling::rdg[@resp='autopsy']/unclear[@reason='damage']">
				  <span class="epidoc-unclear">
				  	<u><xsl:apply-templates /></u>
				  </span>
				</xsl:when>
				<xsl:otherwise>
					<u><xsl:apply-templates /></u>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@resp='autopsy'">
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>