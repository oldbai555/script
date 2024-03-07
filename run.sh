#!/bin/bash

# 异步执行命令 关闭当前终端不影响命令运行
Nohup() {
  nohup $1 >output.out 2>&1 &
}
