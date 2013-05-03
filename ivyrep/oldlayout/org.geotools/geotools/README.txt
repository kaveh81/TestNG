extract-sources.sh and finder.py are helper programs to extract source jars for each of the jars in the distribution, provided you have an extracted-out source folder that contains the required sources somewhere.

So for geotools, there are currently 11 jars we've got, all build from the same source tree.  These scripts will find the source files needed for each jar out of the combined source tree, and build a -source.jar for each of the existing 11 jars.
