<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="plus">
  <xsl:if test="not(ancestor::brackets)">
    <!-- ellipsis is incompatible with papyrological/Vindolanda notation -->
    <!-- <xsl:if test="name(preceding-sibling::node()[1])!='dot' and name(following-sibling::node()[1])='dot' and name(following-sibling::node()[2])='dot' and name(following-sibling::node()[3])!='dot'"><gap reason="ellipsis" /></xsl:if> -->
      <xsl:element name="gap">
        <xsl:attribute name="reason">illegible</xsl:attribute>
        <xsl:attribute name="extent">1</xsl:attribute>
        <xsl:attribute name="unit">character</xsl:attribute>
      </xsl:element>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
