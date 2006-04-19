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
 

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="writehtmlmeta">
        <xsl:param name="name"/>
        <xsl:param name="content"/>
        <xsl:call-template name="writehtmlmetaprefix"/>
        
        <xsl:if test="string-length($name) &gt; 0 and string-length($content) &gt; 0">
            <xsl:element name="meta">
                <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
                <xsl:attribute name="content"><xsl:value-of select="$content"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        
        <xsl:call-template name="writehtmlmetapostfix"/>
    </xsl:template>
    
    <xsl:template name="writehtmlmetaprefix"/>
    <xsl:template name="writehtmlmetapostfix"/>
</xsl:stylesheet>
