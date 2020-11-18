#!python3
'''quick script to grab certain kinds of emails for hard-coded dates.'''
from __future__ import print_function
import logging
import os
import pickle
import imaplib
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import googlesecrets
logger = logging.getLogger()
# import subprocess
try:
    import redis
except ImportError:
    logger.warning('Unable to import python-redis module, caching disabled.')
# import any local project-specific helpers

# If modifying these scopes, delete the file token.pickle.
SCOPES     = ['https://www.googleapis.com/auth/gmail.readonly'] # noqa E221
SCRIPTDATA = 'scriptdata'                                       # noqa E221
TOKENFILE  = 'token.pickle'                                     # noqa E221
CREDJSON   = 'credentials.json'                                 # noqa E221


def get_imap_connection():
    """get_imap_connection.
    Return a pre-authenticated IMAP connection to gmail
    """
    username = 'skyleach@gmail.com'
    password = 'dvlstfwqmcvqzqgi'
    gmail = imaplib.IMAP4_SSL('imap.gmail.com')
    gmail.login(username, password)
    return gmail


def savetokenpickle():
    """savetokenpickle.
    Save the token object to redis if available.
    """
    tokenhash = googledata.tokenhash
    # pikletoken = pickle.pickle(clientid, clientsecret)
    # ok now verify...
    try:
        if not os.path.exists(SCRIPTDATA):
            os.mkdir(SCRIPTDATA)
        with open(os.path.join(SCRIPTDATA, TOKENFILE), 'wb') as token:
            pickle.dump(tokenhash, token)
        with open(os.path.join(SCRIPTDATA, TOKENFILE), 'rb') as token:
            return pickle.load(token)
    except Exception as err:
        # '''Don't do anything yet, this is only here for adding
        # something less cryptic and no stack trace...'''
        raise err


def getredisconn():
    '''Check for a running redis server.  If there, return connection.  If not
    there, start the server.'''
    try:
        return redis.Redis(host='localhost', port='1337', password='mai|dev')
    except Exception as err:
        # TODO: see if we can run redis using our default config.
        raise err


def getlabeltree(service):
    '''use the passed google service (gmail?) to retrieve a list of mail labels
    and then traverse that list building out a tree structure.'''
    results = service.users().labels().list(userId='me').execute()
    labels = results.get('labels', [])
    __import__('pudb').set_trace()
    return labels
    # for label in labels:
    #     # TODO: traverse this node.
    #     logger.info('Traversing {}'.format(label))


def googledemo():
    """Shows basic usage of the Gmail API.
    Lists the user's Gmail labels.
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(SCRIPTDATA) and os.path.exists(
            os.path.join(SCRIPTDATA, TOKENFILE)):
        with open(os.path.join(SCRIPTDATA, TOKENFILE), 'rb') as token:
            creds = pickle.load(token)
    else:
        print('Saving token file [this time]...')
        savetokenpickle()
        with open(os.path.join(SCRIPTDATA, TOKENFILE), 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.

    if not creds or isinstance(creds, dict) or not creds.valid:
        if creds and not isinstance(creds, dict) and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                os.path.join(SCRIPTDATA, CREDJSON), SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(os.path.join(SCRIPTDATA, TOKENFILE), 'wb') as token:
            pickle.dump(creds, token)

    service = build('gmail', 'v1', credentials=creds)

    # Call the Gmail API
    labels = getlabeltree(service)
    # results = service.users().labels().list(userId='me').execute()
    # labels = results.get('labels', [])

    if not labels:
        print('No labels found.')
    else:
        print('Labels:')
        for label in labels:
            print(label['name'])


if __name__ == '__main__':
    # straight IMAP (which may be harder to use than the google API?)
    # gmail = get_imap_connection()
    googledemo()
