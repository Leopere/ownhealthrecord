include .config


build: Dockerfile src
	docker build --rm -t ownhealthrecord .

run: docker-compose.yml Dockerfile src
	docker-compose up --build -d

stop: docker-compose.yml 
	docker-compose stop 

database: database_structure.sql
	bash install_database.sh

clean: docker-compose.yml
	docker-compose down
	docker-compose rm -s -v -f