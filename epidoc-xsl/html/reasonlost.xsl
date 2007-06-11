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
 

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!--        Square bracket handling templates for *[@reason='lost']        -->    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!--     OPEN BRACKET     -->
<xsl:template name="reasonlostopen">
   <xsl:choose>
   	<xsl:when test="parent::tei:item">
   		<!-- (0.) we're in the guidelines, just print the damned bracket -->
   		<xsl:text>[</xsl:text>
   	</xsl:when>
		<xsl:when test="preceding-sibling::*[1][@reason='lost']">
		        <!-- (1.) Simple siblings -->
		        <xsl:if test="preceding-sibling::text() and preceding-sibling::*[1][following-sibling::text()]">
				<!-- test for intervening text node -->
				<xsl:variable name="curr-prec" select="generate-id(preceding-sibling::text()[1])"/>
				<xsl:for-each select="preceding-sibling::*[1][@reason='lost']">
				  <xsl:choose>
				  	<xsl:when test="generate-id(following-sibling::text()[1]) = $curr-prec and not(following-sibling::text()[1]=' ')">
						<!-- 1.a when text node not only whitespace: need bracket -->
						<xsl:text>[</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- 1.b when text node only single space: no bracket -->
					</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
		</xsl:when>
		<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1][@reason='lost']]]">
			<!-- (2.) first preceding sibling of parent: no bracket -->
		</xsl:when>
		<xsl:when test="preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']">
			<!-- (3.) final element of first preceding sibling: no bracket -->
		</xsl:when>
		<xsl:when test="current()[not(preceding-sibling::*)][not(preceding-sibling::text())][parent::*[preceding-sibling::*[1]/*[not(following-sibling::*)][not(following-sibling::text())][@reason='lost']]]">
			<!-- (4.) final element of parent's first preceding sibling: no bracket -->
		</xsl:when>
    <xsl:otherwise>
      <xsl:text>[</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!--     CLOSE BRACKET     -->

<xsl:template name="reasonlostclose">
   <xsl:choose>
   	<xsl:when test="parent::tei:item">
   		<!-- (0.) we're in the guidelines, just print the damned bracket -->
   		<xsl:text>]</xsl:text>
   	</xsl:when>
    <xsl:when test="following-sibling::*[1][@reason='lost']">
      <!-- (1.) Simple siblings -->
        <xsl:if test="following-sibling::text() and following-sibling::*[1][preceding-sibling::text()]">
  <!-- test for intervening text node -->
          <xsl:variable name="curr-foll" select="generate-id(following-sibling::text()[1])"/>
    	    <xsl:for-each select="following-sibling::*[1][@reason='lost']">
      		  <xsl:choose>
      		    <xsl:when test="generate-id(preceding-sibling::text()[1]) = $curr-foll and not(preceding-sibling::text()[1]=' ')">
		    <!-- 1.a when text node not only whitespace: need bracket -->
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
		<!-- 1.b when text node only single space: no bracket -->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
	</xsl:when>
	<xsl:when test="following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']">
		<!-- (2.) first following sibling of parent: no bracket -->
	</xsl:when>
	<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1][@reason='lost']]]">
		<!-- (3.) first element of first following sibling: no bracket -->
	</xsl:when>
	<xsl:when test="current()[not(following-sibling::*)][not(following-sibling::text())][parent::*[following-sibling::*[1]/*[not(preceding-sibling::*)][not(preceding-sibling::text())][@reason='lost']]]">
		<!-- (4.) first element of parent's first following sibling: no bracket -->
	</xsl:when>
	<xsl:otherwise>
        <!-- all other cases: need closing bracket -->
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

</xsl:stylesheet>
