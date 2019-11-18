// title: Bunnymark in Squirrel
// author: Rob Loach
// desc: Benchmarking tool to see how many bunnies can fly around the screen, using Squirrel.
// input: gamepad
// script: squirrel

local ScreenWidth = 240;
local ScreenHeight = 136;
local ToolbarHeight = 6;

function rndfloat(max) {
    local roll = 1.0 * max * rand() / RAND_MAX;
    return roll;
}

function rndint(max) {
    local roll = 1.0 * max * rand() / RAND_MAX;
    return roll.tointeger();
}

class Bunny {
	static width = 26;
	static height = 32;

	x = 0;
	y = 0;
	speedX = 0;
	speedY = 0;
	sprite = 1;

	constructor() {
		x = rndint(ScreenWidth - 26);
		y = rndint(ScreenHeight - 32);
		speedX = (rndfloat(200) - 100) / 60;
		speedY = (rndfloat(200) - 100) / 60;
	}

	function draw() {
		spr(sprite, x, y, 1, 1, 0, 0, 4, 4);
	}

	function update() {
		x = x + speedX;
		y = y + speedY;

		if (x + width > ScreenWidth) {
			x = ScreenWidth - width;
			speedX = speedX * - 1;
		}
		if (x < 0) {
			x = 0;
			speedX = speedX * -1;
		}
		if (y + height > ScreenHeight) {
			y = ScreenHeight - height;
			speedY = speedY * -1;
		}

		if (y < ToolbarHeight) {
			y = ToolbarHeight;
			speedY = speedY * -1;
		}
	}
}

class FPS {
	fps = 0;
	frames = 0;
	lastTime = -1000;

	function getValue() {
		if (time() - lastTime <= 1000) {
			frames = frames + 1;
		} else {
			fps = frames;
			frames = 0;
			lastTime = time();
		}
		return fps;
	}
}

local fps = FPS();
local bunnies = [Bunny()];

function TIC() {
	// Input
	if (btn(0)) {
		for (local i = 0; i < 5; i += 1) {
			bunnies.push(Bunny());
		}
	} else if (btn(1)) {
		for (local i = 0; i < 5; i += 1) {
			if (bunnies.len() > 0) {
				bunnies.remove(0);
			}
		}
	}

	// Update
	foreach (i,bunny in bunnies) {
		bunny.update();
	}

	// Draw
	cls(15)
	foreach (i,bunny in bunnies) {
		bunny.draw();
	}
	rect(0, 0, ScreenWidth, ToolbarHeight, 0);
	print("Bunnies: " + bunnies.len().tostring(), 1, 0, 11, false, 1, false);
	print("FPS: " + fps.getValue().tostring(), ScreenWidth / 2, 0, 11, false, 1, false);
}
