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
<xsl:stylesheet xmlns="http://www.w3.org/1999/XSL/TransformAlias"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
    xmlns:vdex="http://www.imsglobal.org/xsd/imsvdex_v1p0" version="1.0">
    <xsl:import href="copy.xsl" />
    <xsl:import href="csv.xsl" />
    <xsl:import href="xml.xsl" />
    <xsl:import href="substitutions.xsl" />
    <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl" />
    <xsl:output encoding="UTF-8" method="xml" indent="no" />
    <xsl:param name="generatordir">../../generator/</xsl:param>
    <xsl:variable name="format">
        <xsl:value-of select="crosswalk/output/format" />
    </xsl:variable>
    <xsl:variable name="outputformat">
        <xsl:choose>
            <xsl:when test="$format = 'XML'">xml</xsl:when>
            <xsl:otherwise>text</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
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
        <!-- if needed, write a named template to handle string replacements -->
        <xsl:if test="//stringReplace">
            <axsl:import href="{$generatordir}/stringReplace.xsl" />
        </xsl:if>
        <xsl:for-each select="//xslt">
            <axsl:import href="{.}" />
        </xsl:for-each>
        <!-- write an appropriate xsl:output element, differentiating between the different
              possible formats -->
        <axsl:output encoding="{input/encoding}" method="{$outputformat}" indent="no" />
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
            <xsl:apply-templates />
        </axsl:template>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- templates for handling XML output -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- not yet written! -->
    <!-- suppress document-tree-order invocation of templates for the following elements -->
    <xsl:template match="input" />
    <xsl:template match="output" />
    <xsl:template match="element">
        <xsl:choose>
            <xsl:when test="source/delimiter">
                <axsl:variable name="orig">
                    <xsl:call-template name="copy-get-value-source" />
                </axsl:variable>
                <axsl:choose>
                    <axsl:when test="contains(&#x24;orig, '{source/delimiter}')">
                        <axsl:element name="{@name}">
                            <xsl:apply-templates select="attribute">
                                <xsl:with-param name="delimited-position">before</xsl:with-param>
                            </xsl:apply-templates>
                            <axsl:variable name="{@name}">
                                <axsl:value-of
                                    select="substring-before(&#x24;orig, '{source/delimiter}')"
                                 />
                            </axsl:variable>
                            <xsl:call-template name="copy-process-value" />
                        </axsl:element>
                        <axsl:element name="{@name}">
                            <xsl:apply-templates select="attribute">
                                <xsl:with-param name="delimited-position">after</xsl:with-param>
                            </xsl:apply-templates>
                            <axsl:variable name="{@name}">
                                <axsl:value-of
                                    select="substring-after(&#x24;orig, '{source/delimiter}')"
                                 />
                            </axsl:variable>
                            <xsl:call-template name="copy-process-value" />
                        </axsl:element>
                    </axsl:when>
                    <axsl:otherwise> 
                        <axsl:element name="{@name}">
                            <xsl:apply-templates select="attribute" />
                            <xsl:choose>
                                <xsl:when test="source | sourceCombine">
                                    <xsl:call-template name="copy" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates />
                                </xsl:otherwise>
                            </xsl:choose>
                        </axsl:element>
                    </axsl:otherwise>
                </axsl:choose>
                <xsl:comment>wahhoooooooooo</xsl:comment>
            </xsl:when>
            <xsl:otherwise>
                <axsl:element name="{@name}">
                    <xsl:apply-templates select="attribute" />
                    <xsl:choose>
                        <xsl:when test="source | sourceCombine">
                            <xsl:call-template name="copy" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates />
                        </xsl:otherwise>
                    </xsl:choose>
                </axsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="attribute">
        <xsl:param name="delimited-position">not-applicable</xsl:param>
        <axsl:attribute name="{@name}">
            <xsl:choose>
                <xsl:when test="$delimited-position = 'before'">
                    <axsl:variable name="{@name}">
                        <axsl:value-of
                            select="substring-before(&#x24;orig, '{source/delimiter}')" />
                    </axsl:variable>
                    <xsl:call-template name="copy-process-value" />
                </xsl:when>
                <xsl:when test="$delimited-position = 'after'">
                    <axsl:variable name="{@name}">
                        <axsl:value-of
                            select="substring-after(&#x24;orig, '{source/delimiter}')" />
                    </axsl:variable>
                    <xsl:call-template name="copy-process-value" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="source | sourceCombine">
                            <xsl:call-template name="copy" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </axsl:attribute>
    </xsl:template>
    <xsl:template match="for-each">
        <!--        <axsl:element name="for-each">
            <axsl:attribute name="select"><xsl:value-of select="@select"/></axsl:attribute>
            <xsl:apply-templates/>
    </axsl:element> -->
        <xsl:variable name="wiggy">
            <xsl:value-of select="@select" />
        </xsl:variable>
        <axsl:for-each select="{$wiggy}">
            <xsl:apply-templates />
        </axsl:for-each>
    </xsl:template>
    <xsl:template match="copy | force">
        <xsl:choose>
            <xsl:when test="$format = 'CSV'">
                <xsl:apply-templates select="." mode="csv-data" />
            </xsl:when>
            <xsl:when test="$format = 'XML'">
                <xsl:apply-templates select="." mode="xml-data" />
            </xsl:when>
            <!-- NB: only CSV is currently handled. Need to add XML and SQL -->
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
