#!/usr/bin/env python -w
# set us up teh bomb
from setuptools import setup, find_packages
import os
import platform
from subprocess import check_output
scripts = []


# TODO: update all scritps in scritps/* then come back and remove fixmixenc
# filter
def scripts_to_entry_points(slist):
    ''' will auto-generate a list of exported scripts for /usr/local/bin or
    virtualenv/bin once I've ensured all of the scripts in that path are
    actually ready for it.'''
    for script in slist:
        sfn, sext = os.path.splitext(os.path.basename(script))
        if sext == '.py' and sfn == 'fixmixenc':
            yield '{}=scripts.{}:main'.format(sfn, sfn)


for (path, directories, filenames) in os.walk("scripts"):
    for filename in filenames:
        scripts.append(os.path.join("..", path, filename))
built_entry_points = scripts_to_entry_points(scripts)
if platform.system().lower() == 'darwin':
    cellar = check_output(['brew', '--cellar', 'lzo'])[:-1]
    os.environ['C_INCLUDE_PATH'] = \
        '%s/2.09/include/lzo:%s/2.09/include/' % (cellar, cellar)
    os.environ['LIBRARY_PATH'] = '/usr/local/lib'

# noqa=E251
setup(
    name        = 'putools',  # noqa=E251
    version     = '0.0.1',  # noqa=E251
    description = 'SkyLeach poweruser_tools',  # noqa=E251
    url         = 'https://github.com/SkyLeach/poweruser_tools',  # noqa=E251
    packages    = find_packages(),  # noqa=E251
    install_requires=[
        'future>=0.10',
    ],
    entry_points={
        'console_scripts': list(built_entry_points),
        },
    package_data = {'': scripts}  # noqa=E251
)
