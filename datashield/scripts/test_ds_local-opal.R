library(DSOpal)
library(dsBaseClient)

# prepare login data and resources to assign
builder <- DSI::newDSLoginBuilder()
builder$append(server = "study1", url = "http://opal:8880", user = "administrator", password = "password", table = "test.CNSIM1", driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
builder$append(server = "study2", url = "http://opal:8880", token = "1234567", table = "test.CNSIM3", driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
logindata <- builder$build()

# login and assign resources
conns <- datashield.login(logins = logindata, assign = TRUE, symbol = "D")

# assigned objects are of class ResourceClient (and others)
ds.class("D")