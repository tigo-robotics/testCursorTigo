#!/bin/bash

# 检查是否安装了 C 编译器 (gcc)
if ! command -v gcc &> /dev/null
then
    echo "gcc 未安装，正在安装..."
    # 根据不同的操作系统使用不同的包管理器
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install -y gcc
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y gcc
    elif [ -x "$(command -v brew)" ]; then
        brew install gcc
    else
        echo "无法自动安装 gcc。请手动安装 C 编译器。"
        exit 1
    fi
else
    echo "gcc 已安装"
fi

# 编译 main.c
if [ -f "main.c" ]; then
    echo "正在编译 main.c..."
    gcc main.c -o main
    if [ $? -eq 0 ]; then
        echo "编译成功，生成了可执行文件 'main'"
    else
        echo "编译失败"
        exit 1
    fi
else
    echo "错误：main.c 文件不存在"
    exit 1
fi
