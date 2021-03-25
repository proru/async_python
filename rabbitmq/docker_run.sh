#!/bin/sh

name_container="rabbit_docker"
name_image="rabbitmq"
function build {
    docker build --no-cache -t $name_image $@ .
}
#        -P \
#        -v $(pwd)/my_python:/app/my_python \
function up {
    docker run $@ \
        --name $name_container \
        -p 9010:5432 \
        -d $name_image

}

function down {
    docker rm -f -v $name_container
}
function rebuild {
    docker stop $name_container
    docker rm -f -v $name_container
    docker run $@ \
        --name $name_container \
        -p 9010:5672 \
        -d $name_image

#    docker rmi -f $name_image
#    docker build --no-cache -t $name_image:latest $@ .
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
function deli {
  docker rmi -f $name_image
}
function del {
  docker rm -f $name_name_container
}
function show {
  docker images $@ | grep $name_image
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
        deli)     deli $@ ;;
        show)     show $@ ;;
        cron)     cron $@ ;;
        rebuild)     rebuild $@ ;;
        start )     start $@ ;;
        stop )     stop $@ ;;
        *)      echo "Usage: $0 {build|up|down|log|sh|del}" ;;
    esac
}

main $@