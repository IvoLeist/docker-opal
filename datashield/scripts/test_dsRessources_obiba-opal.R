library(DSOpal)
library(dsBaseClient)

# prepare login data and resources to assign
builder <- DSI::newDSLoginBuilder()
builder$append(server = "study1", url = "https://opal-demo.obiba.org", user = "administrator", password = "password", resource = "RSRC.CNSIM1", driver = "OpalDriver")
builder$append(server = "study2", url = "https://opal-demo.obiba.org", user = "administrator", password = "password", resource = "RSRC.CNSIM3", driver = "OpalDriver")
logindata <- builder$build()

# login and assign resources
conns <- datashield.login(logins = logindata, assign = TRUE, symbol = "res")

# assigned objects are of class ResourceClient (and others)
ds.class("res")