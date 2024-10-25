package main

import (
	"image"
	"image/color"
	"image/draw"
	"math/rand"
	"net/http"
	"time"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/hajimehoshi/ebiten/v2/ebitenutil"
)

const (
	screenWidth  = 640
	screenHeight = 480
	frameRate    = 30
)

type Game struct {
	noise *image.RGBA
}

func (g *Game) Update() error {
	// 每帧更新噪声图像
	for y := 0; y < screenHeight; y++ {
		for x := 0; x < screenWidth; x++ {
			c := color.RGBA{
				uint8(rand.Intn(256)),
				uint8(rand.Intn(256)),
				uint8(rand.Intn(256)),
				255,
			}
			g.noise.Set(x, y, c)
		}
	}
	return nil
}

func (g *Game) Draw(screen *ebiten.Image) {
	draw.Draw(screen, screen.Bounds(), g.noise, image.Point{}, draw.Src)
	ebitenutil.DebugPrint(screen, "噪声视频")
}

func (g *Game) Layout(outsideWidth, outsideHeight int) (int, int) {
	return screenWidth, screenHeight
}

func main() {
	rand.Seed(time.Now().UnixNano())

	game := &Game{
		noise: image.NewRGBA(image.Rect(0, 0, screenWidth, screenHeight)),
	}

	ebiten.SetWindowSize(screenWidth, screenHeight)
	ebiten.SetWindowTitle("随机噪声视频")

	go func() {
		http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "text/html")
			w.Write([]byte(`
				<!DOCTYPE html>
				<html>
				<head>
					<title>随机噪声视频</title>
				</head>
				<body>
					<h1>随机噪声视频</h1>
					<p>请运行程序查看噪声视频。</p>
				</body>
				</html>
			`))
		})
		http.ListenAndServe(":8080", nil)
	}()

	if err := ebiten.RunGame(game); err != nil {
		panic(err)
	}
}
