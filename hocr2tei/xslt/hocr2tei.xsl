<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:h="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="h:html">
        <xsl:processing-instruction name="xml-model">
            href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" schematypens="http://relaxng.org/ns/structure/1.0"
        </xsl:processing-instruction>
        <xsl:element name="TEI">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h:head">
        <xsl:element name="teiHeader">
            <xsl:element name="fileDesc">
                <xsl:element name="titleStmt">
                    <xsl:element name="title">
                        <xsl:value-of select="h:title"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="publicationStmt">
                    <xsl:element name="p">
                        <xsl:text>Interim file, not published</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="sourceDesc">
                    <xsl:element name="p">
                        <xsl:text>Scanned text OCRed using </xsl:text>
                        <xsl:value-of select="h:meta[@name='ocr-system']/@content"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <xsl:element name="facsimile">
            <xsl:element name="surface">
                <xsl:element name="graphic">
                    <xsl:attribute name="url" select="substring-after(//h:div[@class='ocr_page']/@title, 'image ')"/>
                </xsl:element>
                <xsl:for-each select="//h:*[starts-with(@title,'bbox')]">
                    <xsl:element name="zone">
                        <xsl:attribute name="xml:id" select="concat(@class,'_',count(preceding::h:*[@class=current()/@class]))"/>
                        <xsl:attribute name="ulx" select="tokenize(@title,' ')[2]"/>
                        <xsl:attribute name="uly" select="tokenize(@title,' ')[3]"/>
                        <xsl:attribute name="lrx" select="tokenize(@title,' ')[4]"/>
                        <xsl:attribute name="lry" select="tokenize(@title,' ')[5]"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
        
    <xsl:template match="h:body">
        <xsl:element name="text">
            <xsl:element name="body">
                <xsl:choose>
                    <xsl:when test="descendant::h:span[@class='tei_p']">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="ab">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h:div[@class='ocr_page']">
        <xsl:element name="pb">
            <xsl:call-template name="at-facs"/>
            <xsl:if test="descendant::h:span[@class='tei_pb']">
                <xsl:attribute name="n">
                    <xsl:value-of select="descendant::h:span[@class='tei_pb'][1]"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="h:span[@class='ocr_line']">
        <xsl:element name="lb">
            <xsl:call-template name="at-facs"/>
            <xsl:if test="descendant::h:span[@class='tei_lb']">
                <xsl:attribute name="n">
                    <xsl:value-of select="descendant::h:span[@class='tei_lb'][1]"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="h:span[@class='ocr_word']">
        <xsl:choose>
            <xsl:when test=".=('-','.',',',':',';','?,','!','·','—')">
                <xsl:element name="pc">
                    <xsl:call-template name="at-facs"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="w">
                    <xsl:call-template name="at-facs"/>
                    <xsl:apply-templates/>
                </xsl:element> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="h:span[starts-with(@class,'tei_')]">
        <xsl:choose>
            <xsl:when test="substring-after(@class,'tei_')=('pb','lb')"/>
            <xsl:otherwise>    
                <xsl:element name="{substring-after(@class,'tei_')}">
                    <xsl:call-template name="at-facs"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="at-facs">
        <xsl:if test="starts-with(@title,'bbox')">
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#',@class,'_',count(preceding::*[@class=current()/@class]))"/>
            </xsl:attribute>
       </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-unicode(.,'NFD')"/>
    </xsl:template>
    
</xsl:stylesheet>