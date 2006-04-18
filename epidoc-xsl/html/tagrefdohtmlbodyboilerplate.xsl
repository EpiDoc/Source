<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace">
    <xsl:key name="exempla-by-element" match="tei:item[@type='exemplum']"
        use="tei:seg[@type='tagi']" />
    <xsl:template name="dohtmlbodyboilerplate">
        <xsl:param name="doctitleprefix" />
        <!-- options: floating, no -->
        <xsl:element name="body">
            <!-- create an html div to function as the header -->
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$htmlheaderdivid" />
                </xsl:attribute>
                <xsl:element name="h1">
                    <xsl:value-of select="$doctitleprefix" />
                    <xsl:call-template name="getdoctitle" />
                </xsl:element>
            </xsl:element>
            <!-- create an html div to contain the rest of the document content -->
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$htmlcontentdivid" />
                </xsl:attribute>
                <xsl:apply-templates select="//tei:list[@type='exempla']" mode="tagref"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:list[@type='exempla']" mode="tagref">
        <xsl:element name="ul">
            <xsl:for-each select="tei:item[count(. | key('exempla-by-element', tei:seg)[1]) = 1]">
                <xsl:sort select="tei:seg" />
                <xsl:element name="li">&lt;<xsl:value-of select="tei:seg" />&gt;:<br />
                    <xsl:element name="ul">
                        <xsl:for-each select="key('exempla-by-element', tei:seg)">
                            <xsl:sort select="name(tei:list/tei:item/*[1])"/>
                            <xsl:sort select="name(tei:list/tei:item/*[1]/@*[1])"/>
                            <xsl:sort select="tei:list/tei:item/*[1]/@*[1]"/>
                            <xsl:sort select="name(tei:list/tei:item/*[1]/@*[2])"/>
                            <xsl:sort select="tei:list/tei:item/*[1]/@*[2]"/>
                            <xsl:sort select="name(tei:list/tei:item/*[1]/@*[3])"/>
                            <xsl:sort select="tei:list/tei:item/*[1]/@*[3]"/>
                            <xsl:sort select="name(tei:list/tei:item/*[1]/*[1])"/>
                            <xsl:sort select="name(tei:list/tei:item/*[1]/*[1]/@*[1])"/>

                            <xsl:element name="li"><xsl:apply-templates mode="process-item-children" select="tei:list/tei:item/*|text()" /><br/>
                            See:&#160;<xsl:apply-templates select="tei:xref"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
