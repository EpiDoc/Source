<xsl:stylesheet
  exclude-result-prefixes="xlink dbk rng tei teix xhtml a edate estr html pantor xd xs xsl"
  extension-element-prefixes="exsl estr edate" 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="TEIC">false</xsl:param>

<xsl:output method="xml" indent="yes"/>

<xsl:key name="SPEC" match="tei:schemaSpec|tei:specGrp" use="1"/>

<xsl:template match="*">
 <xsl:copy>
  <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="text()|@*|comment()|processing-instruction()">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="tei:text">
 <text xmlns="http://www.tei-c.org/ns/1.0">
  <body xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:apply-templates select="key('SPEC',1)"/>
  </body>
 </text>
</xsl:template>

<xsl:template match="tei:schemaSpec/@ident">
  <xsl:attribute name="ident">
    <xsl:value-of select="."/>
    <xsl:text>-examples</xsl:text>
  </xsl:attribute>
</xsl:template>

<xsl:template match="tei:schemaSpec/@start">
  <xsl:attribute name="start">
    <xsl:text>egXML</xsl:text>
  </xsl:attribute>
</xsl:template>

<xsl:template match="tei:schemaSpec/@ns"/>

<xsl:template match="tei:schemaSpec">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="ns">
      <xsl:text>http://www.tei-c.org/ns/Examples</xsl:text>
    </xsl:attribute>
  <xsl:apply-templates select="*|processing-instruction()|comment()|text()"/>  
    <xsl:if test="$TEIC='true'">
      <elementSpec ident="egXML" module="tagdocs"
		   xmlns="http://www.tei-c.org/ns/1.0"
		   ns="http://www.tei-c.org/ns/Examples">
	<content>
	  <group xmlns="http://relaxng.org/ns/structure/1.0">
	    <zeroOrMore >
	      <choice>
		<xsl:copy-of
		    select="document('exnames.xml')/rng:choice/rng:ref"/>
	      </choice>
	    </zeroOrMore>
	  </group>
	</content>
	<attList>
	  <attDef ident="rend">
	    <datatype>
	      <text xmlns="http://relaxng.org/ns/structure/1.0"/>
	    </datatype>
	  </attDef>
	</attList>
      </elementSpec>
    </xsl:if>
</xsl:copy>
</xsl:template>
</xsl:stylesheet>


