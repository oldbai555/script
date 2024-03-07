# https://docs.gitlab.com/ee/install/docker.html
# https://docs.gitlab.com/ee/integration/jenkins.html 配合jenkins
export GITLAB_HOME=/srv/gitlab
~/.bash_profile

docker run -itd \
  -p 9980:80 \
  -p 9922:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  --privileged=true \
  gitlab/gitlab-ee:latest

# 1. 解决访问问题
# 进入容器内部
# vi /etc/gitlab/gitlab.rb

# gitlab访问地址，可以写域名。如果端口不写的话默认为80端口
# external_url 'http://192.168.226.12:9980'
# ssh主机ip
# gitlab_rails['gitlab_ssh_host'] = '192.168.226.12'
# ssh连接端口
# gitlab_rails['gitlab_shell_ssh_port'] = 9922

# 退出容器 stop && rm
# 修改这两个参数重启 run -p 9980:9980  -p 9922:9922

# 让配制生效
# gitlab-ctl reconfigure

# 修改端口
# vi /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
# gitlab-ctl restart

# 2. 修改密码
# gitlab-rails console
# u=User.where(id:1).first
# u.password='zjj123456'
# u.password_confirmation='zjj123456'
# u.save