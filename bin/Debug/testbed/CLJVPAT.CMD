~CLJVPAT 1299~.*    NOTICE    **  (c)(p)1999  ** V. B. Hester **  All Rights  **   Reserved   **    NOTICE    ***************** R?8??R  ?!*z???R?*B###~????R+~?,(???U??U  z??uV:ZA???R!?~#^#V#??zP??E??R?M??R??_2?RH! \??D ! ]??D?	D  z?<(x,(U~?? ?,(M~? ?+?!_S" ???! \?!  8??84!?S??  ! \??D ! ]??D?	D!<U?[sRz?<?gD!bU?gD!VT?gD?!?T?!?T?!VT?!'T?!?T?gD?-@,(?~? ?,(?~??  S?,(?~?! ?,(?~?, ?---. ?&O"?S"?S"T"T
 	"T!?S?B ??!QD?C "?S?&\~????R?S?C ????Rx???R??êR ?!,!Br?CB?!*>k?/?d8?d!Bw?SB??!,!Br?CB?!*>k?/?d8?d!Bw?SB?.4??w,??,4,^`k>?  ??W? ~?(,z??p,p{??8
--~<?d8?dw??p?x< ??x<?!B?T?T?x? Tw?x??T?#?T?T??x?w?x?G?????w#?For Jeff Vavasour's Model 4 Emulator only!Invalid system disk or patch previously applied.Patch code is too big for resident DOS.Patch position pointer is incorrect for resident DOS.Program code is U not compatible with SYSTEM.
Program needs to be updated.SYSTEM has been patched successfully.Patch has been successfully removed from SYSTEM.OFF   sRNO    sRREMOVEsRNORMALsRHELP  0RH     0R ?( ~?vD?<(? ~?,(n?[#B? L~?,(X?)(T?((p+~?,(? (?( ??R(, V??3 #~?(?,(?) ??hV <-- parameter error.?hVSyntax error.+~?((?, ??hVMissing parameter.+~?((??,(??!%B"#B!-@??gD!?V͇V!]X͇V!?Z?gD?O>??gD??D!?V?gD?I ??= ???Press <ENTER> for additional instructions or <BREAK> to exit.CLJVTEST/CMD

CLJVTEST/CMD sh Would be used before you use CLJVPAT/CMD to ensure that the patch
works property. CLJVTEST/CMD only modifies the resident RAM code and does not
modify your virtual disk. CLJVTEST is executed from the DOS promt via:

CLJVTEST<ENTER>

If everything is OK then X the SYSTEM's date and time are updated once per second
from MS-DOS (if interrupts enabled).CLJVPAT/CMD

If CLJVTEST/CMD appears that it is working correctly, you may wish to patch
your virtual disk. To accomplish this enter the following command:

CLJVPA YT<ENTER>

This command patches SYSRES/SYS to read MS-DOS on power-up/re-boot and once
every second (if interrupts enabled). This patch does not go into effect
until you re-boot the computer. If you want to remove this patch, key in the
following command:

 ZCLJVPAT (OFF)<ENTER>

This removes the patch from SYSRES/SYS in logical drive zero.

NOTE: REMOVE, NORMAL or NO may be used instead of OFF.If you are not comfortable with applying a patch to your virtual disk, you can
simply execute CLJVTEST/CMD each tiI [me you want the SYSTEM's clock to use
the date and time from MS-DOS.

 R