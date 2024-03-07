#sed -i 's/\r//' .env
export $(xargs <.env)

RD="\033[31m" # 错误消息
GR="\033[32m" # 成功消息
YL="\033[33m" # 告警消息
BL="\033[36m" # 日志消息
PL='\033[0m'

INFO() {
  echo -e "${GR}[INFO]$1${PL}"
}
ERROR() {
  echo -e "${RD}[ERROR]$1${PL}"
}
WANF() {
  echo -e "${YL}[WANF]$1${PL}"
}
LOG() {
  echo -e "${BL}[LOG]$1${PL}"
}

# 打包 docker 镜像
Image() {
  INFO "start build dockerfile images by $1"
  docker build -f ${OUTPUT_DIR}/docker/$1/Dockerfile -t ${PRIVATE_REGISTRY}/$1 ${OUTPUT_DIR}
  INFO "end build dockerfile images by $1"
  INFO "start tag images by ${PRIVATE_REGISTRY}/$1:$2"
  docker tag $(docker images |grep ${PRIVATE_REGISTRY}/$1 | awk '{print $3}') ${PRIVATE_REGISTRY}/$1:$2
  INFO "end tag images by ${PRIVATE_REGISTRY}/$1:$2"
  INFO "start push images by ${PRIVATE_REGISTRY}/$1:$2"
  docker push ${PRIVATE_REGISTRY}/$1:$2
  INFO "end push images by ${PRIVATE_REGISTRY}/$1:$2"
}

# 构建文件夹
MkdirIfNotExist() {
  stat $1
  if [ $? = 1 ]; then
    mkdir -p "$1"
  fi
}

# 清除缓存
CleanCache() {
  echo -e y | docker system prune
}

# 构建运行环境
BuildRunTimeEnv() {
  docker-compose -f ../docker/docker-compose.yml up -d
}

BuildAppEnv() {
    docker-compose -f ../docker/app-docker-compose.yml up -d
}

# 打包 go 文件
GoBuild() {
  INFO "start build go app by $1"
  export GOOS=linux
  export GOARCH=amd64
  go build -o ${PACK_OUTPUT_DIR}/$1 ${OUTPUT_DIR}/service/$1/main.go
  unset GOOS
  unset GOARCH
  INFO "end build go app by $1"
}

#使用说明，用来提示输入参数
usage() {
  echo "Usage: sh docker.sh [OPTION]"
  echo "bi | buildImage [appname] [tag] 打包镜像"
  echo "be | buildEnv 构建运行环境"
  exit 1
}

case "$1" in
"bi"|"buildImage")
  docker login ccr.ccs.tencentyun.com --username=100021534606
  GoBuild $2
  Image $2 $3
  rm -rf ${PACK_OUTPUT_DIR}/$2
  ;;
"be"|"buildEnv")
  BuildRunTimeEnv
  ;;
*)
  usage
  ;;

esac