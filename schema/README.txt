XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXX      README.txt for EpiDoc ODD and schema              XXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

What it is:

	The EpiDoc RelaxNG schema and the TEI ODD file from which it is generated.

	**Temporary notice**:
	There are two copies of the ODD in this directory: tei-epidoc-full.xml,
	which is the version that will work with the online Roma tool
	(http://www.tei-c.org/Roma/), and tei-epidoc.xml, which currently does
	not work with Roma because it contains only the <schemaSpec> and is
	designed to be x-included to the full ODD (to include Guidelines
	etc.)

License:

	The TEI Schema is copyright the TEI Consortium
	(http://www.tei-c.org/Guidelines/access.xml#body.1_div.2).
	To the extent that the EpiDoc ODD and schema have been customized and
	amount to transformative versions of the original schema, they are
	copyright Gabriel Bodard and the other contributors (as listed in
	tei:revisionDesc). See LICENSE.txt for license details.

Technical Requirements:

	The ODD requires the Roma tool (and associated dependencies) to generate
	the RelaxNG schema. The schema (whose canonical released versions live at
	http://www.stoa.org/epidoc/schema/) may be used by any XML editor or
	processing environment to validate EpiDoc XML files.

How to use it:

	**NB**:
	instructions for the use of Roma to generate the EpiDoc schema are
	under construction

	If using Oxygen to edit XML files, a processing instruction such as:

	<?oxygen
	  RNGSchema="http://www.stoa.org/epidoc/schema/8/tei-epidoc.rng"
        type="xml"?>

	at the top of the XML file will instruct the editor to validate
	against this schema.

