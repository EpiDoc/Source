XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXX      README.txt for P5 Conversion                            XXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

* What it is:

	A set of XSLT scripts for converting an EpiDoc project in TEI P4 to match
	the guidelines for EpiDoc in TEI P5. The scripts are customized to specific
	projects (DDbDP, InsAph, IRT, etc.) and probably need customization for
	more general use.

* License:

	These scripts are copyright Gabriel Bodard (and all other contributors).
	See LICENSE.txt for license details.

* Technical requirements:

	These scripts are written in XSLT 2.0 and require a Saxon™ 8 or 9+ environment.

* How to use it:

	XSLT may be run on an individual EpiDoc XML file, creating a single file output
	(e.g. via a command-line Saxon™ call or an Oxygen™ transformation scenario)
	or batch-run upon a large collection of files via some other process (e.g. an
	Oxygen™ project, set of batch files, etc.)
