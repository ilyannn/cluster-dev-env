IMAGE_NAME := "registry.cluster.megaver.se/library/cluster-dev-env"

build:
    podman build . -t {{IMAGE_NAME}}
    
push:
    podman push {{IMAGE_NAME}}
    
run:
    podman run -it {{IMAGE_NAME}}

default: build run
