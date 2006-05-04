<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" version="1.0">
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" encoding="UTF-8" indent="no" version="1.0" xml:lang="en"/>
    <xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
   <head>
        <title><xsl:value-of select="/tei:div/tei:head"/></title>
        <style type="text/css" media="screen"> @import "webscreen.css"; </style>
    </head>
    <body>
        <div id="container">
            <div id="main">
                <h1><span class="text"><xsl:value-of select="/tei:div/tei:head"/></span></h1>
                <xsl:if test="/tei:div/tei:p">
                <div id="introduction">
                    <xsl:apply-templates select="/tei:div/tei:head">
                        <xsl:with-param name="headlevel">2</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="/tei:div/tei:p"/>
                </div>
                </xsl:if>
                <xsl:apply-templates select="/tei:div/tei:div"/>
                <div id="footer">
                    <xsl:if test="//tei:div[@type='gl-responsibility']//tei:respStmt[tei:resp = 'author']">
                        <xsl:variable name="authorcount"><xsl:value-of select="count(//tei:div[@type='gl-responsibility']//tei:respStmt[tei:resp = 'author'])"/></xsl:variable>
                        <p>Content on this page by <xsl:for-each select="//tei:div[@type='gl-responsibility']//tei:respStmt[tei:resp = 'author']">
                            <xsl:variable name="precedingcount"><xsl:value-of select="count(preceding::tei:respStmt[tei:resp = 'author'])"/></xsl:variable>
                            <xsl:variable name="followingcount"><xsl:value-of select="count(following::tei:respStmt[tei:resp = 'author'])"/></xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$authorcount = 1"><xsl:value-of select="tei:name"/></xsl:when>
                                <xsl:when test="$authorcount = 2">
                                    <xsl:if test="preceding::tei:respStmt[tei:resp = 'author']"> and </xsl:if>
                                    <xsl:value-of select="tei:name"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$precedingcount &gt; 0 and $followingcount &gt; 1">, </xsl:when>
                                        <xsl:when test="$followingcount = 1"> and </xsl:when>
                                    </xsl:choose>
                                    <xsl:value-of select="tei:name"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>. Last update: <xsl:value-of select="substring-before(substring-after(//tei:seg[@n='cvs-revision-date'], '&#x24;Date: '),' &#x24;')"/>.<br/>Copyright 2006 by the authors.<br/>
                        This document derives from content in the <a href="resources.shtml#guidelines">EpiDoc Guidelines</a> (source file: <xsl:value-of select="/tei:div/@id"/>.xml).</p>
                    </xsl:if>
                    
                </div>
                
            </div>
            <xsl:comment>#include virtual="meta.html"</xsl:comment>
        </div>
    </body>
    
</html>
        
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:param name="headlevel">1</xsl:param>
        <xsl:choose>
            <xsl:when test="$headlevel = 1"><h1><xsl:value-of select="."/></h1></xsl:when>
            <xsl:when test="$headlevel = 2"><h2><xsl:value-of select="."/></h2></xsl:when>
            <xsl:when test="$headlevel = 3"><h3><xsl:value-of select="."/></h3></xsl:when>
            <xsl:when test="$headlevel = 4"><h4><xsl:value-of select="."/></h4></xsl:when>
            <xsl:when test="$headlevel = 5"><h5><xsl:value-of select="."/></h5></xsl:when>
            <xsl:otherwise><h6><xsl:value-of select="."/></h6></xsl:otherwise>
            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:element name="div">
            <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="headlevel"><xsl:value-of select="count(ancestor::tei:div)+1"/></xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:list[@type='unordered']">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="tei:xref">
        <xsl:choose>
            <xsl:when test="contains(@href, 'http://')">
        <xsl:element name="a">
            <xsl:copy-of select="@href"/>
            <xsl:if test="@lang">
                <xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
                <xsl:attribute name="xml:lang"><xsl:value-of select="@lang"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@href = 'epidev.xml'">
                        <a href="resources.shtml" title="EpiDoc Resources"><xsl:value-of select="."/></a>
                    </xsl:when>
                    <xsl:when test="@href = 'guidelines.xml'">
                        <a href="resources.shtml#guidelines" title="EpiDoc Guidelines"><xsl:value-of select="."/></a>
                    </xsl:when>
                    <xsl:when test="@href = 'taggingtext.xml'">
                        <a href="#IntroEpigraphers-conventions" title="Epigraphic Conventions"><xsl:value-of select="."/></a>
                    </xsl:when>
                    <xsl:when test="@href = 'chetc.xml'">
                        <a href="resources.shtml#chetc" title="The Chapel Hill Electronic Text Converter"><xsl:value-of select="."/></a>
                    </xsl:when>
                    <xsl:when test="@href = 'documentstructure.xml'">
                        <a href="http://www.stoa.org/projects/epidoc/stable/guidelines/documentstructure.html" title="Document Structure section of the EpiDoc Guidelines"><xsl:value-of select="."/></a>
                    </xsl:when>
                    <xsl:otherwise><span class="internal-link"><xsl:apply-templates/></span></xsl:otherwise>
                </xsl:choose>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='gl-responsibility']"/>
    <xsl:template match="tei:div[@type='gl-cvs']"/>
</xsl:stylesheet>
