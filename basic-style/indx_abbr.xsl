<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />

  <!-- variables to control processing -->
  <!-- variables to control processing -->
  <xsl:variable name="lineInterval">3</xsl:variable>
    <!-- controls line numbering: a number will be printed every $lineInterval lines -->
  <xsl:variable name="tabWidth">2</xsl:variable>
    <!-- number of spaces used for tab stops in indenting output -->
  <xsl:variable name="enumerateLimitHyphen">5</xsl:variable>
  <xsl:variable name="enumerateLimitDot">5</xsl:variable>
  <xsl:variable name="cssPath">../style/sb.css</xsl:variable>
   
  <!-- ***************************************************************************************************************** -->
  <!-- *** ROOT TEMPLATE *********************************************************************************************** -->
  <!-- ***************************************************************************************************************** -->
  <xsl:template match = "/">
    <html>
      <head><xsl:text>
  </xsl:text><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><xsl:text>
  </xsl:text><xsl:element name="title">
          <xsl:call-template name="outputLangAttributes"/>
          <xsl:value-of select="TEI.2/teiHeader/fileDesc/titleStmt/title"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$cssPath"/></xsl:attribute>
        </xsl:element>
      </head>
			<body>
      <xsl:text>

  </xsl:text>
        <xsl:element name="div">
          <h1>Documents analyzed for these indices:</h1>
          <ul>
            <xsl:for-each select="//TEI.2">
              <li><xsl:value-of select="./@id"/>:</li>
            </xsl:for-each>
          </ul>
        </xsl:element>
        <xsl:apply-templates select="//div[@type='edition']"/>
        <xsl:element name="div">
          <h1>Abbreviations:</h1>
          <table>
            <tr>
              <td>abbrev</td>
              <td>expan</td>
              <td>documents</td>
              <td>context</td>
            </tr>
            <xsl:for-each select="//abbr">
              <xsl:sort select="text()"/>
              <xsl:sort select="@expan"/>
              <xsl:sort select="ancestor::TEI.2/@id"/>
              <tr>
                <td><xsl:value-of select="translate(text(),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></td>
                <td><xsl:value-of select="@expan"/></td>
                <td><xsl:value-of select="ancestor::TEI.2/@id"/></td>
                <xsl:variable name="prevLBID" select="generate-id(preceding::lb[1])"/>
                <xsl:variable name="follLBID" select="generate-id(following::lb[1])"/>
                <td><xsl:apply-templates select="//node()[generate-id(following::node())=$follLBID]"/></td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:element>
			</body>
		</html>
	</xsl:template>

  <!-- templates that match specific tag-attribute combinations in the source -->	
  <xsl:include href="es_ab.xsl"/>
  <xsl:include href="sb_abbr.xsl"/>
  <xsl:include href="sb_app.xsl"/>
  <xsl:include href="sb_div_bibliography.xsl"/>
  <xsl:include href="sb_div_description.xsl"/>
  <xsl:include href="sb_div_edition.xsl"/>  
  <xsl:include href="es_div_history.xsl"/>
  <xsl:include href="es_div_metadata.xsl"/>
  <xsl:include href="sb_div_translation.xsl"/>
  <xsl:include href="es_figure.xsl"/>
  <xsl:include href="es_foreign.xsl"/>
  <xsl:include href="es_gap.xsl"/>
  <xsl:include href="es_head.xsl"/>
  <xsl:include href="es_hi.xsl"/>
  <xsl:include href="es_item.xsl"/>
  <xsl:include href="sb_lb.xsl"/>
  <xsl:include href="es_list.xsl"/>
  <xsl:include href="sb_listBibl.xsl"/>
  <xsl:include href="sb_mark.xsl"/>
  <xsl:include href="es_p.xsl"/>
  <xsl:include href="es_ptr.xsl"/>
  <xsl:include href="es_supplied.xsl"/>
  <xsl:include href="es_textNode.xsl"/>
  <xsl:include href="es_title.xsl"/>
	
  <!-- utility templates -->
  <xsl:include href="es_util_outputID.xsl"/>
  <xsl:include href="es_util_outputLang.xsl"/>
  <xsl:include href="es_util_utilIndent.xsl"/>

</xsl:stylesheet>
