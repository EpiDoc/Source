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
       # strip leading whitespace
        $myline =~ s/^\s+//;
        # strip trailing whitespace
        $myline =~ s/\s+$//;
        # determine how to handle a line based on its content
        if($myline =~ /^%.*%\s*=\s*.*/) {
           # line begins with a variable, so it must be definition
           $csskey = $myline;
           $csskey =~ s/^%([^%]+)%.*/$1/;
           $cssvalue = $myline;
           $cssvalue =~ s/^%[^%]*%\s*=\s*(.*)/$1/;
           $cssconstants{$csskey} = $cssvalue;
           # print ("*** " . $csskey . " returns " . $cssconstants{$csskey} . "\n");
        } elsif ($myline =~ /^.+:[^%]*%[^%]+%/) {
           $csskey = $myline;
           $csskey =~ s/^.+:[^%]*%([^%]+)%.*/$1/;
           # print ("--- " . $csskey);
           $myline =~ s/%($csskey)%/$cssconstants{$csskey}/;
           print($myline. "\n");
        } else {
           print ($myline . "\n");
        }
    }
    
}
    