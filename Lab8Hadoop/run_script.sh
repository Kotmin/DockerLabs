# Uruchamiamy nasz "manualnie stworzony Hadoop Container"
docker build -t hadoop-custom:latest .
docker run -d --name hadoop-custom-container -p 9870:9870 -p 8088:8088 hadoop-custom:latest

# Uruchomienie Dockerfile z DockerHub'a
docker run -d --name hadoop-dockerhub-container -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1



