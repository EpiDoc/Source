<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="dot">
    <xsl:choose>
          <xsl:when test="not(ancestor::brackets) and not(parent::div)">
            <!-- ellipsis is incompatible with papyrological/Vindolanda notation -->
            <!-- <xsl:if test="name(preceding-sibling::node()[1])!='dot' and name(following-sibling::node()[1])='dot' and name(following-sibling::node()[2])='dot' and name(following-sibling::node()[3])!='dot'"><gap reason="ellipsis" /></xsl:if> -->
              <xsl:element name="gap">
                <xsl:attribute name="reason">illegible</xsl:attribute>
                <xsl:attribute name="extent">1</xsl:attribute>
                <xsl:attribute name="unit">character</xsl:attribute>
              </xsl:element>
          </xsl:when>
          <xsl:when test="parent::div">.</xsl:when>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
