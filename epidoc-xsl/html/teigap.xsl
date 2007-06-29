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
    <!-- gap introduced by editor for ellipsis -->    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="tei:gap[@reason='ellipsis']">
		<xsl:element name="span">
			<xsl:attribute name="class">editorial ellipsis</xsl:attribute>
			<xsl:attribute name="title">ellipsis introduced by the editor for the sake of brevity or emphasis</xsl:attribute>
			<xsl:text>...</xsl:text>
		</xsl:element>
	</xsl:template>


    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- Letters omitted because the stonecutter did not carry out the text to the end -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="tei:gap[@reason='omitted']">
		<xsl:text>&lt;- - -&gt;</xsl:text>
	</xsl:template>
    

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- illegible gap measured in characters -->    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="tei:gap[@reason='illegible' and @unit!='line']">
		<xsl:variable name="illegiblemaxrepeat">4</xsl:variable>
		<xsl:variable name="illegibleopener"></xsl:variable>
		<xsl:variable name="illegiblecloser"></xsl:variable>
		<xsl:variable name="illegibleextentstring">
			<xsl:call-template name="calcvestigeextentstring">
				<xsl:with-param name="gapmaxrepeat">
					<xsl:value-of select="$illegiblemaxrepeat"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="class">illegible</xsl:attribute>
			<xsl:attribute name="title">put title here!</xsl:attribute>
			<xsl:value-of select="$illegibleopener"/>
			<xsl:value-of select="$illegibleextentstring"/>
			<xsl:value-of select="$illegiblecloser"/>
		</xsl:element>

	</xsl:template>

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- lost gap measured in lines -->    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="tei:gap[@reason='lost' and @unit='line']">
		<xsl:variable name="gaplinelen">15</xsl:variable>
		<xsl:variable name="gapid">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<xsl:variable name="gapopener">[</xsl:variable>
		<xsl:variable name="gapcloser">]</xsl:variable>
		<xsl:choose>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low'] and @precision='circa'">
                 <xsl:text>&#160;</xsl:text>
		 <xsl:call-template name="repeatstring">
		 	<xsl:with-param name="rstring">
				<xsl:text>-&#160;</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="rcount">
				<xsl:value-of select="$gaplinelen"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>?&#160;</xsl:text>                
            </xsl:when>
		<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low']">
			<!-- <xsl:value-of select="$gapopener"/> -->
			<xsl:call-template name="reasonlostopen"/>
			<xsl:text>&#160;</xsl:text>
			<xsl:call-template name="repeatstring">
				<xsl:with-param name="rstring">
					<xsl:text>-&#160;</xsl:text>
				</xsl:with-param>
			<xsl:with-param name="rcount">
				<xsl:value-of select="$gaplinelen"/>
			</xsl:with-param>
			</xsl:call-template>
			<xsl:text>?&#160;</xsl:text>
			<!-- <xsl:value-of select="$gapcloser"/> -->
			<xsl:call-template name="reasonlostclose"/>
		</xsl:when>
			<xsl:when test="@id and @precision='circa'">
				 <xsl:text>&#160;</xsl:text>
				 <xsl:call-template name="repeatstring">
					 <xsl:with-param name="rstring">
					 	<xsl:text>-&#160;</xsl:text>
					 </xsl:with-param>
					<xsl:with-param name="rcount">
						<xsl:value-of select="$gaplinelen"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			<!-- <xsl:value-of select="$gapopener"/> -->
			<xsl:call-template name="reasonlostopen"/>
				<xsl:text>&#160;</xsl:text>
				<xsl:call-template name="repeatstring">
					<xsl:with-param name="rstring">
						<xsl:text>-&#160;</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="rcount">
						<xsl:value-of select="$gaplinelen"/>
					</xsl:with-param>
				</xsl:call-template>
			<!-- <xsl:value-of select="$gapcloser"/> -->
			<xsl:call-template name="reasonlostclose"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- lost gap measured in units other than lines -->    
   <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="tei:gap[@reason='lost' and @unit != 'line']">
		<xsl:variable name="gapmaxrepeat">4</xsl:variable>
		<xsl:variable name="gapopener">
			<xsl:choose>
				<xsl:when test="ancestor::tei:del[@rend='erasure']">
					<xsl:text>&#160;[</xsl:text>
				</xsl:when>
				<xsl:otherwise>
			<xsl:call-template name="reasonlostopen"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gapcloser">
			<xsl:choose>
				<xsl:when test="ancestor::tei:del[@rend='erasure']">
					<xsl:text>]&#160;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="reasonlostclose"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gapextentstring">
			<xsl:call-template name="calcgapextentstring">
				<xsl:with-param name="gapmaxrepeat">
					<xsl:value-of select="$gapmaxrepeat"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="class">gap-lost</xsl:attribute>
			<xsl:attribute name="title">put title here!</xsl:attribute>
			<xsl:value-of select="$gapopener" />
			<xsl:value-of select="$gapextentstring" />
			<xsl:value-of select="$gapcloser"/>
		</xsl:element>
	</xsl:template> 
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- callable template for determining string based on gap extent -->    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="calcgapextentstring">
		<xsl:param name="gapmaxrepeat">4</xsl:param>
		<xsl:variable name="gapid">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low']">
				<xsl:choose>
					<xsl:when test="@precision='circa'">
						<xsl:choose>
							<xsl:when test="@unit='character'">&#160;&#183;&#160;c.<xsl:value-of select="@extent"/>
								<xsl:if test="@extentmax">
									<xsl:text>-</xsl:text>
									<xsl:value-of select="@extentmax"/>
								</xsl:if>&#160;&#183;&#160;?&#160;</xsl:when>
							<xsl:otherwise>
								<xsl:element name="span">
									<xsl:attribute name="class">error</xsl:attribute>&#160;-&#160;c.<xsl:value-of select="@extent"/>
									<xsl:value-of select="@unit"/>&#160;-&#160;?&#160;</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				<xsl:when test="//tei:certainty[@target=$gapid and @locus='unit' and @degree='low']">&#160;<xsl:call-template name="repeatstring">
					<xsl:with-param name="rcount"><xsl:value-of select="@extent"/></xsl:with-param>
						<xsl:with-param name="rstring">-&#160;?&#160;</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@unit='character' and not(@extentmax) and @extent &lt; $gapmaxrepeat">&#160;<xsl:call-template name="repeatstring">
							<xsl:with-param name="rstring">&#183;&#160;</xsl:with-param>
							<xsl:with-param name="rcount"><xsl:value-of select="@extent"/>
							</xsl:with-param>
							</xsl:call-template>?&#160;</xsl:when>
						<xsl:when test="@unit='character' and @extent &gt; $gapmaxrepeat - 1">&#160;&#183;&#160;<xsl:value-of select="@extent"/>&#160;&#183;&#160;?&#160;</xsl:when>
						<xsl:otherwise>&#160;-&#160;<xsl:value-of select="@extent"/>
							<xsl:value-of select="@unit"/>&#160;-&#160;?&#160;</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
			<xsl:when test="@id and @precision='circa'">
				<xsl:choose>
					<xsl:when test="@unit='character'">&#160;&#183;&#160;c.<xsl:value-of select="@extent"/>
						<xsl:if test="@extentmax">
							<xsl:text>-</xsl:text>
							<xsl:value-of select="@extentmax"/>
						</xsl:if>&#160;&#183;&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class">error</xsl:attribute>&#160;-&#160;c.<xsl:value-of select="@extent"/>
							<xsl:value-of select="@unit"/>&#160;-&#160;</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='unit' and @degree='low']">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rcount"><xsl:value-of select="@extent"/>
					</xsl:with-param>
					<xsl:with-param name="rstring">-&#160;</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@unit='character' and not(@extentmax) and @extent &lt; $gapmaxrepeat">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rstring">&#183;&#160;</xsl:with-param>
							<xsl:with-param name="rcount">
								<xsl:value-of select="@extent"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@unit='character' and @extent &gt; $gapmaxrepeat - 1">&#160;&#183;&#160;<xsl:value-of select="@extent"/>
						<xsl:if test="@extentmax">
							<xsl:text>-</xsl:text>
							<xsl:value-of select="@extentmax"/>
						</xsl:if>&#160;&#183;&#160;</xsl:when>
					<xsl:otherwise>&#160;-&#160;<xsl:value-of select="@extent"/>
						<xsl:if test="@extentmax">
							<xsl:text>-</xsl:text>
							<xsl:value-of select="@extentmax"/>
						</xsl:if>
						<xsl:if test="@unit != 'character'">
							<xsl:value-of select="@unit"/>
						</xsl:if>&#160;-&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- callable template for determining string based on vestige extent -->    
   <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="calcvestigeextentstring">
		<xsl:param name="gapmaxrepeat">4</xsl:param>
		<xsl:variable name="gapid">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low'] and @precision='circa'">
				<xsl:choose>
					<xsl:when test="@unit='character'">&#160;+&#160;c.<xsl:value-of select="@extent"/>
						<xsl:if test="@unit != 'character'">
							<xsl:value-of select="@unit"/>
						</xsl:if>&#160;+&#160;?&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class">error</xsl:attribute>&#160;+&#160;c.<xsl:value-of select="@extent"/>
							<xsl:value-of select="@unit"/>&#160;+&#160;?&#160;</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low'] and //tei:certainty[@target=$gapid and @locus='unit' and @degree='low']">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rcount"><xsl:value-of select="@extent"/>
					</xsl:with-param>
					<xsl:with-param name="rstring">+&#160;?&#160;</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='#gi' and @degree='low']">
				<xsl:choose>
					<xsl:when test="@unit='character' and @extent &lt; $gapmaxrepeat">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rstring">+&#160;</xsl:with-param>
							<xsl:with-param name="rcount">
								<xsl:value-of select="@extent"/>
							</xsl:with-param>
						</xsl:call-template>?&#160;</xsl:when>
					<xsl:when test="@unit='character' and @extent &gt; $gapmaxrepeat - 1">&#160;+&#160;<xsl:value-of select="@extent"/>&#160;+&#160;?&#160;</xsl:when>
					<xsl:otherwise>&#160;+&#160;<xsl:value-of select="@extent"/>
						<xsl:value-of select="@unit"/>&#160;+&#160;?&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@id and @precision='circa'">
				<xsl:choose>
					<xsl:when test="@unit='character'">&#160;+&#160;c.<xsl:value-of select="@extent"/>&#160;+&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class">error</xsl:attribute>&#160;+&#160;c.<xsl:value-of select="@extent"/>
							<xsl:value-of select="@unit"/>&#160;+&#160;</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@id and //tei:certainty[@target=$gapid and @locus='unit' and @degree='low']">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rcount"><xsl:value-of select="@extent"/>
					</xsl:with-param>
					<xsl:with-param name="rstring">+&#160;</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@unit='character' and @extent &lt; $gapmaxrepeat">&#160;<xsl:call-template name="repeatstring"><xsl:with-param name="rstring">+&#160;</xsl:with-param>
							<xsl:with-param name="rcount">
								<xsl:value-of select="@extent"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@unit='character' and @extent &gt; $gapmaxrepeat - 1">&#160;+&#160;<xsl:value-of select="@extent"/>&#160;+&#160;</xsl:when>
					<xsl:otherwise>&#160;+&#160;<xsl:value-of select="@extent"/>
						<xsl:value-of select="@unit"/>&#160;+&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
