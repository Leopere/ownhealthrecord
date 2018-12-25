include .config

BASE_IMAGE=ownhealthrecord
WEB_SERVICE=webapp
MYSQL_VOLUME=ownhr_data

.PHONY: all build run stop terminal database clean erase

all: build run
	@echo "Waiting for MySQL Server start..."
	@sleep 40
	@make database

build: Dockerfile src
	docker build --rm -t $(BASE_IMAGE) .

run: docker-compose.yml Dockerfile src
	docker-compose up --build -d

stop: docker-compose.yml 
	docker-compose stop 

terminal: docker-compose.yml
	docker-compose exec $(WEB_SERVICE)  bash

database: database_structure.sql
	bash install_database.sh

clean: docker-compose.yml
	docker-compose down

erase: clean
	docker rmi $(BASE_IMAGE)
	docker volume rm $(BASE_IMAGE)_$(MYSQL_VOLUME)