docker pull jenkins/jenkins:latest

docker run --privileged -itd --name myjenkins -p 9980:8080 -p 50000:50000 -v /home/jenkins/data/jenkins_home:/var/jenkins_home jenkins/jenkins:latest

#查看初始密码 账号是 admin
#cat /var/jenkins_home/secrets/initialAdminPassword

# 插件
# pipeline 相关
# - Pipeline
# - Pipeline: Stage View
# Git Parameter