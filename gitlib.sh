
echo flag1.1

function modificationsExist {

    echo modificationsExist flag1

    if [ "$1" = "" ]
    then
        ROOT_DIR="."
    else
        ROOT_DIR="$1"
    fi

    if [ `git --git-dir="$ROOT_DIR/.git" --work-tree="$ROOT_DIR" status --porcelain|wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi

}

function verifyNoUncommittedChanges {

    echo verifyNoUncommittedChanges flag1


    # Check there are no uncommitted changes
    if modificationsExist .
    then
        echo
        echo ERROR: There are uncommitted changes
        echo
        exit 1
    fi

}

echo flag1.2