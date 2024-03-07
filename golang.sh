#!/bin/bash

source ./log.sh
source ./host.sh

BuildLinux() {
  # 构建Linux版本
  export GOOS=linux
  export GOARCH=amd64

  go build -o $1 $2

  unset GOOS
  unset GOARCH
}

BuildWindows() {
  # 构建Windows版本
  export GOOS=windows
  export GOARCH=amd64

  go build -o $1 $2

  unset GOOS
  unset GOARCH
}

# 调试golang服务
# $1 进程名
DlvSvr() {
  if [ ! $(command -v go) ]; then
    ERROR "golang  未安装"
    exit 1
  fi
  if [ ! $(command -v dlv) ]; then
    INFO "正在安装dlv"
    go install github.com/go-delve/delve/cmd/dlv@master
    INFO "dlv 安装完成 请将 dlv 放入 /usr/bin/ 目录下"
    exit 0
  fi
  # --注意 $1 是 启动 go进程的 id   2345 是服务监听的端口 这里写哪个端口 goland 中就要配置哪个端口，其他参数可以通过 执行 dlv 查看帮助信息
  dlv attach $(PsA $1) --headless --listen=:2345 --api-version=2 --accept-multiclient
}

# 启动 go 程序, 出现 panic 时输出日志文件
GoStart() {
  nohup env GOTRACEBACK=crash $1 -dev true >/dev/null 2>crash.panic.log &
}
