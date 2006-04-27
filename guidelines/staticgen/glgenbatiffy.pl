#!c:\perl\bin

my $file;
my $resultline;
my $fnamebase;
unshift (@ARGV, '-') unless @ARGV;
# for each filename on the command line, open and process the file
while ($file = shift @ARGV) {
    open (FILE, $file) or die "Can't open $file";
    
    print ("echo off\n");
    print ("del .\\glxform.log\n");
    print ("echo ------------------------------------------------------------------------ >> .\\glxform.log\n");
    # while there is content in the file, read it in line-by-line
    while (defined ($myline = <FILE>)) {
    print ("echo ------------------------------------------------------------------------ >> .\\glxform.log\n");
       # remove any newline character at the end of the line
       chomp($myline);
       if ($myline =~ /(.+)\.xml$/) {
           $myfnamebase = $1;
           print ("echo Transforming TEI XML to XHTML: " . $myfnamebase . ".xml >> glxform.log\n");
           if ($1 =~ m/^guidelines$/) {
               print ("xsltproc -o .\\work\\" . $myfnamebase . ".html -novalid --xinclude --stringparam dotitlepage yes \%EPIDOC_XSLPATH\%\\html\\epidoc.xsl \%EPIDOC_GLPATH\%\\src\\" . $myfnamebase . ".xml >> glxform.log 2>&1\n");
           } else {
             print ("xsltproc -o .\\work\\" . $myfnamebase . ".html -novalid --xinclude \%EPIDOC_XSLPATH\%\\html\\epidoc.xsl \%EPIDOC_GLPATH\%\\src\\" . $myfnamebase . ".xml >> glxform.log 2>&1\n");
           }
           print ("echo Tranforming XHTML (indenting): " . $myfnamebase . ".html >> glxform.log\n");
           print ("xsltproc -o \%EPIDOC_STATICHTML\%\\" . $myfnamebase . ".html -novalid \%EPIDOC_XSLPATH\%\\util\\xhtmlindenter.xsl .\\work\\" . $myfnamebase . ".html >> glxform.log 2>&1\n");

       } else {
           die ("Not a valid filename: " . $myline . "\n");
       }


    }
           # now do the rote transformations
    print ("echo ------------------------------------------------------------------------ >> .\\glxform.log\n");
       print ("echo Transforming guidelines.xml to create toc.html >> glxform.log\n");
       print ("xsltproc -o .\\work\\toc.html -novalid --xinclude --stringparam dotitlepage yes \%EPIDOC_XSLPATH\%\\html\\sitemap.xsl \%EPIDOC_GLPATH\%\\src\\guidelines.xml >> glxform.log 2>&1\n");
       print ("echo Transforming XHTML (indenting): toc.html >> glxform.log\n");
       print ("xsltproc -o \%EPIDOC_STATICHTML\%\\toc.html -novalid \%EPIDOC_XSLPATH\%\\util\\xhtmlindenter.xsl .\\work\\toc.html >> glxform.log 2>&1\n");
    print ("echo ------------------------------------------------------------------------ >> .\\glxform.log\n");
       print ("echo copying \%EPIDOC_STATICHTML\%\\guidelines.html to \%EPIDOC_STATICHTML\%\\index.html >> glxform.log\n");
       print ("copy \%EPIDOC_STATICHTML\%\\guidelines.html \%EPIDOC_STATICHTML\%\\index.html >> glxform.log 2>&1\n");
}
    