# creating network
docker network create homework &&

# creating postgres container
docker run -d \
--name postgres \
-e POSTGRES_USER=root \
-e POSTGRES_PASSWORD=root \
-e PGDATA=/var/lib/postgresql/data/pgdata \
-v postgres_data:/var/lib/postgresql/data \
--network homework \
postgres &&

# creating sonarqube container
sysctl -w vm.max_map_count=524288 &&
sysctl -w fs.file-max=131072 &&
ulimit -n 131072 &&
ulimit -u 8192

docker run -d \
--name sonarqube \
-p 9000:9000 \
-e SONAR_JDBC_URL=jdbc:postgresql://postgres/postgres \
-e SONAR_JDBC_USERNAME=root \
-e SONAR_JDBC_PASSWORD=root \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_logs:/opt/sonarqube/logs \
-v sonarqube_extensions:/opt/sonarqube/extensions \
--network homework \
sonarqube:8.9-community &&

# creating jenkins container
docker run -d \
--name jenkins \
-p 8080:8080 \
-p 50000:50000 \
--restart=on-failure \
-v jenkins_home:/var/jenkins_home \
--network homework \
jenkins/jenkins:lts-jdk11 &&

# creating nexus container
docker run -d \
--name nexus \
-p 8081:8081 \
-v nexus-data:/nexus-data \
--network homework \
sonatype/nexus3 &&

# creating portainer container
docker run -d \
--name portainer \
-p 8000:8000 \
-p 9443:9443 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
--network homework \
portainer/portainer-ce:2.9.3
