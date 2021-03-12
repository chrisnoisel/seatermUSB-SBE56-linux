/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class com_ftdichip_ftd2xx_Service */

#ifndef _Included_com_ftdichip_ftd2xx_Service
#define _Included_com_ftdichip_ftd2xx_Service
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     com_ftdichip_ftd2xx_Service
 * Method:    listDevices
 * Signature: ()[Lcom/ftdichip/ftd2xx/Device;
 */
JNIEXPORT jobjectArray JNICALL Java_com_ftdichip_ftd2xx_Service_listDevices
  (JNIEnv *, jclass);

/*
 * Class:     com_ftdichip_ftd2xx_Service
 * Method:    startInputTask
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_com_ftdichip_ftd2xx_Service_startInputTask
  (JNIEnv *, jclass, jlong);

/*
 * Class:     com_ftdichip_ftd2xx_Service
 * Method:    stopInputTask
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_com_ftdichip_ftd2xx_Service_stopInputTask
  (JNIEnv *, jclass, jlong);

#ifdef __cplusplus
}
#endif
#endif
