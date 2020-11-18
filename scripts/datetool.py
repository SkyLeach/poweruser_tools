#!python
''' Really quick tool for returning specific information about calendars
(Gregorian)'''
from builtins import object
from builtins import super
from builtins import input
import argparse
import pprint
from datetime import date

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


class DateObject(object):
    """exampleObject.  Just an example"""

    def __init__(self, *__args, **__kwargs):
        """__init__.

        :param __args:
        :param __kwargs:
        """
        super().__init__(*__args, **__kwargs)

    @staticmethod
    def get_date_info():
        '''blurp'''
        # TODO: make date range dynamic
        # TODO: make requested result dynamic

        # d0 = date(2020, 1, 19)
        # d1 = date(2020, 6, 30)
        # delta = d1 - d0
        # print(delta.weeks)

        return (date(2021, 4, 30) - date(2020, 10, 1)).days * 24 * 60


# main loop
if __name__ == "__main__":
    # Arguments
    parser = argparse.ArgumentParser(description="MainTemplate")
    parser.add_argument('--debug', action='store_true')
    parser.add_argument('--verbose', action='store_true')
    pprint.pprint(parser.parse_args())
    # options, args = parser.parse_args()

    # if args.debug:
    #     logger.setLevel(logging.DEBUG)
    # elif args.verbose:
    #     logger.setLevel(VERBOSE)
    # logger.debug('Debug enabled.')
    # logger.verbose('Verbose logging enabled.')

    pprint.pprint(DateObject.get_date_info())

    logger.verbose("Exit Main")
