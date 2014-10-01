#include "BaseGame4X.h"
#include "RandomValue.h"
#include "level_testmap.inc.h"

namespace ObjectScript
{

// =====================================================================

static void registerGlobals(OS * os)
{
	struct Lib {
	};

	OS::FuncDef funcs[] = {
		{}
	};

	OS::NumberDef nums[] = {
		DEF_CONST(TILE_SIZE),
		DEF_CONST(TILE_TYPE_BLOCK),
		{}
	};
	os->pushGlobals();
	os->setFuncs(funcs);
	os->setNumbers(nums);
	os->pop();
}
static bool __registerGlobals = addRegFunc(registerGlobals);

// =====================================================================

static void registerBaseGame4X(OS * os)
{
	struct Lib {
		static BaseGame4X * __newinstance()
		{
			return new BaseGame4X();
		}

		/* static int posToTile(OS * os, int params, int, int need_ret_values, void*)
		{
			OS_GET_SELF(BaseGame4X*);
			int x, y;
			Vector2 pos = ObjectScript::CtypeValue<Vector2>::getArg(os, -params+0);
			self->posToTile(pos, x, y);
			if(need_ret_values < 2){
				os->setException("two return values required");
				return 0;
			}
			os->pushNumber(x);
			os->pushNumber(y);
			return 2;
		} */

	};

	OS::FuncDef funcs[] = {
		def("__newinstance", &Lib::__newinstance),
		def("registerLevelInfo", &BaseGame4X::registerLevelInfo),
		def("getTileRandom", &BaseGame4X::getTileRandom),
		def("getFrontType", &BaseGame4X::getFrontType),
		def("setFrontType", &BaseGame4X::setFrontType),
		def("getBackType", &BaseGame4X::getBackType),
		def("setBackType", &BaseGame4X::setBackType),
		def("getItemType", &BaseGame4X::getItemType),
		def("setItemType", &BaseGame4X::setItemType),
		{}
	};
	OS::NumberDef nums[] = {
		{}
	};
	registerOXClass<BaseGame4X, Actor>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerBaseGame4X = addRegFunc(registerBaseGame4X);


} // namespace ObjectScript

// =====================================================================
// =====================================================================
// =====================================================================

/* OS2D * getOS()
{
	return ObjectScript::os;
} */

Actor * getOSChild(Actor * actor, const char * name)
{
	SaveStackSize saveStackSize;
	// OS2D * os = getOS();
	pushCtypeValue(os, actor);
	os->getProperty(name);
	return CtypeValue<Actor*>::getArg(os, -1);
}

BaseGame4X::BaseGame4X()
{
	tiles = NULL;
	tiledmapWidth = 0;
	tiledmapHeight = 0;
}

BaseGame4X::~BaseGame4X()
{
	delete [] tiles;
}

Actor * BaseGame4X::getOSChild(const char * name)
{
	return ::getOSChild(this, name);
}

float BaseGame4X::getTileRandom(int x, int y)
{
#if 1
	RandomValue r;
	r.setSeed(x ^ y ^ (x * 123456) ^ (y * 97531));
	return r.getFloat();
#else
	OS_BYTE data[] = {(OS_BYTE)x, (OS_BYTE)y};
	int hash = OS::Utils::keyToHash(data, sizeof(data));
	int hashMask = 0xff;
	return (float)(hash & hashMask) / (float)(hashMask + 1);
#endif
}

TileType BaseGame4X::getFrontType(int x, int y)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		return tiles[y * tiledmapWidth + x].front;
	}
	return TILE_TYPE_BLOCK;
}

void BaseGame4X::setFrontType(int x, int y, TileType type)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		tiles[y * tiledmapWidth + x].front = type;
	}
}

TileType BaseGame4X::getBackType(int x, int y)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		return tiles[y * tiledmapWidth + x].back;
	}
	return TILE_TYPE_BLOCK;
}

void BaseGame4X::setBackType(int x, int y, TileType type)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		tiles[y * tiledmapWidth + x].back = type;
	}
}

ItemType BaseGame4X::getItemType(int x, int y)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		return tiles[y * tiledmapWidth + x].item;
	}
	return 0;
}

void BaseGame4X::setItemType(int x, int y, ItemType type)
{
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		tiles[y * tiledmapWidth + x].item = type;
	}
}

/*
Vector2 BaseGame4X::tileToCenterPos(int x, int y)
{
	return Vector2((float)x * TILE_SIZE + TILE_SIZE/2, (float)y * TILE_SIZE + TILE_SIZE/2);
}

Vector2 BaseGame4X::tileToPos(int x, int y)
{
	return Vector2((float)x * TILE_SIZE, (float)y * TILE_SIZE);
}

void BaseGame4X::posToTile(const Vector2& pos, int& x, int& y)
{
	x = (int)(pos.x / TILE_SIZE);
	y = (int)(pos.y / TILE_SIZE);
}
*/

void BaseGame4X::registerLevelInfo(int p_tiledmapWidth, int p_tiledmapHeight, const OS::String& p_front, const OS::String& p_back, const OS::String& p_items)
{
	struct Lib
	{
		static int decode(OS_BYTE * data, int i)
		{
			int a = data[i*2] + (data[i*2+1]<<8);
			OX_ASSERT(a < 256);
			return a;
		}
	};

	delete [] tiles;
	int count = p_tiledmapWidth * p_tiledmapHeight;
	OS_BYTE * front = (OS_BYTE*)p_front.toChar();
	OS_BYTE * back = (OS_BYTE*)p_back.toChar();
	OS_BYTE * items = (OS_BYTE*)p_items.toChar();
	if(count*2 != p_front.getDataSize() || count*2 != p_back.getDataSize() || count*2 != p_items.getDataSize()){
		os->setException("error layer data size");
		tiles = NULL;
		tiledmapWidth = tiledmapHeight = 0;
		return;
	}
	tiledmapWidth = p_tiledmapWidth;
	tiledmapHeight = p_tiledmapHeight;
	tiles = new Tile[count];

	std::map<TileType, bool> usedTiles;
	std::map<ItemType, bool> usedItems;
	for(int i = 0; i < count; i++){
		tiles[i].front = (TileType)Lib::decode(front, i);
		tiles[i].back = (TileType)Lib::decode(back, i);
		tiles[i].item = (ItemType)Lib::decode(items, i);
		usedTiles[tiles[i].front] = true;
		usedTiles[tiles[i].back] = true;
		usedItems[tiles[i].item] = true;
	}
	std::map<ItemType, bool>::iterator it = usedTiles.begin();
	for(; it != usedTiles.end(); ++it){
		pushCtypeValue(os, this);
		os->getProperty(-1, "touchTileRes");
		OX_ASSERT(os->isFunction());
		pushCtypeValue(os, it->first);
		os->callTF(1);
	}
	it = usedItems.begin();
	for(; it != usedItems.end(); ++it){
		pushCtypeValue(os, this);
		os->getProperty(-1, "touchItemRes");
		OX_ASSERT(os->isFunction());
		pushCtypeValue(os, it->first);
		os->callTF(1);
	}
}

#if 0
void BaseGame4X::initMap(const char * _name)
{
	std::string name = _name;
	if(name == "testmap"){
		OX_ASSERT(!tiles);
		const Tiledmap * tiledmap = &testmapTiledmap;
		tiledmapWidth = tiledmap->size.width;
		tiledmapHeight = tiledmap->size.height;
		int count = tiledmapWidth * tiledmapHeight;
		tiles = new Tile[count];
		std::map<TileType, bool> usedTiles;
		std::map<ItemType, bool> usedItems;
		for(int i = 0; i < count; i++){
			tiles[i].item = tiledmap->items[i];
			tiles[i].front = tiledmap->front[i];
			tiles[i].back = tiledmap->back[i];
			usedTiles[tiles[i].front] = true;
			usedTiles[tiles[i].back] = true;
			usedItems[tiles[i].item] = true;
		}
		std::map<ItemType, bool>::iterator it = usedTiles.begin();
		for(; it != usedTiles.end(); ++it){
			pushCtypeValue(os, this);
			os->getProperty(-1, "touchTileRes");
			OX_ASSERT(os->isFunction());
			pushCtypeValue(os, it->first);
			os->callTF(1);
		}
		it = usedItems.begin();
		for(; it != usedItems.end(); ++it){
			pushCtypeValue(os, this);
			os->getProperty(-1, "touchItemRes");
			OX_ASSERT(os->isFunction());
			pushCtypeValue(os, it->first);
			os->callTF(1);
		}

		spActor view = getOSChild("view"); OX_ASSERT(view);
		view->setSize(Vector2(tiledmapWidth * TILE_SIZE, tiledmapHeight * TILE_SIZE));

		pushCtypeValue(os, this);
		pushCtypeValue(os, tiledmapWidth);
		os->setProperty("tiledmapWidth");
		
		pushCtypeValue(os, this);
		pushCtypeValue(os, tiledmapHeight);
		os->setProperty("tiledmapHeight");
		
		pushCtypeValue(os, this);
		pushCtypeValue(os, tiledmap->floor);
		os->setProperty("tiledmapFloor");
		
		// oldViewPos = view->getPosition() + Vector2(100, 100);
		// view->setPosition(-tileToPos(43, 14));
		for(int i = 0; i < tiledmap->numEntities; i++){
			pushCtypeValue(os, this);
			os->getProperty(-1, "addTiledmapEntity");
			OX_ASSERT(os->isFunction());
			pushCtypeValue(os, tiledmap->entities[i].x);
			pushCtypeValue(os, tiledmap->entities[i].y);
			pushCtypeValue(os, tiledmap->entities[i].type);
			pushCtypeValue(os, tiledmap->entities[i].player);
			os->callTF(4);
		}
		return;
	}
	os->setException(("level "+name+" is not found").c_str());
}
#endif

Actor * BaseGame4X::getLayer(int num)
{
	SaveStackSize saveStackSize;
	pushCtypeValue(os, this);
	os->getProperty("layers");
	pushCtypeValue(os, num);
	os->getProperty();
	return CtypeValue<Actor*>::getArg(os, -1);
}

