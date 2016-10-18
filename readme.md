# agent

##### *Encrypted Key-Value Store for Sensitive Data*

[![Build Status](https://travis-ci.org/ropensci/agent.svg?branch=master)](https://travis-ci.org/ropensci/agent)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/agent?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/agent)
[![Coverage Status](https://codecov.io/github/ropensci/agent/coverage.svg?branch=master)](https://codecov.io/github/ropensci/agent?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/agent)](http://cran.r-project.org/package=agent)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/agent)](http://cran.r-project.org/web/packages/agent/index.html)

> Cross platform solution for securely storing sensitive data. This 
  can either be used directly by the user or by other packages for storing 
  e.g. web tokens or other secrets. The degree of security is detemined by 
  the strength of the password as set by the user.

## Hello World

The agent works like a simple key-value store. The value can be any object that can be serialized by R such as a token or data frame. This API can either be called by the user or by other packages.

```r
library(agent)
agent_set("my_secret_token", "ABCXYZ")
agent_get("my_secret_token")
## "ABCXYZ"
agent_has("my_secret_token")
## TRUE
agent_del("my_secret_token")
```

It is up to the user to protect the keystore with a password:


```r
update_password()
```

The user will automatically be prompted for a password when the keystore needs to be unlocked, for example when a package needs to retrieve a secured token.
