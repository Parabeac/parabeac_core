# Script to verify that SAC is pointing to master 

cd SketchAssetConverter

git fetch

masterCom=`git rev-parse master`
# echo $masterCom
currentCom=`git rev-parse HEAD`
# echo $currentCom

if [ $masterCom == $currentCom ]
then
    echo "Sketch Asset Converter is up to date!"
else
    echo "Sketch Asset Converter is behind master."
fi