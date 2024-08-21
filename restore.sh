#!/bin/bash
sudo systemctl stop rolld && sudo systemctl stop stationd
wait
tar_files=$(ls -1 ~/ | grep '\.tar.gz$')
# Eğer tar dosyası yoksa uyarı ver
if [ -z "$tar_files" ]; then
  echo "Home dizininde tar dosyası bulunamadı."
  exit 1
fi

# Tar dosyalarını sırayla listele ve seçim yap
echo "Lütfen bir tar dosyası seçin:"
select file in $tar_files; do
  if [ "$REPLY" -gt 0 -a "$REPLY" -le "$((${#tar_files[@]}+2))" ]; then
    selected_file="$file"
    break
  else
    echo "Geçersiz seçim. Lütfen tekrar deneyin."
  fi
done
   echo "Seçtiğiniz dosya: $selected_file, eğer seçtiğiniz dosyanın yanlış olduğunu düşünüyorsanız 15 saniye içinde CTRL+C ile çıkış yapınız"
   sleep 15 
   echo "Yedekleme işlemi için evm-station, tracks, .eigenlayer, .evmosd, .tracks, go, .rollup-env dizinleri olası hatalar için başka bir dizine taşınıyor..."
   echo " "
   sleep 5
   rm -rf restore
   mkdir restore
   mv $HOME/evm-station $HOME/restore/ && \
   mv $HOME/tracks $HOME/restore/ && \
   mv $HOME/.eigenlayer $HOME/restore/ && \
   mv $HOME/.evmosd $HOME/restore/ && \
   mv $HOME/.tracks $HOME/restore/ && \
   mv $HOME/go $HOME/restore/go && \
   mv $HOME/.avail $HOME/restore/ && \
   mv $HOME/availup $HOME/restore/ && \
   mv $HOME/send $HOME/restore/ && \
   mv $HOME/.rollup-env $HOME/restore/

   echo "Dizine taşıma işlemi tamamlandı."
   echo " "
   sleep 5
   echo "$selected_file yedeğinin geri yükleme işlemi başlatılıyor..."
   sleep 5
   echo ""  
   tar -xzvf $HOME/$selected_file -C $HOME
   screen -S rpc -p 0 -X stuff "^C"
   wait
   sudo systemctl daemon-reload && sudo systemctl enable rolld && sudo systemctl start rolld && sudo systemctl enable stationd && sudo systemctl start stationd
   wait
   screen -S rpc -X stuff "./AirchainsMonitor.sh\n"
   echo "$selected_file yedeğinin geri yükleme işlemi başarıyla tamamlandı. Logları kontrol edin."
   echo ""
   echo "Eğer her şey yolunda ise, sunucunuzda yer açmak için restore dizinini silebilirsizniz. Silmek için rm -rf restore komutunu kullanabilirsiniz."
   echo ""
   sleep 5
