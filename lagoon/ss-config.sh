#!/bin/sh

# Override sliverstripe environment variables.
export SS_DATABASE_CLASS="MySQLDatabase"
[ ${MARIADB_HOST+x} ] && export SS_DATABASE_SERVER="${MARIADB_HOST}"
[ ${MARIADB_DATABASE+x} ] && export SS_DATABASE_NAME="${MARIADB_DATABASE}"
[ ${MARIADB_USERNAME+x} ] && export SS_DATABASE_USERNAME="${MARIADB_USERNAME}"
[ ${MARIADB_PASSWORD+x} ] && export SS_DATABASE_PASSWORD="${MARIADB_PASSWORD}"

if [ $LAGOON_ENVIRONMENT_TYPE == "production" ]; then
    export SS_ENVIRONMENT_TYPE="live"
else
    export SS_ENVIRONMENT_TYPE="test"
fi
