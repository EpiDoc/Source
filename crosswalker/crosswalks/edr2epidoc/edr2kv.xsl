<?xml version="1.0" encoding="UTF-8"?><axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:vdex="http://www.imsglobal.org/xsd/imsvdex_v1p0" version="1.0"><axsl:import href="../../generator//stringReplace.xsl"/><axsl:output indent="no" method="xml" encoding="UTF-8"/><axsl:template match="/">
    
    


    <axsl:element name="inscriptiones">
        <axsl:for-each select="//epigr">
            <axsl:element name="inscriptio">

                
                <axsl:element name="filename"><axsl:variable name="filename"><axsl:choose><axsl:when test="id_nr"><axsl:value-of select="normalize-space(id_nr)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$filename"/></axsl:element>

                
                <axsl:element name="numerus">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="id_nr"><axsl:value-of select="normalize-space(id_nr)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="regio_ant">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="provinz"><axsl:value-of select="normalize-space(provinz)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="regio_nos">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="land"><axsl:value-of select="normalize-space(land)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="land"><axsl:value-of select="normalize-space(land)"/></axsl:when></axsl:choose></axsl:variable><axsl:for-each select="document('../thesauri/edrcountrycodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$key and vdex:targetTerm/@vocabularyIdentifier='countrycodes']"><axsl:value-of select="vdex:targetTerm"/></axsl:for-each></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="land"><axsl:value-of select="normalize-space(land)"/></axsl:when></axsl:choose></axsl:variable><axsl:for-each select="document('../thesauri/edrcountrycodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$reg and vdex:targetTerm/@vocabularyIdentifier='countrycodes']"><axsl:variable name="targetTermID"><axsl:value-of select="vdex:targetTerm"/></axsl:variable><axsl:for-each select="document('../thesauri/countrycodes.xml')/descendant::vdex:term[vdex:termIdentifier=$targetTermID][1]"><axsl:value-of select="vdex:caption/vdex:langstring[1]"/></axsl:for-each></axsl:for-each></axsl:element>
                </axsl:element>

                
                <axsl:element name="urbs_ant">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="fo_antik"><axsl:value-of select="normalize-space(fo_antik)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="urbs_nos">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="fo_modern"><axsl:value-of select="normalize-space(fo_modern)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="loc_inv">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="fundstelle"><axsl:value-of select="normalize-space(fundstelle)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="loc_ads">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="aufbewahrung"><axsl:value-of select="normalize-space(aufbewahrung)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="rer_distrib">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="denkmaltyp"><axsl:value-of select="normalize-space(denkmaltyp)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="denkmaltyp"><axsl:value-of select="normalize-space(denkmaltyp)"/></axsl:when></axsl:choose></axsl:variable><axsl:call-template name="stringReplace"><axsl:with-param name="input"><axsl:value-of select="$key"/></axsl:with-param><axsl:with-param name="find"><axsl:text>, </axsl:text></axsl:with-param><axsl:with-param name="replace"><axsl:text>_</axsl:text></axsl:with-param></axsl:call-template></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="denkmaltyp"><axsl:value-of select="normalize-space(denkmaltyp)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$reg"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="rei_mat">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="material"><axsl:value-of select="normalize-space(material)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="material"><axsl:value-of select="normalize-space(material)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$key"/></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="material"><axsl:value-of select="normalize-space(material)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$reg"/></axsl:element>

                </axsl:element>

                
                
                <axsl:element name="scriptura">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="scriptura"><axsl:value-of select="normalize-space(scriptura)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="scriptura"><axsl:value-of select="normalize-space(scriptura)"/></axsl:when></axsl:choose></axsl:variable><axsl:call-template name="stringReplace"><axsl:with-param name="input"><axsl:value-of select="$key"/></axsl:with-param><axsl:with-param name="find"><axsl:text> </axsl:text></axsl:with-param><axsl:with-param name="replace"><axsl:text>_</axsl:text></axsl:with-param></axsl:call-template></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="scriptura"><axsl:value-of select="normalize-space(scriptura)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$reg"/></axsl:element>

                </axsl:element>

                
                <axsl:element name="lingua">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="lingua"><axsl:value-of select="normalize-space(lingua)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:variable name="orig"><axsl:choose><axsl:when test="lingua"><axsl:value-of select="normalize-space(lingua)"/></axsl:when></axsl:choose></axsl:variable><axsl:choose><axsl:when test="contains($orig, '-')"><axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:value-of select="substring-before($orig, '-')"/></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$key and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:value-of select="vdex:targetTerm"/></axsl:for-each></axsl:attribute><axsl:variable name="reg"><axsl:value-of select="substring-before($orig, '-')"/></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$reg and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:variable name="targetTermID"><axsl:value-of select="vdex:targetTerm"/></axsl:variable><axsl:for-each select="document('../thesauri/languagecodes.xml')/descendant::vdex:term[vdex:termIdentifier=$targetTermID][1]"><axsl:value-of select="vdex:caption/vdex:langstring[1]"/></axsl:for-each></axsl:for-each></axsl:element><axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:value-of select="substring-after($orig, '-')"/></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$key and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:value-of select="vdex:targetTerm"/></axsl:for-each></axsl:attribute><axsl:variable name="reg"><axsl:value-of select="substring-after($orig, '-')"/></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$reg and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:variable name="targetTermID"><axsl:value-of select="vdex:targetTerm"/></axsl:variable><axsl:for-each select="document('../thesauri/languagecodes.xml')/descendant::vdex:term[vdex:termIdentifier=$targetTermID][1]"><axsl:value-of select="vdex:caption/vdex:langstring[1]"/></axsl:for-each></axsl:for-each></axsl:element></axsl:when><axsl:otherwise><axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="lingua"><axsl:value-of select="normalize-space(lingua)"/></axsl:when></axsl:choose></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$key and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:value-of select="vdex:targetTerm"/></axsl:for-each></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="lingua"><axsl:value-of select="normalize-space(lingua)"/></axsl:when></axsl:choose></axsl:variable><axsl:for-each select="document('../thesauri/edrlanguagecodes.xml')/descendant::vdex:relationship[vdex:sourceTerm=$reg and vdex:targetTerm/@vocabularyIdentifier='languagecodes']"><axsl:variable name="targetTermID"><axsl:value-of select="vdex:targetTerm"/></axsl:variable><axsl:for-each select="document('../thesauri/languagecodes.xml')/descendant::vdex:term[vdex:termIdentifier=$targetTermID][1]"><axsl:value-of select="vdex:caption/vdex:langstring[1]"/></axsl:for-each></axsl:for-each></axsl:element></axsl:otherwise></axsl:choose><!--wahhoooooooooo-->
                </axsl:element>

                
                
                <axsl:element name="tit_distrib">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="i_gattung"><axsl:value-of select="normalize-space(i_gattung)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    <axsl:element name="reg"><axsl:attribute name="key"><axsl:variable name="key"><axsl:choose><axsl:when test="i_gattung"><axsl:value-of select="normalize-space(i_gattung)"/></axsl:when></axsl:choose></axsl:variable><axsl:call-template name="stringReplace"><axsl:with-param name="input"><axsl:value-of select="$key"/></axsl:with-param><axsl:with-param name="find"><axsl:text> </axsl:text></axsl:with-param><axsl:with-param name="replace"><axsl:text>_</axsl:text></axsl:with-param></axsl:call-template></axsl:attribute><axsl:variable name="reg"><axsl:choose><axsl:when test="i_gattung"><axsl:value-of select="normalize-space(i_gattung)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$reg"/></axsl:element>
                </axsl:element>

                
                
                
                <axsl:element name="vir_distrib">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="livellosocialeTot"><axsl:value-of select="normalize-space(livellosocialeTot)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                    
                </axsl:element>

                
                <axsl:element name="editiones">
                    
                </axsl:element>

                
                <axsl:element name="textus"><axsl:variable name="textus"><axsl:choose><axsl:when test="Testo"><axsl:value-of select="normalize-space(Testo)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$textus"/></axsl:element>

                
                <axsl:element name="apparatus"><axsl:variable name="apparatus"><axsl:choose><axsl:when test="Apparato"><axsl:value-of select="normalize-space(Apparato)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$apparatus"/></axsl:element>

                
                <axsl:element name="tempus"> BBBAAAWWWAHAHAHAHAHA!!!!!! </axsl:element>

                
                <axsl:element name="sched_script">
                    <axsl:element name="orig"><axsl:variable name="orig"><axsl:choose><axsl:when test="bearbeiter"><axsl:value-of select="normalize-space(bearbeiter)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$orig"/></axsl:element>
                </axsl:element>

                
                <axsl:element name="temp_sched">
                    <axsl:element name="temp_sched"><axsl:variable name="temp_sched"><axsl:choose><axsl:when test="datum"><axsl:value-of select="normalize-space(datum)"/></axsl:when></axsl:choose></axsl:variable><axsl:value-of select="$temp_sched"/></axsl:element>
                </axsl:element>


            </axsl:element>
        </axsl:for-each>
    </axsl:element>
</axsl:template></axsl:stylesheet>