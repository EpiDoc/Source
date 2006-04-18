<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="count(ancestor::*) = 0">
                <xsl:call-template name="dohtmlheadboilerplate" />
                <xsl:call-template name="dohtmlbodyboilerplate" />
            </xsl:when>
            <xsl:when test="ancestor::tei:div[@rend][1]/@rend='multipart' or (count(ancestor::tei:div[@rend]) = 0 and ancestor::tei:TEI.2/@rend='multipart') ">
                <!--<xsl:if test="@id and not(contains(ancestor-or-self::tei:div/@type, 'gl-')) and
                not(not(@rend) and not(../@rend))">
                <xsl:call-template name="multipartpopdown"/></xsl:if>-->
                <xsl:choose>
                    <xsl:when test="@id and not(contains(ancestor-or-self::tei:div/@type, 'gl-')) and not(not(@rend) and not(../@rend))">
                        <xsl:call-template name="multipartpopdown"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                            <xsl:apply-templates/></xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- this div is part of a TEI.2 document or is a subordinate div -->
                <xsl:choose>
                    <xsl:when test="not(@type) or @type != 'gl-edition'">
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                            <xsl:apply-templates/></xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- make div for human-readable version of encoding -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">gl-encoding</xsl:attribute>
                            <xsl:element name="h3">EpiDoc Encoding</xsl:element>
                            <xsl:element name="ol">
                                <xsl:for-each select="./tei:list/tei:item">
                                    <xsl:element name="li"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute><xsl:apply-templates mode="process-item-children"/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                        <!-- make div for xslt processing as an edition -->
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:attribute name="class">gl-edition</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>
