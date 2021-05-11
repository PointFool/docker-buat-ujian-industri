#!/bin/bash

#variabel

docker="curl -L get.docker.com -o docker.sh"

#mengecek ngecek

clear
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
echo "  by : PointFool"
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
echo ""
echo "Wordpress & Database (*untuk nomor 2 saja)"
echo "-------------------------------------------"
read -p "Nama -> " namawp
read -p "Password database -> " pass
read -p "Nama Database -> " namadb
read -p "port Wordpress -> " portwp
echo ""
echo "        Web (*untuk nomor 3 saja)"
echo "-------------------------------------------"
read -p "Nama -> " namaweb
read -p "Nama image Ex. john:1.0 -> " namaimage
read -p "Port Web -> " portweb
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
	clear
;;

2)
	echo "Wordpress & Database"
	echo ""
	echo "Buat Network"
	docker network create network_$namawp
	echo "done"
	sleep 2
	echo ""
	echo "Buat container Wordpress"
	docker run --name $namawp\_wp -p $portwp:80 --network network_$namawp -d wordpress
	echo "done"
	sleep 2
	echo ""
	echo "Buat container Database"
	docker run --name $namawp\_db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$pass --network network_$namawp -d mysql
	echo "done"
	sleep 2
	echo ""
	echo "Bikin Databasenya gan :'v"
	echo " wait"
	sleep 75
	docker exec -it $namawp\_db mysql -h 127.0.0.1 -P 3306 -u root -p$pass -e "CREATE DATABASE "$namadb";"
	echo ""
	echo "Masih beta :'v"
	echo "kalo error bikin manual aja"
	sleep 2
;;

3)
	echo "Bikin Web"
	echo ""
	sleep 2
	echo "Download httpd"
	docker pull httpd
	echo "done"
	sleep 2
	echo ""
	echo "Bikin Folder"
	mkdir $namaweb\_web
	cd $namaweb\_web/
	echo "done"
	sleep 2
	echo ""
	echo "Bikin Dockerfile"
	echo "FROM httpd:latest" >> Dockerfile
	echo "COPY . /usr/local/apache2/htdocs/" >> Dockerfile
	echo "Done"
	sleep 2	
	echo ""
	echo "Bikin index.html"
	echo "BERHASIL GAN!!" >> index.html
	echo "done"
	sleep 2
	echo ""
	echo "Build image"
	docker build -t $namaimage .
	echo "Done"
	sleep 2
	echo ""
	echo "Bikin container web" 
	docker create --name $namaweb\_web -p $portweb:80 $namaimage
	echo "Done"
	sleep 2
	echo ""
	echo "start container"
	docker start $namaweb\_web
	echo "done"
	sleep 2
	clear
	
;;

*)
	echo "Salah input gan :D"
	sleep 2
	clear
;;

esac
