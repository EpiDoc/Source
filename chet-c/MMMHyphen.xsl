<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="hyphen">
  <xsl:if test="not(ancestor::brackets)">
    <xsl:if test="name(preceding-sibling::node()[1])!='hyphen'"><gap reason="lost" extent="?" unit="line"/></xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
