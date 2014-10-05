/******************************************************************************
* Copyright (C) 2014 Evgeniy Golovin (evgeniy.golovin@unitpoint.ru)
*
* Please feel free to contact me at anytime, 
* my email is evgeniy.golovin@unitpoint.ru, skype: egolovin
*
* eXeXeXeX is a 4X genre of strategy-based video game in which player 
* "eXplore, eXpand, eXploit, and eXterminate" the world
* 
* Latest source code
*	eXeXeXeX: https://github.com/unitpoint/eXeXeXeX
* 	OS2D engine: https://github.com/unitpoint/os2d
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/

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
