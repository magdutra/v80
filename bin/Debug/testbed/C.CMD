  R"`U!%B>2dU:%?I(!C>2dU"bU?[`U??S!qS?[`U?# ?(~? ?S?~?8#?? ?S####?~?(:dU??S#?*`U+6!eU?[bU?sD!qS?[bU ?$D?]U?goO?[bU?ND?]U?6D?]U?? !qS	~?(?3 #x?0?!qS?[bU?6D ?#~?(4?(H? ?]U?[bU?(D!iU?gD?I ? ?*bU?[bUP 6??>
?3 ?-@?! ?R?U?gD?I ?[(?? ??????!?U?gD????*bU?gD!?U?gD!qS?~?8#??? (??+6#??(:dU?(####?????R->?G???gD* @6 #?" @??APPEND ATTRIB ?AUTO 
BASIC2 
?BLINK UBOOT ?BREAK ?CHAIN ?CHNON HCLEAR ?CLOCK ?CLS ,COPY ICREATE %, ?SDATE '%DEBUG '?DFG (DIR (JDO */DUMP *oERROR ,FORMAT ,QFORMS /?FREE 0?HIMEM 1JKL 23KILL 2lLC 3!LCDVR 3?LIB 4?LIST 4?LOAD 5?MDBORT 6bMDCOPY 6?MDRET 7K123 7?PAUSE 8PDRIVE 8?PRINT B?PROT CGPURGE E?R ?T GRENAME GDROUTE H	SETCOM J?STMT NgSYSTEM N?TIME X?VERIFY YkVERSION Y?WRDIRP Z? ?	D     CMD
* * * End of Reference - Press <ENTER> when finished
* * <ENTER> = Next Page  <UP ARROW> = Abort
****  EXAMPLE  ****
This command is not su9?Upported by this "HELP" file.

Supported commands are:
 R                                                                                                                                                                                                                                                                                                                                                                                                                                                         ??APPEND,file1,TO,file2
---------------------
Append the contents of "file1" to the end of "file2".APPEND,NEW/DAT:0,TO,OLD/DAT:1 ATTRIB,file1,options
--------------------
Change the specified attributes (at least one required) of
"file1".
   INV - DIR will not display the file unless parameter "I"
         is specified.
   VIS - DIR will display the file.
   PROT=xxx - Assign file protection xxx=
      LOCK - No access.
      EXEC - Execute.
      READ - Execute or read.
      WRITE - Execute, read or write.
      RENAME or NAME - Execute, read, write or rename.
      KILL - Execute, read, write, rename or kill.
      FULL - All operations.ATTRIB - cont'd
---------------
   ACC=fpwd1 - "fpwd1" becomes the file's access password.
   UPD=fpwd2 - "fpwd2" becomes the file's update password.
   ASE=yn - Enable automatic allocation of additional file
            space.
   ASC=yn - Enable automatic deallocation of excess file
            space.
   UDF=yn - Turn on/off the file's updated flag.ATTRIB,CNTRLDAT/CMD,UPD=KKKJJJ,PROT=READ AUTO,doscmd
-----------
The DOS command "doscmd" is stored in the system diskette's
directory for automatic execution at subsequent re-boots.
AUTO alone eliminates this re-boot action.AUTO,BASIC,RUN"MYPROG/BAS:0" BASIC2 (Model I only)
---------------------
Enter Level II non-disk BASIC (no DOS, no disk BASIC). BLINK,yn
--------
Enable/disable cursor blinking.BLINK,N BOOT
----
Re-boot the DOS system. BREAK,yn
--------
Enable/disable the break key.BREAK,N CHAIN,file1,sectionid
---------------------
Enter keyboard input chaining mode.  Starting at the
beginning of "file1" if "sectionid" is not specified or the
beginning of the section "sectionid" of "file1" if section
was specified.  JCL is assumed as the name extension if
none was specified in "file1".CHAIN,MYCMDS/DAT:1
CHAIN,SPECCMDS,FUNCT1 CHNON,option
------------
Alter chaining state.  Options are:
   N - Chaining is temporarily suspended and the current
       DOS-CALL level, if any, is exited.
   Y - Chaining is resumed at the point in the chain file
       where it left off.  Current DOS-CALL level, if any,
       is exited.
   D - Same as "Y" except the current DOS-CALL level, if any,
       is not exited.CHNON,Y CLEAR,START=addr1,END=addr2,MEM=addr3
-------------------------------------
Clear all routes, dequeue all timer and *name routines,
set HIMEM to "addr3" or to highest memory address, zero
user memory from 5200H or "addr1" to HIMEM or "addr2".CLEAR,START=7000H,MEM=BFFFH
CLEAR CLOCK,yn
--------
Turn on/off the time display on the screen.CLOCK,N CLS
---
Clear the display. COPY,file1,TO,file2,options               FORMAT 1 COPY
---------------------------               -------------
Single file copy.  Only options SPDN and DPDN allowed.COPY,XXX/DAT:0,TO,YYY/DAT:1COPY,$file1,to,file2,options              FORMAT 2 COPY
----------------------------              -------------
Single file copy with system diskette conflict.  Only
options SPDN and DPDN allowed.  "$" indicates if at least
one of "file1" or "file2" specifies drive 0, that diskette
is not the current system diskette.  If both files use drive
0, they are on the same diskette.COPY,$XXX/DAT:0,TO,YYY/DAT:1COPY,dn1,file1,TO,file2,options           FORMAT 3/4 COPY
-------------------------------           ---------------
Single drive, two diskette, single file copy.  Only options
SPDN and DPDN allowed.COPY,1,XXX/DAT,YYY/DATCOPY,dn1,TO,dn2,date,options              FORMAT 5 COPY
----------------------------              -------------
Sector by sector full diskette copy.  Both diskettes must
have the same granules-per-lump; otherwise the CBF (Copy
By File) type of copy must be used.  Options are:
   FMT - Format the destination diskette.  FMT is the
         default if NDMW specified.
   NFMT - Do not format the destination diskette.
   Y - User doesn't care what was previously on the dest-
       ination diskette.  Y is the default if none of N,
       ODN, ODPW, DDND, KDN or KDD are specified.
   N - Reject copy if destination diskette contains data.COPY - cont'd                             FORMAT 5 COPY
-------------                             -------------
   NDMW - No diskette mount waits.  All diskettes are
          already mounted; the system is not to ask for them.
          if an error occurs, terminate the copy.
   SPDN=dn3 - The PDRIVE specifications used for source I/O
              are those listed for drive "dn3" in the PDRIVE
              display.
   DPDN=dn4 - The PDRIVE specifications used for destination
              I/O are those listed for "dn4" in the PDRIVE
              display.COPY - cont'd                             FORMAT 5 COPY
-------------                             -------------
   SN=name3 - If the source diskette's name is not "name3",
              the operator is asked whether or not to
              continue.
   SPW=dpwd1 - The source diskette's password must be "dpwd1"
               or format/copy will not be done.
   ODN=name1 - If the destination diskette's old name is not
               "name1", the operator is asked whether or not
               to continue.
   DDND - Display the destination diskette's old name and
          date and ask the operator whether or not to
          continue.COPY - cont'd                             FORMAT 5 COPY
-------------                             -------------
   KDN - The destination diskette is to retain its old name.
   KDD - The destination diskette is to retain its old date.
   NDN=name2 - "name2" is the destination diskette's new
               name.
   USD - The destination diskette is to receive the source
         diskette's date.
   BDU - Bypass directory update.  Make a mirror image copy
         without any adjustments to destination control or
         directory information.COPY - cont'd                             FORMAT 5 COPY
-------------                             -------------
COPY,0,1,10/06/81,FMT,NDMW
COPY,0,0,,SN=OLDDISK,ODN=NEWDISKCOPY,dn1,dn2,date,CBF,options             FORMAT 6 COPY
-----------------------------             -------------
Multiple file copy.  Distinguished from full diskette copy
by the CBF (Copy By File) parameter.  One, some or all of
the files, excluding BOOT/SYS and DIR/SYS, of the source
diskette are copied to the destination diskette.  All ex-
cluded files and all non-allocated granules are not copied.
If a NEWDOS/80 system disk is being created, FMT must be
specified.  All of the Format 5 options, except BDU, are
useable by this copy.  If a system file is to be copied and
it is not already in the destination diskette, FMT should
be specified.COPY - cont'd                             FORMAT 6 COPY
-------------                             -------------
Additional options are:
   USR - Copy only user files (system and invisible files
         are excluded).
   /ext - Copy only files with name-extensions "ext".
   UPD - Copy only those filesflagged as updated.
   ILF=file3 - Copy only those files listed in "file3".
   XLF=file4 - Exclude all files listed in file "file4".
   DFO - Copy only those source files already represented
         in the destination diskette directory.COPY - cont'd                             FORMAT 6 COPY
-------------                             -------------
   CFWO - Check files with operator.  The operator is asked
          whether or not to copy files which otherwise
          qualify for the copy.
   ODPW=dpwd2 - The destination diskette's old password
                must be "dpwd2" or the format/copy will not
                be done.
   DDSL=ln1 - Formatting will start the directory at the
              beginning of lump "ln1".
   DDGA=gc1 - Format will allocate "gc1" granules to the
              directory.COPY - cont'd                             FORMAT 6 COPY
-------------                             -------------COPY,0,1,01/24/82,CBF,NFMT,CFWO,USR
COPY,0,1,,CBF,NDMW   CREATE,file1,LRL=sz1,REC=count1,ASE=yn,ASC=yn
---------------------------------------------
Create new file "file1" or use old file "file1" as the new
file.  The file record size is set to "sz1", space for
"count1" records is allocated, the records filled with zeros
and EOF set to the end of those records.  Automatic space
allocation and deallocation set according to the ASE and ASC
options respectively.  Defaults for LRL, REC, ASE and ASC
are 256, 0, Y and Y respectively.CREATE,XXX/DAT:1,REC=100 DATE,date1
----------
Displays the current date if "date1" is not specified.
Otherwise, set "date1" as the computers current date.DATE,02/18/82 DEBUG,yn
--------
Enable/disable debug entry at user program start.DEBUG,Y DFG
---
Activate MINI-NEWDOS/80 if available (see SYSTEM AB & AF). DIR,dn1,options
---------------
Display the user files accounted for in the directory of the
diskette mounted on drive "dn1".  Options are:
   A - Display space allocation, record size and count, and
       attribute information.
   S - Display system files.
   I - Display invisible files.
   U - Display only updated files.
   /ext - Display only those files with name-extension
          "/ext".
   P - Send the output to the printer instead of the
       display.DIR,0,A,/DAT,U DO,file1,section
----------------
Performs identical to CHAIN. DUMP,file1,startaddr,endaddr,entryaddr,reladdr
----------------------------------------------
Dump the contents of memory locations "startaddr" thru "end-
addr" to disk file "file1".  If "entryaddr"=0FFFFH, the file
is readable via SUPERZAP DBDM mode; otherwise the file is
stored as a load module with load addresses offset by the
value "reladdr"-"startaddr" respectively.DUMP,PROGFILE/CMD:0,5200H,63F3H,5530H ERROR,xx
--------
Display error message for DOS error xxERROR,24 FORMAT,dn1,dname,date,dpwd,options
----------------------------------
Format the diskette on drive "dn1" and set up the directory,
boot and control information using name "dname", "date" and
password "dpwd".  Defaults for "dname", "date" and "dpwd"
are NOTNAMED, the current date and PASSWORD respectively.
Options Y, N, NDMW, DDND, ODN, KDN, KDD, BDU, DDSL, DDGA and
DPDN are defined under COPY.  Additional options are:
   PFST=tn3 - Partial format starting track.  Start format
              at track "tn3".  Directory and boot information
              are not setup.FORMAT - cont'd
---------------
   PFTC=tn3 - "tn3"=the number of tracks to format under
              partial format.  Default=1.
   RWF - Raw format.  Format all tracks of the diskette,
         ignoring all formatting errors and leave off system
         information.FORMAT,0,AAA0,08/01/81,PSWD,Y
FORMAT,1,,,,Y FORMS,WIDTH=xxx,LINES=yyy (Model III only)
------------------------------------------
Set the printer characters per line=xxx and lines per
page=yyy.  If a parameter is missing, it's value is not changed.FORMS,WIDTH=80,LINES=60 FREE
----
Display the number of free granules and free directory
entries for each diskette mounted. HIMEM,addr1
-----------
Display HIMEM value if "addr1"is not specified.  Otherwise,
set "addr1" as HIMEM value.  DOS maintains a highest memory
value, HIMEM, to be used as a memory upper limit by user
programs so that programs loaded above that value will be
protected.HIMEM,65000 JKL
---
Copy the contents of the screen to the printer. KILL,file1
----------
Delete "file1" from the diskette mounted either on the drive
specified or, if none specified, the lowest numbered drive
containing that file.KILL,XXX/DAT:1 LC,yn
-----
If "yn"=Y, the keyboard will accept lower case A-Z.  If
"yn"=N, the keyboard will convert lowercase a-z to upper
case.LC,Y LCDVR,yn1,yn2 (Model I only)
----------------------------
If "yn1"= Y, the keyboard driver is enabled and the lower
case function LC is set according to "yn2".  If "yn1"= N,
the keyboard driver is disabled and the LC function is in-
operative.LCDVR,Y,Y LIB
---
Display DOS library commands. LIST,file1,startline,linecount
------------------------------
List text file "file1" on the display, starting at line
"startline" and displaying "linecount" number of lines.  The
defaults for "startline" and "linecount" are 1 and 65535
respectively.LIST,TESTFILE/PT1:0 LOAD,file1
----------
Load the machine language program file "file1" into main
memory, but do not execute.LOAD,OVERLAY/OBJ:0 MDBORT
------
Terminate MINI-DOS and go to DOS ready. MDCOPY,file1,TO,file2
---------------------
This single file copy is legal under MINI-DOS; no filespec
truncation, options or diskette swaps allowed.MDCOPY,XXX:1,TO,YYY/DAT:0 MDRET
-----
Exit MINI-DOS and return to the main program, continuing its
execution where it left off when DFG was pressed. 123
---
Activates DEBUG facility, if available (see SYSTEM AB & AE). PAUSE,msg
---------
Display message "msg" and wait on the operator to press
<ENTER>.PAUSE,MOUNT INVENTORY DISKETTE ON DRIVE 1 PDRIVE,pwdn1,dn2,options
------------------------
Display PDRIVE table if "dn2" and "options" not specified.
Otherwise, update drive "dn2"'s data and display drive "dn1"
diskette's PDRIVE table.  Options are:
   TI=type1 - Type of Interface, consisting of one or more
              of the following (see manual for proper comb-
              inations):
      A - Standard TRS-80 disk interface.
      B - Model I only.  Omikron mapper.
      C - Model I only.  Percom doubler interface.
      D - Model III only.  Apparat disk controller.
      E - Model I only.  LNW type disk interface.PDRIVE - cont'd
---------------
      H - Head settle delay is to be done on drive change.
          Required for 8" drives.
      I - Sector 1 is lowest numbered sector on each track.
      J - Track 1 is the lowest numbered track on the
          diskette.
      K - Track 0 is formatted in? p}!C:%?I !%B~? (?,(?(?/(#? ??!,{} ??!}~?/ 6͢x:%?I *D"?*I@"?*?? ??R"?͍y!}?D?:m{==?& :y{<?I(2???p?w!?z?yx?>?2Vz?Hq>?2><͋x>͋x> 2><??	D!??~?? *?z#6 !??6?*?z͟z%*?z???R"?z:????(?  ?]z*?z? ??R6?!K{?tx?"y? (?8?> 2J{??? qw!}#~? (	?,(? ?+#~?(?$(+??x??(?2A{2?{>?2J{!??~?  @ ??R ?!?<" @??w?-@??w?y=2?r:??? (!?<"9{";{!?<"9{";{:?r=2?r*9{~? ??q(?? ͏r*9{~2@{6??x"E{6?*9{??+ ? 7:I{?  ?-y? (? x= ?? x>K2?q?"y?  +?>?2?q?+ ?  ???*9{? x?2={?[(
?!?2s??2s?"y??Nq??? rNq??2s???2s?x Z??x?rÉq?"y?? a:?8? *;{"9{> 2>{2?{! ??jz:>{?  ?]z(:*9{@ ??R"9{:>{=2>{? x ?"y??(?*9{?x:D{?* ??"y???r???r?"y?? 4:>{? ?tz*9{2={~? (?:={??(*9{@ 	"9{:>{<2>{? x(??"y? ?  2:?{? (+*9{ ??R"9{:?{=2?{?"y? ? ?? x(?????(
??x?"? sy?@?@?:?{??:?{<2?{*9{ 	"9{~? (?? x(??????
??x?:={?_?D(?A((?F?Hu?H a!?{?tx??wÉq:?8? > 2?{>2?{> 2?{2?{>2?{!?{?txͭx???s?ʪw2A{2?{2?{!?<"9{> 2>{2?{!?{} ???>p!?{ :={?_??(??wÉq?S?=t>y2G{!{"B{!?|?sv!{??> 2G{~?(:G{<2G{#?>?2={:?{?('? t??s?*9{?{?/ ?`y	+:G{G?py?ʥw????r??͏r:={??(?êw> 2G{:?8? >?2G{*9{?1xʪw*9{}~? 0?@? (#???"B{:G{?? !M|?t??tx>?2??:={2H{?{v:H{2={?[B{>::A{>??"B{:={?Kʶt?k /!?|??w?Ox?Y­w*E{6?!?| } ??! }ͻw*E{6*͏ríw:={??sw?_?L?v?Cʧu?M?Zu?P? uʅu?R?kv?J(!?Oªw!?|?Ox?Y­w!?| } ??! }Úw!?|?Ox?Y­w!?|?| ??!?|?!?|?Ox?­w!?|??-v!i|?Ox?Y­w!i|?| ??!?|ͬz͢x?gD? ???u?w?<v!w|??w?Ox?Y­w!w|?| ??!?|ͻwíw͑x!?{Ͱx??ʭw2={:A{G:={?ʪw!?{ } ??*B{6 #6:#:={w#6*E{#:={w?0?^D :A{?0?^D?	D! }ͻw*E? v{#:={w!?<6      åw!?|?Ox?Y­w!?| } ??! }?ͬz͢x???gD???w>͋x!|?tx??x??Nq??Nq͢x*?z͟z!K{?tx ??xíw*E{6?![|?tx>?2??>͋x??v??x?>͋x???]w??]w?(C?/0'??]w?(??w?2={* @+~?#??? ??w?:={* @2={~?? ??w?:={͋x?!??~? ?]w?[B{> ~??(? 0?@?`? w?_? w? (#?>:G{?y(?? *B{6.???SB{> 2G{?*B{#?[9{~? > ?#?![|?| ??!?|ͻw*E{#6R?  :G{?y?͑x*E{:D{w::@8????(!}??w1{?`y !}!?|?| ??!?|͢x??gD??D??w??w?"y? (?8?Éq??tx> ?fx??D?	D??w???Z>d??>???P>2?w>???:?wG> ??? ????? x:@{w*E{:D{w*9{? 	~2D{?:@8?????*9{~? ("??(?x(?x:D{?*(5{*9{?`y(> >?????tx*E{6???x?:D{w??y >Y?!8͋x!??" @??͑x??~?(
???x(͋x#?????3 ??!??" @>͋x>͋x????>͋x??!?{?yx*E{6???x?:D{w??!8͋x?08?402?{??:J{?  ??? (?? :?{???w>?? ? ?????* @? y6??+ ?  ?6 ?+ ?  ??6 ????> 2I{:@8? ?> 2I{????? ??>?2I{?? >2={>??? > ??????'?'?'?#~?/(?> #~? 0?@w??(???y(? ??>????!?6?>C2?z! ?"?z6 ????!??6?!?"?zͶy?*@"?y!?y"@??  ?>??> ???????????(:><??(??*?y"@!?<6 ??wd?? 2?z:?? zz?? ??? > 2?z?Yz!?<6?:?z?  >A=2?zG*?z#"?z??w? %> w#?6?+"?z> 2?z*??[?z??R??y:@8?(?????*?z@ ??R~???ͬz"?z͟z?*?z?	~??????z?z*?z@ 	"?z͟z:??? (???(?>??? <???>????! <?[?z????? ???g TITLE LINE CHANGED! COMPUTER MEMORY HAS BEEN CHANGED=UNSAFE TO ? {USE=*=*=
RE-BOOT SYSTEM!!!   ????????????  DIR   CMD SYS?<?<    0         CO-DIR 2.0 - Cursor Oriented DIR. (C) 1982 by Hunt K.??{ Brand.  DIR   I AChoices: <SHIFT> = Password:<ENTER> A C D F H J K L M O P R SCO-DIR Directory ofCopy to which drive (0)? |? Press <BREAK or CLEAR> for Dos, any other key for CO-DIR : Search for: ?Password  : ?Rename to : ?Modify file? Print fil??|e? (check printer) List file? Load file?? Chain file (jcl)? Kill file? Free, Press <ENTER> : FREEBASIC,  3,RUN"      CO- }DIR  ? *B{#6 !}y ??!t"j*@"L!7"@!l?D?!?"j!N?gD??*j#"j~?  *L"@??  
ERROR : SUPERZAP NOT FOUNDsSUPERZAPDFST234567i?8/QWE.PASSWORD:0   CO-DIR.  VER 2.0 ND2/I-III(C) 1982 BY HUNT K. BRAND.PICOTRIN TECHNOLOGY, INC. p                                                                                                                                                                 @@@~           @@@@~          @@@@@~         @@@@@@~        @@@ ?@@@@~                ~@@@            ~@@             ~@              ~              @~             @@~            @@@~           @@@@~          @@@@@~         @@@@@@~        @@@@@@@~  oth sending and
             receiving: 50, 75, 110, 134, 150, 300, 600,
             1200, 1800, 2000, 2400, 3600, 4800, 7200, 9600
             and 19200.
   STOP=sb - "sb" is the number of stop bits: 1 or 2.
   PARITY=pp - "pp" is the parity: 1=odd, 2=even and 3=no
               parity.SETCOM - cont'd
---------------
   WAIT or NOWAIT - Indicates whether or not the RS-232 is
                    to wait on transmission/receiving of
                    each byte.
   OFF - Turn off the RS-232 interface.  No other options
         allowed if OFF specified.SETCOM,WORD=8,BAUD=300,PARITY=1,WAIT
SETCOM,OFF STMT,msg
--------
Display the message "msg".STMT,PHASE ONE COMPLETED SYSTEM,pwdn1,options
--------------------
Change and/or display the system options in the control
sector of the system diskette mounted on drive "pwdn1".
These options determine the system configuration at sub-
sequent re-boots when this diskette is the system diskette.
Options are:
   AA=yn - Passwords enabled?
   AB=yn - Run-only mode enabled?
   AC=yn - Keyboard debounce enabled? (Model I)
   AD=yn - "JKL" for screen print enabled?
   AE=yn - "123" for debug enabled?
   AF=yn - "DFG" for MINI-DOS enabled?SYSTEM - cont'd
---------------
   AG=yn - BREAK key enabled?
   AI=yn - Lower case mode installed? (Model I)
   AJ=yn - DOS's keyboard intercept routine enabled?
   AL=al - "al"=the number of physical drives (1 to 4) in
           the system.
   AM=am - "am"=disk I/O tries before error declared.
   AN=an - The DIR command default d[?Y?YDZ                            ?  ?BNOTNAMED4:/4:/::  $ ((
  ((
  (( @((
      (( @    ERROR WHILE WITHIN FILE  PRESS "ENTER" WHEN  DISKETTE MOUNTED ON DRIVE 0DONESOURCE & DEST SAME FILESOURCE DESTINATION ** SYSTE AR=yn - COPY formats 5 and 6 allowed without diskette
           password checking?
   AS=yn - BASIC input text strings forced to upper case?
           (Model I)
   AT=yn - Chaining in byte mode, instead of record?
   AU=yn - Use clock driven repeat key function?
   AV=av - If AU=Y, delay "av" 25ms intervals before key's
           first repeat.
   AW=aw - # of write-with-verify disk I/O tries before
           declaring error.SYSTEM - cont'd
---------------
   AX=ax - "ax" is the highest ASCII code for the printer.
   AY=yn - Ask for date and time at DOS unrecognizable re-boots?
   AZ=yn - Ask for date and time at DOS recognizable re-boots?
   BA=yn - Set ROUTE,DO,NL state?
   BB=yn - Clock interrupts 50 times per second instead of
           60? (Model III)
   BC=yn - Operator allowed to pause or cancel chaining?
   BD=yn - Hold down ENTER during re-boot overrides AUTO
           command?
   BE=yn - DOS command R enabled?SYSTEM - cont'd
---------------
   BF=yn - Set "LCDVR,yn" state (Model I).
   BG=yn - Set "LC,yn" state.
   BH=yn - Set "BLINK,yn" state.
   BI=bi - Set cursor character = "bi" (0 - 255).
   BJ=bj - "bj" is integer CPU speed multiple to help DOS
           cope with a faster CPU.
   BK=yn - WRDIRP command and DIRCHECK functions W and C
           enabled?
   BN=yn - Write directory sectors readable by Model III
           NEWDOS/80 instead of by Model I TRSDOS? (Model I)SYSTEM - cont'd
---------------SYSTEM,0,AL=4,AA=Y,AU=Y,AV=20,AT=Y
SYSTEM,0 TIME,time1
----------
Display the current time if "time1" not specified.  If "time1"
is specified then set time according to it.TIME,09:30:00 VERIFY,yn
---------
Force verify read after every sector write.VERIFY,N       ***********************************************

      NEWDOS/80 Version 2.0 Command Reference Utility
                         - COMREF -
     Copyright (c) 1982 - Colorado Software Consulting
           Distributed by: Apparat, Incorporated

           *************************************    

 WRDIRP,dn1
----------
Write directory sectors protected.  On the Model III, re-
write the directory sectors for the diskette mounted on
drive "dn1" to have address mark F8.  On the Model I, re-
write the directory sectors to have address mark FA (if
SYSTEM option BN=N) to make the diskette useable on all
Model I systems or F8 (if SYSTEM option BN=Y) to make
diskette useable interchangeably on Model I and III under
NEWDOS/80 Version 2.0.  Actual directory data is not changedWRDIRP,1 ess mark FA (if
SYSTEM option BN=N) to make th                                                                                                                                                                                                                                                                