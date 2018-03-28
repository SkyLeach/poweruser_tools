#!/usr/bin/env python2.7
# vim: ts=4 sw=4 sts=4 et

# global
import tempfile
import os
import sys
import unittest
import logging
import pprint
import shutil

# module-level logger
logger = logging.getLogger(__name__)

# module-global test-specific imports
# where to put test output data for compare.
testdatadir = os.path.join('.', 'test', 'test_data')
rawdata_dir = os.path.join(os.path.expanduser('~'), 'Downloads')
testfiles = (
        'bogus.data',
    )
purge_results = False
output_dir = os.path.join('test_data', 'example_out')


def cleanPath(path):
    """cleanPath
    Recursively removes everything below a path

    :param path:
    the path to clean
    """
    for root, files, dirs in os.walk(path):
        for fn in files:
            logger.debug('removing {}'.format(fn))
            os.unlink(os.path.join(root, fn))
        for dn in dirs:
            # recursive
            try:
                logger.debug('recursive del {}'.format(dn))
                shutil.removedirs(dn)
            except Exception as err:
                # for now, halt on all.  Override with shutil onerror
                # callback and ignore_errors.
                raise


class TestChangeMe(unittest.TestCase):
    '''
        TestChangeMe
    '''
    testdatadir = None
    rawdata_dir = None
    testfiles   = None
    output_dir  = output_dir

    def __init__(self, *args, **kwargs):
        self.testdatadir = os.path.join(os.path.dirname(
            os.path.abspath(__file__)), testdatadir)
        super(TestChangeMe, self).__init__(*args, **kwargs)
        # check for kwargs
        # this allows test control by instance
        self.testdatadir = kwargs.get('testdatadir', testdatadir)
        self.rawdata_dir = kwargs.get('rawdata_dir', rawdata_dir)
        self.testfiles = kwargs.get('testfiles', testfiles)
        self.output_dir = kwargs.get('output_dir', output_dir)

    def setUp(self):
        """setUp
        pre-test setup called before each test
        """
        logging.debug('setUp')
        if not os.path.exists(self.testdatadir):
            os.mkdir(self.testdatadir)
        else:
            self.assertTrue(os.path.isdir(self.testdatadir))
        self.assertTrue(os.path.exists(self.testdatadir))
        cleanPath(self.testdatadir)

    def tearDown(self):
        """tearDown
        post-test cleanup, if required
        """
        logging.debug('tearDown')
        if purge_results:
            cleanPath(self.output_dir)

    def test_something_0(self):
        """test_something_0
            auto-run tests sorted by ascending alpha
        """
        pass

    def default_test(self):
        """testFileDetection
        Tests all data files for type and compares the results to the current
        stored results.
        """
        for testfile in self.testfiles:
            self.assertTrue(os.path.exists(testfile))


# stand-alone test execution
if __name__ == '__main__':
    import nose2
    nose2.main(argv=[
            'fake',
            '--log-capture',
            'TestChangeMe.default_test',
        ])

