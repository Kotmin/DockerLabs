#!/bin/bash

# Nazwy twoich kontenerów
CUSTOM_CONTAINER_NAME="hadoop-custom-container"
DOCKERHUB_CONTAINER_NAME="hadoop-dockerhub-container"

# Zatrzymaj i usuń kontener stworzony z własnego Dockerfile
docker stop $CUSTOM_CONTAINER_NAME
docker rm $CUSTOM_CONTAINER_NAME

# Zatrzymaj i usuń kontener pobrany z Docker Hub
docker stop $DOCKERHUB_CONTAINER_NAME
docker rm $DOCKERHUB_CONTAINER_NAME

# Opcjonalnie: Usuń obrazy Docker, jeśli nie są już potrzebne
# docker rmi openjdk:8
# docker rmi hadoop-custom:latest
# docker rmi sequenceiq/hadoop-docker:2.7.1

echo "Kontenery zostały usunięte."

