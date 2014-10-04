local function clamp(a){
	return a < 0 ? 0 : a > 1 ? 1 : a
}

Color = extends Object {
	__construct = function(r, g, b, a){
		@r = r || 0
		@g = g || 0
		@b = b || 0
		@a = a || 1
	},
	
	fromInt = function(value, a){
		return Color(
			((value >> 16) & 0xff) / 0xff,
			((value >> 8) & 0xff) / 0xff,
			((value >> 0) & 0xff) / 0xff,
			a
		)
	},
	
	clamp = function(){
		return Color(clamp(@r), clamp(@g), clamp(@b), clamp(@a))
	},
	
	__cmp = function(b){
		b is Color || throw "Color required"
		var i = @r <=> b.r 
		if(i != 0) return i
		i = @g <=> b.g 
		if(i != 0) return i
		i = @b <=> b.b 
		if(i != 0) return i
		return @a <=> b.a
	},
	
	__add = function(b){
		b is Color && return Color(@r + b.r, @g + b.g, @b + b.b, @a + b.a)
		b = numberOf(b) || throw "number or Color required"
		return Color(@r + b, @g + b, @b + b, @a + b)
	},
	
	__sub = function(b){
		// print "Color ${this} sub ${b}"
		b is Color && return Color(@r - b.r, @g - b.g, @b - b.b, @a - b.a)
		b = numberOf(b) || throw "number or Color required"
		return Color(@r - b, @g - b, @b - b, @a - b)
	},
	
	__mul = function(b){
		// print "Color ${this} mul ${b}"
		b is Color && return Color(@r * b.r, @g * b.g, @b * b.b, @a * b.a)
		b = numberOf(b) || throw "number or Color required"
		return Color(@r * b, @g * b, @b * b, @a * b)
	},
	
	__div = function(b){
		b is Color && return Color(@r / b.r, @g / b.g, @b / b.b, @a / b.a)
		b = numberOf(b) || throw "number or Color required"
		return Color(@r / b, @g / b, @b / b, @a / b)
	},
}

Color.RED = Color(1, 0, 0)
Color.GREEN = Color(0, 1, 0)
Color.BLUE = Color(0, 0, 1)
Color.WHITE = Color(1, 1, 1)
Color.BLACK = Color(0, 0, 0)

