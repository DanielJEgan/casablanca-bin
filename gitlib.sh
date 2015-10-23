function modificationsExist {

    if [ "$1" = "" ]
    then
        local ROOT_DIR="."
    else
        local ROOT_DIR="$1"
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
        local ROOT_DIR="."
    else
        local ROOT_DIR="$1"
    fi

    if [ `git --git-dir="$ROOT_DIR/.git" --work-tree="$ROOT_DIR" status|grep 'Your branch is ahead'|wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi

}

function headDetached {

    if [ "$1" = "" ]
    then
        local ROOT_DIR="."
    else
        local ROOT_DIR="$1"
    fi

    if [ `git --git-dir="$ROOT_DIR/.git" --work-tree="$ROOT_DIR" status|grep 'HEAD detached'|wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi

}

function verifyCurrentBranch {

    # Check current branch
    if [ "$1" != "$2" ]
    then
        echo
        echo "ERROR: You are not on the $2 branch (you are on $1)"
        echo
        exit 1
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

function verifyLocalTagDoesNotExist {

    if git tag|egrep '^'$1'$' >/dev/null
    then
        echo
        echo ERROR: Tag $1 exists
        echo
        exit 1
    fi

}

function verifyTagDoesNotExist {

    if git tag|egrep '^'$1'$' >/dev/null
    then
        echo
        echo ERROR: Tag $1 exists
        echo
        exit 1
    fi

    if git ls-remote --tags origin|egrep '.*refs/tags/'$1'$' >/dev/null
    then
        echo
        echo ERROR: Tag $1 exists at origin
        echo
        exit 1
    fi

}

function verifyPomFileHasASnapshotVersion {

    # Check valid snapshot version in pom file
    if ! mvn blah|egrep '^\[INFO\] Building .+ [0-9]+\.[0-9.]*[0-9]+-SNAPSHOT$' >/dev/null
    then
        echo
        echo ERROR: Project does not seem to have a -SNAPSHOT version
        echo
        exit 1
    fi

}

function extractNonSnapshotVersionIfPresent {

    mvn blah|egrep '^\[INFO\] Building .+ [0-9]+\.[0-9.]*[0-9]+$'|sed 's/^\[INFO\] Building .* //'

}

function extractSnapshotVersionIfPresent {

    mvn blah|egrep '^\[INFO\] Building .+ [0-9]+\.[0-9.]*[0-9]+-SNAPSHOT$'|sed 's/^\[INFO\] Building .* //'

}

function extractVersionFromNonSnapshotVersionIfPresent {

    local SNAPSHOT_VERSION=`extractSnapshotVersionIfPresent`
    if [ "$SNAPSHOT_VERSION" != "" ]
    then
        echo $SNAPSHOT_VERSION | sed 's/-SNAPSHOT$//'
    fi

}

function verifyPomFileHasANonSnapshotVersion {

    # Check valid snapshot version in pom file
    if ! mvn blah|egrep '^\[INFO\] Building .+ [0-9]+\.[0-9.]*[0-9]+$' >/dev/null
    then
        echo
        echo "ERROR: Project does not seem to have a valid (non-SNAPSHOT) version"
        echo
        exit 1
    fi

}

function filterOutInvalidVersions {
    echo $1 | egrep '^[0-9]+\.[0-9.]*[0-9]+$'
}

function verifyHeadIsNotDetached {


    # Check there are no "un-pushed" commits
    if headDetached .
    then
        echo
        echo "ERROR: The head is detached (you are not at the head of the current branch)"
        echo
        exit 1
    fi

}

function confimBeforeProceeding {

    # Confirm before proceeding
    while true; do
        echo
        read -p "$1" yn
        case $yn in
            [Yy] ) break;;
            [Nn] ) echo;exit;;
            * ) echo "   Please answer y or n.";;
        esac
    done
    echo

}

function checkout {

    echo "  - Checking out $1"
    if ! git checkout -q "$1"
    then
        exit 1
    fi

}

function checkoutOnANewBranch {

    echo "  - Creating new branch $1"
    if ! git checkout -q --no-track -b "$1"
    then
        exit 1
    fi

}

function checkoutOnANewBranchAndTrack {

    echo "  - Creating new branch $1"
    if ! git checkout -q --track -b "$1"
    then
        exit 1
    fi

}

function deleteBranch {

    echo "  - Deleting branch $1"
    if ! git branch -q -D "$1"
    then
        exit 1
    fi

}

function updatePomfileVersions {

    echo "  - Setting POM file version to $1"
    if ! mvn versions:set -q -DgenerateBackupPoms=false -DnewVersion=$1 >/dev/null
    then
        exit 1
    fi

}

function addAllModificationsAndCommitWithMessage {

    echo "  - Adding and committing all modifications"
    if ! git add -A
    then
        exit 1
    fi
    if ! git commit -q -m "$1"
    then
        exit 1
    fi

}

function tagAndPushTagToOrigin {

    echo "  - Creating tag $1 and pushing to origin"
    if ! git tag $1
    then
        exit 1
    fi
    if ! git push -q origin "$1"
    then
        exit 1
    fi

}

function printMostRecentVersion {

    git ls-remote --tags origin | egrep '.*refs/tags/v[0-9]+\.[0-9.]*[0-9]+$'|sed 's,.*refs/tags/v,,'|sort -t . -n -k 1,1 -k 2,2 -k 3,3 -k 4,4 -k 5,5 -k 6,6 -k 7,7 -k 8,8 -k 9,9 | tail -1

}

function printNextVersion {

    local LAST_VERSION=`printMostRecentVersion`
    if [ "$LAST_VERSION" != "" ]
    then

        local MINOR_RELEASE=`echo $LAST_VERSION|sed 's/.*\.//'`
        local NEXT_VERSION=`echo $LAST_VERSION|sed 's/[^.]*$//'`$(($MINOR_RELEASE + 1))
        echo $NEXT_VERSION
    else

        echo "1.0.1"

    fi

}

function verifyIsNextVersion {

    local _NEXT_VERSION=`printNextVersion`
    if [ "$_NEXT_VERSION" = "" ]
    then
        return 0
    fi
    if [ "$1" != "$_NEXT_VERSION" ]
    then
        echo
        echo "ERROR: $1 is not the next version ($_NEXT_VERSION)"
        echo
        exit 1
    fi

}

function chooseReleaseCandidateVersion {

    local candidates=( $(git ls-remote --tags origin | egrep '.*refs/tags/v[0-9]+\.[0-9.]*[0-9]+_rc[0-9]+$'|sed 's,.*refs/tags/v,,') )

    echo
    echo "  Please choose a release candidate"
    echo

    for i in `seq 0 $((${#candidates[@]} - 1))`;
    do
        printf "  %3d:  %s\n" $(($i + 1)) ${candidates[$i]}
    done

    local CHOICE=""
    while true; do
        echo
        if [ "$CHOICE" != "" ]
        then
            read -p "   Choose a number [$CHOICE] ? " value
        else
            read -p "   Choose a number ? " value
        fi
        if [ "$value" != "" ]
        then
            let numberChoice=0+$value
            if [ $numberChoice -lt 1 ] || [ $numberChoice -gt ${#candidates[@]} ]
            then
                echo "   $value is not a valid choice, please re-enter"
            else
                local CHOICE="$numberChoice"
                break
            fi
        else
            echo "   Please enter the number of the item to choose"
        fi
    done

    RELEASE_CANDIDATE_VERSION=${candidates[$(($CHOICE - 1))]}

}