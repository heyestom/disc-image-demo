You will need a DigitalOcean account for this demo.  

(DO is pretty cheap at 0.7¢/hour for the low-end box.  https://www.digitalocean.com/pricing/)

You will need your API Client ID and API Key, found here: 

https://cloud.digitalocean.com/api_access


Setup your build pipeline:

First, you'll want to fork the demo code which you can find at:

https://github.com/cgakok/disc-image-demo

![Alt text](/setupImages/1 - Fork Demo.png?raw=true "1 - Fork Demo code")

Next, navigate to snap-ci.com.

Sign-in with your GitHub credentials.

When prompted, Authorize Snap, setup first build, and add the demo project to snap

![Alt text](/setupImages/2 - Authorize Snap.png?raw=true "1 - Authorize Snap")
![Alt text](/setupImages/3 - Setup Build.png?raw=true "3 - Setup Build")
![Alt text](/setupImages/4 - Add disk-image-demo.png?raw=true "4 - Add disk-image-demo project to snap-ci")

At this point, snap will have checked-out your code and setup a dummy-stage.

Customize the build stages as shown in the following images.

![Alt text](/setupImages/5 - Customize build stages.png?raw=true "5 - Customize build stages")
![Alt text](/setupImages/6 - Setup Packer Install Stage.png?raw=true "6 - Setup Packer Install Stage")
![Alt text](/setupImages/7 - Setup Image Assembly.png?raw=true "7 - Setup Image Assembly")
![Alt text](/setupImages/8 - Setup Staging Deploy.png?raw=true "8 - Setup Staging Deploy")
![Alt text](/setupImages/9 - Setup Prod Deploy.png?raw=true "9 - Setup Prod Deploy")


Let me know if you have any issues with the setup:

Chris : ckozak@gmail.com
