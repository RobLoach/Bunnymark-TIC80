all: js moon wren squirrel

js:
	tic80 --fs="." --cmd "load dist/bunnymark-js.tic & import code src/bunnymark.js & import sprites sprites.png"

moon:
	tic80 --fs="." --cmd "load dist/bunnymark-moon.tic & import code src/bunnymark.moon & import sprites sprites.png"

wren:
	tic80 --fs="." --cmd "load dist/bunnymark-wren.tic & import codesrc/bunnymark.wren & import sprites sprites.png"

squirrel:
	tic80 --fs="." --cmd "load dist/bunnymark-squirrel.tic & import code src/bunnymark.nut & import sprites sprites.png"

lua:
	tic80 --fs="." --cmd "load dist/bunnymark-lua.tic & import code src/bunnymark.lua & import sprites sprites.png"
