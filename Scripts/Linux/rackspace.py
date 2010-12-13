#!/usr/bin/python
# rackspace.py - Script to spin up virtual instances in RackSpace's cloud 
# Author: Rich Jerrido 
# License: GPLv2
# Requires:
# 	- Python
# 	- Apache libcloud (http://incubator.apache.org/libcloud/)
#	- A RackSpace cloud account
# 	- A RackSpace API Key
# Todos:
# 	- Add better exception handling
#

import sys, getpass
from libcloud.types import Provider 
from libcloud.providers import get_driver 
from optparse import OptionParser

use = "Usage: %prog [options] argument1"

parser = OptionParser(usage = use)
parser.add_option("-n", "--name", action="store", type="string", dest="name",
	 default=False, help="Cloud Instance Name")
parser.add_option("-u", "--user", action="store", type="string", dest="user", 
	default=False, help="RackSpace Username")
parser.add_option("-k", "--key", action="store", type="string", dest="key", 
	default=False, help="RackSpace API Key (Will prompt if omitted)")
parser.add_option("-s", "--size", action="store", type="string", dest="size", 
	default=False, help="RackSpace Instance Size")
parser.add_option("-i", "--image", action="store", type="string", dest="image", 
	default=False, help="RackSpace Image Name")
options, args = parser.parse_args()
if not ( options.name and options.user and options.size and options.image):
	print "You must specify the name, user, size and image options"
	parser.print_help()
	print "\n\n Example Usage: ./rackspace.py -n testmachine -u rjerrido -k 1111222233334444 -i rhel5u5-x86-64 -s 256"
	sys.exit()
else:
	NAME = options.name
	RACK_USER = options.user
	if not (options.key):
		RACK_API_KEY = getpass.getpass("Enter RackSpace API KEY: ")
	else:
		RACK_API_KEY = options.key

Driver = get_driver(Provider.RACKSPACE) 
conn = Driver(RACK_USER, RACK_API_KEY) 
images = conn.list_images() 
for item in images:
	print item
sizes = conn.list_sizes() 
IMAGE = [i for i in images if i.name.find(options.image) != -1]
SIZE = [i for i in sizes if i.name.find(options.size) != -1]
node = conn.create_node(name=NAME, image=IMAGE[0], size=SIZE[0]) 
