#!c:\perl\bin

my $file;
my $resultline;
my $fnamebase;
unshift (@ARGV, '-') unless @ARGV;
# for each filename on the command line, open and process the file
while ($file = shift @ARGV) {
    open (FILE, $file) or die "Can't open $file";
    
    # while there is content in the file, read it in line-by-line
    while (defined ($myline = <FILE>)) {
       # remove any newline character at the end of the line
       chomp($myline);
       if ($myline =~ /(.+)\.xml$/) {
           $myfnamebase = $1;
           print ("echo !!! TRANSFORMING: " . $myfnamebase . ".xml >> glxform.log\n");
           if ($1 =~ m/^guidelines$/) {
               
               print ("xsltproc -o .\\work\\" . $myfnamebase . ".html -novalid --xinclude --stringparam dotitlepage yes .\\epidoc-xsl\\html\\epidoc.xsl .\\src\\" . $myfnamebase . ".xml >> glxform.log 2>&1\n");
              
           } else {
             print ("xsltproc -o .\\work\\" . $myfnamebase . ".html -novalid --xinclude .\\epidoc-xsl\\html\\epidoc.xsl .\\src\\" . $myfnamebase . ".xml >> glxform.log 2>&1\n");
           }
           print ("echo !!! PRETTY-PRINTING: " . $myfnamebase . ".html >> glxform.log\n");
            print ("xsltproc -o .\\dest\\" . $myfnamebase . ".html -novalid .\\epidoc-xsl\\util\\xhtmlindenter.xsl .\\work\\" . $myfnamebase . ".html >> glxform.log 2>&1\n");

       } else {
           die ("Not a valid filename: " . $myline . "\n");
       }


    }
           # now do the rote transformations
       print ("echo !!! TRANSFORMING: guidelines.xml to create toc.html >> glxform.log\n");
       print ("xsltproc -o .\\work\\toc.html -novalid --xinclude --stringparam dotitlepage yes .\\epidoc-xsl\\html\\sitemap.xsl .\\src\\guidelines.xml >> glxform.log 2>&1\n");
       print ("echo !!! PRETTY-PRINTING: toc.html >> glxform.log\n");
       print ("xsltproc -o .\\dest\\toc.html -novalid .\\epidoc-xsl\\util\\xhtmlindenter.xsl .\\work\\toc.html >> glxform.log 2>&1\n");
       print ("copy .\\dest\\guidelines.html .\\dest\\index.html\n");
}
    