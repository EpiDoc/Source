<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1" xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:output method="xml" indent="yes" encoding="UTF-8" />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-10                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-10                    		 -->
<!-- PURPOSE:   Step 1/3 Creates index of personal names 					 -->
<!-- CREATED FOR:  Epidoc demo                           					 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:template match="/">

	<body>
		<xsl:for-each select="//persName">
			<xsl:sort select="@reg" order="ascending" />			
				<word>
					<xsl:choose>
						<xsl:when test="@reg">
							<head reg="true">
								<xsl:value-of select="normalize-space(@reg)" />
							</head>
						</xsl:when>
						<xsl:otherwise>
								<head>
									<xsl:value-of select="normalize-space(.)" />
								</head>
						</xsl:otherwise>
					</xsl:choose>
					<epidoc>
						<xsl:if test="descendant::*[@cert='low'] or ancestor-or-self::*[@cert='low']">
							<xsl:attribute name="cert">
             	</xsl:attribute>
						</xsl:if>
						<xsl:if test="descendant::supplied or ancestor::supplied">
							<xsl:attribute name="sup">
             	</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="substring-before(ancestor::dir:file/@name, '.xml')" />
					</epidoc>
					<line>
						<xsl:value-of select="preceding::lb[1]/@n" />
					</line>
					<type>
						<xsl:value-of select="normalize-space(@type)"/>
					</type>
				</word>
		</xsl:for-each>
	</body>
</xsl:template>


</xsl:stylesheet>