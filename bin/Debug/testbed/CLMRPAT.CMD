~CLMRPAT 1299~.*    NOTICE    **  (c)(p)1999  ** V. B. Hester **  All Rights  **   Reserved   **    NOTICE    ***************** R?8??R?  ??x????R+~?,(??oUĠU  z??QV:ZA???R!?~#^#V#??zP??E??R?M??R??_2?RH! \??D ! ]??D?	D  z?<(x,(U~?? ?,(M~? ?+?!RS ???! \?  8??84!iS??  ! \??D ! ]??D?	D!U?[fRz?<?gD!>U?gD!2T?gD?!eT?!?T?!2T?!T?!?T?gD?-@,(?~? ?,(?~?? ?,(?~?? ?,(?~ S?" ?---. ?&O"?S"?S"?S"?S
 	"?S!?S?B ??!QD?C "?S?&\~????RS?C ????Rx???R??ÝR ??"Bz?d8?dW?SB?CB???"Bz?d8?dW?SB?CB?.4??w,??,4,^`k>?  ??W? ~?(,z??p,p{??8
--~<?d8?dw??p?x< ??x<?!B??S??S?x?w?x???S?#??S??S??x?w?x?G????? Tw#?For Matthew Reed's Model 4 Emulator only!Invalid system disk or patch previously applied.Patch code is too big for resident DOS.Patch position pointer is incorrect for resident DOS.Program code is not compatible with SYSTEM.
Program U needs to be updated.SYSTEM has been patched successfully.Patch has been successfully removed from SYSTEM.OFF   fRNO    fRREMOVEfRNORMALfRHELP  #RH     #R ?( ~?vD?<(? ~?,(n?[#B? L~?,(X?)(T?((p+~?,(? (?( ??R(,??3 #~?(?,(?) ??DV <-- parameter  Verror.?DVSyntax error.+~?((?, ??DVMissing parameter.+~?((??,(??!%B"#B!-@??gD!?V?cV!9X?cV!hZ?gD?O>??gD??D!?V?gD?I ??= ???Press <ENTER> for additional instructions or <BREAK> to exit.CLMRTEST/CMD

CLMRTEST/CMD should be used before you use CLMRPAT/ WCMD to ensure that the patch
works property. CLMRTEST/CMD only modifies the resident RAM code and does not
modify your virtual disk. CLMRTEST is executed from the DOS promt via:

CLMRTEST<ENTER>

If everything is OK then the SYSTEM's date and time are upda Xted once per second
from MS-DOS (if interrupts enabled).CLMRPAT/CMD

If CLMRTEST/CMD appears that it is working correctly, you may wish to patch
your virtual disk. To accomplish this enter the following command:

CLMRPAT<ENTER>

This command patches SYSRE YS/SYS to read MS-DOS on power-up/re-boot and once
every second (if interrupts enabled). This patch does not go into effect
until you re-boot the computer. If you want to remove this patch, key in the
following command:

CLMRPAT (OFF)<ENTER>

This removes t Zhe patch from SYSRES/SYS in logical drive zero.

NOTE: REMOVE, NORMAL or NO may be used instead of OFF.If you are not comfortable with applying a patch to your virtual disk, you can
simply execute CLMRTEST/CMD each time you want the SYSTEM's clock to us% [e
the date and time from MS-DOS.

 R