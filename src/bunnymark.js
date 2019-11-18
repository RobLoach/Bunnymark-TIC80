// title: Bunnymark in JavaScript
// author: Rob Loach
// desc: Benchmarking tool to see how many bunnies can fly around the screen, using JavaScript.
// input: gamepad
// script: js

const screenWidth = 240
const screenHeight = 136
const toolbarHeight = 6

function GetRandomValue(min, max) {
  return Math.random() * (max - min) + min
}

function Bunny() {
	this.x = GetRandomValue(0, screenWidth - Bunny.width)
	this.y = GetRandomValue(0, screenHeight - Bunny.height)
	this.speedX = GetRandomValue(-100, 100) / 60
	this.speedY = GetRandomValue(-100, 100) / 60
	this.sprite = 1

	this.draw = function() {
		spr(this.sprite, this.x, this.y, 1, 1, 0, 0, 4, 4)
	}

	this.update = function() {
		this.x += this.speedX
		this.y += this.speedY

		if (this.x + Bunny.width > screenWidth) {
			this.x = screenWidth - Bunny.width
			this.speedX *= -1
		}
		if (this.x < 0) {
			this.x = 0
			this.speedX *= -1
		}
		if (this.y + Bunny.height > screenHeight) {
			this.y = screenHeight - Bunny.height
			this.speedY *= -1
		}

		if (this.y < toolbarHeight) {
			this.y = toolbarHeight
			this.speedY *= -1
		}
	}
}

Bunny.width = 26
Bunny.height = 32

function FPS() {
	this.value = 0
	this.frames = 0
	this.lastTime = -1000
	this.getValue = function() {
		if (time() - this.lastTime <= 1000) {
			this.frames = this.frames + 1
		}
		else {
			this.value = this.frames
			this.frames = 0
			this.lastTime = time()
		}
		return this.value
	}
}

const fps = new FPS()
const bunnies = []
bunnies.push(new Bunny())

function TIC() {
	// Input
	if (btn(0)) {
		for (var i = 0; i < 5; i++) {
			bunnies.push(new Bunny())
		}
	}
	else if (btn(1)) {
		for (var i = 0; i < 5; i++) {
			bunnies.pop()
		}
	}

	// Update
	for (var i in bunnies) {
		bunnies[i].update()
	}

	// Draw
	cls(15)
	for (var i in bunnies) {
		bunnies[i].draw()
	}
	rect(0, 0, screenWidth, toolbarHeight, 0)
	print("Bunnies: " + bunnies.length, 1, 0, 11, false, 1, false)
	print("FPS: " + fps.getValue(), screenWidth / 2, 0, 11, false, 1, false)
}
