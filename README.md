# Play With Docker Proof of Concept

This repository is a test for spinning up Docker containers on PWD

## SQL Example

Postgresql instance with Sakilla dataset

https://github.com/jOOQ/jOOQ/tree/main/jOOQ-examples/Sakila/postgres-sakila-db

## In-Browser Docker Playground

Click on the button below to launch a Play-With-Docker session - DockerHub login/signup is required!

**Open in a new tab!!! 👇**

[![Try in PWD](https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png)](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/unicorndatalabs/pwd-poc/master/docker-compose.yml)

Wait a few seconds for the container to finish initialising and then run the following to enter a `psql` session:

```bash
docker exec -it $(docker ps -lq) psql -U postgres
```

You can then run `\d` to show all relevant tables in the database.

## Data Model Diagram

<iframe width="560" height="315" src='https://dbdiagram.io/embed/5f3e085ccf48a141ff558487'> </iframe>

![Sakilla-Data-Model](images/data-model.png "Sakilla Data Model")