;; title:  Bunnymark in Fennel
;; author: @RobLoach and Graham Scheaffer
;; desc:   Benchmarking tool to see how many bunnies can fly around the screen, using Fennel.
;; input: gamepad
;; script: fennel
;; version: 1.2.0

(local screen-width 240)
(local screen-height 136)
(local toolbar-height 6)
(var t 0)

(fn random-float [lower greater]
	 (+ lower (* (math.random) (- greater lower))))

(fn bunny-new [o]
	 (local bunny {
		  :width 26
		  :height 32
		  :speed-x (/ (random-float -100 100) 60)
		  :speed-y (/ (random-float -100 100) 60)
		  :sprite 1})
	 (set bunny.x (math.random 0 (- screen-width bunny.width)))
	 (set bunny.y (math.random 0 (- screen-height bunny.height)))

	 bunny)

(fn bunny-draw [self]
	 (spr self.sprite self.x self.y 1 1 0 0 4 4))

(fn bunny-update [self]
	 (set self.x (+ self.x self.speed-x))
	 (set self.y (+ self.y self.speed-y))

	 (if (> (+ self.x self.width) screen-width)
		  (do
			   (set self.x (- screen-width self.width))
			   (set self.speed-x (- self.speed-x)))
		  (< self.x 0)
		  (do
			   (set self.x 0)
			   (set self.speed-x (- self.speed-x))))

	 (if (> (+ self.y self.height) screen-height)
		  (do
			   (set self.y (- screen-height self.height))
			   (set self.speed-y (- self.speed-y)))
		  (< self.y 0)
		  (do
			   (set self.y 0)
			   (set self.speed-y (- self.speed-y)))))

(fn fps-new [] {
	 :value 0
	 :frames 0
	 :last-time 0})

(fn fps-get-value [self]
	 (if (<= (- (time) self.last-time) 1000)
		  (set self.frames (+ self.frames 1))
		  (do
			   (set self.value self.frames)
			   (set self.frames 0)
			   (set self.last-time (time))))
	 self.value)

(local fps (fps-new))
(local bunnies [(bunny-new)])


(fn tic []
	 (if (= t 0)
		  (music 0)
		  (= t (* 2 64 2.375))
		  (music 1))

	 (set t (+ t 1))

	 (if (btn 0)
		  (for [i 1 5]
			   (table.insert bunnies (bunny-new))))

	 (if (btn 1)
		  (for [i 1 5]
			   (if (> (length bunnies) 3)
					(table.remove bunnies i))))

	 (each [i item (pairs bunnies)]
		  (bunny-update item))

	 (cls 15)
	 (each [i item (pairs bunnies)]
		  (bunny-draw item))

	 (rect 0 0 screen-width toolbar-height 0)
	 (print (.. "Bunnies: " (length bunnies)) 1 0 11 false 1 false)
	 (print (.. "FPS: " (fps-get-value fps)) (/ screen-width 2) 0 11 false 1 false))

(global TIC tic)
