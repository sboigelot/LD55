extends Reference

class_name SavableReference
func get_class(): return "SavableReference"

signal LoadingProgress(current, count)
#func get_class_path(): return get_class()

# HOW TO USE
# Exemple with AsteroidData
#	inherit SavableReference
# 	override  func get_class(): return "%class_name%"
#	save: call json = to_save_dict() on root
#   load: call from_save_dict(parse(json)) on root
#
#	assigned_citizens.append(CitizenData.new(GameEnum.PROFESSION_ID.ANDROID))
#	var d = to_save_dict()
#	print(to_json(d))
#	position = Vector2(-1,-1)
#	size=56151
#	from_save_dict(d)
#	print("pause")

func duplicate()->SavableReference:
	return unpack_save_dict(to_save_dict())

func to_save_dict()->Dictionary:
	var properties = get_property_list()
	var script_class_name = get_class()
	if script_class_name == "Anomaly/AnomalyData":
		pass
		
	var save_dict = { "class_name": script_class_name }

	for property in properties:
		var name = property["name"]
		
		if (property["usage"] != PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE and
			property["usage"] != PROPERTY_USAGE_DEFAULT and
			property["usage"] != PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue
			
		if name == "script": 
			continue
			
		if name == "rng":
			continue
			
		if name.begins_with("_"):
			continue
			
		var type = property["type"]
		var value = get(name)
		if value == null:
			continue
					
		match type:
			TYPE_COLOR:
				value = {
						"class_name": "Color",
						"r": value.r,
						"g": value.g,
						"b": value.b,
						"a": value.a
					}
			TYPE_OBJECT:
#				if value is Image:
#					value = value.data
#					print("SavableReference can not save image yet for ", name)
#					continue
#				if value is StreamTexture:
#					value = value.data
#					print("SavableReference can not save StreamTexture yet for ", name)
#					continue
				if value.has_method("to_save_dict"):
					value = value.to_save_dict()
			TYPE_ARRAY:
				var arr = []
				for item in value:
					if (typeof(item) == TYPE_OBJECT and 
						item.has_method("to_save_dict")):
						item = item.to_save_dict()
					arr.append(item)
				value = arr
			TYPE_DICTIONARY:
				var dic = {}
				for key in value:
					var item = value[key]
					if typeof(item) == TYPE_OBJECT and item.has_method("to_save_dict"):
						item = item.to_save_dict()
					dic[key] = item
				value = dic
			TYPE_VECTOR2:
				value = {
					"x": value.x,
					"y": value.y
				}
		save_dict[name] = value	
	return save_dict
	
func from_save_dict(save_dict:Dictionary):
		
	var properties = get_property_list()
	
	var property_count = properties.size()
	for index in property_count:
		var property = properties[index]
		
		emit_signal("LoadingProgress", index, property_count)
		
		var name = property["name"]
		if not save_dict.has(name):
			continue
			
		if (property["usage"] != PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE and
			property["usage"] != PROPERTY_USAGE_DEFAULT and
			property["usage"] != PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue
			
		var type = property["type"]
		var value = save_dict[name]
		
		if name == "diplomacy_mode":
			pass
					
		match type:
			TYPE_COLOR:
				if (value.has("class_name") and 
					value["class_name"] == "Color"):
					value =	Color(float(value["r"]) if "r" in value else 0.0,
							float(value["g"] if "g" in value else 0.0),
							float(value["b"] if "b" in value else 0.0),
							float(value["a"] if "a" in value else 0.0))
					self.set(name, value)
					save_dict.erase(name)
			TYPE_OBJECT:
				if value is String:
#					printerr("SavableReference can not load %s yet" % value)
					continue
				if value.has("class_name"):
					value = unpack_save_dict(value)
				self.set(name, value)
				save_dict.erase(name)
				
			TYPE_VECTOR2:
				value = Vector2(
					value["x"] if "x" in value else 0.0, 
					value["y"] if "y" in value else 0.0)
				self.set(name, value)
				save_dict.erase(name)
			TYPE_DICTIONARY:
				if value.has("class_name"):
					value = unpack_save_dict(value)
				else: 
					var dic = {}
					for key in value:	
						var item = value[key]
						if typeof(item) == TYPE_DICTIONARY and item.has("class_name"):
							item = unpack_save_dict(item)
							
						if str(int(key)) == str(key): #we only use int as dictionary key in GateBuilders
							dic[int(key)] = item
						else:
							dic[key] = item
							
					value = dic
				self.set(name, value)
				save_dict.erase(name)
			TYPE_ARRAY:
				var arr = []
				for item in value:
					if typeof(item) == TYPE_DICTIONARY and item.has("class_name"):
						item = unpack_save_dict(item)
					elif typeof(item) == TYPE_STRING:
						item = item
					elif item != null:
						item = int(item) #we only consider array of Object or array of int(ids) in GateBuilders
					arr.append(item)
				self.set(name, arr)
				save_dict.erase(name)
	
	emit_signal("LoadingProgress", property_count, property_count)
	for i in save_dict.keys():
		self.set(i, save_dict[i])

static func unpack_save_dict(save_dict):
	var classpath = "res://%s.gd" % save_dict["class_name"]
	var classitem = load(classpath).new()		
	if not classitem.has_method("from_save_dict"):
		return null	
	classitem.from_save_dict(save_dict)
	return classitem
	
