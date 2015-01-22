<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://relaxng.org/ns/structure/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="rng:grammar">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="ns">http://www.tei-c.org/ns/Examples</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="rng:start">
        <xsl:element name="define">
            <xsl:attribute name="name">tei_egXML</xsl:attribute>
            <xsl:element name="element">
                <xsl:attribute name="name">egXML</xsl:attribute>
                <zeroOrMore>
                    <group>
                        <choice>
                            <text/>
                            <xsl:for-each
                                select="//rng:element/ancestor::rng:define[1]/@name[not(contains(., 'any'))]">
                                <xsl:sort/>
                                <xsl:element name="ref">
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>

                                </xsl:element>
                            </xsl:for-each>
                        </choice>
                    </group>
                </zeroOrMore>
                <ref name="att.global.attributes"/>
                <ref name="att.source.attributes"/>
            </xsl:element>
        </xsl:element>
        <start>
            <ref name="tei_egXML"/>
        </start>
    </xsl:template>

    <xsl:template match="*">
        <xsl:call-template name="copier"/>
    </xsl:template>

    <xsl:template name="copier">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
