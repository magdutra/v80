zTCPATCH 1299z.*    NOTICE    **  (c)(p)1999  ** V. B. Hester **  All Rights  **   Reserved   **    NOTICE    ************* R@: R2VS2lS2qS2?S?2[S2vS+~?,(??MU?~U  z??/V:ZA???R!?~#^#V#??zP??E??R?M??R??_2?RH! \??D ! ]??D?	D  z?<??R,(U~?? ?,(M~? ?+?!TS ???! \?  8??84!pS??  ! \??D ! ]??D?	D!?T?[kRz?<?gD!U?gD!T?gD?!CT?!oT?!T?!?T?gD?-@,(?~? ?,(?~? ?,(?~?? ?,( S?~? ?---. ?&O"?S"?S"?S"?S
 	"?S!?S?B ??!QD?C "?S?&\~???R?S?C ????Rx???R??ãR @?xC!B+???xw ?@??@?xC!B+???xw ?@??.4??w,??,4,^`k>?  ??W? ~?(,z??p,p{??8
--~<?d8?dw??p?x< ??x<?!B??S??S?x?w?x??T?#??S??S??x? Tw?x?G?????w#?Invalid system disk or patch previously applied.Patch code is too big for resident DOS.Patch position pointer is incorrect for resident DOS.Program code is not compatible with SYSTEM.
Program needs to be updated.SYSTEM has U been patched successfully.Patch has been successfully removed from SYSTEM.OFF   kRNO    kRREMOVEkRNORMALkRHELP  (RH     (R ?( ~?vD?<(? ~?,(n?[#B? L~?,(X?)(T?((p+~?,(? (?( ??R(,??3 #~?(?,(?) ??"V <-- parameter error.?"VSyntax error.+~?((?, ? V?"VMissing parameter.+~?((??,(??!%B"#B!-@??gD!?V?AV!X?AV!hZ?gD?O>??gD??D!_V?gD?I ??= ???Press <ENTER> for additional instructions or <BREAK> to exit.TCTEST/CMD

TCTEST/CMD should be used before you use TCPATCH/CMD to ensure that the patch
works pro Wperty. TCTEST/CMD only modifies the resident RAM code and does not
modify your diskette or hard disk. TCTEST is executed from the DOS promt via:

TCTEST<ENTER>

If everything is OK then the SYSTEM's date and time are updated once per second
from TIMCLOCK ( Xif interrupts enabled).TCPATCH/CMD

If TCTEST/CMD appears that it is reading TIMCLOCK properly, you may
wish to patch your MULTIDOS system diskette or hard disk. To accomplish this
enter the following command:

TCPATCH<ENTER>

This command patches SYSRES/ YSYS to read TIMCLOCK on power-up/re-boot and once
every second (if interrupts enabled). This patch does not go into effect
until you re-boot the computer. If you want to remove this patch, key in the
following command:

TCPATCH (OFF)<ENTER>

This removes t Zhe patch from SYSRES/SYS in logical drive zero.

NOTE: REMOVE, NORMAL or NO may be used instead of OFF.If you are not comfortable with applying a patch to your system diskette or
hard disk, you can simply execute TCTEST/CMD each time you want the SYSTEM ['s
clock to use the date and time from TIMCLOCK. If you only want to
update the SYSTEM's clock periodically use TCBIG/CMD.

R