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

### Use Opal 
- connect to https://localhost:8843
- click on "Sign in with Keycloak"
- enter the credentials test/test

---
## Configurations before the first usage
  - [Configure Keycloak](#configure-keycloak)
  - [Configure Opal](#configure-opal)
  - [Configure your local machine](#configure-your-local-machine)

### Configure Keycloak
  - connect to http://localhost:8080
  - log in with the credentials admin/password
  - navigate to Manage - Users
  - add a new user e.g. test
    - Credentials: test/test (Temporary: OFF)
    - Email Verified: ON
    - Groups: opal-users

  If you want to test the Groups Mapper:

  Prerequisites:
  - [jsonwebtokencli](https://github.com/mattroberts297/jsonwebtokencli): `npm install --global jsonwebtokencli`
  - [jq](https://stedolan.github.io/jq/): `sudo apt-get install jq`

  ```
  curl -d 'client_id=opal' -d 'username=test' -d 'password=test' -d 'grant_type=password' -d 'client_secret=<secret*>' 'http://localhost:8080/auth/realms/opal/protocol/openid-connect/token' | jq '.access_token' | xargs jwt --decode | jq
  ```
  *`client_secret` is in Clients > Opal > Credentials

### Configure Opal
- connect to https://localhost:8843
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
  - set Public URL to https://localhost:8843
- navigate to Administration > Identity Providers
- add KeyCloak as ID provider:
    - Name: Keycloak
    - Client ID: opal
    - Client Secret: Get it from Keycloak (Clients > Opal > Credentials)
    - Discovery URI: http://keycloak:8080/auth/realms/opal/.well-known/openid-configuration
    - Groups Claim: groups

! relog and check if under Adminstration > Profiles the group opal-users is set.

If not: close Opal and `docker-compose restart opal`

This seem to be an already [known issue](https://github.com/obiba/opal/issues/3531)

### Configure your local machine
- Add `0.0.0.0 keycloak` to /etc/hosts