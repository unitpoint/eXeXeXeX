#ifndef __BASE_GAME_4X_H__
#define __BASE_GAME_4X_H__

#include "oxygine-framework.h"
#include <ox-binder.h>

using namespace ObjectScript;

#define TILE_TYPE_BLOCK 255

typedef OS_BYTE TileType;
typedef OS_BYTE ItemType;

struct Tile
{
	ItemType item;
	TileType front;
	TileType back;
};

#define TILE_SIZE 128.0f

struct Tiledmap
{
	struct Size
	{
		int width, height;
	};

	struct Entity
	{
		float x, y;
		int type;
		bool player;
	};

	const Size size;
	const int floor;
	const Entity * entities;
	const int numEntities;
	const OS_BYTE * items;
	const OS_BYTE * front;
	const OS_BYTE * back;
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

	// void initMap(const char * name);

	float getTileRandom(int x, int y);

	TileType getFrontType(int x, int y);
	void setFrontType(int x, int y, TileType type);

	TileType getBackType(int x, int y);
	void setBackType(int x, int y, TileType type);

	ItemType getItemType(int x, int y);
	void setItemType(int x, int y, ItemType type);

	// Vector2 tileToCenterPos(int x, int y);
	// Vector2 tileToPos(int x, int y);
	// void posToTile(const Vector2& pos, int& x, int& y);

	void registerLevelInfo(int tiledmapWidth, int tiledmapHeight, const OS::String& front, const OS::String& back, const OS::String& items);

protected:

	Tile * tiles;
	int tiledmapWidth;	// in tiles
	int tiledmapHeight;	// in tiles
};

namespace ObjectScript {

// OS_DECL_CTYPE_ENUM(TileType);
// OS_DECL_CTYPE_ENUM(TileType);

OS_DECL_OX_CLASS(BaseGame4X);

} // namespace ObjectScript


#endif // __BASE_GAME_4X_H__
