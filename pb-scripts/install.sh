echo "[INFO]: Installing Para-beac core and its dependencies"
dart pub get
# pub run build_runner build
#cd sketch-to-svg/
# docker build -t sketch .

# if [[ "`docker container inspect -f '{{.State.Status}}' parabeac_container`" == "running" ]]
# then
#     echo "Parabeac_container already running"
# else
#     if [ ! "$(docker ps -a | grep parabeac_container)" ]
#     then
#         echo "[INFO]: Starting parabeac_container"
#         docker run -d --name parabeac_container -p 5555:8081 sketch
#     else
#         echo "[INFO]: Restarting parabeac_container"
#         docker restart parabeac_container
#     fi
# fi