<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================================================= -->
<!-- This xslt file contains template that is intended to be invoked by the EpiDoc 
       crosswalker.xsl file's contents. These templates provide the crosswalker
       application with the ability to produce CSV text files. -->
<!-- ========================================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="substitutions.xsl"/>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- This template invokes sub-templates to create a CSV header row -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="csv-header">
        <xsl:for-each select="copy | force">
            <xsl:apply-templates select="." mode="csv-header" />
        </xsl:for-each>
        <xsl:text>
</xsl:text>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to create a column header for a single 
          column in an output csv file, based on the information provided in the crosswalk 
          input document. The crosswalk definition elements (i.e., copy and force) are 
          processed in crosswalk document order -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="copy | force" mode="csv-header">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="destination" />
        <xsl:text>"</xsl:text>
        <xsl:if test="count(following-sibling::*) != 0">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to create a column content (data) for a 
          single column in an output csv file when the  corresponding crosswalk defintion 
          element in the source file is "copy". -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="copy" mode="csv-data">
        <xsl:text>"</xsl:text><xsl:call-template name="copy"/><xsl:text>"</xsl:text>
        <xsl:if test="count(following-sibling::*) != 0"><xsl:text>,</xsl:text></xsl:if>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to create a column content (data) for a 
          single column in an output csv file when the corresponding crosswalk defintion 
          element in the source file is "force". -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="force" mode="csv-data">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="value" />
        <xsl:text>"</xsl:text>
        <xsl:if test="count(following-sibling::*) != 0">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>    
</xsl:stylesheet>
