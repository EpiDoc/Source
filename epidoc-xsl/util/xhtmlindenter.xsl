<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:str="http://exslt.org/strings">
   <xsl:output indent="no"/>
    <!--
   ====================================================================================
   ROOT TEMPLATE
   ====================================================================================
   -->
   <xsl:template match="/"><xsl:apply-templates/></xsl:template>
   <!--
   ====================================================================================
   TAGS TO *NOT* INDENT OR OTHERWISE MESS WITH: INLINE TAGS
   ====================================================================================
   -->  
   <xsl:template match="xhtml:a | xhtml:span | xhtml:abbr | xhtml:strong"><xsl:call-template name="copyme"/></xsl:template>
   <!--
   ====================================================================================
   TAGS REQUIRING SPECIAL PROCESSING
   ====================================================================================
   -->   

   <xsl:template match="xhtml:q">
      <xsl:choose>
         <xsl:when test="@class='inline'"><xsl:call-template name="copyme"/></xsl:when>
         <xsl:otherwise><xsl:call-template name="indentme"/><xsl:call-template name="copyme"/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="xhtml:img">
      <xsl:choose>
         <xsl:when test="name(..)= 'div'"><xsl:call-template name="indentme"/><xsl:call-template name="copyme"/></xsl:when>
         <xsl:otherwise><xsl:call-template name="copyme"></xsl:call-template></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
   ====================================================================================
   BLOCK LEVEL TAGS: SHOW ENCAPSULATION (BREAK AND INDENT INSIDE, BREAK BEFORE CLOSE)
   ====================================================================================
   -->  
   <xsl:template match="xhtml:div | xhtml:ul | xhtml:ol | xhtml:dl | xhtml:html | xhtml:body |
      xhtml:head"><xsl:call-template name="indentme"><xsl:with-param
      name="blanklines">1</xsl:with-param></xsl:call-template><xsl:call-template
         name="copyme"><xsl:with-param name="unindent">yes</xsl:with-param></xsl:call-template></xsl:template>
   <!--
   ====================================================================================
   ALL OTHER TAGS: SIMPLE INDENTION
   ====================================================================================
   -->
   <xsl:template match="xhtml:*"><xsl:call-template name="indentme"/><xsl:call-template name="copyme"/></xsl:template>
   <!--
   ====================================================================================
   TEXT NODES: ALL BREAKS TO BE REMOVED
   ====================================================================================
   -->   
   <xsl:template match="text()">
      <xsl:call-template name="collapsewhitespace"/>
   </xsl:template>
   <!--
   ====================================================================================
   UTILITY AND STRING-PROCESSING TEMPLATES
   ====================================================================================
   -->   

   <xsl:template name="collapsewhitespace">
      <xsl:param name="victimstring" select="."/>
      <xsl:variable name="cleanstring" select="normalize-space($victimstring)"/>
      <!-- check for leading and trailing whitespace and put in a space for each -->
      <xsl:if test="substring($victimstring,1,1) != substring($cleanstring,1,1)"><xsl:text> </xsl:text></xsl:if
      ><xsl:value-of select="$cleanstring"/><xsl:if
         test="substring($cleanstring,string-length($cleanstring),1) != substring($victimstring,
         string-length($victimstring), 1)"><xsl:text> </xsl:text></xsl:if>
   </xsl:template>
   <xsl:template name="copyme">
      <xsl:param name="unindent">no</xsl:param>
      <xsl:copy>
         <xsl:copy-of select="attribute::*"/>
         <xsl:apply-templates/>
         <xsl:if test="$unindent='yes'">
            <xsl:call-template name="unindentme"/>
         </xsl:if>
      </xsl:copy>
   </xsl:template>

   
   <xsl:template name="indentme">
      <xsl:param name="blanklines">1</xsl:param>
      <xsl:call-template name="addblankline">
         <xsl:with-param name="count"><xsl:value-of select="$blanklines"/></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="addblock">
         <xsl:with-param name="count"><xsl:value-of select="count(ancestor::xhtml:div | ancestor::xhtml:head |
            ancestor::xhtml:html | ancestor::xhtml:body | ancestor::xhtml:p | ancestor::xhtml:ul |
            ancestor::xhtml:ol | ancestor::xhtml:dl)"/></xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="unindentme">
      <xsl:param name="blanklines">1</xsl:param>
      <xsl:call-template name="addblankline">
         <xsl:with-param name="count"><xsl:value-of select="$blanklines"/></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="addblock">
         <xsl:with-param name="count"><xsl:value-of select="count(ancestor::xhtml:div | ancestor::xhtml:head |
            ancestor::xhtml:html | ancestor::xhtml:body | ancestor::xhtml:p | ancestor::xhtml:ul |
            ancestor::xhtml:ol | ancestor::xhtml:dl)"/></xsl:with-param>
      </xsl:call-template>      
   </xsl:template>
   
   <xsl:template name="addblock">
      <xsl:param name="count">0</xsl:param>
      <xsl:if test="$count &gt; 0">
         <xsl:text> </xsl:text>
         <xsl:call-template name="addblock">
            <xsl:with-param name="count"><xsl:value-of select="$count - 1"/></xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="addblankline">
      <xsl:param name="count">0</xsl:param>
      <xsl:if test="$count != 0"><xsl:text>
</xsl:text><xsl:call-template name="addblankline"><xsl:with-param name="count"><xsl:value-of
         select="$count - 1"/></xsl:with-param></xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="comment()">
      <xsl:call-template name="indentme"/><xsl:copy/>
   </xsl:template>
      
   <xsl:template match="processing-instruction()">
      <xsl:call-template name="addblankline"><xsl:with-param name="count">1</xsl:with-param></xsl:call-template>
      <xsl:copy/>
      <xsl:call-template name="addblankline"><xsl:with-param name="count">1</xsl:with-param></xsl:call-template>
   </xsl:template>
   
</xsl:stylesheet>
