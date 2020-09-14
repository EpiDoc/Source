<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:pxf="http://exproc.org/proposed/steps/file">
    
    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

    <!--<p:declare-step type="pxf:copy">
        <p:output port="result" primary="false"/>
        <p:option name="href" required="true"/>
        <p:option name="target" required="true"/>
        <p:option name="fail-on-error" select="'true'"/>
    </p:declare-step>-->
    
    <p:group>
        <p:variable name="from" select="'../xml/ex-epidoctemplate.xml'"/>
        <p:variable name="to" select="'../output/ex-epidoctemplate.xml'"/>

        <!-- This works -->
        <pxf:copy name="copy">
            <p:with-option name="href" select="$from"/>
            <p:with-option name="target" select="$to"/>
        </pxf:copy>
    </p:group>
    
</p:declare-step>