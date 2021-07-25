"""
File: kitty_b64dump.py
Author: SkyLeach
Email: skyleach@gmail.com
Github: https://github.com/skyleach/poweruser_tools
Description: Simple script to dump base64 kitt-encoded text to terminals that can handle the kitty graphic output format.
"""
import sys
from base64 import standard_b64encode


def serialize_gr_command(cmd, payload=None):
    cmd = ','.join('{}={}'.format(k, v) for k, v in cmd.items())
    ans = []
    w = ans.append
    w(b'\033_G'), w(cmd.encode('utf8'))
    if payload:
        w(b';')
        w(payload)
        w(b'\033\\')
        return b''.join(ans)


def write_chunked(cmd, data):
    data = standard_b64encode(data)
    while data:
        chunk, data = data[:4096], data[4096:]
        m = 1 if data else 0
        cmd['m'] = m
        sys.stdout.write(serialize_gr_command(cmd, chunk))
        # sys.stdout.buffer.write(serialize_gr_command(cmd, chunk))
        sys.stdout.flush()
        cmd.clear()


with open(sys.argv[-1], 'rb') as f:
    write_chunked({'a': 'T', 'f': 100}, f.read())
