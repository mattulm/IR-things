


def createmd5 ()
	import hashlib

	hasher = hashlib.md5()
	with open('myfile.jpg', 'rb') as afile:
		buf = afile.read()
		hasher.update(buf)
	print(hasher.hexdigest())
		
	
def cretaesha1()
	import hashlib

	hasher = hashlib.sha1()
	with open('myfile.jpg', 'rb') as afile:
		buf = afile.read()
		hasher.update(buf)
	print(hasher.hexdigest())

	
def createsha256()
	import hashlib

	hasher = hashlib.sha256()
	with open('myfile.jpg', 'rb') as afile:
		buf = afile.read()
		hasher.update(buf)
	print(hasher.hexdigest())