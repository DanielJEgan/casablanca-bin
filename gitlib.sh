
function modificationsExist {

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

function unpushedCommitsExist {

    if [ "$1" = "" ]
    then
        ROOT_DIR="."
    else
        ROOT_DIR="$1"
    fi

    if [ `git --git-dir="$ROOT_DIR/.git" --work-tree="$ROOT_DIR" status|grep '# Your branch is ahead'|wc -l` -gt 0 ]
    then
        echo flag unpushedCommitsExist true
        return 0
    else
        echo flag unpushedCommitsExist false
        return 1
    fi

}

function verifyNoUncommittedChanges {

    # Check there are no uncommitted changes
    if modificationsExist .
    then
        echo
        echo ERROR: There are uncommitted changes
        echo
        exit 1
    fi

}

function verifyNoUnpushedCommits {

    # Check there are no "un-pushed" commits
    if unpushedCommitsExist .
    then
        echo
        echo ERROR: There are \"un-pushed\" commits
        echo
        exit 1
    fi

}