<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================================================= -->
<!-- This xslt file is designed to transform the content of a "crosswalk document" in 
        xml into a new, custom xslt file that can then be used to transform xml source 
        documents (built according to a particular schema) into new:
       
           * xml documents governed by other schemas, or 
           * "comma separated value" (csv) text files, or
           * text files containing SQL INSERT statements
       
       The "crosswalk document" is assumed to have been constructed correctly by the 
       user; i.e., it maps (via "copy" elements) fields defined in the source schema to 
       fields defined in the destination schema, or it provides default values (via "force" 
       elements) for required fields in the destination schema.  -->
<!-- ========================================================================= -->
<xsl:stylesheet xmlns="http://www.w3.org/1999/XSL/TransformAlias" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" version="1.0">
    <xsl:import href="copy.xsl"/>
    <xsl:import href="csv.xsl"/>
    <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
    <xsl:output encoding="UTF-8" method="xml" indent="no" />
    <xsl:param name="generatordir">../../generator/</xsl:param>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- write stylesheet element and process document tree -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="/">
        <axsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
            <xsl:apply-templates />
        </axsl:stylesheet>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- write output element and a template element to handle the root of the 
           of the EpiDoc document, a template that will invoke appropriate modes and
           templates for processing the EpiDoc document tree in the context of the 
           output format specified in the input file to this transform. -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="crosswalk">
        <!-- store the format information in a variable for easy access -->
        <xsl:variable name="format">
            <xsl:value-of select="output/format" />
        </xsl:variable>
        <xsl:variable name="outputformat">
            <xsl:choose>
                <xsl:when test="$format = 'XML'">xml</xsl:when>
                <xsl:otherwise>text</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
         <!-- if needed, write a named template to handle string replacements -->
        <xsl:if test="//stringReplace">
            <axsl:import href="{$generatordir}/stringReplace.xsl"/>
        </xsl:if>
        <xsl:for-each select="//xslt">
            <axsl:import href="{.}"/>
        </xsl:for-each>
        <!-- write an appropriate xsl:output element, differentiating between the different
              possible formats -->
        <axsl:output encoding="{input/encoding}" method="{$outputformat}" indent="no"/>
        <!-- Write a template to match the root element of the document to be 
               transformed and to handle therein any requirements for headers or 
               other initialization steps related to the desired output format. Once 
               any header information or initialization is complete, invoke 
                appropriate sub-templates to handle the specific field-to-field 
                transformations. -->
        <axsl:template match="/">
            <xsl:choose>
                <xsl:when test="$format = 'CSV' and output/header = 'yes'">
                    <xsl:call-template name="csv-header" />
                </xsl:when>
                <!-- NB: only CSV has a header requirement, right now anyway -->
            </xsl:choose>
            <xsl:for-each select="copy | force">
                <xsl:choose>
                    <xsl:when test="$format = 'CSV'">
                        <xsl:apply-templates select="." mode="csv-data" />
                    </xsl:when>
                    <!-- NB: only CSV is currently handled. Need to add XML and SQL -->
                </xsl:choose>
            </xsl:for-each>
        </axsl:template>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- templates for handling XML output -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- not yet written! -->
    <!-- suppress document-tree-order invocation of templates for the following elements -->
    <xsl:template match="input" />
    <xsl:template match="output" />
</xsl:stylesheet>
