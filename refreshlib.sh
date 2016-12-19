
function  refreshMainSystemEtc {

    if [ "$#" != "4" ]
    then
        >&2 echo
        >&2 echo "function refreshMainSystemEtc: expected four parameters (ob command, server, main db, and import db)"
        >&2 echo
        exit 1
    fi

    obd=$1
    SERVER=$2
    mainDb=$3
    importDb=$4


    echo
    echo "    This will completely blow away all data in the main database and the import"
    echo "    database as well as deleting everything in the emailArchive and fileStore."
    confimBeforeProceeding "    Are you sure you want to do this (y/n) ?"

    echo
    echo ===== Backing up main database on $SERVER to local filesystem and restoring to local database $mainDb
    BACKUP_FILEPATH=`remoteDbBackup $SERVER`
    restoreBackup $mainDb $BACKUP_FILEPATH

    echo
    echo -n ===== Running obd upgradedb
    $obd upgradedb

    echo
    echo ===== Recreating $importDb
    psql -h localhost postgres postgres -c "drop database $importDb"
    psql -h localhost postgres postgres -c "create database $importDb"

    echo
    echo -n ===== Running obd createimportdb
    $obd createimportdb

    echo
    echo ===== Flushing fileStore and emailArchive
    rm -rf ~/fileStore/*
    echo - flushed fileStore
    rm -rf ~/emailArchive/*
    echo - flushed emailArchive

    echo

}

function  refreshObpay {

    if [ "$#" != "2" ]
    then
        >&2 echo
        >&2 echo "function refreshObpay: expected two parameters (server and local db)"
        >&2 echo
        exit 1
    fi

    SERVER=$1
    localDb=$2


    echo
    echo "    This will completely blow away all data in the $localDb database."
    confimBeforeProceeding "    Are you sure you want to do this (y/n) ?"

    echo
    echo ===== Backing up obpay database on $SERVER to local filesystem and restoring to local database $localDb
    BACKUP_FILEPATH=`remoteObpayDbBackup $SERVER`
    restoreObpayBackup $localDb $BACKUP_FILEPATH

    echo

}

function  refreshObPayAfterConfirmation {
    echo
    echo "    Would you also like to refresh ObPay data?  This will delete"
    echo "    all data currently in ObPay.  This could be an issues if any other"
    echo "    servers are also configured to use this ObPay server."
    echo "    Note that this will only work for ObPay servers that support"
    echo "    it (e.g. DummyPaymentGateway and obpay-blackhole)"
    while true; do
        read -p "    Are you sure you want to clear out ObPay (y/n) ?" yn
        case $yn in
            [Yy] ) echo;echo  ===== Running obd reset-obpay;$obd reset-obpay;echo - flushed ObPay;break;;
            [Nn] ) echo;break;;
            * ) echo "   Please answer y or n.";;
        esac
    done
}
