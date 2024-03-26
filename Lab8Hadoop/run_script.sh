# Kompilujemy obecny stan WordCountApp
./compile_jar.sh


# Uruchamiamy nasz "manualnie stworzony Hadoop Container"
docker build -t hadoop-custom:latest .
docker run -d --name hadoop-custom-container -p 9870:9870 -p 8089:8088 hadoop-custom:latest

# Uruchomienie Dockerfile z DockerHub'a
docker run -d --name hadoop-dockerhub-container -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1

# Skopiowanie pliku .jar do kontenera z DockerHub'a

docker cp wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar hadoop-dockerhub-container:/usr/local/hadoop/



# Sprawdzenie bazowego użycia zasobów
docker stats hadoop-custom-container hadoop-dockerhub-container


# Uruchomienie

time docker exec hadoop-custom-container /bin/bash -c "\
    $HADOOP_HOME/bin/hadoop fs -mkdir -p /input && \
    $HADOOP_HOME/bin/hadoop fs -copyFromLocal /usr/local/hadoop/input.txt /input/input.txt && \
    $HADOOP_HOME/bin/hadoop jar /usr/local/hadoop/wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar WordCount /input /output"

# Uruchomienie zadania Hadoop w kontenerze z DockerHub'a
time docker exec hadoop-dockerhub-container /bin/bash -c "\
    /usr/local/hadoop/bin/hadoop fs -mkdir -p /input && \
    /usr/local/hadoop/bin/hadoop fs -copyFromLocal /usr/local/hadoop/input.txt /input/input.txt && \
    /usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar WordCount /input /output"

#docker exec -it hadoop-custom-container bash
## Wewnątrz kontenera
#cd $HADOOP_HOME
#hadoop fs -copyFromLocal ./input.txt /input.txt
#hadoop jar wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar WordCount /input.txt /output

#exit

#docker exec -it hadoop-dockerhub-container bash
## Wewnątrz kontenera
#cd $HADOOP_HOME
#hadoop fs -copyFromLocal ./input.txt /input.txt
#hadoop jar wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar WordCount /input.txt /output

#exit
