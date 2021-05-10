#!/bin/bash

$path="$HOME/"
echo " ====WELCOME===="
echo ""
echo "  Script Docker"
echo "  Ujian industri"
echo "   by : saddam"
echo ""
echo " ==============="
echo ""

echo "Mau yang mana dulu?"
echo ""
echo "1) Install Docker"
echo "2) Bikin Wordpress & Database"
echo "3) Bikin web"
echo ""
read -p "pilih -> " wh
echo ""
echo "isi Formulir duls gan :'v"
echo ""
read -p "Nama -> " nama
read -p "Password database -> " pass
read -p "Nama image Ex. john:1.0 -> " namaimage
read -p "Port Web -> " portweb
read -p "port Wordpress -> " portwp
echo""
clear
sleep 2

case $wh in

1)
	echo "Install Docker"
	curl get.docker.com -o docker.sh
	sh docker.sh
	echo " Done "
	sleep 2
;;

2)
	echo "Wordpress & Database"
	echo "Buat Network"
	docker network create network_$nama
	echo "done"
	sleep 2
	echo "Buat container Wordpress"
	docker run --name $nama\_wp -p $portwp:80 --network network_$nama -d wordpress:latest
	echo "done"
	sleep 2
	echo "Buat container Database"
	docker run --name $nama\_db -e MYSQL_ROOT_PASSWORD=$pass --network network_$nama -d mysql:latest
	echo "done"
	sleep 2
	echo "bikin database nya manual ya :'v"
	echo "nama database : " $nama\_db
;;

3)
	echo "Bikin Web"
	sleep 2
	echo "pull httpd"
	docker pull httpd
	echo "done"
	sleep 2
	echo "Bikin Folder"
	mkdir $path/$nama\_web
	cd $nama\_web
	sleep 2
	echo "bikin Dockerfile"
	echo "FROM httpd:latest" >> Dockerfile
	echo "COPY . /usr/local/apache2/htdocs/" >> Dockerfile
	sleep 2	
	echo "index.html"
	echo "BERHASIL GAN!!" >> index.html
	sleep 2
	echo "Build image"
	docker build -t $namaimage .
	sleep 2
	echo "Bikin container web" 
	docker create --name $nama\_web -p $portweb:80 $nama:1.0
	sleep 2
	echo "start container"
	docker start $nama\_web
	echo "done"
;;

*)
	echo "Salah input gan :D"
	sleep 2
	clear
;;

esac
