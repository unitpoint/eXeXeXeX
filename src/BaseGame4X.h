#ifndef __BASE_GAME_4X_H__
#define __BASE_GAME_4X_H__

#include <oxygine-framework.h>
#include <core/gl/ShaderProgramGL.h>
#include <ox-binder.h>
#include <ox-physics.h>
#include "MathLib.h"
// #include <Box2D\Box2D.h>
#include "Box2DDebugDraw.h"

using namespace ObjectScript;

// =====================================================================

#define USE_PHYS_CAST_SHADOW_INSTEAD_OF_TILES
#define USE_PHYS_OF_WHOLE_LEVEL

// #define GAME_TO_PHYS_SCALE	(2.0f / 128.0f)

/*
#define PHYS_DEF_FIXED_ROTATION		true
#define PHYS_DEF_LINEAR_DAMPING		0.98f
#define PHYS_DEF_ANGULAR_DAMPING	0.98f
#define PHYS_DEF_DENSITY			1.0f
#define PHYS_DEF_RESTITUTION		0.0f
#define PHYS_DEF_FRICTION			0.02f

#define PHYS_PLAYER_ANGULAR_DAMPING	0.8f
#define PHYS_PLAYER_LINEAR_DAMPING	0.9f
#define PHYS_PLAYER_DENSITY			0.5f
#define PHYS_PLAYER_FRICTION		0.99f
#define PHYS_PLAYER_RESTITUTION		0.0f
*/

/*
#define PHYS_CAT_BIT_SOLID		(1<<0)
#define PHYS_CAT_BIT_LADDER		(1<<1)
#define PHYS_CAT_BIT_PLATFORM	(1<<2)
#define PHYS_CAT_BIT_PLAYER		(1<<3)
#define PHYS_CAT_BIT_ENTITY		(1<<4)
#define PHYS_CAT_BIT_STATIC_OBJECT	(1<<5)
#define PHYS_CAT_BIT_DYNAMIC_OBJECT	(1<<6)
#define PHYS_CAT_BIT_SCREEN		(1<<7)
#define PHYS_CAT_BIT_PIT		(1<<8)
*/

/*
float toPhysValue(float a);
float fromPhysValue(float a);
b2Vec2 toPhysVec(const vec2 &pos);
vec2 fromPhysVec(const b2Vec2 &pos);
*/

Actor * getOSChild(Actor*, const char * name);
float getOSChildFloat(Actor * actor, const char * name, float def);
float getOSChildPhysicsFloat(Actor * actor, const char * name, float def);
int getOSChildPhysicsInt(Actor * actor, const char * name, int def);
bool getOSChildPhysicsBool(Actor * actor, const char * name, bool def);

/*
class BasePhysEntity;

DECLARE_SMART(PhysContact, spPhysContact);
class PhysContact: public Object
{
public:
	OS_DECLARE_CLASSINFO(PhysContact);

	struct Data
	{
		spBasePhysEntity ent[2];
		b2Filter filter[2];
		bool isSensor[2];
		
		Data(){ reset(); }
		void reset();
	};
	Data data;

	PhysContact(){}

	PhysContact * with(const Data& d);

	int getCategoryBits(int i) const;
	BasePhysEntity * getEntity(int i) const;
	bool getIsSensor(int i) const;
};
*/

enum EPhysTileType
{
	PHYS_EMPTY,
	PHYS_SOLID,
	// PHYS_LADDER,
	// PHYS_PLATFORM,
	PHYS_HELPER,
	PHYS_PIT
};

DECLARE_SMART(PhysTileArea, spPhysTileArea);
class PhysTileArea: public Object
{
public:
	OS_DECLARE_CLASSINFO(PhysTileArea);

	float time;
	int ax, ay, bx, by;
	Bounds2 bounds;
	Bounds2 physBounds;
	std::vector<vec2> physPoly;
	EPhysTileType type;

	spPhysBody body;

	PhysTileArea()
	{
		time = 0;
		ax = ay = bx = by = 0;
		bounds.b[0] = bounds.b[1] = vec2(0, 0);
		physBounds = bounds;
		type = PHYS_EMPTY;
		body = NULL;
	}
	~PhysTileArea()
	{
		// OX_ASSERT(!body || !body->getCore());
	}

	// vec2 getPos() const { return pos; }
	// vec2 getSize() const { return size; }
	EPhysTileType getType() const { return type; }
};

/*
class BaseGame4X;

DECLARE_SMART(BasePhysEntity, spBasePhysEntity);
class BasePhysEntity: public oxygine::Sprite
{
public:
	OS_DECLARE_CLASSINFO(BasePhysEntity);

	BaseGame4X * game;
	b2Body * body;

	BasePhysEntity();
	~BasePhysEntity();

	void applyForce(const vec2& force, int paramsValueId);

	vec2 getLinearVelocity() const
	{
		return body ? fromPhysVec(body->GetLinearVelocity()) : vec2(0, 0);
	}
	void setLinearVelocity(const vec2& a)
	{
		if(body){
			body->SetLinearVelocity(toPhysVec(a));
		}
	}

	bool getIsAwake() const 
	{
		return body ? body->IsAwake() : false;
	}

	void setLinearDamping(float a)
	{
		if(body) body->SetLinearDamping(a);
	}

	void setAngularDamping(float a)
	{
		if(body) body->SetAngularDamping(a);
	}

	float getPhysicsFloat(const char * name, float def)
	{
		return getOSChildPhysicsFloat(this, name, def);
	}
	int getPhysicsInt(const char * name, int def)
	{
		return getOSChildPhysicsInt(this, name, def);
	}
	bool getPhysicsBool(const char * name, bool def)
	{
		return getOSChildPhysicsBool(this, name, def);
	}
};
*/

// =====================================================================

// #define TILE_TYPE_BLOCK 255

typedef OS_U16 ElementType;

struct Tile
{
	// ElementType item;
	ElementType front;
	ElementType back;
	bool physCreated;

	EPhysTileType getPhysType() const;
};

// #define LEVEL_BIN_DATA_PREFIX "level-tile-layers:front:back."

/*
#define TILE_SIZE 64.0f
#define ENTITY_SIZE 128.0f

#define TILE_TYPE_EMPTY			0
#define TILE_TYPE_LIGHT_ROCK_01 2
#define TILE_TYPE_LIGHT_ROCK_02 3
#define TILE_TYPE_DOOR_01		16
#define TILE_TYPE_LADDER		17
#define TILE_TYPE_TRADE_STOCK	24
*/

/*
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
*/

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
	vec2 pos;
	Color color;
	Color frontColor;
	Color shadowColor;
	float radius;
	float angle;
	float angularVelocity;
	float prevTimeSec;

	// vec2 validPos;
	// bool isLevelLights;

	BaseLight()
	{
		shadowColor = Color(127, 127, 127, 255);
		// tileRadiusScale = 1.0f;
		pos = /*validPos =*/ vec2(0.0f, 0.0f);
		color = frontColor = Color(255, 255, 255, 255);
		radius = 0.0f; // disabled by default
		angle = 0.0f;
		angularVelocity = 0.0f;
		prevTimeSec = 0.0f;
	}

	// OS getters, setters
	std::string getName() const { return name; }
	void setName(const char * value){ name = value;}

	vec2 getPos() const { return pos; }
	void setPos(const vec2& value){ pos = value;}

	Color getColor() const { return color; }
	void setColor(const Color& value){ color = value;}

	Color getFrontColor() const { return frontColor; }
	void setFrontColor(const Color& value){ frontColor = value;}

	Color getShadowColor() const { return shadowColor; }
	void setShadowColor(const Color& value){ shadowColor = value;}

	float getRadius() const { return radius; }
	void setRadius(float value){ radius = value;}

	float getAngle() const { return angle; }
	void setAngle(float value){ angle = value;}

	float getAngularVelocity() const { return angularVelocity; }
	void setAngularVelocity(float value){ angularVelocity = value;}

	// bool getIsLevelLights() const { return isLevelLights; }
	// void setIsLevelLights(bool value){ isLevelLights = value;}
};

DECLARE_SMART(BaseLightmap, spBaseLightmap);
class BaseLightmap: public Box9Sprite
{
public:
	OS_DECLARE_CLASSINFO(BaseLightmap);

	BaseLightmap();
	~BaseLightmap();
};

DECLARE_SMART(BaseGame4X, spBaseGame4X);
class BaseGame4X: public Actor
{
public:
	OS_DECLARE_CLASSINFO(BaseGame4X);

	BaseGame4X();
	~BaseGame4X();

	Actor * getOSChild(const char * name);
	Actor * getMapLayer(int num);

	// void initMap(const char * name);

	float getTileRandom(int x, int y);

	ElementType getFrontType(int x, int y);
	void setFrontType(int x, int y, ElementType type);

	ElementType getBackType(int x, int y);
	void setBackType(int x, int y, ElementType type);

	// ElementType getItemType(int x, int y);
	// void setItemType(int x, int y, ElementType type);

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

	spPhysWorld getPhysWorld();
	void setPhysWorld(spPhysWorld);

	void updateLightmap(BaseLightmap*);

	// void createPhysicsWorld();
	// void destroyPhysicsWorld();

	void drawPhysics();

	void queryTilePhysics(int ax, int ay, int bx, int by, float time);
	void addDebugMessage(const char * message);

	/*
	void initEntityPhysics(BasePhysEntity * ent);
	void addEntityPhysicsShapes(BasePhysEntity * ent);

	void destroyEntityPhysics(BasePhysEntity * ent);

	void updatePhysics(float dt);
	*/

	bool getPhysDebugDraw() const;
	void setPhysDebugDraw(bool value);

protected:

	std::vector<Tile> tiles;
	int tiledmapWidth;	// in tiles
	int tiledmapHeight;	// in tiles
	std::map<int, bool> physTilesChanged;

	spNativeTexture shadowMaskTexture;
	ShaderProgramGL * shadowMaskProg;

	spNativeTexture lightTexture;
	ShaderProgramGL * lightProg;
	ShaderProgramGL * lightTileProg;
	spSprite tempLightSprite;
	
	float lightScale;
	int lightTextureWidth;
	int lightTextureHeight;

	struct ShadowPolygon
	{
		vec2 points[b2_maxPolygonVertices];
		int count;
	};
	std::vector<ShadowPolygon> shadowPolygons;
	
	spResources resources;

	std::vector<spBaseLight> lights;
	// std::vector<Point> activeTilesXY;

	int startViewX, startViewY, endViewX, endViewY;
	int startPhysX, startPhysY, endPhysX, endPhysY;
	// bool afterDraggingMode;

	/*
	float physAccumTimeSec;
	b2World * physWorld;
	std::vector<PhysContact::Data> physContacts;
	std::vector<b2Body*> waitBodiesToDestroy;
	spPhysContact physContactShare;
	*/
	spPhysWorld physWorld;
	
	std::vector<spPhysTileArea> physTileAreas;
	spBox2DDraw physDebugDraw;
	
	Bounds2 physPlayerBounds;
	Bounds2 physDraggingBounds;
	bool physDraggingBoundsUsed;

	void initLightmap(BaseLightmap*);
	ShaderProgramGL * createShaderProgram(const char * _vs, const char * _fs, bvertex_format);
	void setUniformColor(const char * name, const vec3& color);

	std::vector<Vector2> vertices;

	bool getTileVertices(ElementType, std::vector<Vector2>&);

	Tile * getTile(int x, int y);
	int getTileId(int x, int y);
	void tileIdToTilePos(int& x, int& y, int id);
	void worldPosToPos(int& x, int& y, const vec2&);

	Bounds2 getTileAreaBounds(int ax, int ay, int bx, int by);
	void boundsToTileArea(int& ax, int& ay, int& bx, int& by, const Bounds2&);
	bool freePhysTileAreasInBounds(const Bounds2&);
	void freeAllPhysTileAreas();
	void freePhysTileArea(spPhysTileArea);

	void drawPhysShape(b2Fixture* fixture, const b2Transform& xf, const b2Color& color);
	void drawPhysJoint(b2Joint* joint);

	/*
	static b2BodyDef getPlayerWheelDef(const vec2& pos);

	void destroyWaitBodies();
	void destroyAllBodies();
	void dispatchContacts();

	/// Called when two fixtures begin to touch.
	void BeginContact(b2Contact* contact); // override b2ContactListener

	/// Called when two fixtures cease to touch.
	void EndContact(b2Contact* contact); // override b2ContactListener

	/// Called when any joint is about to be destroyed due
	/// to the destruction of one of its attached bodies.
	void SayGoodbye(b2Joint* joint); // override b2DestructionListener

	/// Called when any fixture is about to be destroyed due
	/// to the destruction of its parent body.
	void SayGoodbye(b2Fixture* fixture); // override b2DestructionListener
	*/
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

	void drawTriangleStrip(const vec3 * points, int numPoints)
	{
		Renderer::draw(points, sizeof(points[0])*numPoints, VERTEX_POSITION);
	}

	void drawTriangleStrip(const vec2 * points, int numPoints)
	{
		vec3 * p = (vec3*)alloca(sizeof(vec3)*numPoints);
		for(int i = 0; i < numPoints; i++){
			p[i] = points[i];
		}
		drawTriangleStrip(p, numPoints);
	}

	void drawTriangleFan(const vec3 * points, int numPoints)
	{
		if(numPoints > 2){
			vec3 * strip = (vec3*)alloca(sizeof(vec3)*numPoints);
			strip[0] = points[0];
			strip[1] = points[1];
			strip[2] = points[2];
			int i = 3;
			for(int a = 3, b = numPoints-1;;){
				if(b < a){
					break;
				}
				strip[i++] = points[b--];
				if(a > b){
					break;
				}
				strip[i++] = points[a++];
			}
			OX_ASSERT(i == numPoints);
			drawTriangleStrip(strip, numPoints);
		}
	}

	void drawTriangleFan(const vec2 * points, int numPoints)
	{
		if(numPoints > 2){
			vec3 * strip = (vec3*)alloca(sizeof(vec3)*numPoints);
			strip[0] = points[0];
			// strip[1] = points[1];
			// strip[2] = points[2];
			int i = 1;
			for(int a = 1, b = numPoints-1;;){
				if(b < a){
					break;
				}
				strip[i++] = points[b--];
				if(a > b){
					break;
				}
				strip[i++] = points[a++];
			}
			OX_ASSERT(i == numPoints);
			drawTriangleStrip(strip, numPoints);
		}
	}

	void drawPoly(const vec2& p1, const vec2& p2, const vec2& p3, const vec2& p4)
	{
		vec3 points[] = {p1, p4, p2, p3};
		drawTriangleStrip(points, 4);
	}
};


namespace ObjectScript {

// OS_DECL_CTYPE_ENUM(ElementType);
// OS_DECL_CTYPE_ENUM(ElementType);

/*
OS_DECL_CTYPE_NAME(vec2, "vec2");
template <> struct CtypeValue<vec2>: public CtypeValuePoint<vec2> {};

OS_DECL_CTYPE_NAME(b2Vec2, "vec2");
template <> struct CtypeValue<b2Vec2>: public CtypeValuePointOf<b2Vec2, float32> {};

OS_DECL_OX_CLASS(PhysContact);
OS_DECL_OX_CLASS(BasePhysEntity);
*/

OS_DECL_OX_CLASS(BaseLight);
OS_DECL_OX_CLASS(BaseLightmap);
OS_DECL_OX_CLASS(BaseGame4X);

} // namespace ObjectScript


#endif // __BASE_GAME_4X_H__
