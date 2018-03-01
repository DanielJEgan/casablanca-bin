function getLatestBackupForServer {

    if [ "$1" = "" ]
    then
        echo
        echo "ERROR: server name must be provided (unqualified name, e.g. fergus)"
        echo
        exit 1
    fi
    SERVER_NAME=$1

    if [ "$1" = "eric" ]
    then
        database="cmtst"
    else
        database="cmprd"
    fi

    LATEST_BU_DAY=`ssh djegan@jack.collectionsmanager.com.au "ls /var/lib/postgresql/backups/$SERVER_NAME/$database"|tail -1`
    LATEST_BU=`ssh djegan@jack.collectionsmanager.com.au "ls /var/lib/postgresql/backups/$SERVER_NAME/$database/$LATEST_BU_DAY"|grep '\.backup$'|tail -1`
    LOCAL_BU_DIR="/Users/djegan/backups/cm/$SERVER_NAME/database/$LATEST_BU_DAY"


    echo
    echo "Copying $LATEST_BU to $LOCAL_BU_DIR"
    if test -e "$LOCAL_BU_DIR/$LATEST_BU"
    then
        echo $LOCAL_BU_DIR/$LATEST_BU already exists.
    else
        mkdir -p "$LOCAL_BU_DIR"
        scp djegan@jack.collectionsmanager.com.au:/var/lib/postgresql/backups/$SERVER_NAME/$database/$LATEST_BU_DAY/$LATEST_BU $LOCAL_BU_DIR
    fi

}

function restoreLatestLocalBackupForServer {

    if [ "$1" = "" ]
    then
        echo
        echo "ERROR: server name must be provided (unqualified name, e.g. fergus)"
        echo
        exit 1
    fi
    SERVER_NAME=$1


    if [ "$1" = "fergus" ] || [ "$1" = "ethan" ] || [ "$1" = "karen" ] || [ "$1" = "vlad" ] || [ "$1" = "cal" ]
    then
        mainDb=cmdev
    else
        mainDb=cmsbdev
        if [ "$1" = "eric" ]
        then
            backedUpDb=cmtst
        else
            backedUpDb=cmprd
        fi  
    fi  

    MAIN_BACKUP_DIRECTORY=/Users/djegan/backups/cm
    if ! test -e "$MAIN_BACKUP_DIRECTORY"
    then
        echo
        echo 'ERROR: main backup directory "'$MAIN_BACKUP_DIRECTORY'" does not exist'
        echo
        exit 1
    fi

    SERVER_BACKUP_DIRECTORY=$MAIN_BACKUP_DIRECTORY/$SERVER_NAME
    if ! test -e "$SERVER_BACKUP_DIRECTORY"
    then
        echo
        echo 'ERROR: server backup directory "'$SERVER_BACKUP_DIRECTORY'" does not exist'
        echo
        exit 1
    fi

    CMPRD_BACKUP_DIRECTORY=$SERVER_BACKUP_DIRECTORY/$backedUpDb
    if ! test -e "$CMPRD_BACKUP_DIRECTORY"
    then
        echo
        echo 'ERROR: $backedUpDb backup directory "'$CMPRD_BACKUP_DIRECTORY'" does not exist'
        echo
        exit 1
    fi

    LATEST_BU_DAY=`ls /Users/djegan/backups/cm/$SERVER_NAME/$backedUpDb|tail -1`
    if [ "$LATEST_BU_DAY" = "" ]
    then
        echo
        echo "ERROR: no backups found for $SERVER_NAME $backedUpDb"
        echo
        exit 1
    fi

    LOCAL_BU_DIR="/Users/djegan/backups/cm/$SERVER_NAME/$backedUpDb/$LATEST_BU_DAY"
    LATEST_BU=`ls $LOCAL_BU_DIR|grep '\.backup$'|tail -1`
    if [ "$LATEST_BU" = "" ]
    then
        echo
        echo "ERROR: no backups found for $SERVER_NAME $backedUpDb"
        echo
        exit 1
    fi

    echo
    echo "Restoring $LATEST_BU to $mainDb"
    psql -U postgres -h localhost -c "drop database $mainDb"
    psql -U postgres -h localhost -c "create database $mainDb with encoding 'utf8'"
    pg_restore -w -h localhost -U $mainDb -n public --no-owner -d $mainDb "$LOCAL_BU_DIR/$LATEST_BU"
    echo "Restored to $mainDb"
    echo "Deleting xero access tokens"
    psql -h localhost $mainDb $mainDb -c "delete from xero_access_tokens"
    echo "Resetting all passwords"
    psql -h localhost $mainDb $mainDb -c "update users set password = 'x'"
    echo "Finished restoring $LATEST_BU to $mainDb"

}
