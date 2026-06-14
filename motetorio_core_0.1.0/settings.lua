-- settings can be accessed by using settings.startup["setting-name"].value
data:extend({
	{
		type = "string-setting",
		name = "starting-plane",
		setting_type = "startup",
		default_value = "life",
		allowed_values = {"air","earth","fire","life","shadow","water"}
	},
})