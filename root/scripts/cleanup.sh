#!/bin/bash
#script to clean up the resource
#later remove all the static path with dynamic environment variable and refer it in every script.
#below are variable defined in globalname.sh file
source globalname.sh
echo "date is `date`";
#dt_var=$(date +%d-%b-%Y);
#name="somename";
#echo $name;
#echo $dt_var;
#echo "value of dat_var is" $dt_var;

#remove the directory if exist for today date
#rm -rf $backup_path/$dt_var;
#create a directory and keep the jar
#mkdir /$backup_path/$dt_var
#copy the jar to the backup folder
#cp -p $server_path/webapps/$project_war /$backup_path/$dt_var
#remove the jar from webapps folder along with directory
#echo $server_path;
rm -rf /opt/server/apache-tomcat-7.0.70/webapps/circleweb.war
rm -rf /opt/server/apache-tomcat-7.0.70/webapps/circleweb





