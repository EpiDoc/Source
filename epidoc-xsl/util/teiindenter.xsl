<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY inlinetags "
   tei:abbr
   | tei:add
   | tei:att
   | tei:author[name(..) = 'bibl']
   | tei:bibl[name(..) != 'listBibl']
   | tei:biblScope[name(..) = 'bibl']
   | tei:corr
   | tei:date[name(..) != 'creation'] 
   | tei:editor[name(..) = 'bibl'] 
   | tei:expan
   | tei:foreign 
   | tei:geogName 
   | tei:hi 
   | tei:idno[name(..) = 'bibl'] 
   | tei:link 
   | tei:measure
   | tei:name
   | tei:note[name(..) = 'bibl']
   | tei:persName 
   | tei:placeName 
   | tei:publisher[name(..) = 'bibl'] 
   | tei:pubPlace[name(..) = 'bibl'] 
   | tei:quote[@rend='inline']
   | tei:ref
   | tei:resp
   | tei:respStmt
   | tei:seg
   | tei:sic
   | tei:tag
   | tei:term 
   | tei:translator[name(..) = 'bibl'] 
   | tei:title[name(..) != 'titleStmt']
   | tei:unclear
   | tei:xref
">
<!ENTITY blocktags "
   tei:TEI.2
   | tei:body
   | tei:creation
   | tei:div 
   | tei:fileDesc
   | tei:handList
   | tei:langUsage
   | tei:list 
   | tei:listBibl 
   | tei:profileDesc
   | tei:publicationStmt
   | tei:quote[@rend='block']
   | tei:sourceDesc
   | tei:teiHeader
   | tei:text
   | tei:titleStmt
">
<!ENTITY indentingancestortags "
   ancestor::tei:TEI.2
   | ancestor::tei:ab
   | ancestor::tei:body
   | ancestor::tei:creation
   | ancestor::tei:div 
   | ancestor::tei:fileDesc
   | ancestor::tei:handList
   | ancestor::tei:item 
   | ancestor::tei:langUsage
   | ancestor::tei:list 
   | ancestor::tei:listBibl 
   | ancestor::tei:p
   | ancestor::tei:profileDesc
   | ancestor::tei:publicationStmt
   | ancestor::tei:quote[@rend='block']
   | ancestor::tei:sourceDesc
   | ancestor::tei:teiHeader 
   | ancestor::tei:text
   | ancestor::tei:titleStmt
">
]>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:str="http://exslt.org/strings">
    
   <xsl:output indent="no" method="xml" doctype-system="../dtd/tei-epidoc.dtd" />
   <xsl:strip-space elements="*"/>
   <xsl:param name="tabwidth">3</xsl:param>
   <!--
   ====================================================================================
   ROOT TEMPLATE
   ====================================================================================
   -->
   <xsl:template match="/"><xsl:apply-templates/></xsl:template>
   
   <xsl:template match="comment()|processing-instruction()">
      <xsl:copy><xsl:apply-templates/></xsl:copy>
   </xsl:template>
   
   <!--
   ====================================================================================
   TAGS TO *NOT* INDENT OR OTHERWISE MESS WITH: INLINE TAGS
   ====================================================================================
   -->  
   <xsl:template match="&inlinetags;"><xsl:call-template name="copyme"/></xsl:template>
   <!--
   ====================================================================================
   BLOCK LEVEL TAGS: SHOW ENCAPSULATION (BREAK AND INDENT INSIDE, BREAK BEFORE CLOSE)
   ====================================================================================
   -->  
   <xsl:template match="&blocktags;"><xsl:call-template name="indentme"><xsl:with-param
      name="blanklines">1</xsl:with-param></xsl:call-template><xsl:call-template
         name="copyme"><xsl:with-param name="unindent">yes</xsl:with-param></xsl:call-template></xsl:template>
   <!--
   ====================================================================================
   ALL OTHER TAGS: SIMPLE INDENTION
   ====================================================================================
   -->
    <xsl:template match="*"><xsl:call-template name="indentme"/><xsl:call-template name="copyme"/></xsl:template>
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
   <!-- normalize white space intelligently -->
   <xsl:template name="collapsewhitespace">
      <xsl:param name="victimstring" select="."/>
      <xsl:variable name="cleanstring" select="normalize-space($victimstring)"/>
      <!-- check for leading and trailing whitespace and put in a space for each -->
      <xsl:if test="substring($victimstring,1,1) != substring($cleanstring,1,1)"><xsl:text> </xsl:text></xsl:if
      ><xsl:value-of select="$cleanstring"/><xsl:if
         test="substring($cleanstring,string-length($cleanstring),1) != substring($victimstring,
         string-length($victimstring), 1)"><xsl:text> </xsl:text></xsl:if> 
   </xsl:template>
   
   <!-- copy an element and its attributes with appropriate, parameter-driven indentation -->
   <xsl:template name="copyme">
      <xsl:param name="unindent">no</xsl:param>
      <xsl:copy><xsl:copy-of select="attribute::*"/><xsl:apply-templates/><xsl:if
         test="$unindent='yes'"><xsl:call-template name="unindentme"/></xsl:if></xsl:copy>
   </xsl:template>

   <!-- parameter-driven indentation -->
   <xsl:template name="indentme">
      <xsl:param name="blanklines">1</xsl:param>
      <xsl:call-template name="addblankline">
         <xsl:with-param name="count"><xsl:value-of select="$blanklines"/></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="addblock">
         <xsl:with-param name="count"><xsl:value-of select="count(&indentingancestortags;)"/></xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!-- parameter-driven unindentation -->
   <xsl:template name="unindentme">
      <xsl:param name="blanklines">1</xsl:param>
      <xsl:call-template name="addblankline">
         <xsl:with-param name="count"><xsl:value-of select="$blanklines"/></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="addblock">
         <xsl:with-param name="count"><xsl:value-of select="count(&indentingancestortags;)"/></xsl:with-param>
      </xsl:call-template>      
   </xsl:template>
   
   <!-- sub-template to add uniform amount of whitespace for a single level of indentation -->
   <xsl:template name="addblock">
      <xsl:param name="count">0</xsl:param>
      <xsl:if test="$count &gt; 0">
         <xsl:text>   </xsl:text>
         <xsl:call-template name="addblock">
            <xsl:with-param name="count"><xsl:value-of select="$count - 1"/></xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <!-- subtemplate to insert a blank line -->
   <xsl:template name="addblankline">
      <xsl:param name="count">0</xsl:param>
      <xsl:if test="$count != 0"><xsl:text>
</xsl:text><xsl:call-template name="addblankline"><xsl:with-param name="count"><xsl:value-of
         select="$count - 1"/></xsl:with-param></xsl:call-template>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
