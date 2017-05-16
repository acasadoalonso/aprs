#
# OGN tracker integration functions
#
# -------------------------------------------------------------------------------------------------------------------------------- #
import kglid
from flarmfuncs import *
def ogntbuildtable(conn, ognttable, prt=False):	# function to build the OGN tracker table of relation between flarmid and registrations
	auxtable={}
	cursG=conn.cursor()             # set the cursor for searching the devices
	cursG.execute("select id, flarmid, registration from TRKDEVICES where devicetype = 'OGNT' and active = 1; " ) 	# get all the devices with SPIDER
        for rowg in cursG.fetchall(): 	# look for that registration on the OGN database
                                
        	ogntid=rowg[0]		# OGN tracker ID
        	flarmid=rowg[1]		# Flarmid id to be linked
        	registration=rowg[2]	# registration id to be linked
		if flarmid == None or flarmid == '': 			# if flarmid is not provided 
			flarmid=getflarmid(conn, registration, prt)	# get it from the registration
		else:
			chkflarmid(flarmid)
		ognttable[ogntid]=flarmid
	
		if ogntid[3:]  not in kglid.kglid:	# check that the registration is on the table - sanity checka
			o='NoregO'
		else:
			o=kglid.kglid[ogntid[3:]]
		if flarmid[3:]  not in kglid.kglid:	# check that the registration is on the table - sanity checka
			f='NoregF'
		else:
			f=kglid.kglid[flarmid[3:]]
		auxtable[o]=f
	print "OGNTtable:", ognttable
	print "OGNTtable:", auxtable
	return(ognttable)

# -------------------------------------------------------------------------------------------------------------------------------- #

#########################################################################


