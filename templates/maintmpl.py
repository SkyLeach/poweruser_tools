#!python
'''Template script for one-off python scripts.  Main function, log setup,
etc...'''
from builtins import object
from builtins import super
from builtins import input
import os
import sys
import argparse
import pprint

# Configure Logging Module
import logging


def pathwalker_gen(startpath,prune=[]):
    def skip(t):
        for p in prune:
            if p in t: return True
        return False
    for root, dirs, files in os.walk(startpath):
        level = root.replace(startpath, '').count(os.sep)
        # indent = ' ' * 4 * (level)
        if skip(root): continue
        # print('{}{}/'.format(indent, os.path.basename(root)))
        # subindent = ' ' * 4 * (level + 1)
        for f in files:
            if skip(f): continue
            yield f
            # print('{}{}'.format(subindent, f))

def load_module(self, fullname):
    """
    Iterate over the search path to locate and load fullname.
    """
    root, base, target = fullname.partition(self.root_name + '.')
    for prefix in self.search_path:
        try:
            extant = prefix + target
            __import__(extant)
            mod = sys.modules[extant]
            sys.modules[fullname] = mod
            return mod
        except ImportError:
            pass
    else:
        raise ImportError(
            "The '{target}' package is required; "
            "normally this is bundled with this package so if you get "
            "this warning, consult the packager of your "
            "distribution.".format(**locals())
        )

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
