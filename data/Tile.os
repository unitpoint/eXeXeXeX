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

Tile = extends Object {
	VEC2_SIZE = vec2(TILE_SIZE, TILE_SIZE),
	
	__construct = function(game, tx, ty){
		super()
		@game = game
		@tileId = game.getTileId(tx, ty)
		@tileX = tx
		@tileY = ty
		// @size = vec2(TILE_SIZE, TILE_SIZE)
		@pos = game.tileToPos(tx, ty)
		@time = 0 // game.time
		
		@back = null
		@shadow = null
		// @item = null
		@front = null
		// @crack = null
		
		game.setTile(this)
		
		@frontType = game.getFrontType(tx, ty)
		// @itemType = game.getItemType(tx, ty)
		@backType = game.getBackType(tx, ty)
		
		// var elem = ELEMENTS_LIST[@frontType] || throw "unknown front type: ${@frontType}"
		// _G[elem.class || "FrontTile"](this)
		FrontTile(this)
	},
	
	cleanup = function(){
		@game.cleanupActor(@back); @back.detach()
		@game.cleanupActor(@shadow); @shadow.detach()
		// @game.cleanupActor(@item)
		@game.cleanupActor(@front); @front.detach()
	},
	
	updateShadow = function(recreate){
		if(@shadow){
			@shadow.updateShadow(recreate)
		}else{
			var shadow = ShadowTile(this)
			shadow === @shadow || throw "error init shadow"
		}
	},
	
	pickByEnt = function(ent){
		return @front.pickByEnt(ent) // || @item.pickByEnt(ent)
	},
	
	checkStartFalling = function(){
		@front.checkStartFalling()
	},
	
	
}