function confimBeforeProceeding {

    # Confirm before proceeding
    while true; do
        read -p "$1" yn
        case $yn in
            [Yy] ) break;;
            [Nn] ) echo;exit;;
            * ) echo "   Please answer y or n.";;
        esac
    done
    echo

}
