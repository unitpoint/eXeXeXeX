#include "RandomValue.h"

#define IEEE_ONE    0x3f800000
#define IEEE_MASK   0x007fffff

int RandomValue::getInt()
{
  seed = 1664525L * seed + 1013904223L;
  return ((int)seed & MAX_RAND);
}

int RandomValue::getInt(int max)
{
  if(max == 0)
  {
    return 0; // avoid divide by zero error 
  }
  return getInt() % max;
}

float RandomValue::getFloat()
{
  seed = 1664525L * seed + 1013904223L;
  OS_U32 i = IEEE_ONE | (seed & IEEE_MASK);
  return ((*(float*)&i) - 1.0f);
}

float RandomValue::getSignFloat()
{
  seed = 1664525L * seed + 1013904223L;
  OS_U32 i = IEEE_ONE | (seed & IEEE_MASK);
  return (2.0f * (*(float*)&i) - 3.0f);
}