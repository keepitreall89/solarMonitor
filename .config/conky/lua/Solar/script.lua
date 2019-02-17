require 'cairo'

function angulo( graus )
    radianos = (graus - 90) * (math.pi/180)
    return radianos
end

function rgb( r, g, b )
    red = r/255
    green = g/255
    blue = b/255

    return red, green, blue
end

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


function indicador_arco(x, y, tx, ty, ts, value, r, w, label, red, green, blue, backr, backg, backb, tred, tgreen, tblue)
    --SETTINGS
    --rings size
    ring_center_x=x
    ring_center_y=y

    ring_radius=r
    ring_width=w

    --colors
    --set background colors
    ring_bg_red, ring_bg_green, ring_bg_blue=backr/255, backg/255, backb/255
    ring_bg_alpha=1

    --set indicator colors
    ring_in_red=red/255
    ring_in_green=green/255
    ring_in_blue=blue/255
    ring_in_alpha=1

    --indicator value settings
    max_value=100

    --draw background
    cairo_set_line_width (cr,ring_width)
    cairo_set_source_rgba (cr,ring_bg_red,ring_bg_green,ring_bg_blue,ring_bg_alpha)
    cairo_arc (cr,ring_center_x,ring_center_y,ring_radius,0,2*math.pi)
    cairo_stroke (cr)

    cairo_set_line_width (cr,ring_width)
    start_angle = angulo(0)
    end_angle=angulo( value*(360/max_value) )

    --print (end_angle)
    cairo_set_source_rgba (cr,ring_in_red,ring_in_green,ring_in_blue,ring_in_alpha)
    cairo_arc (cr,ring_center_x,ring_center_y,ring_radius,start_angle,end_angle)
    cairo_stroke (cr)

    -- Label
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)
    cairo_text_extents(cr, label, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) - 7

    texto(label, x, y, ts, tred/255, tgreen/255, tblue/255)

    txt = value .. "%"
    cairo_text_extents(cr, txt, extents)
    x = tx - (extents.width / 2 + extents.x_bearing)
    y = ty - (extents.height / 2 + extents.y_bearing) + 7

    texto(txt, x, y, ts, tred/255, tgreen/255, tblue/255)
end

function texto(txt, x, y, tSize, r, g, b)
    font="Ubuntu Mono"
    font_size=tSize
    font_slant=CAIRO_FONT_SLANT_NORMAL
    font_face=CAIRO_FONT_WEIGHT_BOLD

    cairo_select_font_face (cr, font, font_slant, font_face);
    cairo_set_font_size (cr, font_size)

    text=txt
    xpos,ypos=x,y
    red,green,blue = r,g,b
    alpha=1
    cairo_set_source_rgba (cr,red,green,blue,alpha)

    cairo_move_to (cr,xpos,ypos)
    cairo_show_text (cr,text)
    cairo_stroke (cr)
end


--Used to draw solid planets
function drawCircle(xCenter, yCenter, radius, red, green, blue, alpha)
	--Draw Background
	cairo_arc(cr, xCenter, yCenter, radius, 0, 2*math.pi)
	cairo_set_source_rgba(cr, red/256, green/256, blue/256, alpha/256)
	cairo_fill(cr)
	cairo_stroke(cr)
--	if not value ==0 then
--		endAngle = value*(360/100)
--		cairo_set_source_rgba(cr, dialRed/256, dialGreen/256, dialBlue/256, dialAlpha/256)
--		cairo_arc(cr, xCenter, yCenter, radius, 0, endAngle)
--		cairo_stroke(cr)
--	end
end

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
	--Radius of the Sun (center object) Experimenting with scaling all measurements off that. 
	rSun=45
	rEarth=4
	solarMap = True
	
	--Center settings used for all orbits
    local x=(xi / 2)+xoffset
    local y=ysize / 2
	
	--Planet scaling settings
	local p1r=0.383
	local p2r=0.95
	local p3r=1.0
	local p4r=0.532
	local p5r=3.67 --Was 10.97 to scale, too big.
	local p6r=3.14 -- Was 9.14 to scale, too big.
	local p7r=2.38 --originally 3.98
	local p8r=1.86 --originally 3.86
	
	local pEinP=18
	
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
	
	
	
	
    -- Sun ring - Used for RAM here
    val = tonumber(conky_parse("${memperc}"))
    drawCircle(x, y, rSun, 255, 255, 112, 256)
    indicador_arco(x, y, x, y, 18, val, rSun, rSun, "RAM", 244, 162, 36, 255, 255, 112, 214, 0, 0)
	
	-- Mercury orbit - Used for CPU0 here
    val = conky_parse("${cpu cpu0}")
    indicador_arco(x, y, x, y-85, 20, val, rSun+60, 3, "CPU0", 214, 0, 0, 255, 255, 255, 152, 152, 149)
	--if solarMap==False then
		--drawCircle(x-(rSun+60), y, 10, 152, 152, 149, 256)
	if solarMap==True then
		angle = getCurrentAngle(p1ot, p1ou, p1p, pTime)
		if angle>75 and angle<105 then
			tempAlpha=115
		else
			tempAlpha=256
		end
		xCurr, yCurr = getXY(x, y, rSun+60, angle)
		drawCircle(xCurr, yCurr, p1r*pEinP, 152, 152, 149, tempAlpha)
	end
	
	-- Venus orbit - Used for CPU1 here
    val = conky_parse("${cpu cpu1}")
    indicador_arco(x, y, x, y-145, 20, val, rSun+120, 3, "CPU1", 214, 0, 0, 255, 255, 255, 221, 227, 119)
	--drawCircle(x-(rSun+120), y, 15, 221, 227, 119, 256)
	if solarMap==True then
		angle = getCurrentAngle(p2ot, p2ou, p2p, pTime)
		if angle>75 and angle<105 then
			tempAlpha=115
		else
			tempAlpha=256
		end
		xCurr, yCurr = getXY(x, y, rSun+120, angle)
		--xCurr, yCurr = getXY(x, y, rSun+120, 90)
		drawCircle(xCurr, yCurr, p2r*pEinP, 221, 227, 119, tempAlpha)
	end
	
	-- Earth orbit - Used for CPU2 here
    val = conky_parse("${cpu cpu2}")
    indicador_arco(x, y, x, y-205, 20, val, rSun+180, 3, "CPU2", 214, 0, 0, 255, 255, 255, 80, 121, 235)
	--drawCircle(x-(rSun+180), y, 18, 80, 121, 235, 256)
	if solarMap==True then
		angle=getCurrentAngle(p3ot, p3ou, p3p, pTime)
		if angle>75 and angle<105 then
			tempAlpha=115
		else
			tempAlpha=256
		end
		xCurr, yCurr = getXY(x, y, rSun+180, angle)
		drawCircle(xCurr, yCurr, p3r*pEinP, 80, 121, 235, tempAlpha)
	end
	
	-- Mars orbit - Used for CPU3 here
    val = conky_parse("${cpu cpu3}")
    indicador_arco(x, y, x, y-265, 20, val, rSun+240, 3, "CPU3", 214, 0, 0, 255, 255, 255, 214, 0, 0)
	--drawCircle(x-(rSun+240), y, 15, 214, 0, 0, 256)
	if solarMap==True then
		angle=getCurrentAngle(p4ot, p4ou, p4p, pTime)
		if angle>75 and angle<105 then
			tempAlpha=115
		else
			tempAlpha=256
		end
		xCurr, yCurr = getXY(x, y, rSun+240, angle)
		drawCircle(xCurr, yCurr, p4r*pEinP, 214, 0, 0, tempAlpha)
	end
	
	
	--Asteroid Belt
	if solarMap==True then
		local angle=0
		local rinc=5
		local rAst=2
		local oAst=rSun+270
		local oAstMax=rSun+280
		local oinc=3
		local pass=0
		while oAst<oAstMax do
			angle = 0+pass
			while angle<360 do
				xCurr, yCurr = getXY(x, y, oAst, angle)
				angle=angle+rinc
				drawCircle(xCurr, yCurr, rAst, 255, 255, 255, 255)
			end
			rinc=rinc+rinc/2
			oAst=oAst+oinc
			pass=pass+1
		end
	end
	
	-- Jupiter orbit - Used for CPU4 here
    rn=y-275
    val = conky_parse("${cpu cpu4}")
    indicador_arco(x, y, x, y-(rn-25), 20, val, rn, 3, "CPU4", 214, 0, 0, 255, 255, 255, 199, 140, 0)
	--drawCircle(x-(rn), y, 40, 199, 140, 0, 256)
	if solarMap==True then
		xCurr, yCurr = getXY(x, y, rn, getCurrentAngle(p5ot, p5ou, p5p, pTime))
		drawCircle(xCurr, yCurr, p5r*pEinP, 199, 140, 0, 256)
	end
	
	-- Saturn orbit - Used for CPU5 here
    rn=y-165
    val = conky_parse("${cpu cpu5}")
    indicador_arco(x, y, x, y-(rn-25), 20, val, rn, 3, "CPU5", 214, 0, 0, 255, 255, 255, 215, 174, 76)
	-- Saturn planet - Used for Home here
--    val = 100-tonumber(conky_parse("${fs_free_perc /home/spyware}"))
--    indicador_arco(x-rn, y, x-(rn+40), y-40, 20, val, 4.5*rEarth, (4.5*rEarth)+15, "Home", 215, 250, 176, 215, 174, 76, 215, 174, 76)
	if solarMap==True then
		xCurr, yCurr = getXY(x, y, rn, getCurrentAngle(p6ot, p6ou, p6p, pTime))
		drawCircle(xCurr, yCurr, p6r*pEinP, 215, 174, 76, 256)
	end
	
	-- Uranus orbit - Used for CPU6 here
	rn=y-65
    val = conky_parse("${cpu cpu6}")
    indicador_arco(x, y, x, y-(rn-25), 20, val, rn, 3, "CPU6", 214, 0, 0, 255, 255, 255, 0, 208, 171)
	-- Uranus planet - Used for SWAP here
--    val = conky_parse("${swapperc}")
--    indicador_arco(x-rn, y, x-(rn+25), y-40, 20, val, 3.5*rEarth, (3.5*rEarth)+5, "SWAP", 150, 208, 171, 0, 208, 171, 0, 208, 171)
	if solarMap==True then
		xCurr, yCurr = getXY(x, y, rn, getCurrentAngle(p7ot, p7ou, p7p, pTime))
		drawCircle(xCurr, yCurr, p7r*pEinP, 0, 208, 171, 256)
	end
	
	-- Neptune orbit - Used for CPU7 here
	rn=y-5
    val = conky_parse("${cpu cpu7}")
    indicador_arco(x, y, x, y-(rn-25), 20, val, rn, 3, "CPU7", 214, 0, 0, 255, 255, 255, 0, 140, 208)
		-- Neptune planet - Used for Boot here
--    val = 100-tonumber(conky_parse("${fs_free_perc /boot}"))
--    indicador_arco(x-rn, y, x-(rn+25), y-40, 20, val, 3*rEarth, (3*rEarth)+5, "Boot",  0, 208, 208, 0, 140, 208, 0, 140, 208)
	if solarMap==True then 
		xCurr, yCurr = getXY(x, y, rn, getCurrentAngle(p8ot, p8ou, p8p, pTime))
		drawCircle(xCurr, yCurr, p8r*pEinP, 0, 140, 208, 256)
	end


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end