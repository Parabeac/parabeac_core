source ./spinner.sh
start_spin "Installing Para-beac core and its dependencies"
tput civis # stop mouse pointer from blinking
cd SketchAssetConverter && npm i
dart pub get
stop_spin
tput cnorm # return mouse pointer
echo -e "\033[1;32m[====]\033[0m Installed Sketch Asset Converter dependencies"


