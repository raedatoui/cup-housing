## Uploading Flash Builds
This set of tools is intended to be used with Flash Builder.

### Install pre-requisites
####1. Install Dev Tools
If you are installing grunt and npm for the first time, I recommend using homebrew

__http://shapeshed.com/setting-up-nodejs-and-npm-on-mac-osx/__

Homebrew requires installing Xcode and the Command line Tools. You need an Apple ID to downlaod Xcode from the App Store.

* install homebrew
* install npm : `brew install nodejs`
* install grunt: `npm install grunt-cli -g`

####2. Install CUP Grunt project
* navigate to the project directory, ie, the root of the git repository (__cup-housing__)
* run the command `npm install`
* a new directory will be created __node_modules__


### Build and Upload

####1. Clean
* run `grunt clean` from the project root
* the __bin-release__ will emptied

####2. Export Release Build
* Open Flash Builder and load the project
* Make sure no errors are reported by the compiler (Problems tab) 
* Go to the menu and select __Project__ > __Export Release Build...__ 
* When prompted to export, make sure you set the field **Export to Folder** to ___bin-release/build___

####3. Upload to server via FTP
* copy __ftp_auth.sample__ and create a new file named __ftp_auth__
* open and edit __ftp_auth__ and set your FTP username and password
* open __Gruntfile.js__ and find the line: ` var uploadPath = './html/flash/2013/';`. This defines the path where the build will be uploaded
* run `grunt upload` and the build gets uploaded to the server



## Uploading JSON File