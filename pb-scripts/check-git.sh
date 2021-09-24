# Script to verify that SAC was pulled and pointing to master 

parentCom=`git rev-parse HEAD`

cd SketchAssetConverter

git fetch

currentCom=`git rev-parse HEAD`
# echo $currentComi

if [ $parentCom == $currentCom ]
then
    cd ..
    temp=`git submodule update --init`
    temp2=`git pull --recurse-submodules`
    cd SketchAssetConverter
    git fetch
    currentCom=`git rev-parse HEAD`
    echo "Downloading submodule SketchAssetConverter"
else
    cd ..
    masterCom=`git rev-parse @:SketchAssetConverter`

    if [ $masterCom == $currentCom ]
    then
        echo "Sketch Asset Converter is up to date!"
    else
        echo "Sketch Asset Converter is behind master."
    fi
fi
