#ifndef __RANDOM_VALUE_H__
#define __RANDOM_VALUE_H__

#include <objectscript.h>

class RandomValue
{
public:

  enum
  {
    MAX_RAND = 0x7fffffff
  };

  RandomValue(OS_U32 s = 0){ seed = s; }

  OS_U32 getSeed() const { return seed; }
  void setSeed(OS_U32 s){ seed = s; }

  int getInt();			// random integer in the range [0, MAX_RAND] 
  int getInt(int max);	// random integer in the range [0, max[ 
  float getFloat();		// random float in the range [0, 1.0f] 
  float getSignFloat();	// random float in the range [-1.0f, 1.0f] 

protected:

  OS_U32 seed;
};


#endif
