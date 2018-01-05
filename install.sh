echo 'Enter Your Project Name : '
read project_name
echo 'Enter Your DB Host :  [localhost if blank ]'
read host_name
####### localhost #############
if [ "$host_name" = "" ]; then
	host_name="localhost"
fi;
echo 'Enter Your DB Name : ['$project_name' if blank ]'
read db_name
####### DBNAME: PROJECT NAME #############
if [ "$db_name" = "" ]; then
	db_name=$project_name
fi;
echo 'Enter Your DB User Name : [root if blank ]'
read db_user
####### DBUSER: root #############
if [ "$db_user" = "" ]; then
	db_user="root"
fi;
echo 'Enter Your DB Password : '
read db_pass

echo 'Enter Your Project Path [e.g : http://localhost/'$project_name']'
read project_path
echo 'Enter Admin User Name :[admin if blank ]'
read wp_admin
####### ADMIN USER : admin #############
if [ "$wp_admin" = "" ]; then
	wp_admin="admin"
fi;
echo 'Enter Admin Password :[admin if blank ]'
read wp_pass
####### ADMIN PASSWORD : admin #############
if [ "$wp_pass" = "" ]; then
	wp_pass="admin"
fi;
#Back To Parent Folder
#cd ..
mkdir $project_name
echo 'Permission to Project Folder'
sudo chmod 0777 -R $project_name
#Into Project folder
cd $project_name
#Download core wordpress
echo 'Enter WordPress version to install : [ Latest if blank ]'
read wp_version

if [ "$wp_version" = "" ]; then
	wp_version='latest';
fi;
wp core download --version=$wp_version
wp core config --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --dbhost=$host_name
#wp db drop --yes
wp db create
wp core install --url=$project_path --title=$project_name --admin_user=$wp_admin --admin_password=$wp_pass --admin_email="tristup@itobuz.com"

#Demo Content Section Starts
echo 'Do you want to Import Demo Contents :[y/n]'
read democontent
if [ "$democontent" = "y" ]; then
	wp plugin install wordpress-importer
	wp plugin activate wordpress-importer
wp import ../wptest.xml --authors=create	
fi;
echo 'Do you want to Install Woocommerce :[y/n]'
read woo
if [ "$woo" = "y" ]; then

	#IF wordpress importer not installed
	if [ "$democontent" != "y" ]; then
		wp plugin install wordpress-importer
		wp plugin activate wordpress-importer
	fi;
	
	wp plugin install woocommerce
	wp plugin activate woocommerce
	echo 'Do you want to Import Woocommerce Demo Contents :[y/n]'
	read woocontent
	if [ "$woocontent" = "y" ]; then
		wp import ../woo.xml --authors=create
	fi;
fi;
#Demo Content Section ENDS

pwd
# #wp cli to generate .htaccess and rewrite rules
echo "apache_modules:- mod_rewrite" > wp-cli.yml
wp rewrite structure '/%postname%/'
wp rewrite flush --hard