<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://www.ascc.net/xml/schematron" 
                    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <sch:title>Epidoc Unit Test</sch:title>
    <sch:pattern name="Checking for document testability...">
        <sch:rule context="/">
            <sch:assert test="//tei:*[starts-with(@xml:id, 'TypoEx-')]">There is no identifiable typographic example.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'TypoEx-')]">A typographic example exists.</sch:report>
            <sch:assert test="//tei:*[starts-with(@xml:id, 'EncEx-')]">There is no identifiable Epidoc encoding example.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'EncEx-')]">A Epidoc encoding example exists.</sch:report>
            <sch:assert test="//tei:*[starts-with(@xml:id, 'Regex-')]">There is no identifiable regular expression test.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'Regex-')]">A typographic example exists.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern name="Checking example consistency...">
        <sch:rule context="tei:*[starts-with(@xml:id, 'TypoEx-')]">
            <sch:assert test="//tei:*[starts-with(@xml:id, 'EncEx-') and substring-after(@id, '-') = substring-after(current()/@id, '-')]">There must be an element containing an Epidoc fragment that corresponds to the typographic example.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'EncEx-') and substring-after(@id, '-') = substring-after(current()/@id, '-')]">An element containing an Epidoc fragment that corresponds to the typographic example exists.</sch:report>
            <sch:assert test="//tei:*[starts-with(@xml:id, 'Regex-')]">There must be an element containing a regular expression that corresponds to the typographic example and the Epidoc fragment.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'Regex-')]">An element containing a regular expression that corresponds to the typographic example and the Epidoc fragment exists.</sch:report>
            <sch:assert test="//tei:*[starts-with(@xml:id, 'TestLink-') and substring-after(@id, '-') = substring-after(current()/@id, '-')]">There must be an element that links together the typographic example, the epidoc fragment, and the regular expression test.</sch:assert>
            <sch:report test="//tei:*[starts-with(@xml:id, 'TestLink-') and substring-after(@id, '-') = substring-after(current()/@id, '-')]">An element that links together the typographic example, the epidoc fragment, and the regular expression test exists.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern name="Checking whether typographic example and regular expression match...">
        <sch:rule context="tei:link[@type='regextest']">
            <sch:assert test="fn:matches(fn:id(tei:target[@type = 'TypoEx']), fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = ')))">The given regular expression <sch:span class="markup"><sch:value-of select="fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = '))"/></sch:span> does not match the typographic example.</sch:assert>
            <sch:report test="fn:matches(fn:id(tei:target[@type = 'TypoEx']), fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = ')))">The given regular expression <sch:span class="markup"><sch:value-of select="fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = '))"/></sch:span> matches the typographic example.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern name="Checking whether the regular expression result matches the encoding example...">
        <sch:rule context="tei:link[@type='regextest']">
            <sch:assert test="fn:normalize-space(fn:replace(fn:id(tei:target[@type='TypoEx']), fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = ')), fn:normalize-space(fn:substring-after(fn:id(tei:target[@type = 'Regex']), ' = ')))) eq fn:normalize-space(fn:id(tei:target[@type='EncEx']))">The given regex replacement <sch:span class="markup"><sch:value-of select="fn:id(tei:target[@type='Regex'])"/></sch:span> will not convert <sch:span class="markup"><sch:value-of select="fn:id(tei:target[@type='TypoEx'])"/></sch:span> into <sch:span class="markup"><sch:value-of select="fn:normalize-space(fn:id(tei:target[@type='EncEx']))"/></sch:span>.  It does this instead: <sch:span class="markup"><sch:value-of select="fn:replace(fn:id(tei:target[@type='TypoEx']), fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = ')), fn:normalize-space(fn:substring-after(fn:id(tei:target[@type = 'Regex']), ' = ')))"/></sch:span>.</sch:assert>
            <sch:report test="fn:normalize-space(fn:replace(fn:id(tei:target[@type='TypoEx']), fn:normalize-space(fn:substring-before(fn:id(tei:target[@type = 'Regex']), ' = ')), fn:normalize-space(fn:substring-after(fn:id(tei:target[@type = 'Regex']), ' = ')))) eq fn:normalize-space(fn:id(tei:target[@type='EncEx']))">The examples and regular expression match.</sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>