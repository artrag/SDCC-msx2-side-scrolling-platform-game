import string
import sys
import os

# Build symbol file from map-file
# (argv[0]: python filename) 
# argv[1]: filename without extension
# argv[2]: path
def is_hex(s):
	try:
		int(s, 16)
		return True
	except ValueError:
		return False

f1 = open(sys.argv[1] + os.path.sep + sys.argv[2] + '_.sym','w')

with open(sys.argv[1] + os.path.sep + sys.argv[2] + '.map','r') as f2:
	for line in f2:
		line1 = line.strip()
		words = line1.split()
		if len(words) > 1:
			if words[1].startswith('l__') or words[1].startswith('s__') or words[1].startswith('.__'): 
				continue

			if is_hex(words[0]):
				f1.write( "%s: equ %sH\n" % (words[1], words[0]))

f2.close()
f1.close()

exit()
