<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:gap[@reason='illegible' and @unit='character']">
      <xsl:element name="span">
         <xsl:attribute name="class">gap-illegible</xsl:attribute>
         <xsl:attribute name="title"><xsl:value-of select="@extent"/> illegible character<xsl:if test="@extent &gt; 1">s</xsl:if></xsl:attribute>
         <xsl:call-template name="propagateattrs"/>
         <xsl:attribute name="lang"><xsl:value-of select="ancestor::*[@lang]/@lang"/></xsl:attribute>
         <xsl:attribute name="xml:lang"><xsl:value-of select="ancestor::*[@lang]/@lang"/></xsl:attribute>
         <xsl:choose>
            <xsl:when test="@extent &lt; 4"><xsl:call-template name="repeatstring"><xsl:with-param name="rstring" select="$vestigemark"/><xsl:with-param name="rcount" select="@extent"/></xsl:call-template></xsl:when>
      <xsl:otherwise><xsl:value-of select="$vestigemark"/><xsl:text> </xsl:text><xsl:value-of select="@extent"/><xsl:text> </xsl:text><xsl:value-of select="$vestigemark"/></xsl:otherwise>
         </xsl:choose></xsl:element>
         
   </xsl:template>

    <!-- ================================================================================= -->
    <!-- lost characters, units measured in characters -->
    <!-- ================================================================================= -->
    <xsl:template match="tei:gap[@reason='lost' and @unit='character' and @extent]">
        <xsl:variable name="gapid"><xsl:value-of select="@id"/></xsl:variable>
        <xsl:element name="span">
            <xsl:attribute name="class">gap-illegible</xsl:attribute>
            <xsl:attribute name="title"><xsl:if test="@id and //tei:certainty[@target=$gapid and @locus='extent' and @degree='no']">approximately </xsl:if><xsl:value-of select="@extent"/> illegible character<xsl:if test="@extent &gt; 1">s</xsl:if></xsl:attribute>
            <xsl:call-template name="propagateattrs"/>
            <xsl:choose>
                <xsl:when test="@extent &lt; 4 and not(//tei:certainty[@target=$gapid and @locus='extent' and @degree='no'])">[<xsl:call-template name="repeatstring"><xsl:with-param name="rcount"><xsl:value-of select="@extent - 1"/></xsl:with-param><xsl:with-param name="rstring">• </xsl:with-param></xsl:call-template>•]</xsl:when>
                <xsl:otherwise>[• <xsl:if test="@id and //tei:certainty[@target=$gapid and @locus='extent' and @degree='no']">c.</xsl:if><xsl:value-of select="@extent"/> •]</xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- ================================================================================= -->
    <!-- lost characters, units NOT measured in characters -->
    <!-- ================================================================================= -->
    <xsl:template match="tei:gap[@reason='lost' and @unit!='character' and @unit!='line' and @extent]">
        <xsl:element name="span">
            <xsl:attribute name="class">gap-illegible</xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="@extent"/> <xsl:value-of select="@unit"/> of illegible text</xsl:attribute>
            <xsl:call-template name="propagateattrs"/>
            [ - <xsl:value-of select="@extent"/><xsl:value-of select="@unit"/> - ]
        </xsl:element>
    </xsl:template>

    <!-- ================================================================================= -->
    <!-- one lost line: matches guidelines lostline.xml                                                                      -->
    <!-- ================================================================================= -->
    <xsl:template match="tei:gap[@reason='lost' and @unit='line' and @extent='1']">
        <xsl:element name="span">
            <xsl:attribute name="class">gap-illegible</xsl:attribute>
            <xsl:attribute name="title">1 illegible line</xsl:attribute>
            <xsl:call-template name="propagateattrs"/>
            [ - - - - - - - - - - - - - - - - - - ]
        </xsl:element>
    </xsl:template>
   
    <!-- ================================================================================= -->
    <!-- callable template for repeating strings in output                                                                  -->
    <!-- ================================================================================= -->

    <xsl:template name="repeatstring">
      <xsl:param name="rstring"/>
      <xsl:param name="rcount"/>
      <xsl:if test="$rcount &gt; 0"
         ><xsl:value-of select="$rstring"
            /><xsl:call-template name="repeatstring"
            ><xsl:with-param name="rstring"  select="$rstring"
            /><xsl:with-param name="rcount" select="$rcount - 1"/></xsl:call-template
         ></xsl:if>
   </xsl:template>
</xsl:stylesheet>
