#!/bin/bash

# 下载文件
CurlOutput() {
  #  如果需要认证
  #  curl -u "username:password" -LO $1
  curl -LO "$1"
}