# ubuntu 安装
apt install -y supervisor
# 开机自启
systemctl enable supervisor
# 开始运行
systemctl start supervisor
# 查看服务状态
systemctl status supervisor
# 查看是否存在进程
ps -aux | grep supervisor
# supervisord 的配置文件默认位于 /etc/supervisord.conf
