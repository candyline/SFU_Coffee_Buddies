# SFU Coffee Buddies #

----------------------------------------------------------------------------
## Goal: ##
SFU Coffee Buddies aims to engage students as well as connect students together

----------------------------------------------------------------------------
## Version 1.0.0 ##

----------------------------------------------------------------------------
## Steps to set up ##

First set up a server and database on localhost

### 1) install home brew ###

     - /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### 2) install node ###

     - brew install node

### 3) install mongodb ###

     - brew install mongodb

### 4) create folder for mongodb ###

     - sudo mkdir -p /data/db

     - sudo chown -R $USER /data/db

### 5) in terminal anywhere run mongodb ###

     - mongod

### 6) go to git repository restapi/ ###

     - node server.js

### 7) to test, get chrome extension Postman ###
in the body field,
add text, and user, and specify x-www-form-urlencoded

--------------------------------------------------------------------------------------
## To Fix compile errors + use carthage for project, Follow these steps: ##

Do in any directory in terminal:

     - brew update

     - brew install carthage
-------------------------------------------------------------------------------------
## Go into the directory that contains the cartfile which should be the SFU Coffee Buddies directory ##

     - carthage update --platform iOS --no-use-binaries

and will fix the module compile version error

-------------------------------------------------------------------------------------
For more info, please email us

Frank - fpsu@sfu.ca

Eton - etonk@sfu.ca

David - admao@sfu.ca

Daniel - dzt2@sfu.ca

Mauricio - mveloz@sfu.ca