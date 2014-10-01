#include "oxygine-framework.h"
#include "SoundPlayer.h"
#include "SoundSystem.h"
#include <ox-binder.h>
#include <ext-base64/os-base64.h>
#include <ext-json/os-json.h>
#include <ext-zlib/os-zlib.h>

using namespace oxygine;

void example_preinit()
{
	ObjectScript::Oxygine::init();

	ObjectScript::OS * os = ObjectScript::os;
	initBase64Extension(os);
	initJsonExtension(os);
	initZlibExtension(os);
}

#ifdef WIN32
#include <core\STDFileSystem.h>
file::STDFileSystem extfs(true);
file::STDFileSystem extfs2(true);
#endif

void example_postinit()
{
#ifdef WIN32
	extfs.setPath(file::fs().getFullPath("../data").c_str());
	file::mount(&extfs);
	
	extfs2.setPath(file::fs().getFullPath("data").c_str());
	file::mount(&extfs2);
#endif
	ObjectScript::Oxygine::postInit();
}

void example_init()
{
	//initialize sound system with 16 channels
	SoundSystem::instance = SoundSystem::create();
	SoundSystem::instance->init(16);

	//initialize SoundPlayer
	SoundPlayer::initialize();

	DebugActor::showFPS = false;
	ObjectScript::Oxygine::run();
}

void example_update()
{
#ifdef WIN32 // && !defined 
#ifdef OS_DEBUG
	sleep(10);
#else
	sleep(15);
#endif
#endif
	SoundSystem::instance->update();
}

void example_destroy()
{
	ObjectScript::Oxygine::shutdown();
	SoundSystem::instance->stop();
	SoundSystem::instance->release();
}