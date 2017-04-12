function getDbNameForServer {

    if [ "$#" != "1" ]
    then
        >&2 echo
        >&2 echo "function getDbNameForServer: expected one parameter (server)"
        >&2 echo
        exit 1
    fi

    if [ "$1" = "sam" ] || [ "$1" = "fergus" ] || [ "$1" = "ethan" ] || [ "$1" = "karen" ] || [ "$1" = "vlad" ] || [ "$1" = "cal" ]
    then
        echo 'cmprd'
    elif [ "$1" = "eric" ]
    then
        echo 'cmtst'
    elif [ "$1" = "claudia" ]
    then
        echo 'obpaystage'
    elif [ "$1" = "sabine" ]
    then
        echo 'obpay'
    else
        >&2 echo
        >&2 echo 'Unknown server "'$1'"'
        >&2 echo
        exit 1
    fi

}

function getFullyQualifiedNameForServer {

    if [ "$#" != "1" ]
    then
        >&2 echo
        >&2 echo "function getFullyQualifiedNameForServer: expected one parameter (server)"
        >&2 echo
        exit 1
    fi

    if [ "$1" = "fergus" ] || [ "$1" = "ethan" ] || [ "$1" = "karen" ] || [ "$1" = "vlad" ] || [ "$1" = "cal" ]
    then
        echo "$1.onebox.net.au"
    else
        echo "$1.apxium.com"
    fi

}

function getBackupFilepathForServer {

    if [ "$#" != "2" ]
    then
        >&2 echo
        >&2 echo "function getBackupFilepathForServer: expected two parameters (server and database)"
        >&2 echo
        exit 1
    fi

    # Set and check MAIN_BACKUP_DIR
    MAIN_BACKUP_DIR=$HOME/backups/cm
    if ! test -e $MAIN_BACKUP_DIR
    then
        >&2 echo $MAIN_BACKUP_DIR  does NOT exist
        exit 1
    fi

    # Set and create HOST_BACKUP_DIR if necessary
    HOST_BACKUP_DIR=$MAIN_BACKUP_DIR/$1
    if ! test -e $HOST_BACKUP_DIR
    then
        mkdir "$HOST_BACKUP_DIR"
    fi

    TIMESTAMP=`date -v+30M +%Y%m%d-%H%M`

    echo $HOST_BACKUP_DIR/$1-$2-$TIMESTAMP.backup

}

function backupRemoteDatabase {

    if [ "$#" != "3" ]
    then
        >&2 echo
        >&2 echo "function backupRemoteDatabase: expected three parameters (fully qualified server name, database, and backup filepath)"
        >&2 echo
        exit 1
    fi

    ssh onebox@$1 "pg_dump  -h localhost -U postgres -vFc $2" 2> $3.log > $3

}

function backupRemoteObpayDatabase {

    if [ "$#" != "3" ]
    then
        >&2 echo
        >&2 echo "function backupRemoteDatabase: expected three parameters (fully qualified server name, database, and backup filepath)"
        >&2 echo
        exit 1
    fi

    ssh djegan@$1 "sudo -iu postgres pg_dump -vFc $2" 2> $3.log > $3

}

function remoteDbBackup {

    if [ "$#" != "1" ]
    then
        >&2 echo
        >&2 echo "function remoteDbBackup: expected one parameter (the server)"
        >&2 echo
        exit 1
    fi

    DBNAME=`getDbNameForServer $1`
    SERVER=`getFullyQualifiedNameForServer $1`
    BACKUP_FILEPATH=`getBackupFilepathForServer $1 $DBNAME`

    backupRemoteDatabase $SERVER $DBNAME $BACKUP_FILEPATH

    echo $BACKUP_FILEPATH

}


function remoteObpayDbBackup {

    if [ "$#" != "1" ]
    then
        >&2 echo
        >&2 echo "function remoteDbBackup: expected one parameter (the server)"
        >&2 echo
        exit 1
    fi

    DBNAME=`getDbNameForServer $1`
    SERVER=`getFullyQualifiedNameForServer $1`
    BACKUP_FILEPATH=`getBackupFilepathForServer $1 $DBNAME`

    backupRemoteObpayDatabase $SERVER $DBNAME $BACKUP_FILEPATH

    echo $BACKUP_FILEPATH

}
