<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Firefish, verified and packaged by Elestio

[Firefish](https://git.joinfirefish.org/firefish/firefish) is based off of Misskey, a powerful microblogging server on ActivityPub with features such as emoji reactions, a customizable web UI, rich chatting, and much more!

<img src="https://github.com/elestio-examples/firefish/raw/main/firefish.png" alt="Firefish" width="800">

[![deploy](https://github.com/elestio-examples/firefish/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/firefish)

Deploy a <a target="_blank" href="https://elest.io/open-source/firefish">fully managed Firefish</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want a free and open-source, decentralized, ActivityPub federated video platform powered by WebTorrent, that uses peer-to-peer technology to reduce load on individual servers when viewing videos.

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/firefish.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:54824`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.3"

    services:
      web:
        image: elestio4test/firefish:${SOFTWARE_VERSION_TAG}
        restart: always
        depends_on:
          - db
          - redis
          - meilisearch
        ports:
          - "172.17.0.1:54824:3000"
        environment:
          NODE_ENV: production
        volumes:
          - ./storage/files:/firefish/files
          - ./.config:/firefish/.config:ro

      redis:
        image: elestio/redis:7.0
        restart: always
        volumes:
          - ./storage/redis:/data

      db:
        image: elestio/postgres:15
        restart: always
        env_file:
          - ./.env
        volumes:
          - ./storage/db:/var/lib/postgresql/data
        ports:
          - 172.17.0.1:43282:5432

      ### Only one of the below should be used.
      ### Meilisearch is better overall, but resource-intensive. Sonic is a very light full text search engine.

      meilisearch:
        image: getmeili/meilisearch:v1.1.1
        restart: always
        environment:
          - MEILI_ENV=${MEILI_ENV:-development}
        ports:
          - "7700:7700"
        volumes:
          - ./storage/meili_data:/meili_data

      pgadmin4:
        image: dpage/pgadmin4:latest
        restart: always
        environment:
          PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
          PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
          PGADMIN_LISTEN_PORT: 8080
        ports:
          - "172.17.0.1:39736:8080"
        volumes:
          - ./servers.json:/pgadmin4/servers.json


### Environment variables

|       Variable       |     Value (example)     |
| :------------------: | :---------------------: |
|       ADMIN_EMAIL    |  admin email            |
|     ADMIN_PASSWORD   |  admin password         |
|   SOFTWARE_VERSION   |  latest                 |
|    POSTGRES_USER     |  postgres user          |
|   POSTGRES_PASSWORD  |  postgres password      |


# Maintenance

## Logging

The Elestio Firefish Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://docs.firefish.io/">Firefish documentation</a>

- <a target="_blank" href="https://git.joinfirefish.org/firefish/firefish">Firefish Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/firefish">Elestio/Firefish Github repository</a>
