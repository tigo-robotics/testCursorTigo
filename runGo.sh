#!/bin/bash

# 检查是否安装了 Go
if ! command -v go &> /dev/null
then
    echo "Go 未安装，请先安装 Go 环境"
    exit 1
fi

# 编译 goServer.go
echo "正在编译 goServer.go..."
go build goServer.go

# 检查编译是否成功
if [ $? -eq 0 ]; then
    echo "编译成功，生成了可执行文件 'goServer'"
    
    # 运行服务器
    echo "正在启动服务器..."
    ./goServer
else
    echo "编译失败"
    exit 1
fi
