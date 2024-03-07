#!/bin/bash

export $(xargs <.env)

# $1 输出文件名字 不需要后缀
# #2 需要压缩的文件夹
Tar() {
  tar -cvf "$1".tar "$2"
}

# $1 需要解压的文件
UnTar() {
  tar -xvf "$1"
}

# $1 输出文件名字 不需要后缀
# #2 需要压缩的文件夹
TarGz() {
  tar -zcvf "$1".tar.gz "$2"
}

# $1 需要解压的文件
UnTarGz() {
  tar -zxvf "$1"
}