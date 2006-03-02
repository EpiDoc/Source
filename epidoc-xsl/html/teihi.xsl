<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
    <xsl:template match="tei:hi">
        <xsl:choose>
             <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='intraline'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='intraline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">line-through</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='italic'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='italic'">
                <xsl:element name="span">
                    <xsl:attribute name="class">italic</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='ligature'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='ligature'">
                <xsl:element name="span">
                    <xsl:attribute name="class">ligature</xsl:attribute>
                    <xsl:attribute name="title">Ligature: these characters are joined</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='normal'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='normal'">
                <xsl:element name="span">
                    <xsl:attribute name="class">normal</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
             <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='reversed'                                                                                                      -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='reversed'">
                <xsl:element name="span">
                    <xsl:attribute name="class">reversed</xsl:attribute>
                    <xsl:attribute name="title">reversed: <xsl:value-of select="."/></xsl:attribute>
                    ((<xsl:apply-templates />))
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='strong'                                                                                                           -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='strong'">
                <xsl:element name="strong">
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='superscript'                                                                                                   -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='superscript'">
                <xsl:element name="sup">
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='supraline'                                                                                                   -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='supraline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">supraline</xsl:attribute>
                    <xsl:attribute name="title">line above</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='underline'                                                                                                      -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='underline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">underline</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- UNTRAPPED REND VALUE                                                                                           -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:otherwise>
                <xsl:comment>hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:comment>
                <xsl:element name="span">
                    <xsl:attribute name="class">error</xsl:attribute>
                    <xsl:attribute name="title">hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
