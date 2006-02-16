Instructions for installing the epidoc-webapp (but see also developer tips below before you do anything)

1. Install cocoon and, optionally, integrate it into another web application server like Tomcat.

2. Copy the epidoc-webapp directory tree into the webapp directory (henceforth %COCOON_WEBAPP%) under your cocoon installation (or customize your cocoon installation using map:mount or mount-table.xml and put epidoc-webapp wherever you like)

3. Checkout or download the latest version of the epidoc-xsl package and copy its contents (including its root directory "epidoc-xsl") into %COCOON_WEBAPP%/epidoc-webapp/xsl

4. Start your cocoon instance and aim a browser at http://%YOUR_SERVER%/%INTERNAL_PATH_TO_COCOON_WEBAPP%/epidoc-webapp/prj/examples/inst054.html

5. To create new projects, create a new subdirectory (any name is fine) in prj. Copy the sitemap file from prj/examples. Create a src subdirectory and put your xml files in it. Have fun.

DEVELOPER TIPS:

To create a workspace where all separate epidoc packages are in parallel (rather than hierarchically arranged) so that you can use CVS easily, and so that they're out from under the cocoon webapp tree (so that you can rebuild cocoon without destroying everything):

1. Unpack all your epidoc packages into a work directory subtree structured as follows, located in a place of your choice (e.g., d:\epidocwork\). I'll use %YOUR_EPIDOC_WORK% to represent the path to this work directory henceforth. You might have:

%YOUR_EPIDOC_WORK% (created by you)
   - dtd (checked out from cvs)
   - epidoc-webapp (checked out from cvs)
   - epidoc-xsl (checked out from cvs)
   - guidelines (checked out from cvs)
   - mythesis (created and populated by you)

  Note: there are hooks built into the epidoc-webapp sitemap files at appropriate points to make all requests for project content under the %INTERNAL_PATH_TO_EPIDOC-WEBAPP%/work look in subdirectories in your epidoc work directory, using a relative path. If you don't set up this way, you'll have to hack the sitemap files. If you check such a hacked sitemap file into cvs as part of the epidoc-webapp package, YOU WILL BE BUYING TOM MANY DRINKS WHILE YOU LISTEN PATIENTLY TO HIS GOOD CITIZEN LECTURE!
  
  Note: new projects can be added as arbitrarily named folders immediately below %YOUR_EPIDOC_WORK% (like "mythesis" in the example above).
   
2. Edit the sitemap.xmap file in %COCOON_WEBAPP% and add a line to mount the epidoc-webapp folder from your work directory:

         <map:match pattern="epidoc-webapp/**">
            <map:mount uri-prefix="epidoc-webapp/" src="%YOUR_EPIDOC_WORK%/epidoc-webapp/" check-reload="yes"/>
         </map:match>

   Note: you'll need to change the path in the src attribute to match the location of your work directory.

   Note: the above code snippet should go directly after the following element that ships in the default sitemap:
   
         <map:match pattern="../../mount-table.xml" type="mount-table">
            <map:mount src="{src}" uri-prefix="{uri-prefix}" />
         </map:match>
         
3. copy sitemap.xmap in %YOUR_EPIDOC_WORK%/epidoc-webapp/prj/ to %YOUR_EPIDOC_WORK%

4. Have fun.