********************************************************************************
* chetc-js README                                                            *
********************************************************************************
What it is:

        A JavaScript + HTML tool to convert digital texts that employ standard typographic editorial conventions into EpiDoc-compliant XML files.
 
License:

        This software is copyright Hugh Cayless, Elli Mylonas, Gabriel Bodard and Tom Elliott.  See LICENSE.txt for license details.
 
Technical requirements and limitations:

        This tool makes use of a number of third-party JavaScript libraries, which are distributed with chetc-js under the terms of their own licenses:
        * Google AJAX XSLT (http://goog-ajaxslt.sourceforge.net/); version uncertain, copyright 2005
        * MochiKit (http://www.mochikit.com/); version 1.2, copyright 2005
        * Scriptaculous (http://script.aculo.us/); version uncertain, copyright 2005
        
        NB: the current version of chetc-js does not work in Google Chrome 5 or Internet Explorer 8. It has been tested and shown to work in Firefox 3.6 and Safari 5.
 
How to use it:

        In any modern browser, open the file chetc.html. Paste or type your epigraphic or papyrological text into the large text box on the page, then click the "convert" button. The corresponding EpiDoc XML will be returned below the form. 
        
        For example, entering the text:
        
            arma virumque c[a]no
            
        and clicking "convert" should produce:
        
            <ab>
            <lb/>arma virumque c<supplied reason="lost">a</supplied>no</ab>
            
        A series of regular expressions are applied to the source text to produce the xml. These regular expressions can be customized in advance (see replacements/replacements_general.txt). 
        