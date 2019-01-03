 RAD  *%%TS  SD  20011025  160518  RADDATZ     REL-V4R4M0  5769-PW1
 RAD  * =================================================================== *
 RAD  *                                                                     *
 RAD  *  Kurzdokumentation :                                                *
 RAD  *                                                                     *
 RAD  *  Bereich . . . : CMPMSGF                                            *
 RAD  *  Objekt  . . . : CMPMSGFR2                                          *
 RAD  *  Beschreibung  : Tool: CMPMSGF    (Compare Message File     )       *
 RAD  *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
 RAD  *  Datum . . . . : 20.12.2001                                         *
 RAD  *                                                                     *
 RAD  * =================================================================== *
 RAD  *                                                                     *
 RAD  *  This software is free software, you can redistribute it and/or     *
 RAD  *  modify it under the terms of the GNU General Public License (GPL)  *
 RAD  *  as published by the Free Software Foundation.                      *
 RAD  *                                                                     *
 RAD  *  See GNU General Public License for details.                        *
 RAD  *          http://www.opensource.org                                  *
 RAD  *          http://www.opensource.org/licenses/gpl-license.html        *
 RAD  *                                                                     *
 RAD  * =================================================================== *
 RAD  *  History:                                                           *
 RAD  *                                                                     *
 RAD  *  Datum       Name          Änderung                                 *
 RAD  *  ----------  ------------  ---------------------------------------  *
 RAD  *                                                                     *
 RAD  *                                                                     *
 RAD  *                                                                     *
 RAD  * =================================================================== *
 RAD  *   >>PRE-COMPILER<<                                                  *
 RAD  *                                                                     *
 RAD  *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
 RAD  *                              SRCFILE(&SL/&SF) +                     *
 RAD  *                              SRCMBR(&SM);                           *
 RAD  *                                                                     *
 RAD  *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
 RAD  *     >>END-COMPILE<<                                                 *
 RAD  *                                                                     *
 RAD  *     >>EXECUTE<<                                                     *
 RAD  *                                                                     *
 RAD  *   >>END-PRE-COMPILER<<                                              *
 RAD  * =================================================================== *
     H DEBUG
     H NOMAIN
     H EXTBININT(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
      /COPY QCMPMSGF,COPYRIGHT
      *===============================================================*
     FCMPMSGFD2 CF   E             WORKSTN usropn
     F                                     infds(Screen)
     F                                     indds(workstn)
      *
     D workstn         DS
      *
     D  workstn_cpyl_pc...
     D                        61     61N
     D  workstn_cpyr_pc...
     D                        62     62N
     D  workstn_equal_pc...
     D                        63     63N
     D  workstn_nequal_pc...
     D                        64     64N
      *
     D  workstn_cpyl_ri...
     D                        71     71N
     D  workstn_cpyr_ri...
     D                        72     72N
     D  workstn_equal_ri...
     D                        73     73N
     D  workstn_nequal_ri...
     D                        74     74N
      *
     D  workstn_msgsflend...
     D                        89     89N
      *
      *== Workstation information data structure =====================*
     D screen          DS
     D  screen_Open            9      9A
     D  screen_status         11     15S 0
     D  screen_AID           369    369A
      *===============================================================*
      *
      *== Prototypes and Constants ===================================*
      /COPY QCMPMSGF,CMPMSGFR4
      *===============================================================*
      *
      *== Private Prototypes =========================================*
      *
      * ... end program
     D cmd_endPgm...
     D                 PR              N
      *
      * ... refresh screen
     D cmd_refresh...
     D                 PR
      *
      * ... process enter key
     D cmd_enter...
     D                 PR              N
      *
      *  ... clear screen indicators
     D p_scrClrInd...
     D                 PR
      *===============================================================*
      *
      *== Global fields ==============================================*
     D g_cpyr          S              1A   inz
     D g_cpyl          S              1A   inz
     D g_equal         S              1A   inz
     D g_nequal        S              1A   inz
      *===============================================================*
      *
      *===============================================================*
      *   Main procedure (with local variables)
      *===============================================================*
      *
     P f_chgFilter...
     P                 B                   export
      *
     D f_chgFilter...
     D                 PI             1A
     D  io_cpyr                       1A
     D  io_cpyl                       1A
     D  io_equal                      1A
     D  io_nequal                     1A
      *
      *  Return value
     D rtnKey          S              1A   inz
      *
      *  Fields
     D isDone          S               N   inz
     D msg           E DS                  extname(xdmsg     )
     D                                     prefix(msg_)
      *
      /COPY QCMPMSGF,USR0017
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      g_cpyr   = io_cpyr
     C                   Eval      g_cpyl   = io_cpyl
     C                   Eval      g_equal  = io_equal
     C                   Eval      g_nequal = io_nequal
      *
     C                   Eval      ZEI = 3
     C                   Eval      POS = 3
      *
      *  Load screen values
     C                   Callp     cmd_refresh
      *
      *  Initialize MsgQ Name
      ***                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
     C                   Eval      PGMQ = '_CL_PEP'
      *
      *  Remove program messages
     C                   Callp     p_rmvPgmMsg(cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
      *  Clear indicators
     C                   Callp     p_scrClrInd
      *
      *  Loop until no more changes
     C                   Eval      isDOne = cFalse
      *
     C                   Dou       isDone
      *
      *  Display messages
     C                   Eval      workstn_msgsflend = cFalse
     C                   Write     MSGCTL
      *
      *  Display command keys
     C                   Write     BOT#1
      *
      *  Display window
     C                   Exfmt     SCR
      *
      *  Clear indicators
     C                   Callp     p_scrClrInd
      *
      *  Remove messages
     C                   Callp     p_rmvPgmMsg(cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
      *  Process command key ...
     C                   Select
      *  ... F3  - End program
     C                   When      screen_AID = cKeyF3
     C                   Eval      isDone = cmd_endPgm
      *  ... F5  - Refresh screen
     C                   When      screen_AID = cKeyF5
     C                   Callp     cmd_refresh
      *
      *  ... F12 - End program
     C                   When      screen_AID = cKeyF12
     C                   Eval      isDone = cmd_endPgm
      *
      *  ... ENTER
     C                   When      screen_AID = cKeyEnter
     C                   Eval      isDone = cmd_enter
      *
     C                   If        isDone
     C                   Eval      io_cpyr   = g_cpyr
     C                   Eval      io_cpyl   = g_cpyl
     C                   Eval      io_equal  = g_equal
     C                   Eval      io_nequal = g_nequal
     C                   Endif
      *
     C                   Other
      *  ... wrong key
     C                   Eval      msg = f_newMsg('USR0001')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endsl
      *
     C                   Enddo
      *
     C                   Write     RMVWDW
      *
     C                   Eval      rtnKey = screen_AID
      *
     C                   Return    rtnKey
      *
     P f_chgFilter...
     P                 E
      *
      *===============================================================*
      *  cmd_endPgm
      *===============================================================*
      *
     P cmd_endPgm...
     P                 B
      *
     D cmd_endPgm...
     D                 PI              N
      *
      *  Return value
     D isDone          S               N   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Callp     p_rmvPgmMsg(cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      isDone = cTrue
      *
     C                   Return    isDone
      *
     P cmd_endPgm...
     P                 E
      *
      *===============================================================*
      *  cmd_refresh
      *===============================================================*
      *
     P cmd_refresh...
     P                 B
      *
     D cmd_refresh...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      ##CPYR   = g_cpyr
     C                   Eval      ##CPYL   = g_cpyl
     C                   Eval      ##EQUAL  = g_equal
     C                   Eval      ##NEQUAL = g_nequal
      *
     C                   Return
      *
     P cmd_refresh...
     P                 E
      *
      *===============================================================*
      *  cmd_enter
      *===============================================================*
      *
     P cmd_enter...
     P                 B
      *
     D cmd_enter...
     D                 PI              N
      *
      *  Return value
     D isDone          S               N   inz
      *
      *  Local fields
     D msg           E DS                  extname(xdmsg     )
     D                                     prefix(msg_)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      isDone     = cTrue
      *
      *  Check ##CPYL
     C                   If        (##CPYL <> 'Y')  and
     C                             (##CPYL <> 'N')
     C                   Eval      msg = f_newMsg('USR0019')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_cpyl_pc   = cTrue
     C                   Eval      workstn_cpyl_ri   = cTrue
     C                   Eval      isDone            = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Check ##CPYR
     C                   If        (##CPYR <> 'Y')  and
     C                             (##CPYR <> 'N')
     C                   Eval      msg = f_newMsg('USR0019')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_cpyr_pc   = cTrue
     C                   Eval      workstn_cpyr_ri   = cTrue
     C                   Eval      isDone            = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Check ##EQUAL
     C                   If        (##EQUAL <> 'Y')  and
     C                             (##EQUAL <> 'N')
     C                   Eval      msg = f_newMsg('USR0019')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_equal_pc   = cTrue
     C                   Eval      workstn_equal_ri   = cTrue
     C                   Eval      isDone            = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Check ##NEQUAL
     C                   If        (##NEQUAL <> 'Y')  and
     C                             (##NEQUAL <> 'N')
     C                   Eval      msg = f_newMsg('USR0019')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_nequal_pc   = cTrue
     C                   Eval      workstn_nequal_ri   = cTrue
     C                   Eval      isDone            = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *
     C                   Eval      g_cpyr   = ##CPYR
     C                   Eval      g_cpyl   = ##CPYL
     C                   Eval      g_equal  = ##EQUAL
     C                   Eval      g_nequal = ##NEQUAL
      *
     C     exitProcedure Tag
      *
     C                   Return    isDone
      *
     P cmd_enter...
     P                 E
      *
      *===============================================================*
      *  scrClrInd
      *===============================================================*
      *
     P p_scrClrInd...
     P                 B
      *
     D p_scrClrInd...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      workstn_cpyr_pc   = cFalse
     C                   Eval      workstn_cpyl_pc   = cFalse
     C                   Eval      workstn_equal_pc  = cFalse
     C                   Eval      workstn_nequal_pc = cFalse
      *
     C                   Eval      workstn_cpyr_ri   = cFalse
     C                   Eval      workstn_cpyl_ri   = cFalse
     C                   Eval      workstn_equal_ri  = cFalse
     C                   Eval      workstn_nequal_ri = cFalse
      *
     C                   Return
      *
     P p_scrClrInd...
     P                 E
      *
      *===============================================================*
      *  Load Module "Filter"
      *===============================================================*
      *
     P p_loadFilter...
     P                 B                   export
      *
     D p_loadFilter...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not %open(CMPMSGFD2)
     C                   Open      CMPMSGFD2
     C                   Endif
      *
     C                   Return
      *
     P p_loadFilter...
     P                 E
      *
      *===============================================================*
      *  Unload Module "Filter"
      *===============================================================*
      *
     P p_unloadFilter...
     P                 B                   export
      *
     D p_unloadFilter...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        %open(CMPMSGFD2)
     C                   Close     CMPMSGFD2
     C                   Endif
      *
     C                   Return
      *
     P p_unloadFilter...
     P                 E
      *
