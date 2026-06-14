utils = require("utils")
merge = utils.merge
pf = require("prototypeFactory")

-- Variables for getting art assets
graphicsPath = "__motetorio_core__/graphics/"
iconPath = graphicsPath .. "icons/"

local elementList = {"air","water","earth","fire","life","shadow"}
local nonElementList = {"hybrid","entropy","salt","space"}
local planeKeys = {"enemy","tile","dedcorative_entity"}
local mainKeys = {"technology","recipe","item","building"}

-- A master list of everything created by this mod.
-- Everything should be read-only by the time it gets here.
prototypeDirectory = {} 

-- Loop through merged element + non-element lists
	-- require all mainKeys, add to prototypeDirectory["<item>"]["<key>"] = require("prototypes.<item>.<key>")
-- Loop through element list only
	-- require all planeKeys, add to prototypeDirectory in the same way

--[[ Only enable once all the files are created

for _,item in ipairs(merge{elementList,nonElementList}) do
	for _,mainKey in ipairs(mainKeys) do
		prototypeDirectory[item] = {}
		prototypeDirectory[item][mainKey] = require("prototypes." .. item .. "." .. item .. "_" .. mainKey)
	end
end
for _,item in ipairs(elementList) do
	for _,planeKey in ipairs(planeKeys) do
		prototypeDirectory[item] = {}
		prototypeDirectory[item][planeKey] = require("prototypes." .. item .. "." .. item .. "_" .. planeKey)
	end
end
]]
prototypeDirectory["space"] = {}-- Temp
prototypeDirectory["space"]["asteroid"] = require("prototypes.space.asteroid")
prototypeDirectory["space"]["space-location"] = require("prototypes.space.space-location")