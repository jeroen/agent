.onAttach <- function(lib, pkg){
  keyfile <- agent_dir("id_rsa")
  buf <- readBin(keyfile, raw(), file.info(keyfile)$size)
  name <- utils::getFromNamespace('parse_pem', 'openssl')(buf)$name
  if(!grepl("ENCRYPTED", name, ignore.case = TRUE)){
    packageStartupMessage("Your keystore is currently unprotected! Please set a password using update_password()")
  }
}

.onLoad <- function(lib, pkg){
  if(!file.exists(agent_dir("id_rsa")))
    agent_init()
}
