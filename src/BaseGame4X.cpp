#include "BaseGame4X.h"
#include "RandomValue.h"
#include "level_testmap.inc"

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
		// tile types
		DEF_CONST(TILE_EMPTY),
		DEF_CONST(TILE_GRASS),
		DEF_CONST(TILE_CHERNOZEM),
		DEF_CONST(TILE_STONE),
		DEF_CONST(TILE_LADDERS),
		DEF_CONST(TILE_BLOCK),
		// layres
		DEF_CONST(LAYER_TILES),
		DEF_CONST(LAYER_MONSTERS),
		DEF_CONST(LAYER_PLAYER),
		DEF_CONST(LAYER_DECALS),
		DEF_CONST(LAYER_COUNT),
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
		def("initMap", &BaseGame4X::initMap),
		def("getTileRandom", &BaseGame4X::getTileRandom),
		def("getTileType", &BaseGame4X::getTileType),
		def("setTileType", &BaseGame4X::setTileType),
		// def("tileToCenterPos", &BaseGame4X::tileToCenterPos),
		// def("tileToPos", &BaseGame4X::tileToPos),
		// {"posToTile", &Lib::posToTile},
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
	tiledmap = NULL;
	map = NULL;
}

BaseGame4X::~BaseGame4X()
{
	delete [] map;
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

ETile BaseGame4X::getTileType(int x, int y)
{
	if(x >= 0 && x < tiledmap->size.width
		&& y >= 0 && y < tiledmap->size.height)
	{
		return map[y * tiledmap->size.width + x];
	}
	return TILE_BLOCK;
}

void BaseGame4X::setTileType(int x, int y, ETile type)
{
	if(x >= 0 && x < tiledmap->size.width
		&& y >= 0 && y < tiledmap->size.height)
	{
		map[y * tiledmap->size.width + x] = type;
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

void BaseGame4X::initMap(const char * _name)
{
	std::string name = _name;
	if(name == "testmap"){
		view = getOSChild("view"); OX_ASSERT(view);
		
		tiledmap = &testmapTiledmap;

		int count = tiledmap->size.width * tiledmap->size.height;
		map = new ETile[count];
		for(int i = 0; i < count; i++){
			switch(tiledmap->map[i]){
			case 255:	map[i] = TILE_EMPTY; break;
			case 0:		map[i] = TILE_GRASS; break;
			case 8:		map[i] = TILE_CHERNOZEM; break;
			case 9:		map[i] = TILE_STONE; break;
			case 16:	map[i] = TILE_LADDERS; break;
			default:
				OX_ASSERT(false);
			}
		}

		view->setSize(Vector2(tiledmap->size.width * TILE_SIZE, tiledmap->size.height * TILE_SIZE));

		pushCtypeValue(os, this);
		pushCtypeValue(os, (char*)"tiledmapWidth");
		pushCtypeValue(os, tiledmap->size.width);
		os->setProperty();
		
		pushCtypeValue(os, this);
		pushCtypeValue(os, (char*)"tiledmapHeight");
		pushCtypeValue(os, tiledmap->size.height);
		os->setProperty();
		
		// oldViewPos = view->getPosition() + Vector2(100, 100);
		// view->setPosition(-tileToPos(43, 14));

		for(int i = 0; i < tiledmap->numEntities; i++){
			pushCtypeValue(os, this);
			os->getProperty(-1, "addTilemapEntity");
			OX_ASSERT(os->isFunction());
			pushCtypeValue(os, tiledmap->entities[i].x);
			pushCtypeValue(os, tiledmap->entities[i].y);
			pushCtypeValue(os, tiledmap->entities[i].type);
			os->callTF(3);
		}
		return;
	}
	os->setException(("level "+name+" is not found").c_str());
}

Actor * BaseGame4X::getLayer(int num)
{
	OX_ASSERT(num >= 0 && num < LAYER_COUNT);
	SaveStackSize saveStackSize;
	pushCtypeValue(os, this);
	os->getProperty("layers");
	pushCtypeValue(os, num);
	os->getProperty();
	return CtypeValue<Actor*>::getArg(os, -1);
}

