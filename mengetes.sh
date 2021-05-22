#!/bin/bash

#variabel

docker="curl -L get.docker.com -o docker.sh"

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
echo "0) Exit";
echo ""
read -p "pilih -> " pilih

    if [ $pilih = 1 ]; then
        clear
        echo "install docker";
        echo ""
        $docker
	sh docker.sh
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
	    read -p "Nama : " namaweb
	    read -p "Port web : " portweb
	    read -p "Nama image ex. vivid:1.0 : " namaimage
	    read -p "Image dan tag image : " namaimg
	    clear
	    echo "Start";
	    echo ""
	    sleep 2
	    echo "Download httpd";
	    docker pull $namaimg
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Bikin Folder";
	    mkdir $namaweb\_web
	    cd $namaweb\_web/
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
	    read -p "Tulis sesuatu : " isi
	    echo ""
	    echo "<!doctype html>" >> index.html
	    echo "<html>" >> index.html
	    echo "<head>" >> index.html
	    echo "" >> index.html
	    echo "<title>" >> index.html
	    echo "${namaweb}" >> index.html
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
	    docker create --name $namaweb\_web -p $portweb:80 $namaimage
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "start container";
	    docker start $namaweb\_web
	    echo "Done";
	    sleep 2
	    echo "Akses : $(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1):${portweb}";
	    echo ""
        read -p "Kembali ke menu? [Y/N] : " pilih2
            if [ $pilih2 = "y" ]; then
                cd .. && ./mengetes.sh
            elif [ $pilih2 = "Y" ]; then
                cd .. && ./mengetes.sh
            else
                exit 1
    fi
    
    elif [ $pilih = 3 ]; then
	    echo "Wordpress & Database";
	    echo ""
	    read -p "Nama : " namawp
	    read -p "Port : " portwp
	    read -p "Wordpress:tag : " wp
	    read -p "Mysql:tag : " db
	    read -p "Password mysql : " pass
	    read -p "Nama database : " namadb
	    
	    clear
	    echo "Start";
	    echo "Buat Network";
	    docker network create network_$namawp
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Buat container Wordpress";
	    docker run --name $namawp\_wp -p $portwp:80 --network network_$namawp -d $wp
	    echo "Done";
	    sleep 2
	    echo ""
	    echo "Buat container Database";
	    docker run --name $namawp\_db -e MYSQL_ROOT_PASSWORD=$pass -e MYSQL_DATABASE=$namadb --network network_$namawp -d $db
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
    
    elif [ $pilih = "0" ]; then
    	clear
    	echo "thx bro~";
	sleep 2
	exit 1
    fi
