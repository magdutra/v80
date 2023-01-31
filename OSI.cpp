//---------------------------------------------------------------------------------
// Operating System Interface
//---------------------------------------------------------------------------------

#include <windows.h>
#include "V80.h"
#include "VDI.h"
#include "OSI.h"

COSI::COSI()
: m_pVDI(NULL), m_dwFlags(0), m_DG()
{
}

COSI::~COSI()
{
}
