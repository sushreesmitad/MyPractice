#!/bin/bash  
#write above line else it won't work , also with this trick you can hide sensitive data or info
#script file to keep all keep global variable for all other script
export server_name="apache-tomcat-7.0.70";
export server_path="/opt/server/$server_name";
export backup_path="/opt/server/backup";
export clean_path="/opt/server/$server_name/work/Catalina/localhost/";
export project_name="circleweb";
export project_war="circleweb.war";
export logger_path="/home/ubuntu/logger";
