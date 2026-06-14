-- All Space Locations

-- Create master list of space locations and space connections.
local spaceLocationNames = {"elemental-nexus","entropic-vortex","life","earth","fire","shadow","air","water"}
local prefix = "mote-"
local function name(plane)
	return prefix .. plane .. "-plane"
end

local nexusDistance = 12
local systemScale = 5
local nexusAngle = 240
local vortexOffset = 3

local nexusName = prefix .. "elemental-nexus"
local vortexName = prefix .. "entropic-vortex"


local nexus = {
	name = nexusName,
	type = "space-location",
	orbit = {
		parent = {
			name = "star",
			type = "space-location"
		},
		distance = nexusDistance,
		orientation = nexusAngle/360
	},
	is_satellite = false,
	gravity_pull = 1,
	magnitude = .5,
	-- parked_platforms_orientation = ???
	-- label_orientation = ??
	draw_orbit = false,
	solar_power_in_space = 450,
	icon = iconPath .. "MoteMancer_LogoIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "MoteMancer_Logo.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}
PlanetsLib:extend({nexus})


local vortex = {
	name = vortexName,
	type = "space-location",
	orbit = {
		parent = {
			name = nexusName,
			type = "space-location"
		},
		distance = systemScale + vortexOffset,
		orientation = nexusAngle/360
	},
	is_satellite = true,
	gravity_pull = 1,
	magnitude = .75,
	-- parked_platforms_orientation = ???
	label_orientation = .45,
	draw_orbit = false,
	solar_power_in_space = 300,
	icon = iconPath .. "EntropicHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "EntropicHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}
PlanetsLib:extend({vortex})

local startingPlane = settings.startup["starting-plane"].value
local orientationIndex = 1
if startingPlane == "earth" then orientationIndex = 2
elseif startingPlane == "fire" then orientationIndex = 3
elseif startingPlane == "shadow" then orientationIndex = 4
elseif startingPlane == "air" then orientationIndex = 5
elseif startingPlane == "fire" then orientationIndex = 6 end


local function gravityToPressure(gravity, botEnergy)
	return gravity * 100 * (1/botEnergy)
end

-- Relative position in the system
local orientations = {
	life = (30 + 60*(2 - orientationIndex)),
	earth = (30 + 60*(3 - orientationIndex)),
	fire = (30 + 60*(4 - orientationIndex)),
	shadow = (30 + 60*(5 - orientationIndex)),
	air = (30 + 60*(6 - orientationIndex)),
	water = (30 + 60*(7 - orientationIndex)),
}
-- Solar power {space, surface}
local solarStrength = {
	life = {720,600},
	earth = {500,300},
	water = {500,300},
	air = {300,60},
	fire = {300,60},
	shadow = {60,0}
}

local life = {
	name = name("life"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["life"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	player_effects = pf.clone(data.raw['planet']['gleba'].player_effects), -- Controls the weather particles
	ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['gleba'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["life"][2],
		["gravity"] = 24,
		["pressure"] = gravityToPressure(24,6/6),
		[prefix.."vitality"] = 6,
		[prefix.."aqueousness"] = 4,
		[prefix.."tempestuousness"] = 2,
		[prefix.."gloom"] = 0,
		[prefix.."incandescence"] = 2,
		[prefix.."rigidity"] = 4,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["life"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["life"][1],
	icon = iconPath .. "LifeHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "LifeHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}

local earth = {
	name = name("earth"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["earth"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	--player_effects = pf.clone(data.raw['planet']['fulgora'].player_effects), -- Controls the weather particles
	ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['fulgora'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["earth"][2],
		["gravity"] = 48,
		["pressure"] = gravityToPressure(48,8/6),
		[prefix.."vitality"] = 4,
		[prefix.."aqueousness"] = 2,
		[prefix.."tempestuousness"] = 0,
		[prefix.."gloom"] = 2,
		[prefix.."incandescence"] = 4,
		[prefix.."rigidity"] = 6,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["earth"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["earth"][1],
	icon = iconPath .. "EarthHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "EarthHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}

local fire = {
	name = name("fire"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["fire"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	--player_effects = pf.clone(data.raw['planet']['vulcanus'].player_effects), -- Controls the weather particles
	--ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['vulcanus'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["fire"][2],
		["gravity"] = 24,
		["pressure"] = gravityToPressure(24,6/6),
		[prefix.."vitality"] = 2,
		[prefix.."aqueousness"] = 0,
		[prefix.."tempestuousness"] = 2,
		[prefix.."gloom"] = 4,
		[prefix.."incandescence"] = 6,
		[prefix.."rigidity"] = 4,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["fire"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["fire"][1],
	icon = iconPath .. "FireHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "FireHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}

local water = {
	name = name("water"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["water"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	--player_effects = pf.clone(data.raw['planet']['vulcanus'].player_effects), -- Controls the weather particles
	--ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['vulcanus'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["water"][2],
		["gravity"] = 12,
		["pressure"] = gravityToPressure(12,4/6),
		[prefix.."vitality"] = 4,
		[prefix.."aqueousness"] = 6,
		[prefix.."tempestuousness"] = 4,
		[prefix.."gloom"] = 2,
		[prefix.."incandescence"] = 0,
		[prefix.."rigidity"] = 2,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["water"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["water"][1],
	icon = iconPath .. "WaterHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "WaterHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}

local shadow = {
	name = name("shadow"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["shadow"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	--player_effects = pf.clone(data.raw['planet']['vulcanus'].player_effects), -- Controls the weather particles
	--ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['vulcanus'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["shadow"][2],
		["gravity"] = 12,
		["pressure"] = gravityToPressure(12,4/6),
		[prefix.."vitality"] = 0,
		[prefix.."aqueousness"] = 2,
		[prefix.."tempestuousness"] = 4,
		[prefix.."gloom"] = 6,
		[prefix.."incandescence"] = 4,
		[prefix.."rigidity"] = 2,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["shadow"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["shadow"][1],
	icon = iconPath .. "ShadowHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "ShadowHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}

local air = {
	name = name("air"),
	type = "planet",
	orbit = {
		parent = {
			name = vortexName,
			type = "space-location"
		},
		distance = systemScale,
		orientation = orientations["air"]/360,
	},
	is_satellite = true,
	entities_require_heating = false,
	pollutant_type = prefix .. "entropy",
	-- persistent_ambient_sounds = ???
	-- surface_render_parameters = ???
	--player_effects = pf.clone(data.raw['planet']['vulcanus'].player_effects), -- Controls the weather particles
	--ticks_between_player_effects = 1,
	map_gen_settings = pf.clone(data.raw['planet']['vulcanus'].map_gen_settings),
	surface_properties = {
		["day-night-cycle"] = 6 * 3600,
		["solar-power"] = solarStrength["air"][2],
		["gravity"] = 6,
		["pressure"] = gravityToPressure(6,2/6),
		[prefix.."vitality"] = 2,
		[prefix.."aqueousness"] = 4,
		[prefix.."tempestuousness"] = 6,
		[prefix.."gloom"] = 4,
		[prefix.."incandescence"] = 2,
		[prefix.."rigidity"] = 0,
		[prefix.."entropic-influence"] = 3600,
	},
	gravity_pull = 10,
	magnitude = 1,
	-- parked_platforms_orientation = ???
	label_orientation = orientations["air"]/360,
	draw_orbit = false,
	solar_power_in_space = solarStrength["air"][1],
	icon = iconPath .. "AirHexIcon.png",
	icon_size = 64,
	starmap_icon = graphicsPath .. "AirHex.png",
	starmap_icon_size = 1024,
	starmap_icon_orientation = 0,
	--asteroid_spawn_influence = ??
	--asteroid_spawn_definitions = ??
}
PlanetsLib:extend({life,earth,fire,water,shadow,air})


data:extend({
	{
		type = "airborne-pollutant",
		name = prefix .. "entropy",
		chart_color = {.3,.3,.3},
		icon = table.deepcopy(data.raw['airborne-pollutant']['pollution'].icon),
		affects_evolution = true,
		affects_water_tint = false,
		damages_trees = true
	},
	{ -- Life
		type = "surface-property",
		name = prefix.."vitality",
		default_value = 3,
		order = "m[motetorio]-a[vitality]",
	},
	{ -- Water
		type = "surface-property",
		name = prefix.."aqueousness",
		default_value = 3,
		order = "m[motetorio]-a[aqueousness]",
	},
	{ -- Air
		type = "surface-property",
		name = prefix.."tempestuousness",
		default_value = 3,
		order = "m[motetorio]-a[tempestuousness]",
	},
	{ -- Shadow
		type = "surface-property",
		name = prefix.."gloom",
		default_value = 3,
		order = "m[motetorio]-a[gloom]",
	},
	{ -- Fire
		type = "surface-property",
		name = prefix.."incandescence",
		default_value = 3,
		order = "m[motetorio]-a[incandescence]",
	},
	{ -- Earth
		type = "surface-property",
		name = prefix.."rigidity",
		default_value = 3,
		order = "m[motetorio]-a[rigidity]",
	},
	{ -- Entropy
		type = "surface-property",
		name = prefix.."entropic-influence",
		default_value = 0,
		order = "m[motetorio]-b[entropic-influence]",
	},
})

local standardConnectionPairs = {
	{"air","water"},
	{"water","life"},
	{"life","earth"},
	{"earth","fire"},
	{"fire","shadow"},
	{"shadow","air"},
	{"water","entropic-vortex"},
	{"life","entropic-vortex"},
	{"earth","entropic-vortex"},
	{"fire","entropic-vortex"},
	{"shadow","entropic-vortex"},
	{"air","entropic-vortex"},
	{"elemental-nexus","nauvis"},
	{"elemental-nexus","vulcanus"},
	{"elemental-nexus","fulgora"},
}
--	{startingPlane,"elemental-nexus"},
local connectionPrototypes = {}

for _,linkPair in ipairs(standardConnectionPairs) do
	local routeFrom = ""
	if linkPair[1] == "elemental-nexus" then
		routeFrom = nexusName
	else
		routeFrom = name(linkPair[1])
	end
	local routeTo = ""
	if linkPair[2] == "entropic-vortex" then
		routeTo = vortexName
	elseif linkPair[2] ~= "nauvis" and linkPair[2] ~= "vulcanus" and linkPair[2] ~= "fulgora" then
		routeTo = name(linkPair[2])
	else
		routeTo = linkPair[2]
	end
	local routeIcon = iconPath .. linkPair[1] .. "-" .. linkPair[2] .. "-SpaceRoute.png"
	local routeLength = linkPair[1] == "elemental-nexus" and 30000 or 6000

	routeLength = routeLength + (linkPair[2] == "fulgora" and 5000 or 0)

	table.insert(connectionPrototypes, {
		type = "space-connection",
		name = prefix .. linkPair[1] .. "-" .. linkPair[2],
		from = routeFrom,
		to = routeTo,
		length = routeLength,
		icon = routeIcon,
		icon_size = 64
	})
end

table.insert(connectionPrototypes, {
	type = "space-connection",
	name = "first-plane-elemental-nexus",
	from = name(startingPlane),
	to = nexusName,
	length = 12000,
	icon = iconPath .. startingPlane .. "-elemental-nexus-SpaceRoute.png",
	icon_size = 64
})

data:extend(connectionPrototypes)

-- Return a cloned reference list for later use, pulled from data.raw after PlanetsLib does its magic.
local allSpaceLocations = {}
--[[
for _,location in ipairs(spaceLocationNames) do
	allSpaceLocations[name] = pf.clone(
		data.raw['space-location'][prefix .. location] or
		data.raw['planet'][name(location)]
	)
end
]]
return allSpaceLocations