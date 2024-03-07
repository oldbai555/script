export $(xargs <.env)
source log.sh
source file.sh

supervisorDir=/home/work/pt/service
supervisorLogDir=/home/work/pt/supervisor/logs
projectRootDir=${OUTPUT_DIR}
packOutputDir=${PACK_OUTPUT_DIR}

outputSupervisorConf() {
  local programName=$1
  local outputDir=$2
  local appName=$3
  echo "[program:${programName}] ;
directory=${supervisorDir}/${programName} ;
command=${supervisorDir}/${programName}/${appName} ;
autostart=true ;
autorestart=true ;
startsecs=10 ;
startretries=3 ;
user=root ;
redirect_stderr=true ;
stdout_logfile=${supervisorLogDir}/${programName}_stdout.log ;
stdout_logfile_maxbytes=20MB ;
stdout_logfile_backups=20 ;
" >${outputDir}/${programName}.ini
}

localPackGate() {
  local programName=$1
  local outputDir=${PACK_OUTPUT_DIR}/${programName}
  MkdirIfFileUnExist ${outputDir}
  outputSupervisorConf ${programName} ${outputDir} ${programName}
  goBuild ${outputDir} ${projectRootDir}/service/${programName}
  cp -rf ${projectRootDir}/service/${programName}/application.yaml ${outputDir}
  cd ${packOutputDir} && tar -cvf ${programName}.tar ${programName}
}

localPackServer() {
  local appName=$1
  local outputDir=${PACK_OUTPUT_DIR}/${appName}
  MkdirIfFileUnExist ${outputDir}
  outputSupervisorConf ${appName} ${outputDir} cmd
  goBuild ${outputDir}/cmd ${projectRootDir}/service/${appName}server/cmd
  cp -rf ${projectRootDir}/service/${appName}server/cmd/application.yaml ${outputDir}
  cd ${packOutputDir} && tar -cvf ${appName}.tar ${appName}
}

local_pkg_to_supervisor() {
  local appName=$1
  MkdirIfFileUnExist ${supervisorDir}
  MkdirIfFileUnExist ${supervisorLogDir}
  chmod +x -R ${supervisorLogDir}
  cd ${supervisorDir}
  rm -rf ${appName}
  tar -xvf ${appName}.tar
  chmod +x -R ${appName}
  cp -rf ${supervisorDir}/${appName}/${appName}.ini /etc/supervisord.d
  supervisorctl update
  supervisorctl restart ${appName}
  supervisorctl status ${appName}
}

# 打包 go 文件
goBuild() {
  INFO "start build go app by $1"
  export GOOS=linux
  export GOARCH=amd64
  go build -o $1 $2
  unset GOOS
  unset GOARCH
  INFO "end build go app by $1"
}

#使用说明，用来提示输入参数
usage() {
  echo "Usage: sh supervisor.sh [OPTION]"
  echo "lpg | localPackGate 本地: 网关"
  echo "lps | localPackServer 本地: 服务"
  exit 1
}

case "$1" in
"lpg" | "localPackGate")
  localPackGate $2
  cp -rf $2.tar ${supervisorDir}
  local_pkg_to_supervisor $2
  ;;
"lps" | "localPackServer")
  localPackServer $2
  cp -rf $2.tar ${supervisorDir}
  local_pkg_to_supervisor $2
  ;;
*)
  usage
  ;;

esac
rm -rf ${packOutputDir}
