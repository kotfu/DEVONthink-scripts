# DEVONthink-scripts
Useful and interesting scripts for DEVONthink.

The AppleScript native file format is binary, and contains the text version of the script and a compiled version. This makes it difficult to view, compare, share, and edit these scripts using anything other that the AppleScript Editor. I have chosen to store all these scripts as plain text in the src directory. It's easy to version control them and compare differences, but it also means they need to be turned into real AppleScript files in order to use them.

To create usable script files, just type:

    $ ./compilescripts
	
Then go look in the newly created `script` directory, and you will see all the binary script files which you can edit and run with Script Editor.

To install the scripts, type:

	$ ./installscripts
