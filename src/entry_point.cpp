/**
Attention!
This file has Oxygine initialization stuff.
If you just started you don't need to understand it exactly you could check it later.
You could start from example.cpp and example.h it has main functions being called from there
*/
#include "Stage.h"
#include "DebugActor.h"
#include "example.h"

#include <ext-datetime/os-datetime.h>

using namespace oxygine;


//called each frame
int mainloop()
{
	example_update();
	//update our stage
	//update all actors. Actor::update would be called also for all children
	getStage()->update();
	
	if (core::beginRendering())
	{		
		Color clearColor(32, 32, 32, 255);
		Rect viewport(Point(0, 0), core::getDisplaySize());
		//render all actors. Actor::render would be called also for all children
		getStage()->render(clearColor, viewport);

		core::swapDisplayBuffers();
	}

	//update internal components
	//all input events would be passed to Stage::instance.handleEvent
	//if done is true then User requests quit from app.
	bool done = core::update();

	return done ? 1 : 0;
}

//it is application entry point
void run()
{
	ObjectBase::__startTracingLeaks();

	//initialize Oxygine's internal stuff
	core::init_desc desc;

#if OXYGINE_SDL || OXYGINE_EMSCRIPTEN
	//we could setup initial window size on SDL builds
	desc.w = 960;
	desc.h = 640;
	//marmalade settings could be changed from emulator's menu
#endif


	example_preinit();
	core::init(&desc);
	example_postinit();

	//create Stage. Stage is a root node
	Stage::instance = new Stage(true);
	Point size = core::getDisplaySize();
	getStage()->setSize(size);

	//DebugActor is a helper actor node. It shows FPS, memory usage and other useful stuff
	DebugActor::show();
		
	//initialize this example stuff. see example.cpp
	example_init();

#ifdef EMSCRIPTEN
	/*
	if you build for Emscripten mainloop would be called automatically outside. 
	see emscripten_set_main_loop below
	*/	
	return;
#endif

	bool done = false;
	//here is main game loop
#ifdef WIN32
	double fps = 60;
	double dt = 1.0 / fps;
#endif
	while (1)
	{
#ifdef WIN32
		double startTime = ObjectScript::getTimeSec();
#endif
		int done = mainloop();
		if (done)
			break;
#ifdef WIN32
		double frameTime = ObjectScript::getTimeSec() - startTime + 0.001;
		if(1 && dt > frameTime){
			sleep((oxygine::timeMS)((dt - frameTime) * 1000));
		}
#endif
	}

	//user wants to leave application...

	//lets dump all created objects into log
	//all created and not freed resources would be displayed
	ObjectBase::dumpCreatedObjects();

	//lets cleanup everything right now and call ObjectBase::dumpObjects() again
	//we need to free all allocated resources and delete all created actors
	//all actors/sprites are smart pointer objects and actually you don't need it remove them by hands
	//but now we want delete it by hands

	//check example.cpp
	example_destroy();


	//renderer.cleanup();

	/**releases all internal components and Stage*/
	core::release();

	//dump list should be empty now
	//we deleted everything and could be sure that there aren't any memory leaks
	ObjectBase::dumpCreatedObjects();

	ObjectBase::__stopTracingLeaks();
	//end
}

#ifdef __S3E__
int main(int argc, char* argv[])
{
	run();
	return 0;
}
#endif


#ifdef OXYGINE_SDL
#ifdef __MINGW32__
int WinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR lpCmdLine, int nCmdShow)
{
	run();
	return 0;
}
#else
#include "SDL_main.h"
extern "C"
{
	int main(int argc, char* argv[])
	{
		run();
		return 0;
	}
};
#endif
#endif

#ifdef EMSCRIPTEN
#include <emscripten.h>

void one(){ mainloop(); }

int main(int argc, char* argv[])
{
	run();
	emscripten_set_main_loop(one, 0, 0);
	return 0;
}
#endif
