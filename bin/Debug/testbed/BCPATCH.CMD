~BCPATCH 1299~.*    NOTICE    **  (c)(p)1999  ** V. B. Hester **  All Rights  **   Reserved   **    NOTICE    ***************** R+~?,(???U?V  z???V?! A??K?? ?>??y:A??!?T?gD:ZA??S!?~#^#V#??zP??E?S?M?S2?R??_2?RH! ]??D ! ^??D?	D  z?<?(S,(~?? ?,?S~? ?+? &O"?S"?S"?S 	"?S"?S!?S?8 ???! ]?7  V??8R?! & "?S"?S"?S "?S"?S!?S?7 ??  ! ]??D ! ^??D?	D!?U?[sR Sz?<?gD!?U?gD!?T?gD?!?T?!U?!?T?!;U?gD?-@,(?~? ?,(?~? ?,(?~? ?,(?~?B ?---. ?&O"YT"\T"oT"rT
 	"iT!GT?B ??!QD?C "T?&]~??ST?C ???Sx??S????R B??KA??SͳSJͳSH??S>??K??xo?g?o???ͳS??B??KA??S??SJ??SH??S>??K??xo?g?o????gD T??.4??w,??,4,^`k>?  ??W? ~?(,z??p,p{??8
--~<?d8?dw??p?x< ??x<?!B?uT?uT?x?w?x??T?#?uT?uT??x?w?x?G?????w#?BUS Clock not found.Invalid system disk or patch previously applied.Patch code is too big for resident DOS. UPatch position pointer is incorrect for resident DOS.Program code is not compatible with SYSTEM.
Program needs to be updated.SYSTEM has been patched successfully.Patch has been successfully removed from SYSTEM.OFF   sRNO    sRREMOVEsRNORMALsRH VELP  RH     R ?( ~?vD?<(? ~?,(n?[#B? L~?,(X?)(T?((p+~?,(? (?( ??R(,??3 #~?(?,(?) ?ʹV <-- parameter error.ʹVSyntax error.+~?((?, ?ʹVMissing parameter.+~?((??,(??!%B"#B!-@??gD!/W??V!?X??V!	[?gD?O>??gD??D!?V?gD?I ??= ???Press <ENTER> f Wor additional instructions or <BREAK> to exit.BCTEST/CMD

BCTEST/CMD should be used before you use BCPATCH/CMD to ensure that the patch
works property. BCTEST/CMD only modifies the resident RAM code and does not
modify your diskette or hard disk. BCTEST i Xs executed from the DOS promt via:

BCTEST<ENTER>

If everything is OK then the SYSTEM's date and time are updated once per second
from the BUS Clock (if interrupts enabled).BCPATCH/CMD

If BCTEST/CMD appears that it is reading the BUS Clock properly, you Y may
wish to patch your MULTIDOS system diskette or hard disk. To accomplish this
enter the following command:

BCPATCH<ENTER>

This command patches SYSRES/SYS to read the BUS Clock on power-up/re-boot
and once every second (if interrupts enabled). This pa Ztch does not go into
effect until you re-boot the computer. If you want to remove this patch, key in
the following command:

BCPATCH (OFF)<ENTER>

This removes the patch from SYSRES/SYS in logical drive zero.

NOTE: REMOVE, NORMAL or NO may be used instead [ of OFF.If you are not comfortable with applying a patch to your system diskette or
hard disk, you can simply execute BCTEST/CMD each time you want the SYSTEM's
clock to use the date and time from the BUS Clock. If you only want to
update the SYSTEM's c3 \lock periodically use BCLOCK/CMD or BCBIG/CMD.

 R