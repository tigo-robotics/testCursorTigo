#!/bin/bash

# 检查是否安装了 OpenCV
if ! pkg-config --exists opencv4; then
    echo "OpenCV 未安装，正在安装..."
    sudo apt-get update
    sudo apt-get install -y libopencv-dev
else
    echo "OpenCV 已安装"
fi

# 创建 C 文件
cat << EOF > opencv_camera.c
#include <opencv2/opencv.hpp>
#include <stdio.h>

int main() {
    cv::VideoCapture cap(0);
    if (!cap.isOpened()) {
        printf("无法打开摄像头\n");
        return -1;
    }

    cv::Mat frame;
    cv::namedWindow("摄像头", cv::WINDOW_AUTOSIZE);

    while (true) {
        cap >> frame;
        if (frame.empty()) break;

        cv::imshow("摄像头", frame);

        if (cv::waitKey(30) >= 0) break;
    }

    return 0;
}
EOF

# 编译 C 文件
echo "正在编译 opencv_camera.c..."
g++ opencv_camera.c -o opencv_camera `pkg-config --cflags --libs opencv4`

# 检查编译是否成功
if [ $? -eq 0 ]; then
    echo "编译成功，生成了可执行文件 'opencv_camera'"
    
    # 运行程序
    echo "正在启动摄像头程序..."
    ./opencv_camera
else
    echo "编译失败"
    exit 1
fi
