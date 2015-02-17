## Install pre-requisites
###1. Install Dev Tools
If you are installing grunt and npm for the first time, I recommend using homebrew

Homebrew requires installing Xcode and the Command line Tools. You need an Apple ID to download Xcode from the App Store.

* Download Xcode from the App Store
* Download Command Line Tools from Dev Center: https://developer.apple.com/downloads/index.action 

###2. Install Homebrew
__http://shapeshed.com/setting-up-nodejs-and-npm-on-mac-osx/__

###3. Install nodejs, npm and grunt
* install npm : `brew install nodejs`
* install grunt: `npm install grunt-cli -g`

---
 
## Uploading Flash Builds
These are the set of steps for creating a new build using Flash Builder and uploading it to the server using a grunt command. 

### Install CUP Grunt project
You need to do this only once after installing the pre-requisites

* navigate to the project directory, ie, the root of the git repository (__cup-housing__)
* run the command `npm install`
* a new directory will be created __node_modules__


### Build and Upload

####1. Clean
* run `grunt clean` from the project directory
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
* run `grunt build` and the build directory gets uploaded to the server

--

## Uploading JSON File
The following grunt command and steps allow uploading only the data files (__settings.json__ and __2013-incomes.csv__) to the server. This is useful for updating the data on the server without having to create an entirely new build.

Once edits have been made to the data files, they __must__ get committed and pushed to git.

### Using grunt command
* run `grunt data` and the data files will uploaded to the server

### Using grunt watcher
#### Start the watcher
* run `grunt watch` starts to watch changes to the __assets/data__ directory

#### Iterative edits and uploads
* open and edit any of the files in __assets/data__
* any changes to made on any file will automatically start the upload of the data files to the server
* this process is triggered as soon as file as saved
* reload the site and check that data is updated
* rinse and repeat from step 2

 
 

