Docker Opal
===========

This fork uses PostgreSQL as identifiers/storage database
and Keycloak as an identity provider.

The only difference to the [main repo](https://github.com/obiba/docker-opal/)
is the docker-compose.yml and the imports folder for Keycloak.

All the necessary changes to support PostgreSQL have been implemented in the main repo.

Issues in obiba/docker-opal which helped me to configure it: 
[#13](https://github.com/obiba/docker-opal/issues/13) 
[#14](https://github.com/obiba/docker-opal/issues/14)

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

## Use Opal 
- connect to https://localhost:8843
- click on "Sign in with Keycloak"
- enter the credentials test/test

## Query data from Opal

### By using the opal-python-client

[documentation](http://opaldoc.obiba.org/en/latest/python-user-guide/index.html) / [repo](https://github.com/obiba/opal-python-client)

requirements: python 2.x must be installed on the system

try it out:

```
opal data test.CNSIM3 --opal https://localhost:8843 --user administrator --password password --id 999
```
or 
```
opal rest /datasource/test/table/CNSIM3/valueSet/999 --opal https://localhost:8843 --user administrator --password password --json
```

### By using dataSHIELD

a series of R libraries that enables the non-disclosive co-analysis of distributed sensitive research data

[documentation](http://opaldoc.obiba.org/en/latest/r-user-guide/datashield.html) / [repo](https://github.com/datashield)

try it out:

- obiba-opal demo
  - attach a shell to the container: docker-opal_rdsclient
  - execute:  `Rscript /opt/datashield/test_dsRessources_obiba-opal`  

- local-opal
  - [open a  Opal session by signing in with Keycloak as the user test](##Use-opal)
  - add a personal access token with ticked on "Use DataSHIELD"
  - Copy the access token and paste it into `test_ds_local-opal.R`
  - attach a shell to the container: docker-opal_rdsclient
  - execute: `Rscript /opt/datashield/test_ds_local-opal.R`

    \* works as expected if the user is created by Opal, but unfortunately not if the user is created by Keycloak 
    
    `Error: Client error: (403) Forbidden`


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
1. connect to https://localhost:8843
2. log in with the credentials administrator/password

- add the databases
  - navigate to Administration > Database
  - add the two databases:
      - Driver:PostgreSQL
      - Url: 
        - jdbc:postgresql://postgresids:5432/opal
        - jdbc:postgresql://postgresdata:5432/opal
      - Username: opal
      - Password: password

- change the public url
  - navigate to Administration > General Settings
    - set Public URL to https://localhost:8843

- add Keycloak
  - navigate to Administration > Identity Providers
  - add Keycloak as ID provider:
      - Name: Keycloak
      - Client ID: opal
      - Client Secret: Get it from Keycloak (Clients > Opal > Credentials)
      - Discovery URI: http://keycloak:8080/auth/realms/opal/.well-known/openid-configuration
      - Groups Claim: groups

- add example data
  - navigate to Projects
  - add a project called test with the Database "postgresdb"
  - navigate to Files/projects/test and upload the CSVs from data/examples

- add permissions
  - navigate to Tables/Permissions
  - add group permission "View dictionary and values of all tables" to /opal-users (! mind the "/")

- add DataSHIELD
  - navigate to Administration > DataSHIELD
  - add the group permission "Use DataSHIELD services" to opal-users

! relog and check if under Adminstration > Profiles the group opal-users is set.

If not: close Opal and `docker-compose restart opal`

This seem to be an already [known issue](https://github.com/obiba/opal/issues/3531)

### Configure your local machine
- Add `0.0.0.0  keycloak` to /etc/hosts
- Add `0.0.0.0  opal` to /etc/hosts 
--- 

## Debugging

### Fix Postgres issues:

- remove locks: https://jaketrent.com/post/find-kill-locks-postgres/