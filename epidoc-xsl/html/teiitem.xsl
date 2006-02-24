<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:item">
      <xsl:element name="li">
          <xsl:call-template name="propagateattrs">
              <xsl:with-param name="dolang">no</xsl:with-param>
          </xsl:call-template>
          <xsl:choose>
              <xsl:when test="@lang">
                  <xsl:element name="span">
                      <xsl:apply-templates select="@lang" mode="propagateattrs"/>
                      <xsl:apply-templates />
                  </xsl:element>
              </xsl:when>
              <xsl:when test="../@lang">
                  <xsl:element name="span">
                      <xsl:apply-templates select="../@lang" mode="propagateattrs"/>
                      <xsl:apply-templates />
                  </xsl:element>
              </xsl:when>
              <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
