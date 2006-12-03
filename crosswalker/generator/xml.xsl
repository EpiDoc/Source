<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================================================= -->
<!-- This xslt file contains template that is intended to be invoked by the EpiDoc 
       crosswalker.xsl file's contents. These templates provide the crosswalker
       application with the ability to produce XML files. -->
<!-- ========================================================================= -->
<xsl:stylesheet xmlns="http://www.w3.org/1999/XSL/TransformAlias" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" version="1.0">
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to copy data from the source xml file to the
            destination xml file -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="copy" mode="xml-data">
        <axsl:element name="{destination}"><xsl:call-template name="copy"/></axsl:element>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes the instructions to create a column content (data) for a 
          single column in an output csv file when the corresponding crosswalk defintion 
          element in the source file is "force". -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="force" mode="xml-data">
        <!-- <xsl:text>"</xsl:text>
        <xsl:value-of select="value" />
        <xsl:text>"</xsl:text>
        <xsl:if test="count(following-sibling::*) != 0">
            <xsl:text>, </xsl:text>
        </xsl:if> -->
    </xsl:template>    
</xsl:stylesheet>
