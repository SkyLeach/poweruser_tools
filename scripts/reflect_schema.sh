#!/usr/bin/env bash
#example shell script for doing declarative base schema reflection

# this is a utility distributed with sqlalchemy, but it almost ceratinly will
# not be on your path if you are in a virtual environment.

# On a mac, I recommend installing python3 with homebrew (because it is WAY
# easier to maintain packages that include c code, even with xcode on your
# system)

# On windows you may have to play with this a bit, but simply adding the
# python3 executable bin directory to your local environment PATH variable
# should be sufficient.  Once there, using pip3 install sqlalchemy should place
# this utility script into your python3 bin directory.
# DB_URL="oracle://user:pass@host.class.tld:port/schema_or_id"
# DB_URL="mysql+pymysql://user:pass@localhost/dbname"
cwd=$(cwd)
execdir="$( cd "$(dirname "$0")" ; pwd -P )"
# TODO: Create plugin to handle model reflection and visualization using coffeescript and python3
# DB_URL="sqlite:///Users/$(whoami)/Library/Application Support/Firefox/Profiles/$(${execdir}/get_ff_profile default)/stylish.sqlite"
DB_URL="sqlite:///Users/$(whoami)/Library/Application Support/Firefox/Profiles/8i9hxp9x.dev-edition-default-1505183723406/stylish.sqlite"


if [ "${1}" ]; then
    ofile="${1}"
else
    ofile="stylish_modelbase.py"
fi

sqlacodegen "${DB_URL}" --outfile "${ofile}"


