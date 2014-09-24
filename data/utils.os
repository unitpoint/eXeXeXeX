function getTimeSec(){
	return DateTime.now().comtime
}

function clamp(a, min, max){
	return a < min ? min : a > max ? max : a
}

function randItem(items){
	if(arrayOf(items)){
		return items[math.random(#items)]
	}
	if(items.prototype === Object){
		var keys = items.keys
		return items[keys[math.random(#keys)]]
	}
	return items
}

function randSign(){
	return math.random()*2-1
}

function randTime(time, scale){
	if(time[0]){
		return math.random(time[0], time[1]) * (scale || 1)
	}
	return time * (1 + randSign()*0.1) * (scale || 1)
}

function extend(a, b, clone_result){
	if(b === null){
		return a.deepClone()
	}
	if(!!objectOf(b) != !!objectOf(a)){
		return b.deepClone()
	}
	if(clone_result !== false){
		a = a.deepClone()
	}
	for(var key, item in b){
		if(objectOf(item)){
			var val
			if((val = a[key]) && objectOf(val)){
				a[key] = extend(val, item, false)
			}else{
				a[key] = item.deepClone()
			}
		}else{
			a[key] = item
		}
	}
	return a
}
