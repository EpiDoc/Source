<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- epidoc-xmlcomment -->
    <!-- 2005-08-10: created by Tom Elliott -->
    
    <xsl:template match="comment()">
        <xsl:if test="$stripcomments='false'">
            <xsl:copy><xsl:apply-templates/></xsl:copy>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
