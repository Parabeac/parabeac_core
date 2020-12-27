#!/bin/bash

spin()
{
  text=$*
  spinner=("[    ]" "[=   ]" "[==  ]" "[=== ]" "[ ===]" "[  ==]" "[   =]" "[    ]" "[   =]" "[  ==]" "[ ===]" "[====]" "[=== ]" "[==  ]" "[=   ]")
  backspace=""
  totalSize=$(expr ${#text} + 7)
  for ((i=1;i<=totalSize;i++))
  do
    backspace+="\010"
  done
  while :
  do
    for i in $(seq 0 ${#spinner})
    do
      echo -e -n "\033[1;34m${spinner[i]}\033[0m $text"
      echo -en ${backspace}
      sleep 0.3
    done
  done
}

start_spin(){
  spin $* &
  SPIN_PID=$!
}

stop_spin(){
  kill -9 $SPIN_PID
}

# only install dependencies if SAC_ENDPOINT envvar is not set
if [[ -z "${SAC_ENDPOINT}" ]]; then
  start_spin "Installing Parabeac-core and its dependencies"
  tput civis # stop mouse pointer from blinking
  cd ./SketchAssetConverter && npm i # Assuming install.sh is being run from Parabeac-Core directory
  pub get
  stop_spin
  tput cnorm # return mouse pointer
  echo -e "\033[1;32m[====]\033[0m Installed Sketch Asset Converter dependencies"
fi
