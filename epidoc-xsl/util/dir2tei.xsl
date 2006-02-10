<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
   <xsl:output indent="no" />
   <xsl:param name="dodirs">no</xsl:param>
   <xsl:param name="dofiles">yes</xsl:param>
    <xsl:param name="htmllink">no</xsl:param>
   <xsl:template match="comment()|processing-instruction()">
      <xsl:copy>
         <xsl:apply-templates />
      </xsl:copy>
   </xsl:template>
   <xsl:template match="dir:directory">
      <xsl:choose>
         <xsl:when test="count(ancestor::dir:directory) = 0">
            <xsl:element name="tei:div">
               <xsl:element name="tei:head">Directory contents:</xsl:element>
               <xsl:if test="*">
                  <xsl:element name="tei:list">
                     <xsl:attribute name="type">unordered</xsl:attribute>
<xsl:apply-templates/>
                  </xsl:element>
               </xsl:if>
            </xsl:element></xsl:when>
         <xsl:when test="$dodirs='yes'">
            <xsl:element name="tei:item">
               <xsl:element name="tei:xref">
                  <xsl:attribute name="doc"><xsl:value-of select="@name" />/</xsl:attribute>
                  <xsl:value-of select="@name" />/</xsl:element> (directory) <xsl:if test="*">
                  <xsl:element name="tei:list">
                     <xsl:attribute name="type">unordered</xsl:attribute>
                     <xsl:apply-templates />
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="dir:file">
      
      <xsl:if test="$dofiles='yes' and contains(@name, '.xml')"><xsl:element name="tei:item">
         
         <xsl:element name="tei:xref">
            <xsl:attribute name="doc"><xsl:value-of select="substring-before(@name, '.xml')"/></xsl:attribute>
            <xsl:value-of select="@name" />
         </xsl:element> (file, last changed: <xsl:value-of select="@date" />) </xsl:element></xsl:if>
   </xsl:template>
   <xsl:template match="*">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()" />
      </xsl:copy>
   </xsl:template>
   <xsl:template match="@*">
      <xsl:attribute name="{local-name()}">
         <xsl:value-of select="." />
      </xsl:attribute>
   </xsl:template>
</xsl:stylesheet>
