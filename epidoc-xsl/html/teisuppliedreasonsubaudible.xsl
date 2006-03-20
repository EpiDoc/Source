<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:supplied[@reason='subaudible']">(<abbr expan="scilicet">scil.</abbr> <xsl:apply-templates />)</xsl:template>
</xsl:stylesheet>
