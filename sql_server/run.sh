#!/bin/sh

name_container=sql_server
function build {
    docker build --no-cache -t $name_container $@ .
}
#        -P \
#        -v $(pwd)/my_python:/app/my_python \
function up {
    docker run \
     --name $name_container \
     -e "ACCEPT_EULA=Y" \
     -e "SA_PASSWORD=12345678" \
     -p 1433:1433 \
     -d mcr.microsoft.com/mssql/server:2019-latest
}


function down {
    docker rm -f -v $name_container
}
function rebuild {
    docker rm -f -v $name_container
    docker run \
    --name $name_container \
   -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Post87654321" \
   -p 1433:1433 \
   -d mcr.microsoft.com/mssql/server:2019-latest

}
function log {
    docker logs $name_container $@
}

function sh {
    docker exec $@ -it $name_container bash
}
function cron {
    docker exec $@ -it $name_container bash /bin/build_project.sh
}
function del {
  docker rmi -f $name_container
}
function show {
  docker images $@ | grep $name_container
}
function start {
  docker start $(docker ps -a -q -f "name=$name_container" --format "{{.ID}}") $@
}
function stop {
  docker stop $(docker ps -f "name=$name_container" --format "{{.ID}}")
}
function main {
    Command=$1
    shift
    case "${Command}" in
        build)  build $@ ;;
        up)     up $@ ;;
        down)   down $@ ;;
        log)    log $@ ;;
        sh)     sh $@ ;;
        del)     del $@ ;;
        show)     show $@ ;;
        cron)     cron $@ ;;
        rebuild)     rebuild $@ ;;
        start )     start $@ ;;
        stop )     stop $@ ;;
        *)      echo "Usage: $0 {build|up|down|log|sh|del}" ;;
    esac
}

main $@