<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="t" 
                version="2.0">    
    <xsl:output />
    <xsl:template name="search">
      <xsl:variable name="form"><div id="search"><form><input type="text" name="search" id="searchBox"/>&#x00A0;<button value="search" name="go" id="searchBtn">search</button></form></div></xsl:variable>
      <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
      <script type="text/javascript">
$(window).load(function() {
  $("body")
    .append('<xsl:copy-of select="$form"/>');
  if (document.querySelector("div.main-content")) {
    $("#search").css({"position":"absolute","top":"1.3em","right":"1.3em"});
  } else {
    $("#search").css({"position":"absolute","top":"2.5em","right":"12em"});
  }
  var go =  $("#searchBtn");
  go.click(function(evt){
      var url = window.location.host + window.location.pathname.replace(/\/[^/]+$/, "");
        window.open("https://www.google.com/search?q=" + $("#searchBox").val() + "%20site%3A" + encodeURIComponent(url));
    });
});
    </script>
    </xsl:template>
    
    
    
</xsl:stylesheet>