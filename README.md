# WebProtégé

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/168f293b92f64cf1a7a56cee6f914e3c)](https://www.codacy.com/app/skyper/webprotege-dockerfile?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=SkypLabs/webprotege-dockerfile&amp;utm_campaign=Badge_Grade)

This image allows you to deploy [WebProtégé][webprotege] as a [microservice][microservice].

WebProtégé is a free, open-source ontology editor and framework for building intelligent systems.

## How to

### Create your container

To start a new instance:

    docker run --name webprotege -d \
      -v webprotege_data:/srv/webprotege \
      -v webprotege_logs:/var/log/webprotege \
      --link mongodb -p 8888:8080 \
      skyplabs/webprotege

The web application will be accessible from the host system on port `8888`. All the persistent data will be stored in two volumes managed by Docker and called respectively `webprotege_data` and `webprotege_logs`. `mongodb` must be the name of a [MongoDB][mongodb] docker container listening on port `27017`.

To start a MongoDB instance using Docker (must be started before WebProtégé):

    docker run --name mongodb -d -v mongodb_data:/data/db mongo:3

All the persistent data will be stored in a volume managed by Docker and called `mongodb_data`.

To start the two containers using only one command, you can use [Docker Compose][docker-compose]:

    docker-compose up -d

### Create an admin account

To bootstrap your new container with an admin account, you need to use the [WebProtégé Command Line Tool][webprotege-cli]. This Docker image embeds natively this tool.

Once your new container up and running:

    docker exec -it <container name> webprotege-cli create-admin-account

### Finalise your installation

After having signed in your new WebProtégé instance, you need to specify the host name and a couple of other parameters on the [settings page][webprotege-settings].

## Customise the configuration

You can customise the configuration of WebProtégé by injecting the [`webprotege.properties`][webprotege-properties] and/or [`mail.properties`][mail-properties] files into the container using the volume command. The files must be placed in `/etc/webprotege`.

For example:

    export WP_CONFIG_DIR=/etc/webprotege
    docker run --name webprotege -d \
      -v webprotege_data:/data/webprotege \
      -v webprotege_logs:/var/log/webprotege \
      -v $(pwd)/config/webprotege.properties:${WP_CONFIG_DIR}/webprotege.properties:ro \
      -v $(pwd)/config/mail.properties:${WP_CONFIG_DIR}/mail.properties:ro \
      --link mongodb -p 8888:8080 \
      skyplabs/webprotege

Note that `application.version` and `data.directory` are defined in `Dockerfile` as environment variables and will overwrite the values contained in `webprotege.properties`. However, you can change them at build-time via the arguments `WEBPROTEGE_VERSION` and `WEBPROTEGE_DATA_DIR`.

For example:

    docker build -t webprotege --build-arg WEBPROTEGE_DATA_DIR=/data/webprotege .

## License

[MIT][license]

 [docker-compose]: https://www.docker.com/products/docker-compose
 [license]: http://opensource.org/licenses/MIT
 [mail-properties]: config/mail.properties
 [microservice]: https://en.wikipedia.org/wiki/Microservices
 [mongodb]: https://www.mongodb.com/
 [webprotege]: https://protegewiki.stanford.edu/wiki/WebProtege
 [webprotege-cli]: https://github.com/protegeproject/webprotege/wiki/WebProt%C3%A9g%C3%A9-3.0.0-Installation#bootstrap-webprot%C3%A9g%C3%A9-with-an-admin-account
 [webprotege-properties]: config/webprotege.properties
 [webprotege-settings]: https://github.com/protegeproject/webprotege/wiki/WebProt%C3%A9g%C3%A9-3.0.0-Installation#edit-the-webprot%C3%A9g%C3%A9-settings
