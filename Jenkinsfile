#!/usr/bin/env groovy

def git_address = "http://192.168.226.12:9980/root/test.git" // 仓库地址
def git_auth = "ec1beedc-7d5f-4a5b-b0a3-07409a276ace" // 登陆凭证 可以在 http://{JenkinsIp:port}/manage/credentials/ 查看
def demo_name = "test"
def demo_dir = "/var/jenkins_home/myworkspace"

pipeline {
    agent any

    parameters {
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'main', name: 'BRANCH', type: 'PT_BRANCH'
    }

    stages {
        stage('1.拉取代码'){
            steps {
                 git  branch: "${params.BRANCH}", credentialsId: "${git_auth}", url: "${git_address}"
            }
        }


        stage('3.编译程序'){
            steps {
                script{
                    try {
                        sh """
                            export GOROOT=/var/jenkins_home/go/go
                            export PATH=$PATH:\$GOROOT/bin
                            go build -o ${demo_name} main.go
                            cp -rf ${demo_name} ${demo_dir}
                        """
                    } catch (err) {
                        echo "${err}"
                        throw new RuntimeException("${err}")
                    }
                }
            }
        }

        stage('4.部署程序'){
            steps {
                script{
                    try{
                        PROCESS_ID = sh(script: "ps -aux|grep ${demo_dir}/${demo_name}|grep -v grep|awk \'{print \$2}\'", returnStdout: true).trim()
                        echo "show processId ${PROCESS_ID}"

                        if (PROCESS_ID != "") {
                            echo "start kill process: ${PROCESS_ID}"
                            sh """
                                 kill -9 ${PROCESS_ID}
                               """
                            echo "end kill process: ${PROCESS_ID}"
                        }
                        echo "start deployment test"
                        sh """
                        JENKINS_NODE_COOKIE=dontKillMe nohup ${demo_dir}/${demo_name} &
                        """
                        echo "end deployment test"
                    } catch (err) {
                        echo "${err}"
                        throw new RuntimeException("${err}")
                    }
                }
            }
        }
    }

    post {
        always{
            script{
                println("流水线结束后，经常做的事情")
            }
        }

        success{
            script{
                println("流水线成功后，要做的事情")
            }

        }
        failure{
            script{
                println("流水线失败后，要做的事情")
            }
        }

        aborted{
            script{
                println("流水线取消后，要做的事情")
            }

        }
    }
}