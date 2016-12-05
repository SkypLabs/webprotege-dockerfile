# WebProtégé

This image allows you to deploy [WebProtégé][webprotege] as a [microservice][microservice].

WebProtégé is a free, open-source ontology editor and framework for building intelligent systems.

## How to

To start a new instance :

    docker run --name webprotege -d -v webprotege_data:/data/webprotege --link mongodb -p 8888:8080 docker.io/skyplabs/webprotege

The web application will be accessible from the host system on port *8888*. All the persistent data will be stored in a volume handled by Docker and called *webprotege_data*. *mongodb* must be the name of a [MongoDB][mongodb] docker container listening on port *27017*.

To start a MongoDB instance using Docker (must be started before WebProtégé) :

    docker run --name mongodb -d -v mongodb_data:/data/db mongo:3

All the persistent data will be stored in a volume handled by Docker and called *mongodb_data*.

To start the two containers using only one command, you can use [Docker Compose][docker-compose] :

    docker-compose up -d

## License

[MIT][license]

 [webprotege]: http://protege.stanford.edu/
 [microservice]: https://en.wikipedia.org/wiki/Microservices
 [mongodb]: https://www.mongodb.com/
 [docker-compose]: https://www.docker.com/products/docker-compose
 [license]: http://opensource.org/licenses/MIT
