.onAttach <- function(lib, pkg){
  keyfile <- agent_dir("id_rsa")
  buf <- readBin(keyfile, raw(), file.info(keyfile)$size)
  name <- names(openssl::read_pem(buf))
  if(!grepl("ENCRYPTED", name, ignore.case = TRUE)){
    packageStartupMessage("Your keystore is currently unprotected! Set a password using update_password()")
  }
  # Load all environment variables
  # env_load()
}

.onLoad <- function(lib, pkg){
  if(!file.exists(agent_dir("id_rsa")))
    agent_init()
}
