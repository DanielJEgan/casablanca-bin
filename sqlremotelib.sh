function runOnServer {

    if [ "$1" = "" ]
    then
        echo
        echo "ERROR: server name must be provided (unqualified name, e.g. fergus)"
        echo
        exit 1
    fi
    SERVER_NAME=$1

    if [ "$2" = "" ]
    then
        echo
        echo "ERROR: sql must be provided"
        echo
        exit 1
    fi
    SQL="$2"

    echo
    echo
    echo ===== $1 =====
    if [ "$1" = "fergus" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "ethan" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "karen" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "vlad" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "cal" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    else
        ssh onebox@$SERVER_NAME.apxium.com 'psql -h localhost cmprd cmprd -c "'"$SQL"'"'
    fi

}

function runOnServerT {

    if [ "$1" = "" ]
    then
        echo
        echo "ERROR: server name must be provided (unqualified name, e.g. fergus)"
        echo
        exit 1
    fi
    SERVER_NAME=$1

    if [ "$2" = "" ]
    then
        echo
        echo "ERROR: sql must be provided"
        echo
        exit 1
    fi
    SQL="$2"

    echo
    echo
    echo ===== $1 =====
    if [ "$1" = "fergus" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    elif [ "$1" = "ethan" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    elif [ "$1" = "karen" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    elif [ "$1" = "vlad" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    elif [ "$1" = "cal" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    else
        ssh onebox@$SERVER_NAME.apxium.com 'psql -h localhost cmtst cmtst -c "'"$SQL"'"'
    fi

}

function runOnServerX {

    if [ "$1" = "" ]
    then
        echo
        echo "ERROR: server name must be provided (unqualified name, e.g. fergus)"
        echo
        exit 1
    fi
    SERVER_NAME=$1

    if [ "$2" = "" ]
    then
        echo
        echo "ERROR: sql must be provided"
        echo
        exit 1
    fi
    SQL="$2"

    echo
    echo
    echo ===== $1 =====
    if [ "$1" = "fergus" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "ethan" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "karen" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "vlad" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    elif [ "$1" = "cal" ]
    then
        ssh onebox@$SERVER_NAME.onebox.net.au 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    else
        ssh onebox@$SERVER_NAME.apxium.com 'psql -x -h localhost cmprd cmprd -c "'"$SQL"'"'
    fi

}
