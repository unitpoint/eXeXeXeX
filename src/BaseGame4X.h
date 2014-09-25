#ifndef __BASE_GAME_4X_H__
#define __BASE_GAME_4X_H__

#include "oxygine-framework.h"
#include <ox-binder.h>

using namespace ObjectScript;

enum ETile
{
	TILE_EMPTY,
	TILE_GRASS,
	TILE_CHERNOZEM,
	TILE_STAIRS,
	TILE_BLOCK,
};

enum ELayer
{
	LAYER_TILES,
	LAYER_MONSTERS,
	LAYER_PLAYER,
	// LAYER_LIGHT_DARK,
	LAYER_COUNT
};

#define TILE_SIZE 128.0f

struct Tiledmap
{
	struct Size
	{
		unsigned char width, height;
	};

	struct Entity
	{
		unsigned char x, y, type;
	};

	const Size size;
	const Entity * entities;
	const int numEntities;
	const unsigned char * map;
};

// OS2D * getOS();
Actor * getOSChild(Actor*, const char * name);

DECLARE_SMART(BaseGame4X, spBaseGame4X);
class BaseGame4X: public Actor
{
public:
	OS_DECLARE_CLASSINFO(BaseGame4X);

	BaseGame4X();
	~BaseGame4X();

	Actor * getOSChild(const char * name);
	Actor * getLayer(int num);

	void initMap(const char * name);

	float getTileRandom(int x, int y);
	ETile getTileType(int x, int y);

	// Vector2 tileToCenterPos(int x, int y);
	// Vector2 tileToPos(int x, int y);
	// void posToTile(const Vector2& pos, int& x, int& y);

protected:

	const Tiledmap * tiledmap;
	spActor view;

	// Vector2 oldViewPos;
};

namespace ObjectScript {

OS_DECL_CTYPE_ENUM(ETile);

OS_DECL_OX_CLASS(BaseGame4X);

} // namespace ObjectScript


#endif // __BASE_GAME_4X_H__
