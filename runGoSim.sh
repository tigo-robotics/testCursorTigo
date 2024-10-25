#!/bin/bash
#this was required on ubuntu 24.04
sudo apt-get update && sudo apt-get install -y libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libxxf86vm-dev
# 检查是否安装了 Go
if ! command -v go &> /dev/null
then
    echo "Go 未安装，请先安装 Go 环境"
    exit 1
fi

# 编译 goSimServer.go
echo "正在编译 goSimServer.go..."
go build goSimServer.go

# 检查编译是否成功
if [ $? -eq 0 ]; then
    echo "编译成功，生成了可执行文件 'goSimServer'"
    
    # 运行服务器
    echo "正在启动服务器..."
    ./goSimServer
else
    echo "编译失败"
    exit 1
fi
