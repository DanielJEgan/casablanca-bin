
function restoreBackup {

    if [ "$1" = "" ]
    then
        >&2 echo
        >&2 echo "ERROR: local dbname must be provided"
        >&2 echo
        exit 1
    fi
    LOCAL_DBNAME=$1

    if [ "$2" = "" ]
    then
        >&2 echo
        >&2 echo "ERROR: backup filepath must be provided"
        >&2 echo
        exit 1
    fi
    BACKUP_FILEPATH=$2

    echo "Restoring $BACKUP_FILEPATH to $LOCAL_DBNAME"
    psql -U postgres -h localhost -c "drop database $LOCAL_DBNAME"
    psql -U postgres -h localhost -c "create database $LOCAL_DBNAME with encoding 'utf8'"
    pg_restore -w -h localhost -U $LOCAL_DBNAME -n public --no-owner -d $LOCAL_DBNAME "$BACKUP_FILEPATH"
    echo "Restored to $LOCAL_DBNAME"
    echo "Deleting xero access tokens"
    psql -h localhost $LOCAL_DBNAME $LOCAL_DBNAME -c "delete from xero_access_tokens"
    echo "Resetting all passwords"
    psql -h localhost $LOCAL_DBNAME $LOCAL_DBNAME -c "update users set password = 'x'"
    echo "Finished restoring $BACKUP_FILEPATH to $LOCAL_DBNAME"

}