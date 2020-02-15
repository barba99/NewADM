#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
SCPidioma="${SCPdir}/idioma" && [[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}
echo -e "${cor[4]} $(fun_trans "Speed Test") [NEW-ADM]"
msg -bar
ping=$(ping -c1 google.com |awk '{print $8 $9}' |grep -v loss |cut -d = -f2 |sed ':a;N;s/\n//g;ta')
# PROGRESS - BAR
(
echo -ne "[" >&2
while [[ ! -e /tmp/pyend ]]; do
echo -ne "." >&2
sleep 0.8s
done
rm /tmp/pyend
echo -e "]" >&2
) &
[[ $(dpkg --get-selections|grep -w "python"|head -1) ]] || apt-get install python -y &>/dev/null
starts_test=$(python ${SCPfrm}/speedtest.py --share) && touch /tmp/pyend
sleep 0.6s
tput cuu1 && tput dl1
down_load=$(echo "$starts_test" | grep "Download" | awk '{print $2,$3}')
up_load=$(echo "$starts_test" | grep "Upload" | awk '{print $2,$3}')
re_sult=$(echo "$starts_test" | grep "result" | awk '{print $3}')
msg -ama " $(fun_trans "Latencia"): $ping"
msg -ama " $(fun_trans "Upload"): $up_load"
msg -ama " $(fun_trans "Download"): $down_load"
msg -ama " $(fun_trans "Result"): $re_sult"
msg -bar 