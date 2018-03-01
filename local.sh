function getObCommand {
    echo "java -jar "`ls ~/dev/cm/cm/cm-core/target/cm-core*-CmCommandLine.jar|head -1`" -c /Users/djegan/.apxium"
}

function getDevOrTestDb {
    echo "apxiumdev"
}


function getDevOrTestImportDb {
    echo "apxiumimportdev"
}
