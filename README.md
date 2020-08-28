Docker Opal
===========

This fork uses PostgreSQL as identifiers/storage database
and KeyCloak as an identity provider

The only difference to the [main repo](https://github.com/obiba/docker-opal/)
is the docker-compose.yml and the imports folder for KeyCloak.

All the necessary changes to support PostgreSQL have been implemented in the main repo.

Issues helping me to configure it:\
See:https://github.com/obiba/docker-opal/issues/13
See:https://github.com/obiba/docker-opal/issues/14

---

## Launch

Use [docker compose](https://docs.docker.com/compose/) to launch opal, rserver, the two PostgreSQL databases & KeyCloak

```
docker-compose up
```

If you want to restart individual services:
```
docker-compose stop <service-name>
docker-compose start <service-name>
```
The \<service-name> is the one used in the docker-compose.

---

## Configurations for the first run
  - [Configure KeyCloak](#configure-keycloak)
  - [Configure Opal](#configure-opal)
  - [Configure your local machine](#configure-your-local-machine)

### Configure KeyCloak
  - connect to http://localhost:8080
  - log in with the credentials admin/password
  - navigate to Manage - Users
  - add a new user e.g. test

### Configure Opal
- connect to [https://localhost:8843](https://localhost:8843)
- log in with the credentials administrator/password
- navigate to Administration > Database
- add the two databases:
    - Driver:PostgreSQL
    - Url: 
      - jdbc:postgresql://postgresids:5432/opal
      - jdbc:postgresql://postgresdata:5432/opal
    - Username: opal
    - Password: password
- navigate to Administration > General Settings
  - change Public URL to https://localhost:8843
- navigate to Administration > Identity Providers
- Add KeyCloak as ID provider:
    - Name: keycloak
    - Client ID: opal
    - Client Secret: Get it from KeyCloak (Clients > Opal > Credentials)
    - Discovery URI: http://keycloak:8080/auth/realms/opal/.well-known/openid-configuration

### Configure your local machine
- Add `0.0.0.0 keycloak` to /etc/hosts