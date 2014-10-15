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

static void registerBaseLightLayer(OS * os)
{
	struct Lib {
		static BaseLightLayer * __newinstance()
		{
			return new BaseLightLayer();
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
	registerOXClass<BaseLightLayer, Actor>(os, funcs, nums, true OS_DBG_FILEPOS);
}
static bool __registerBaseLightLayer = addRegFunc(registerBaseLightLayer);

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
		DEF_GET("numLights", BaseGame4X, NumLights),
		def("getLight", &BaseGame4X::getLight),
		def("addLight", &BaseGame4X::addLight),
		def("removeLight", &BaseGame4X::removeLight),
		def("updateLightLayer", &BaseGame4X::updateLightLayer),
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

BaseLightLayer::BaseLightLayer()
{
	// lightProgram = NULL;
	// blendProgram = NULL;
	setTouchEnabled(false);
	setTouchChildrenEnabled(false);
}

BaseLightLayer::~BaseLightLayer()
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

void BaseGame4X::updateLightLayer(BaseLightLayer * lightLayer)
{
	vec2 size = getSize();
	if(!lightProg){
#if defined _WIN32 && 0
		Point displaySize = core::getDisplaySize();
		float displayWidthScale = (float)displaySize.x / getWidth();
		float displayHeightScale = (float)displaySize.y / getHeight();
		lightScale = MathLib::max(displayWidthScale, displayHeightScale);
#else
		lightScale = 1.0f / 2.0f;
#endif

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
			uniform mediump vec4 color;\
			void main() { \
				gl_FragColor = color; \
			} \
			";

		shadowMaskProg = createShaderProgram(shadowMaskVS, shadowMaskFS, VERTEX_POSITION);
		
		const char* lightVS = "\
			varying vec4 result_color; \
			varying vec2 result_uv; \
			varying vec2 result_uv2; \
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
			varying vec4 result_color; \
			varying vec2 result_uv; \
			varying vec2 result_uv2; \
			\
			uniform sampler2D base_texture; \
			uniform sampler2D shadow_texture; \
			\
			void main() { \
				vec4 base = texture2D(base_texture, result_uv); \
				vec4 shadow = texture2D(shadow_texture, result_uv2); \
				gl_FragColor = base * shadow * result_color; \
			} \
			";

		lightProg = createShaderProgram(lightVS, lightFS, VERTEX_PCT2T2);

		Diffuse df;
		df.base = lightTexture;
		
		AnimationFrame frame;
		frame.init(0, df,
			RectF(0, 0, (float)lightTextureWidth / lightTexture->getWidth(), (float)lightTextureHeight / lightTexture->getHeight()), 
			RectF(vec2(0, 0), size), size);

		lightLayer->setAnimFrame(frame);		
		lightLayer->setBlendMode(blend_multiply);
		
		os->getGlobal("res");
		resources = CtypeValue<Resources*>::getArg(os, -1);
		os->pop();
		OX_ASSERT(resources);
	}

	Actor * player = getOSChild("player"); OX_ASSERT(player);
	vec2 playerPos = player->getPosition();

	Actor * view = getOSChild("view"); OX_ASSERT(view);
	vec2 viewPos = view->getPosition();
	vec2 viewScale = view->getScale();

	int startX, startY;
	vec2 offs = -viewPos / viewScale;
	posToTile(offs, startX, startY);

	int endX, endY;
	vec2 endOffs = offs + size / viewScale;
	posToCeilTile(endOffs, endX, endY);

	vec2 lightTextureSize((float)lightTextureWidth, (float)lightTextureHeight);

	MyRenderer r;	
	r.initCoordinateSystem(lightTextureWidth, lightTextureHeight, true);
	
	Matrix viewProj = r.getViewProjection();
	Rect viewport(Point(0, 0), Point(lightTextureWidth, lightTextureHeight));

#if 1
	/*
	std::vector<LightInfo> lights;
	
	// LightFormInfo lightFormInfo(OS::String(os, "light-02"), (0.2f, 0.2f, 0.2f), 1.5f);
	LightFormInfo lightFormInfo(OS::String(os, "light-01"), (0.1f, 0.1f, 0.1f), 1.5f);

	lights.push_back(LightInfo(
			vec2(playerPos + vec2(TILE_SIZE * os->getRand(-0.02f, 0.02f), TILE_SIZE * os->getRand(-0.02f, 0.02f))),
			2.5f * os->getRand(0.97f, 1.03f), vec3(0.8f, 1.0f, 1.0f), lightFormInfo
		));

	bool lightItems = false;
	if(lightItems)
	for(int y = startY; y <= endY; y++){
		for(int x = startX; x <= endX; x++){
			ItemType type = getItemType(x, y);
			if(!type){
				continue;
			}
			vec3 color(0.5f, 0.5f, 0.5f);
			switch(type){
			default:
				continue;

			case 1:
				color = colorFromInt(0xfcb251);
				break;

			case 2:
				color = colorFromInt(0x60c983);
				break;

			case 3:
				color = colorFromInt(0x8fb9db);
				break;

			case 4:
				color = colorFromInt(0x7ddb3d);
				break;

			case 5:
				color = colorFromInt(0xf95a4a);
				break;

			case 6:
				color = colorFromInt(0xff9c53);
				break;

			case 7:
				color = colorFromInt(0x65686c);
				break;

			case 8:
				color = colorFromInt(0xefc7ac);
				break;

			case 9:
				color = colorFromInt(0xcfce55);
				break;

			case 10:
				color = colorFromInt(0xfbec9d);
				break;
			}
			vec2 pos = tileToCenterPos(x, y);
			lights.push_back(LightInfo(
					vec2(pos + vec2(TILE_SIZE * os->getRand(-0.02f, 0.02f), TILE_SIZE * os->getRand(-0.02f, 0.02f))),
					0.9f * os->getRand(0.97f, 1.03f), color, lightFormInfo
				));
		}
	}
	*/

	/*
	int tileAreaWidth = endX - startX + 1;
	int tileAreaHeight = endY - startY + 1;
	int tileAreaCount = tileAreaWidth * tileAreaHeight;
	lightVolume.resize(tileAreaCount);
	*/

	activeTilesXY.clear();

	pushCtypeValue(os, this);
	os->getProperty("tiles");
	while(os->nextIteratorStep()){
		int x = (os->getProperty(-1, "tileX"), os->popInt());
		int y = (os->getProperty(-1, "tileY"), os->popInt());
		activeTilesXY.push_back(Point(x, y));
		os->pop(2);
	}
	os->pop();


	for(int i = 0; i < (int)lights.size(); i++){
		spBaseLight light = lights[i];
		float radius = light->radius; // tileRadius * light->tileRadiusScale * TILE_SIZE;
		if(radius <= 0.0f){
			continue;
		}
		vec2 lightScreenPos = light->pos - offs;

		/*
		std::vector<OS_BYTE>::iterator it = lightVolume.begin();
		for(; it != lightVolume.end(); ++it){
			*it = 0;
		}
		
		OX_ASSERT(tx >= startX && tx <= endX && ty >= startY && ty <= endY);
		lightVolume[(tx - startX) + (ty - startY) * tileAreaWidth] = 1;
		for(int y = ty; y <= endY; y++){
			for(int x = tx; x <= endX; x++){
				TileType type = getFrontType(x, y);
				if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS || type == TILE_TYPE_DOOR_01){
					lightVolume[(x - startX) + (y - startY) * tileAreaWidth] = 1;
					continue;
				}
			}
		}
		*/

		r.begin(shadowMaskTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));
		// r.begin(lightTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));

		IVideoDriver::instance->setShaderProgram(shadowMaskProg);
		IVideoDriver::instance->setUniform("projection", &viewProj);
		setUniformColor("color", light->shadowColor);

		int tx, ty;
		posToTile(light->pos, tx, ty);
		TileType type = getFrontType(tx, ty);
		if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS || type == TILE_TYPE_DOOR_01){
			std::vector<Point>::iterator it = activeTilesXY.begin();
			for(; it != activeTilesXY.end(); ++it){
				const Point& p = *it;
				int x = p.x;
				int y = p.y;
		// for(int y = startY; y <= endY; y++){
			// for(int x = startX; x <= endX; x++){
				TileType type = getFrontType(x, y);
				if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){
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
					os->getProperty("openState");
					float openState = os->popFloat();
					if(openState > 0.999f){
						continue;
					}
					tileHeight *= 1.0f - openState;
					isDoor = true;
				}
				vec2 pos = tileToPos(x, y) - offs;
				vec2 points[] = {
					pos,
					pos + vec2(tileWidth, 0),
					pos + vec2(tileWidth, tileHeight),
					pos + vec2(0, tileHeight)
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
					if(dist <= 0 || dist > radius){
						continue;
					}

					vec2 lightToCurrent = p1 - lightScreenPos;
					OX_ASSERT(normal.dot(lightToCurrent) > 0);
					type = isDoor ? TILE_TYPE_EMPTY : getFrontType(x + tileSideOffs[i].x, y + tileSideOffs[i].y);
					if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS || type == TILE_TYPE_DOOR_01){
						vec2 p1_target = p1 + lightToCurrent * (radius * 100);
						vec2 p2_target = p2 + (p2 - lightScreenPos) * (radius * 100);
						
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
		std::vector<Point>::iterator it = activeTilesXY.begin();
		for(; it != activeTilesXY.end(); ++it){
			const Point& p = *it;
			int x = p.x;
			int y = p.y;
		// for(int y = startY; y <= endY; y++){
			// for(int x = startX; x <= endX; x++){
				TileType type = getFrontType(x, y);
				if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){ // || type == TILE_TYPE_DOOR_01){
					continue;
				}
				vec2 pos = tileToPos(x, y) - offs;
				vec2 points[] = {
					pos,
					pos + vec2(TILE_SIZE, 0),
					pos + vec2(TILE_SIZE, TILE_SIZE),
					pos + vec2(0, TILE_SIZE)
				};
				r.drawPoly(points[0] * lightScale, 
					points[1] * lightScale, 
					points[2] * lightScale, 
					points[3] * lightScale);
			// }
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

		radius = radius * lightScale;
		vec2 pos = lightScreenPos * lightScale;

		// pos.y = lightTextureSize.y - pos.y;
		r.draw(frame.getSrcRect(), RectF(pos - vec2(radius, radius), vec2(radius*2.0f, radius*2.0f)));
		r.drawBatch();

		r.end();
	}
	
	r.begin(lightTexture, viewport);

	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE);

	IVideoDriver::instance->setShaderProgram(shadowMaskProg);

	// Matrix viewProj = r.getViewProjection();
	IVideoDriver::instance->setUniform("projection", &viewProj);
		
	vec3 color, prevColor(0, 0, 0);
	std::vector<Point>::iterator it = activeTilesXY.begin();
	for(; it != activeTilesXY.end(); ++it){
		const Point& p = *it;
		int x = p.x;
		int y = p.y;
	// for(int y = startY; y <= endY; y++){
		// for(int x = startX; x <= endX; x++){
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
			vec2 pos = tileToPos(x, y) - offs;
			vec2 points[] = {
				pos,
				pos + vec2(TILE_SIZE, 0),
				pos + vec2(TILE_SIZE, TILE_SIZE),
				pos + vec2(0, TILE_SIZE)
			};
			r.drawPoly(points[0] * lightScale, 
				points[1] * lightScale, 
				points[2] * lightScale, 
				points[3] * lightScale);
		// }
	}

	r.end();
	return;
#else
	{
		r.begin(shadowMaskTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));
		// r.begin(lightTexture, viewport, Vector4(1.0f, 1.0f, 1.0f, 1.0f));

		IVideoDriver::instance->setShaderProgram(shadowMaskProg);

		Matrix viewProj = r.getViewProjection();
		IVideoDriver::instance->setUniform("projection", &viewProj);
		
		Vector4 color(0.0f, 0.0f, 0.0f, 0.0f);
		IVideoDriver::instance->setUniform("color", &color, 1);
		
		vec2 pos = lightTextureSize * 0.1f;
		vec2 rectSize = lightTextureSize * 0.4f;

#if 1
		vec3 points[] = {
			pos,
			pos + vec2(0, rectSize.y),
			pos + vec2(rectSize.x, 0),
			pos + rectSize,
		};
		r.drawPoints(points, 4);
#else
		glBegin(GL_QUADS);
		glVertex2f(pos.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y + rectSize.y);
		glVertex2f(pos.x, pos.y + rectSize.y);
		glEnd();
#endif

		r.end();
		// return;
	}
	{
		r.begin(lightTexture, viewport, Vector4(0.0f, 0.0f, 0.0f, 1.0f));
		// r.begin(lightTexture, viewport, Vector4(0.1f, 0.1f, 0.1f, 1.0f));

		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);

		IVideoDriver::instance->setShaderProgram(lightProg);
		IVideoDriver::instance->setUniformInt("base_texture", 0);
		IVideoDriver::instance->setUniformInt("shadow_texture", 1);

		Matrix viewProj = r.getViewProjection();
		IVideoDriver::instance->setUniform("projection", &viewProj);

		RectF shadowSrc = RectF(0, 0, lightTextureSize.x / lightTexture->getWidth(), lightTextureSize.y / lightTexture->getHeight());
		RectF shadowDest = RectF(vec2(0, 0), lightTextureSize);
		
		AffineTransform t; t.identity();
		r.setMask(shadowMaskTexture, shadowSrc, shadowDest, t, true);

		ResAnim * resAnim = resources->getResAnim("light-02");
		AnimationFrame frame = resAnim->getFrame(0, 0);
		r.setDiffuse(frame.getDiffuse());
		r.setPrimaryColor(Color(255, 255, 200));

		IVideoDriver::instance->setTexture(0, frame.getDiffuse().base);
		IVideoDriver::instance->setTexture(1, shadowMaskTexture);

		float radius = lightTextureSize.x * 0.3f;
		vec2 pos = vec2(lightTextureSize.x * 0.6f, lightTextureSize.y * 0.5f);
		// pos.y = lightTextureSize.y - pos.y;
		r.draw(frame.getSrcRect(), RectF(pos - vec2(radius, radius), vec2(radius*2.0f, radius*2.0f)));
		r.drawBatch();

		// IVideoDriver::instance->setRenderTarget(NULL);
		r.end();
		return;
	}
#endif

#if 0
	{
		Color color = Color(0, 0, 0, 255);
		r.begin(lightTexture, viewport, &color);
	
		Renderer::transform t;
		t.identity();
		
		RectF maskSrc = RectF(0, 0, lightTextureSize.x / lightTexture->getWidth(), lightTextureSize.y / lightTexture->getHeight());
		RectF maskDest = RectF(vec2(0, 0), size);
		r.setMask(shadowMaskTexture, maskSrc, maskDest, t, true);

		// glEnable(GL_BLEND);
		// glBlendFunc(GL_ONE, GL_ONE);
		// glUseProgram(0);

		ResAnim * resAnim = resources->getResAnim("light-02");
		AnimationFrame frame = resAnim->getFrame(0,0);
		r.setDiffuse(frame.getDiffuse());
		r.setPrimaryColor(Color(255, 255, 200));

		float radius = lightTextureSize.x * 0.3f;
		vec2 pos = vec2(lightTextureSize.x * 0.6f, lightTextureSize.y * 0.5f);
		// pos.y = lightTextureSize.y - pos.y;
		r.draw(frame.getSrcRect(), RectF(pos - vec2(radius, radius), vec2(radius*2.0f, radius*2.0f)));

		r.removeMask();
		r.end();
	}
	return;
#endif
	// r.begin(lightTexture, viewport, &color);

#if 0

	rs.renderer->getDriver()->setShaderProgram(prog);

	// Matrix m = Matrix(rs.transform) * rs.renderer->getViewProjection();
	Matrix m = rs.renderer->getViewProjection();
	IVideoDriver::instance->setUniform("projection", &m);

	{
		Vector4 c(1.0f, 1.0f, 1.0f, 1.0f);
		IVideoDriver::instance->setUniform("color", &c, 1);

		glEnable(GL_STENCIL_TEST);

		// glEnable(GL_BLEND);
		glStencilFunc(GL_ALWAYS, 1, 0xFF);
		glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
		glStencilMask(0xFF);
		// glColorMask(false, false, false, false);
		// glDepthMask(false);
		glClear(GL_STENCIL_BUFFER_BIT);

		vec2 pos = size * 0.1f * lightScale;
		vec2 rectSize = size * 0.4f * lightScale;

		glBegin(GL_QUADS);
		glVertex2f(pos.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y + rectSize.y);
		glVertex2f(pos.x, pos.y + rectSize.y);
		glEnd();
	}

	{
		Vector4 c(1.0f, 0.75f, 0.75f, 1.0f);
		IVideoDriver::instance->setUniform("color", &c, 1);

		glEnable(GL_STENCIL_TEST);
		glStencilFunc(GL_EQUAL, 0, 0xff);
		glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		glStencilMask(0x00);
		glColorMask(true, true, true, true);

		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);

		vec2 pos = size * 0.3f * lightScale;
		vec2 rectSize = size * 0.4f * lightScale;

		glBegin(GL_QUADS);
		glVertex2f(pos.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y);
		glVertex2f(pos.x + rectSize.x, pos.y + rectSize.y);
		glVertex2f(pos.x, pos.y + rectSize.y);
		glEnd();
	}

	r.setBlendMode(blend_alpha);
	r.end();
	return;
#endif

#if 0
	struct LightInfo
	{
		vec2 pos;
		float radius;
		Color color;
	};

	LightInfo lights[] = {
		// { vec2(size.x * 0.2f, size.y * 0.2f), size.x * 0.19f, Color(255, 100, 100) },
		// { vec2(size.x * 0.7f, size.y * 0.7f), size.x * 0.29f, Color(100, 255, 100) },
		{ vec2(size.x * 0.5f, size.y * 0.5f), size.x * 0.3f, Color(255, 255, 200) },
	};
	int lightSize = sizeof(lights) / sizeof(lights[0]);

	for(int i = 0; i < lightSize; i++){
		// glClear(GL_STENCIL_BUFFER_BIT);
		float radius = viewScale.x * lights[i].radius;
		vec2 pos = lights[i].pos;
		
		rs.renderer->getDriver()->setShaderProgram(prog);

		// Matrix m = Matrix(rs.transform) * rs.renderer->getViewProjection();
		Matrix m = rs.renderer->getViewProjection();
		IVideoDriver::instance->setUniform("projection", &m);

		Vector4 c(1.0f, 1.0f, 1.0f, 1.0f);
		IVideoDriver::instance->setUniform("color", &c, 1);

		glEnable(GL_STENCIL_TEST);

		// glDisable(GL_BLEND);
		glStencilFunc(GL_ALWAYS, 1, 0xFF);
		glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
		glStencilMask(0xFF);
		glColorMask(false, false, false, false);
		glDepthMask(false);
		glClear(GL_STENCIL_BUFFER_BIT);
		
		// Vector2 p1 = pos - radius;
		vec2 lightSize = vec2(radius * 2, radius * 2);
#if 0
		/* Vertex vertices[] = {
				p1,
				p1 + Vector2(lightSize.x, 0),
				p1 + Vector2(lightSize.x, lightSize.y),
				p1 + Vector2(0, lightSize.y),
		};
		r.draw(vertices, sizeof(vertices), VERTEX_POSITION); */
		glBegin(GL_QUADS);
		glVertex2f(p1.x, p1.y);
		glVertex2f(p1.x + lightSize.x, p1.y);
		glVertex2f(p1.x + lightSize.x, p1.y + lightSize.y);
		glVertex2f(p1.x, p1.y + lightSize.y);
		glEnd();
		continue;
#else
		vec2 lightScreenPos = pos; // offs + pos;

		for(int y = startY; y <= endY; y++){
			for(int x = startX; x <= endX; x++){
				TileType tileType = getFrontType(x, y);
				if(!tileType){
					continue;
				}
				vec2 pos = tileToPos(x, y) - offs;
				vec2 vertices[] = {
					pos,
					pos + vec2(TILE_SIZE, 0),
					pos + vec2(TILE_SIZE, TILE_SIZE),
					pos + vec2(0, TILE_SIZE)
				};
				int count = 4;
				for(int i = 0; i < count; i++){
					vec2& p1 = vertices[i];
					vec2& p2 = vertices[(i+1) % count];
					vec2 edge = p2 - p1;
					vec2 normal = vec2(edge.y, -edge.x);
					vec2 lightToCurrent = p1 - lightScreenPos;
					if(normal.dot(lightToCurrent) > 0){
						vec2 p1_target = p1 + lightToCurrent * (radius * 100);
						vec2 p2_target = p2 + (p2 - lightScreenPos) * (radius * 100);
						
						glBegin(GL_QUADS);
						glVertex2f(p1.x, p1.y);
						glVertex2f(p1_target.x, p1_target.y);
						glVertex2f(p2_target.x, p2_target.y);
						glVertex2f(p2.x, p2.y);
						glEnd();
					}
				}
			}
		}
		// continue;
		glEnable(GL_STENCIL_TEST);
		glStencilFunc(GL_EQUAL, 0, 0xff);
		glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		glStencilMask(0x00);
		glColorMask(true, true, true, true);

		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);
		glUseProgram(0);

		ResAnim * resAnim = resources->getResAnim("light-02");
		AnimationFrame frame = resAnim->getFrame(0,0);
		r.setDiffuse(frame.getDiffuse());
		r.setPrimaryColor(lights[i].color);

		pos.y = size.y - pos.y;
		r.draw(frame.getSrcRect(), RectF(pos - vec2(radius, radius), lightSize));

		glDisable(GL_BLEND);
		glUseProgram(0);
		glClear(GL_STENCIL_BUFFER_BIT);
#endif
	}
	glDisable(GL_STENCIL_TEST);

	r.setBlendMode(blend_alpha);
	r.end();
#endif

	/*
	const char* blend_vs = "\
		uniform mediump mat4 projection;\
		attribute vec2 a_position;\
		void main() {\
			vec4 position = vec4(a_position, 0.0, 1.0);\
			gl_Position = projection * position;\
		}\
		";
	const char* blend_fs = "\
		uniform vec4 lightPos;\
		uniform vec4 lightColor;\
		uniform float lightRadius;\
		void main() {\
			float distance = length(lightPos.xy - gl_FragCoord.xy) / lightRadius;\
			float attenuation = 1.0 / distance;\
			vec4 color = vec4(attenuation, attenuation, attenuation, pow(attenuation, 3)) * lightColor;\
			gl_FragColor = color;\
		}\
		";

	blendProgram = createShaderProgram(blend_vs, blend_fs);
	*/
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

#if 0
void BaseLightLayer::doRender(const RenderState &rs)
{
	rs.renderer->drawBatch();	
	
	if(!blendProgram){
		init();
	}

	// _world->SetDebugDraw(this);
	IVideoDriver * driver = rs.renderer->getDriver();
	float width = getWidth(), height = getHeight();

	int w = (int)width, h = (int)height;
	rs.renderer->initCoordinateSystem(w, h, false);

	{
		Renderer r;
		RenderState rs;
		rs.renderer = &r;
		
		int w = (int)width, h = (int)height;
		r.initCoordinateSystem(w, h, false);
		
		Rect viewport(Point(0, 0), Point(w, h));

		Color color = Color(0, 0, 0, 255);
		r.begin(lightTexture, viewport, &color);

#if 1
		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);

		os->getGlobal("res");
		spResources resources = CtypeValue<Resources*>::getArg(os, -1);
		os->pop();
		OX_ASSERT(resources);

		struct LightInfo
		{
			Vector2 pos;
			float radius;
			Color color;
		};

		LightInfo lights[] = {
			{ Vector2(width * 0.3f, height * 0.3f), width * 0.2f, Color(255, 100, 100) },
			{ Vector2(width * 0.7f, height * 0.7f), width * 0.4f, Color(100, 255, 100) },
			// { Vector2(width * 0.5f, height * 0.5f), width * 0.5f, Color(255, 255, 255) },
		};
		int lightSize = sizeof(lights) / sizeof(lights[0]);
		for(int i = 0; i < lightSize; i++){
			ResAnim * resAnim = resources->getResAnim("light-02");
			AnimationFrame frame = resAnim->getFrame(0,0);
			r.setDiffuse(frame.getDiffuse());
			r.setPrimaryColor(lights[i].color);

			float radius = lights[i].radius;
			r.draw(frame.getSrcRect(), RectF(lights[i].pos - Vector2(radius, radius), Vector2(radius*2, radius*2)));
		}
#endif

		/* ResAnim *brush = resources.getResAnim("brush");
		AnimationFrame frame = brush->getFrame(0,0);
		r.setDiffuse(frame.getDiffuse());
		r.setPrimaryColor(color);
		r.setBlendMode(blend_alpha);
		float pressure =  1.0f;//te->pressure;
		//log::messageln("pressure %.2f", pressure);
		//pressure = pressure * pressure;
		r.draw(frame.getSrcRect(), RectF(te->localPosition - Vector2(16, 16) * pressure, Vector2(32, 32)  * pressure));
		*/

		/*
		driver->setShaderProgram(blendProgram);

		// Matrix m = Matrix(rs.transform) * rs.renderer->getViewProjection();
		Matrix m = rs.renderer->getViewProjection();
		driver->setUniform("projection", &m);

		Vector4 lightColor(1, 1, 0, 1);
		driver->setUniform("lightColor", &lightColor, 1);

		Vector4 lightPos(width * 0.5f, height * 0.5f, 0, 0);
		driver->setUniform("lightPos", &lightPos, 1);

		float lightRadius = width * 0.25f;
		driver->setUniform("lightRadius", lightRadius);

		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);

		glBegin(GL_QUADS);
		glVertex2f(0, 0);
		glVertex2f(width, 0);
		glVertex2f(width, height);
		glVertex2f(0, height);
		glEnd();
		*/

		r.setBlendMode(blend_alpha);
		r.end();
	}

	Diffuse df;
	df.base = lightTexture;
	df.premultiplied = true;
	rs.renderer->setDiffuse(df);
	// rs.renderer->setBlendMode(blend_alpha);

	glEnable(GL_BLEND);
	glBlendFunc(GL_DST_COLOR, GL_ZERO);

	float lightWidth = lightTexture->getWidth();
	float lightHeight = lightTexture->getHeight();
	// rs.renderer->draw(RectF(0.1f, 0.1f, 0.8f, 0.8f), RectF(width*0.1f, height*0.1f, width*0.8f, height*0.8f));
	rs.renderer->draw(RectF(0.0f, 0.0f, width/lightWidth, height/lightHeight), RectF(0, 0, width, height));
	rs.renderer->drawBatch();

	/*
	driver->setShaderProgram(blendProgram);

	Matrix m = Matrix(rs.transform) * rs.renderer->getViewProjection();
	driver->setUniform("projection", &m);

	Vector4 lightColor(1, 1, 0, 1);
	driver->setUniform("lightColor", &lightColor, 1);

	Vector4 lightPos(width * 0.5f, height * 0.5f, 0, 0);
	driver->setUniform("lightPos", &lightPos, 1);

	float lightRadius = width * 0.25f;
	driver->setUniform("lightRadius", lightRadius);

	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE);

	glBegin(GL_QUADS);
	glVertex2f(0, 0);
	glVertex2f(width, 0);
	glVertex2f(width, height);
	glVertex2f(0, height);
	glEnd();
	*/

	rs.renderer->resetSettings();
}
#endif

// =====================================================================
// =====================================================================
// =====================================================================

BaseGame4X::BaseGame4X()
{
	tiles = NULL;
	tiledmapWidth = 0;
	tiledmapHeight = 0;
	shadowMaskProg = NULL;
	lightProg = NULL;
	lightTextureWidth = 0;
	lightTextureHeight = 0;
	lightScale = 0.0f;
}

BaseGame4X::~BaseGame4X()
{
	delete [] tiles;
	delete shadowMaskProg;
	delete lightProg;
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

void BaseGame4X::registerLevelInfo(int p_tiledmapWidth, int p_tiledmapHeight, const OS::String& p_data)
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
	OS_BYTE * data = (OS_BYTE*)p_data.toChar();
	const char * dataPrefix = LEVEL_BIN_DATA_PREFIX;
	int dataPrefixLen = (int)OS_STRLEN(dataPrefix);
	int count = p_tiledmapWidth * p_tiledmapHeight;
	if(count*2*3 + dataPrefixLen != p_data.getDataSize() || OS_STRNCMP((char*)data, dataPrefix, dataPrefixLen) != 0){
		os->setException("error layer data size");
		tiles = NULL;
		tiledmapWidth = tiledmapHeight = 0;
		return;
	}
	tiledmapWidth = p_tiledmapWidth;
	tiledmapHeight = p_tiledmapHeight;
	tiles = new Tile[count];

	OS_BYTE * front = data + dataPrefixLen;
	OS_BYTE * back = front + count*2;
	OS_BYTE * items = back + count*2;

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

