#!/bin/bash
cd /nfs/OGN/SWdata 
echo "============================:"   		>>aprs.log
date                            		>>aprs.log
python3 ~/src/APRSsrc/main/APRScalsunrisesunset.py >>aprs.log
echo "APRSLIVE.sh:"	            		>>aprs.log
echo "===========:"     	       		>>aprs.log
python3 ~/src/APRSsrc/main/aprslog.py    	>>aprs.log 2>>aprserr.log &
pgrep -a python3				>>aprs.log
cd
