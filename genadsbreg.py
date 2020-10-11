#!/usr/bin/python3

#!/usr/bin/python3
#
# Python code to show access to OGN Beacons
#
# Version for gathering all the records for the world
#

from   datetime import datetime
from   ctypes import *
import time
import string
import sys
import os
import json
import socket
import signal
import atexit
import MySQLdb                          # the SQL data base routines^M
import sqlite3
import argparse

class create_dict(dict): 
  
    # __init__ function 
    def __init__(self): 
        self = dict() 
          
    # Function to add key:value 
    def add(self, key, value): 
        self[key] = value

programver = 'V1.00'			# manually set the program version !!!

print("\n\nGen the ADSB registration JSON file : "+programver)
print("==================================================================================")
#					  report the program version based on file date
print("Program Version:", time.ctime(os.path.getmtime(__file__)))
date = datetime.utcnow()                # get the date
dte = date.strftime("%y%m%d")           # today's date
hostname = socket.gethostname()		# get the hostname 
print("\nDate: ", date, "UTC on SERVER:", hostname, "Process ID:", os.getpid())
date = datetime.now()
print("Time now is: ", date, " Local time")

# --------------------------------------#
#
import config				# import the configuration details

# --------------------------------------#
DBpath      = config.DBpath
DBhost      = config.DBhost
DBuser      = config.DBuser
DBpasswd    = config.DBpasswd
DBname      = config.DBname
OGNT        = config.OGNT
filedb      = "BasicAircraftLookup.sqb"
# --------------------------------------#
parser = argparse.ArgumentParser(description="Gen the ADSB registration file")
parser.add_argument('-p',  '--print',     required=False,
                    dest='prt',   action='store', default=False)
parser.add_argument('-m',  '--MYSQL',     required=False,
                    dest='MYSQL',   action='store', default=False)
parser.add_argument('-s',  '--S3file',     required=False,
                    dest='S3file',   action='store', default="BasicAircraftLookup.sqb")
args = parser.parse_args()
prt      = args.prt			# print on|off
MYSQL    = args.MYSQL			# Use MySQL or SQLITE3
filedb   = args.S3file			# SQLITE3 file name

# --------------------------------------#
# --------------------------------------#
if MYSQL:
					# open the DataBase
   conn = MySQLdb.connect(host=DBhost, user=DBuser, passwd=DBpasswd, db=DBname)
   print("MySQL: Database:", DBname, " at Host:", DBhost)
else:
   conn = sqlite3.connect(filedb)
   print("SQLITE3 file:", filedb)

cursA = conn.cursor()     # set the cursor
cursM = conn.cursor()     # set the cursor


#----------------------genadsbreg.py start-----------------------#

mydict = create_dict()
cursA.execute("SELECT Aircraft.Icao as ICAO, Registration as REG, ModelID as MODEL  FROM Aircraft ;")
res=cursA.fetchall()
#print(res)
counter=0
for row in res:
    if row[2] == None:
       model="UNKW"
    else:
       cursM.execute("SELECT Icao FROM Model WHERE ModelID = "+str(row[2])+" ;")
       mod = cursM.fetchone()
       model = mod[0]
       if model == None or model == '':
          model  = 'UNKW'
    mydict.add(row[0],({"Reg":row[1],"Model":model}))
    counter += 1
#print (mydict)
#stud_json = json.dumps(mydict, indent=4, sort_keys=True)
stud_json = json.dumps(mydict)

#print(stud_json) 
fd=open ("ADSBreg.py","w")
fd.write("ADSBreg="+stud_json)
fd.close()
print (len(stud_json), " Registration generated at ADSBreg.py ", counter)
exit(0)
