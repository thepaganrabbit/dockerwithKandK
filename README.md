# Simple Java docker

This is a simple docker and kotlin/ktor setup with gradle.

## Setting up VS Code (optional)

Go to market place in VS Code and install:
1. Extension Pack for Java (if Java is the language used)
2. Kotlin
3. Remote-containers

## RUN

To build your initial docker image run the command bellow:

```BASH
docker-compose up --build
```

If it is the base app know that the container will just finish with a hellow world in java. If you have your own application it will put everything in the directory and do the run command. In the docker file CMD it is an array of commands to be run each command needs to be in it's own "", ["java", "this location"]. If this is a spring boot application how you usually would run it would go in the CMD. If you need it to remain open so you can ssh into the machine or work inside the mache as stated At the bottom of this Readme add inside the docker-compose.yml file command: sleep infinity. When you make this change you will need to rebuild the container. 

To Use your own code just put the Dockerfile and the docker-compose.yml file in the root, update the ports if need be. 

To get a container sinternal ip address to ssh into it or do other things here is the command for that:

```BASH
docker inspect -f \
'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
container-id or tag
```


## Understanding the Dockerfile

**Gradle**

ARG WRKDIR is the directory where the files will be put this will be your projects root directory

COPY transfers everything in the root directory to the container at the specified directory

CMD runs the command, this will start your application if you have a main. If this is web related you will need to uncomment the expose and put the port you need to export and follow up with this in the docker-compose.yml this maps that to your local machines port. 

**Database**

I have added in a simple docker container for postgres this can use any docker hosted database for local dev if you need it if not use the below yaml:

Without DB (runs what is in the cmd):

```YAML
version: "3.6"

services:
  app:
    build: ./
    container_name: gradle-app
```

Without DB (remains running):

```YAML
version: "3.6"

services:
  app:
    build: ./
    container_name: gradle-app
    command: sleep infinity
    volumes:
      - ./:/dockjav
```

With DB

```YAML
version: "3.6"

services:
  db:
    image: postgres:14.1-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
      - ./db/init.sql:/docker-entrypoint-initdb.d/create_tables.sql
  app:
    build: ./
    container_name: gradle-app
    command: sleep infinity
    volumes:
      - ./:/dockjav
```

## Accessing your docker container

to get a terminal into the running container:

```BASH
docker exec -it (container sha or tag) /bin/bash
```

## Commands to know

To create the base container:

```BASH
docker-compose up --build
```

To view running containers (This will only show running containers):

```BASH
docker container ls
```

To view all container (running or not):

```BASH
docker container ls -a
```

To delete a container (must be stopped):

```BASH
docker rm container id
```


## To work using the container with VS Code

Add this to your extensions:

[link](ms-vscode-remote.remote-containers) ms-vscode-remote.remote-containers

If link does not work search for Dev Containers

**Note:** if the above package is not set up correctly it will not work, it is finiky hence why I include using the package below as an option. You sould also ssh into the machine and do everything in vim there. 

I found that using the remote exploror package is best for my setup, however, you will need to open a external terminal to access the terminal in the machine, VS Codes terminall seems to have a bug. there you can navigate to the icon on the sidebar, and view all remote container. If you click the open folder icon listed beside the container or in the structure it should open in VS Code and allow you to edit files inside the container. 

## Useful links:

Develop on a remote Docker host [VS Code Info 1](https://code.visualstudio.com/remote/advancedcontainers/develop-remote-host)

Remote Development with VS Code and Docker [Meduim.com Article](https://medium.com/the-telegraph-engineering/remote-development-with-vs-code-a8d8fe8aa9e)

How to use Docker for Java development [Docker and Java](https://www.infoworld.com/article/3638548/how-to-use-docker-for-java-development.html)

Find Docker prebuilt images [DockerHub](https://hub.docker.com/)

**Docker Training**

Docker 101 Tutorial [Begginers intro to Docker](https://www.docker.com/101-tutorial/)

Docker for beginners {Video} [Docker Tutorial](https://youtu.be/pTFZFxd4hOI)