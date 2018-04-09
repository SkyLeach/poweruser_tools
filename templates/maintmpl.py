#!/usr/bin/env python
from builtins import object, super, input
import sys
import os
import argparse

# Configure Logging Module
import logging

class CustomLogFormatter(logging.Formatter):
    err_fmt  = "ERROR: %(message)s"
    dbg_fmt  = "DEBUG: %(module)s: %(lineno)d: %(message)s"
    # verbose same as info, just filtered
    info_fmt = "%(message)s"

    def __init__(self, fmt="%(msg)s"):
        logging.Formatter.__init__(self, fmt)

    def format(self, record):
        format_orig = self._fmt
        if record.levelno == logging.DEBUG:
            self._fmt = CustomLogFormatter.dbg_fmt
        elif record.levelno == logging.ERROR:
            self._fmt = CustomLogFormatter.err_fmt
        result = super().format(record)
        self._fmt = format_orig
        return result

#########################################################################
# Custom logging formatter, module or whole app if __name__ == '__main__'
# -logger - add custom loglevel
VERBOSE = logging.INFO - 1  # INFO== for verbose logging
logging.addLevelName(VERBOSE, 'VERBOSE')


# add method for verbose logging
def verbose(self, message, *args, **kwargs):
    # Yes, logger takes its '*args' as 'args'.
    if self.isEnabledFor(VERBOSE):
        self._log(VERBOSE, message, args, **kwargs)


logging.Logger.verbose = verbose
custom_log_format = CustomLogFormatter()
handler_hook = logging.StreamHandler()
handler_hook.setFormatter(custom_log_format)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(message)s',
    handlers=[handler_hook])
logger = logging.getLogger(__name__)

class exampleObject(object):
    def __init__(self, *args, **kwargs):
        super().__init__()

# main loop
if __name__ == "__main__":
    # Arguments
    parser = argparse.ArgumentParser(description="MainTemplate")
    parser.add_argument('--debug', action='store_true')
    parser.add_argument('--verbose', action='store_true')
    options, args = parser.parse_args()

    if args.debug:
        logger.setLevel(logging.DEBUG)
    elif args.verbose:
        logger.setLevel(VERBOSE)
    logger.debug('Debug enabled.')
    logger.verbose('Verbose logging enabled.')

    for line in input:
        logger.info(line)

    logger.verbose("Exit Main")
