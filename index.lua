if not System.doesDirExist("ux0:/data/phoenix") then
	System.createDirectory("ux0:/data/phoenix")
end
if not System.doesDirExist("ux0:/data/phoenix/pog") then
	System.createDirectory("ux0:/data/phoenix/pog")
	save = System.openFile("ux0:/data/phoenix/pog/save0.lua", FCREATE)
	savedata = 'highscore = 0'
	System.writeFile(save, savedata, #savedata)
	System.closeFile(save)
end
math.randomseed(398630055)
red = Color.new(255, 0, 0)
meiyro = Font.load('app0:/font/meiyro.ttf')
score = 0
x = 7
y = 14
f0 = 0
f1 = 0
dofile("ux0:/data/phoenix/pog/save0.lua")
pog = Graphics.loadImage("app0:/image/pog.png")
bg = Graphics.loadImage("app0:/image/bg.png")
car = Graphics.loadImage("app0:/image/car.png")
logp = Graphics.loadImage("app0:/image/log.png")
power = Sound.open("app0:/sound/why.mp3")
music = Sound.open("app0:/sound/universal.mp3")
Sound.init()
Sound.play(power, LOOP)
Sound.play(music, LOOP)
Sound.setVolume(power, 32767)
Sound.setVolume(music, 32767)
Controls.rumble(0, 100, 100)
Controls.lockHomeButton() -- there is no escape, fuck you
dead = 0
game = 1
oldpad = Controls.read()
while (game == 1) do
	Controls.setLightbar(0, Color.new(math.random(255), math.random(255), math.random(255)))
	f0 = f0 + 1
	f1 = f1 + 1
	Graphics.initBlend()
	Screen.clear()
	Graphics.drawImage(0, 0, bg)
	log = 0
	for i = 1, 5 do
		cx = math.random(15)
		cy = math.random(5) + 8
		Graphics.drawImage(cx * 32, cy * 32, car)
		if (x == cx) or (x == cx + 1) then
			if (y == cy) then
				dead = 1
			end
		end
	end
	for i = 1, 10 do
		cx = math.random(15)
		cy = math.random(5) + 2
		Graphics.drawImage(cx * 32, cy * 32, logp)
		if (y == cy) then
			if (x == cx) or (x == cx + 1) or (x == cx + 2) then
				if (y >= 4) and (y <= 8) then
					log = 1
				end
			end
		end
	end
	if (y >= 4) and (y <= 7) and (log == 0) then
		dead = 1
	end
	Graphics.drawImage(x * 32, y * 32, pog)
	Font.print(meiyro, 240, 256, "SCORE: " .. score, red)
	Font.print(meiyro, 0, 0, "HIGHSCORE: " .. highscore, red)
	if (dead == 1) then
		if (score > highscore) then
			System.deleteFile("ux0:/data/phoenix/pog/save0.lua")
			save = System.openFile("ux0:/data/phoenix/pog/save0.lua", FCREATE)
			savedata = 'highscore = ' .. highscore
			System.writeFile(save, savedata, #savedata)
			System.closeFile(save)
		end
		score = 0
		x = 7
		y = 14
		dead = 0
	end
	pad = Controls.read()
	if (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
		x = x - 1
		Sound.playShutter(IMAGE_CAPTURE)
	end
	if (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
		x = x + 1
		Sound.playShutter(IMAGE_CAPTURE)
	end
	if (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
		y = y - 1
		Sound.playShutter(IMAGE_CAPTURE)
	end
	if (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
		y = y + 1
		Sound.playShutter(IMAGE_CAPTURE)
	end
	if (y <= 1) then
		score = score + 1
		x = 7
		y = 14
	end
	oldpad = pad
	Graphics.termBlend()
	Screen.flip()
	Screen.waitVblankStart()
end
System.exit()