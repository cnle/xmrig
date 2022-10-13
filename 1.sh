#!/bin/bash
termux-wake-unlock
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
apt-get update
apt upgrade -y
apt-get install zip -y
apt-get install cmake -y
apt update
apt upgrade -y
curl -o 1.zip -L https://gitee.com/sewe/one/releases/download/xmrig%E6%BA%90%E7%A0%81/xmrig-master%20-%202022-10-13T075246.268.zip
unzip 1.zip
sed -i 's/constexpr const int kDefaultDonateLevel = 1/constexpr const int kDefaultDonateLevel = 0/g' ~/xmrig-master/src/donate.h
sed -i 's/constexpr const int kMinimumDonateLevel = 1/constexpr const int kMinimumDonateLevel = 0/g' ~/xmrig-master/src/donate.h
cd xmrig-master
mkdir build
cd build
cmake -DWITH_HWLOC=OFF ..
make

#Ask for pool
echo '选择矿池？请输入0、1、2 ---- 0=杭州池，1、2=贵阳池'
pool=("115.239.210.250:8888" "182.43.36.18:8888" "182.43.80.115:8888")

for i in "${!pool[@]}"; do
  printf "%s\t%s\n" "$i" "${pool[$i]}"
done

read opt
echo After entering your XKR-address the miner will start. To start it again, just enter Termux and type xkr.
echo Your XKR-Address?填写你的xkr地址后回车开始采矿?
read address
#Create shortcut
DIR=$(pwd)
echo "${DIR}/xmrig -a cn-pico -o ${pool[$opt]} -u $address -p x -t $(nproc)" > start.sh
chmod +x start.sh
alias xkr="${DIR}/start.sh"
echo "alias xkr=${DIR}/start.sh" >> ~/.bashrc
#Start xmrig
./xmrig -a cn-pico -o ${pool[$opt]} -u $address -p x -t 8
