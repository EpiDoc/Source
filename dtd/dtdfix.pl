#!/usr/bin/perl

# Fix up an XML DTD output from Michael Sperberg-McQueen's carthago
# program.  Such DTDs are perfectly usable, but this program fixes
# them up by putting ATTLIST declarations after corresponding ELEMENT
# declarations, and conflating multiple ATTLISTs for one GI into a
# single ATTLIST.  It also alphabetically sorts ELEMENT declarations,
# and attribute declarations within each ATTLIST.  The conflation and
# sorting can make the DTD easier to use: one problem with multiple
# ATTLISTs is that you can be misled by declarations that are actually
# overriden by others earlier in the file.  And the order of
# declarations in a DTD derived from the TEI DTD doesn't always make a
# lot of sense.  However, the original spur for this program was the
# fact that Emil&eacute; 1.0p didn't parse some of those features
# correctly: it wanted the ELEMENT declaration before the ATTLIST for
# an element, and it used the last declaration it found for a
# particular attribute name, not the first.

# As of August 2002 there are also reports that jEdit from
# www.jedit.org with its XML plugin misunderstands ATTLISTs in a
# different way: if an attribute is declared several times the last
# rather than the first instance is used. That problem is also avoided
# if this script is applied to the DTD.

# Runs as a filter. Very dependent on recognizing the \n\n\n pattern
# that separates entries in carthago output.

# John Lavagnino, King's College London <John.Lavagnino@kcl.ac.uk>.

# Inelegantly hacked by Tom Elliott, 18 August 2005, to suppress the
# TEIform attribute

use strict;
use English;
use diagnostics;

my $version = '$Id: dtdfix.pl,v 1.2 2005-08-18 17:07:04 paregorios Exp $';

sub fixattlist ($); # prototype

# In Carthago output declarations are separated by three newlines.

$INPUT_RECORD_SEPARATOR = "\n\n\n";

my %elements;

my %attlists;

my $otherlines = '';

my $file;
unshift (@ARGV, '-') unless @ARGV;
while ($file = shift @ARGV) {
    my $decl;

    open (FILE, $file) or die "Can't open $file";

    # Sweep through the declarations and store the ELEMENT and
    # ATTLIST declarations in appropriate hashes; any other lines
    # (entity declarations, perhaps) get saved in $otherlines.

    while (defined ($decl = <FILE>)) {
        chop $decl;
        if ($decl =~ m/^\s*<!ELEMENT/) {
            my (undef, $gi, undef) = split (' ', $decl);
            if (exists $elements{$gi}) {
                print STDERR "Multiple ELEMENT declarations for $gi\n";
            } else {
                $elements{$gi} = $decl;
            }
        } elsif ($decl =~ m/^\s*<!ATTLIST/) {
            my (undef, $gi) = split (' ', $decl);
            if (exists $attlists{$gi}) {
                $decl = $attlists{$gi} . $decl;
            }
            $attlists{$gi} = $decl;
        } else {
            $otherlines .= $decl;
        }

    }

    close (FILE);
}

# Output the ELEMENT declarations in alphabetical order, with the
# ATTLIST, if any, for each element following the ELEMENT declaration.

my $gi;
foreach $gi (sort (keys %elements)) {
    print $elements{$gi};
    if (exists $attlists{$gi}) {
        my $attlist = fixattlist ($attlists{$gi});
        print $attlist;
        delete $attlists{$gi};
    }
}

# Flush any lingering ATTLIST declarations: these are ones that must
# not have had a corresponding ELEMENT declaration.

foreach $gi (sort (keys %attlists)) {
    print STDERR "ATTLIST without ELEMENT declaration for $gi:\n";
    print STDERR $attlists{$gi};
}

# And output the other stuff.

print $otherlines;


# Subroutine to fix up attribute lists.

sub fixattlist ($) {
    my ($attlist) = @ARG;

    my @lines = split (/[\n]+/, $attlist);

    my $beginning = '';
    my %atts;

    # The ATTLIST part will be on a separate line from all attribute
    # names; save that part in $beginning.  The individual attribute
    # declarations will each be on a separate line; for each, check
    # that we haven't seen that attribute before, and if we haven't
    # store the declaration away.

    for my $line (@lines) {
        $line =~ s/\s*[>]\s*$//;
        if ($line =~ m/^\s*<!ATTLIST/) {
            $beginning = $line;
        } elsif ($line =~ m/^\t/) {
            my (undef, $attname) = split (/\s+/, $line);
            if (!exists $atts{$attname}) {
                $atts{$attname} = $line;
            }
        } elsif ($line =~ m/^\s*$/) {
            ;
        } else {
            print STDERR "Odd line in ATTLIST: $line\n";
        }
    }

    # Now build a new attribute list, with the attributes in
    # alphabetical order.  This is the function return value.

    my $newattlist = $beginning . "\n";

    foreach my $attname (sort (keys %atts)) {
        # suppress the annoying TEIform attribute
        if ($attname ne "TEIform") {
           $newattlist .= $atts{$attname} . "\n";
       }
    }

    $newattlist .= "\t >\n\n";

    return $newattlist;
}

# End of file.
