#!c:\perl\bin

my $file;
my $resultline;
my %cssconstants = ();
unshift (@ARGV, '-') unless @ARGV;
# for each filename on the command line, open and process the file
while ($file = shift @ARGV) {
    open (FILE, $file) or die "Can't open $file";
    
    # while there is content in the file, read it in line-by-line
    while (defined ($myline = <FILE>)) {
       # remove any newline character at the end of the line
       chomp($myline);
        if($myline =~ /<!ATTLIST div/) {
            print ($myline . "\n	xmlns CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:tei CDATA \"http://www.tei-c.org/ns/1.0\"\n	xmlns:xi CDATA \"http://www.w3.org/2001/XInclude\"\n");
        } elsif ($myline =~ /lang IDREF #IMPLIED/) {
            print ("lang CDATA #IMPLIED");
        } else {
            print ($myline . "\n");
        }
    }
    
}
    