<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



<xsl:template match="doubleAngleBrackets">
  <app>
    <rdg>
      <del>
        <xsl:element name="gap">
          <xsl:attribute name="reason">lost</xsl:attribute>
          <xsl:attribute name="extent"><xsl:value-of select="string-length(normalize-space(text()))"/></xsl:attribute>
          <xsl:attribute name="unit">character</xsl:attribute>
        </xsl:element>
      </del>
    </rdg>
    <rdg>
      <add place="overstrike"><xsl:apply-templates/></add>
    </rdg>
  </app>
</xsl:template>
</xsl:stylesheet>
