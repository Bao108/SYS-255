#!/bin/bash
# Install Grav CMS on Rocky Linux 9 with Apache and add some pages.
# Run as root:  bash grav.sh
set -e
 
read -p "Enter a title for your site: " TITLE
WEB=/var/www/html
 
# Install Apache, PHP 8.2 and tools
dnf module enable php:8.2 -y
dnf install -y httpd php php-gd php-mbstring php-xml php-intl php-pecl-zip unzip
 
# Download Grav (with admin panel) into the web root
curl -L -o /tmp/grav.zip https://getgrav.org/download/core/grav-admin/latest
unzip -q -o /tmp/grav.zip -d /tmp
cp -a /tmp/grav-admin/. $WEB/
 
# Let Grav's .htaccess work
echo "<Directory $WEB>
    AllowOverride All
</Directory>" > /etc/httpd/conf.d/grav.conf
 
# Site title
sed -i "s/^title:.*/title: \"$TITLE\"/" $WEB/user/config/site.yaml
 
# Content pages:  page <folder> <title> <text>
rm -rf $WEB/user/pages/*
page() {
    mkdir -p $WEB/user/pages/$1
    printf -- "---\ntitle: %s\n---\n\n# %s\n\n%s\n" "$2" "$2" "$3" > $WEB/user/pages/$1/default.md
}
page 01.home     "Home"     "Welcome to $TITLE, running Grav CMS with Apache."
page 03.about    "About"    "Grav is a flat-file CMS. Every page is a Markdown file, so there is no database."
page 04.services "Services" "Web hosting with Apache Bash script."
page 05.contact  "Contact"  "Questions about this site? Ask the site administrator."
 
# Blog section with posts:  post <folder> <title> <date> <text>
mkdir -p $WEB/user/pages/02.blog
printf -- "---\ntitle: Blog\ncontent:\n    items: '@self.children'\n    order:\n        by: date\n        dir: desc\n---\n" > $WEB/user/pages/02.blog/blog.md
post() {
    mkdir -p $WEB/user/pages/02.blog/$1
    printf -- "---\ntitle: %s\ndate: %s\n---\n\n%s\n" "$2" "$3" "$4" > $WEB/user/pages/02.blog/$1/item.md
}
post setting-up-web01  "Setting Up web01"          "I gave web01 a hostname and a static IP with nmcli, then pointed DNS at the domain controller."
post joining-ad        "Joining Active Directory"  "I joined web01 to the AD domain with realm, so I can log in with my domain admin account."
post installing-grav   "Installing Grav CMS"       "Logged in with my AD account, I installed Apache, PHP 8.2 and Grav with one Bash script." 

# Permissions, SELinux, firewall, start Apache
chown -R apache:apache $WEB
chcon -R -t httpd_sys_rw_content_t $WEB
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
systemctl enable --now httpd
systemctl restart httpd
 
echo "Done! Open http://$(hostname -I | awk '{print $1}')/ on your Windows host."
echo "Go to /admin to create your admin login."
