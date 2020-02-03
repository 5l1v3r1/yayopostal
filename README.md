# yayopostal

if ur server head is alright if not run diag
make sure to have server with 2 ip address

# MADE WITH LOVE BY @therealelyayo

# StartHere
fix dependencies
wget https://raw.githubusercontent.com/therealelyayo/yayopostal/master/postaldebian.sh

$chmod +x postaldebian.sh
# To run the script give the following command, again in the same directory.
$./postaldebian.sh

my postal mail server
after installing from postaldebian.sh proceed laka dis

# Once this is done, you are ready to make your initial user account, just run:
postal make-user

Add Postal to startup
# /etc/rc.local
  #!/bin/sh -e
  sudo -u postal postal start
  exit 0
  
  
## Configuring Postal
Open the file /opt/postal/config/postal.yml and change the entries of the DNS section to the domain name of your choice. Feel free to go through other entries of generic domain names and replace them too. In the example below, the domain name used is just ranvirblog.com feel free to use your domain name with any reasonable sub domain like mail.mydomainname.com
dns:
 # Specifies the DNS record that you have configured. Refer to the documentation at
 # https://github.com/atech/postal/wiki/Domains-&-DNS-Configuration for further
 # information about these.
 mx_records:
 - mx.ranvirblog.com
 smtp_server_hostname: ranvirblog.com
 spf_include: spf.ranvirblog.com
 return_path: rp.ranvirblog.com
 dkim_identifier: postal
 domain_verify_prefix: postal-verification
 custom_return_path_prefix: psrp
## To access the main interface, add the following DNS records using your DNS provider’s interface.

An A record for subdomain.yourdomain.com
An A record for track.yourdomain.com

## Interface and Getting Started
Now that you are ready to access the interface and start using Postal. Visit, https://yourdomain.com and enter your initial email address and password that you chose after running the postal make-user command. After which the interface asks for Organization Setup. Add in the name of your organization and from there go to the next prompt for Build A New Server.



Enter a reasonable name and let the mode stay on ‘Live’ and click on build server. From here you will be taken to your mail server management interface. Here, click on the top left menu that say “Domains”.



Click on “Add your first domain”. In my case, it is ‘ranvirblog.com’ your case can be very different, like mail.yourdomain.com. In any case, once you have entered your domain name you will be greeted by a screen that will show you step by step how to properly add each record.

Once you are satisfied with your domain name records, you can click on the “Check my records are correct” button on the top of the screen and it will verify whether or not everything is fine. You may want to keep all of the DKIM values private for security reasons. As an example, here is the DNS record list that worked with the server.



## The next steps
Now we are ready to send our first email. Click on Messages from the black menu bar on the top of the screen. Then click on Send Message that appears below it.



## The message would be queued for a while before being sent. Once you have successfully sent your first email via this server. It is time to set up actual set up the proper encryption key for secure SSL (we were using self-signed certificate all this while!)

$postal register-lets-encrypt username@example.com
Then you can proceed on to adding new users and also explore some of the spam mitigation options. You may also want to look into Click and Open Tracking Installing and running Spam Assassin is highly recommended, as well.
