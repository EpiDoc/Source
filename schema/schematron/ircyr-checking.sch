<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.ascc.net/xml/schematron" xmlns:t="http://www.tei-c.org/ns/1.0">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>
    <!--<pattern name="Print both cases">
        <rule context="AAA">
            <assert test="BBB">BBB element is missing.</assert>
            <report test="BBB">BBB element is present.</report>
            <assert test="@name">AAA misses attribute name.</assert>
            <report test="@name">AAA contains attribute name.</report>
        </rule>
    </pattern>-->
    <pattern name="Test gap attributes">
        <rule context="//t:gap">
            <report test="(@extent and @quantity)">conflict: @quantity and @extent both present on <name/></report>
            <report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atLeast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</report>
            <report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</report>
        </rule>
    </pattern>
    <pattern name="Test space attributes">
        <rule context="//t:space">
            <report test="(@extent and @quantity)">conflict: @quantity and @extent both present on <name/></report>
            <report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atleast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</report>
            <report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</report>
        </rule>
    </pattern>
    
</schema>
