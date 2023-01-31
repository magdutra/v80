	Title    'MEX overlay for TRS-80 compatible systems'
;
; Ignore the Title error message if using ASM.   
;
REV	EQU	14		;vern the MXO-PM22.ASM overlay written by Ron Fowler.
; It is a MEX overlay for use with TRS-80 compatible systems, and an
; external modem. It has a SET command that supports  baudrate, parity,
; word and stopbit setting. (baudrate's include 50, 75, 300, 600, 1200,
; 2400, 4800, 9600, 75/1200 and 1200/75)
;
;
; VERSION 1.4, changed the way the errors in the SET command where
;   display. On error during a specific comand only the help for
;   that command will be displayed.
;					Modified 02/08/88 Bert van Hoekelen
;
; VERSION 1.3, added switchable DTR and RTS to the SET command.
;					Modified 02/07/88 Bert van Hoekelen
;
; VERSION 1.2, status display is now decoded from the port and the
;   configuration image byte, so they will reflect the real values.
;					Modified 02/04/88 Bert van Hoekelen
;
; VERSION 1.1, fixed a bug in the configuration section, new values were
;   modified in the text but not send to the port.
;					Modified 02/03/88 Bert van Hoekelen
;
; VERSION 1.0, Written from scratch 01/31/88 by Bert van Hoekelen
;
;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*;
;
CR	EQU	00DH		;carriage return
LF	EQU	00AH		;linefeed
TPA	EQU	100H		;start of TPA area
TAB	EQU	009H		;tab character
CTRLC	EQU	003H		;control <C> char
CTRLZ	EQU	01AH		;clear screen char
ESC	EQU	01BH		;escape character
IVON	EQU	029H		;switch to inverse screen
IVOFF	EQU	028H		;switch to normal screen
;
YES	EQU	0FFH		;activate,
NO	EQU	000H		;deactivate some commands
;
; Change the following information to match your equipment.
;
; UAPORT should be set to the base port address for the RS-232.
;
UAPORT	EQU	0E8H		;master reset port   
BAUDRP	EQU	UAPORT+1	;baud rate port
MODCTL	EQU	UAPORT+2	;modem control port
MODDAT	EQU	UAPORT+3	;modem data in/out port
MDRCVB	EQU	10000000B	;bit to test for receive
MDRCVR	EQU	10000000B	;value when ready
MDSNDB	EQU	01000000B	;bit to test for send
MDSNDR	EQU	01000000B	;value when ready
;
CTSMSK	EQU	10000000B	;CTS bit mask
DSRMSK	EQU	01000000B	;DSR bit mask
CDMASK	EQU	00100000B	;CD bit mask
RIMASK	EQU	00010000B	;RI bit mask
;
MODCTB	EQU	11101100B	;even,8,1,nopar,xmit,dtr,rts for port init
POEMSK	EQU	10000000B	;par odd/even mask 
WBMASK	EQU	01100000B	;word bits mask UCONFG
SBMASK	EQU	00010000B	;stop-bits mask
PONMSK	EQU	00001000B	;par-on mask
XMTMSK	EQU	00000100B	;xmit break mask
DTRMSK	EQU	00000010B	;DTR bit mask
RTSMSK	EQU	00000001B	;RTS bit mask
;
ISOCD	EQU	11011111B	;port ready mask
BRKMSK	EQU	11111011B	;disable xmit (send break)
;
;MEX SERVICE PROCESSOR STUFF
;
MEX	EQU	0D00H		;address of the service processor
INMDM	EQU	255		;get char from port,CY=no more in 100ms
TIMER	EQU	254		;delay 100 ms * reg b
TMDINP	EQU	253		;b=# secs to wait for char,CY=no char
CHEKCC	EQU	252		;check for ^C from kbd, Z=present
SNDRDY	EQU	251		;test for modem-send ready
RCVRDY	EQU	250		;test for modem-receive ready
SNDCHR	EQU	249		;send to modem (after SNDRDY)
RCVCHR	EQU	248		;recv a char from modem after (RCVRDY)
LOOKUP	EQU	247		;table search: see CMDTBL for info 
PARSFN	EQU	246		;parse filename from input stream ŠBDPARS	EQU	245		;parse baud-rate from input stream
SBLANK	EQU	244		;scan input stream to next non-blank
EVALA	EQU	243		;evaluate numeric from input stream
LKAHED	EQU	242		;get nxt char w/o removing from input
GNC	EQU	241		;get char from input, CY=1 if none
ILP	EQU	240		;inline print
DECOUT	EQU	239		;decimal output
PRBAUD	EQU	238		;print baud rate
;
CONOUT	EQU	2		;simulated BDOS funct 2:CONSOLE OUT
PRINT	EQU	9		;simulated BDOS funct 9: PRINT STRING
INBUF	EQU	10		;input buffer, same as BDOS FUNCT 10
;
;MODIFY BAUDRATE TABLE IN MEX112.COM to suit usable baud rates
;
;  this modification allows split baudrates to be included in the
;  phone list, the MEX display routine and MEX test for correct
;  baud input during SET command. (length must be 56 bytes and
;  apply to the MEX table rules)  see PMMI overlay for details
;  this table is not documented in any way by MEX, so use it
;  at your own risk (this table works fine on my machine BvH)

	ORG	04E91H			;somewhere in MEX (version 1.12)
	DB	'5','0'+80H		;baud rate
	DB	00H,00H			;mex number
	DB	'7','5'+80H
	DB	00H,01H
	DB	'30','0'+80H
	DB	00H,02H
	DB	'60','0'+80H
	DB	00H,03H
	DB	'120','0'+80H
	DB	00H,04H
	DB	'240','0'+80H
	DB	00H,05H
	DB	'480','0'+80H
	DB	00H,06H
	DB	'960','0'+80H
	DB	00H,07H
	DB	'75/1','2'+80H
	DB	00H,08H
	DB	'12/7','5'+80H
	DB	00H,09H
;
;END OF NON SUPPORTED MEX AREA
; (leave here for correct end-address display by MAC)
; (with smartmodem overlay it must end before 0AFFH else it must
;  end before 0CFFH.)
;
	ORG	TPA		;start of the overlay area
;
	DS	3		;(for MEX "JMP   START" instruction)
PMODEM:	DB	NO		;0103H Not referenced by MEX
SMODEM:	DB	NO		;0104H Not referenced by MEX
TPULSE:	DB	'P'		;0105H Not referenced by MEX
CLOCK:	DB	90		;0106H clock speed in MHz * 0.1, 25.5 MHz max.
				;      20=2 MHh, 37=3.68 MHz, 40=4 MHz, etc.
MSPEED:	DB	8		;0107H 0=50 1=75 2=300 3=600 4=1200 5=2400
				;      6=4800 7=9600 8=75/1200 9=1200/75
				;      default baudrate on entry
BYTDLY:	DB	0		;0108H 0=0 delay  1=10ms  5=50 ms  9=90 ms
				;      default delay time to send character
				;      in terminal mode file transfer for
				;      slow BBS.
CRDLY:	DB	0		;0109H 0=0 delay 1=100 ms 5=500 ms - 9=900 ms
				;      default delay time for extra wait after
				;      CRLF in terminal mode file transfer
COLUMS:	DB	5		;010AH number of DIR columns shown
SETFL:	DB	YES		;010BH yes=user-defined SET command
SCRTST:	DB	YES		;010CH yes=if home cursor & clear screen
				;      routine at CLRSCRN
	DS	1		;010DH reserved (old ACKNAK flag)
BAKFLG:	DB	NO      	;010EH yes=change any file same name to .BAK
CRCDFL:	DB	YES		;010FH yes=default to CRC checking
TOGCRC:	DB	YES		;0110H yes=allow toggling of CRC to Checksum
CVTBS:	DB	NO		;0111H yes=convert backspace to rub
TOGLBK:	DB	YES		;0112H yes=allow toggling of bksp to rub
ADDLF:	DB	NO		;0113H no=no LF after CR to send file in
				;      terminal mode (added by remote echo)
TOGLF:	DB	YES		;0114H yes=allow toggling of LF after CR
TRNLOG:	DB	YES		;0115H yes=allow transmission of logon
				;      write logon sequence at location LOGON
SAVCCP:	DB	YES		;0116H yes=do not overwrite CCP
LOCNXT:	DB	NO		;0117H yes=local command if EXTCHR precedes
				;      no=external command if EXTCHR precedes
TOGLOC:	DB	YES		;0118H yes=allow toggling of LOCNXTCHR
LSTTST:	DB	YES		;0119H yes=allow toggling of printer on/off
XOFTST:	DB	YES		;011AH yes=checks for XOFF from remote while
				;      sending a file in terminal mode
XONWT:	DB	NO		;011BH yes=wait for XON after CR whileŠ				;      sending a file in terminal mode
TOGXOF:	DB	YES		;011CH yes=allow toggling of XOFF checking
IGNCTL:	DB	NO		;011DH yes=CTL-chars above ^M not displayed
EXTRA1:	DB	0		;011EH for future expansion
EXTRA2:	DB	0		;011FH for future expansion
BRKCHR:	DB	'@'-40H		;0120H ^@ = Send 300 ms. break tone
NOCONN:	DB	'N'-40H		;0121H ^N = Disconnect from the phone line
LOGCHR:	DB	'L'-40H		;0122H ^L = Send logon
LSTCHR:	DB	'P'-40H		;0123H ^P = Toggle printer
UNSVCH:	DB	'R'-40H		;0124H ^R = Close input text buffer
TRANCHR:DB	'T'-40H 	;0125H ^T = Transmit file to remote
SAVECHR:DB	'Y'-40H		;0126H ^Y = Open input text buffer
EXTCHR:	DB	'^'-40h		;0127H ^^ = Send next character
PRATE:	DS	1		;0128H pulse dialing rate
	DS	1
INCTL1:	JMP     iCTL1		;012AH in modem control port
	DB	0,0,0,0,0,0,0
OTDATA:	JMP	oDATA		;0134H out data to UART
	DB	0,0,0,0,0,0,0
INPORT:	JMP	iDATA		;013EH in data from UART
	DB	0,0,0,0,0,0,0
MASKR:	ANI	MDRCVB		;0148H bit to test for rcv ready 10000000B
	RET
TESTR:	CPI	MDRCVR		;014BH value of rcv. bit when ready 10000000B
	RET
MASKS:	ANI	MDSNDB		;014EH bit to test for send ready 01000000B
	RET
TESTS:	CPI	MDSNDR		;0151H value of send bit when ready 01000000B
	RET
	DS	12
LOGON:	DS	2		;0160H not ref'd by MEX
DIALV:	DS	3		;0162H dial digit in A
DISCV:	DS	3		;0165H disconnect the modem
GOODBV:	JMP	PGOODB		;0168H called before exit to CP/M
INMODV:	JMP	NITMOD		;016BH initialisation at COLD START
NEWBDV:	JMP	PBAUD		;016EH set baud-rate
NOPARV:	DS	3		;0171H call at end of file transfer
PARITV:	JMP	SCLSHO		;0174H call at begin of file transfer
SETUPV:	JMP	SETCMD		;0177H SET command entry
SPMENV:	DS	3		;017AH not used with MEX
VERSNV:	JMP	SYSVER		;017DH Overlay's sign-on message
BREAKV:	JMP	PBREAK		;0180H send a break
;
; Do not change the following six lines.
;
ILPRTV:	DS	3		;0183H
INBUFV:	DS	3		;0186H
ILCMPV:	DS	3		;0189H
INMDMV:	DS	3		;018CH
NXSCRV:	DS	3		;018FH
TIMERV:	DS	3		;0192H
;
; Routine to clear to end of screen.  If using CLREOS and CLRSCRN, set
; SCRNTEST to YES at 010AH (above).
;
CLREOS:	LXI	D,EOSMSG	;0195H clear to end of screen
	MVI	C,PRINT		;      from cursor
	CALL	MEX		;
	RET			;
;
CLS:	LXI	D,CLSMSG	;019EH clear screen
	MVI	C,PRINT		;Š	CALL	MEX		;
	RET			;
;
;-------------------------------------------------------------------
;
;	*** END OF FIXED FORMAT AREA
;
;-------------------------------------------------------------------
;
; return status of the modem port
;
iCTL1:	IN	MODCTL		;in modem contol port (EA)
	RET
;
oDATA:	OUT	MODDAT  	;out modem data port (EB)
	RET
;
iDATA:	IN	MODDAT  	;in modem data port (EB)
	RET
;
; called before exit to CP/M
;
PGOODB:	CALL	CLS		;clear screen
	RET
;
; initialisation at cold start, set UART and BAUDRATE to there initial value 
;
NITMOD:	MVI	A,1
	OUT	UAPORT		;reset the UART (E8)Š	MVI	A,MODCTB	;get initial UART configuration 11101100B
	STA	UCONFG		;UART configuration image byte
	OUT	MODCTL		;(EA)
	LDA	MSPEED		;get initial baud rate
	CALL	PBAUD		;set baud
	CALL	CLS
	RET
;	
; set baud rate
;
PBAUD:	PUSH	H		;save everybody
	PUSH	B
	PUSH	D
	MOV	E,A		;get speed
	ORA	A		;0= 50 baud
	JZ	BAUD50		;set 50 baud
	MVI	D,0		;zero the other half of reg pair
	LXI	H,BAUDTB	;get baud rate table address
	DAD	D		;add speed offset
	MOV	A,M		;get baud rate  
	ORA	A		;0=not valid baud rate
	JZ	PBEXIT		;not valid baud rate then exit
BAUD50:	OUT	BAUDRP		;good baud rate then set it (E9)
	MOV	A,E		;get speed 
	STA	MSPEED		;set speed
	JMP	PBEXIT1		;return 
PBEXIT:	STC
PBEXIT1:POP	B		;no carrier or incorrect baud rate
	POP	D
	POP   	H
	RET
;
; if want to make a baud-rate invalid then change its value to 00H,
;   for 50 this will not work (delete the JZ BAUD50 above)
;
BAUDTB:	DB	000H,011H,055H	;   50,   75,  300 bps
	DB	066H,077H,0AAH	;  600, 1200, 2400 bps
	DB	0CCH,0EEH,017H	; 4800, 9600,75/12 bps
	DB	071H		;12/75 bps
;
; set command, modify baud-rate, uart and modem values
;
SETCMD:	MVI	C,SBLANK	;any arguments ?
	CALL	MEX
	JC	SCLSHO		;if not print current values
	LXI	D,CMDTBL	;start of available commands
	CALL	LKTBL
	PUSH	H		;address on stack
	RNC			;if yes then execute it
	POP	H		;no fix stack
	CALL	ILPRIN		;go print it
	DB	ESC,IVON,'NON VALID SET COMMAND',ESC,IVOFF,CR,LF,0
	JMP	ERHELP		;not a valid command give help
CMDTBL:	DB	'?'+80H		;"set ?"
	DW	STHELP
	DB	'HEL','P'+80H	;"set HELP"
	DW	STHELP
	DB	'B'+80H		;"set B" short for baudrate
	DW	STBAUD
	DB	'BAU','D'+80H	;"set baud'
	DW	STBAUD
	DB	'W'+80H		;"set W" short for word length
	DW	STWORD
	DB	'WOR','D'+80H	;"set WORD"
	DW	STWORD
	DB	'S'+80H		;"set S" short for stopbits
	DW	STSTOP
	DB	'STO','P'+80H	;"set STOP"
	DW	STSTOP
	DB	'P'+80H		;"set P" short for parity
	DW	STPAR
	DB	'PARIT','Y'+80H ;"set PARITY"
	DW	STPAR
	DB	'DT','R'+80H	;"set DTR"
	DW	STDTR
	DB	'RT','S'+80H	;"set RTS"
	DW	STRTS
	DB	0		;end of table
;
; set command, display help message
;
STHELP:	CALL	CLS		;clear screen
ERHELP:	LXI	D,HLPMSG	;overlay help message
	CALL	GPRINT		;go print it
	LXI	D,HLBAUD	;baud-rate help message
	CALL	GPRINT		;go print it and return
	LXI	D,HLWORD	;word help message
	CALL	GPRINT		;go print it
	LXI	D,HLSTOP	;stopbit help message
	CALL	GPRINT		;go print it
	LXI	D,HLPARI	;parity help message
	CALL	GPRINT		;go print it
	LXI	D,HLDTR		;dtr help message
	CALL	GPRINT		;go print it
	LXI	D,HLRTS		;rts help message
	CALL	GPRINT		;go print it
	CALL	SETSHO		;show current values
	RET
;
; set command, modify baud-rate
;
STBAUD:	MVI	C,BDPARS	;MEX find baud rate		
	CALL	MEX
	LXI	D,HLBAUD	;baud-rate help message
	JC 	SETERR		;none then exit
	CALL    PBAUD		;valid baud rate then set it
	JMP	SCLSHO
;
; set command, modify word-length
;
STWORD:	LXI	D,WLTBL		;find word length function requested
	CALL	LKTBL
	PUSH	H
	LDA	UCONFG		;get previous configuration
	RNC			;execute it
	POP	H
	LXI	D,HLWORD	;word help message
	JMP	SETERR		;not valid then say so
WLTBL:	DB	'5'+80H		;word length table
	DW	STFIVE		;5 bit length
	DB	'6'+80H
	DW	STSIX		;6 bit length
	DB	'7'+80H
	DW	STSEV		;7 bit length
	DB	'8'+80H
	DW	STATE		;8 bit length
	DB	0
STFIVE:	ANI	10011111B	;change to 5 bits
	JMP	SETCFG
STSIX:	ORI	01000000B	;set six bits	
	ANI	11011111B
	JMP	SETCFG
STSEV:	ORI	00100000B	;set seven bits
	ANI	10111111B
	JMP	SETCFG
STATE:	ORI	01100000B	;set eight bits
	JMP	SETCFG
;
; set command, modify stopbits
;
STSTOP:	LXI	D,STTBL		;find how many stop bits 
	CALL	LKTBL
	PUSH	H
	LDA	UCONFG		;get previous configuration
	RNC			;execute it
	POP	H
	LXI	D,HLSTOP	;stop help message
	JMP	SETERR		;not valid then say so 
STTBL:	DB	'1'+80H		;stop bit tabe
	DW	STONE		;set one bit
	DB	'2'+80H
	DW	STTWO		;set two bits
	DB	0
STONE:	ANI	11101111B	;set one stop bit 
	JMP	SETCFG
STTWO:	ORI	00010000B	;set two stop bits
	JMP	SETCFG
;
; set command, modify parity
;
STPAR:	LXI	D,PARTBL	;find parity function requested
	CALL	LKTBL
	PUSH	H
	LDA	UCONFG
	RNC			;execute it
	POP	H
	LXI	D,HLPARI	;parity help message
	JMP	SETERR		;not valid then say so 				
PARTBL:	DB	'O','N'+80H	;parity table
	DW	STON		;enable parity
	DB	'OF','F'+80H
	DW	STOFF		;disable parity
	DB	'EVE','N'+80HŠ	DW	STEVE		;even parity
	DB	'OD','D'+80H
	DW	STODD		;odd parity	
	DB	0
STON:	ANI	11110111B	;set parity on
	JMP	SETCFG
STOFF:	ORI	00001000B	;set parity off
	JMP	SETCFG
STEVE:	ORI	10000000B	;set even parity
	JMP	SETCFG
STODD:	ANI	01111111B	;set parity odd
	JMP	SETCFG
;
; set command, modify DTR
;
STDTR:	LXI	D,DTRTBL	;find parity function requested
	CALL	LKTBL
	PUSH	H
	LDA	UCONFG
	RNC			;execute it
	POP	H
	LXI	D,HLDTR		;parity help message
	JMP	SETERR		;not valid then say so 				
DTRTBL:	DB	'O','N'+80H	;parity table
	DW	STDON		;enable parity
	DB	'OF','F'+80H
	DW	STDOFF		;disable parity
	DB	0
STDON:	ANI	11111101B	;set parity on
	JMP	SETCFG
STDOFF:	ORI	00000010B	;set parity off
	JMP	SETCFG
;
; set command, modify RTS
;
STRTS:	LXI	D,RTSTBL	;find parity function requested
	CALL	LKTBL
	PUSH	H
	LDA	UCONFG
	RNC			;execute it
	POP	H
	LXI	D,HLRTS		;parity help message
	JMP	SETERR		;not valid then say so 				
RTSTBL:	DB	'O','N'+80H	;parity table
	DW	STRON		;enable parity
	DB	'OF','F'+80H
	DW	STROFF		;disable parity
	DB	0
STRON:	ANI	11111110B	;set parity on
	JMP	SETCFG
STROFF:	ORI	00000001B	;set parity off
	JMP	SETCFG
;
SETERR:	PUSH	D		;save help command text
	CALL	ILPRIN
	DB	ESC,IVON,CR,LF,'SET COMMAND ERROR',ESC,IVOFF,CR,LF,LF,0
	POP	D		;restore help text
	CALL	GPRINT		;go print help msg
	JMP	SETSHO		;show current commands
;
SETCFG:	STA	UCONFG		;set new config value
SCLSHO	CALL	CLS
				;fall tru to show routine
;
; print out current values
;
SETSHO:	LDA	UCONFG		;get config value
	OUT	MODCTL		;set configuration
	CALL	ILPRIN		;in-line print
	DB	CR,LF,ESC,IVON,'CURRENT VALUES:',ESC,IVOFF,' ',0
	LXI	H,SHOTBL	;show subroutines table
	CALL	SETSLP		;perform table routines
	RET
SHOTBL:	DW	BDSHOW		;baud show
	DW	LFTMRG		;marge and skip i line
	DW	UASHOW		;UART show
	DW	LFTMRG
	DW	CBITSH		;modem controlbits show
	DW	CRLF		;skip 1 line
	DW	0
;
; show baud rate's
;
BDSHOW:	LDA	MSPEED		;get MSPEED to determine present
	LXI	D,BD7512	;for 75 send 1200 receive.
	CPI	8		;
	JZ	BDEXIT		;if 75/1200
	LXI	D,BD1275	;for 1200 send 75 receive.
	CPI	9		;
	JZ	BDEXIT		;if 1200/75
	MVI	C,PRBAUD	;baud rate
	CALL	MEX
	LXI	D,NSBAUD	;send/receive message
BDEXIT:	CALL	GPRINT		;for send receive message
	CALL	CRLF
	RET
BD7512:	DB	'send 75 bps, receive 1200 bps.$'
BD1275:	DB	'send 1200 bps, receive 75 bps.$'
NSBAUD:	DB	' send/receive.$'
;
; show UART values
;
UASHOW:	CALL	ILPRIN
	DB	'<',0
	LDA	UCONFG		;get current configuration
	ANI	WBMASK		;only word size bits
	RLC			;shift left to bits 0 & 1
	RLC
	RLC
	MOV	C,A
	MVI	B,0
	LXI	H,WBTBL		;table ascii values data bits
	DAD	B
	MOV	A,M
	CALL	TYPE		;print found value
	CALL	ILPRIN
	DB	'> data bits, ',0
	CALL	ILPRIN
	DB	'<',0
	LDA	UCONFG
	ANI	SBMASK		;only stop-bits bit
	MVI	A,'1'		;1 stop bit if zero
	JZ	SSTXIT 
	INR	A
SSTXIT:	CALL	TYPE
	CALL	ILPRIN
	DB	'> stop bit(s), ',0	
	LDA	UCONFG
	ANI	PONMSK		;on/off bit
	LXI	D,POFMSG	;get set for no parity
	JNZ	PARXIT		;print it
	LXI	D,EVEMSG	;get parity even message
	LDA	UCONFG
	ANI	POEMSK		;odd/even bit
	JNZ	PARXIT		;yes then say so
	LXI	D,ODDMSG	;get parity odd message
PARXIT:	CALL	GPRINT
	CALL	ILPRIN
	DB	' parity.',CR,LF,0
	RET
WBTBL:	DB	'5','7','6','8'
POFMSG:	DB	'<NO>$'
ODDMSG:	DB	'<ODD>$'
EVEMSG:	DB	'<EVEN>$'
;
; show modem control:(XMT, DTR, RTS) output bits
;		     (CTS, DSR, CD, RI) input bits
;
CBITSH:	LXI	D,DTRMSG	;DTR bit
	MVI	B,DTRMSK
	CALL	TSCBIT
	LXI	D,RTSMSG	;RTS bit
	MVI	B,RTSMSK
	CALL	TSCBIT
	LXI	D,CTSMSG	;CTS bit
	MVI	B,CTSMSK
	CALL	TSPBIT
	LXI	D,DSRMSG	;DSR bit
	MVI	B,DSRMSK
	CALL	TSPBIT
	LXI	D,CDMESG	;CD bit
	MVI	B,CDMASK
	CALL	TSPBIT
	LXI	D,RIMESG	;RI bit
	MVI	B,RIMASK
	CALL	TSPBIT
	CALL	ILPRIN
	DB	'.',CR,LF,0
	RET
TSCBIT:	CALL	GPRINT
	LDA	UCONFG
	JMP	PONOFF
TSPBIT:	CALL	GPRINT
	IN	UAPORT		;(E8)
PONOFF:	ANA	B		;and with mask
	LXI	D,ONMESG	;' on'
	JZ	BITON		;if Z then bit is on (inverted logic)
	LXI	D,OFFMSG	;' off'
BITON:	CALL	GPRINT
	RET
ONMESG:	DB	' on$'
OFFMSG:	DB	' off$'
DTRMSG:	DB	'DTR$'
RTSMSG:	DB	', RTS$'
CTSMSG:	DB	', CTS$'
DSRMSG:	DB	', DSR$'
CDMESG:	DB	', CD$'
RIMESG:	DB	', RI$'
;
; overlay's voice in the sign-on message
;
SYSVER:	LXI	D,SOMESG
	CALL	GPRINT
	RET
;
; Send a break tone to reset some time-share computers.
;
PBREAK:	LDA	UCONFG		;current UART config byte
	ANI	BRKMSK		;set the txt break bit low 11111011B
	OUT	MODCTL		;(EA)
	MVI	B,3
	MVI	C,TIMER
	CALL	MEX		;delay 200 ms
	LDA	UCONFG
	OUT	MODCTL		;restore old UART value
 	RET
;
; common used routines
;
SETSLP: MOV	E,M		;get table address
	INX	H
	MOV	D,M
	INX	H
	MOV	A,D		;end of table
	ORA	E
	RZ			;exit if yes
	PUSH	H		;save table pointer
	XCHG			;addrs to HL
	CALL	GOHL		;do it
	MVI	C,CHEKCC	;check for console abort
	CALL	MEX		
	POP	H		;its done
	JNZ	SETSLP		;continue if no abort
	RET
GOHL:	PCHL
;
LFTMRG:	CALL	ILPRIN
	DB	'                ',0
	RET
;
CRLF:	MVI	A,CR		;newline on console
	CALL	TYPE
	MVI	A,LF
TYPE:	PUSH	H		;save em
	PUSH	D
	PUSH	B
	MOV	E,A
	MVI	C,CONOUT	;align output char
	CALL	MEX		;print via mex
	POP	B		;restore emŠ	POP	D
	POP	H
	RET		
;
GPRINT:	MVI	C,PRINTŠ	JMP	MEX
;
ILPRIN:	MVI	C,ILP
	JMP	MEX
;
LKTBL:	MVI	C,LOOKUP
	JMP	MEX
;
; Message and buffer area
;
UCONFG:	DS	1		;current UART config image
;
CLSMSG:	DB	CTRLZ,'$'
EOSMSG:	DB	01DH,'$'
;
SOMESG:	DB	ESC,IVON,LF,'TRS BvHPf ZCP/M 2.2 overlay Version '
	DB	REV/10+'0','.',REV MOD 10+'0',CR,LF
	DB	'With split baud rate support           ',CR,LF,LF,ESC,IVOFF,'$'
;
HLPMSG:	DB	ESC,IVON,'SET, BvhPf ZCP/M Overlay version '
	DB	REV/10+'0','.',REV MOD 10+'0',CR,LF,ESC,IVOFF,'$'
HLBAUD:	DB	'SET B(AUD) <value>  [set new baud-rate]',CR,LF
	DB	'    allowed values are: 50, 75, 300, 600, 1200,',CR,LF
	DB	'    2400, 4800, 9600, 75/12 or 12/75.',CR,LF,'$'
HLPARI:	DB	'SET P(ARITY) <mode> [set parity check]',CR,LF
	DB	'    allowed modes are : ON, OFF, ODD or EVEN.',CR,LF,'$'
HLWORD:	DB	'SET W(ORD) <value>  [set number of data bits]',CR,LF
	DB	'    allowed values are: 5, 6, 7 or 8.',CR,LF,'$'
HLSTOP:	DB	'SET S(TOP) <value>  [set number of stop bits]',CR,LF
	DB	'    allowed values are: 1 or 2.4',CR,LF,'$'
HLDTR:	DB	'SET DTR <mode> [set DTR line]',CR,LF
	DB	'    allowed modes are : ON or OFF.',CR,LF,'$'
HLRTS:	DB	'SET RTS <mode> [set RTS line]',CR,LF
	DB	'    allowed modes are : ON or OFF.',CR,LF,'$'
;
;
;----------------------------------------------------------------------
; NOTE:  MUST TERMINATE PRIOR TO 0B00H (with Smartmodem or Anchor)
;----------------------------------------------------------------------
;
  	END
