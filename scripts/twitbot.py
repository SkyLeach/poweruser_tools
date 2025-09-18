#!python
'''Template script for one-off python scripts.  Main function, log setup,
etc...'''
from builtins import object
from builtins import super
from builtins import input
import argparse
import pprint

# Configure Logging Module
import logging


class CustomLogFormatter(logging.Formatter):
    """CustomLogFormatter - Setup class for custom log formatting"""

    err_fmt = "ERROR: %(message)s"
    dbg_fmt = "DEBUG: %(module)s: %(lineno)d: %(message)s"
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
def verbose(self, message, *__args, **__kwargs):
    """verbose.

    :param message:
    String message parameter
    :param __args:
    Any additional non-keyword args packed into a list
    :param __kwargs:
    Any additional keyword args packed into a dict
    """
    # Yes, logger takes its '*__args' as 'args'.
    if self.isEnabledFor(VERBOSE):
        self._log(VERBOSE, message, __args, **__kwargs)


# Create new verbose method/attribute for the logging
setattr(logging.Logger, 'verbose', verbose)
custom_log_format = CustomLogFormatter()
handler_hook = logging.StreamHandler()
handler_hook.setFormatter(custom_log_format)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(message)s',
    handlers=[handler_hook])
logger = logging.getLogger(__name__)


class ExampleObject(object):
    """exampleObject.  Just an example"""

    def __init__(self, *__args, **__kwargs):
        """__init__.

        :param __args:
        :param __kwargs:
        """
        super().__init__(*__args, **__kwargs)


# main loop
if __name__ == "__main__":
    # Arguments
    parser = argparse.ArgumentParser(description="MainTemplate")
    parser.add_argument('--debug', action='store_true')
    parser.add_argument('--verbose', action='store_true')
    pprint.pprint(parser.parse_args)
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
