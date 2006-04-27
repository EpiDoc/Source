echo off
:: ---------------------------------------------------------------------------
:: initialize log 
:: ---------------------------------------------------------------------------
del .\glgen.log

:: ---------------------------------------------------------------------------
:: check for required environment variables 
:: ---------------------------------------------------------------------------
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Checking required environment variables ... >> .\glgen.log
if not "%EPIDOC_GLPATH%" == "" goto gotGLPATH
echo You must set EPIDOC_GLPATH to point to the EpiDoc Guidelines directory
echo ***FATAL: EPIDOC_GLPATH not set >> .\glgen.log
goto fatal
:gotGLPATH

if not "%EPIDOC_XSLPATH%" == "" goto gotXSLPATH
echo You must set EPIDOC_XSLPATH to point to the EpiDoc XSLT directory
echo ***FATAL: EPIDOC_XSLPATH not set >> .\glgen.log
goto fatal
:gotXSLPATH

if not "%EPIDOC_STATICHTML%" == "" goto gotSTATICHTML
echo You must set EPIDOC_STATICHTML to point to a directory where you want the results written
echo **FATAL: EPIDOC_STATICHTML not set >> .\glgen.log
goto fatal
:gotSTATICHTML
echo ... done >> .\glgen.log

:: ---------------------------------------------------------------------------
:: set up work directory 
:: ---------------------------------------------------------------------------
echo Cleaning up and making work directory at .\work\ ...
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Cleaning up and making work directory at .\work\ ... >> .\glgen.log
del /q .\work\*.* >> glgen.log 2>&1
rmdir .\work >> glgen.log 2>&1
mkdir .\work >> glgen.log 2>&1
echo ... done
echo ... done >> .\glgen.log

:: ---------------------------------------------------------------------------
:: set up destination directory 
:: ---------------------------------------------------------------------------
echo Cleaning up and making destination directory at %EPIDOC_STATICHTML% ...
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Cleaning up and making destingation directory at %EPIDOC_STATICHTML% ... >> .\glgen.log
del /q %EPIDOC_STATICHTML%\*.* >> glgen.log 2>&1
rmdir %EPIDOC_STATICHTML%\ >> glgen.log 2>&1
mkdir %EPIDOC_STATICHTML%\ >> glgen.log 2>&1
echo ... ( copying css files from %EPIDOC_XSLPATH%\css\ to %EPIDOC_STATICHTML% ... )
echo ... ( copying css files from %EPIDOC_XSLPATH%\css\ ... ) >> glgen.log
copy %EPIDOC_XSLPATH%\css\*.css %EPIDOC_STATICHTML% >> glgen.log 2>&1
echo ... ( ... done copying css files )
echo ... ( ... done copying css files ) >> glgen.log 2>&1
echo ... done
echo ... done >> .\glgen.log

:: ---------------------------------------------------------------------------
:: create list of source files 
:: ---------------------------------------------------------------------------
echo Creating list of source files (.\work\srclist.txt) from %EPIDOC_GLPATH%\src\ ...
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Creating list of source files (.\work\srclist.txt) from %EPIDOC_GLPATH%\src\ ... >> .\glgen.log
dir /b src > .\work\srclist.txt
type .\work\srclist.txt >> .\glgen.log
echo ... done
echo ... done >> .\glgen.log

:: ---------------------------------------------------------------------------
:: generate a batch file to run the transformations 
:: ---------------------------------------------------------------------------
echo Generating transformation batch file (.\glxform.bat) from list of source files ...
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Generating transformation batch file (.\glxform.bat) from list of source files ... >> .\glgen.log
perl glgenbatiffy.pl .\work\srclist.txt > .\glxform.bat
echo ... done
echo ... done >> .\glgen.log

:: ---------------------------------------------------------------------------
:: run the transformations 
:: ---------------------------------------------------------------------------
echo Calling the transformation batch file ...
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Calling the transformation batch file ... >> .\glgen.log
call .\glxform
echo ... done
echo done >> .\glgen.log

goto complete

:fatal
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Execution terminated abnormally
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! >> .\glgen.log
echo Execution terminated abnormally >> .\glgen.log

goto end

:complete
echo ------------------------------------------------------------------------
echo Execution complete
echo ------------------------------------------------------------------------ >> .\glgen.log
echo Execution complete >> .\glgen.log
goto end

:end

