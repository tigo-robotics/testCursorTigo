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
