'''SkyLeach special utility scripts meant to make my projects (in general) much
more robust and to prevent me having to copy stuff all over the place.

This isn't in it's own repository because it's meant to be copied into repos in
which it is to play a role, but I want to keep useful updates here.'''

from .clean_unicode_spooler import UnicodeSpooledTemporaryFile

__all__ = [UnicodeSpooledTemporaryFile.__name__]
