#!/bin/bash
#@author: SushiRoll53

# -> Name of the project
project=parabeac_core

cat pb-scripts/parabird.txt

cd lib/eggs

# ==========================================
# Download eggs if link is provided
# ==========================================
if [ -z "${1}" ]
then
    echo "[INFO]: No URL provided"
else
    if [ -z "${2}" ]
    then
        echo "[INFO]: No Credentials provided"
    else
        if [ -z "${3}" ]
        then
            echo "[INFO]: No Credentials provided"
        else
            bash ../../pb-scripts/automate.sh $2 us-east-1 s3 $3 $1
        fi
    fi
fi

counter=0

# ==========================================
# To collect eggs information
# ==========================================
for f in *.dart 
do
    # -> To get import of file
    saved[counter]="import@'package:$project/eggs/$f';"
    # echo ${saved[counter]} # Uncomment to debug

    # -> To get file semantics
    temp="`grep -n "semanticName =" $f`"
    temp=${temp%\;*}
    temp=${temp##*=}
    inline[counter]=$temp
    # echo ${inline[counter]} # Uncomment to debug

    # -> To get file class name
    temporal="`grep -n "class" $f`"
    temporal=${temporal%\ extends PBEgg*}
    temporal=${temporal##*class }
    classSaved[counter]=$temporal
    #echo $temporal # Uncomment to debug

    counter=$((counter+1))
done

cd ../interpret_and_optimize/helpers/

newCounter=0;


echo "[INFO]: Processing eggs..."

# ==========================================
# To put plugin information on plugin helper
# ==========================================
for line in ${saved[@]}
do
    tempLine=${line//[@]/' '}
    # echo $line # Uncomment to debug
    # echo ${inline[newCounter]} # Uncomment to debug
    # echo ${classSaved[newCounter]} # Uncomment to debug
    if [ -z "${classSaved[newCounter]}" ]
    then
        echo "[ERROR]: Class not found"
    else
        # ==========================================
        # This hack let us dissect the string to see if it truly extends such class
        # ==========================================    
        IFS=' '
        temp=${classSaved[newCounter]}
        read -ra ADDR <<<"${temp}"
        # echo $ADDR # Uncomment to debug
        # echo "${#ADDR[@]}" # Uncomment to debug
        if [ "${#ADDR[@]}" -gt 1 ]
        then
            echo "[ERROR]: ${ADDR[0]} class did not extend PBEgg"
        else
            if [ -z "${inline[newCounter]}" ]
            then
                echo "[WARNING]: No semantics found for ${classSaved[newCounter]}"
            else
                if [ -z "${tempLine}" ]
                then
                    echo "[ERROR]: No path found"
                else
                    ####################################################
                    # This logic allows us to skip repeting eggs
                    ####################################################
                    onFile="`grep -n "$tempLine" pb_plugin_list_helper.dart `"
                    if [ -z "${onFile}" ]
                    then
                        sed -i.bak '
                        /allowListNames = {/ a\
                        '"${inline[newCounter]}"' :  '"${classSaved[newCounter]}"'(Point(0, 0), Point(0, 0), Uuid().v4(), '\'\'', currentContext: context),
                        ' pb_plugin_list_helper.dart

                        sed -i.bak '
                        /List<String> names = / a\
                        '"${inline[newCounter]}"',
                        ' pb_plugin_list_helper.dart

                        echo $tempLine | cat - pb_plugin_list_helper.dart > temp && mv temp pb_plugin_list_helper.dart
                        echo "[INFO]: Plugin set!"
                    else
                        echo "[INFO]: Plugin already in file. Skipping..."
                    fi
                fi
            fi
        fi
    fi
    newCounter=$((newCounter+1))
done

# -> to remove temp file
rm -rf pb_plugin_list_helper.dart.bak

echo "[INFO]: Done processing!"

