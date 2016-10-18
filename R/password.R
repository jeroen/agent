#' Update Password
#'
#' Your keyring is only secure when protected by a good password. These functions
#' can only be called interatively by the user (not by packages).
#'
#' Updating the password automatically refreshes all keypairs. If you forgot your
#' password you can reset it with `reset_password`. This will permanently delete
#' all your existing tokens.
#'
#' @export
#' @rdname password
update_password <- function(){
  oldkey <- get_key()
  key <- openssl::rsa_keygen()
  pubkey <- as.list(key)$pubkey
  passwd <- new_password()
  openssl::write_pem(key, agent_dir("id_rsa.new"), password = passwd)
  openssl::write_pem(pubkey, agent_dir("id_rsa.pub.new"))

  # Update existing tokens
  keyfiles <- list.files(agent_dir(), "\\.key$", full.names = TRUE)
  allfiles <- c(keyfiles, agent_dir(c("id_rsa", "id_rsa.pub")))
  lapply(keyfiles, function(keyfile){
    hash <- basename(keyfile)
    buf <- readBin(keyfile, raw(), file.info(keyfile)$size)
    aes <- openssl::rsa_decrypt(buf, oldkey, NULL)
    aes_encrypted <- openssl::rsa_encrypt(aes, pubkey = pubkey)
    writeBin(aes_encrypted, paste0(keyfile, ".new"))
  })
  bakfiles <- paste0(allfiles, ".bak")
  newfiles <- paste0(allfiles, ".new")
  file.rename(allfiles, bakfiles)
  file.rename(newfiles, allfiles)
  unlink(bakfiles)
}

#' @export
#' @rdname password
reset_password <- function(){
  n <- length(list.files(agent_dir(), "\\.key$"))
  if(n > 0){
    str <- sprintf("There are currently %d keys in the keyring. These will be deleted when you reset your password. Type YES to confirm: ", n)
    response <- readline(str)
    if(!identical(toupper(response), "YES")){
      message("aboring")
      return(invisible())
    }
  }
  unlink(agent_dir(), recursive = TRUE)
  agent_init()
}

backup <- function(file){
  file.rename(file, paste0(file, ".bak"))
}

new_password <- function(x){
  if(!interactive()) return(character())
  passwd <- ask_password("Please enter a new password. Leave blank or hit cancel for no passwd. You can update this later.")
  if(length(passwd) && nchar(passwd)){
    passwd2 <- ask_password("Enter same password again to confirm")
    if(!identical(passwd, passwd2)){
      stop("Passwords not identical")
    }
  }
  return(passwd)
}

ask_password <- function(...){
  passwd <- tryCatch({
    newpass <- getPass::getPass(...)
  }, interrupt = character())
  as.character(passwd)
}

