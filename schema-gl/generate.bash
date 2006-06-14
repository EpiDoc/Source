#! /bin/bash
#
# Generate reference documentation, RelaxNG schemas, and RelaxNG
# schemas for examples of the meta-epidoc language. This is the ODD
# language in which the EpiDoc Guidelines are written.
#
# This is meant to be a dual-platfrom routine: Mac OS X and Debian GNU/Linux 
# 
# luckily path to bash is the same on both Mac OS X and Debian
#
# Written 2006-03-23 by Syd Bauman, based on my local version of similar cmd.
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

# --------- main routine starts here --------- #
INNAME=epiMetaDoc.xml
EXNAME=epiMetaDoc-ex.xml
PREFIX=emd.
# WARNING: these default paths are currently for Syd's systems, not generalized.
if [ -e /Volumes/data/ ] ; then
    # Note: these paths are aginst the latest Subversion check-in, rather than
    # the released TEI, which may be a better idea
    ROMACMD=/Volumes/data/SFTEI/trunk/Roma/roma.sh
    XSLDIR=/Volumes/data/Stylesheets/release/tei-xsl/p5
    P5DIR=/Volumes/data/P5
else
    ROMACMD=/usr/bin/roma
    XSLDIR=/usr/share/xml/tei/stylesheet
    P5DIR=/home/syd/SFTEI/P5
fi
while test $# -gt 0; do
    case $1 in
	--xsl=*)       XSLDIR=`echo $1 | sed 's/.*=//'`;;
	--roma=*)      ROMACMD=`echo $1 | sed 's/.*=//'` ;;
	--p5dir=*)     P5DIR=`echo $1 | sed 's/.*=//'` ;;
     *) if test "$1" = "${1#--}" ; then 
	   break
	else
	   echo "WARNING: Unrecognized option '$1' ignored"
	   echo "For usage syntax read the source, $0"
	fi ;;
  esac
  shift
done

#
# check to see that I'm in the right directory
# 
MYDIR=`pwd`
MYDIR=${MYDIR##*/}
if [ $MYDIR != schema-gl ] ; then 
    die "Need to be in your sourceforge:epidoc/schema-gl working directory."
fi


GLOBAL_ATTS_VERBOSE='(\s*<a class=\"link_odd\"[^>]+href=\"#att\.global\.[A-Za-z0-9-]*\">att\.global\.[A-Za-z0-9-]*</a>,?)+'
GLOBAL_ATTS_CONCISE='   <a class=\"link_odd\" href=\"#att.global\">att.global</a>,\n'
GLOBAL_ATTS_LINKING_VERBOSE='(\s*<a class=\"link_odd\"[^>]+href=\"#att\.global\.linking[A-Za-z0-9.-]*\">att\.global\.linking[A-Za-z0-9.-]*</a>,?)+'
GLOBAL_ATTS_LINKING_CONCISE='   <a class=\"link_odd\" href=\"#att.global.linking\">att.global.linking</a>,\n'

echo -e "--------- generate schema & reference documentation"
$ROMACMD --patternprefix=$PREFIX            \
    --xsl=$XSLDIR --nodtd --noxsd --dochtml \
    --localsource=$P5DIR/Source/Guidelines/en/guidelines-en.xml  \
    --doc  ./$INNAME  .

echo "9. extract schematron rules into ${MYNAME}.sch"
xmllint --noent  ./$INNAME | xsltproc $P5DIR/Utilities/extract-sch.xsl - > `basename $INNAME .odd`.sch

echo -e "\n--------- now generate schema for examples, i.e. <egXML> content"
$ROMACMD --patternprefix=emd-ex.          \
    --xsl=$XSLDIR --nodtd --noxsd          \
    --localsource=$P5DIR/Source/Guidelines/en/guidelines-en.xml \
    --doc  ./$EXNAME  .

# get the name of the examples' schema output file
EXSCHEMA=$(xsltproc $XSLDIR/odds/extract-schemaSpec-ident.xsl ./$EXNAME | head -1)
EXSCHEMA=${EXSCHEMA:?"Unable to ascertain ident= of <schemaSpec>"}
# change the namespace in those files
perl -p -i -e 's+org/ns/1.0+org/ns/Examples+' ${EXSCHEMA}.rnc
perl -p -i -e 's+org/ns/1.0+org/ns/Examples+' ${EXSCHEMA}.rng

echo -e "\n--------- now do some post-processing to make things prettier"
echo "A. fix whitespace in RNC files."
for i in ./*.rnc; do
    t=`basename $i .rnc`.tmp
    mv $i $t
    $P5DIR/Utilities/fix_rnc_whitespace.perl --patternprefix=$PREFIX < $t > $i
    rm $t
    done

echo "B. reduce verbosity of global attrs in HTML files."
for i in ./*.html; do
    t=`basename $i .html`.tmp
    mv $i $t
    perl -e"@in=<STDIN>;
\$in=join('',@in);
\$in=~s|$GLOBAL_ATTS_LINKING_VERBOSE|$GLOBAL_ATTS_LINKING_CONCISE|gs;
\$in=~s|$GLOBAL_ATTS_VERBOSE|$GLOBAL_ATTS_CONCISE|gs;
\$in=~s|element :|element |gs;
print \$in;" < $t > $i
    rm $t
    done
