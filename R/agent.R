#' Token Agent
#'
#' Safely store and load sensitive data. This API may be both by users as well
#' as packages to store e.g. secrets or auth tokens.
#'
#' Note that it is up to the user to secure the keyring with a password via
#' \link{update_password}.
#'
#' @export
#' @rdname agent
#' @aliases agent
#' @param name a unique name to store and retrieve this object. Make sure to
#' pick a unique name that does not conflict with other packages using the same
#' store.
#' @param value an R object to be stored securely. This part contains the
#' sensitive data.
agent_set <- function(name, value){
  hash <- digest(name)
  datafile <- token_datafile(hash)
  keyfile <- token_keyfile(hash)
  if(file.exists(datafile))
    stop("token already exists")
  pubkey <- get_pubkey()
  aes <- openssl::rand_bytes(16)
  aes_encrypted <- openssl::rsa_encrypt(aes, pubkey = pubkey)
  buf <- serialize(value, NULL)
  cipher <- openssl::aes_cbc_encrypt(buf, key = aes, iv = hash)
  writeBin(as.raw(cipher), datafile)
  writeBin(aes_encrypted, keyfile)
}

#' @export
#' @rdname agent
agent_has <- function(name){
  hash <- digest(name)
  datafile <- token_datafile(hash)
  file.exists(datafile)
}

#' @export
#' @rdname agent
agent_get <- function(name){
  hash <- digest(name)
  datafile <- token_datafile(hash)
  keyfile <- token_keyfile(hash)
  if(!file.exists(datafile))
    stop("token does not exist")
  key <- get_key()
  aes_encrypted <- readBin(keyfile, raw(), file.info(keyfile)$size)
  aes <- openssl::rsa_decrypt(aes_encrypted, key = key)
  cipher <- readBin(datafile, raw(), file.info(datafile)$size)
  out <- openssl::aes_cbc_decrypt(cipher, aes, iv = hash)
  unserialize(out)
}

#' @export
#' @rdname agent
agent_del <- function(name){
  hash <- digest(name)
  datafile <- token_datafile(hash)
  keyfile <- token_keyfile(hash)
  unlink(c(datafile, keyfile))
}

digest <- function(x){
  openssl::md5(serialize(x, NULL))
}

token_datafile <- function(hash){
  if(is.raw(hash))
    hash <- paste(hash, collapse = "")
  agent_dir(hash)
}

token_keyfile <- function(hash){
  if(is.raw(hash))
    hash <- paste(hash, collapse = "")
  agent_dir(paste0(hash,".key"))
}




add_env <- function(name, value){

}

del_env <- function(name, value){

}

get_env <- function(name, value){

}

load_all_env <- function(){

}

change_password <- function(password){

}

unlock_keystore <- function(){

}

lock_keystore <- function(){

}
