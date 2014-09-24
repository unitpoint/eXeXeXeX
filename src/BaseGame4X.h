#ifndef __BASE_GAME_4X_H__
#define __BASE_GAME_4X_H__

#include "oxygine-framework.h"
#include <ox-binder.h>

DECLARE_SMART(BaseGame4X, spBaseGame4X);
class BaseGame4X: public Actor
{
public:
	OS_DECLARE_CLASSINFO(BaseGame4X);

	BaseGame4X();
	~BaseGame4X();
};

namespace ObjectScript {

OS_DECL_OX_CLASS(BaseGame4X);

} // namespace ObjectScript


#endif // __BASE_GAME_4X_H__
