package main

import (
	"image"
	"image/color"
	"image/gif"
	"math/rand"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", serveAnimatedImage)
	println("服务器正在监听端口 7777...")
	http.ListenAndServe(":7777", nil)
}

func serveAnimatedImage(w http.ResponseWriter, r *http.Request) {
	width, height := 300, 200
	frames := 60     // 1秒的帧数
	delay := 100 / 6 // 每帧延迟时间（以10毫秒为单位）

	palette := []color.Color{
		color.White,
		color.Black,
		color.RGBA{255, 0, 0, 255},   // 红色
		color.RGBA{0, 255, 0, 255},   // 绿色
		color.RGBA{0, 0, 255, 255},   // 蓝色
		color.RGBA{255, 255, 0, 255}, // 黄色
		color.RGBA{255, 0, 255, 255}, // 紫色
		color.RGBA{0, 255, 255, 255}, // 青色
	}

	anim := gif.GIF{LoopCount: 0} // 无限循环

	for i := 0; i < frames; i++ {
		img := image.NewPaletted(image.Rect(0, 0, width, height), palette)
		for y := 0; y < height; y++ {
			for x := 0; x < width; x++ {
				img.Set(x, y, palette[rand.Intn(len(palette))])
			}
		}
		anim.Image = append(anim.Image, img)
		anim.Delay = append(anim.Delay, delay)
	}

	w.Header().Set("Content-Type", "image/gif")
	err := gif.EncodeAll(w, &anim)
	if err != nil {
		http.Error(w, "无法生成GIF图像", http.StatusInternalServerError)
		return
	}
}

func init() {
	rand.Seed(time.Now().UnixNano())
}
