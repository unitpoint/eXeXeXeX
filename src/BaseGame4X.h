#ifndef __BASE_GAME_4X_H__
#define __BASE_GAME_4X_H__

#include <oxygine-framework.h>
#include <core/gl/ShaderProgramGL.h>
#include <ox-binder.h>
#include "MathLib.h"

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
#define LEVEL_BIN_DATA_PREFIX "level-layers:front:back:items."

#define TILE_TYPE_EMPTY		0
#define TILE_TYPE_LIGHT_ROCK_01 2
#define TILE_TYPE_LIGHT_ROCK_02 3
#define TILE_TYPE_DOOR_01	16
#define TILE_TYPE_LADDERS	17
#define TILE_TYPE_TRADE_STOCK	24

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

struct LightFormInfo
{
	OS::String form; // "light-02"
	vec3 shadowColor;
	float tileRadiusScale;

	LightFormInfo(const OS::String& _form, const vec3& _shadowColor, float _tileRadiusScale):
		form(_form), shadowColor(_shadowColor)
	{
		tileRadiusScale = _tileRadiusScale;
	}
};

struct LightInfo
{
	vec2 pos;
	float tileRadius;
	vec3 color;
	LightFormInfo lightForm;

	LightInfo(const vec2& _pos, float _tileRadius, const vec3& _color, const LightFormInfo& _lightForm): 
		pos(_pos), tileRadius(_tileRadius), color(_color), lightForm(_lightForm)
	{
	}
};

DECLARE_SMART(BaseLight, spBaseLight);
class BaseLight: public Object
{
public:
	OS_DECLARE_CLASSINFO(BaseLight);

	std::string name;
	Color shadowColor;
	// float tileRadiusScale;

	vec2 pos;
	Color color;
	float radius;

	vec2 validPos;
	// bool isLevelLights;

	BaseLight()
	{
		shadowColor = Color(127, 127, 127, 255);
		// tileRadiusScale = 1.0f;
		pos = validPos = vec2(0.0f, 0.0f);
		color = Color(255, 255, 255, 255);
		radius = 0.0f; // disabled by default
		// isLevelLights = false;
	}

	// OS getters, setters
	std::string getName() const { return name; }
	void setName(const char * value){ name = value;}

	// float getTileRadiusScale() const { return tileRadiusScale; }
	// void setTileRadiusScale(float value){ tileRadiusScale = value;}

	Color getShadowColor() const { return shadowColor; }
	void setShadowColor(const Color& value){ shadowColor = value;}

	vec2 getPos() const { return pos; }
	void setPos(const vec2& value){ pos = value;}

	Color getColor() const { return color; }
	void setColor(const Color& value){ color = value;}

	float getRadius() const { return radius; }
	void setRadius(float value){ radius = value;}

	// bool getIsLevelLights() const { return isLevelLights; }
	// void setIsLevelLights(bool value){ isLevelLights = value;}
};

DECLARE_SMART(BaseLightLayer, spBaseLightLayer);
class BaseLightLayer: public Sprite
{
public:
	OS_DECLARE_CLASSINFO(BaseLightLayer);

	BaseLightLayer();
	~BaseLightLayer();

	// void init();

protected:

	// ShaderProgramGL * lightProgram;
	// ShaderProgramGL * blendProgram;
	// ShaderProgramGL * createShaderProgram(const char * vs, const char * fs);
	
	// void doRender(const RenderState &rs);
};

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

	vec2 tileToCenterPos(int x, int y);
	vec2 tileToPos(int x, int y);
	void posToTile(const vec2& pos, int& x, int& y);
	void posToCeilTile(const vec2& pos, int& x, int& y);

	void registerLevelData(int tiledmapWidth, int tiledmapHeight, const OS::String& data);
	OS::String retrieveLevelData();

	int getNumLights();
	spBaseLight getLight(int);
	void addLight(spBaseLight light);
	void removeLight(spBaseLight light);

	void updateCamera(BaseLightLayer*);

protected:

	Tile * tiles;
	int tiledmapWidth;	// in tiles
	int tiledmapHeight;	// in tiles

	spNativeTexture shadowMaskTexture;
	ShaderProgramGL * shadowMaskProg;

	spNativeTexture lightTexture;
	ShaderProgramGL * lightProg;
	ShaderProgramGL * lightTileProg;
	spSprite tempLightSprite;
	
	float lightScale;
	int lightTextureWidth;
	int lightTextureHeight;
	
	spResources resources;

	std::vector<spBaseLight> lights;
	std::vector<Point> activeTilesXY;

	int startViewX, startViewY;
	int endViewX, endViewY;
	bool afterDraggingMode;

	// std::vector<OS_BYTE> lightVolume;

	ShaderProgramGL * createShaderProgram(const char * _vs, const char * _fs, bvertex_format);
	void setUniformColor(const char * name, const vec3& color);

	std::vector<Vector2> vertices;

	bool getTileVertices(TileType, std::vector<Vector2>&);
};

class MyRenderer: public Renderer
{
public:

	size_t _maxVertices;

	MyRenderer()
	{
		_maxVertices = indices16.size()/3 * 2;
		_vdecl = _driver->getVertexDeclaration(VERTEX_PCT2T2);
	}

	void setVertexDeclaration(bvertex_format vf)
	{
		_vdecl = _driver->getVertexDeclaration(vf);
	}

	bool begin(spNativeTexture rt, const Rect &viewport, const Vector4& clearColor)
	{
		unsigned char r = (unsigned char)(clearColor.x * 255.0F);
		unsigned char g = (unsigned char)(clearColor.y * 255.0F);
		unsigned char b = (unsigned char)(clearColor.z * 255.0F);
		unsigned char a = (unsigned char)(clearColor.w * 255.0F);
		Color color(r, g, b, a);
		return Renderer::begin(rt, viewport, &color);
	}

	bool begin(spNativeTexture rt, const Rect &viewport)
	{
		return Renderer::begin(rt, viewport, NULL);
	}

	void drawBatch()
	{
		if(!_vertices.empty()){
			size_t count = _vertices.size() / _vdecl->size;
			size_t indices = (count * 3)/2;

			if (indices <= indices8.size())
				getDriver()->draw(IVideoDriver::PT_TRIANGLES, _vdecl, &_vertices.front(), count, &indices8.front(), indices, false);
			else
				getDriver()->draw(IVideoDriver::PT_TRIANGLES, _vdecl, &_vertices.front(), count, &indices16.front(), indices, true);
		
			_vertices.resize(0);			
		}
	}

	void drawPoints(const vec3 * points, int numPoints)
	{
		Renderer::draw(points, sizeof(points[0])*numPoints, VERTEX_POSITION);
	}

	void drawPoly(const vec2& p1, const vec2& p2, const vec2& p3, const vec2& p4)
	{
		vec3 points[] = {p1, p4, p2, p3};
		drawPoints(points, 4);
	}
};


namespace ObjectScript {

// OS_DECL_CTYPE_ENUM(TileType);
// OS_DECL_CTYPE_ENUM(TileType);
OS_DECL_CTYPE_NAME(vec2, "vec2");
template <> struct CtypeValue<vec2>: public CtypeValuePoint<vec2> {};

OS_DECL_OX_CLASS(BaseLight);
OS_DECL_OX_CLASS(BaseLightLayer);
OS_DECL_OX_CLASS(BaseGame4X);

} // namespace ObjectScript


#endif // __BASE_GAME_4X_H__
