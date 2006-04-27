del .\glgen.log
echo deleting .\work\*.* >> glgen.log
del /q .\work\*.* >> glgen.log 2>&1
del /q .\src\*.* >> glgen.log 2>&1
del /q .\dtd\*.* >> glgen.log 2>&1
del /q .\epidoc-xsl\html\*.* >> glgen.log 2>&1
del /q .\epidoc-xsl\util\*.* >> glgen.log 2>&1
del /q .\dest\*.* >> glgen.log 2>&1
del .\glxform.bat >> glgen.log 2>&1
del .\glxform.log >> glgen.log 2>&1
rmdir .\work >> glgen.log 2>&1
rmdir .\src >> glgen.log 2>&1
rmdir .\dtd >> glgen.log 2>&1
rmdir .\epidoc-xsl\html >> glgen.log 2>&1
rmdir .\epidoc-xsl\util >> glgen.log 2>&1
rmdir .\dest >> glgen.log 2>&1
mkdir .\work >> glgen.log 2>&1
mkdir .\src >> glgen.log 2>&1
mkdir .\dtd >> glgen.log 2>&1
mkdir .\epidoc-xsl\html >> glgen.log 2>&1
mkdir .\epidoc-xsl\util >> glgen.log 2>&1
mkdir .\dest >> glgen.log 2>&1
copy ..\src\*.* .\src >> glgen.log 2>&1
copy ..\dtd\tei-epidoc.dtd .\dtd >> glgen.log 2>&1
copy ..\..\epidoc-xsl\html\*.* .\epidoc-xsl\html >> glgen.log 2>&1
copy ..\..\epidoc-xsl\util\*.* .\epidoc-xsl\util >> glgen.log 2>&1
copy ..\..\epidoc-xsl\css\*.css .\dest >> glgen.log 2>&1
dir /b src > .\work\srclist.txt
perl glgenbatiffy.pl .\work\srclist.txt > .\glxform.bat
call .\glxform 


