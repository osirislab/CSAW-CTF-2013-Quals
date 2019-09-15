#! /usr/bin/python

import sys
import Image

def isWhite(r, g, b):
	if (0xFF - r == 0) and (0xFF - g == 0) and (0xFF - b == 0):
		return True
	return False

def main(argv):
	try:
		im = Image.open(argv[1])
	except:
		print 'Error opening file...'
		sys.exit()
	
	try:
		mode = argv[2].lower()
		if mode not in ["e", "d"]:
			mode = "e"
	except:
		mode = "e"

	width, height = im.size

	imo = Image.new("RGB", (width, height), "white")

	for h in xrange(height):
		for w in xrange(width):
			r, g, b = im.getpixel((w, h))
			if isWhite(r, g, b):
				imo.putpixel((w, h), (255, 255, 255))
			else:
				if mode == "e":
					imo.putpixel((w, h), (254, 254, 254))
				elif mode == "d":
					imo.putpixel((w, h), (0, 0, 0))

	of = "chal.png" if mode == "e" else "solve.png"
	imo.save(of)
	
if __name__ == "__main__":
	main(sys.argv)