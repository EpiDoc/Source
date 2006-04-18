<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:template match="*" mode="process-item-children">&lt;<xsl:value-of
        select="local-name(.)"/><xsl:for-each select="@*"><xsl:text> </xsl:text><xsl:value-of
            select="local-name(.)"/>="<xsl:value-of
                select="."/>"</xsl:for-each><xsl:choose><xsl:when test="count(./* | text()) = 0">
                    /&gt;</xsl:when><xsl:otherwise>&gt;<xsl:apply-templates
                        mode="process-item-children"/>&lt;/<xsl:value-of select="local-name(.)"/>&gt;</xsl:otherwise></xsl:choose></xsl:template>    
</xsl:stylesheet>
