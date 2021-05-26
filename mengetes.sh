#!/bin/bash

#mengecek ngecek

clear
if [[ $EUID -ne 0 ]]; then
        echo  "Harus sudo su dulu!!!";
        exit 1
fi

if [ $(id -u) != "0" ]; then

      echo [!]::[Check Dependencies] ;
      sleep 2
      echo [✔]::[Check User]: $USER ;
      sleep 1
      echo [x]::[not root]: you need to be [root] to run this script.;
      echo ""
   	  sleep 1
	  exit


else

   echo [!]::[Check Dependencies]: ;
   sleep 1
   echo [✔]::[Check User]: $USER ;

fi

echo ""
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

echo " ====WELCOME====";
echo ""
echo "  Script Docker";
echo "  Ujian industri";
echo "  by : PointFool";
echo ""
echo " ===============";
echo ""

echo "Mau yang mana dulu?";
echo ""
echo "1) Install Docker";
echo "2) Bikin web";
echo "3) Bikin Wordpress & Database";
echo "4) Setting IP";
echo "0) Exit";
echo ""
read -p "pilih -> " pilih

    if [ $pilih = 1 ]; then
        clear
        echo "install docker";
        echo ""
	curl -fsSL get.docker.com | sh
        echo "Done";
        sleep 2
        read -p "Kembali ke menu? [Y/N] : " pilih1
            if [ $pilih1 = "y" ]; then
                ./mengetes.sh
            elif [ $pilih1 = "Y" ]; then
                ./mengetes.sh
            else
                exit 1
    fi
    
    elif [ $pilih = 2 ]; then
        echo "Bikin Web"
	    echo ""
	    read -p "Nama container : " namaweb
	    read -p "Port web : " portweb
	    read -p "Image:tag ex. httpd:tag : " namaimg
	    read -p "Nama image ex. vivid:1.0 : " namaimage
	    clear
	    echo "Start";
	    echo ""
	    sleep 2
	    echo "Download image";
	    docker pull $namaimg
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Bikin Folder";
	    cd ..
	    mkdir $namaweb
	    cd $namaweb/
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Bikin Dockerfile";
	    echo "FROM ${namaimg}" >> Dockerfile
	    echo "COPY . /usr/local/apache2/htdocs/" >> Dockerfile
	    echo "Done";
	    sleep 2	
	    echo ""
	    echo "Bikin index.html";
	    echo ""
	    read -p "title : " title
	    read -p "Tulis sesuatu : " isi
	    echo ""
	    echo "<html>" >> index.html
	    echo "<head>" >> index.html
	    echo "" >> index.html
	    echo "<title>" >> index.html
	    echo "${title}" >> index.html
	    echo "</title>" >> index.html
	    echo "</head>" >> index.html
	    echo "" >> index.html
	    echo "<body>" >> index.html
	    echo "<p>${isi}</p>" >> index.html
	    echo "</body>" >> index.html
	    echo "" >> index.html
	    echo "</html>" >> index.html
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Build image";
	    docker build -t $namaimage .
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Bikin container web";
	    docker run -dit --name $namaweb -p $portweb:80 $namaimage
	    echo "Done";
	    sleep 2
	    echo "Akses : $(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1):${portweb}";
	    echo ""
            read -p "Kembali ke menu? [Y/N] : " pilih2
            if [ $pilih2 = "y" ]; then
                cd .. && cd docker-buat-ujian-industri/ && ./mengetes.sh
            elif [ $pilih2 = "Y" ]; then
                cd .. && cd docker-buat-ujian-industri/ && ./mengetes.sh
            else
                exit 1
    fi
    
    elif [ $pilih = 3 ]; then
	    echo "Wordpress & Database";
	    echo ""
	    read -p "Nama container Wordpress : " namawp
	    read -p "Nama container db : " namadb
	    read -p "Nama network :" namanet
	    read -p "Port wordpress : " portwp
	    read -p "Wordpress:tag : " wp
	    read -p "Mysql:tag : " db
	    read -p "Password mysql : " pass
	    read -p "Nama database : " isidb
	    
	    clear
	    echo "Start";
	    echo "Buat Network";
	    docker network create $namanet
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Buat container Wordpress";
	    docker run --name $namawp -p $portwp:80 --network $namanet -d $wp
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Buat container Database";
	    docker run --name $namadb -e MYSQL_ROOT_PASSWORD=$pass -e MYSQL_DATABASE=$isidb --network $namanet -d $db
	    echo "Done";
	    echo "Akses : $(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1):${portwp}";
	    sleep 2
	    echo ""
	    read -p "Kembali ke menu? [Y/N] : " pilih3
            if [ $pilih3 = "y" ]; then
                ./mengetes.sh
            elif [ $pilih3 = "Y" ]; then
                ./mengetes.sh
            else
                exit 1
    fi
    
    elif [ $pilih = 4 ]; then
    	echo "Setting IP";
	echo ""
	echo "backup file original";
	mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
	echo ""
	read -p "IP : " ip
	read -p "Gateway : " gt
	read -p "Nameservers : " srv
	echo ""
	echo "network:" >> /etc/netplan/00-installer-config.yaml
	echo " ethernets:" >> /etc/netplan/00-installer-config.yaml
	echo "  enp0s3:" >> /etc/netplan/00-installer-config.yaml
	echo "   addresses: [${ip}]" >> /etc/netplan/00-installer-config.yaml
	echo "   gateway4: ${gt}" >> /etc/netplan/00-installer-config.yaml
	echo "   nameservers:" >> /etc/netplan/00-installer-config.yaml
	echo "    addresses: [${srv}]" >> /etc/netplan/00-installer-config.yaml
	echo " version: 2" >> /etc/netplan/00-installer-config.yaml
	echo "applying"
	netplan apply
	echo ""
	echo "cek"
	sleep 2
	ip a show enp0s3
	echo ""
	echo "Done"
	read -p "Kembali ke menu? [Y/N] : " pilih3
            if [ $pilih3 = "y" ]; then
                ./mengetes.sh
            elif [ $pilih3 = "Y" ]; then
                ./mengetes.sh
            else
                exit 1
    fi
    
    elif [ $pilih = "0" ]; then
    	clear
    	echo "thx bro~";
	sleep 2
	exit 1
    fi
