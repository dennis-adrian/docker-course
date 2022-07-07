# creating network
docker network create homework &&

# creating postgres container
docker run -d \
--name postgres \
-e POSTGRES_PASSWORD=root \
-e POSTGRES_USER=admin \
-v postgres_data:/var/lib/postgresql/data \
--network homework \
postgres &&

# creating jenkins container
docker run -d \
--name jenkins \
-p 8080:8080 \
-p 50000:50000 \
--restart=on-failure \
-v jenkins_home:/var/jenkins_home \
--network homework \
jenkins/jenkins:lts-jdk11
