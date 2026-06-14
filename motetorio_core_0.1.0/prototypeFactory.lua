-- Contains many helper functions for creating brand new recipes, items, technologies, and tiles.

local modName = "__williams-tweaks__"
local spaceAge = "__space-age__"
local defaultIconSizeDefine = defines.default_icon_size

local pf = {}
-- hidden wrapper function for getting categories from raw.
function raw(category)
	return data.raw[category]
end

-- wrapper for deepcopy function
function pf.clone(original)
	original = original or {}
	return table.deepcopy(original)
end

-- clones any base thing from any category of data.raw
function pf.cloneRaw(category,original)
	return pf.clone(raw(category)[original])
end

-- gets a clone of the the crafting_machine_tint of a recipe
function pf.getTint(recipe)
	return pf.clone(recipes[recipe].crafting_machine_tint)
end

--[[ Depreciated
function pf.getTimeAndCount(item)
	local count = 1
	local recipe = raw("recipe")[item]
	for _,result in ipairs(recipe.results) do
		if result.name == item then
			count = result.amount
		end
	end
	return recipe.energy_required, count
end
]]

--[[
	Constructs a new recipe prototype.
	string name					name of the recipe
	array icons					icons for the recipe (use pf.iconFactory or pf.makeCastingIcon)
	array ingredients			ingredients for the recipe (use pf.ingredientsFactory)
	array results				results for the recipe (use pf.resultsFactory)
	double energy_required		crafting time for the recipe
	string category				category of the recipie, determining main production building
	table otherKeys				optional table of other properties for the recipe 
]]
function pf.recipeFactory(name, icons, ingredients, results, energy_required, category, otherKeys)
	recipe = {type = "recipe"}
	recipe.name = name
	recipe.icons = icons
	recipe.ingredients = ingredients
	recipe.results = results
	recipe.energy_required = energy_required
	recipe.category = category

	otherKeys = otherKeys or {}
	for key,value in pairs(otherKeys) do
		recipe[key] = value
	end
	return recipe
end

--[[
	Takes in two ordered arrays. itemIngredients = {itemName, amount}, fluidIngredients = {fluidName, amount}. Arrays can be nil if there are no ingredients of that type.
	Amount must be specified for fluids, but is optional for items (default = 1).
	all properties can also be specified by key name:
		name
		amount
		temperature
		minimum_temperature and maximum_temperature (if temperature not specified)
		ignored_by_stats
		fluidbox_index
		fluidbox_multiplier
]]
function pf.ingredientsFactory(itemIngredients, fluidIngredients)
	ingredientsFormatted = {}
	if itemIngredients ~= nil then
		for i,item in ipairs(itemIngredients) do
			table.insert(ingredientsFormatted, {
				type = "item",
				name = item.name or item[1],
				amount = item.amount or item[2] or 1,
				ignored_by_stats = item.ignored_by_stats or 0
			})
		end
	end
	if fluidIngredients ~= nil then
		for i,fluid in ipairs(fluidIngredients) do
			table.insert(ingredientsFormatted, {
				type = "fluid",
				name = fluid.name or fluid[1],
				amount = fluid.amount or fluid[2],
				temperature = fluid.temperature,
				minimum_temperature = fluid.minimum_temperature,
				maximum_temperature = fluid.maximum_temperature,
				ignored_by_stats = fluid.ignored_by_stats,
				fluidbox_index = fluid.fluidbox_index,
				fluidbox_multiplier = fluid.fluidbox_multiplier
			})
		end
	end
	return ingredientsFormatted
end

--[[
	Takes in two ordered arrays. itemResults = {{itemName, amount},...}, fluidResults = {{fluidName, amount},...}. Arrays can be nil if there are no results of that type.
	Also accepts all other keys by name, with some commonly used keys having a alternative shorthand key:
		name
		amount
		amount_min (aka "min")
		amount_max (aka "max")
		probability (aka "p")
		ignored_by_productivity (aka "ignore_prod")
		ignored_by_stats
		temperature
		fluidbox_index
		show_details_in_recipe_tooltip
		extra_count_fraction
		percent_spoiled
]]
function pf.resultsFactory(itemResults, fluidResults)
	resultsFormatted = {}
	if itemResults ~= nil then
		for i,item in ipairs(itemResults) do
			table.insert(resultsFormatted, {
				type = "item",
				name = item.name or item[1],
				amount = item.amount or item[2],
				amount_min = item.amount_min or item.min,
				amount_max = item.amount_max or item.max,
				probability = item.probability or item.p,
				ignored_by_stats = item.ignored_by_stats,
				ignored_by_productivity = item.ignored_by_productivity or item.ignore_prod,
				show_details_in_recipe_tooltip = item.show_details_in_recipe_tooltip,
				extra_count_fraction = item.extra_count_fraction,
				percent_spoiled = item.percent_spoiled
			})
		end
	end
	if fluidResults ~= nil then
		for i,fluid in ipairs(fluidResults) do
			table.insert(resultsFormatted, {
				type = "fluid",
				name = fluid.name or fluid[0],
				amount = fluid.amount or fluid[1],
				amount_min = fluid.amount_min or fluid.min,
				amount_max = fluid.amount_max or fluid.max,
				probability = fluid.probability or fluid.p,
				ignored_by_stats = fluid.ignored_by_stats,
				ignored_by_productivity = fluid.ignored_by_productivity or fluid.ignore_prod,
				temperature = fluid.temperature,
				fluidbox_index = fluid.fluidbox_index,
				show_details_in_recipe_tooltip = fluid.show_details_in_recipe_tooltip,
			})
		end
	end
	return resultsFormatted
end


--[[
	Takes in either a string path to a 64px icon file, or takes in an array of icons layers.
	Each icon layer can be either a standard factorio icon definition or can be an ordered array: {iconPath, shift, scale, tint}
]]
function pf.iconFactory(icons)
	iconList = {}
	if type(icons) == type("string") then -- if given only a string to the icon location
		iconList = {icon = icons}
	elseif type(icons) == type({}) then -- if given an array of layers
		for i,layer in ipairs(icons) do
			table.insert(iconList, {
				icon = layer.icon or layer[1],
				shift = layer.shift or layer[2],
				scale = layer.scale or layer[3],
				tint = layer.tint or layer[4],
				icon_size = layer.icon_size,
				draw_background = layer.draw_background,
				floating = layer.floating
			})
		end
	end
	return iconList
end

--[[
	Constructs a new item prototype
	string name					name of the item
	int stackSize				items per stack
	array/string icons			icons for the item. (Use pf.iconFactory)
	string subgroup				subgroup of the item, for ordering on the GUI.
	table pfs					table with keys "placement", "fuel", or "spoilage". Use appropriate helper to generate
		table placement				placement details, use pf.placementHelper to generate
		table fuel					fuel details, use pf.fuelHelper to generate
		table spoilage				spoilage details, use pf.spoilageHelper to generate
	table otherKeys				optional table of other properties for the item 
]]
function pf.itemFactory(name, stackSize, icons, subgroup, pfs, otherKeys)
	item = {type = "item"}
	item.name = name
	item.stack_size = stackSize
	item.icons = icons
	pfs = pfs or {}

	if pfs.placement ~= nil and pfs.placement.type ~= nil then
		item[placement.type] = pfs.placement.result
	end

	if pfs.fuel ~= nil then
		for key,value in pairs(pfs.fuel) do
			item[key] = value
		end
	end

	if pfs.spoilage ~= nil then
		for key,value in pairs(pfs.spoilage) do
			item[key] = value
		end
	end

	for key,value in pairs(otherKeys) do
		item[key] = value
	end

	return item
end

--[[
	Helper function for pf.itemFactory. Defines placement of entities and tiles from items.
	string type					"building", "equipment", "plant", or "tile"
	string id					id of entity to place
	array placeAsTileStruct		tile placement struct, unused if type ~= "tile".
		array tile_condition		Specific Tiles it CAN be placed on. Can be the only argument at placeAsTileStruct[1]	
		dict layers					Collision layers it CANNOT be placed on (e.g. landfill cannot be placed upon ground_tile). Defaults to {layers = {}}.
										https://lua-api.factorio.com/latest/types/CollisionMaskConnector.html
		bool invert					defaults to false
		int condition_size			defaults to 1
]]
function pf.placementHelper(type, id, placeAsTileStruct)
	placeKey = ""
	result = id
	if type == "building" then placeKey = "place_result"
	elseif type == "equipment" then placeKey = "place_as_equipment_result"
	elseif type == "plant" then placeKey = "plant_result"
	elseif type == "tile" then 
		placeKey = "place_as_tile"
		result = {
			result = id,
			condition = {layers = placeAsTileStruct.layers or {}}, -- Collision layers it CANNOT be placed on (e.g. landfill cannot be placed upon ground_tile)
			invert = placeAsTileStruct.invert or false,
			condition_size = placeAsTileStruct.condition_size or 1,
			tile_condition = placeAsTileStruct.tile_condition or placeAsTileStruct[1] -- Specific Tiles it CAN be placed on
		}
	end
	return {["type"] = placeKey, ["result"] = result}
end

--[[
	Helper function for pf.itemFactory. Defines the fuel value of items.
	str value			value of the fuel, such as "12MJ". https://lua-api.factorio.com/latest/types/Energy.html
	str category		fuel category, defaults to "chemical" if omitted.
	table otherKeys		other optional keys and values to assign for fuels.
		fuel_acceleration_multiplier
		fuel_top_speed_multiplier
		fuel_emissions_multiplier
		fuel_acceleration_multiplier_quality_bonus
		fuel_top_speed_multiplier_quality_bonus
		fuel_glow_color
]]
function pf.fuelHelper(value, category, otherKeys)
	fuel = {}
	fuel.fuel_value = value
	fuel.fuel_category = category or "chemical"
	otherKeys = otherKeys or {}
	for key,value in otherKeys do
		fuel[key] = value
	end
	return fuel
end

--[[
	Helper function for pf.itemFactory. Defines spoilage properties.
	str result			item resulting from the spoilage
	int seconds			seconds for item to spoil. Is multiplied by 60 when saved as game ticks.
	int level			Optional spoil level of items. Inserters consider higher spoil_level items to be more spoiled regardless of actual percentage spoiled.
	table trigger		Optional. https://lua-api.factorio.com/latest/types/SpoilToTriggerResult.html
]]
function pf.spoilageHelper(result, seconds, level, trigger)
	spoilage = {
		spoil_result = result,
		spoil_ticks = seconds * 60,
		spoil_level = level or 0,
		spoil_to_trigger_result = trigger
	}
	return spoilage
end


--[[
	Constructs a new fluid prototype
	string name					name of the fluid
	array/string icons			icons for the fluid; can accept the string address of a single 64px icon or an array of simple icon layers. Calls pf.iconFactory for formatting.
	float default_temperature	temperature of the fluid. defaults to 15.
	color base_color			an array of {r,g,b} or {r,g,b,a}. Defaults to {1,1,1}.
	color flow_color
	table otherKeys				Optional. Any other keys and values to use.
]]
function pf.fluidFactory(name, icons, default_temperature, base_color, flow_color, otherKeys)
	fluid = {type = "fluid"}
	fluid.name = name
	fluid.icons = pf.iconFactory(icons)
	fluid.default_temperature = default_temperature or 15
	fluid.base_color = base_color or {1,1,1}
	fluid.flow_color = flow_color or {1,1,1}
	otherKeys = otherKeys or {}
	for key,value in pairs(otherKeys) do
		fluid[key] = value
	end
	return fluid
end


--[[
	Constructs a new technology prototype
	string name					name of the technology
	array/string icons			icons for the technology; can accept the string address of a single 64px icon or an array of simple icon layers. Calls pf.iconFactory for formatting.
	bool essential				sets whether the technology is marked as essential.
	table unlockCondition		the unlock condition of the technology. Use pf.unlockHelper.
	array prerequisites			a list of prerequisite technologies.
	array effects				a list of the technology's effects

]]
function pf.technologyFactory(name, icons, essential, unlockCondition, prerequisites, effects)
	tech = {type = "technology"}
	tech.name = name
	tech.icons = pf.iconFactory(icons)
	tech.essential = essential
	tech.research_trigger = unlockCondition.research_trigger
	tech.unit = unlockCondition.unit
	tech.prerequisites = prerequisites
	tech.effects = effects
	return tech
end


--[[
	Helper method for constructing a technology trigger.
	string type						"unit" or type of technology trigger.
	string/table triggerItemID		string of trigger item name, or ItemIDFilter. Only required for type ~= "unit". https://lua-api.factorio.com/latest/types/ItemIDFilter.html
	int count						number of research cycles (if unit) or items (if trigger)
	array packs						list of science packs name strings (such as {"automation-science-pack"}). Only required for type == "unit".
	int seconds						duration in seconds a unit of technology research takes. Only required for type == "unit".
	table otherKeys					Optional other keys. Only required for type == "scripted".
]]
function pf.unlockHelper(type, triggerItemID, count, packs, seconds, otherKeys)
	if type == "unit" then
		unit = {
			["time"] = seconds, 
			["count"] = count
		}
		ingredients = {}
			for i,pack in ipairs(packs) do
				table.insert(ingredients, {pack, 1})
			end
		unit.ingredients = ingredients
		unit.count_formula = otherKeys.count_formula
		return {["unit"] = unit}
	else
		trigger = {["type"] = type}
		if type == "mine-entity" or type == "capture-spawner" or type == "build-entity" then
			trigger.entity = triggerItemID
		elseif type == "craft-item" then
			trigger.item = triggerItemID
			trigger.count = count or 1
		elseif type == "craft-fluid" then
			trigger.fluid = triggerItemID
			trigger.amount = count
		elseif type == "send-item-to-orbit" then
			trigger.item = triggerItemID
		else
			otherKeys = otherKeys or {}
			for key,value in pairs(otherKeys) do
				trigger[key] = value
			end
		end
		return {["research_trigger"] = trigger}
	end
end

--[[
	Helper function. wrapper for unlock-recipe type technology effects
]]
function pf.recipeEffect(recipeID)
	return {type = "unlock-recipe", recipe = recipeID}
end

--[[
	comlpetely hides a recipe in game without deleting its prototype
]]
function pf.hideMe(recipeOrItem)
	recipeOrItem.hidden = true
	recipeOrItem.hidden_in_factoriopedia = true
	if recipeOrItem.type == "recipe" then
		recipeOrItem.hide_from_signal_gui = true
		recipeOrItem.hide_from_player_crafting = true
	end
end

--stolen from more-casting mod
--retrieves the specific prototype of a thing without needing to know its specific subtype
--for example, it can get a science pack (a "tool") when given the base type ("item")
function pf.getPrototype(base_type, name)
    for type_name in pairs(defines.prototypes[base_type]) do
        local prototypes = data.raw[type_name]

        if prototypes and prototypes[name] then
            return prototypes[name]
        end
    end
end

function pf.getLocalisedName(name)
	local item = pf.getPrototype("item",name)

	if not item then return end -- skip non-items.
	if item.localised_name then -- if it has a localised_name defined, return that.
        return item.localised_name
    end

	local prototype
    local type_name = "item"

    if item.place_result then
        prototype =  pf.getPrototype("entity", item.place_result)
        type_name = "entity"
    elseif item.place_as_equipment_result then
        prototype =  pf.getPrototype("equipment", item.place_as_equipment_result)
        type_name = "equipment"
    elseif item.place_as_tile then
        -- Tiles with variations don't have a localised name
        local tile_prototype = data.raw.tile[item.place_as_tile.result]
        if tile_prototype and tile_prototype.localised_name then
            prototype = tile_prototype
            type_name = "tile"
        end
    end

    return prototype and prototype.localised_name or { type_name .. "-name." .. name }

end

return pf