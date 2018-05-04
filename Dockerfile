FROM kmubigdata/ubuntu-hadoop:standalone

RUN wget http://apache.claz.org/hive/stable-2/apache-hive-2.3.3-bin.tar.gz
RUN tar -xvzf apache-hive-2.3.3-bin.tar.gz -C /usr/local/
RUN cd /usr/local && ln -s ./apache-hive-2.3.3-bin hive
RUN rm apache-hive-2.3.3-bin.tar.gz

#install mysql
RUN echo 'mysql-server mysql-server/root_password password hive' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password hive' | debconf-set-selections
RUN apt-get -y install mysql-server
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.11.tar.gz
RUN tar -xvzf mysql-connector-java-8.0.11.tar.gz
RUN mv /mysql-connector-java-8.0.11/mysql-connector-java-8.0.11.jar /usr/local/hive/lib/
RUN rm -r /mysql-connector-java-8.0.11
RUN rm mysql-connector-java-8.0.11.tar.gz

ENV HIVE_HOME /usr/local/hive
ENV PATH $HIVE_HOME/bin:$PATH

ADD hive-site.xml $HIVE_HOME/conf/hive-site.xml

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

EXPOSE 10000

ENTRYPOINT ["/etc/bootstrap.sh"]
