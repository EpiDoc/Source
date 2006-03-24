#! /bin/bash
#
# Validate the entire EpiDoc guidelines file against the EpiMetaDoc schema.
#
# This is meant to be a dual-platfrom routine: Mac OS X and Debian
# GNU/Linux. Luckily path to bash is the same on both of these
# systems.
#
# Written 2006-03-23 by Syd Bauman, based on my local version of
# similar cmd.
# Copyleft 2006 Syd Bauman.
# 

#
# error exit routine
# 
die() {
    echo; echo
    echo "ERROR: $@."
    D=`date "+%Y-%m-%d %H:%M:%S.%N"`
    echo "Aborting due to above error, $D"
    exit 13
}

DRIVER=src/guidelines.xml
RNG=../schema-gl/epiMetaDoc.rng
RNC=../schema-gl/epiMetaDoc.rnc
TMP=/tmp
TFILE=epidoc-guidelines-complete.xml


# --------- main routine starts here --------- #

#
# check to see that I'm in the right directory
# 
MYDIR=`pwd`
MYDIR=${MYDIR##*/}
if [ $MYDIR != guidelines ] ; then 
    die "Need to be in your sourceforge:epidoc/guidelines working directory."
fi

if which xmllint ; then
    xmllint --xinclude --noent --noout --relaxng $RNG $DRIVER
else
    echo "You don't seem to have `xmllint`, skipping that validator."
fi

if which rnv ; then
    xmllint --noent --xinclude $(DRIVER) > $TMP/$TFILE
    rnv -v $RNC $TMP/$TFILE	# && rm $TMP/$TFILE
else
    echo "You don't seem to have `rnv`, skipping that validator."
fi

if which jing ; then 
    jing -t p5odds.rng $(DRIVER) | grep -v ": error: Illegal xml:lang value \"[A-Za-z][A-Za-z][A-Za-z]\"\.$$"
else
    echo "You don't seem to have `jing`, skipping both jing validation and NRL validation."
fi
