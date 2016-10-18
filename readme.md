A Token Agent for R
-------------------

## API

Storing tokens 

```r
add_token(name, value)
get_token(name)
del_token(name)
```

Storing env variables

```r
add_env(name, value)
get_env(name, set = TRUE)
del_env(name)
load_envs()
```

Store:

 - Value can be anything serialized()
 - Randomly generated master key 
 - Encrypt value with aes_cbc()
 - Store each token in file substring(sha1(name), 16) with also IV=sha1(name)

Where to store master key:

 - Encrypt master key with RSA keypair
 - Preferred: in OS keychain (for master key or rsa passwd?)
 - Or ssh/gpg agent ?
 - Otherwise: using RSA password protected
 - 

Other:

 - when prompting for password, maybe display the calling stack to see which package is asking?
 - once the keychain is unlocked, cache the unencrypted tokens
 - make sure R does not access other stuff from the OS keychain

