''' A failsafe wrapper for python3 unicode text file handling and also a
working example of using UltiSnips'''
import tempfile
import struct
import logging
logger = logging.getLogger(__name__)


def mixed_text_decoder(datablock):
    if isinstance(datablock, str):
        return datablock
    cunpack = struct.Struct('=c')
    result = str()
    for coff in range(len(datablock)):
        cchar = cunpack.unpack_from(datablock, coff)[0]
        try:
            result += cchar.decode('utf-8')
        except UnicodeDecodeError:
            result += cchar.decode('latin-1')
    return result


def UnicodeSpooledTemporaryFile(orig_fh, *args, **kwargs):  # noqa=N802
    '''UnicodeSpooledTemporary
    Wraps tempfile.SpooledTemporaryFile functionality to safely enxure that the
    passed orig_fh is cleanly converted from a malformed mixed encoding to a
    pure unicode (utf-8) encoded file.'''
    if 'max_size' not in kwargs:
        if not args or not isinstance(int, args[0]):
            kwargs['max_size'] = 1024**2 * 30
    buffer_size = 4096
    stf = tempfile.SpooledTemporaryFile(*args, **kwargs)
    with open(orig_fh.name, 'r+b') as ofnfh:
        datablock = ofnfh.read(buffer_size)
        while datablock:
            stf.write(mixed_text_decoder(datablock).encode('UTF-8'))
            datablock = orig_fh.read(buffer_size)
    stf.seek(0)
    return stf
