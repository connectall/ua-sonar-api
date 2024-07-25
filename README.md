# ua-sonar-api

This repository contains the source and binaries for a basic adapter that allows synchronization with the Sonat Qube product, and any other applications that ConnectAll integrates with.

To get started, download this repository into a local folder on your linux system. Then follow the following steps:

* Request a license from sales@connectall.com
* Set the sonar_setup.sh file setting the url's, etc. for your integration
* Edit the SonarCustomAdapterDescriptor.json, setting the fields:
  * type, ie, the name of the application you provided to sales above, eg, "ABC Company".
  * project name and id. This will be displayed in the ConnectALL entity mapping screen.
  * fields - You may add any custom fields in your sonar project, otherwise, no changes are necessary.
* Import the json into your ConnectAll system using the Configuration/Install Custom Adapter" menu option. Then import your license file.

Now you're all ready to create an application link, just like you did for your other application. This example assumes that qTest is mapped on the right side. Also remember to set the "sync type" to "push", not "poll".

To sync the data from sonar to your other endpoint, run the update_other.sh script, providing the application link name and sonar project id and issue type as arguments, eg, ./update_other.sh sonar2jirav2 SonarAdapter VULNERABILITY

If you would like the sync to occur automatically you can schedule the script as a cron job.
