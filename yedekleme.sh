#!/bin/bash
 echo "Çalışan servisler durduruluyor..."
 echo " "
 sudo systemctl stop rolld && sudo systemctl stop stationd && sudo systemctl stop availd 
wait
cd
mkdir -p yedek
# Sonsuz döngü içinde çalışacak
while true; do
   echo "Yedekleme işlemi başlatılıyor..."
   echo " "
   cp -r $HOME/evm-station $HOME/yedek/ && \
   cp -r $HOME/tracks $HOME/yedek/ && \
   cp -r $HOME/.eigenlayer $HOME/yedek/ && \
   cp -r $HOME/.evmosd $HOME/yedek/ && \
   cp -r $HOME/.tracks $HOME/yedek/ && \
   cp -r $HOME/go $HOME/yedek/go && \
   cp -r $HOME/.avail $HOME/yedek/ && \
   cp -r $HOME/availup $HOME/yedek/ && \
   cp -r $HOME/send $HOME/yedek/ && \
   cp -r $HOME/.rollup-env $HOME/yedek/
   echo "Dosyalar dizine aktarıldı."
   echo " "
   sleep 5
   echo "Yedekleme dosyaları sıkıştırılıyor"
   echo " "
   t1=$(date +%d%m%Y)
   t2=$(date -d "-3 days" +%d%m%Y)
   tar -czvf yedek_"$t1".tar.gz -C $HOME/yedek .
   wait
   rm -rf $HOME/yedek/evm-station
   wait
   rm -rf $HOME/yedek/tracks
   wait
   rm -rf $HOME/yedek/.eigenlayer
   wait
   rm -rf $HOME/yedek/.evmosd
   wait
   rm -rf $HOME/yedek/.tracks
   wait
   rm -rf $HOME/yedek/.rollup-env
   wait
   rm -rf $HOME/yedek/go
   wait
   rm -rf $HOME/yedek/send
   wait
   rm -rf $HOME/yedek/availup
   wait
   rm -rf $HOME/yedek/.avail
   wait
   find $HOME -name "yedek_"$t2".tar.gz" -delete
   clear
   echo ""
   echo "Yedekleme sonrası fazlalık dosyalar temizlendi"
   echo ""
   echo "Servisler yeniden başlatılıyor..."
   sudo systemctl daemon-reload && sudo systemctl enable rolld && sudo systemctl start rolld && sudo systemctl enable stationd && sudo systemctl start stationd
   wait  
   echo " "
   echo "$t1 Yedekleme işlemi 24 saat sonra tekrar başlatılacak."
   sleep 86400
 done
