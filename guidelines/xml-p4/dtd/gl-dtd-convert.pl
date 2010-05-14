#!c:\perl\bin

my $file;
my $resultline;
my %cssconstants = ();
my $inbody;
my $indiv;
unshift (@ARGV, '-') unless @ARGV;
# for each filename on the command line, open and process the file
while ($file = shift @ARGV) {
    open (FILE, $file) or die "Can't open $file";
    
    # while there is content in the file, read it in line-by-line
    $inbody = "no";
    $indiv = "no";
    while (defined ($myline = <FILE>)) {
       # remove any newline character at the end of the line
       chomp($myline);
        if($myline =~ /<!ATTLIST div/) {
            print ($myline . "\n	xmlns CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:tei CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:xi CDATA \"http://www.w3.org/2001/XInclude\"\n");
        } elsif ($myline =~ /<!ATTLIST TEI.2/) {
            print ($myline . "\n	xmlns CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:tei CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:xi CDATA \"http://www.w3.org/2001/XInclude\"\n");
        } elsif ($myline =~ /lang IDREF #IMPLIED/) {
            print ("	lang CDATA #IMPLIED\n");
        } elsif ($myline =~ /<!ELEMENT body/) {
            print($myline . "\n");
            $inbody = "yes";
        } elsif ($inbody eq "yes") {
            if ($myline eq "	| fs | link | linkGrp | cb | lb | pb)*))) >") {
                print ("	| fs | link | linkGrp | cb | lb | pb)*)|xi:include*)) >\n");
                $inbody = "no";
            } else {
                print ($myline . "\n");
            }
        } elsif ($myline =~ /<!ELEMENT div/) {
            print ($myline . "\n");
            $indiv = "yes";
        } elsif ($indiv eq "yes") {
            if ($myline =~ /list/) {
                $myline =~ s/list/list | xi:include/;
                print ($myline . "\n");
                $indiv = "no";
            } else {
                print ($myline . "\n");
            }
        } else {
            print ($myline . "\n");
        }
    }
    print ("\n");
    print ("<!ELEMENT xi:include EMPTY >\n");
    print ("<!ATTLIST xi:include href CDATA #IMPLIED >\n");
}
    