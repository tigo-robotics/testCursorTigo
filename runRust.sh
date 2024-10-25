#!/bin/bash
# 检查是否安装了 Rust
if ! command -v rustc &> /dev/null
then
    echo "Rust 未安装，正在安装 Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    echo "Rust 安装完成"
else
    echo "Rust 已安装"
fi

# 编译并运行名为 rustSimServer 的 Rust 程序

# 检查 rustSimServer.rs 文件是否存在
if [ ! -f "rustSimServer.rs" ]; then
    echo "错误：rustSimServer.rs 文件不存在"
    exit 1
fi

# 编译 Rust 程序
echo "正在编译 rustSimServer..."
rustc rustSimServer.rs

# 检查编译是否成功
if [ $? -ne 0 ]; then
    echo "编译失败"
    exit 1
fi

# 运行编译后的程序
echo "正在运行 rustSimServer..."
./rustSimServer

# 清理编译生成的可执行文件
rm rustSimServer
