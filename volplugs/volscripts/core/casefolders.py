#
# import needed utilities
import os
import errno

def buildcasefolders ():
	#
	# Tell the user what we are about to do.
	print "I am now going to check for our needed directories, "
	print "and create them if they do not exist."
	# Create 2 arrays of folders for our cases
	casefolders = ["dumps", "evidence", "text", "logs"]
	dumpfolders = ["procexedump", "procmemdump", "dlls", "malfind"]
	# Check for the existance of the first set of folders.
	# Create them if they do not exist.
	for dir in casefolders:
		print dir
		try:
			os.stat(dir)
		except:
			os.mkdir(dir)
		
	#
	# Move into the dumps directory to create our second batch of folders
	os.chdir("dumps")

	#
	# Check for the existance of these folders inside the dumps folder.
	# Create them if they do not exist.
	for dir in dumpfolders:
		print dir
		try:
			os.stat(dir)
		except:
			os.mkdir(dir)

	#
	# Move back up 1 directory in the tree.
	os.chdir("../")


