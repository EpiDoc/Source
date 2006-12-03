<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/XSL/TransformAlias" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" version="1.0">
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template handles the selection and processing of data for a single "copy"
          mapping in the crosswalk input document. It is output-format neutral, providing
          only the bare data in return. -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="copy">
        <xsl:call-template name="copy-get-value"/>
        <xsl:call-template name="copy-process-value"/>
    </xsl:template>    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes xslt code that will try to obtain (or assemble) the value(s)
          indicated by appropriate elements ("source", "sourceCombine") in the "copy"
          element of the input file. Having obtained the value(s), the generated code
          stores the same in a variable with the name of the destination field. -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="copy-get-value">
        <xsl:variable name="destname">
            <xsl:choose>
                <xsl:when test="destination"><xsl:value-of select="destination"/></xsl:when>
                <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <axsl:variable name="{$destname}">
            <xsl:choose>
                <xsl:when test="source">
                    <xsl:call-template name="copy-get-value-source"/>
                </xsl:when>
                <xsl:when test="sourceCombine">
                    <xsl:call-template name="copy-get-value-sourceCombine"/>
                </xsl:when>
            </xsl:choose>
        </axsl:variable>
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes xslt code that will try to obtain the value indicated by the 
          "source" element in the "copy" element of the input file. If specified in the input 
          file, alternate locations are tried in the following order:
            * node (or first node in nodelist) selected by value of "source" element
            * node (or first node in nodelist) selected by value of "fallback" attribute on 
               "source" element, if any
            * value contained in the "default" element, if any -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="copy-get-value-source">
        <xsl:choose>
            <xsl:when test="source/xslt">
                <axsl:apply-templates select="{source/xpath}"/>
            </xsl:when>
            <xsl:otherwise>
                <axsl:choose>
                    <axsl:when test="{source/xpath}"><axsl:value-of select="normalize-space({source/xpath})"/></axsl:when>
                    <xsl:if test="source/fallback">
                        <axsl:when test="{source/fallback}"><axsl:value-of select="normalize-space({source/fallback})"/></axsl:when>
                    </xsl:if>
                    <xsl:if test="default">
                        <axsl:otherwise><xsl:value-of select="default"/></axsl:otherwise>
                    </xsl:if>
                </axsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes xslt code that will try to obtain the values indicated by the 
          "sourceCombine" element in the "copy" element of the input file, concatenating
          them together. If a string is specified with the "delimiter" element, that string
          will be inserted between each source value. If there is a value in the "enumerate"
          element, one-up numberings will be included with each value, as follows:
            * postfix-parens = number will appear, enclosed in parentheses, following the
               values
            * others????
          If specified in the input file, alternate locations are tried in the following order:
            * all nodes in nodelist selected by value of "xpath" element
            * all nodes in nodelist selected by value of "fallback" element, if any
            * value contained in the "default" element, if any -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="copy-get-value-sourceCombine">
        <xsl:if test="sourceCombine/prefix">
            <xsl:if test="contains(sourceCombine/enumerate, 'prefix')">
                    <xsl:call-template name="copy-enumerate">
                        <xsl:with-param name="forcedval">1</xsl:with-param>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:for-each select="sourceCombine/prefix">
                <xsl:choose>
                    <xsl:when test="xpath">
                        <axsl:apply-templates select="{xpath}"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="contains(sourceCombine/enumerate, 'postfix')">
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="copy-enumerate">
                        <xsl:with-param name="forcedval">1</xsl:with-param>
                    </xsl:call-template>
            </xsl:if>
            <xsl:if test="sourceCombine/delimiter">
                <xsl:element name="axsl:if" namespace="http://www.w3.org/1999/XSL/Transform">
                    <xsl:attribute name="test">count(<xsl:value-of select="sourceCombine/xpath"/>)<xsl:if test="sourceCombine/fallback"> + count(<xsl:value-of select="sourceCombine/fallback"/>)</xsl:if> &gt; 0</xsl:attribute>
                    <xsl:value-of select="sourceCombine/delimiter" />
                </xsl:element>
            </xsl:if>

        </xsl:if>
        <axsl:choose>
            <xsl:call-template name="copy-get-value-sourceCombine-option">
                <xsl:with-param name="optionval"><xsl:value-of select="sourceCombine/xpath"/></xsl:with-param>
            </xsl:call-template>
            <xsl:if test="sourceCombine/fallback">
                <xsl:call-template name="copy-get-value-sourceCombine-option">
                    <xsl:with-param name="optionval"><xsl:value-of select="sourceCombine/fallback"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="default">
                <axsl:otherwise>
                    <xsl:value-of select="default" />
                </axsl:otherwise>
            </xsl:if>
        </axsl:choose>
    </xsl:template>
    <xsl:template name="copy-get-value-sourceCombine-option">
        <xsl:param name="optionval" />
        <axsl:when test="{$optionval}">
            <axsl:for-each select="{$optionval}">
                <xsl:if test="contains(sourceCombine/enumerate, 'prefix')">
                    <xsl:call-template name="copy-enumerate">
                        <xsl:with-param name="startval">
                            <xsl:choose>
                                <xsl:when test="sourceCombine/prefix">2</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <axsl:value-of select="." />
                <xsl:if test="contains(sourceCombine/enumerate, 'postfix')">
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="copy-enumerate">
                        <xsl:with-param name="startval">
                            <xsl:choose>
                                <xsl:when test="sourceCombine/prefix">2</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="sourceCombine/delimiter">
                    <axsl:if test="generate-id(.) != generate-id({$optionval}[last()])">
                        <xsl:value-of select="sourceCombine/delimiter" />
                    </axsl:if>
                </xsl:if>
            </axsl:for-each>
        </axsl:when>
    </xsl:template>
    
    <xsl:template name="copy-enumerate">
        <xsl:param name="forcedval"/>
        <xsl:param name="startval"/>
        <xsl:choose>
            <xsl:when test="contains(sourceCombine/enumerate, 'parens')">
                <xsl:text>(</xsl:text>
                <xsl:choose>
                    <xsl:when test="$forcedval != ''"><xsl:value-of select="$forcedval"/></xsl:when>
                    <xsl:when test="$startval != ''"><axsl:value-of select="position() + {$startval - 1}"/></xsl:when>
                    <xsl:otherwise><axsl:value-of select="position()"/></xsl:otherwise>
                </xsl:choose>
                
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
       
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes xslt code that performs on the source value any post-
          processing (e.g., string substitution) called for in the crosswalk input file. 
          Whether processing is called for or not, the final result of the code generated by
          this template is the expression of a text value, ready for inclusion in the output 
          file.-->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template name="copy-process-value">
        <xsl:choose>
            <xsl:when test="stringReplace">
                <xsl:call-template name="copy-stringReplace"/>
            </xsl:when>
            <xsl:when test="substitutions">
                <xsl:call-template name="substitutions"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="destname">
                    <xsl:choose>
                        <xsl:when test="destination"><xsl:value-of select="destination"/></xsl:when>
                        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <axsl:value-of select="&#x24;{$destname}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- this template writes xslt code to perform any needed string replacements on
          the source data value and emits the result as a destination-ready text value -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->    
    <xsl:template name="copy-stringReplace">
        <xsl:variable name="destname">
            <xsl:choose>
                <xsl:when test="destination"><xsl:value-of select="destination"/></xsl:when>
                <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <axsl:call-template name="stringReplace">
            <axsl:with-param name="input"><axsl:value-of select="&#x24;{$destname}"/></axsl:with-param>
            <axsl:with-param name="find"><xsl:value-of select="stringReplace/find"/></axsl:with-param>
            <axsl:with-param name="replace"><xsl:value-of select="stringReplace/replace" /></axsl:with-param>
        </axsl:call-template>
    </xsl:template>
</xsl:stylesheet>
