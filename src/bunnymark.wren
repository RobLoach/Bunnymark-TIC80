// title: Bunnymark in Wren
// author: Rob Loach
// desc: Benchmarking tool to see how many bunnies can fly around the screen, using Wren.
// input: gamepad
// script: wren

import "random" for Random

var ScreenWidth = 240
var ScreenHeight = 136
var ToolbarHeight = 6

class Bunny {
	construct new(rand) {
		_x = rand.int(0, ScreenWidth - Bunny.width)
		_y = rand.int(0, ScreenHeight - Bunny.height)
		_speedX = rand.float(-100, 100) / 60
		_speedY = rand.float(-100, 100) / 60
		_sprite = 1
	}

	static width {
		return 26
	}
	static height {
		return 32
	}

	draw() {
		TIC.spr(_sprite, _x, _y, 1, 1, 0, 0, 4, 4)
	}

	update() {
		_x = _x + _speedX
		_y = _y + _speedY

		if (_x + Bunny.width > ScreenWidth) {
			_x = ScreenWidth - Bunny.width
			_speedX = _speedX * - 1
		}
		if (_x < 0) {
			_x = 0
			_speedX = _speedX * -1
		}
		if (_y + Bunny.height > ScreenHeight) {
			_y = ScreenHeight - Bunny.height
			_speedY = _speedY * -1
		}

		if (_y < ToolbarHeight) {
			_y = ToolbarHeight
			_speedY = _speedY * -1
		}
	}
}

class FPS {
	construct new() {
		_value = 0
		_frames = 0
		_lastTime = -1000
	}
	getValue() {
		if (TIC.time() - _lastTime <= 1000) {
			_frames = _frames + 1
		} else {
			_value = _frames
			_frames = 0
			_lastTime = TIC.time()
		}
		return _value
	}
}

class Game is TIC {
	construct new() {
		_fps = FPS.new()
		_random = Random.new()
		_bunnies = [Bunny.new(_random)]
	}

	TIC() {
		// Input
		if (TIC.btn(0)) {
			for (i in 1...5) {
				_bunnies.add(Bunny.new(_random))
			}
		} else if (TIC.btn(1)) {
			for (i in 1...5) {
				if (_bunnies.count > 0) {
					_bunnies.removeAt(0)
				}
			}
		}

		// Update
		for (bunny in _bunnies) {
			bunny.update()
		}

		// Draw
		TIC.cls(15)
		for (bunny in _bunnies) {
			bunny.draw()
		}
		TIC.rect(0, 0, ScreenWidth, ToolbarHeight, 0)
		TIC.print("Bunnies: %(_bunnies.count)", 1, 0, 11, false, 1, false)
		TIC.print("FPS: %(_fps.getValue())", ScreenWidth / 2, 0, 11, false, 1, false)
	}
}
