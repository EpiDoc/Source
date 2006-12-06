<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================================================= -->
<!-- This xslt file contains template that is intended to be invoked by the EpiDoc 
       crosswalker.xsl file's contents. These templates provide the crosswalker
       application with the ability to produce XML files. -->
<!-- ========================================================================= -->
<xsl:stylesheet xmlns="http://www.w3.org/1999/XSL/TransformAlias"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" version="1.0">
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to copy data from the source xml file to the
            destination xml file -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="copy" mode="xml-data">
        <axsl:element name="{destination}">
            <xsl:call-template name="copy" />
        </axsl:element>
    </xsl:template>

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- these templates enable specific scripting of xml elements as called for in the 
        driver file; includes support for nesting elements in the result file -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="attribute[source/useParent]">
        <axsl:attribute name="{@name}">
                <xsl:variable name="destname">
                    <xsl:value-of select="@name" />
                </xsl:variable>
                <axsl:variable name="{$destname}">
                    <axsl:value-of select="normalize-space(&#x24;{../@name})" />
                </axsl:variable>
                <xsl:call-template name="copy-process-value" />
        </axsl:attribute>
    </xsl:template>
    <xsl:template match="attribute">
        <axsl:attribute name="{@name}">
            <xsl:choose>
                <xsl:when test="source | sourceCombine">
                    <xsl:call-template name="copy" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </axsl:attribute>
    </xsl:template>
    <xsl:template match="element[sourceSplit]">
        <!-- get the raw source value -->
        <axsl:variable name="orig">
            <xsl:call-template name="copy-get-value-sourceSplit" />
        </axsl:variable>
        <!-- split it up and process each value to produce a separate element -->
        <axsl:for-each select="str:split(&#x24;orig, '{sourceSplit/delimiter}')">
            <axsl:element name="{@name}">
                <xsl:variable name="destname">
                    <xsl:value-of select="@name" />
                </xsl:variable>
                <axsl:variable name="{$destname}">
                    <axsl:value-of select="normalize-space(.)" />
                </axsl:variable>
                <xsl:apply-templates select="attribute" />
                <xsl:call-template name="copy-process-value" />
            </axsl:element>
        </axsl:for-each>
    </xsl:template>

    <xsl:template match="element[source | sourceCombine]">
        <axsl:element name="{@name}">
            <xsl:apply-templates select="attribute" />
            <xsl:call-template name="copy-get-value" />
            <xsl:call-template name="copy-process-value" />
        </axsl:element>
    </xsl:template>

    <xsl:template match="element[copy | element]">
        <axsl:element name="{@name}">
            <xsl:apply-templates select="attribute" />
            <xsl:apply-templates select="copy | element" />
        </axsl:element>
    </xsl:template>

    <xsl:template match="element">
        <axsl:element name="{@name}">
            <xsl:apply-templates />
        </axsl:element>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to force data into an element in the 
            destination xml file  (currently disabled: force elements in the driver file
            will be silently ignored! -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="force" mode="xml-data">
        <!-- <xsl:text>"</xsl:text>
        <xsl:value-of select="value" />
        <xsl:text>"</xsl:text>
        <xsl:if test="count(following-sibling::*) != 0">
            <xsl:text>, </xsl:text>
        </xsl:if> -->
    </xsl:template>
</xsl:stylesheet>
