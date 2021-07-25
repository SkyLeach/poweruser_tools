#!python3
'''Template script for one-off python scripts.  Main function, log setup,
etc...'''
from builtins import object
from builtins import super
import pathlib
import argparse
import pprint

# Configure Logging Module
import logging
from typing import Optional
logger = logging.getLogger(__name__)
import os

def list_files(startpath,prune=[]):
    def skip(t):
        for p in prune:
            if p in t: return True
        return False
    for root, dirs, files in os.walk(startpath):
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * (level)
        if skip(root): continue
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            if skip(f): continue
            print('{}{}'.format(subindent, f))

if __name__ == "__main__":
    logging.basicConfig()
    parser = argparse.ArgumentParser(
        description="Directory tree structure view.")
    parser.add_argument('treepath', type=pathlib.Path, help="A path to tree")
    parser.add_argument('-prune', type=str, nargs='?', dest='prune', 
                        help="One more more strings to prune.")
    args = parser.parse_args()
    if not os.path.isdir(args.treepath):
        logger.warning("'{}' not a directory".format(args.treepath))
        parser.print_usage()
    list_files(str(args.treepath),[args.prune])
