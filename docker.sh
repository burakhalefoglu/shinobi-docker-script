#!/bin/bash
COMMAND=$1

IMAGE_NAME=registry.gitlab.com/shinobi-systems/shinobi:dev
CONTAINER_NAME=Shinobi

CONFIG_DIR=./config
CUSTOM_AUTOLOAD_DIR=./customAutoLoad
DB_DIR=./database
VIDEOS_DIR=./videos
PLUGINS_DIR=./plugins
STREAMS_DIR=/dev/shm/Shinobi/streams

exists()
{
    command -v "$1" &> /dev/null
}

if exists podman; then
    DOCKER=podman
elif exists docker; then
    DOCKER=docker
else
    echo "podman and docker are not installed!"
    exit 1
fi

for host_dir in $CONFIG_DIR $CUSTOM_AUTOLOAD_DIR $DB_DIR $VIDEOS_DIR $PLUGINS_DIR $STREAMS_DIR
do
    if [ ! -d $host_dir ]; then
	mkdir -p $host_dir
    fi
done

case $COMMAND in
    run)
	$DOCKER run --name $CONTAINER_NAME \
		--net host \
		-v $CONFIG_DIR:/config:Z \
		-v $CUSTOM_AUTOLOAD_DIR:/home/Shinobi/libs/customAutoLoad:Z \
		-v $DB_DIR:/var/lib/mysql:Z \
		-v $VIDEOS_DIR:/home/Shinobi/videos:Z \
		-v $PLUGINS_DIR:/home/Shinobi/plugins:Z \
		-v $STREAMS_DIR:/dev/shm/streams:Z \
		-d $IMAGE_NAME
	;;
    bash)
	$DOCKER exec -it $CONTAINER_NAME /bin/bash
	;;
    *)
	echo "Unknown command"
	;;
esac
