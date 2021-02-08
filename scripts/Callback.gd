class_name Callback
extends Reference

var target: Object
var method: String
var binds: Array

func _init(target: Object, method: String, binds: Array = []):
	self.target = target
	self.method = method
	self.binds = binds

func callback(args: Array = []):
	var arg_array = args + self.binds
	self.target.callv(self.method, arg_array)
