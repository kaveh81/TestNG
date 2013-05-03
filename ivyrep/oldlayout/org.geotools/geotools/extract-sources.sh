#!/bin/bash
for lib in gt-api gt-data gt-jdbc gt-jdbc-postgis gt-main gt-metadata gt-postgis gt-referencing gt-render gt-wms gt-xml ; do jar tf $lib-2.7-M1.jar | grep '\.class$' | grep -v \\$ | python finder.py && cd tmp && jar cf ../$lib-source-2.7-M1.jar * && cd ..; done
