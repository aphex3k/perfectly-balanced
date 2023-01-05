#!/bin/bash

# Perfectly Balanced as all things should be
# By Cuaritas 2021
# MIT License

# This script tries to get your channels perfectly balanced by using `rebalance.py`
# See https://github.com/C-Otto/rebalance-lnd for more info

VERSION="0.0.10"

FILENAME=$0

MAX_PPM=10 # Sats

TOLERANCE=0.95 # 95%

LND_DIR="${LND_DIR:-$HOME/.lnd/}"
LND_IP="${LND_IP:-localhost}"
LND_GRPC_PORT="${LND_GRPC_PORT:-10009}"

REBALANCE_LND_VERSION="484c172e760d14209b52fdc8fcfd2c5526e05a7c"

REBALANCE_LND_FILEPATH="${REBALANCE_LND_FILEPATH:-/tmp/rebalance-lnd-$REBALANCE_LND_VERSION/rebalance.py}"

W='\e[0m' # White
P='\e[1;35m' # Purple Thanos
R='\e[1;31m' # Red
G='\e[1;32m' # Green
Bo="\033[1m" # Bold

echo -e "$(
cat << PERFECT
${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}░░▒▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓${W}
▒Perfectly balanced, as all things should be...▒▒▒▒${P}░░░▒▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓████▓${W}
▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}░░░░░▒▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓▓▓▓▓▓▓█▓███▓${W}
▒▒▒▒▓▒▒░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}░░░░░░▒▓▓██▓▒▓▓▓▓▓▓▓▓▓▓▓███▓██▓▓▓▓▓▓▓▓▓▓█▓███▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}░░░░░▒▓▓▓▓██▓▒▓▓▓▓▓▓▓▓▓█████▓██▓▓▓▓▓▓▓▓▓▓█▓██▓▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▓▒░░░░░░░▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}░░▒▒▓▓▓▓▓▓███▒▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓▓▓▓▓▓█▓██▓▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░░▒▒▒▒▒▒▒▒▒▒░${P}░░░░░░▒▒▓▓███▓▒▓▓▓▓▓▓▓▓▓▓███████▓▓▓▓▓▓▓▓▓▓██████▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒░${P}░░░░░▒▒▒▒▓▓███▓▓▓▓▓▓▓▓▓▓▓▓███████▓▓▓▓▓▓▓▓▓▓███████${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒▓▓█▓▓▓▓▓▓▒▒▒░░▒${P}▒▓▓▓▓▓████▓▓▓▓▓▓▓▓▓▓▓▓██████▓▓▓▓▓▓▓▓▓▓▓███████${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▓▓▓▓▓▓▓▓▓▓${R}███▓████▓▓█▓${W}▓▓▓▒▓${P}▓████▓▓▓███▓█▓▓█████████▓▓▓▓▓▓▓▓▓▓███████▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓${R}▓▓▓▓████████▓▓▒▒${W}▓▒▓▓▓▓▒▒${P}▒▓███▓███████████▓▓▓▓▓▓▓▓▓██████▓▓▓${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓${R}▓▓▓▓▓▓▓▓▒▒▒▓▒▓▓${W}▓▒▓▓▒▒░▒▒▒▒▒${P}▓▓▓▓▓▓▓▓▒▒▒▓▓█▓▓▓▓▓▓▓▓▓▓███████${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${R}▓▓▓▓▓▓▓▓▓▒▓▓▓▓${W}▓▓▓▓▓▓▓▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓████████████${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓▓▓▓▓▓${W}▓▓▓▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓▓▓▓▓▒${W}
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓▓▓▓▓▓▓▓${W}▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓▒▒▓▓▓▓▓▓${W}▒▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓█████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▒▓▓▓▓▓▓▓▓▓▓${W}▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓█▓▒▓▓▓███▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${P}▓▓▓▓▓▓▓▓${W}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓█▓█▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒
${W}
PERFECT
)"

setup() {

  error=0

  if ! [ -f "$REBALANCE_LND_FILEPATH" ]; then
    echo -e "Downloading 'rebalance-lnd' from https://github.com/C-Otto/rebalance-lnd\n"
    wget -qO /tmp/rebalance-lnd.zip "https://github.com/C-Otto/rebalance-lnd/archive/$REBALANCE_LND_VERSION.zip"
    if [[ $? -ne 0 ]]; then
      echo -e "Error: unable to download 'rebalance-lnd' from https://github.com/C-Otto/rebalance-lnd\n"
      error=1
    fi
    unzip -q /tmp/rebalance-lnd.zip -d /tmp &> /dev/null
  fi

  if ! [ -x "$(command -v python3)" ]; then
    echo -e "Error: 'python3' is not available!\n"
    error=1
  fi

  if ! [ -f "$REBALANCE_LND_FILEPATH" ]; then
    echo -e "Error: 'rebalance-lnd.py' is not available!\n"
    error=1
  fi

  python3 $REBALANCE_LND_FILEPATH -h &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "Error: 'rebalance-lnd.py' dependencies are not available!"
    echo -e "\tPlease install them using 'pip install -r requirements.txt'\n"
    cp "/tmp/rebalance-lnd-$REBALANCE_LND_VERSION/requirements.txt" . &> /dev/null
    error=1
  fi

  if ! [ -x "$(command -v bc)" ]; then
    echo -e "Error: 'bc' is not available!\n"
    error=1
  fi

  if [ $error -eq 1 ]; then
    exit 1
  fi
}

setup

reb () {
  python3 $REBALANCE_LND_FILEPATH --grpc=${LND_IP}:${LND_GRPC_PORT} --lnddir=$LND_DIR $@
}

channels_file=`mktemp`

cat << CHAN > $channels_file
`reb -l -c`
CHAN

channels() {
  cat $channels_file
}

UNBALANCED=()
IGNORE=()
SHUFFLED=()

headers() {
  echo -e "${Bo}Balance Graph  | Channel ID         | Oubound Cap | Inbound Cap | Channel Alias${W}"
}

graph() {
  temp=`channels | grep $c`
  inbound=`echo $temp | awk '{ printf $3 }' | sed 's/,//g'`
  outbound=`echo $temp | awk '{ printf $5 }' | sed 's/,//g'`
  if [[ `bc -l <<< "$inbound == 0 || $outbound == 0"` -eq 1 ]]; then
    export GREP_COLORS='ms=01;31'
    UNBALANCED+=("$c")
  elif [[ `bc -l <<< "$inbound/$outbound >= $TOLERANCE && $outbound/$inbound >= $TOLERANCE"` -eq 1 ]]; then
    export GREP_COLORS='ms=01;32'
  else
    export GREP_COLORS='ms=01;31'
    UNBALANCED+=("$c")
  fi
  total=`bc -l <<< "$inbound + $outbound"`
  inb=`bc -l <<< "x=($inbound*12/$total)+0.5;
                  if (x < 1) {
                    print 0
                    x
                  } else if (x > 11.5) {
                    13
                  } else {
                    x
                  }"`
  out=`bc -l <<< "13-$inb"`
  for x in `seq 0 ${inb%.*}`; do
    if [[ ${inb%.*} -eq 0 ]]; then
      break
    fi

    printf "${P}▓"
  done
  for x in `seq 0 ${out%.*}`; do
    if [[ ${out%.*} -eq 0 ]]; then
      break
    fi

    printf "${G}▓"
  done
  printf "${W} | "
}

list () {
  for ig in ${IGNORE[@]}; do
    sed -i.bak "/$ig/d" $channels_file
  done

  IDS=(`channels | awk '{ printf "%s\n", $1 }'`)

  echo -e "\nChecking ${#IDS[@]} channels:\n"

  inbound=0
  outbound=0

  headers
  for c in ${IDS[@]}; do
    graph
    channels | grep --color=always $c
  done

  if [[ ${#UNBALANCED[@]} -eq 0 ]]; then
    echo -e "\nAll Channels are balanced according to tolerance levels $TOLERANCE\n"
    exit
  else
    echo -e "\nChannels in red are outside tolerance $TOLERANCE, green are ok\n"
  fi
}

rebalance () {
  echo -e "Trying to rebalance these ${#UNBALANCED[@]} unbalanced channels, max fee $MAX_PPM sats:\n"
  export GREP_COLORS='ms=01;31'
  headers
  for c in ${UNBALANCED[@]}; do
    graph
    channels | grep --color=always $c
  done
  echo
  for v in $(shuf -e "${UNBALANCED[@]}"); do
    amount=`reb -l --show-only $v | grep "Rebalance amount:" | awk '{ printf $3 }' | sed 's/,//g'`
    if [[  `bc -l <<< "$amount < 0"` -eq 1 ]]; then
      reb -f $v --amount ${amount#-} --reckless --min-local 0 --min-amount 0 --fee-ppm-limit $MAX_PPM --min-remote 0
    elif [[ `bc -l <<< "$amount > 0"` -eq 1 ]]; then
      reb -t $v --amount $amount --reckless --min-local 0 --min-amount 0 --fee-ppm-limit $MAX_PPM --min-remote 0
    fi
  done
  echo -e "\nRebalance completed!\nPlease use '$FILENAME list' to see your perfectly rebalanced list :)\n"
}

for i in "$@"; do
  case "$i" in
  -m=*|--max-fee=*)
    MAX_PPM="${i#*=}"
    if ! [[ "$MAX_PPM" =~ ^[0-9]+$ ]]; then
      echo -e "Error: the MAX_PPM value should be a positive number\n"
      exit 1
    fi
    if [[ `bc -l <<< "$MAX_PPM <= 0"` -eq 1 ]]; then
      echo -e "Error: the MAX_PPM value should be greater than 0\n"
      exit 1
    fi
    shift
    ;;
  -t=*|--tolerance=*)
    TOLERANCE="${i#*=}"
    if ! [[ "$TOLERANCE" =~ ^0.[0-9]+$ ]]; then
      echo -e "Error: the TOLERANCE value should be greater than 0 and less than 1, for example 0.97\n"
      exit 1
    fi
    if [[ `bc -l <<< "$TOLERANCE <= 0 || $TOLERANCE >= 1"` -eq 1 ]]; then
      echo -e "Error: the TOLERANCE value should be greater than 0 and less tnan 1\n"
      exit 1
    fi
    shift
    ;;
  -v|--version)
    echo -e "$FILENAME v${VERSION}\n"
    exit
    ;;
  -h|--help)
    echo -e "Usage: $FILENAME {-v|-h|-m=VALUE|-t=VALUE|list|rebalance}\n"
    echo -e "Optional:"
    echo -e "\t-v, --version\n\t\tShows the version for this script\n"
    echo -e "\t-h, --help\n\t\tShows this help\n"
    echo -e "\t-i=CHANNEL_ID, --ignore=CHANNEL_ID\n\t\tIgnores a specific channel id useful only if passed before 'list' or 'rebalance'"
    echo -e "\t\tIt can be used many times and should match a number of 18 digits\n"
    echo -e "\t-m=MAX_PPM, --max-fee=MAX_PPM\n\t\t(Default: 10) Changes max fees useful only if passed before 'list' or 'rebalance'\n"
    echo -e "\t-t=TOLERANCE, --tolerance=TOLERANCE\n\t\t(Default: 0.95) Changes tolerance useful only if passed before 'rebalance'\n"
    echo -e "list:\n\tShows a list of all channels in compacted mode using 'rebalance.py -c -l'"
    echo -e "\tfor example to: '$FILENAME --tolerance=0.99 list'\n"
    echo -e "rebalance:\n\tTries to rebalance unbalanced channels with default max fee of 10 and tolerance 0.95"
    echo -e "\tfor example to: '$FILENAME --max-fee=10 --tolerance=0.98 rebalance'\n"
    exit
    ;;
  -i=*|--ignore=*)
    if ! [[ "${i#*=}" =~ ^[0-9]{18}$ ]]; then
      echo -e "Error: the IGNORE list should be channels id only, get them with '$FILENAME list'\n"
      exit 1
    fi
    IGNORE+=("${i#*=}")
    shift
    ;;
  list)
    list
    exit
    ;;
  rebalance)
    list
    rebalance
    exit
    ;;
  esac
done

if [[ $# -ne 0 ]]; then
  echo "Unknown parameter passed: $@"
fi

echo -e "Try --help or -h\n"
exit 1
