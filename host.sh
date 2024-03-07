#!/bin/bash

source ./log.sh

# 设置主机名字
# $1 主机名称
SetHostName() {
  hostnamectl set-hostname "$1"
}

# 打印进程号
# $1 进程名
PsA() {
  ps -A | grep "$1" | awk '{print $1}'
}

# $1 进程名
WaitProcess() {
  wait $(PsA $1)
}
