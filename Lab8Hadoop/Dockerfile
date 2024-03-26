# Używamy oficjalnego obrazu Java 8 jako bazy
FROM openjdk:8

# Instalacja ssh i sudo-ssh (potrzebne do konfiguracji SSH bez hasła i zarządzania użytkownikami)
RUN apt-get update && apt-get install -y openssh-server sudo

# Dodanie użytkownika hduser i grupę hadoop_group
RUN addgroup hadoop_group && \
    adduser --ingroup hadoop_group hduser && \
    echo "hduser:hdpass" | chpasswd && \
    adduser hduser sudo

# Konfiguracja SSH
RUN service ssh start

# Generowanie kluczy SSH
RUN su hduser -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa" && \
    su hduser -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"

# Pobieranie i instalacja Hadoopa
ENV HADOOP_VERSION 3.3.1
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN wget http://apache.mirrors.pair.com/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz

# Ustawienie JAVA_HOME w hadoop-env.sh
RUN echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed 's:bin/java::')" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Dodanie pliki konfiguracyjne Hadoop (hdfs-site.xml, core-site.xml, mapred-site.xml itp.)

COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/:

# Start Hadoop przy uruchomieniu kontenera (można skonfigurować własne skrypty startowe)
CMD ["sh", "-c", "service ssh start; bash"]

