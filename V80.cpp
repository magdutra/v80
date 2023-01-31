//---------------------------------------------------------------------------------
// TRS-80 Virtual Disk Kit                                  Written by Miguel Dutra
//---------------------------------------------------------------------------------

#include <cctype>
#include <typeinfo>
#include <windows.h>
#include <stdio.h>
#include "V80.h"
#include "VDI.h"
#include "JV1.h"
#include "JV3.h"
#include "DMK.h"
#include "OSI.h"
#include "TD4.h"
#include "TD3.h"
#include "TD1.h"
#include "RD.h"
#include "MD.h"
#include "ND.h"
#include "DD.h"
#include "CPM.h"

//---------------------------------------------------------------------------------
// Function Definitions
//---------------------------------------------------------------------------------

// Core operations

DWORD   Dir();
DWORD   Get();
DWORD   Put();
DWORD   Ren();
DWORD   Del();
DWORD   DumpDisk();
DWORD   DumpFile();

// Auxiliary functions

DWORD   LoadVDI();
DWORD   LoadOSI();
void    Dump(unsigned char* pBuffer, int nSize);
bool    WildComp(const char* pSource, const char* pMask, BYTE nLength);
void    WildCopy(const char* pSource, char* pTarget, const char* pMask, BYTE nLength);
void    FmtName(const char szName[9], const char szType[4], const char* szDivider, char szNewName[13]);
void    Win2TRS(const char* pWinName, char cTRSName[11]);
void    Trim(char cField[8]);

// Command-line related

DWORD   ParseCmdLine(int argc, char* argv[]);
DWORD   SetCmd(void* pParam);
DWORD   SetOpt(void* pParam);
DWORD   SetVDI(void* pParam);
DWORD   SetOSI(void* pParam);

void    PrintHelp();
void    PrintError(DWORD dwError);

//---------------------------------------------------------------------------------
// Data structures
//---------------------------------------------------------------------------------

char*   gpFileSpec[4] = {};
DWORD   (*gpCommand)() = NULL;
HANDLE  ghFile = INVALID_HANDLE_VALUE;
CVDI*   gpVDI = NULL;
COSI*   gpOSI = NULL;
DWORD   gdwFlags = 0;

struct SWITCH
{
    const char* cName;
    DWORD       (*pCall)(void*);
    void*       pParam;
    const char* cDescr;
};

SWITCH  gSwitches[] =
{
    { "-l",     SetCmd, (void*)Dir,                 "List directory (default)"                          },
    { "-r",     SetCmd, (void*)Get,                 "Read files"                                        },
    { "-w",     SetCmd, (void*)Put,                 "Write files"                                       },
    { "-n",     SetCmd, (void*)Ren,                 "Rename files"                                      },
    { "-k",     SetCmd, (void*)Del,                 "Delete files"                                      },
    { "-f",     SetCmd, (void*)DumpFile,            "Dump file contents"                                },
    { "-d",     SetCmd, (void*)DumpDisk,            "Dump disk contents"                                },
    { "-s",     SetOpt, (void*)V80_FLAG_SYSTEM,     "Include system files"                              },
    { "-i",     SetOpt, (void*)V80_FLAG_INVISIBLE,  "Include invisible files"                           },
    { "-x",     SetOpt, (void*)V80_FLAG_INFO,       "Show extra information"                            },
    { "-p",     SetOpt, (void*)V80_FLAG_CHKDSK,     "Skip the disk parameters check"                    },
    { "-c",     SetOpt, (void*)V80_FLAG_CHKDIR,     "Skip the directory structure check"                },
    { "-g",     SetOpt, (void*)V80_FLAG_GATFIX,     "Skip the GAT auto-fix in TRSDOS system disks"      },
    { "-b",     SetOpt, (void*)V80_FLAG_READBAD,    "Read as much as possible from bad files"           },
    { "-ss",    SetOpt, (void*)V80_FLAG_SS,         "Force the disk as single-sided"                    },
    { "-ds",    SetOpt, (void*)V80_FLAG_DS,         "Force the disk as double-sided"                    },
    { "-dmk",   SetVDI, (void*)new CDMK,            "Force the DMK disk interface"                      },
    { "-jv1",   SetVDI, (void*)new CJV1,            "Force the JV1 disk interface"                      },
    { "-jv3",   SetVDI, (void*)new CJV3,            "Force the JV3 disk interface"                      },
    { "-cpm",   SetOSI, (void*)new CCPM,            "Force the CP/M system interface (INCOMPLETE)"      },
    { "-dd",    SetOSI, (void*)new CDD,             "Force the DoubleDOS system interface"              },
    { "-md",    SetOSI, (void*)new CMD,             "Force the MicroDOS/OS-80 III system interface"     },
    { "-nd",    SetOSI, (void*)new CND,             "Force the NewDOS/80 system interface"              },
    { "-rd",    SetOSI, (void*)new CRD,             "Force the RapiDOS system interface"                },
    { "-td1",   SetOSI, (void*)new CTD1,            "Force the TRSDOS Model I system interface"         },
    { "-td3",   SetOSI, (void*)new CTD3,            "Force the TRSDOS Model III system interface"       },
    { "-td4",   SetOSI, (void*)new CTD4,            "Force the TRSDOS Model 4 system interface"         }
};

const char* gCategories[4] = { "Commands", "Options", "Disk Interfaces", "DOS Interfaces" };

//---------------------------------------------------------------------------------
// Main
//---------------------------------------------------------------------------------

int main(int argc, char* argv[])
{

    HANDLE  hHeap = NULL;
    DWORD   dwError;

    // Print authoring information
    puts("VDK-80, The TRS-80 Virtual Disk Kit v1.7");
    puts("Written by Miguel Dutra (www.mdutra.com)");
    puts("Icon by Marco Martin (www.notmart.org)");

    // Print usage instructions when no parameters are provided
    if (argc == 1)
    {
        PrintHelp();
        goto Exit_1;
    }

    // Process command line parameters
    if ((dwError = ParseCmdLine(argc, argv)) != NO_ERROR)
        goto Exit_1;

    // Check whether user has provided a disk image filename
    if (gpFileSpec[1] == NULL)
    {
        puts("Missing the disk image filename.");
        goto Exit_1;
    }

    // Open disk image
    if ((ghFile = CreateFile(gpFileSpec[1], GENERIC_READ+GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL)) == INVALID_HANDLE_VALUE)
    {
        dwError = GetLastError();
        goto Exit_2;
    }

    // Create a new heap for our process
    if ((hHeap = HeapCreate(0, 0, 0)) == NULL)
    {
        dwError = GetLastError();
        goto Exit_3;
    }

    // Set a command to execute if the user hasn`t indicated one (first one in the array)
    if (gpCommand == NULL)
        gpCommand = (DWORD (*)())gSwitches[0].pParam;

    // Execute the command with parameters previously parsed from the command-line
    dwError = gpCommand();

    // Release the heap
    if (hHeap != NULL)
        HeapDestroy(hHeap);

    // Close the file
    Exit_3:
    if (ghFile != INVALID_HANDLE_VALUE)
        CloseHandle(ghFile);

    // Print error message, if any
    Exit_2:
    PrintError(dwError);

    // Exit
    Exit_1:
    return 0;

}

//---------------------------------------------------------------------------------
// List disk files
//---------------------------------------------------------------------------------

DWORD Dir()
{

    OSI_FILE    File;
    char        cMask[11];
    char        szFile[13];
    void*       pFile = NULL;
    WORD        wFiles = 0;
    DWORD       dwSize = 0;
    DWORD       dwError = NO_ERROR;

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // Print operation objective
    printf("\r\nListing directory contents:\r\n\r\n");

    // Print header
    printf("Filename\t    Size\tDate\t\tAttr\r\n");
    printf("----------------------------------------------------\r\n");

    // Convert Windows filespec to TRS standard
    Win2TRS((gpFileSpec[2] != NULL ? gpFileSpec[2] : "*.*"), cMask);

    // While OSI::Dir() returns a valid file pointer
    while ((dwError = gpOSI->Dir(&pFile, (pFile == NULL ? OSI_DIR_FIND_FIRST : OSI_DIR_FIND_NEXT))) == NO_ERROR)
    {

        // Get file properties
        gpOSI->GetFile(pFile, File);

        // Compare file attributes against user requests
        if ((File.bSystem && !(gdwFlags & V80_FLAG_SYSTEM)) || (File.bInvisible && !(gdwFlags & V80_FLAG_INVISIBLE)))
            continue;

        // Compare the filename against the source filespec
        if (!WildComp(File.szName, cMask, 8) || !WildComp(File.szType, &cMask[8], 3))
            continue;

        // Format the filename
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szFile);

        // Print file information
        printf("%-12s\t%8lu\t%04d/%02d/%02d\t%c%c%c%d\r\n", szFile, File.dwSize, File.Date.wYear, File.Date.nMonth, File.Date.nDay, (File.bSystem?'S':'-'), (File.bInvisible?'I':'-'), (File.bModified?'M':'-'), File.nAccess);

        // Update operation status variables
        wFiles++;
        dwSize += File.dwSize;

    }

    // Print operation summary
    printf("\r\nTotal of %ld bytes in %d files listed.\r\n\r\n", dwSize, wFiles);

    // If exited on "No More Files" then "No Error"
    if (dwError == ERROR_NO_MORE_FILES)
        dwError = NO_ERROR;

    // Release the OSI object
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Extract files from the disk
//---------------------------------------------------------------------------------

DWORD Get()
{

    OSI_FILE    File;
    HANDLE      hFile;
    char        cMask[11];
    char        szTRSFile[13];
    char        szWinFile[13];
    char        szFile[MAX_PATH];
    void*       pFile = NULL;
    WORD        wFiles = 0;
    DWORD       dwSize = 0;
    BYTE*       pBuffer = NULL;
    DWORD       dwBytes;
    DWORD       dwError = NO_ERROR;

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // 360KB should be more than enough for any TRS-80 file
    dwBytes = (40*2*18*256) + (V80_MEM - (40*2*18*256) % V80_MEM);

    // Allocate memory
    if ((pBuffer = (BYTE*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, dwBytes)) == NULL)
    {
        dwError = ERROR_OUTOFMEMORY;
        goto Exit_2;
    }

    // Print operation objective
    printf("\r\nReading files from disk:\r\n\r\n");

    // Convert Windows filespec to TRS standard
    Win2TRS((gpFileSpec[2] != NULL ? gpFileSpec[2] : "*.*"), cMask);

    // While OSI::Dir() returns a valid file pointer
    while ((dwError = gpOSI->Dir(&pFile, (pFile == NULL ? OSI_DIR_FIND_FIRST : OSI_DIR_FIND_NEXT))) == NO_ERROR)
    {

        // Get file properties
        gpOSI->GetFile(pFile, File);

        // Compare file attributes against user requests
        if ((File.bSystem && !(gdwFlags & V80_FLAG_SYSTEM)) || (File.bInvisible && !(gdwFlags & V80_FLAG_INVISIBLE)))
            continue;

        // Compare the filename against the source filespec
        if (!WildComp(File.szName, cMask, 8) || !WildComp(File.szType, &cMask[8], 3))
            continue;

        // Format the filenames
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szTRSFile);
        FmtName(File.szName, File.szType, ".", szWinFile);

        // Add the user specified path (if any) to the Windows-based filename
        wsprintf(szFile, "%s\\%s", (gpFileSpec[3] ? gpFileSpec[3] : "."), szWinFile);

        // Print filenames
        printf("%-12s -> %-12s\t", szTRSFile, szFile);

        // Check if the file is not empty
        if (File.dwSize == 0)
        {
            printf("%8ld bytes\tSkipped\r\n", File.dwSize);
            continue;
        }

        // Check whether the file size is valid (<360KB)
        if (File.dwSize > 40*2*18*256)
        {
            printf("%8ld bytes\tInvalid Size!\r\n", File.dwSize);
            continue;
        }

        // Set file pointer
        if ((dwError = gpOSI->Seek(pFile, 0)) != NO_ERROR)
        {
            PrintError(dwError);
            continue;
        }

        // Read file contents
        if ((dwError = gpOSI->Read(pFile, pBuffer, File.dwSize)) != NO_ERROR && !(gdwFlags & V80_FLAG_READBAD))
        {
            PrintError(dwError);
            continue;
        }

        // Create Windows file
        if ((hFile = CreateFile(szFile, GENERIC_READ+GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL)) == INVALID_HANDLE_VALUE)
        {
            PrintError(dwError);
            continue;
        }

        // Write buffer contents to Windows file
        if (WriteFile(hFile, pBuffer, File.dwSize, &dwBytes, NULL) == 0)
        {
            PrintError(dwError);
            CloseHandle(hFile);
            continue;
        }

        // Close file handle
        CloseHandle(hFile);

        // Print total number of bytes extracted
        printf("%8ld bytes\tOK\r\n", File.dwSize);

        // Update operation status variables
        wFiles++;
        dwSize += File.dwSize;

    }

    // Print operation summary
    printf("\r\nTotal of %ld bytes read from %d files.\r\n\r\n", dwSize, wFiles);

    // If exited on "No More Files" then "No Error"
    if (dwError == ERROR_NO_MORE_FILES)
        dwError = NO_ERROR;

    // Release allocated memory
    if (pBuffer != NULL)
        HeapFree(GetProcessHeap(), 0, pBuffer);

    // Release the OSI object
    Exit_2:
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    // Return
    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Write files to the disk
//---------------------------------------------------------------------------------

DWORD Put()
{

    HANDLE          hFind;
    HANDLE          hFile;
    WIN32_FIND_DATA FD;
    SYSTEMTIME      ST;
    char            szFileSpec[MAX_PATH];
    char*           pFileName;
    char            cFile[11];
    char            szFile[13];
    OSI_FILE        File;
    void*           pFile;
    WORD            wFiles = 0;
    DWORD           dwSize = 0;
    BYTE*           pBuffer = NULL;
    DWORD           dwBytes;
    DWORD           dwError = NO_ERROR;

    // Check whether the user informed a FROM filespec
    if (gpFileSpec[2] == NULL)
    {
        dwError = ERROR_BAD_ARGUMENTS;
        goto Exit_0;
    }

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // 360KB should be more than enough for any TRS-80 file
    dwBytes = (40*2*18*256) + (V80_MEM - (40*2*18*256) % V80_MEM);

    // Allocate memory
    if ((pBuffer = (BYTE*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, dwBytes)) == NULL)
    {
        dwError = ERROR_OUTOFMEMORY;
        goto Exit_2;
    }

    // Print operation objective
    printf("\r\nWriting files to disk:\r\n\r\n");

    // Get the target file path
    if (GetFullPathName(gpFileSpec[2], sizeof(szFileSpec), szFileSpec, &pFileName) == 0)
    {
        dwError = GetLastError();
        goto Exit_3;
    }

    // Get the first file in the list
    if ((hFind = FindFirstFile(gpFileSpec[2], &FD)) == INVALID_HANDLE_VALUE)
    {
        dwError = GetLastError();
        goto Exit_3;
    }

    // While there are files pending for writing
    do
    {

        // Append the filename to the target file path
        strcpy(FD.cFileName, pFileName);

        // Convert the file creation time to the system time format
        if (FileTimeToSystemTime(&FD.ftCreationTime, &ST) == 0)
            memset(&ST, 0, sizeof(ST));

        // Convert Windows filename to the TRS standard
        Win2TRS((const char*)&FD.cFileName, cFile);

        // Set target filename
        memcpy(File.szName, cFile, 8);
        memcpy(File.szType, &cFile[8], 3);

        // Set target file size
        File.dwSize = FD.nFileSizeLow;

        // Set target file date
        File.Date.nDay = ST.wDay;
        File.Date.nMonth = ST.wMonth;
        File.Date.wYear = ST.wYear;

        // Set target file attributes
        File.bSystem = false;
        File.bInvisible = false;
        File.bModified = true;
        File.nAccess = OSI_PROT_FULL;

        // Format the filename for printing purposes
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szFile);

        // Print the filenames
        printf("%-12s -> %-12s\t", szFileSpec, szFile);

        // Check whether the file size is valid
        if (FD.nFileSizeLow > 40*2*18*256 || FD.nFileSizeHigh > 0)
        {
            puts("Invalid size!");
            continue;
        }

        // Open the Windows file
        if ((hFile = CreateFile(szFileSpec, GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, NULL)) == INVALID_HANDLE_VALUE)
        {
            PrintError(GetLastError());
            continue;
        }

        // Move the file pointer to the beginning
        if (SetFilePointer(hFile, 0, NULL, FILE_BEGIN) == 0xFFFFFFFF)
        {
            PrintError(GetLastError());
            CloseHandle(hFile);
            continue;
        }

        // Read file contents to the buffer
        if (ReadFile(hFile, pBuffer, File.dwSize, &dwBytes, NULL) == 0)
        {
            PrintError(GetLastError());
            CloseHandle(hFile);
            continue;
        }

        // Close file handle
        CloseHandle(hFile);

        // Create a TRS file with the properties defined above
        if ((dwError = gpOSI->Create(&pFile, File)) != NO_ERROR)
            goto Exit_4;

        // Move the file pointer to the beginning
        if ((dwError = gpOSI->Seek(pFile, 0)) != NO_ERROR)
        {
            gpOSI->Delete(pFile);
            goto Exit_4;
        }

        // Write the buffer contents to the new file
        if ((dwError = gpOSI->Write(pFile, pBuffer, File.dwSize)) != NO_ERROR)
        {
            gpOSI->Delete(pFile);
            goto Exit_4;
        }

        // Print the total number of bytes written
        printf("%8ld bytes OK\r\n", File.dwSize);

        // Update operation status variables
        wFiles++;
        dwSize += File.dwSize;

    }
    while (FindNextFile(hFind, &FD));

    // Print operation summary
    printf("\r\nTotal of %ld bytes written in %d files.\r\n\r\n", dwSize, wFiles);

    // Close find file handle
    Exit_4:
    if (hFind != NULL)
        FindClose(hFind);

    // Release the allocated memory
    Exit_3:
    if (pBuffer != NULL)
        HeapFree(GetProcessHeap(), 0, pBuffer);

    // Release the OSI object
    Exit_2:
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    // Return
    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Rename files
//---------------------------------------------------------------------------------

DWORD Ren()
{

    OSI_FILE    File;
    char        cName[9];
    char        cType[4];
    char        cSource[11];
    char        cTarget[11];
    char        szFromFile[13];
    char        szToFile[13];
    void*       pFile = NULL;
    WORD        wFiles = 0;
    DWORD       dwError = NO_ERROR;

    // Clear variables cName and cType
    memset(cName, 0, sizeof(cName));
    memset(cType, 0, sizeof(cType));

    // Check whether the user informed both the FROM and TO filespecs
    if (gpFileSpec[2] == NULL || gpFileSpec[3] == NULL)
    {
        dwError = ERROR_BAD_ARGUMENTS;
        goto Exit_0;
    }

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // Print operation objective
    printf("\r\nRenaming files:\r\n\r\n");

    // Convert Windows filespecs to TRS standards
    Win2TRS(gpFileSpec[2], cSource);
    Win2TRS(gpFileSpec[3], cTarget);

    // While OSI::Dir() returns a valid file pointer
    while ((dwError = gpOSI->Dir(&pFile, (pFile == NULL ? OSI_DIR_FIND_FIRST : OSI_DIR_FIND_NEXT))) == NO_ERROR)
    {

        // Get file properties
        gpOSI->GetFile(pFile, File);

        // Compare file attributes against user options
        if ((File.bSystem && !(gdwFlags & V80_FLAG_SYSTEM)) || (File.bInvisible && !(gdwFlags & V80_FLAG_INVISIBLE)))
            continue;

        // Compare the filename against the source filespec
        if (!WildComp(File.szName, cSource, 8) || !WildComp(File.szType, &cSource[8], 3))
            continue;

        // Copy the filename to the internal variable checking it against the target filespec
        WildCopy(File.szName, cName, cTarget, 8);
        WildCopy(File.szType, cType, &cTarget[8], 3);

        // Format "FROM" filename
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szFromFile);

        // Replace current filename with the new one
        memcpy(File.szName, cName, sizeof(cName));
        memcpy(File.szType, cType, sizeof(cType));

        // Format "TO" filename
        FmtName(cName, cType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szToFile);

        // Print filenames
        printf("%-12s -> %-12s\t", szFromFile, szToFile);

        // Update file properties
        if ((dwError = gpOSI->SetFile(pFile, File)) != NO_ERROR)
            goto Exit_2;

        // Print OK if the file has been successfully renamed
        printf("OK\r\n");

        // Update operation status variable
        wFiles++;

    }

    // Print operation summary
    printf("\r\nTotal of %d files renamed.\r\n\r\n", wFiles);

    // If exited on "No More Files" then "No Error"
    if (dwError == ERROR_NO_MORE_FILES)
        dwError = NO_ERROR;

    // Release the OSI object
    Exit_2:
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    // Return
    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Delete files
//---------------------------------------------------------------------------------

DWORD Del()
{

    OSI_FILE    File;
    char        cMask[11];
    char        szFile[13];
    void*       pFile = NULL;
    WORD        wFiles = 0;
    DWORD       dwError = NO_ERROR;

    // Check whether the user informed a filespec
    if (gpFileSpec[2] == NULL)
    {
        dwError = ERROR_BAD_ARGUMENTS;
        goto Exit_0;
    }

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // Print operation objective
    printf("\r\nDeleting files:\r\n\r\n");

    // Convert Windows filespec to TRS standard
    Win2TRS(gpFileSpec[2], cMask);

    // While OSI::Dir() returns a valid file pointer
    while ((dwError = gpOSI->Dir(&pFile, (pFile == NULL ? OSI_DIR_FIND_FIRST : OSI_DIR_FIND_NEXT))) == NO_ERROR)
    {

        // Get file properties
        gpOSI->GetFile(pFile, File);

        // Compare file attributes against user options
        if ((File.bSystem && !(gdwFlags & V80_FLAG_SYSTEM)) || (File.bInvisible && !(gdwFlags & V80_FLAG_INVISIBLE)))
            continue;

        // Compare the filename against the source filespec
        if (!WildComp(File.szName, cMask, 8) || !WildComp(File.szType, &cMask[8], 3))
            continue;

        // Format filename
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szFile);

        // Print filename
        printf("%-12s\t", szFile);

        // Delete the file
        dwError = gpOSI->Delete(pFile);

        // Print error message
        if (dwError != NO_ERROR)
        {
            PrintError(dwError);
            continue;
        }

        // Print OK if the file has been successfully deleted
        printf("OK\r\n");

        // Update operation status variable
        wFiles++;

    }

    // Print operation summary
    printf("\r\nTotal of %d files deleted.\r\n\r\n", wFiles);

    // If exited on "No More Files" then "No Error"
    if (dwError == ERROR_NO_MORE_FILES)
        dwError = NO_ERROR;

    // Release the OSI object
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    // Return
    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Dump file contents
//---------------------------------------------------------------------------------

DWORD DumpFile()
{

    OSI_FILE    File;
    char        cMask[11];
    char        szFile[13];
    void*       pFile = NULL;
    BYTE*       pBuffer = NULL;
    DWORD       dwBytes;
    DWORD       dwError = NO_ERROR;

    // Check whether the user informed a filespec
    if (gpFileSpec[2] == NULL)
    {
        dwError = ERROR_BAD_ARGUMENTS;
        goto Exit_0;
    }

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Exit_0;

    // Initialize the DOS interface
    if ((dwError = LoadOSI()) != NO_ERROR)
        goto Exit_1;

    // 360KB should be more than enough for any TRS-80 file
    dwBytes = (40*2*18*256) + (V80_MEM - (40*2*18*256) % V80_MEM);

    // Allocate memory
    if ((pBuffer = (BYTE*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, dwBytes)) == NULL)
    {
        dwError = ERROR_OUTOFMEMORY;
        goto Exit_2;
    }

    // Convert Windows filespec to TRS standard
    Win2TRS(gpFileSpec[2], cMask);

    // While OSI::Dir() returns a valid file pointer
    while ((dwError = gpOSI->Dir(&pFile, (pFile == NULL ? OSI_DIR_FIND_FIRST : OSI_DIR_FIND_NEXT))) == NO_ERROR)
    {

        // Get file properties
        gpOSI->GetFile(pFile, File);

        // Compare file attributes against user options
        if ((File.bSystem && !(gdwFlags & V80_FLAG_SYSTEM)) || (File.bInvisible && !(gdwFlags & V80_FLAG_INVISIBLE)))
            continue;

        // Compare the filename against the source filespec
        if (!WildComp(File.szName, cMask, 8) || !WildComp(File.szType, &cMask[8], 3))
            continue;

        // Format filename
        FmtName(File.szName, File.szType, (strcmp(typeid(*gpOSI).name()+2, "CPM") ? "/" : "."), szFile);

        // Print operation objective
        printf("\r\nDumping contents of %s:\r\n\r\n", szFile);

        // Set the file pointer
        if ((dwError = gpOSI->Seek(pFile, 0)) != NO_ERROR)
        {
            PrintError(dwError);
            continue;
        }

        // Read the file contents
        if ((dwError = gpOSI->Read(pFile, pBuffer, File.dwSize)) != NO_ERROR && !(gdwFlags & V80_FLAG_READBAD))
        {
            PrintError(dwError);
            continue;
        }

        // Dump the file contents
        Dump(pBuffer, File.dwSize);

        // Print operation summary
        printf("\r\nTotal of %ld bytes dumped.\r\n\r\n", File.dwSize);

    }

    // If exited on "No More Files" then "No Error"
    if (dwError == ERROR_NO_MORE_FILES)
        dwError = NO_ERROR;

    // Release the allocated memory
    if (pBuffer != NULL)
        HeapFree(GetProcessHeap(), 0, pBuffer);

    // Release the OSI object
    Exit_2:
    if (gpOSI != NULL)
        delete gpOSI;

    // Release the VDI object
    Exit_1:
    if (gpVDI != NULL)
        delete gpVDI;

    // Return
    Exit_0:
    return dwError;

}

//---------------------------------------------------------------------------------
// Dump disk sectors
//---------------------------------------------------------------------------------

DWORD DumpDisk()
{

    VDI_GEOMETRY    DG;
    VDI_TRACK*      pTrack;
    BYTE            Buffer[1024];
    WORD            wSectors = 0;
    DWORD           dwError;

    // Initialize the disk interface
    if ((dwError = LoadVDI()) != NO_ERROR)
        goto Done;

    // Print operation objective
    printf("\r\nDumping disk contents:\r\n\r\n");

    // Get the disk geometry
    gpVDI->GetDG(DG);

    // For each track in the disk
    for (int nTrack = DG.FT.nTrack; nTrack <= DG.LT.nTrack; nTrack++)
    {
        // Makes pTrack point to FirstTrack or LastTrack accordingly
        pTrack = (nTrack == 0 ? &DG.FT : &DG.LT);

        // For each side in the disk
        for (int nSide = pTrack->nFirstSide; nSide <= pTrack->nLastSide; nSide++)
        {   // For each sector in the track
            for (int nSector = pTrack->nFirstSector; nSector <= pTrack->nLastSector; nSector++)
            {   // Read sector
                if (gpVDI->Read(nTrack, nSide, nSector, Buffer, sizeof(Buffer)) == NO_ERROR)
                {   // Dump sector data
                    printf("\r\n[%02d:%d:%02d]\r\n", nTrack, nSide, nSector);
                    Dump(Buffer, pTrack->wSectorSize);
                    wSectors++;
                }
            }
        }

    }

    // Print operation summary
    printf("\r\nTotal of %d sectors dumped.\r\n\r\n", wSectors);

    // Release the VDI object
    delete gpVDI;

    // Return
    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Initialize the Virtual Disk Interface
//---------------------------------------------------------------------------------

DWORD LoadVDI()
{

    DWORD dwError = NO_ERROR;

    // Check whether the user indicated a disk interface
    if (gpVDI != NULL)
    {
        if ((dwError = gpVDI->Load(ghFile, gdwFlags)) == NO_ERROR)
            goto Done;
        else
            goto Error;
    }

    // Try the DMK format

    gpVDI = new CDMK;

    if ((dwError = gpVDI->Load(ghFile, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpVDI;

    // Try the JV3 format

    gpVDI = new CJV3;

    if ((dwError = gpVDI->Load(ghFile, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpVDI;

    // Try the JV1 format

    gpVDI = new CJV1;

    if ((dwError = gpVDI->Load(ghFile, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpVDI;

    Error:
    gpVDI = NULL;

    Done:
    // If requested by the user, print disk data
    if ((gdwFlags & V80_FLAG_INFO) && gpVDI != NULL)
    {
        VDI_GEOMETRY DG;
        gpVDI->GetDG(DG);
        printf("\r\nVDI: %-3s (%02d:%d:%02d,%s)\r\n", typeid(*gpVDI).name()+2, (DG.LT.nTrack-DG.FT.nTrack+1), (DG.LT.nLastSide-DG.LT.nFirstSide+1), (DG.LT.nLastSector-DG.LT.nFirstSector+1), (DG.FT.nDensity!=DG.LT.nDensity?"MD":(DG.LT.nDensity==VDI_DENSITY_SINGLE?"SD":"DD")));
    }

    return dwError;

}

//---------------------------------------------------------------------------------
// Initialize the Operating System Interface
//---------------------------------------------------------------------------------

DWORD LoadOSI()
{

    DWORD dwError = NO_ERROR;

    // Check whether the user indicated a DOS interface
    if (gpOSI != NULL)
    {
        if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
            goto Done;
        else
            goto Error;
    }

    // Try TRSDOS Model 4

    gpOSI = new CTD4;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try TRSDOS Model III

    gpOSI = new CTD3;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try TRSDOS Model I

    gpOSI = new CTD1;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try RapiDOS

    gpOSI = new CRD;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try MicroDOS/OS-80 III

    gpOSI = new CMD;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try NewDOS/80

    gpOSI = new CND;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try DoubleDOS

    gpOSI = new CDD;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    // Try CP/M

    gpOSI = new CCPM;

    if ((dwError = gpOSI->Load(gpVDI, gdwFlags)) == NO_ERROR)
        goto Done;

    delete gpOSI;

    Error:
    gpOSI = NULL;

    Done:
    // If requested by the user, print DOS data
    if ((gdwFlags & V80_FLAG_INFO) && gpOSI != NULL)
    {
        OSI_DOS DOS;
        gpOSI->GetDOS(DOS);
        Trim(DOS.szName);
        Trim(DOS.szDate);
        printf("OSI: %-3s (%s,%s,%02X)\r\n", typeid(*gpOSI).name()+2, DOS.szName, DOS.szDate, DOS.nVersion);
    }

    return dwError;

}

//---------------------------------------------------------------------------------
// Print data in hex and ASCII
//---------------------------------------------------------------------------------

void Dump(unsigned char* pBuffer, int nSize)
{

    char szLine[48+16+1];
    char szTemp[4];
    int  x;

    // Clear variables szLine and szTemp
    memset(szLine, 0, sizeof(szLine));
    memset(szTemp, 0, sizeof(szTemp));

    // For each byte in the buffer
    for (x = 0; x < nSize; x++)
    {
        // Convert byte to HEX in szTemp
        wsprintf(szTemp, "%02X ", pBuffer[x]);

        // Append szTemp to szLine
        memcpy(&szLine[(x % 16) *3], szTemp, 3);

        // Set the corresponding ASCII value in szLine
        szLine[(16 * 3) + (x % 16)] = (pBuffer[x] < ' ' ? '.' : pBuffer[x]);

        // When a 16-byte line has been filled, print a CR/LF
        if ((x % 16) == 15)
        {
            printf("%s\r\n", szLine);
            memset(szLine, ' ', sizeof(szLine)-1);
        }

    }

    // If exited in the middle of a 16-byte line, print a CR/LF
    if (x % 16 != 0)
        printf("%s\r\n", szLine);

}

//---------------------------------------------------------------------------------
// Compare a string against a wildcard-based mask (case insensitive)
//---------------------------------------------------------------------------------

bool WildComp(const char* pSource, const char* pMask, BYTE nLength)
{

    for (int x = 0; x < nLength; x++)
    {
        if (pMask[x] == '?')
            continue;
        if (pMask[x] == '*')
            break;
        if ((pMask[x] | ('a'-'A')) != (pSource[x] | ('a'-'A')))
            return false;
    }

    return true;

}

//---------------------------------------------------------------------------------
// Compare a string against a wildcard-based mask (case insensitive)
//---------------------------------------------------------------------------------

void WildCopy(const char* pSource, char* pTarget, const char* pMask, BYTE nLength)
{
    for (int x = 0; x < nLength; x++)
    {
        if (pMask[x] == '?')
        {
            pTarget[x] = pSource[x];
            continue;
        }
        if (pMask[x] == '*')
        {
            memcpy(&pTarget[x], &pSource[x], nLength - x);
            break;
        }
        pTarget[x] = toupper(pMask[x]);
    }
}

//---------------------------------------------------------------------------------
// Format a new filename from separated parts
//---------------------------------------------------------------------------------

void FmtName(const char szName[9], const char szType[4], const char* szDivider, char szNewName[13])
{

    char szTmpName[9];
    char szTmpType[4];

    // Copy szName and szType to temporary variables
    memcpy(szTmpName, szName, sizeof(szTmpName));
    memcpy(szTmpType, szType, sizeof(szTmpType));

    // Remove trailing spaces from name
    for (int x = 8; x > 0 && szTmpName[x - 1] == ' '; x--)
        szTmpName[x - 1] = 0;

    // Remove trailing spaces from extension
    for (int x = 3; x > 0 && szTmpType[x - 1] == ' '; x--)
        szTmpType[x - 1] = 0;

    // Assemble the new name from the two temporary variables
    wsprintf(szNewName, "%s%s%s", szTmpName, (szTmpType[0] ? szDivider : ""), szTmpType);

}

//---------------------------------------------------------------------------------
// Convert Windows-based filename to TRS standard
//---------------------------------------------------------------------------------

void Win2TRS(const char* pWinName, char cTRSName[11])
{

    BYTE x, y, z, k = strlen(pWinName);

    for (x = k; x > 0 && pWinName[x - 1] != '\\' && pWinName[x - 1] != ':'; x--);

    if (pWinName[x] == '\\' || pWinName[x] == ':')
        x++;

    for (y = 0; y < 8 && pWinName[x] != '.' && pWinName[x] != '/' && pWinName[x] != 0; x++, y++)
        cTRSName[y] = toupper(pWinName[x]);

    for ( ; y < 8; y++)
        cTRSName[y] = ' ';

    for (z = 0; z < (k - x); z++)
    {
        if (pWinName[x+z] == '.' || pWinName[x+z] == '/')
        {
            x += z + 1;
            break;
        }
    }

    for (; y < 11 && pWinName[x] != 0; x++, y++)
        cTRSName[y] = toupper(pWinName[x]);

    for ( ; y < 11; y++)
        cTRSName[y] = ' ';

}

//---------------------------------------------------------------------------------
// Remove spaces from disk name/date
//---------------------------------------------------------------------------------

void Trim(char cField[8])
{
    for (int x = 8; x > 0; x--)
    {
        if (cField[x-1] != ' ')
            break;
        cField[x-1] = 0;
    }
}

//---------------------------------------------------------------------------------
// Processes command line parameters
//---------------------------------------------------------------------------------

DWORD ParseCmdLine(int argc, char* argv[])
{

    BYTE    x, y, z;
    DWORD   dwError = NO_ERROR;

    for (x = 0, z = 0; x < argc; x++)
    {

        if (argv[x][0] == '-')
        {

            for (y = 0; y < (sizeof(gSwitches) / sizeof(SWITCH)); y++)
            {
                if (stricmp(argv[x], gSwitches[y].cName) == 0)
                {
                    if ((dwError = (*gSwitches[y].pCall)(gSwitches[y].pParam)) != NO_ERROR)
                        goto Done;
                    goto Next;
                }
            }

            puts("Unknown switch.");
            dwError = ERROR_BAD_ARGUMENTS;
            goto Done;

            Next:;

        }
        else
        {
            if (z < 4)
            {
                gpFileSpec[z++] = argv[x];
            }
            else
            {
                puts("Too many filespecs.");
                dwError = ERROR_BAD_ARGUMENTS;
                goto Done;
            }
        }

    }

    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Set the function pointer according to the command requested by the user
//---------------------------------------------------------------------------------

DWORD SetCmd(void* pParam)
{

    DWORD dwError = NO_ERROR;

    if (gpCommand != NULL)
    {
        puts("Attempt to set multiple commands.");
        dwError = ERROR_BAD_ARGUMENTS;
        goto Done;
    }

    gpCommand = (DWORD (*)())pParam;

    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Turn on option flags according to selected user switches
//---------------------------------------------------------------------------------

DWORD SetOpt(void* pParam)
{

    DWORD dwError = NO_ERROR;

    if (((gdwFlags | (DWORD)pParam) & V80_FLAG_SS) && ((gdwFlags | (DWORD)pParam) & V80_FLAG_DS))
    {
        puts("Attempt to set conflicting disk parameters.");
        dwError = ERROR_BAD_ARGUMENTS;
        goto Done;
    }

    gdwFlags |= (DWORD)pParam;

    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Set the VDI function pointer according to the file format requested by the user
//---------------------------------------------------------------------------------

DWORD SetVDI(void* pParam)
{

    DWORD dwError = NO_ERROR;

    if (gpVDI != NULL)
    {
        puts("Attempt to set multiple file formats.");
        dwError = ERROR_BAD_ARGUMENTS;
        goto Done;
    }

    gpVDI = (CVDI*)pParam;

    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Set the OSI function pointer according to the DOS requested by the user
//---------------------------------------------------------------------------------

DWORD SetOSI(void* pParam)
{

    DWORD dwError = NO_ERROR;

    if (gpOSI != NULL)
    {
        puts("Attempt to set multiple operating systems.");
        dwError = ERROR_BAD_ARGUMENTS;
        goto Done;
    }

    gpOSI = (COSI*)pParam;

    Done:
    return dwError;

}

//---------------------------------------------------------------------------------
// Print usage instructions
//---------------------------------------------------------------------------------

void PrintHelp()
{

    DWORD (*pLastFnCall)(void*) = NULL;

    printf("\r\nSyntax: V80 [switches] <disk_image> [source_filespec] [target_filespec]\r\n");

    for (BYTE x = 0, y = 0; x < (sizeof(gSwitches) / sizeof(SWITCH)); x++)
    {

        if (gSwitches[x].pCall != pLastFnCall && y < sizeof(gCategories))
        {
            printf("\r\n%s:\r\n", gCategories[y++]);
            pLastFnCall = gSwitches[x].pCall;
        }

        printf("\t%s\t\t%s\r\n", gSwitches[x].cName, gSwitches[x].cDescr);

    }

}

//---------------------------------------------------------------------------------
// Print error message
//---------------------------------------------------------------------------------

void PrintError(DWORD dwError)
{

    char szMessage[128];

    if  (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, dwError, 0, szMessage, sizeof(szMessage), NULL) != 0)
        printf("%s", szMessage);
    else
        printf("Error %ld\r\n", dwError);

}
