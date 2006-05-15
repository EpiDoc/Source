<?xml version="1.0" encoding="UTF-8"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <axsl:template match="fileDesc">
        <axsl:variable name="iaph2edr-edition-prefix"><axsl:apply-templates select="titleStmt/editor"/>
        in
        <axsl:apply-templates select="editionStmt"/>,
        <axsl:apply-templates select="publicationStmt"/>, 
        http://insaph.kcl.ac.uk/, 
        no. <axsl:call-template name="unpadID">
            <axsl:with-param name="input"><axsl:value-of select="/TEI.2/@id"/></axsl:with-param>
        </axsl:call-template></axsl:variable>
        <axsl:value-of select="normalize-space($iaph2edr-edition-prefix)"/>
        
    </axsl:template>
    
    <axsl:template match="editor">
        <axsl:value-of select="."/>
    </axsl:template>
    
    <axsl:template match="editionStmt">
        <axsl:value-of select="edition/title[@type='main']"/>
    </axsl:template>
    
    <axsl:template match="publicationStmt">
        <axsl:value-of select="date"/>
    </axsl:template>
    
    <axsl:template name="unpadID">
        <axsl:param name="input"/>
        <axsl:call-template name="popleadingzero">
            <axsl:with-param name="input"><axsl:value-of select="substring-after($input, 'iAph')"/></axsl:with-param>
        </axsl:call-template>
    </axsl:template>
    
    <axsl:template name="popleadingzero">
        <axsl:param name="input"/>
        <axsl:choose>
            <axsl:when test="starts-with($input, '0')">
                <axsl:call-template name="popleadingzero">
                    <axsl:with-param name="input">
                        <axsl:value-of select="substring-after($input, '0')" />
                    </axsl:with-param>
                </axsl:call-template>
            </axsl:when>
            <axsl:otherwise><axsl:value-of select="$input"/></axsl:otherwise>
        </axsl:choose>
    </axsl:template>
</axsl:stylesheet>
