#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  echo "usage: glog.sh <options> <keyword>"
  echo "<options>"
  echo "-t 默认当前年月日时"
  echo "-t [前x小时]"
  echo "-t [指定日小时 例如 0114]"
  echo "-t [指定月日小时 例如 120114]"
  exit 1
fi

D=
args=("$@")
args_filter=()
LOG=
LOGDIR=/tmp/lb/log/

for ((i = 0; i < ${#args[@]}; i++)); do
  if [[ "${args[$i]}" == "-t" ]]; then
    n=$(($i + 1))
    D="${args[$n]}"
    i=$(($i + 1))
  else
    args_filter[${#args_filter[@]}]="${args[$i]}"
  fi
done

if [[ "$D" == "" ]]; then
  D="0"
fi

if [ $D -eq "0" ]; then
  LOG=$(date "+%Y%m%d%H")".log"
elif [ ${#D} -eq 1 ]; then
  LOG=$(date -d "-${D} hour" +%Y%m%d%H)".log"
elif [ ${#D} -eq 2 ]; then
  LOG=$(date -d "-${D} hour" +%Y%m%d%H)".log"
elif [ ${#D} -eq 3 ]; then
  D=0$D
  LOG=$(date "+%Y%m")$D".log"
elif [ ${#D} -eq 4 ]; then
  LOG=$(date "+%Y%m")$D".log"
elif [ ${#D} -eq 5 ]; then
  D=0$D
  LOG=$(date "+%Y")$D".log"
elif [ ${#D} -eq 6 ]; then
  LOG=$(date "+%Y")$D".log"
fi

LOG=$LOGDIR"*"$LOG
LOG=${LOG//\\/\/}
NLOG=$(ls $LOG | wc -l)
if [ $NLOG -eq 0 ]; then
  echo
  echo "file $LOG not existed, stop"
  echo
  exit 1
fi

echo
echo "exec \"cat $LOG | grep -a ${args_filter[*]}\""
echo
cat $LOG | grep -a "${args_filter[@]}" | sort -k3
