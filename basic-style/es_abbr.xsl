<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="abbr[not(@expan)]">
    <xsl:apply-templates /><xsl:text>(---)</xsl:text>
  </xsl:template>
  <xsl:template match="abbr[@expan]">
		<xsl:call-template name="resolveAbbr">
			<xsl:with-param name="str1" select="@expan"/>
			<xsl:with-param name="str2">
				<xsl:apply-templates/>
			</xsl:with-param>
			<xsl:with-param name="position1">1</xsl:with-param>
			<xsl:with-param name="position2">1</xsl:with-param>
			<xsl:with-param name="open">false</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="resolveAbbr">
		<xsl:param name="str1"/>	<!--the expansion -->
		<xsl:param name="str2"/> 	<!--the abbreviation -->
		<xsl:param name="position1"/> <!--the current position in str1 -->
		<xsl:param name="position2"/> <!--the current position in str2 -->
		<xsl:param name="open"/>  <!-- indicates whether a parenthesis has been opened -->
		<xsl:param name="prevchr"/>  <!--the previous character processed in $str2 -->
		<xsl:choose>
			<xsl:when test="(substring($str2, $position2, 1) = '[') or (substring($str2, $position2, 1) = ']') or (substring($str2, $position2, 1) = '&lt;') or (substring($str2, $position2, 1) = '&gt;')">
				<xsl:value-of select="substring($str2, $position2, 1)"/>
				<xsl:call-template name="resolveAbbr">
					<xsl:with-param name="str1" select="$str1"/>
					<xsl:with-param name="str2" select="string($str2)"/>
					<xsl:with-param name="position1" select="$position1"/>
					<xsl:with-param name="position2" select="$position2+1"/>
					<xsl:with-param name="open" select="$open"/>
					<xsl:with-param name="prevchr" select="$prevchr"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="substring($str1, $position1, 1) = substring($str2, $position2, 1) and string-length($str2) &gt;= $position2">
				<xsl:if test="$open='true'">)</xsl:if>
				<xsl:value-of select="substring($str1, $position1, 1)"/>
				<xsl:call-template name="resolveAbbr">
					<xsl:with-param name="str1" select="$str1"/>
					<xsl:with-param name="str2" select="string($str2)"/>
					<xsl:with-param name="position1" select="$position1+1"/>
					<xsl:with-param name="position2" select="$position2+1"/>
					<xsl:with-param name="open">false</xsl:with-param>
					<xsl:with-param name="prevchr" select="substring($str2, $position2, 1)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="substring($str1, $position1, 1) != substring($str2, $position2, 1) and string-length($str2) &gt;= $position2">
				<xsl:choose>
					<xsl:when test="substring($str2, $position2, 1) = $prevchr">
						<xsl:value-of select="substring($str2, $position2, 1)"/>
						<xsl:call-template name="resolveAbbr">
							<xsl:with-param name="str1" select="$str1"/>
							<xsl:with-param name="str2" select="string($str2)"/>
							<xsl:with-param name="position1" select="$position1"/>
							<xsl:with-param name="position2" select="$position2 + 1"/>
							<xsl:with-param name="open" select="$open"/>
							<xsl:with-param name="prevchr" select="substring($str2, $position2, 1)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$open='false'">(</xsl:if>
						<xsl:value-of select="substring($str1, $position1, 1)"/>
						<xsl:call-template name="resolveAbbr">
							<xsl:with-param name="str1" select="$str1"/>
							<xsl:with-param name="str2" select="string($str2)"/>
							<xsl:with-param name="position1" select="$position1+1"/>
							<xsl:with-param name="position2" select="$position2"/>
							<xsl:with-param name="open">true</xsl:with-param>
							<xsl:with-param name="prevchr" select="substring($str2, $position2, 1)"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>(<xsl:value-of select="substring($str1, $position1)"/>)</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  </xsl:stylesheet>
