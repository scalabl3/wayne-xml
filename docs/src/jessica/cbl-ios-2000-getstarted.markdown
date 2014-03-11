# Introducion
This section contains the information you need to start developing iOS apps with Couchbase Lite. It lists the system requirements, shows how to build a sample app, and explains how to add the Couchbase Lite iOS framework to your project.

## System Requirements

To develop Couchbase Lite apps for iOS, you need:

* [Couchbase Lite for iOS](http://www.couchbase.com/communities/couchbase-lite)
* [Xcode 4.6 or later](https://developer.apple.com/xcode/index.php)
* iOS SDK 6.0 or later

### Before You Begin

Before you can build Couchbase Lite apps, make sure you have the following tools installed on your computer. You might already have  some of them installed.

1. Download [Xcode](https://developer.apple.com/xcode/).

4. Download [Couchbase Lite for iOS](http://www.couchbase.com/download#cb-mobile) and move it to a permanent location.

3. Download and install [Git](http://git-scm.com).


## Adding Couchbase Lite To Your App

To add Couchbase Lite to your own app, you need to add the Couchbase Lite framework and other frameworks to your target and modify the build options, and then initialize Couchbase Lite in your app.
 
**To add the frameworks:** 

1. Download the [latest release of Couchbase Lite for iOS](http://www.couchbase.com/communities/couchbase-lite) and move it to a permanent location.

2. From the **Couchbase Lite** folder, drag the **CouchbaseLite.framework** folder to the **Frameworks** group in the Xcode Project Navigator.

3. In the **Choose options for adding these files** sheet, make sure that your app target is selected.

4. Open the project editor for your app target and click the **Build Settings** tab.

5. In the **Linking** section, on the **Other Linker Flags** row, add the flag `-ObjC` (be sure to use the capitalization shown).

6. Click the **Build Phases** tab.

7. In the **Link Binary With Libraries** section, click **+** and add the following items:
    * `CFNetwork.framework`
    * `Security.framework`
    * `SystemConfiguration.framework`
    * `libsqlite3.dylib`
    * `libz.dylib`

8. Build your app to make sure there are no errors.

**To initialize Couchbase Lite in your app:**

You initialize Couchbase Lite in your app delegate, which is usually named ***YourPrefix*AppDelegate**, as follows:

1. In the app delegate header file, add the following import directive:  

        #import <CouchbaseLite/CouchbaseLite.h>

2. In the app delegate header file, add the following property declaration:  

        @property (strong, nonatomic) CBLDatabase *database;
    
3. In the app delegate implementation file, add the following code to the **application:didFinishLaunchingWithOptions:** method:  

        // create a shared instance of CBLManager
        CBLManager *manager = [CBLManager sharedInstance];
        
        // create a database
        NSError *error;
        self.database = [manager createDatabaseNamed: @"my-database" error: &error];
    
    You should also add appropriate error checking code after each call. If either call fails, you might need to display an error message and exit.
    
    The legal characters for the database name are: lowercase letters \[`a-z`], digits \[`0-9`], and special characters \[`$_()+-/`].


