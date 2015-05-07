#!/usr/bin/python

import pymongo
import pymongo.errors

import sys

def main():
    if len(sys.argv) < 2:
        sys.stderr.write("Please provide a mongo URI\n")
        sys.exit(1)
    mongo_uri = sys.argv[1]
    mclient = pymongo.MongoClient(mongo_uri)
    
    try:
        rs_status = mclient.admin.command('replSetGetStatus')
    except pymongo.errors.OperationFailure as e:
        sys.stderr.write("ERROR: {}\n".format(e))
        sys.exit(2)
    for member in rs_status['members']:
        if member['state'] == 2:
            print member['name'].split(':')[0]
            sys.exit(0)
    sys.stderr.write("No members found in 'SECONDARY' state!\n")
    sys.exit(1)

if __name__ == "__main__":
    main()

