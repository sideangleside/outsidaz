#!/usr/bin/python
from optparse import OptionParser
import os
import sys, string, time
import random

def changeWallpaper(filename):
	cmd = string.join(["gconftool-2 -s /desktop/gnome/background/picture_filename -t string \"",filename,"\""],'')
	os.system(cmd) # execute system command

# Parse commandline arguments
parser = OptionParser()
parser.add_option("-f", "--folder", dest="folder",
help="use wallpapers from FOLDER", metavar="FOLDER")           
parser.add_option("-i", "--interval", type="float", dest="interval", default=300, help="time interval in seconds", metavar="INTERVAL")
(options, args) = parser.parse_args()

           # Validate for presence of valid folder
if options.folder is None:
	raise ValueError, "No valid folder specified"
if not(os.path.isdir(options.folder)):
	raise ValueError, "The folder specified is not valid"

           # Make list of images
imagefilelist = [filename for filename in os.listdir(options.folder)
if (filename.lower().endswith("jpg")
or filename.lower().endswith("png")
or filename.lower().endswith("gif"))]
imagefilelist = [string.join([os.path.normpath(options.folder),imgFile],"/") for imgFile in imagefilelist]

# Validate for presence of images
if (len(imagefilelist) == 0):
	raise ValueError, "Folder does not contain any image files"

count=0 #init index
random.shuffle(imagefilelist) #randomize wallpaper order
try:
	while (True):
		if (count < len(imagefilelist) -1):
			count = count + 1
		else:
			count = 0
		time.sleep(options.interval)
		changeWallpaper(imagefilelist[count])
except KeyboardInterrupt:
	pass
