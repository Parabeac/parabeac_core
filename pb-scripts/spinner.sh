#!/bin/bash

SPIN_PID=$!

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
  kill -13 $SPIN_PID &
}