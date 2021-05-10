#!/bin/bash

docker="curl -L get.docker.com -o docker.sh"

#mengecek ngecek

echo "Tes internet"
ping -c 1 google.com > /dev/null 2>&1
  if [ "$?" != 0 ];

then

    echo [x]-[WADOOO]: Nyambung inet duls gan!!!;
    sleep 1
    
else

    echo [✔]-[Internet Connection]: MANTAP!;
    sleep 1
fi

echo ""
echo "curl"
which curl > /dev/null 2>&1
      if [ "$?" -eq "0" ]; 

then

      echo [✔]-[curl]: MANTAP!;

else

   echo [x]-[WADOOO]: butuh curl gan!!!;
   echo ""
   echo [!]-[bentar]: Tungguin;
   apt update
   apt install curl -y
   echo ""
   sleep 1
fi
sleep 2
clear

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
echo "*isi yang perlu aja"
read -p "Nama (web & wp) -> " nama
read -p "Password database (db) -> " pass
read -p "Nama image Ex. john:1.0 (web) -> " namaimage
read -p "Port Web (web) -> " portweb
read -p "port Wordpress (wp) -> " portwp
echo ""
clear
sleep 2

case $wh in

1)
	echo "Install Docker"
	$docker
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
	docker run --name $nama\_wp -p $portwp:80 --network network_$nama -d wordpress
	echo "done"
	sleep 2
	echo "Buat container Database"
	docker run --name $nama\_db -e MYSQL_ROOT_PASSWORD=$pass --network network_$nama -d mysql
	echo "done"
	sleep 2
	echo "bikin database nya manual ya :'v"
	echo "nama database : " $nama\_db
;;

3)
	echo "Bikin Web"
	sleep 2
	echo "Download httpd"
	docker pull httpd
	echo "done"
	sleep 2
	echo "Bikin Folder"
	mkdir $nama\_web
	cd $nama\_web/
	echo "done"
	sleep 2
	echo "bikin Dockerfile"
	echo "FROM httpd:latest" >> Dockerfile
	echo "COPY . /usr/local/apache2/htdocs/" >> Dockerfile
	sleep 2	
	echo "Bikin index.html"
	echo "BERHASIL GAN!!" >> index.html
	sleep 2
	echo "Build image"
	docker build -t $namaimage .
	sleep 2
	echo "Bikin container web" 
	docker create --name $nama\_web -p $portweb:80 $namaimage
	sleep 2
	echo "start container"
	docker start $nama\_web
	echo "done"
	sleep 2
;;

*)
	echo "Salah input gan :D"
	sleep 2
	clear
;;

esac
