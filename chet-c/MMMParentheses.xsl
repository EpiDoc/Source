<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">            

   <!--parentheses-->
  <xsl:template match="parentheses">
	<xsl:choose>
		<xsl:when test="idEst"><supplied reason="explanation"><xsl:value-of select="normalize-space()"  /></supplied></xsl:when>
		<xsl:when test="scil"><supplied reason="subaudible"><xsl:value-of select="normalize-space()" /></supplied></xsl:when>
		<xsl:when test="vacat"><xsl:call-template name="vacat"/></xsl:when>
        <xsl:otherwise><expan><xsl:apply-templates /></expan></xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  <!--vacats are handled in a called template simply for code readability-->
  <xsl:template name="vacat">
  	<!-- a questionMark element anywhere inside the parentheses is interpreted as an indication that this could have been a gap -->
	<xsl:variable name="spaceCert">
	    <xsl:choose>
	      <xsl:when test="questionMark">no</xsl:when>
	      <xsl:otherwise>yes</xsl:otherwise>
	    </xsl:choose>
	</xsl:variable>
	  
	<!-- test for extent uncertainty -->
	<!-- a circa element anywhere inside the parentheses is interpreted as an indication of imprecision in the extent of the vacat -->
	<xsl:variable name="extentCert">
	    <xsl:choose>
	      <xsl:when test="circa">no</xsl:when>
	      <xsl:otherwise>yes</xsl:otherwise>
	    </xsl:choose>
	</xsl:variable>
	
	<!--generate id for the space-->
	<xsl:variable name="generatedID">SPACE<xsl:value-of select="generate-id()"/></xsl:variable>
	
	<!--get the measurement of the vacat-->
	<xsl:variable name="measurement">
		<xsl:choose>
			<!--if measurements are in decimals, the decimal point will have been converted to a <dot/>, and so the 
			measurement will have been split into two text nodes; this code restores the original decimal point.-->
			<xsl:when test="dot"><xsl:value-of select="normalize-space(./text()[position() = last() - 1])"/>.<xsl:value-of select="normalize-space(./text()[position() = last()])"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space(./text()[position() = last()])"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!--find units; the default is 'character'-->
	<xsl:variable name="units">
		<xsl:choose> 
			<xsl:when test="string-length(normalize-space($measurement)) = 0">character</xsl:when>
			<xsl:when test="string(number($measurement)) = 'NaN'"><xsl:value-of select="translate($measurement, '1234567890.', '')"/></xsl:when>
			<xsl:otherwise>character</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!--find extent; the default is 1-->
	<xsl:variable name="extent">
		<xsl:choose>
			<xsl:when test="string-length($measurement) = 0">1</xsl:when>
			<xsl:when test="normalize-space($units) = 'character'"><xsl:value-of select="normalize-space($measurement)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="substring-before(normalize-space($measurement), normalize-space($units))"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!--create the <space/> element-->
	<space id="{$generatedID}" dim="horizontal" extent="{normalize-space($extent)}" unit="{normalize-space($units)}"/>
	<!-- write any needed certainty tags and their attributes -->
	<xsl:if test="$spaceCert='no'">
		<certainty target="{$generatedID}" locus="#gi" degree="lesser" assertedValue="gap"/>
	</xsl:if>
	  
	<xsl:if test="$extentCert='no'">
		<certainty target="{$generatedID}" locus="extent" degree="lesser"/>
	</xsl:if>
  </xsl:template>
  
</xsl:stylesheet>