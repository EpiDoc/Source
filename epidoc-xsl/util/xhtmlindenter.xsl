<?xml version="1.0" encoding="UTF-8"?>
 
 <!-- Start license statement: do not remove 
 
 EpiDoc Standard Stylesheets
 Copyright (C) 2000-2006 by all contributors
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
 Information about the EpiDoc community can be obtained via
  http://epidoc.sf.net.
 
 End license statement: do not remove -->
 

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
