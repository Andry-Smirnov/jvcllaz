The JvTimeFrameDemo of the JVCL Lazarus port uses an SQLite3 database to store 
the data. In order to run this demo you must have SQLite3 installed, or you must
copy the sqlite3.dll to the folder with JvTimeFrameDemo.exe.

If you want to run with the demo's data it is also required to copy the 
data base file, data.sqlite, from the source directory (the directory which 
contains this readme.txt) to the folder with JvTimeFrameDemo.exe. And, since
the demo data are fairly old, you must enter the date Jan 01, 2002 in the
date field of the demo so that the control focus on this date.

If you do not copy the data base file the demo program creates a new, empty
data base, dta.sqlite.

--------------------------------------------------------------------------------

Original text:

The PhotoOp demo uses a Paradox database to store the data. In order to run this 
demo, you need to have the BDE installed and correctly configured. In addition, 
the path to the data is restricted in Paradox. If you get an error about the 
path being too long when you start the application, copy the executable and 
the \Data subfolder from the source folder to a folder with a shorter path and 
run the demo from that location instead.