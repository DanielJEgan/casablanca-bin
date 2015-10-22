
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

    if [ `git --git-dir="$ROOT_DIR/.git" --work-tree="$ROOT_DIR" status|grep 'Your branch is ahead'|wc -l` -gt 0 ]
    then
        return 0
    else
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

function verifyPomFileHasASnapshotVersion {

    # Check valid current version in pom file
    if ! mvn blah|egrep '^\[INFO\] Building .+ [0-9]+\.[0-9]+\.[0-9]+-SNAPSHOT$' >/dev/null
    then
        echo
        echo ERROR: Project does not seem to have a -SNAPSHOT version
        echo
        exit 1
    fi

}