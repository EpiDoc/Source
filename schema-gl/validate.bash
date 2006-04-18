#! /bin/bash
#
# Validate the entire EpiDoc guidelines file against the EpiMetaDoc schema.
#
# This is meant to be a dual-platfrom routine: Mac OS X and Debian
# GNU/Linux. Luckily path to bash is the same on both of these
# systems.
#
# Written 2006-03-24 by Syd Bauman, based on my local version of
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
NRL=../schema-gl/epiMetaDoc.nrl
TMP=/tmp
TFILE=epidoc-guidelines-complete.xml


# --------- main routine starts here --------- #

#
# check to see that I'm in the right directory
# 
MYDIR=`pwd`
MYDIR=${MYDIR##*/}
if [ $MYDIR != guidelines ] ; then 
    die "You need to be in your sourceforge:epidoc/guidelines working directory."
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
    # Note: see sourceforge:tei/P5/Makefile for an explanation of the greps below
    jing -t $RNG $DRIVER | grep -v ": error: Illegal xml:lang value \"[A-Za-z][A-Za-z][A-Za-z]\"\.$$"
    jing $NRL $DRIVER \
	 | grep -v ": error: Illegal xml:lang value \"[A-Za-z][A-Za-z][A-Za-z]\"\.$$" \
	 | grep -v ': error: unfinished element$$'
else
    echo "You don't seem to have `jing`, skipping both jing validation and NRL validation."
fi
