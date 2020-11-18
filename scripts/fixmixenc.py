#!/usr/bin/env python
'''
A script largely intended for vim users using pathogen or vim modules in a
bundle directory.  It walks through vim/neovim bundles and searches for
documentation files that contain mixed encodings.

If the --in-place option has not been specified, you will only get warnings and
nothing will be changed.

If, however, you specify --in-place then the documentation files that contain
mixed encodings will all be re-encoded as utf-8 and the original files will be
renamed to have the supplied extension.
'''
# python2 compat
from __future__ import print_function, absolute_import
from builtins import super
import sys
import os
import argparse
import logging
import struct
import shutil
import tempfile
# Configure Logging Module
import skypy

logger = logging.getLogger(__name__)


class CustomLogFormatter(logging.Formatter):
    err_fmt  = "ERROR: %(message)s"
    dbg_fmt  = "DEBUG: %(module)s: %(lineno)d: %(message)s"
    # verbose same as info, just filtered
    info_fmt = "%(message)s"

    def __init__(self, fmt="%(message)s"):
        logging.Formatter.__init__(self, fmt)

    def format(self, record):
        format_orig = self._fmt
        if record.levelno == logging.DEBUG:
            self._fmt = self.dbg_fmt
        elif record.levelno == logging.ERROR:
            self._fmt = self.err_fmt
        else:
            self._fmt = self.info_fmt
        result = super().format(record)
        self._fmt = format_orig
        return result


def mixed_to_clean_unicode_tempfile(filehandle):
    """mixed_to_clean_unicode_tempfile
    a 30mb in-memory auto-clean spooled temporary file cleanly converted to
    unicode is yielded to the caller.
    :param filehandle:
    """
    filehandle.seek(0)
    with tempfile.SpooledTemporaryFile(max_size=1024**2 * 30) as spooltemp:
        shutil.copyfileobj(filehandle, spooltemp)
        spooltemp.seek(0)
        yield spooltemp


def read_latin1_raw(docin, offset=0):
    buffer_size = 4096
    outlines = []

    def mixed_text_decoder(datablock):
        if not datablock:
            return
        cunpack = struct.Struct('=c')
        curline = str()
        reset = False
        for coff in range(len(datablock)):
            cchar = cunpack.unpack_from(datablock, coff)[0]
            if cchar == '\n':
                yield curline
                reset = True
            else:
                try:
                    curline += cchar.decode('utf-8')
                except UnicodeDecodeError:
                    curline += cchar.decode('latin-1')
            if reset:
                reset = False
                curline = str()
        # get the last partial, if any
        if curline:
            yield curline

    with open(docin.name, 'rb') as bdocin:
        if offset:
            bdocin.seek(offset)
        datablock = bdocin.read(buffer_size)
        while datablock:
            for line in mixed_text_decoder(datablock):
                outlines.append(line)
            datablock = bdocin.read(buffer_size)
    logger.info('Processed {} lines'.format(len(outlines)))
    return outlines


def readlines_safer(docin, in_place=None):
    counter = 0
    prevline = None
    logger.info('Starting to read {}'.format(docin.name))
    try:
        for docline in docin:
            counter += 1
            prevline = docline
            pass
    except UnicodeDecodeError as ude:
        if counter > 0:
            # if we read multiple lines and *then* have a decode error it's
            # more than likely still a text file only it was encoded as either
            # utf-8 with some latin-1 characters or as latin-1 with some
            # unicode characters.
            # The python3 'helpful' text reader wrapper around io called
            # _io.TextHelperIO doesn't handle this well at all.  Let's take
            # care of it ourselves.
            logger.debug(
                'Problem with line {} in {}'.format(
                    str(counter),
                    docin.name))
            logger.debug(
                'Message was:\n\t{}'.format(str(ude)))
            logger.debug(
                'Previous line:\n\t{}'.format(prevline))
            try:
                # udemsg = str(ude)
                # position = int(re.search('position (\d+)', udemsg).group(1))
                # logger.debug('Trying UnicodeSpooledTemporary')
                # logger.debug('Trying latin1 from pos {}...'.format(position))
                # read_latin1_raw(docin)
                with skypy.UnicodeSpooledTemporaryFile(docin) as ustf:
                    if in_place:
                        with open(docin.name + '_tmp', 'w') as tmpout:
                            shutil.copyfileobj(ustf, tmpout)
                    else:
                        for docline in ustf:
                            counter += 1
                            prevline = docline
            except Exception as e:
                logger.debug('read_latin1_raw failed with:\n\t{}'.format(
                    str(e)))
                return  # we can't do more


def walk_bundles(in_place, path=None):
    """walk_bundles
    Tries to find all documentation files and check them for ascii encoding
    :param path:
    """
    bundle_paths = []
    if not path:
        for evar in ('VIMHOME', 'NVIMHOME'):
            if evar in os.environ:
                # get the real path not symlink so we don't double-apply
                bundlerp = os.path.realpath(
                    os.path.join(
                        os.path.expanduser(os.environ[evar]),
                        'bundle'))
                if bundlerp not in bundle_paths:
                    bundle_paths.append(bundlerp)
        if not bundle_paths:
            # no envvars found, try standard bundle_paths:
            for stdpath in (os.path.expanduser('~/.vim/bundle'),
                    os.path.expanduser('~/.config/nvim/bundle')):
                if os.path.isdir(stdpath):
                    bundle_paths.append(stdpath)
        if not bundle_paths:
            raise FileNotFoundError('Could not find VIMHOME or NVIMHOME or' +
                'bundle dirs in standard locations.')
    else:
        if os.path.isdir(path):
            bundle_paths.append(path)
        else:
            raise FileNotFoundError('{} is not a valid path'.format(path))
    for bpath in bundle_paths:
        for root, dirs, files in os.walk(bpath):
            if os.path.basename(root) == 'doc':
                logger.info('Checking docfiles for {}'.format(root))
                for docfile in map(lambda x: os.path.join(root, x), files):
                    if os.path.splitext(docfile)[1].lower() == '.txt':
                        with open(docfile, 'r') as docin:
                            readlines_safer(docin, in_place=in_place)
                        if in_place and os.path.exists(docfile + '_tmp'):
                            os.rename(docfile, docfile + in_place)
                            os.rename(docfile + '_tmp', docfile)


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


setattr(logging.Logger, 'verbose', verbose)


def main(args=None):
    custom_log_format = CustomLogFormatter()
    handler_hook = logging.StreamHandler()
    handler_hook.setFormatter(custom_log_format)
    logging.basicConfig(
        level=logging.WARN,
        # format='%(message)s',
        handlers=[handler_hook])
    if not args:
        args = sys.argv
    # Arguments
    parser = argparse.ArgumentParser(description="MainTemplate")
    parser.add_argument(
        '--debug',
        action='store_true',
        help='enable debug logging')
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='enable verbose logging')
    parser.add_argument(
        '--in-place',
        default=None,
        help='Replaces the original file, saving a backup with the extension' +
        'provided.')
    parser.add_argument(
        '--bundles',
        action='store_true',
        help='enables vim-bundle mode which goes through vim/neovim bundles' +
        'and searches for documentation files that contain mixed encodings.' +
        '  If the --in-place option has not been specified, you will only ' +
        'get warnings and nothing will be changed.  If, however, you specify' +
        ' --in-place then the documentation files that contain mixed ' +
        'encodings will all be re-encoded as utf-8 and the original files ' +
        'will be renamed to have the supplied extension.')
    parser.add_argument(
        'target',
        nargs='?',
        help='if --bundles is included, this is the path of the bundles dir ' +
        'you wish to process.  Otherwise it is a path to a single file.')
    args = parser.parse_args()
    if args.debug:
        logger.setLevel(logging.DEBUG)
    elif args.verbose:
        logger.setLevel(VERBOSE)
    logger.debug('Debug enabled.')
    logger.verbose('Verbose logging enabled.')
    # TODO: handle things besides vim bundles
    if args.bundles:
        walk_bundles(args.in_place, path=args.target)
    logger.verbose("Exit Main")


# main loop
if __name__ == "__main__":
    main()
