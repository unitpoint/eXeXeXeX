#include "BaseGame4X.h"
#include "RandomValue.h"
// #include "level_testmap.inc.h"

#include <core/VideoDriver.h>
#include <core/gl/VideoDriverGLES20.h>
#include <core/UberShaderProgram.h>

// #include <SDL_opengl.h>
// #include <SDL_opengles2_gl2.h>

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
		DEF_CONST(PHYS_CAT_BIT_GROUND),
		DEF_CONST(PHYS_CAT_BIT_LADDER),
		DEF_CONST(PHYS_CAT_BIT_PLATFORM),
		DEF_CONST(PHYS_CAT_BIT_PLAYER),
		DEF_CONST(PHYS_CAT_BIT_ENTITY),
		DEF_CONST(PHYS_CAT_BIT_STATIC_OBJECT),
		DEF_CONST(PHYS_CAT_BIT_DYNAMIC_OBJECT),
		DEF_CONST(PHYS_CAT_BIT_SCREEN),
		DEF_CONST(PHYS_CAT_BIT_PIT),
		/*
		DEF_CONST(TO_PHYS_SCALE),
		DEF_CONST(PHYS_DEF_FIXED_ROTATION),
		DEF_CONST(PHYS_DEF_LINEAR_DAMPING),
		DEF_CONST(PHYS_DEF_ANGULAR_DAMPING),
		DEF_CONST(PHYS_DEF_DENSITY),
		DEF_CONST(PHYS_DEF_RESTITUTION),
		DEF_CONST(PHYS_DEF_FRICTION),
		*/
		DEF_CONST(TILE_SIZE),
		DEF_CONST(TILE_TYPE_BLOCK),
		{}
	};
	os->pushGlobals();
	os->setFuncs(funcs);
	os->setNumbers(nums);

	os->pushString(LEVEL_BIN_DATA_PREFIX);
	os->setProperty(-2, "LEVEL_BIN_DATA_PREFIX");

	os->pop();
}
static bool __registerGlobals = addRegFunc(registerGlobals);

// =====================================================================

static void registerBaseLight(OS * os)
{
	struct Lib {
		static BaseLight * __newinstance()
		{
			return new BaseLight();
		}
	};

	OS::FuncDef funcs[] = {
		def("__newinstance", &Lib::__newinstance),
		DEF_PROP("name", BaseLight, Name),
		DEF_PROP("shadowColor", BaseLight, ShadowColor),
		// DEF_PROP("tileRadiusScale", BaseLight, TileRadiusScale),
		DEF_PROP("pos", BaseLight, Pos),
		DEF_PROP("color", BaseLight, Color),
		DEF_PROP("radius", BaseLight, Radius),
		{}
	};

	OS::NumberDef nums[] = {
		{}
	};
	registerOXClass<BaseLight, Object>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerBaseLight = addRegFunc(registerBaseLight);

// =====================================================================

static void registerBaseLightmap(OS * os)
{
	struct Lib {
		static BaseLightmap * __newinstance()
		{
			return new BaseLightmap();
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
		{}
	};
	OS::NumberDef nums[] = {
		{}
	};
	registerOXClass<BaseLightmap, Actor>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerBaseLightmap = addRegFunc(registerBaseLightmap);

// =====================================================================
/*
static void registerPhysContact(OS * os)
{
	struct Lib {
	};

	OS::FuncDef funcs[] = {
		// def("__newinstance", &Lib::__newinstance),
		def("getCategoryBits", &PhysContact::getCategoryBits),
		def("getEntity", &PhysContact::getEntity),
		def("getIsSensor", &PhysContact::getIsSensor),
		{}
	};
	OS::NumberDef nums[] = {
		{}
	};
	registerOXClass<PhysContact, Object>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerPhysContact = addRegFunc(registerPhysContact);

// =====================================================================

static void registerBasePhysEntity(OS * os)
{
	struct Lib {
		static BasePhysEntity * __newinstance()
		{
			return new BasePhysEntity();
		}

		static int applyForce(OS * os, int params, int, int, void*)
		{
			OS_GET_SELF(BasePhysEntity*);
			if(params < 1){
				os->setException("vec2 argument required");
				os->handleException();
				return 0;
			}
			Vector2 force = CtypeValue<Vector2>::getArg(os, -params+0);
			self->applyForce(force, params >= 2 ? os->getValueId(-params+1) : 0);
			return 0;
		}
	};

	OS::FuncDef funcs[] = {
		def("__newinstance", &Lib::__newinstance),
		{"applyForce", &Lib::applyForce},
		DEF_PROP("linearVelocity", BasePhysEntity, LinearVelocity),
		DEF_GET("isAwake", BasePhysEntity, IsAwake),
		DEF_SET("linearDamping", BasePhysEntity, LinearDamping),
		DEF_SET("angularDamping", BasePhysEntity, AngularDamping),
		{}
	};
	OS::NumberDef nums[] = {
		{}
	};
	registerOXClass<BasePhysEntity, Sprite>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerBasePhysEntity = addRegFunc(registerBasePhysEntity);
*/

// =====================================================================

static void registerBaseGame4X(OS * os)
{
	struct Lib {
		static BaseGame4X * __newinstance()
		{
			return new BaseGame4X();
		}

		static int setPhysWorld(OS * os, int params, int, int need_ret_values, void*)
		{
			OS_GET_SELF(BaseGame4X*);
			if(os->isNull(-params+0)){
				self->setPhysWorld(NULL);
			}else{
				self->setPhysWorld(CtypeValue<PhysWorld*>::getArg(os, -params+0));
			}
			return 0;
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
		def("registerLevelData", &BaseGame4X::registerLevelData),
		def("retrieveLevelData", &BaseGame4X::retrieveLevelData),
		DEF_GET("numLights", BaseGame4X, NumLights),
		def("getLight", &BaseGame4X::getLight),
		def("addLight", &BaseGame4X::addLight),
		def("removeLight", &BaseGame4X::removeLight),
		def("updateLightmap", &BaseGame4X::updateLightmap),
		def("getTileRandom", &BaseGame4X::getTileRandom),
		def("getFrontType", &BaseGame4X::getFrontType),
		def("setFrontType", &BaseGame4X::setFrontType),
		def("getBackType", &BaseGame4X::getBackType),
		def("setBackType", &BaseGame4X::setBackType),
		def("getItemType", &BaseGame4X::getItemType),
		def("setItemType", &BaseGame4X::setItemType),
		// def("createPhysicsWorld", &BaseGame4X::createPhysicsWorld),
		// def("destroyPhysicsWorld", &BaseGame4X::destroyPhysicsWorld),
		DEF_GET("physWorld", BaseGame4X, PhysWorld),
		{"__set@physWorld", &Lib::setPhysWorld},
		def("queryTilePhysics", &BaseGame4X::queryTilePhysics),
		/*
		def("updatePhysics", &BaseGame4X::updatePhysics),
		def("initEntityPhysics", &BaseGame4X::initEntityPhysics),
		def("destroyEntityPhysics", &BaseGame4X::destroyEntityPhysics),
		*/
		DEF_PROP("physDebugDraw", BaseGame4X, PhysDebugDraw),
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

// =====================================================================
// =====================================================================
// =====================================================================

/*
void PhysContact::Data::reset()
{
	memset(this, 0, sizeof(*this));
}

PhysContact * PhysContact::with(const Data& d)
{
	data = d;
	return this;
}

int PhysContact::getCategoryBits(int i) const 
{
	OS_ASSERT(i >= 0 && i < 2);
	if(i >= 0 && i < 2){
		return data.filter[i].categoryBits;
	}
	return 0;
}

BasePhysEntity * PhysContact::getEntity(int i) const
{
	OS_ASSERT(i >= 0 && i < 2);
	if(i >= 0 && i < 2){
		return data.ent[i];
	}
	return NULL;
}

bool PhysContact::getIsSensor(int i) const
{
	OS_ASSERT(i >= 0 && i < 2);
	if(i >= 0 && i < 2){
		return data.isSensor[i];
	}
	return false;
}

// =====================================================================
// =====================================================================
// =====================================================================

BasePhysEntity::BasePhysEntity()
{
	game = NULL;
	body = NULL;
}

BasePhysEntity::~BasePhysEntity()
{
	OX_ASSERT(!game && !body);
}

void BasePhysEntity::applyForce(const vec2& viewForce, int paramsValueId)
{
	if(!body){
		return;
	}
	if(viewForce.x || viewForce.y){
		ObjectScript::SaveStackSize saveStackSize;
		ObjectScript::OS * os = ObjectScript::os;

		b2Vec2 force = toPhysVec(viewForce);
		
		os->pushValueById(paramsValueId);
		bool noClipForce = (os->getProperty(-1, "noClipForce"), os->popBool(false));
		if(!noClipForce){
			float scalarSpeed = toPhysValue((os->getProperty(-1, "maxSpeed"), os->popFloat(getOSChildPhysicsFloat(this, "maxSpeed", 120.0f))));
			scalarSpeed *= (os->getProperty(-1, "speedScale"), os->popFloat(1.0f));
			
			b2Vec2 destSpeed = force;
			destSpeed.Normalize();
			destSpeed *= scalarSpeed;
			
			b2Vec2 speed = body->GetLinearVelocity();
			float clip_edge = 0.5f, src, dest;
			for(int i = 0; i < 2; i++){
				if(i == 0){
					src = speed.x;
					dest = destSpeed.x;
				}else{
					src = speed.y;
					dest = destSpeed.y;
				}
				float t = src / (dest ? dest : 0.00001f);
				if(t >= clip_edge){
					t = 1 - (t - clip_edge) / (1 - clip_edge);
					
					if(t < -1) t = -1;
					else if(t > 1) t = 1;
					// t = t*t * (t < 0 ? -1.0f : 1.0f);
					// t = (1 - (1-t)*(1-t)) * (t < 0 ? -1.0f : 1.0f);
					
					if(i == 0){
						force.x *= t;
					}else{
						force.y *= t;
					}
				}
			}
		}
		if(force.x || force.y){
			body->ApplyForce(force, body->GetWorldCenter(), true);
		}
	}
}
*/

// =====================================================================
// =====================================================================
// =====================================================================

Actor * getOSChild(Actor * actor, const char * name)
{
	SaveStackSize saveStackSize;
	// OS2D * os = getOS();
	pushCtypeValue(os, actor);
	os->getProperty(name);
	return CtypeValue<Actor*>::getArg(os, -1);
}

float getOSChildFloat(Actor * actor, const char * name, float def)
{
	ObjectScript::SaveStackSize saveStackSize;
	ObjectScript::OS * os = ObjectScript::os;
	ObjectScript::pushCtypeValue(os, actor);
	os->getProperty(-1, name);
	return os->toFloat(-1, def);
}

float getOSChildPhysicsFloat(Actor * actor, const char * name, float def)
{
	ObjectScript::SaveStackSize saveStackSize;
	ObjectScript::OS * os = ObjectScript::os;
	ObjectScript::pushCtypeValue(os, actor);
	os->getProperty(-1, "physics");
	os->getProperty(-1, name);
	return os->toFloat(-1, def);
}

int getOSChildPhysicsInt(Actor * actor, const char * name, int def)
{
	return (int)getOSChildPhysicsFloat(actor, name, (float)def);
}

bool getOSChildPhysicsBool(Actor * actor, const char * name, bool def)
{
	ObjectScript::SaveStackSize saveStackSize;
	ObjectScript::OS * os = ObjectScript::os;
	ObjectScript::pushCtypeValue(os, actor);
	os->getProperty(-1, "physics");
	os->getProperty(-1, name);
	return os->toBool(-1, def);
}

// =====================================================================
// =====================================================================
// =====================================================================

BaseLightmap::BaseLightmap()
{
	// lightProgram = NULL;
	// blendProgram = NULL;
	setTouchEnabled(false);
	setTouchChildrenEnabled(false);
}

BaseLightmap::~BaseLightmap()
{
	// delete lightProgram;
	// delete blendProgram;
}

int prevPOT(int v)
{
	return nextPOT(v) >> 1;
}

bool BaseGame4X::getTileVertices(TileType type, std::vector<Vector2>& vertices)
{
	if(!type){
		return false;
	}
	// vertices
	return true;
}

vec3 colorFromInt(int color)
{
	float r = (float)((color >> 16) & 0xff);
	float g = (float)((color >> 8) & 0xff);
	float b = (float)((color >> 0) & 0xff);
	return vec3(r / 255.0f, g / 255.0f, b / 255.0f);
}

void BaseGame4X::setUniformColor(const char * name, const vec3& color)
{
	Vector4 c(color.x, color.y, color.z, 1.0f);
	IVideoDriver::instance->setUniform(name, &c, 1);
}

int BaseGame4X::getNumLights()
{
	return (int)lights.size();
}

spBaseLight BaseGame4X::getLight(int i)
{
	if(i >= 0 && i < (int)lights.size()){
		return lights[i];
	}
	return NULL;
}

void BaseGame4X::addLight(spBaseLight light)
{
	OX_ASSERT(std::find(lights.begin(), lights.end(), light) == lights.end());
	lights.push_back(light);
}

void BaseGame4X::removeLight(spBaseLight light)
{
	std::vector<spBaseLight>::iterator it = std::find(lights.begin(), lights.end(), light);
	OX_ASSERT(it != lights.end());
	lights.erase(it);
}

spPhysWorld BaseGame4X::getPhysWorld()
{
	return physWorld;
}

void BaseGame4X::setPhysWorld(spPhysWorld value)
{
	physWorld = value;
}

void BaseGame4X::initLightmap(BaseLightmap * lightmap)
{
	if(!lightProg){
		Point displaySize = core::getDisplaySize();
		float displayWidthScale = (float)displaySize.x / getWidth();
		float displayHeightScale = (float)displaySize.y / getHeight();
		lightScale = MathLib::max(displayWidthScale, displayHeightScale);
#if defined _WIN32 && 1
		// keep max quality lightScale?
		lightScale *= 1.0f / 2.0f;
#else
		lightScale *= 1.0f / 3.0f;
#endif
		vec2 size = getSize();
		lightTextureWidth = (int)(size.x * lightScale);
		lightTextureHeight = (int)(size.y * lightScale);
		
		// TextureFormat lightTextureFormat = TF_R8G8B8A8;
		TextureFormat lightTextureFormat = TF_R5G6B5;
		lightTexture = IVideoDriver::instance->createTexture();
		lightTexture->init(lightTextureWidth, lightTextureHeight, lightTextureFormat, true);

		TextureFormat shadowMaskTextureFormat = TF_R5G6B5;
		shadowMaskTexture = IVideoDriver::instance->createTexture();
		shadowMaskTexture->init(lightTextureWidth, lightTextureHeight, shadowMaskTextureFormat, true);

		const char* shadowMaskVS = "\
			uniform mediump mat4 projection;\
			attribute vec2 position;\
			void main() {\
				gl_Position = projection * vec4(position, 0.0, 1.0);\
			}\
			";

		const char* shadowMaskFS = "\
			uniform lowp vec4 color;\
			void main() { \
				gl_FragColor = color; \
			} \
			";

		shadowMaskProg = createShaderProgram(shadowMaskVS, shadowMaskFS, VERTEX_POSITION);
		
		const char* lightVS = "\
			varying lowp vec4 result_color; \
			varying mediump vec2 result_uv; \
			varying mediump vec2 result_uv2; \
			\
			uniform mat4 projection; \
			attribute vec2 position; \
			attribute vec4 color; \
			attribute vec2 uv; \
			attribute vec2 uv2; \
			\
			void main() {\
				gl_Position = projection * vec4(position, 0.0, 1.0); \
				result_color = color; \
				result_uv = uv; \
				result_uv2 = uv2; \
			}\
			";

		const char* lightFS = "\
			varying lowp vec4 result_color; \
			varying mediump vec2 result_uv; \
			varying mediump vec2 result_uv2; \
			\
			uniform lowp sampler2D base_texture; \
			uniform lowp sampler2D shadow_texture; \
			\
			void main() { \
				lowp vec4 base = texture2D(base_texture, result_uv); \
				lowp vec4 shadow = texture2D(shadow_texture, result_uv2); \
				gl_FragColor = base * shadow * result_color; \
			} \
			";

		lightProg = createShaderProgram(lightVS, lightFS, VERTEX_PCT2T2);

		const char* lightTileVS = "\
			varying lowp vec4 result_color; \
			varying mediump vec2 result_uv; \
			\
			uniform mediump mat4 projection; \
			attribute vec2 position; \
			attribute vec4 color; \
			attribute vec2 uv; \
			\
			void main() {\
				gl_Position = projection * vec4(position, 0.0, 1.0); \
				result_color = color; \
				result_uv = uv; \
			}\
			";

		const char* lightTileFS = "\
			varying lowp vec4 result_color; \
			varying mediump vec2 result_uv; \
			\
			uniform lowp sampler2D base_texture; \
			\
			void main() { \
				lowp vec4 base = texture2D(base_texture, result_uv); \
				gl_FragColor = base * result_color; \
			} \
			";

		lightTileProg = createShaderProgram(lightTileVS, lightTileFS, VERTEX_PCT2);

		Diffuse df;
		df.base = lightTexture;
		// df.premultiplied = false;
		
		AnimationFrame frame;
		frame.init(0, df,
			RectF(0, 0, (float)lightTextureWidth / lightTexture->getWidth(), (float)lightTextureHeight / lightTexture->getHeight()), 
			RectF(vec2(0, 0), size), size);

		lightmap->setAnimFrame(frame);
		lightmap->setBlendMode(blend_multiply);
		lightmap->removeChildren();

#if 0
		Sprite * illumination = new Sprite();
		illumination->setAnimFrame(frame);
		// illumination->setOpacity(0.1f);
		illumination->setColor(Color(255/2, 255/2, 255/2, 255));
		illumination->setBlendMode(blend_add_dst_color);
		illumination->attachTo(lightmap);
#endif
		
		os->getGlobal("res");
		resources = CtypeValue<Resources*>::getArg(os, -1);
		os->pop();
		OX_ASSERT(resources);
	}
}

void BaseGame4X::updateLightmap(BaseLightmap * lightmap)
{
	initLightmap(lightmap);
	
	pushCtypeValue(os, this);
	float time = (os->getProperty(-1, "time"), os->popFloat());
	float dt = (os->getProperty(-1, "dt"), os->popFloat());
	bool dragging = (os->getProperty(-1, "dragging"), os->popBool());
	os->pop();

	Actor * player = getOSChild("player"); OX_ASSERT(player);
	vec2 playerPos = player->getPosition();

	Actor * map = getOSChild("map"); OX_ASSERT(map);
	vec2 mapPos = map->getPosition();
	vec2 mapScale = map->getScale();

	int startX, startY;
	vec2 offs = -mapPos / mapScale;
	posToTile(offs, startX, startY);

	int endX, endY;
	vec2 size = getSize();
	vec2 endOffs = offs + size / mapScale;
	posToCeilTile(endOffs, endX, endY);

	int physEdge = 0;
	int startPhysX = startX+physEdge, endPhysX = endX-physEdge;
	int startPhysY = startY+physEdge, endPhysY = endY-physEdge;

#if 1 || defined _WIN32 && 1
	startX -= 2; startY -= 1;
	endX += 1; endY += 1;
#endif

	bool physChanged = false;
	if(physTilesChanged.size() > 0){
		std::map<int, bool>::iterator it = physTilesChanged.begin();
		for(; it != physTilesChanged.end(); ++it){
			int x, y, id = it->first;
			tileIdToTilePos(x, y, id);
			if(freePhysTileAreasInBounds(getTileAreaBounds(x, y, x, y))){
				physChanged = true;
			}
		}
		physTilesChanged.clear();
	}

	if(startX != startViewX || startY != startViewY || endX != endViewX || endY != endViewY){
		startViewX = startX;
		startViewY = startY;
		endViewX = endX;
		endViewY = endY;

		pushCtypeValue(os, this);
		os->getProperty(-1, "updateMapTilesViewport");
		pushCtypeValue(os, startX);
		pushCtypeValue(os, startY);
		pushCtypeValue(os, endX);
		pushCtypeValue(os, endY);
		os->callTF(4);
	}
	
	physEdge = 4;
	startPhysX = (startPhysX / physEdge) * physEdge;
	startPhysY = (startPhysY / physEdge) * physEdge;
	endPhysX = ((endPhysX + physEdge-1) / physEdge) * physEdge;
	endPhysY = ((endPhysY + physEdge-1) / physEdge) * physEdge;
	// endPhysX = (endPhysX / physEdge + 1) * physEdge;
	// endPhysY = (endPhysY / physEdge + 1) * physEdge;
	// physDraggingBoundsUsed = false;
	if(physChanged || startPhysX != this->startPhysX || startPhysY != this->startPhysY || endPhysX != this->endPhysX || endPhysY != this->endPhysY){
		this->startPhysX = startPhysX;
		this->startPhysY = startPhysY;
		this->endPhysX = endPhysX;
		this->endPhysY = endPhysY;
		Bounds2 bounds = getTileAreaBounds(startPhysX, startPhysY, endPhysX, endPhysY);
		if(dragging){
			physDraggingBounds = bounds;
			physDraggingBoundsUsed = true;
			// addDebugMessage("set dragging bounds");
		}else{
			physPlayerBounds = bounds;
			physDraggingBoundsUsed = false;
			// addDebugMessage("set player bounds");
		}
		queryTilePhysics(startPhysX, startPhysY, endPhysX, endPhysY, time);
	}

	vec2 lightTextureSize((float)lightTextureWidth, (float)lightTextureHeight);

	MyRenderer r;	
	r.initCoordinateSystem(lightTextureWidth, lightTextureHeight, true);
	
	Matrix viewProj = r.getViewProjection();
	Rect viewport(Point(0, 0), Point(lightTextureWidth, lightTextureHeight));

#if 0
	activeTilesXY.clear();

#if 1
	activeTilesXY.reserve((endX - startX + 1) * (endY - startY + 1));
	for(int y = startY; y <= endY; y++){
		for(int x = startX; x <= endX; x++){
			activeTilesXY.push_back(Point(x, y));
		}
	}
#else
	pushCtypeValue(os, this);
	os->getProperty("tiles");
	while(os->nextIteratorStep()){
		int x = (os->getProperty(-1, "tileX"), os->popInt());
		int y = (os->getProperty(-1, "tileY"), os->popInt());
		activeTilesXY.push_back(Point(x, y));
		os->pop(2);
	}
	os->pop();
#endif
#endif // 0

	std::vector<Point>::iterator it;
	for(int i = 0; i < (int)lights.size(); i++){
		spBaseLight light = lights[i];
		// float radius = light->radius; // tileRadius * light->tileRadiusScale * TILE_SIZE;
		if(light->radius <= 0.0f){
			continue;
		}
		vec2 lightScreenRadius = vec2(light->radius, light->radius) * mapScale;
		float lightScreenRadiusMax = MathLib::max(lightScreenRadius.x, lightScreenRadius.y);
		vec2 lightScreenPos = (light->pos - offs) * mapScale;

		r.begin(shadowMaskTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));
		// r.begin(lightTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));

		r.setVertexDeclaration(VERTEX_POSITION);
		IVideoDriver::instance->setShaderProgram(shadowMaskProg);
		IVideoDriver::instance->setUniform("projection", &viewProj);
		setUniformColor("color", light->shadowColor);

		int tx, ty;
		posToTile(light->pos, tx, ty);
		TileType type = getFrontType(tx, ty);
		if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER || type == TILE_TYPE_DOOR_01){
			light->validPos = light->pos;
		}else{
			posToTile(light->validPos, tx, ty);
			lightScreenPos = (light->validPos - offs) * mapScale;
		}
		/* it = activeTilesXY.begin();
		for(; it != activeTilesXY.end(); ++it){
			const Point& p = *it;
			int x = p.x;
			int y = p.y; */
		for(int y = startY; y <= endY; y++){
			for(int x = startX; x <= endX; x++){
				TileType type = getFrontType(x, y);
				if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER){
					continue;
				}
				bool isDoor = false;
				float tileWidth = TILE_SIZE, tileHeight = TILE_SIZE;
				if(type == TILE_TYPE_DOOR_01){
					pushCtypeValue(os, this);
					os->getProperty(-1, "getTile");
					OX_ASSERT(os->isFunction());
					pushCtypeValue(os, x);
					pushCtypeValue(os, y);
					os->callTF(2, 1);
					os->getProperty("front");
					os->getProperty("openState");
					float openState = os->popFloat();
					if(openState > 0.999f){
						continue;
					}
					tileHeight *= 1.0f - openState;
					isDoor = true;
				}else{
					pushCtypeValue(os, this);
					os->getProperty(-1, "getTile");
					OX_ASSERT(os->isFunction());
					pushCtypeValue(os, x);
					pushCtypeValue(os, y);
					os->callTF(2, 1);
					os->getProperty("front");
					os->getProperty("isFalling");
					float isFalling = os->popBool();
					if(isFalling){
						continue;
					}
				}
				vec2 pos = (tileToPos(x, y) - offs) * mapScale;
				vec2 points[] = {
					pos,
					pos + vec2(tileWidth, 0) * mapScale,
					pos + vec2(tileWidth, tileHeight) * mapScale,
					pos + vec2(0, tileHeight) * mapScale
				};
				static Point tileSideOffs[] = {
					Point(0, -1),
					Point(1, 0),
					Point(0, 1),
					Point(-1, 0),
				};
				int count = 4;
				for(int i = 0; i < count; i++){
					const vec2& p1 = points[i];
					const vec2& p2 = points[(i+1) % count];
					vec2 edge = p2 - p1;
					vec2 normal = vec2(edge.y, -edge.x).norm();
					float dist = normal.dot(p1) - normal.dot(lightScreenPos);
					if(dist <= 0 || dist > lightScreenRadiusMax){
						continue;
					}

					vec2 lightToCurrent = p1 - lightScreenPos;
					OX_ASSERT(normal.dot(lightToCurrent) > 0);
					type = isDoor ? TILE_TYPE_EMPTY : getFrontType(x + tileSideOffs[i].x, y + tileSideOffs[i].y);
					if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER || type == TILE_TYPE_DOOR_01){
						vec2 p1_target = p1 + lightToCurrent * (lightScreenRadius * 100);
						vec2 p2_target = p2 + (p2 - lightScreenPos) * (lightScreenRadius * 100);
						
						r.drawPoly(p1 * lightScale, 
								p1_target * lightScale, 
								p2_target * lightScale, 
								p2 * lightScale);
					}
				}
			}
		}
		r.drawBatch();

		setUniformColor("color", vec3(1.0f, 1.0f, 1.0f));
		/* it = activeTilesXY.begin();
		for(; it != activeTilesXY.end(); ++it){
			const Point& p = *it;
			int x = p.x;
			int y = p.y; */
		for(int y = startY; y <= endY; y++){
			for(int x = startX; x <= endX; x++){
				TileType type = getFrontType(x, y);
				if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER){ // || type == TILE_TYPE_DOOR_01){
					continue;
				}
				vec2 pos = (tileToPos(x, y) - offs) * mapScale;
				vec2 points[] = {
					pos,
					pos + vec2(TILE_SIZE, 0) * mapScale,
					pos + vec2(TILE_SIZE, TILE_SIZE) * mapScale,
					pos + vec2(0, TILE_SIZE) * mapScale
				};
				r.drawPoly(points[0] * lightScale, 
					points[1] * lightScale, 
					points[2] * lightScale, 
					points[3] * lightScale);
			}
		}
		r.end();

		if(i == 0){
			r.begin(lightTexture, viewport, Vector4(0.0f, 0.0f, 0.0f, 1.0f));
		}else{
			r.begin(lightTexture, viewport);
		}
		// r.begin(lightTexture, viewport, Vector4(0.1f, 0.1f, 0.1f, 1.0f));

		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);

		r.setVertexDeclaration(VERTEX_PCT2T2);
		IVideoDriver::instance->setShaderProgram(lightProg);
		IVideoDriver::instance->setUniformInt("base_texture", 0);
		IVideoDriver::instance->setUniformInt("shadow_texture", 1);

		// Matrix viewProj = r.getViewProjection();
		IVideoDriver::instance->setUniform("projection", &viewProj);

		RectF shadowSrc = RectF(0, 0, lightTextureSize.x / lightTexture->getWidth(), lightTextureSize.y / lightTexture->getHeight());
		RectF shadowDest = RectF(vec2(0, 0), lightTextureSize);
		
		AffineTransform t; t.identity();
		r.setMask(shadowMaskTexture, shadowSrc, shadowDest, t, true);

		ResAnim * resAnim = resources->getResAnim(light->name);
		AnimationFrame frame = resAnim->getFrame(0, 0);
		r.setDiffuse(frame.getDiffuse());
		r.setPrimaryColor(light->color);

		IVideoDriver::instance->setTexture(0, frame.getDiffuse().base);
		IVideoDriver::instance->setTexture(1, shadowMaskTexture);

		vec2 radius = lightScreenRadius * lightScale;
		vec2 pos = lightScreenPos * lightScale;

		// pos.y = lightTextureSize.y - pos.y;
		r.draw(frame.getSrcRect(), RectF(pos - radius, radius * 2.0f));
		r.drawBatch();

		r.end();
	}
	
	r.begin(lightTexture, viewport);

	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE);

	r.setVertexDeclaration(VERTEX_POSITION);
	IVideoDriver::instance->setShaderProgram(shadowMaskProg);

	// Matrix viewProj = r.getViewProjection();
	IVideoDriver::instance->setUniform("projection", &viewProj);
		
	vec3 color, prevColor(0, 0, 0);
	/* it = activeTilesXY.begin();
	for(; it != activeTilesXY.end(); ++it){
		const Point& p = *it;
		int x = p.x;
		int y = p.y; */
	for(int y = startY; y <= endY; y++){
		for(int x = startX; x <= endX; x++){
			TileType type = getBackType(x, y);
			if(type != TILE_TYPE_TRADE_STOCK){
				// continue;
				bool found = false;
				for(int dx = -1; dx <= 1 && !found; dx++){
					for(int dy = -1; dy <= 1; dy++){
						if(dx == 0 && dy == 0){
							continue;
						}
						type = getBackType(x + dx, y + dy);
						if(type == TILE_TYPE_TRADE_STOCK){
							found = true;
							break;
						}
					}
				}
				if(!found){
					continue;
				}
				color = vec3(0.25f, 0.25f, 0.25f);
			}else{
				color = vec3(0.5f, 0.5f, 0.5f);
			}
			if(color != prevColor){
				prevColor = color;
				r.drawBatch();
				setUniformColor("color", color);
			}
			vec2 pos = (tileToPos(x, y) - offs) * mapScale;
			vec2 points[] = {
				pos,
				pos + vec2(TILE_SIZE, 0) * mapScale,
				pos + vec2(TILE_SIZE, TILE_SIZE) * mapScale,
				pos + vec2(0, TILE_SIZE) * mapScale
			};
			r.drawPoly(points[0] * lightScale, 
				points[1] * lightScale, 
				points[2] * lightScale, 
				points[3] * lightScale);
		}
	}
	r.drawBatch();

	// glEnable(GL_BLEND);
	// glBlendFunc(GL_ONE, GL_ONE);

	r.setVertexDeclaration(VERTEX_PCT2);
	IVideoDriver::instance->setShaderProgram(lightTileProg);
	IVideoDriver::instance->setUniformInt("base_texture", 0);

	// Matrix viewProj = r.getViewProjection();
	IVideoDriver::instance->setUniform("projection", &viewProj);

	if(!tempLightSprite){
		tempLightSprite = new Sprite();
	}
	Sprite * lightSprite = tempLightSprite.get();
	float lightT = (sinf((float)getTimeMS() / 1000.0f * 0.5f) + 1.0f) / 2.0f;
	lightSprite->setColor(colorFromInt(0xff9d68) * (0.3f + 0.7f * lightT));
	lightSprite->setBlendMode(blend_add);

	RenderState rs;
	rs.renderer = &r;
	r.setBlendMode(blend_disabled);
	IVideoDriver::instance->setState(IVideoDriver::STATE_BLEND, 0);

	const float TILE_LIGHT_SIZE = TILE_SIZE * 0.5f;

	// if(false) // TODO: fix pos & scale using mapScale
	/* it = activeTilesXY.begin();
	for(; it != activeTilesXY.end(); ++it){
		const Point& p = *it;
		int x = p.x;
		int y = p.y; */
	for(int y = startY; y <= endY; y++){
		for(int x = startX; x <= endX; x++){
			struct Lib {
				static bool isEmptyLightTile(BaseGame4X * game, int x, int y)
				{
					TileType type = game->getFrontType(x, y);
					return type != TILE_TYPE_LIGHT_ROCK_01 && type != TILE_TYPE_LIGHT_ROCK_02;
				}
				static void render(RenderState& rs, Sprite * lightSprite, const vec2& pos, const vec2& mapScale, float scale)
				{
					lightSprite->setPosition((pos + mapScale * lightSprite->getPosition()) * scale);
					lightSprite->setScale(mapScale * lightSprite->getScale() * scale);
					lightSprite->render(rs);
				}
			};

			TileType type = getFrontType(x, y);
			if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER){
				vec2 pos = (tileToPos(x, y) - offs) * mapScale;
			
				bool top = Lib::isEmptyLightTile(this, x, y-1);
				bool bottom = Lib::isEmptyLightTile(this, x, y+1);
				bool left = Lib::isEmptyLightTile(this, x-1, y);
				bool right = Lib::isEmptyLightTile(this, x+1, y);
				bool leftTop = Lib::isEmptyLightTile(this, x-1, y-1);
				bool rightTop = Lib::isEmptyLightTile(this, x+1, y-1);
				bool leftBottom = Lib::isEmptyLightTile(this, x-1, y+1);
				bool rightBottom = Lib::isEmptyLightTile(this, x+1, y+1);

				if(!top){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-left"),
						angle = 90,
						// pos = vec2(0, 0),
						pivot = vec2(0, 1),
						opacity = opacity,
						parent = @shadow
					} */
					lightSprite->setResAnim(resources->getResAnim("tile-light-left"));
					lightSprite->setRotationDegrees(90.0f);
					lightSprite->setAnchor(0.0f, 1.0f);
					lightSprite->setY(0);
					float x = 0, size = TILE_SIZE;
					if(!left){
						x = TILE_LIGHT_SIZE;
						size = size - TILE_LIGHT_SIZE;
					}
					if(!right){
						size = size - TILE_LIGHT_SIZE;
					}
					lightSprite->setX(x);
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, size) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}		
				if(!bottom){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-left"),
						angle = -90,
						// pos = vec2(0, 0),
						y = TILE_SIZE,
						pivot = vec2(0, 0),
						opacity = opacity,
						parent = @shadow
					} */
					lightSprite->setResAnim(resources->getResAnim("tile-light-left"));
					lightSprite->setRotationDegrees(-90.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setY(TILE_SIZE);
					float x = 0.0f, size = TILE_SIZE;
					if(!left){
						x = TILE_LIGHT_SIZE;
						size = size - TILE_LIGHT_SIZE;
					}
					if(!right){
						size = size - TILE_LIGHT_SIZE;
					}
					lightSprite->setX(x);
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, size) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(!left){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-left"),
						angle = 0,
						// pos = vec2(0, 0),
						pivot = vec2(0, 0),
						opacity = opacity,
						parent = @shadow
					} */
					lightSprite->setResAnim(resources->getResAnim("tile-light-left"));
					lightSprite->setRotationDegrees(0.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setX(0);
					float y = 0.0f, size = TILE_SIZE;
					if(!top){
						y = TILE_LIGHT_SIZE;
						size = size - TILE_LIGHT_SIZE;
					}
					if(!bottom){
						size = size - TILE_LIGHT_SIZE;
					}
					lightSprite->setY(y);
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, size) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(!right){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-left"),
						angle = 180,
						// pos = vec2(0, 0),
						x = TILE_SIZE,
						pivot = vec2(0, 1),
						opacity = opacity,
						parent = @shadow
					} */
					lightSprite->setResAnim(resources->getResAnim("tile-light-left"));
					lightSprite->setRotationDegrees(180.0f);
					lightSprite->setAnchor(0.0f, 1.0f);
					lightSprite->setX(TILE_SIZE);
					float y = 0.0f, size = TILE_SIZE;
					if(!top){
						y = TILE_LIGHT_SIZE;
						size = size - TILE_LIGHT_SIZE;
					}
					if(!bottom){
						size = size - TILE_LIGHT_SIZE;
					}
					lightSprite->setY(y);
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, size) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(left && top && !leftTop){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-outer-left-top"),
						// pivot = vec2(0, 0),
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-outer-left-top"));
					lightSprite->setRotationDegrees(0.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(0.0f, 0.0f));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}else if(!left && !top){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-inner-left-top"),
						// pivot = vec2(0, 0),
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-inner-left-top"));
					lightSprite->setRotationDegrees(0.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(0.0f, 0.0f));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(right && top && !rightTop){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-outer-left-top"),
						pivot = vec2(0, 0),
						angle = 90,
						x = TILE_SIZE,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-outer-left-top"));
					lightSprite->setRotationDegrees(90.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(TILE_SIZE, 0.0f));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}else if(!right && !top){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-inner-left-top"),
						pivot = vec2(0, 0),
						angle = 90,
						x = TILE_SIZE,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-inner-left-top"));
					lightSprite->setRotationDegrees(90.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(TILE_SIZE, 0.0f));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(left && bottom && !leftBottom){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-outer-left-top"),
						// pivot = vec2(0, 0),
						y = TILE_SIZE,
						angle = -90,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-outer-left-top"));
					lightSprite->setRotationDegrees(-90.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(0.0f, TILE_SIZE));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}else if(!left && !bottom){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-inner-left-top"),
						// pivot = vec2(0, 0),
						y = TILE_SIZE,
						angle = -90,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-inner-left-top"));
					lightSprite->setRotationDegrees(-90.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(0.0f, TILE_SIZE));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
				if(right && bottom && !rightBottom){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-outer-left-top"),
						// pivot = vec2(0, 0),
						x = TILE_SIZE,
						y = TILE_SIZE,
						angle = 180,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-outer-left-top"));
					lightSprite->setRotationDegrees(180.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(TILE_SIZE, TILE_SIZE));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}else if(!right && !bottom){
					/* var fade = Sprite().attrs {
						resAnim = res.get("tile-fade-inner-left-top"),
						// pivot = vec2(0, 0),
						x = TILE_SIZE,
						y = TILE_SIZE,
						angle = 180,
						opacity = opacity,
						parent = @shadow,
					}
					fade.scale = vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / fade.size */
					lightSprite->setResAnim(resources->getResAnim("tile-light-inner-left-top"));
					lightSprite->setRotationDegrees(180.0f);
					lightSprite->setAnchor(0.0f, 0.0f);
					lightSprite->setPosition(vec2(TILE_SIZE, TILE_SIZE));
					lightSprite->setScale(vec2(TILE_LIGHT_SIZE, TILE_LIGHT_SIZE) / lightSprite->getSize());
					Lib::render(rs, lightSprite, pos, mapScale, lightScale);
				}
			}
		}
	}

	r.end();

	// updatePhysics(dt);
}

ShaderProgramGL * BaseGame4X::createShaderProgram(const char * _vs, const char * _fs, bvertex_format format)
{
	ShaderProgramGL * program = new ShaderProgramGL();
	
	int vs = ShaderProgramGL::createShader(GL_VERTEX_SHADER, _vs, 0, 0);
	int fs = ShaderProgramGL::createShader(GL_FRAGMENT_SHADER, _fs, 0, 0);

	/*
	char buf[1024];
	GLsizei len;
	
	glGetShaderInfoLog(vs, sizeof(buf)-1, &len, buf); buf[len] = 0;
	log::message("OpenGL vs shader info: %s\n", buf);
	
	glGetShaderInfoLog(fs, sizeof(buf)-1, &len, buf); buf[len] = 0;
	log::message("OpenGL fs shader info: %s\n", buf);
	*/

	VertexDeclarationGL * vdecl = (VertexDeclarationGL*)IVideoDriver::instance->getVertexDeclaration(format); // VERTEX_POSITION)
	OX_ASSERT(vdecl);
	int pr = ShaderProgramGL::createProgram(vs, fs, vdecl);
	program->init(pr);
	return program;
}

// =====================================================================
// =====================================================================
// =====================================================================

BaseGame4X::BaseGame4X()
{
	// PhysWorld::setToPhysScale(GAME_TO_PHYS_SCALE);

	// tiles = NULL;
	tiledmapWidth = 0;
	tiledmapHeight = 0;
	shadowMaskProg = NULL;
	lightProg = NULL;
	lightTileProg = NULL;
	lightTextureWidth = 0;
	lightTextureHeight = 0;
	lightScale = 0.0f;
	startViewX = startViewY = endViewX = endViewY = 0;
	startPhysX = startPhysY = endPhysX = endPhysY = 0;
	// afterDraggingMode = false;

	/*
	physAccumTimeSec = 0;
	physWorld = NULL;
	physContactShare = new PhysContact;
	*/
}

BaseGame4X::~BaseGame4X()
{
	// destroyPhysicsWorld();
	/*
	physDebugDraw = NULL;
	destroyAllBodies();
	delete physWorld;
	*/

	// delete [] tiles;
	delete shadowMaskProg;
	delete lightProg;
	delete lightTileProg;
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

Tile * BaseGame4X::getTile(int x, int y)
{
	/* x %= tiledmapWidth;
	if(x < 0){
		x = (x + tiledmapWidth) % tiledmapWidth;
	} */
	if(x >= 0 && x < tiledmapWidth
		&& y >= 0 && y < tiledmapHeight)
	{
		return &tiles[y * tiledmapWidth + x];
	}
	return NULL;
}

Bounds2 BaseGame4X::getTileAreaBounds(int ax, int ay, int bx, int by)
{
	float edge = 0.000001f;
	return Bounds2(
				vec2((float)ax * TILE_SIZE + edge, (float)ay * TILE_SIZE + edge), 
				vec2((float)(bx+1) * TILE_SIZE - edge, (float)(by+1) * TILE_SIZE - edge));
}

void BaseGame4X::boundsToTileArea(int& ax, int& ay, int& bx, int& by, const Bounds2& bounds)
{
	worldPosToPos(ax, ay, bounds.b[0]);
	worldPosToPos(bx, by, bounds.b[1]); bx--, by--;
}

void BaseGame4X::freePhysTileArea(spPhysTileArea physTileArea)
{
	physWorld->destroyBody(physTileArea->body);
	physTileArea->body = NULL;

	int ax, ay, bx, by;
	// boundsToTileArea(ax, ay, bx, by, physTileArea->bounds);
	ax = physTileArea->ax, bx = physTileArea->bx;
	ay = physTileArea->ay, by = physTileArea->by;
	for(int x = ax; x <= bx; x++){
		for(int y = ay; y <= by; y++){
			getTile(x, y)->physCreated = false;
		}
	}
}

bool BaseGame4X::freePhysTileAreasInBounds(const Bounds2& bounds)
{
	bool changed = false;
	std::vector<spPhysTileArea>::iterator it = physTileAreas.begin(), next_it;
	for(; it != physTileAreas.end(); it = next_it){
		next_it = it + 1;
		spPhysTileArea physTileArea = *it;
		if(physTileArea->bounds.intersectsBounds(bounds)){
			freePhysTileArea(physTileArea);
			next_it = physTileAreas.erase(it);
			changed = true;
		}
	}
	return changed;
}

void BaseGame4X::freeAllPhysTileAreas()
{
	std::vector<spPhysTileArea>::iterator it = physTileAreas.begin();
	for(; it != physTileAreas.end(); ++it){
		spPhysTileArea physTileArea = *it;
		freePhysTileArea(physTileArea);
	}
	physTileAreas.clear();
}

#define TILE_WORLD_ID_WIDTH 1000000

int BaseGame4X::getTileId(int x, int y)
{
	return y * TILE_WORLD_ID_WIDTH + x;
}

void BaseGame4X::tileIdToTilePos(int& x, int& y, int id)
{
	x = id % TILE_WORLD_ID_WIDTH;
	y = id / TILE_WORLD_ID_WIDTH;
}

void BaseGame4X::worldPosToPos(int& x, int& y, const vec2& pos)
{
	x = (int)(pos.x / TILE_SIZE + 0.5f);
	y = (int)(pos.y / TILE_SIZE + 0.5f);
}

TileType BaseGame4X::getFrontType(int x, int y)
{
	Tile * tile = getTile(x, y);
	return tile ? tile->front : TILE_TYPE_BLOCK;
}

void BaseGame4X::setFrontType(int x, int y, TileType type)
{
	Tile * tile = getTile(x, y);
	if(tile){
		EPhysTileType prevPhysType = tile->getPhysType();
		tile->front = type;
		if(prevPhysType != tile->getPhysType()){
			physTilesChanged[getTileId(x, y)] = true;
		}
	}
}

TileType BaseGame4X::getBackType(int x, int y)
{
	Tile * tile = getTile(x, y);
	return tile ? tile->back : TILE_TYPE_BLOCK;
}

void BaseGame4X::setBackType(int x, int y, TileType type)
{
	Tile * tile = getTile(x, y);
	if(tile){
		EPhysTileType prevPhysType = tile->getPhysType();
		tile->back = type;
		if(prevPhysType != tile->getPhysType()){
			physTilesChanged[getTileId(x, y)] = true;
		}
	}
}

ItemType BaseGame4X::getItemType(int x, int y)
{
	Tile * tile = getTile(x, y);
	return tile ? tile->item : 0;
}

void BaseGame4X::setItemType(int x, int y, ItemType type)
{
	Tile * tile = getTile(x, y);
	if(tile){
		EPhysTileType prevPhysType = tile->getPhysType();
		tile->item = type;
		if(prevPhysType != tile->getPhysType()){
			physTilesChanged[getTileId(x, y)] = true;
		}
	}
}

vec2 BaseGame4X::tileToCenterPos(int x, int y)
{
	return vec2((float)x * TILE_SIZE + TILE_SIZE/2, (float)y * TILE_SIZE + TILE_SIZE/2);
}

vec2 BaseGame4X::tileToPos(int x, int y)
{
	return vec2((float)x * TILE_SIZE, (float)y * TILE_SIZE);
}

void BaseGame4X::posToTile(const vec2& pos, int& x, int& y)
{
	x = (int)(pos.x / TILE_SIZE);
	y = (int)(pos.y / TILE_SIZE);
}

void BaseGame4X::posToCeilTile(const vec2& pos, int& x, int& y)
{
	x = (int)(pos.x / TILE_SIZE + 0.5f);
	y = (int)(pos.y / TILE_SIZE + 0.5f);
}

OS::String BaseGame4X::retrieveLevelData()
{
	struct Lib
	{
		static void encode(OS_BYTE * data, int i, int a)
		{
			OX_ASSERT(a >= 0 && a < 256);
			data[i*2] = (OS_BYTE)(a & 0xff);
			data[i*2+1] = (OS_BYTE)((a>>8) & 0xff);
		}
	};

	const char * dataPrefix = LEVEL_BIN_DATA_PREFIX;
	int dataPrefixLen = (int)OS_STRLEN(dataPrefix);
	int count = tiledmapWidth * tiledmapHeight;
	OS_BYTE * data = new OS_BYTE[count*2*3 + dataPrefixLen];
	OX_ASSERT(data);
	OS_MEMCPY(data, dataPrefix, dataPrefixLen); 
	
	OS_BYTE * front = data + dataPrefixLen;
	OS_BYTE * back = front + count*2;
	OS_BYTE * items = back + count*2;
	for(int i = 0; i < count; i++){
		Lib::encode(front, i, tiles[i].front);
		Lib::encode(back, i, tiles[i].back);
		Lib::encode(items, i, tiles[i].item);
	}
	OS::String str(os, (const void*)data, count*2*3 + dataPrefixLen);
	delete [] data;
	return str;
}

void BaseGame4X::registerLevelData(int p_tiledmapWidth, int p_tiledmapHeight, const OS::String& p_data)
{
	struct Lib
	{
		static int decode(OS_BYTE * data, int i)
		{
			int a = data[i*2] + (data[i*2+1]<<8);
			OX_ASSERT(a >= 0 && a < 256);
			return a;
		}
	};

	// delete [] tiles;
	tiles.clear();
	OS_BYTE * data = (OS_BYTE*)p_data.toChar();
	const char * dataPrefix = LEVEL_BIN_DATA_PREFIX;
	int dataPrefixLen = (int)OS_STRLEN(dataPrefix);
	int count = p_tiledmapWidth * p_tiledmapHeight;
	if(count*2*3 + dataPrefixLen != p_data.getDataSize() || OS_STRNCMP((char*)data, dataPrefix, dataPrefixLen) != 0){
		os->setException("error layer data");
		// tiles = NULL;
		tiledmapWidth = tiledmapHeight = 0;
		return;
	}
	tiledmapWidth = p_tiledmapWidth;
	tiledmapHeight = p_tiledmapHeight;
	// tiles = new Tile[count];
	tiles.reserve(count);

	OS_BYTE * front = data + dataPrefixLen;
	OS_BYTE * back = front + count*2;
	OS_BYTE * items = back + count*2;

	Tile tile;
	std::map<TileType, bool> usedTiles;
	std::map<ItemType, bool> usedItems;
	for(int i = 0; i < count; i++){
		tile.front = (TileType)Lib::decode(front, i);
		tile.back = (TileType)Lib::decode(back, i);
		tile.item = (ItemType)Lib::decode(items, i);
		tile.physCreated = false;
		usedTiles[tile.front] = true;
		usedTiles[tile.back] = true;
		usedItems[tile.item] = true;
		tiles.push_back(tile);
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

Actor * BaseGame4X::getMapLayer(int num)
{
	SaveStackSize saveStackSize;
	pushCtypeValue(os, this);
	os->getProperty("mapLayers");
	pushCtypeValue(os, num);
	os->getProperty();
	return CtypeValue<Actor*>::getArg(os, -1);
}

/*
void BaseGame4X::addEntityPhysicsShapes(BasePhysEntity * ent)
{
	ObjectScript::SaveStackSize saveStackSize;
	ObjectScript::OS * os = ObjectScript::os;

	OX_ASSERT(ent->game && ent->body);

	b2CircleShape circleShape;
	b2PolygonShape polyShape;
	b2FixtureDef fixtureDef;

	if(!os->isObject()){
		os->setException("object required");
		os->handleException();
		return;
	}

	os->getProperty(-1, "shapes");
	if(!os->isNull()){
		if(!os->isArray()){
			os->setException("array required for shapes");
			os->handleException();
			return;
		}
		while(os->nextIteratorStep()){
			addEntityPhysicsShapes(ent);
			os->pop(2);
		}
	}else{
		os->pop(); // pop shapes

		os->getProperty(-1, "radius");
		if(!os->isNull()){
			fixtureDef.shape = &circleShape;
			circleShape.m_radius = toPhysValue(os->popFloat());
		}else{
			os->pop(); // pop radius
			os->getProperty(-1, "radiusScale");
			if(!os->isNull()){
				fixtureDef.shape = &circleShape;
				vec2 size = ent->getSize();
				circleShape.m_radius = toPhysValue((size.x > size.y ? size.x : size.y) / 2 * os->popFloat());
			}else{
				os->pop(); // pop radiusScale
				fixtureDef.shape = &polyShape;
				b2Vec2 halfSize = toPhysVec(ent->getSize() / 2);
				halfSize.x *= (os->getProperty(-1, "widthScale"), os->popFloat(1.0f));
				halfSize.y *= (os->getProperty(-1, "heightScale"), os->popFloat(1.0f));
				polyShape.SetAsBox(halfSize.x, halfSize.y);
			}
		}
		fixtureDef.density = (os->getProperty(-1, "density"), os->popFloat(ent->getPhysicsFloat("density", PHYS_DEF_DENSITY)));
		fixtureDef.restitution = (os->getProperty(-1, "restitution"), os->popFloat(ent->getPhysicsFloat("restitution", PHYS_DEF_RESTITUTION)));
		fixtureDef.friction = (os->getProperty(-1, "friction"), os->popFloat(ent->getPhysicsFloat("friction", PHYS_DEF_FRICTION)));
		fixtureDef.isSensor = (os->getProperty(-1, "sensor"), os->popBool(ent->getPhysicsBool("sensor", false)));
		fixtureDef.filter.categoryBits = (os->getProperty(-1, "categoryBits"), os->popInt(ent->getPhysicsInt("categoryBits", fixtureDef.filter.categoryBits)));
		fixtureDef.filter.maskBits = (os->getProperty(-1, "maskBits"), os->popInt(ent->getPhysicsInt("maskBits", fixtureDef.filter.maskBits)));
		
		int ignoreBits = (os->getProperty(-1, "ignoreBits"), os->popInt(ent->getPhysicsInt("ignoreBits", 0)));
		fixtureDef.filter.maskBits &= ~ ignoreBits;

		os->getProperty(-1, "fly");
		if(os->toBool()){
			// fixtureDef.filter.maskBits &= ~ PHYS_CAT_BIT_WATER;
		}
		os->pop();

		ent->body->CreateFixture(&fixtureDef);
	}
}

b2BodyDef BaseGame4X::getPlayerWheelDef(const vec2& pos)
{
	b2BodyDef bodyDef;
	bodyDef.position = toPhysVec(pos);
	bodyDef.linearDamping = PHYS_PLAYER_LINEAR_DAMPING;
	bodyDef.angularDamping = PHYS_PLAYER_ANGULAR_DAMPING;
	bodyDef.allowSleep = false;
	return bodyDef;
}
*/

void BaseGame4X::addDebugMessage(const char * message)
{
	pushCtypeValue(os, this);
	os->getProperty(-1, "addDebugMessage");
	pushCtypeValue(os, message);
	os->callTF(1);
}

void BaseGame4X::queryTilePhysics(int ax, int ay, int bx, int by, float time)
{
	struct Lib
	{
		static bool isTileEmpty(BaseGame4X * game, int x, int y)
		{
			Tile * tile = game->getTile(x, y);
			if(tile){
				EPhysTileType physTileType = tile->getPhysType();
				switch(physTileType){
				case PHYS_EMPTY:
					return true;
				/* case PHYS_GROUND:
					return false;
				}
				return true; */
				}
			}
			return false;
		}
	};

	if(ax < 0) ax = 0; else if(ax >= tiledmapWidth) ax = tiledmapWidth-1;
	if(bx < 0) bx = 0; else if(bx >= tiledmapWidth) bx = tiledmapWidth-1;

	if(ay < 0) ay = 0; else if(ay >= tiledmapHeight) ay = tiledmapHeight-1;
	if(by < 0) by = 0; else if(by >= tiledmapHeight) by = tiledmapHeight-1;

	for(int y = ay; y <= by; y++){
		for(int x = ax; x <= bx; x++){
			Tile * tile = getTile(x, y);
			EPhysTileType physTileType = tile->getPhysType();
			if(tile->physCreated){
				continue;
			}
			if(physTileType == PHYS_EMPTY){
				if(Lib::isTileEmpty(this, x-1, y) && Lib::isTileEmpty(this, x+1, y)
					&& !Lib::isTileEmpty(this, x-1, y+1) && !Lib::isTileEmpty(this, x+1, y+1)
					&& Lib::isTileEmpty(this, x, y+1))
				{
					spPhysTileArea block = new PhysTileArea();
					block->time = time;
					block->type = PHYS_PIT;
					block->ax = x-1, block->ay = y;
					block->bx = x+1, block->by = y+1;
					block->bounds = getTileAreaBounds(block->ax, block->ay, block->bx, block->by);
					block->physBounds = Bounds2(
						vec2(((float)x - 0.0f) * TILE_SIZE, ((float)y + 1.0f) * TILE_SIZE), 
						vec2((float)(x + 1.0f) * TILE_SIZE, ((float)y + 1.5f) * TILE_SIZE));
					physTileAreas.push_back(block);
					for(int ax = block->ax; ax <= block->bx; ax++){
						for(int ay = block->ay; ay <= block->by; ay++){
							Tile * tile = getTile(ax, ay);
							if(tile && tile->getPhysType() == PHYS_EMPTY){
								tile->physCreated = true;
							}
						}
					}
				}				
				continue;
			}
			int max_x = bx, max_y = by;
			for(int ax = x+1; ax <= max_x; ax++){
				Tile * ac = getTile(ax, y);
				if(ac->physCreated || ac->getPhysType() != physTileType){
					max_x = ax-1;
					break;
				}
			}
			if(physTileType == PHYS_LADDER){
				max_y = tiledmapHeight-1;
			}
			for(int ay = y+1; ay <= max_y; ay++){
				bool isOk = true;
				for(int ax = x; ax <= max_x; ax++){
					Tile * ac = getTile(ax, ay);
					if(ac->physCreated || ac->getPhysType() != physTileType){
						isOk = false;
						break;
					}
				}
				if(!isOk){
					max_y = ay-1;
					break;
				}
			}
			int tx = x, ty = y;
			if(physTileType == PHYS_LADDER){
				for(ty = y-1; ty >= 0; ty--){
					bool isOk = true;
					for(int ax = x; ax <= max_x; ax++){
						Tile * ac = getTile(ax, ty);
						if(ac->physCreated || ac->getPhysType() != physTileType){
							isOk = false;
							break;
						}
					}
					if(!isOk){
						// ay++;
						break;
					}
				}
				ty++;
			}
			spPhysTileArea block = new PhysTileArea();
			block->time = time;
			block->type = physTileType;
			block->ax = tx, block->ay = ty;
			block->bx = max_x, block->by = max_y;
			block->bounds = block->physBounds = getTileAreaBounds(block->ax, block->ay, block->bx, block->by);
			physTileAreas.push_back(block);
			
			for(int ax = tx; ax <= max_x; ax++){
				for(int ay = ty; ay <= max_y; ay++){
					getTile(ax, ay)->physCreated = true;
				}
			}
		}
	}
	
	// Bounds2 bounds = getTileAreaBounds(ax, ay, bx, by);
	int numDeletedByBounds = 0, numCreated = 0;
	std::vector<spPhysTileArea>::iterator it = physTileAreas.begin(), next_it;
	for(; it != physTileAreas.end(); it = next_it){
		next_it = it + 1;
		spPhysTileArea physTileArea = *it;
		if(physTileArea->body){
			if(!physPlayerBounds.intersectsBounds(physTileArea->bounds) 
				&& (!physDraggingBoundsUsed || !physDraggingBounds.intersectsBounds(physTileArea->bounds)))
			{
				freePhysTileArea(physTileArea);
				next_it = physTileAreas.erase(it);
				numDeletedByBounds++;
				// addDebugMessage("delete phys area by bounds");
			}else{
				physTileArea->time = time;
			}
			continue;
		}
		
		Bounds2 physBounds = physTileArea->physBounds;
		spPhysFixtureDef fixtureDef = new PhysFixtureDef();
		switch(physTileArea->type){
		case PHYS_LADDER:
			fixtureDef->setCategoryBits(PHYS_CAT_BIT_LADDER);
			fixtureDef->setIsSensor(true);
			physBounds.expand(-TILE_SIZE * 0.4f);
			physBounds.b[0].y -= TILE_SIZE * 0.8f;
			break;

		case PHYS_PLATFORM:
			fixtureDef->setCategoryBits(PHYS_CAT_BIT_PLATFORM);
			break;

		case PHYS_PIT:
			fixtureDef->setCategoryBits(PHYS_CAT_BIT_PIT);
			fixtureDef->setIsSensor(true);
			break;

		default:
			fixtureDef->setCategoryBits(PHYS_CAT_BIT_GROUND);
			break;
		}
		spPhysBodyDef bodyDef = new PhysBodyDef();
		bodyDef->setType(b2_staticBody);
		bodyDef->setPos((physBounds.b[0] + physBounds.b[1]) / 2);
		physTileArea->body = physWorld->createBody(bodyDef);
		
		fixtureDef->setType(b2Shape::e_polygon);
		fixtureDef->setPolygonAsBox((physBounds.b[1] - physBounds.b[0]) / 2);
		fixtureDef->setFriction(0.99f);
		physTileArea->body->createFixture(fixtureDef);
		numCreated++;
		// addDebugMessage("add phys area");
	}
	if(numDeletedByBounds || numCreated){
		char buf[1024];
		sprintf(buf, "phys area: +%d -%d", numCreated, numDeletedByBounds);
		// addDebugMessage(buf);
	}
}

EPhysTileType Tile::getPhysType() const
{
	switch(front){
	case TILE_TYPE_DOOR_01:
	case TILE_TYPE_EMPTY: return PHYS_EMPTY;
	case TILE_TYPE_LADDER: return PHYS_LADDER;
	}
	return PHYS_GROUND;
}

/*
void BaseGame4X::initEntityPhysics(BasePhysEntity * ent)
{
	ObjectScript::SaveStackSize saveStackSize;
	ObjectScript::OS * os = ObjectScript::os;
	
	if(ent->game || ent->body){
		os->setException("entity physics is already initialized");
		os->handleException();
		return;
	}
	ent->game = this;
	// entities.push_back(ent);

	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = toPhysVec(ent->getPosition());
	bodyDef.angle = ent->getRotation();
	bodyDef.fixedRotation = getOSChildPhysicsBool(ent, "fixedRotation", PHYS_DEF_FIXED_ROTATION);
	bodyDef.linearDamping = getOSChildPhysicsFloat(ent, "linearDamping", PHYS_DEF_LINEAR_DAMPING);
	bodyDef.angularDamping = getOSChildPhysicsFloat(ent, "angularDamping", PHYS_DEF_ANGULAR_DAMPING);

	ent->body = physWorld->CreateBody(&bodyDef);
	ent->body->SetUserData(ent);

	ObjectScript::pushCtypeValue(os, ent);
	os->getProperty(-1, "physics");

	addEntityPhysicsShapes(ent);
}

void BaseGame4X::destroyEntityPhysics(BasePhysEntity * ent)
{
	if(!ent->body){
		return;
	}
	OX_ASSERT(ent->game == this);
	OX_ASSERT(ent->body);
	
	b2Fixture * fixture = ent->body->GetFixtureList();
	while(fixture){
		ent->body->DestroyFixture(fixture);
		fixture = ent->body->GetFixtureList();
	}
#if 0
	b2JointEdge * joint = ent->body->GetJointList();
	while(fixture){
		physWorld->DestroyJoint(joint);
		joint = ent->body->GetJointList();
	}
#endif

	OX_ASSERT(std::find(waitBodiesToDestroy.begin(), waitBodiesToDestroy.end(), ent->body) == waitBodiesToDestroy.end());
	waitBodiesToDestroy.push_back(ent->body);

	ent->body->SetUserData(NULL);
	ent->body = NULL;
	ent->game = NULL;
}

void BaseGame4X::destroyWaitBodies()
{
	if(!waitBodiesToDestroy.size()){
		return;
	}
	OX_ASSERT(physWorld);

	std::vector<b2Body*> waitBodiesToDestroy = this->waitBodiesToDestroy;
	this->waitBodiesToDestroy.clear();

	std::vector<b2Body*>::iterator it = waitBodiesToDestroy.begin();
	for(; it != waitBodiesToDestroy.end(); ++it){
		b2Body * body = *it;
		OX_ASSERT(!body->GetUserData());
		physWorld->DestroyBody(body);
	}
}

void BaseGame4X::destroyAllBodies()
{
	if(!physWorld){
		return;
	}
	b2Body * body = physWorld->GetBodyList(), * next = NULL;
	for(; body; body = next){
		next = body->GetNext();
		BasePhysEntity * ent = dynamic_cast<BasePhysEntity*>((Object*)body->GetUserData());
		if(ent){
			OX_ASSERT(ent->game == this);
			OX_ASSERT(ent->body == body);
			ent->body->SetUserData(NULL);
			ent->body = NULL;
			ent->game = NULL;
		}else{
			PhysTileArea * area = dynamic_cast<PhysTileArea*>((Object*)body->GetUserData());
			if(area){
				area->body->SetUserData(NULL);
				area->body = NULL;
			}
		}
		physWorld->DestroyBody(body);
	}
	freeAllPhysTileAreas();
}

void BaseGame4X::updatePhysics(float dt)
{
	if(!physWorld){
		return;
	}
	destroyWaitBodies();

	physAccumTimeSec += dt;
	dt = 1.0f/30.0f;
	while(physAccumTimeSec >= dt){ 
		physWorld->Step(dt, 6, 2);
		dispatchContacts();
		physAccumTimeSec -= dt;
	}

	b2Body * body = physWorld->GetBodyList();
	for(; body; body = body->GetNext()){
		BasePhysEntity * ent = dynamic_cast<BasePhysEntity*>((Object*)body->GetUserData());
		if(ent){
			OX_ASSERT(ent->body == body && ent->game == this);
			ent->setPosition(fromPhysVec(body->GetPosition()));
			ent->setRotation(body->GetAngle());
		}
	}
}

void BaseGame4X::dispatchContacts()
{
	ObjectScript::OS * os = ObjectScript::os;
	std::vector<PhysContact::Data>::iterator it = physContacts.begin();
	for(; it != physContacts.end(); ++it){
		PhysContact::Data& c = *it;
		if(c.ent[0]){
			ObjectScript::pushCtypeValue(os, c.ent[0]); // this
			os->getProperty(-1, "onPhysicsContact"); // func
			OX_ASSERT(os->isFunction());
			ObjectScript::pushCtypeValue(os, physContactShare->with(c));
			os->pushNumber(1);
			os->callTF(2, 1);
			if(os->popBool()){
				return;
			}
		}
		if(c.ent[1]){
			ObjectScript::pushCtypeValue(os, c.ent[1]); // this
			os->getProperty(-1, "onPhysicsContact"); // func
			OX_ASSERT(os->isFunction());
			ObjectScript::pushCtypeValue(os, physContactShare->with(c));
			os->pushNumber(0);
			os->callTF(2);
		}
	}
	physContactShare->data.reset();
	physContacts.clear();
}

void BaseGame4X::BeginContact(b2Contact* c)
{
	PhysContact::Data data;
	for(int i = 0; i < 2; i++){
		b2Fixture * fixture = i ? c->GetFixtureB() : c->GetFixtureA();
		data.ent[i] = dynamic_cast<BasePhysEntity*>((Object*)fixture->GetBody()->GetUserData());
		data.filter[i] = fixture->GetFilterData();
		data.isSensor[i] = fixture->IsSensor();
	}
	physContacts.push_back(data);
}

void BaseGame4X::EndContact(b2Contact* contact)
{
}

void BaseGame4X::createPhysicsWorld()
{

	physWorld = new PhysWorld();
}

void BaseGame4X::destroyPhysicsWorld()
{
	if(physWorld){
		physWorld->destroy();
		physWorld = NULL;
	}
}
*/

bool BaseGame4X::getPhysDebugDraw() const
{
	return physDebugDraw;
}

void BaseGame4X::setPhysDebugDraw(bool value)
{
	if((bool)physDebugDraw != value){
		if(value){
			Actor * map = getOSChild("map"); OX_ASSERT(map);
			physDebugDraw = new Box2DDraw(this);
			physDebugDraw->SetFlags(b2Draw::e_shapeBit | b2Draw::e_jointBit | b2Draw::e_pairBit | b2Draw::e_centerOfMassBit);
			physDebugDraw->setPriority(10000);
			physDebugDraw->attachTo(map);
			// physDebugDraw->setWorld(1/PHYS_SCALE, physWorld);
		}else{
			physDebugDraw->detach();
			physDebugDraw = NULL;
		}
	}
}

void BaseGame4X::drawPhysShape(b2Fixture* fixture, const b2Transform& xf, const b2Color& color)
{
	switch (fixture->GetType())
	{
	case b2Shape::e_circle:
		{
			b2CircleShape* circle = (b2CircleShape*)fixture->GetShape();

			b2Vec2 center = b2Mul(xf, circle->m_p);
			float32 radius = circle->m_radius;
			b2Vec2 axis = b2Mul(xf.q, b2Vec2(1.0f, 0.0f));

			physDebugDraw->DrawSolidCircle(center, radius, axis, color);
		}
		break;

	case b2Shape::e_edge:
		{
			b2EdgeShape* edge = (b2EdgeShape*)fixture->GetShape();
			b2Vec2 v1 = b2Mul(xf, edge->m_vertex1);
			b2Vec2 v2 = b2Mul(xf, edge->m_vertex2);
			physDebugDraw->DrawSegment(v1, v2, color);
		}
		break;

	case b2Shape::e_chain:
		{
			b2ChainShape* chain = (b2ChainShape*)fixture->GetShape();
			int32 count = chain->m_count;
			const b2Vec2* vertices = chain->m_vertices;

			b2Vec2 v1 = b2Mul(xf, vertices[0]);
			for (int32 i = 1; i < count; ++i)
			{
				b2Vec2 v2 = b2Mul(xf, vertices[i]);
				physDebugDraw->DrawSegment(v1, v2, color);
				physDebugDraw->DrawCircle(v1, 0.05f, color);
				v1 = v2;
			}
		}
		break;

	case b2Shape::e_polygon:
		{
			b2PolygonShape* poly = (b2PolygonShape*)fixture->GetShape();
			int32 vertexCount = poly->m_count;
			b2Assert(vertexCount <= b2_maxPolygonVertices);
			b2Vec2 vertices[b2_maxPolygonVertices];

			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, poly->m_vertices[i]);
			}

			physDebugDraw->DrawSolidPolygon(vertices, vertexCount, color);
		}
		break;
            
    default:
        break;
	}
}

void BaseGame4X::drawPhysJoint(b2Joint* joint)
{
	b2Body* bodyA = joint->GetBodyA();
	b2Body* bodyB = joint->GetBodyB();
	const b2Transform& xf1 = bodyA->GetTransform();
	const b2Transform& xf2 = bodyB->GetTransform();
	b2Vec2 x1 = xf1.p;
	b2Vec2 x2 = xf2.p;
	b2Vec2 p1 = joint->GetAnchorA();
	b2Vec2 p2 = joint->GetAnchorB();

	b2Color color(0.5f, 0.8f, 0.8f);

	switch (joint->GetType())
	{
	case e_distanceJoint:
		physDebugDraw->DrawSegment(p1, p2, color);
		break;

	case e_pulleyJoint:
		{
			b2PulleyJoint* pulley = (b2PulleyJoint*)joint;
			b2Vec2 s1 = pulley->GetGroundAnchorA();
			b2Vec2 s2 = pulley->GetGroundAnchorB();
			physDebugDraw->DrawSegment(s1, p1, color);
			physDebugDraw->DrawSegment(s2, p2, color);
			physDebugDraw->DrawSegment(s1, s2, color);
		}
		break;

	case e_mouseJoint:
		// don't draw this
		break;

	default:
		physDebugDraw->DrawSegment(x1, p1, color);
		physDebugDraw->DrawSegment(p1, p2, color);
		physDebugDraw->DrawSegment(x2, p2, color);
	}
}

void BaseGame4X::drawPhysics()
{
	if(!physDebugDraw || !physWorld){
		return;
	}

	uint32 flags = physDebugDraw->GetFlags();

	if (flags & b2Draw::e_shapeBit)
	{
		for (b2Body* b = physWorld->getCore()->GetBodyList(); b; b = b->GetNext())
		{
			const b2Transform& xf = b->GetTransform();
			for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext())
			{
				b2Filter filter = f->GetFilterData();
				if (b->IsActive() == false)
				{
					drawPhysShape(f, xf, b2Color(0.5f, 0.5f, 0.3f));
				}
				else if (b->GetType() == b2_staticBody)
				{
					b2Color color(0.4f, 0.65f, 0.4f);
					if(filter.categoryBits & PHYS_CAT_BIT_LADDER){
						color = b2Color(0.68f, 0.46f, 0.12f);
					}else if(filter.categoryBits & PHYS_CAT_BIT_PLATFORM){
						color = b2Color(0.68f, 0.46f, 0.12f);
					}else if(filter.categoryBits & PHYS_CAT_BIT_PIT){
						color = b2Color(0.48f, 0.46f, 0.68f);
					}
					drawPhysShape(f, xf, color);
				}
				else if (b->GetType() == b2_kinematicBody)
				{
					drawPhysShape(f, xf, b2Color(0.5f, 0.5f, 0.9f));
				}
				else if (b->IsAwake() == false)
				{
					drawPhysShape(f, xf, b2Color(0.6f, 0.6f, 0.6f));
				}
				else
				{
					drawPhysShape(f, xf, b2Color(0.9f, 0.7f, 0.7f));
				}
			}
		}
	}

	if (flags & b2Draw::e_jointBit)
	{
		for (b2Joint* j = physWorld->getCore()->GetJointList(); j; j = j->GetNext())
		{
			drawPhysJoint(j);
		}
	}

	if (flags & b2Draw::e_pairBit)
	{
		b2Color color(0.3f, 0.9f, 0.9f);
		for (b2Contact* c = physWorld->getCore()->GetContactList(); c; c = c->GetNext())
		{
			//b2Fixture* fixtureA = c->GetFixtureA();
			//b2Fixture* fixtureB = c->GetFixtureB();

			//b2Vec2 cA = fixtureA->GetAABB().GetCenter();
			//b2Vec2 cB = fixtureB->GetAABB().GetCenter();

			//physDebugDraw->DrawSegment(cA, cB, color);
		}
	}

	/* if (flags & b2Draw::e_aabbBit)
	{
		b2Color color(0.9f, 0.3f, 0.9f);
		b2BroadPhase* bp = &physWorld->GetContactManager().m_broadPhase;

		for (b2Body* b = physWorld->GetBodyList(); b; b = b->GetNext())
		{
			if (b->IsActive() == false)
			{
				continue;
			}

			for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext())
			{
				for (int32 i = 0; i < f->m_proxyCount; ++i)
				{
					b2FixtureProxy* proxy = f->m_proxies + i;
					b2AABB aabb = bp->GetFatAABB(proxy->proxyId);
					b2Vec2 vs[4];
					vs[0].Set(aabb.lowerBound.x, aabb.lowerBound.y);
					vs[1].Set(aabb.upperBound.x, aabb.lowerBound.y);
					vs[2].Set(aabb.upperBound.x, aabb.upperBound.y);
					vs[3].Set(aabb.lowerBound.x, aabb.upperBound.y);

					physDebugDraw->DrawPolygon(vs, 4, color);
				}
			}
		}
	} */

	if (flags & b2Draw::e_centerOfMassBit)
	{
		for (b2Body* b = physWorld->getCore()->GetBodyList(); b; b = b->GetNext())
		{
			b2Transform xf = b->GetTransform();
			xf.p = b->GetWorldCenter();
			physDebugDraw->DrawTransform(xf);
		}
	}
}

/*
void BaseGame4X::SayGoodbye(b2Joint* joint)
{
}

void BaseGame4X::SayGoodbye(b2Fixture* fixture)
{
}
*/
