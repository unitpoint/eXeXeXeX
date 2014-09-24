#include "oxygine-framework.h"
#include "SoundPlayer.h"
#include "SoundSystem.h"
#include <ox-binder.h>

using namespace oxygine;

void example_preinit()
{
	ObjectScript::Oxygine::init();
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
#if defined WIN32 // && !defined OS_DEBUG
	sleep(10);
#endif
	SoundSystem::instance->update();
}

void example_destroy()
{
	ObjectScript::Oxygine::shutdown();
	SoundSystem::instance->stop();
	SoundSystem::instance->release();
}