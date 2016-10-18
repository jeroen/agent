get_key <- function(){
  keyfile <- agent_dir("id_rsa")
  tryCatch({openssl::read_key(keyfile, password = function(...){
    getPass::getPass("Please enter your (current) key password.")
  })}, error = function(e){
    stop("Failed to read key. Wrong password?", call. = FALSE)
  })
}

get_pubkey <- function(){
  openssl::read_pubkey(agent_dir("id_rsa.pub"))
}

agent_init <- function(){
  appdir <- agent_dir()
  if(!file.exists(appdir))
    dir.create(appdir)
  if(!file.exists(appdir))
    stop("failed to create dir:", appdir)
  keyfile <- agent_dir("id_rsa")
  pubkeyfile <- agent_dir("id_rsa.pub")
  if(file.exists(keyfile) || file.exists(pubkeyfile))
    stop("keys already exist. Aborting setup.")
  key <- openssl::rsa_keygen()
  pubkey <- as.list(key)$pubkey
  openssl::write_pem(key, keyfile, password = NULL)
  openssl::write_pem(pubkey, pubkeyfile)
}

agent_dir <- function(...){
  appdir <- rappdirs::user_data_dir("agent")
  file.path(appdir, ...)
}
