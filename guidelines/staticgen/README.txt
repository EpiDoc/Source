There are two tools:

1. staticgen.py - handles transformation of the guidelines source to html according to instructions supplied in a config.xml file

2. package.py - a python script that copies xml and css files to a specified file destination (generally, whatever directory you've already used staticgen to generate the html into)

Instructions for running each of these tools are to be found in the docstrings inside the individual python files.