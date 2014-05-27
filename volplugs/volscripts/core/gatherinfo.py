"""
This script will gather the information needed from the user
In order to proceed with the program
"""

def getuserinput():
	#
	# Let's grab all of the input we need to get started from the user.
	# since we are using raw_input, these will be string values.
	homedir = raw_input("Enter your home directory: ")
	casedir = raw_input("Enter the case name: ")
	memfilename = raw_input("Enter the memory file name: ")
	
	#
	# Let's verify the information from the user.
	print "This is the information that you entered. \n"
	print "Your Home Directory is: " + homedir
	print "Your Case Directory is: " + casedir
	print "Your Memory File is: " + memfilename
	print "Are these values correct?: (y/n) \n"

"""
Need to create an array of these variables, so that we can iterate through them
and test to make sure the files and directories exist. If they do not exist, we 
will need to create them in this script as well.
"""
	