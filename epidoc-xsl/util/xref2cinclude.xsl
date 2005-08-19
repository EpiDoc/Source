<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ci="http://apache.org/cocoon/include/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="no"/>
    <xsl:param name="recursion">no</xsl:param>
    <xsl:template match="/|comment()|processing-instruction()">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>
<!--   <xsl:template match="tei:list[tei:item/tei:xref/@type='include']"><xsl:apply-templates/></xsl:template>
   <xsl:template match="tei:item[tei:xref/@type='include']">
        <xsl:element name="ci:include">
           <xsl:attribute name="src">src/<xsl:value-of select=".//tei:xref/@href"/></xsl:attribute>
        </xsl:element>
   </xsl:template>
-->
   <xsl:template match="tei:xref[@type='include']">
      <xsl:element name="ci:include">
         <xsl:attribute name="src">src/<xsl:value-of select="@href"/></xsl:attribute>
      </xsl:element>
   </xsl:template>
    <xsl:template match="*">
          <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
