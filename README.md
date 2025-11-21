# Cobol

I followed [this great blogpost](https://bigdanzblog.wordpress.com/2020/10/28/embedded-sql-for-gnucobol-using-ocesql/) to get stated with embedded sql in cobol, refer to it for more details.
# SQL database integration
SQL in cobol is executed inside EXEC blocks e.g.
```cobol
EXEC SQL <SQL Instructions> END-EXEC
```
On mainframes there's supposedly native support for this, however on x86-64 systems we need a *precompiler* to translate the exec sql blocks into cobol library calls, this project used Open COBOL ESQL to achieve this.

Here's an example of a precompiled EXEC SQL block the code written is commented out and replaced with a call to a open cobol esql library.
```cobol
OCESQL*    EXEC SQL
OCESQL*        DROP TABLE IF EXISTS testtable
OCESQL*    end-exec.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL     END-CALL.
```



# Instructions for running database code

## Prequisites

* Linux environment
* postgres installed locally (works with pg version 16 & 18)
* Open COBOL ESQL installed and built locally (requires gcc to build) (tested with version 1.2)
* GnuCobol compiler (tested with version 3.1 & 3.2)
* GnuMake (possibly other variants?)

## Running the program
A database needs to be created matching the hardcoded credentials in the cobol file. For convenience there's commands in the make file to create a db under the postgres user
```bash
make db-create DB=nameofdb
``` 
The entire build process including precompiling & compiling have been combined into a single command with GnuMake
```bash
make
```
This will create a binary file that can be executed with either
```bash
make run
# or
./nameofbinary
```
the build process will create a file containing the precompiled calls to the open cobol esql libraries as well as a executeable binary. To clean up these files the following command can be invoked
```
make clean
```