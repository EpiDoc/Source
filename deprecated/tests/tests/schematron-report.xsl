<?xml version="1.0" ?>
<!-- Report Generator for the Schematron XML Schema Language.
	http://www.ascc.net/xml/resource/schematron/schematron.html
   
 Copyright (c) 2000,2001 David Calisle, Oliver Becker,
	 Rick Jelliffe and Academia Sinica Computing Center, Taiwan

 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the authors be held liable for any damages arising from 
 the use of this software.

 Permission is granted to anyone to use this software for any purpose, 
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim
 that you wrote the original software. If you use this software in a product, 
 an acknowledgment in the product documentation would be appreciated but is 
 not required.

 2. Altered source versions must be plainly marked as such, and must not be 
 misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.

    1999-10-25  Version for David Carlisle's schematron-report error browser
    1999-11-5   Beta for 1.2 DTD
    1999-12-26  Add code for namespace: thanks DC
    1999-12-28  Version fix: thanks Uche Ogbuji
    2000-03-27  Generate version: thanks Oliver Becker
    2000-10-20  Fix '/' in do-all-patterns: thanks Uche Ogbuji
    2001-02-15  Port to 1.5 code
    2001-03-15  Diagnose test thanks Eddie Robertsson
-->

<!-- Schematron report -->

<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
   xmlns:fn="http://www.w3.org/2005/xpath-functions">

<xsl:import href="skeleton1-5.xsl"/>
 <xsl:output method="xml" standalone="yes" omit-xml-declaration="no"/>
<xsl:param name="diagnose">yes</xsl:param>     

<xsl:template name="process-prolog">
   <axsl:output method="html" />
</xsl:template>

<xsl:template name="process-root">
   <xsl:param name="title" />
   <xsl:param name="icon" />
   <xsl:param name="contents" />
   <html>
      <style>
         body {
            font-family:"Lucida Grande", Verdana, Arial, Helvetica;
         }
         h3 { 
            background-color:black; 
            color:white;
            font-size:16pt; 
            padding: 3px;
            margin-bottom: 2px;
         }
         h3.linked { 
            background-color:black; 
            color:white;
            font-size:12pt; 
         }
         li {
            margin: 3px;
            padding: 2px;
         }
         .success {
            background: #D6FF9F;
            color: #007000;
         }
         .error {
            background: #FFCCCC;
            color: #CC3300;
         }
         .markup {
            font-family:"Courier New", Courier, monospace;
            font-size: smaller;
            font-weight: bold;
            color: #005577;
         }
      </style>
      <h2 title="Schematron contact-information is at the end of 
                 this page">
         <xsl:if test="$icon"><img src="{$icon}" /></xsl:if>
         <font color="#FF0080" >Schematron</font> Report
      </h2>
      <h1 title="{@ns} {@fpi}">
         <xsl:value-of select="$title" />
      </h1>
      <div class="errors">
         <ul>
            <xsl:copy-of select="$contents" />
         </ul>
      </div>
      <hr color="#FF0080" />
      <p><font size="2">Schematron Report by David Carlisle.
      <a href="http://www.ascc.net/xml/resource/schematron/schematron.html"
         title="Link to the home page of the Schematron, 
                a tree-pattern schema language">
         <font color="#FF0080" >The Schematron</font>
      </a> by
      <a href="mailto:ricko@gate.sinica.edu.tw"
         title="Email to Rick Jelliffe (pronounced RIK JELIF)"
      >Rick Jelliffe</a>,
      <a href="http://www.sinica.edu.tw"
         title="Link to home page of Academia Sinica"
      >Academia Sinica Computing Centre</a>.
      </font></p>
   </html>
</xsl:template>

<xsl:template name="process-p">
   <xsl:param name="icon" />
<p><xsl:if test="$icon"><img src="{$icon}" /> </xsl:if
><xsl:apply-templates mode="text"/></p>
</xsl:template>

<xsl:template name="process-pattern">
   <xsl:param name="icon" />
   <xsl:param name="name" />
   <xsl:param name="see" />
   <xsl:choose>
      <xsl:when test="$see">
         <a href="{$see}" target="SRDOCO" 
            title="Link to User Documentation:">
            <h3 class="linked">
               <xsl:value-of select="$name" />
            </h3>
         </a>
      </xsl:when>
      <xsl:otherwise>
         <h3><xsl:value-of select="$name" /></h3>
      </xsl:otherwise>
   </xsl:choose>
   <xsl:if test="$icon"><img src="{$icon}" /> </xsl:if>
</xsl:template>

<!-- use default rule for process-name: output name -->

<xsl:template name="process-assert" xml:space="preserve">
   <xsl:param name="icon" />
   <xsl:param name="pattern" />
   <xsl:param name="role" />
   <xsl:param name="diagnostics" />
   <li class="error">
   <xsl:if test="$icon"><img src="{$icon}" /> </xsl:if>
         <i><xsl:value-of select="$role"/></i>
         <xsl:apply-templates mode="text"/>
         <xsl:if test="$diagnose = 'yes'">
          <b><xsl:call-template name="diagnosticsSplit">
               <xsl:with-param name="str" select="$diagnostics" />
           </xsl:call-template></b>
         </xsl:if>
   </li>                    
</xsl:template>

<xsl:template name="process-report" xml:space="preserve">
   <xsl:param name="pattern" />
   <xsl:param name="icon" />
   <xsl:param name="role" />
   <xsl:param name="diagnostics" />
   <li class="success">
   <xsl:if test="$icon"><img src="{$icon}" /> </xsl:if>
         <i><xsl:value-of select="$role"/></i>
         <xsl:apply-templates mode="text"/>
          <b><xsl:call-template name="diagnosticsSplit">
               <xsl:with-param name="str" select="$diagnostics" />
           </xsl:call-template></b>
   </li>
</xsl:template>
   
<xsl:template name="process-span" xml:space="preserve">
   <xsl:param name="class"/>
   <span class="{$class}"><xsl:apply-templates mode="text"/></span>
</xsl:template>


</xsl:stylesheet>
