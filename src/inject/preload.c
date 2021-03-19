#define _GNU_SOURCE
#include <dlfcn.h>
#include "../ftd2xx/ftd2xx.h"
#include "injections.h"
#include "injtools.h"


char INJ_VIDPID_ADDED = 0;
FT_STATUS FT_ListDevices(PVOID pArg1,PVOID pArg2,DWORD Flags)
{
	if(!INJ_VIDPID_ADDED) {
		FT_SetVIDPID(0x0403, 0x9670);
		INJ_VIDPID_ADDED = 1;
	}
	
	INJ_dbgprint("> FT_ListDevices, flags: %x\n", Flags);
	
	orig_FT_ListDevices_type orig_FT_ListDevices;
	orig_FT_ListDevices = (orig_FT_ListDevices_type)dlsym(RTLD_NEXT,"FT_ListDevices");
	FT_STATUS ret = orig_FT_ListDevices(pArg1,pArg2,Flags);
	
	INJ_dbgprint("< nb of devices: %d\n", *(unsigned int*)pArg1);
	
	return ret;
}
/*
FT_STATUS FT_SetTimeouts(FT_HANDLE ftHandle,ULONG ReadTimeout,ULONG WriteTimeout)
{
	INJ_dbgprint("> %s, r:%lu, w:%lu\n", "FT_SetTimeouts", ReadTimeout, WriteTimeout);
	
	orig_FT_SetTimeouts_type orig_FT_SetTimeouts;
	orig_FT_SetTimeouts = (orig_FT_SetTimeouts_type)dlsym(RTLD_NEXT,"FT_SetTimeouts");
	FT_STATUS ret = orig_FT_SetTimeouts(ftHandle,ReadTimeout,WriteTimeout);
	
	INJ_dbgprint("< %d\n", ret);
	
	return ret;
}
*/

FT_STATUS FT_EE_Read(FT_HANDLE ftHandle,PFT_PROGRAM_DATA pData)
{
	INJ_dbgprint("> %s\n", "FT_EE_Read");
	
	orig_FT_EE_Read_type orig_FT_EE_Read;
	orig_FT_EE_Read = (orig_FT_EE_Read_type)dlsym(RTLD_NEXT,"FT_EE_Read");
	FT_STATUS ret = orig_FT_EE_Read(ftHandle,pData);
	
	INJ_dbgprint("< %d\n", ret);
	INJ_printhex(pData, sizeof(FT_PROGRAM_DATA));
	
	return ret;
}

FT_STATUS FT_ReadEE(FT_HANDLE ftHandle,DWORD dwWordOffset,LPWORD lpwValue)
{
	INJ_dbgprint("> FT_ReadEE, o:%u, l:%04hx \n", dwWordOffset, *lpwValue);
	
	orig_FT_ReadEE_type orig_FT_ReadEE;
	orig_FT_ReadEE = (orig_FT_ReadEE_type)dlsym(RTLD_NEXT,"FT_ReadEE");
	FT_STATUS ret = orig_FT_ReadEE(ftHandle,dwWordOffset,lpwValue);
	
	INJ_dbgprint("< %d\n", ret);
	
	return ret;
}

FT_STATUS FT_GetDeviceInfo( FT_HANDLE ftHandle, FT_DEVICE *lpftDevice, LPDWORD lpdwID, PCHAR SerialNumber, PCHAR Description, LPVOID Dummy )
{
	INJ_dbgprint("> %s\n", "FT_GetDeviceInfo");
	
	orig_FT_GetDeviceInfo_type orig_FT_GetDeviceInfo;
	orig_FT_GetDeviceInfo = (orig_FT_GetDeviceInfo_type)dlsym(RTLD_NEXT,"FT_GetDeviceInfo");
	FT_STATUS ret = orig_FT_GetDeviceInfo(ftHandle,lpftDevice,lpdwID,SerialNumber,Description,Dummy);
	
	INJ_dbgprint("< FTdev:%lu devID:0x%X serial:%s desc:%s\n", *lpftDevice, *lpdwID, SerialNumber, Description);
	
	return ret;
}
FT_STATUS FT_GetDeviceLocId( FT_HANDLE ftHandle, LPDWORD lpdwLocId )
{
	INJ_dbgprint("> %s\n", "FT_GetDeviceLocId");
	
	orig_FT_GetDeviceLocId_type orig_FT_GetDeviceLocId;
	orig_FT_GetDeviceLocId = (orig_FT_GetDeviceLocId_type)dlsym(RTLD_NEXT,"FT_GetDeviceLocId");
	FT_STATUS ret = orig_FT_GetDeviceLocId(ftHandle,lpdwLocId);
	
	INJ_dbgprint("< locID:0x%X\n", *lpdwLocId);
	
	return ret;
}

FT_STATUS FT_SetLatencyTimer( FT_HANDLE ftHandle, UCHAR ucLatency )
{
	INJ_dbgprint("> %s\n", "FT_SetLatencyTimer");
	
	orig_FT_SetLatencyTimer_type orig_FT_SetLatencyTimer;
	orig_FT_SetLatencyTimer = (orig_FT_SetLatencyTimer_type)dlsym(RTLD_NEXT,"FT_SetLatencyTimer");
	FT_STATUS ret = orig_FT_SetLatencyTimer(ftHandle,ucLatency);
	
	INJ_dbgprint("< latency:%dms\n", ucLatency);
	
	return ret;
}

FT_STATUS FT_SetUSBParameters( FT_HANDLE ftHandle, ULONG ulInTransferSize, ULONG ulOutTransferSize )
{
	INJ_dbgprint("> %s\n", "FT_SetUSBParameters");
	
	orig_FT_SetUSBParameters_type orig_FT_SetUSBParameters;
	orig_FT_SetUSBParameters = (orig_FT_SetUSBParameters_type)dlsym(RTLD_NEXT,"FT_SetUSBParameters");
	FT_STATUS ret = orig_FT_SetUSBParameters(ftHandle,ulInTransferSize,ulOutTransferSize);
	
	INJ_dbgprint("< InTransferSize:%luB OutTransferSize:%luB\n", ulInTransferSize*64, ulOutTransferSize*64);
	
	return ret;
}

FT_STATUS FT_Write( FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToWrite, LPDWORD lpBytesWritten )
{
	INJ_dbgprint("> %s\n", "FT_Write");
	
	orig_FT_Write_type orig_FT_Write;
	orig_FT_Write = (orig_FT_Write_type)dlsym(RTLD_NEXT,"FT_Write");
	FT_STATUS ret = orig_FT_Write(ftHandle,lpBuffer,dwBytesToWrite,lpBytesWritten);
	
	INJ_printhex(lpBuffer, dwBytesToWrite);
	INJ_dbgprint("< bytes_written:%d\n", *lpBytesWritten);
	
	return ret;
}

FT_STATUS FT_GetStatus( FT_HANDLE ftHandle, DWORD *dwRxBytes, DWORD *dwTxBytes, DWORD *dwEventDWord )
{
	INJ_dbgprint("> %s\n", "FT_GetStatus");
	
	orig_FT_GetStatus_type orig_FT_GetStatus;
	orig_FT_GetStatus = (orig_FT_GetStatus_type)dlsym(RTLD_NEXT,"FT_GetStatus");
	FT_STATUS ret = orig_FT_GetStatus(ftHandle,dwRxBytes,dwTxBytes,dwEventDWord);
	
	INJ_dbgprint("< rx:%d tx:%d event:0x%X\n", *dwRxBytes, *dwTxBytes, *dwEventDWord);
	
	return ret;
}

FT_STATUS FT_GetQueueStatus( FT_HANDLE ftHandle, DWORD *dwRxBytes )
{
	INJ_dbgprint("> %s\n", "FT_GetQueueStatus");
	
	orig_FT_GetQueueStatus_type orig_FT_GetQueueStatus;
	orig_FT_GetQueueStatus = (orig_FT_GetQueueStatus_type)dlsym(RTLD_NEXT,"FT_GetQueueStatus");
	FT_STATUS ret = orig_FT_GetQueueStatus(ftHandle,dwRxBytes);
	
	INJ_dbgprint("< rx:%d\n", *dwRxBytes);
	
	return ret;
}