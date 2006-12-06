<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns="http://www.w3.org/1999/XSL/TransformAlias" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"  version="1.0">
    
    <xsl:template name="substitutions">
        <xsl:choose>
            <xsl:when test="substitutions[@type='vdex']"><xsl:call-template name="substitutions-vdex"/></xsl:when>
            <xsl:otherwise><xsl:call-template name="substitutions-local"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="substitutions-local">
        <xsl:variable name="varname">
            <xsl:choose>
                <xsl:when test="destination"><xsl:value-of select="destination"/></xsl:when>
                <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsl:choose">
            <xsl:for-each select="substitutions/substitution"> 
                <xsl:element  name="xsl:when">
                    <xsl:attribute name="test">
                        <xsl:choose>
                            <xsl:when test="match">&#x24;<xsl:value-of select="$varname"/> = '<xsl:value-of select="match"/>'</xsl:when>
                            <xsl:when test="partialMatch">contains(&#x24;<xsl:value-of select="$varname"/>, '<xsl:value-of select="match"/>')</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="replace"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="substitutions-vdex">
        <xsl:variable name="varname">
            <xsl:choose>
                <xsl:when test="destination"><xsl:value-of select="destination"/></xsl:when>
                <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- TOM!!!!!! -->
        <xsl:variable name="sourcetermpath"></xsl:variable>
        <axsl:for-each select="document('../thesauri/{substitutions/sourceThesaurus}.xml')/descendant::vdex:relationship[vdex:sourceTerm=&#x24;{$varname} and vdex:targetTerm/@vocabularyIdentifier='{substitutions/targetThesaurus}']">
            <xsl:choose>
                <xsl:when test="substitutions/target='termIdentifier'"><axsl:value-of select="vdex:targetTerm"/></xsl:when>
                <xsl:when test="substitutions/target='caption'">
                    <axsl:variable name="targetTermID"><axsl:value-of select="vdex:targetTerm"/></axsl:variable>
                    <axsl:for-each select="document('../thesauri/{substitutions/targetThesaurus}.xml')/descendant::vdex:term[vdex:termIdentifier=&#x24;targetTermID][1]">
                        <axsl:value-of select="vdex:caption/vdex:langstring[1]"/>
                    </axsl:for-each>
                </xsl:when>
            </xsl:choose>
        </axsl:for-each>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>
