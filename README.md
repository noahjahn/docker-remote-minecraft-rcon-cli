# Docker Remote Minecraft RCON CLI

Manage a Minecraft server with a nice interface. Vanilla minecraft commands can be run from here

## Project Links

- Localhost: [http://localhost:3333](http://localhost:3333)
- Staging: TBD
- Production: TBD

## Getting Started

To run this code you'll need to

- use a UNIX operating system
- have [Docker](https://www.docker.com/) installed

### Quick Start

Locally, using docker is the easiest and fastest way to get up and running. The `docker-compose.yaml` file will start the following services for you:

- NodeJS v18 mapped to your host by default on port 3333
- PostgreSQL v15 database mapped to your host on port 5432

The local PostgreSQL database credentials are set in the `docker-compose.yaml` file:

- Database: adonis
- Username: adonis
- Password: secret

1. Clone the repository and change directory into the cloned repo

```bash
git clone git@github.com:noahjahn/docker-remote-minecraft-rcon-cli.git
cd docker-remote-minecraft-rcon-cli
```

2. Set up the `.env` file

   a. Copy `.env.example` to `.env`

   ```
   cp .env.example .env
   ```

   b. Generate and set the `APP_KEY` value in the `.env` file

   - Just copy the generated key and replace the `APP_KEY=tbd` value in the `.env` file

   ```
   ./node ace generate:key
   ```

3. Start docker containers (this will take a while the first time, grab a cup of coffee)

```bash
./start-app
```

- You can optionally pass a port number to map nodejs to your host on a different port than the default of 3333. Ex: `./start-app 80`

## Ace

The command-line tool provided by Adonis should be run in the docker containers. For example (yes, the `./` is important, it's a bash file the wraps running node in a node container):

```
./node ace
```

You can use `ace` to generate controllers, migrations, models, etc. You can also use `ace` to run migrations

More information can be found [here](https://docs.adonisjs.com/guides/ace-commandline)

### Migrations

After setting up the project, or switching branches, it's always good to keep your database schema up-to-date:

```
./node ace migration:run
```

More information can be found [here](https://docs.adonisjs.com/guides/database/migrations)
