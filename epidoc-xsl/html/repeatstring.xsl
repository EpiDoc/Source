<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
  
    <!-- ================================================================================= -->
    <!-- callable template for repeating strings in output                                                                  -->
    <!-- ================================================================================= -->

    <xsl:template name="repeatstring">
      <xsl:param name="rstring"/>
      <xsl:param name="rcount"/>
      <xsl:if test="$rcount &gt; 0"
         ><xsl:value-of select="$rstring"
            /><xsl:call-template name="repeatstring"
            ><xsl:with-param name="rstring"  select="$rstring"
            /><xsl:with-param name="rcount" select="$rcount - 1"/></xsl:call-template
         ></xsl:if>
   </xsl:template>
</xsl:stylesheet>
