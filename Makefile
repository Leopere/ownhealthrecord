include .config


MYSQL_VOLUME := ownhr_data

# DATABASE CONTAINER
DB_BASE_IMAGE := mysql:5.6

# RUN FLAGS
DB_ROOT_PASSWORD := root123
DB_CONTAINER_NAME := database_ownhr
DB_RUN_FLAGS := -d --name $(DB_CONTAINER_NAME) -e MYSQL_ROOT_PASSWORD=$(DB_ROOT_PASSWORD) -v $(MYSQL_VOLUME):/var/lib/mysql -p 3306:3306

# WEB CONTAINER
WEB_BASE_IMAGE := ownhealthrecord
WEB_CONTAINER_NAME := webapp_ownhr
WEB_DATABASE_NAME := database

# RUN FLAGS
PORT_MAP := 8989:80
VOLUME := $(PWD)/src:/var/www/html:rw
WEB_RUN_FLAGS := -d --name $(WEB_CONTAINER_NAME) -v $(VOLUME) -p $(PORT_MAP) --link $(DB_CONTAINER_NAME):$(WEB_DATABASE_NAME)

# EXEC OPTIONS
EXEC_SHELL := bash



.PHONY: all build run stop terminal database clean erase

all: build run
	@echo "Waiting for MySQL Server starts..."
	@sleep 40
	@make database

build: Dockerfile src
	docker build --rm -t $(WEB_BASE_IMAGE) .
	docker volume create $(MYSQL_VOLUME)

run: Dockerfile src
	# Run the webapp
	docker run $(DB_RUN_FLAGS) $(DB_BASE_IMAGE)
	docker run $(WEB_RUN_FLAGS) $(WEB_BASE_IMAGE)
	
stop: 
	-docker stop $(WEB_CONTAINER_NAME)
	-docker stop $(DB_CONTAINER_NAME)

terminal: docker-compose.yml
	-docker -it exec $(WEB_CONTAINER_NAME) $(EXEC_SHELL)

database: database_structure.sql
	-mysqladmin -u$(DB_USER) -p$(DB_PASSWORD) -h 0.0.0.0  create $(DB_NAME)
	-mysql -u$(DB_USER) -p$(DB_PASSWORD) -h 0.0.0.0  $(DB_NAME) < database_structure.sql

clean:
	-docker rm --force $(WEB_CONTAINER_NAME)
	-docker rm --force $(DB_CONTAINER_NAME)

erase: clean
	-docker rmi $(WEB_BASE_IMAGE)
	-docker volume rm $(MYSQL_VOLUME)