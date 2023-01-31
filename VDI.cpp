//---------------------------------------------------------------------------------
// Virtual Disk Interface
//---------------------------------------------------------------------------------

#include <windows.h>
#include "V80.h"
#include "VDI.h"

CVDI::CVDI()
: m_hFile(NULL), m_dwFlags(0), m_DG()
{
}

CVDI::~CVDI()
{
}

void CVDI::GetDG(VDI_GEOMETRY& DG)
{
    DG = m_DG;
}
