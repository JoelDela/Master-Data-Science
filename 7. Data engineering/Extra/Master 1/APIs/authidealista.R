#-------------------------------------------------------------------------------#

# authidealista.R: Este codigo permite autenticarse a la API de idealista

# INPUT: consumer_key y consumer_secret (se obtienen rellenando el formulario
# de la url: http://developers.idealista.com/access-request)
# OUTPUT: token necesario para hacer solicitudes a la API

#-------------------------------------------------------------------------------#




#--------------------------------------------------------------------------------------------------------------------------------------#
#  ___           _          _                    _              _     _         _       _                  _   _         _           
# |_ _|  _ __   (_)   ___  (_)   ___    _       / \     _   _  | |_  | |__     (_)   __| |   ___    __ _  | | (_)  ___  | |_    __ _ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)     / _ \   | | | | | __| | '_ \    | |  / _` |  / _ \  / _` | | | | | / __| | __|  / _` |
#  | |  | | | | | | | (__  | | | (_) |  _     / ___ \  | |_| | | |_  | | | |   | | | (_| | |  __/ | (_| | | | | | \__ \ | |_  | (_| |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   /_/   \_\  \__,_|  \__| |_| |_|   |_|  \__,_|  \___|  \__,_| |_| |_| |___/  \__|  \__,_|
#--------------------------------------------------------------------------------------------------------------------------------------#                                                                                                                                   



#Create your own appication key
consumer_key <- "rrry3jb98a7wjs5xbcwsk3u7z2rb9q77"
consumer_secret <- "OM5tXahuf36x"

#Use basic auth
secret <- jsonlite::base64_enc(paste(consumer_key, consumer_secret, sep = ":"))
req <- httr::POST("https://api.idealista.com/oauth/token",
                  httr::add_headers(
                    "Authorization" = paste("Basic", gsub("\n", "", secret)),
                    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
                  ),
                  body = "grant_type=client_credentials"
)

#Extract the access token
token <- paste("Bearer", httr::content(req)$access_token)





#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#
