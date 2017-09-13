require 'cairo'

function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)
	xsize=1850
	ysize=1350
	xoffset=500
	xi=xsize-xoffset
	
	--Set this to your home folder path
	local homeDirectory = "/home/spyware"
	local maxCPUTemp = 72 --Degrees C
	local minCPUTemp = 23
	
	--true to have the planets move representing current positions of planets.
	local solarMap = true
	-- False to disable astroid belt, true to enable.
	local solarExtras = true
	
	--Center settings used for all orbits
    local x=(xi / 2)+xoffset
    local y=ysize / 2
	
	--Planet scaling settings
	local p1r=0.383
	local p2r=0.95
	local p3r=1.0
	local p4r=0.532
	local p5r=3.1 --Was 10.97 to scale, too big.
	local p6r=2.8 -- Was 9.14 to scale, too big.
	local p7r=2.38 --originally 3.98
	local p8r=1.86 --originally 3.86
	--Radius of Earth in Pixels. Scales rest of planets
	local pEinP=18
	--Radius of Sun, center object. Will define minimum planet orbits.
	local sunRadius=3.5
	
	--Planet starting positions
	local p1p=273.524
	local p2p=142.744
	local p3p=226.644
	local p4p=51.355
	local p5p=332.996
	local p6p=274.175
	local p7p=154.424
	local p8p=197.653
	
	--Planet starting position timepoint
	local pTime = os.time{day=06, year=2017, month=08}
	
	--Planet Orbital times and units
	local p1ot = 2111.04
	local p1ou = 'h'
	local p2ot = 225.7
	local p2ou = 'd'
	local p3ot = 365.25
	local p3ou = 'd'
	local p4ot = 687
	local p4ou = 'd'
	local p5ot = 4300
	local p5ou = 'd'
	local p6ot = 11000
	local p6ou = 'd'
	local p7ot = 30790
	local p7ou = 'd'
	local p8ot = 60193.2
	local p8ou = 'd'
	
	--orbit thicknesses and settings
	local oThickness = 3
	local oGap = 5
	local maxOrbit = y-(p8r*pEinP) - oGap
	--Outer planets orbits, work from the outside in.
	local p8o=maxOrbit
	local p7o=p8o-oGap-(p8r*pEinP)-(p7r*pEinP)
	local p6o=p7o-oGap-(p7r*pEinP)-(p6r*pEinP)
	local p5o=p6o-oGap-(p6r*pEinP)-(p5r*pEinP)
	--Inner planet orbits, work from the inside out. Fill space between inner and outer with asteroids.
	local p1o=(sunRadius*pEinP)+(p1r*pEinP)+oGap+5
	local p2o=p1o+oGap+(p2r*pEinP)+(p1r*pEinP)
	local p3o=p2o+oGap+(p2r*pEinP)+(p3r*pEinP)
	local p4o=p3o+oGap+(p3r*pEinP)+(p4r*pEinP)
	local oRed = 256
	local oGreen = 256
	local oBlue = 256
	local oAlpha = 256
	local odRed=214
	local odGreen=0
	local odBlue=0
	local odAlpha=256
	
	--Label settings
	textSize = 18
	textRed = 214
	textGreen = 0
	textBlue = 0
	textAlpha = 256
	
	local xCurr = x
	local yCurr = y
	
    -- Sun ring - Used for RAM here
    val = conky_parse("${memperc}")
	drawCircle(x, y, sunRadius*pEinP, 256, 256, 112, 230)
	drawDial(x, y, sunRadius*pEinP, tonumber(val), 244, 162, 36, 256)
	--drawLabel(x, y, "RAM", val, 18, 214, 0, 0, 256)
	drawCenteredLabel(x, y, 18, val, "RAM", textRed, textGreen, textBlue, textAlpha)
	
	-- Mercury orbit - Used for CPU0 here
    val = conky_parse("${cpu cpu0}")
	drawRing(x, y, oThickness, p1o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p1o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p1o, getCurrentAngle(p1ot, p1ou, p1p, pTime))
	else
		xCurr, yCurr = x-(p1o), y
	end
		-- Mercury planet
	drawCircle(xCurr, yCurr, p1r*pEinP, 152, 152, 149, 256)
	
	-- Venus orbit - Used for CPU1 here
    val = conky_parse("${cpu cpu1}")
	drawRing(x, y, oThickness, p2o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p2o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p2o, getCurrentAngle(p2ot, p2ou, p2p, pTime))
	else
		xCurr, yCurr = x-(p2o), y
	end
		-- Venus planet
	drawCircle(xCurr, yCurr, p2r*pEinP, 221, 227, 119, 256)
		-- Swap % used
	val = conky_parse("${swapperc}")
	drawDial(xCurr, yCurr, p2r*pEinP, tonumber(val), 140, 140, 208, 256)
	
	-- Earth orbit - Used for CPU2 here
    val = conky_parse("${cpu cpu2}")
	drawRing(x, y, oThickness, p3o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p3o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p3o, getCurrentAngle(p3ot, p3ou, p3p, pTime))
	else
		xCurr, yCurr = x-(p3o), y
	end
		-- Earth planet
	drawCircle(xCurr, yCurr, p3r*pEinP, 80, 121, 235, 256)
	
	-- Mars orbit - Used for CPU3 here
    val = conky_parse("${cpu cpu3}")
	drawRing(x, y, oThickness, p4o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p4o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p4o, getCurrentAngle(p4ot, p4ou, p4p, pTime))
	else
		xCurr, yCurr = x-(p4o), y
	end
		-- Mars planet
	drawCircle(xCurr, yCurr, p4r*pEinP, 214, 0, 0, 256)
	
	--Asteroid Belt
	if solarExtras==true then
		local angle=0
		local rinc=5
		local rAst=2
		local oAst=p4o+oGap+(p4r*pEinP)
		local oAstMax=p5o-oGap-(p5r*pEinP)
		local oinc=3
		local pass=0
		while oAst<oAstMax do
			math.randomseed(oAst)
			angle = math.random(0, 4)
			rinc=math.random(7)
			while angle<360 do
				xCurr, yCurr = getXY(x, y, oAst, angle)
				r = math.random(3)
				angle=angle+rinc+r
				drawCircle(xCurr, yCurr, r, 133, 133, 133, 255)
			end
			oAst=oAst+oinc
			pass=pass+1
		end
	end
	
	-- Jupiter orbit - Used for CPU4 here
    val = conky_parse("${cpu cpu4}")
	drawRing(x, y, oThickness, p5o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p5o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p5o, getCurrentAngle(p5ot, p5ou, p5p, pTime))
	else
		xCurr, yCurr = x-(p5o), y
	end
		-- Jupiter planet
	drawCircle(xCurr, yCurr, p5r*pEinP, 199, 140, 0, 256)
	if solarExtras==true then
		drawCircle(xCurr-(.3*p5r*pEinP), yCurr+(.5*p5r*pEinP), (.5*pEinP), 200, 0, 0, 200)
	end
		-- Total CPU %
	val = tonumber(conky_parse("${cpu cpu0}"))+tonumber(conky_parse("${cpu cpu1}"))+tonumber(conky_parse("${cpu cpu2}"))+tonumber(conky_parse("${cpu cpu3}"))+tonumber(conky_parse("${cpu cpu4}"))+tonumber(conky_parse("${cpu cpu5}"))+tonumber(conky_parse("${cpu cpu6}"))+tonumber(conky_parse("${cpu cpu7}"))
	val = val/8
	drawDial(xCurr, yCurr, p5r*pEinP, val, 140, 140, 208, 256)
	drawCenteredLabel(xCurr, yCurr, 18, val, "CPU", 256, 256, 256, textAlpha)
	
	-- Saturn orbit - Used for CPU5 here
    val = conky_parse("${cpu cpu5}")
	drawRing(x, y, oThickness, p6o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p6o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p6o, getCurrentAngle(p6ot, p6ou, p6p, pTime))
	else
		xCurr, yCurr = x-p6o, y
	end
		-- Saturn planet
	if solarExtras==true then
		cairo_set_line_width(cr, oThickness*2)
		cairo_set_source_rgba(cr, oRed/256, oGreen/256, oBlue/256, oAlpha/256)
		cairo_scale(cr, .5, 1)
		cairo_arc(cr, xCurr*2, yCurr, p6r*pEinP+20, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 200/256, 100/256, 180/256)
		cairo_arc(cr, xCurr*2, yCurr, p6r*pEinP+15, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 200/256, 100/256, 180/256)
		cairo_arc(cr, xCurr*2, yCurr, p6r*pEinP+25, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_scale(cr, 2, 1)
	end
	drawCircle(xCurr, yCurr, p6r*pEinP, 215, 174, 76, 256)
	val = tonumber(conky_parse("${hwmon 1 temp 1}"))
	tempVal = (100*(val-minCPUTemp)/(maxCPUTemp-minCPUTemp))
	drawExpandingDial(xCurr, yCurr, p6r*pEinP, tempVal, 120, 120, 120, 120)
	drawCenteredTempLabel(xCurr, yCurr, 18, val, "Temp", 256, 256, 256, textAlpha)
	
	-- Uranus orbit - Used for CPU6 here
    val = conky_parse("${cpu cpu6}")
	drawRing(x, y, oThickness, p7o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p7o, tonumber(val), odRed, odGreen, odBlue, odAlpha)	
	if solarMap==true then
		xCurr, yCurr = getXY(x, y, p7o, getCurrentAngle(p7ot, p7ou, p7p, pTime))
	else
		xCurr, yCurr = x-p7o, y
	end
		-- Uranus planet - used for Home space here. Yes, Home is URANUS
	if solarExtras==true then
		cairo_set_line_width(cr, oThickness*2)
		cairo_set_source_rgba(cr, oRed/256, 100/256, oBlue/256, 120/256)
		cairo_scale(cr, .5, 1)
		cairo_arc(cr, xCurr*2, yCurr, p7r*pEinP+20, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 100/256, 200/256, 100/256)
		cairo_arc(cr, xCurr*2, yCurr, p7r*pEinP+15, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 100/256, 200/256, 100/256)
		cairo_arc(cr, xCurr*2, yCurr, p7r*pEinP+25, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_scale(cr, 2, 1)
	end
	drawCircle(xCurr, yCurr, p7r*pEinP, 0, 208, 171, 120)
	val = 100-tonumber(conky_parse("${fs_free_perc "..homeDirectory.."}"))
	drawDial(xCurr, yCurr, p7r*pEinP, val, 140, 140, 208, 256)
	drawCenteredLabel(xCurr, yCurr, 18, val, "Home", 256, 256, 256, textAlpha)
	
	
	-- Neptune orbit - Used for CPU7 here
    val = conky_parse("${cpu cpu7}")
	drawRing(x, y, oThickness, p8o, oRed, oGreen, oBlue, oAlpha)
	drawRingDial(x, y, oThickness, p8o, tonumber(val), odRed, odGreen, odBlue, odAlpha)
	if solarMap==true then 
		xCurr, yCurr = getXY(x, y, p8o, getCurrentAngle(p8ot, p8ou, p8p, pTime))
	else 
		xCurr, yCurr = x-p8o, y
	end
		-- Neptune planet
	if solarExtras==true then
		cairo_set_line_width(cr, oThickness*2)
		cairo_set_source_rgba(cr, oRed/256, oGreen/256, oBlue/256, 120/256)
		cairo_scale(cr, .5, 1)
		cairo_arc(cr, xCurr*2, yCurr, p8r*pEinP+20, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 200/256, 100/256, 100/256)
		cairo_arc(cr, xCurr*2, yCurr, p8r*pEinP+15, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_set_source_rgba(cr, 200/256, 200/256, 100/256, 100/256)
		cairo_arc(cr, xCurr*2, yCurr, p8r*pEinP+25, 0, 2*math.pi)
		cairo_stroke(cr)
		cairo_scale(cr, 2, 1)
	end
	drawCircle(xCurr, yCurr, p8r*pEinP, 0, 140, 208, 180)
		--Draw system value for Neptune. Free Boot space here
	val = 100-tonumber(conky_parse("${fs_free_perc /boot}"))
	drawDial(xCurr, yCurr, p8r*pEinP, val, 140, 140, 208, 256)
	drawCenteredLabel(xCurr, yCurr, 18, val, "Boot", 256, 256, 256, textAlpha)
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

--Returns x, y values based on an angle from left center and radius
function getXY(x, y, radius, degrees)
	local x2 = x
	local y2 = y
	if degrees>0 and degrees<90 then
		y2 = y - math.abs(math.sin(math.rad(degrees))*radius)
		x2 = x - math.abs(math.cos(math.rad(degrees))*radius)
	elseif degrees>90 and degrees<180 then
		y2 = y - math.abs(math.sin(math.rad(degrees))*radius)
		x2 = x + math.abs(math.cos(math.rad(degrees))*radius)
	elseif degrees>180 and degrees<270 then
		y2 = y + math.abs(math.sin(math.rad(degrees))*radius)
		x2 = x + math.abs(math.cos(math.rad(degrees)))*radius
	elseif degrees>270  and degrees<360 then
		y2 = y + math.abs(math.sin(math.rad(degrees))*radius)
		x2 = x - math.abs(math.cos(math.rad(degrees))*radius)
	elseif degrees==0 or degrees==360 then
		y2=y
		x2=x-radius
	elseif degrees==90 then
		y2=y-radius
		x2=x
	elseif degrees==180 then
		y2=y
		x2=x+radius
	elseif degrees==270 then
		y2=y+radius
		x2=x
	else 
		error("invalid angle")
	end
	return x2, y2
end

--Returns the angle in degrees from left center line for a constant orbitital period
function getCurrentAngle(period, periodUnit, startingAngle, startingTime)
	local degreesPerUnit=360/period
	local unit = 60*60*24 --default to days
	if periodUnit=='h' or periodUnit=='hours' then
		unit = 60*60
	elseif periodUnit=='y' or periodUnit=='years' then
		unit = 60*60*24*365.25
	elseif periodUnit=='d' or periodUnit=='days' then
		unit = 60*60*24
	else
		error("invalid periodUnit")
	end
	local unitsElapsed = os.difftime(os.time(), startingTime)/unit
	local angle = startingAngle-(degreesPerUnit*unitsElapsed)
	while angle>360 do
		angle = angle-360
	end
	while angle<0 do
		angle = angle+360
	end
	return angle
end

--Used to draw solid planets
function drawCircle(xCenter, yCenter, radius, red, green, blue, alpha)
	--Draw Background
	cairo_arc(cr, xCenter, yCenter, radius, 0, 2*math.pi)
	cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
	cairo_fill(cr)
	cairo_stroke(cr)
end

function drawDial(xCenter, yCenter, radius, value, red, green, blue, alpha)
	if value ~=0 then
		if value>100 then
			value = 100
		end
		endAngle = value*(360/100)-90
		cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
		cairo_arc(cr, xCenter, yCenter, radius, math.rad(-90), math.rad(endAngle))
		cairo_line_to(cr, xCenter, yCenter)
		cairo_fill(cr)
		cairo_stroke(cr)
	end
end

function drawExpandingDial(xCenter, yCenter, radius, value, red, green, blue, alpha)
	if value ~=0 then
		if value>100 then
			value = 100
		end
		--Testing using a ratio of area rather than radius
		value = value/100
		--size = (2*math.pi*radius*value)/(2*math.pi)
		size = math.sqrt(radius*radius*value)
		--size = value*(radius/100)
		cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
		cairo_arc(cr, xCenter, yCenter, size, 0, 2*math.pi)
		cairo_fill(cr)
		cairo_stroke(cr)
	end
end

--Draw Ring (orbit path)
function drawRing(xCenter, yCenter, thickness, radius, red, green, blue, alpha)
		cairo_set_line_width(cr, thickness)
		cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
		cairo_arc(cr, xCenter, yCenter, radius, 0, 2*math.pi)
		cairo_stroke(cr)
end

--Draw Ring indicator (orbit path)
function drawRingDial(xCenter, yCenter, thickness, radius, value, red, green, blue, alpha)
	if value ~=0 then
		if value>100 then 
			value=100 
		end
		endAngle = value*(360/100)-90
		cairo_set_line_width(cr, thickness)
		cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
		cairo_arc(cr, xCenter, yCenter, radius, math.rad(-90), math.rad(endAngle))
		cairo_stroke(cr)
	end
end

function drawLabel(x, y, label, value, fontSize, red, green, blue, alpha)
	font = "Ubuntu Mono"
	fontSlant=CAIRO_FONT_SLANT_NORMAL
	fontWeight=CAIRO_FONT_WEIGHT_BOLD
	cairo_select_font_face(cr, font, fontSlant, fontWeight)
	cairo_set_font_size(cr, fontSize)
	cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
	
	local ext = cairo_text_extents_t:create()
    tolua.takeownership(ext)
    cairo_text_extents(cr, label, extents)
    x = x - (extents.width / 2 + extents.x_bearing)
    y = y - (extents.height / 2 + extents.y_bearing) - 7
	
	cairo_move_to(cr, x, y)
	cairo_show_text(cr, label)
	cairo_stroke(cr)


    value = value .. "%"
    cairo_text_extents(cr, value, ext)
    x = x - (extents.width / 2 + extents.x_bearing)
    y = y - (extents.height / 2 + extents.y_bearing) + 7
	cairo_select_font_face(cr, font, fontSlant, fontWeight)
	cairo_set_font_size(cr, fontSize)
	cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
	cairo_move_to(cr, x, y)
	cairo_show_text(cr, value)
	cairo_stroke(cr)
end

function drawCenteredLabel(tx, ty, ts, value, label, red, green, blue, alpha)
    -- Label
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)
    cairo_text_extents(cr, label, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) - 7

    drawText(label, x, y, ts, red, green, blue, alpha)

    txt = value .. "%"
    cairo_text_extents(cr, txt, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) + 7

    drawText(txt, x, y, ts, red, green, blue, alpha)
end

function drawCenteredTempLabel(tx, ty, ts, value, label, red, green, blue, alpha)
    -- Label
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)
    cairo_text_extents(cr, label, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) - 7

    drawText(label, x, y, ts, red, green, blue, alpha)

    txt = value .. " C"
    cairo_text_extents(cr, txt, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) + 7

    drawText(txt, x, y, ts, red, green, blue, alpha)
end

function drawText(text, x, y, textSize, red, green, blue, alpha)
    font="Ubuntu Mono"
    font_slant=CAIRO_FONT_SLANT_NORMAL
    font_face=CAIRO_FONT_WEIGHT_BOLD

    cairo_select_font_face (cr, font, font_slant, font_face);
    cairo_set_font_size (cr, textSize)

    xpos, ypos= x, y
    
    cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)

    cairo_move_to(cr, xpos, ypos)
    cairo_show_text(cr, text)
    cairo_stroke(cr)
end
