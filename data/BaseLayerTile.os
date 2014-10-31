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

BaseLayerTile = extends BasePhysEntity {
	__construct = function(tile){
		super()
		@linkTiles = null
		@cull = true
		@tile = tile
		// @type = type
		@pos = tile.pos
		@size = Tile.SIZE
		@touchChildrenEnabled = false
	},
	
	cleanup = function(){
		@tile.game.destroyEntityPhysics(this)
		var linkTiles = @linkTiles; @linkTiles = null
		for(var _, linkTile in linkTiles){
			@tile.game.cleanupActor(linkTile)
			linkTile.detach()
		}
		@detach()
	},
	
	addLinkTile = function(tile){
		@linkTiles.indexOf(tile) && throw "link tile is already exist"
		@linkTiles || @linkTiles = []
		@linkTiles[] = tile
	},
	
	updateLinkTiles = function(){
		var pos, size = @tile.pos, Tile.SIZE
		for(var _, linkTile in @linkTiles){
			linkTile.parent !== this || throw "error link tile parent" 
			linkTile.pos = pos + size * linkTile.pivot
		}
	},
	
	__set@pos = function(value){
		super(value)
		@updateLinkTiles()
	},
	
	__set@x = function(value){
		super(value)
		@updateLinkTiles()
	},
	
	__set@y = function(value){
		super(value)
		@updateLinkTiles()
	},
	
	pickByEnt = function(ent){
	},
	
	__get@touchSprite = function(){
		return this
	},
	
	animateTouch = function(){
		// print "start animateTouch: ${@tile.tileX}-${@tile.tileY}"
		var touchSprite = @touchSprite
		"touchSaveColor" in this || @touchSaveColor = touchSprite.color
		touchSprite.replaceAction("touch", TweenAction {
			duration = 0.5,
			color = Color(1, 0.4, 0.4),
			ease = Ease.PING_PONG,
			doneCallback = function(){
				touchSprite.color = @touchSaveColor
				delete @touchSaveColor
				// print "end animateTouch: ${@tile.tileX}-${@tile.tileY}"
			},
		})
	},
	
	touch = function(){
		@animateTouch()
	},
}