#!python
import sympy
import logging
logger = logging.getLogger(__name__)


def get_los_eq(a=None, b=None, c=None):
    '''Assume a opposite known angle'''
    pass

from importlib import reload

try:
    localhost_common = __import__('localhost_common')
except ImportError as ie:
    pass

if __name__ == '__main__':
    logger.info('Ready')
