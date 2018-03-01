function getObCommand {
    echo "java -jar "`ls ~/dev/cm/cm2/cm-core/target/cm-core*-CmCommandLine.jar|head -1`" -c /Users/djegan/.apxium2"
}

function getDevOrTestDb {
    echo "apxium2dev"
}


function getDevOrTestImportDb {
    echo "apxium2importdev"
}
