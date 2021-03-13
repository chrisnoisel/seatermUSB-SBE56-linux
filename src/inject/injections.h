#include "ftd2xx_fx.h"

typedef FT_STATUS (*orig_FT_EE_Read_type)(FT_HANDLE ftHandle,PFT_PROGRAM_DATA pData);
typedef FT_STATUS (*orig_FT_GetDeviceInfo_type)(FT_HANDLE ftHandle,FT_DEVICE *lpftDevice,LPDWORD lpdwID,PCHAR SerialNumber,PCHAR Description,LPVOID Dummy);
typedef FT_STATUS (*orig_FT_GetDeviceLocId_type)(FT_HANDLE ftHandle,LPDWORD lpdwLocId);
typedef FT_STATUS (*orig_FT_GetQueueStatus_type)(FT_HANDLE ftHandle,DWORD *dwRxBytes);
typedef FT_STATUS (*orig_FT_GetStatus_type)(FT_HANDLE ftHandle,DWORD *dwRxBytes,DWORD *dwTxBytes,DWORD *dwEventDWord);
typedef FT_STATUS (*orig_FT_ListDevices_type)(PVOID pArg1,PVOID pArg2,DWORD Flags);
typedef FT_STATUS (*orig_FT_ReadEE_type)(FT_HANDLE ftHandle,DWORD dwWordOffset,LPWORD lpwValue);
typedef FT_STATUS (*orig_FT_SetLatencyTimer_type)(FT_HANDLE ftHandle,UCHAR ucLatency);
typedef FT_STATUS (*orig_FT_SetUSBParameters_type)(FT_HANDLE ftHandle,ULONG ulInTransferSize,ULONG ulOutTransferSize);
typedef FT_STATUS (*orig_FT_SetVIDPID_type)(DWORD dwVID,DWORD dwPID);
typedef FT_STATUS (*orig_FT_Write_type)(FT_HANDLE ftHandle,LPVOID lpBuffer,DWORD dwBytesToWrite,LPDWORD lpBytesWritten);
