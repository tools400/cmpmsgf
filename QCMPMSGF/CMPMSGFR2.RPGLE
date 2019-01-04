       //%%TS  SD  20011025  160518  RADDATZ     REL-V4R4M0  5769-PW1
       // =================================================================== *
       //                                                                     *
       //  Kurzdokumentation :                                                *
       //                                                                     *
       //  Bereich . . . : CMPMSGF                                            *
       //  Objekt  . . . : CMPMSGFR2                                          *
       //  Beschreibung  : Tool: CMPMSGF    (Compare Message File     )       *
       //  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
       //  Datum . . . . : 20.12.2001                                         *
       //                                                                     *
       // =================================================================== *
       //                                                                     *
       //  This software is free software, you can redistribute it and/or     *
       //  modify it under the terms of the GNU General Public License (GPL)  *
       //  as published by the Free Software Foundation.                      *
       //                                                                     *
       //  See GNU General Public License for details.                        *
       //          http://www.opensource.org                                  *
       //          http://www.opensource.org/licenses/gpl-license.html        *
       //                                                                     *
       // =================================================================== *
       //  History:                                                           *
       //                                                                     *
       //  Datum       Name          Änderung                                 *
       //  ----------  ------------  ---------------------------------------  *
       //                                                                     *
       //                                                                     *
       //                                                                     *
       // =================================================================== *
       //   >>PRE-COMPILER<<                                                  *
       //                                                                     *
       //     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
       //                              SRCFILE(&SL/&SF) +                     *
       //                              SRCMBR(&SM);                           *
       //                                                                     *
       //     >>COMPILE<<                                                     *
       //       >>PARM<< TRUNCNBR(*NO);                                       *
       //       >>PARM<< DBGVIEW(*LIST);                                      *
       //       >>PARM<< OPTION(*EVENTF);                                     *
       //     >>END-COMPILE<<                                                 *
       //                                                                     *
       //     >>EXECUTE<<                                                     *
       //                                                                     *
       //   >>END-PRE-COMPILER<<                                              *
       // =================================================================== *
     H DEBUG
     H NOMAIN
     H EXTBININT(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
      /COPY QCMPMSGF,COPYRIGHT
       //===============================================================*
     FCMPMSGFD2 CF   E             WORKSTN usropn
     F                                     infds(Screen)
     F                                     indds(workstn)
       //
     D workstn         DS                  qualified
     D  cpyl_pc               61     61N
     D  cpyr_pc               62     62N
     D  equal_pc              63     63N
     D  nequal_pc             64     64N
     D  cpyl_ri               71     71N
     D  cpyr_ri               72     72N
     D  equal_ri              73     73N
     D  nequal_ri             74     74N
     D  msgsflend             89     89N
     D

       //== Workstation information data structure =====================*
     D screen          DS
     D screen_Open             9      9A
     D screen_status          11     15S 0
     D screen_AID            369    369A
       //===============================================================*

       //== Prototypes and Constants ===================================*
      /COPY QCMPMSGF,CMPMSGFR4
       //===============================================================*

       //== Private Prototypes =========================================*

       // ... end program
     D cmd_endPgm...
     D                 PR              N

       // ... refresh screen
     D cmd_refresh...
     D                 PR

       // ... process enter key
     D cmd_enter...
     D                 PR              N

       //  ... clear screen indicators
     D p_scrClrInd...
     D                 PR
       //===============================================================*

       //== Global fields ==============================================*
     D g_cpyr          S              1A   inz
     D g_cpyl          S              1A   inz
     D g_equal         S              1A   inz
     D g_nequal        S              1A   inz
       //===============================================================*

       //===============================================================*
       //   Main procedure (with local variables)
       //===============================================================*
     P f_chgFilter...
     P                 B                   export
     D                 PI             1A
     D  io_cpyr                       1A
     D  io_cpyl                       1A
     D  io_equal                      1A
     D  io_nequal                     1A

       //  Return value
     D rtnKey          S              1A   inz

       //  Fields
     D isDone          S               N   inz
     D msg             DS                  likeds(msg_t) inz

      /COPY QCMPMSGF,USR0017
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       g_cpyr   = io_cpyr;
       g_cpyl   = io_cpyl;
       g_equal  = io_equal;
       g_nequal = io_nequal;

       ZEI = 3;
       POS = 3;

       //  Load screen values
       cmd_refresh();

       //  Initialize MsgQ Name
       //**                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
       PGMQ = '_CL_PEP';

       //  Remove program messages
       p_rmvPgmMsg(cMsg_Same     :
                  cMsg_ToPgmBdy );

       //  Clear indicators
       p_scrClrInd();

       //  Loop until no more changes
       isDOne = cFalse;

       Dou isDone;

          //  Display messages
          workstn.msgsflend = cFalse;
          Write MSGCTL;

          //  Display command keys
          Write BOT#1;

          //  Display window
          Exfmt SCR;

          //  Clear indicators
          p_scrClrInd();

          //  Remove messages
          p_rmvPgmMsg(cMsg_Same     :
                     cMsg_ToPgmBdy );

          //  Process command key ...
          Select;
             //  ... F3  - End program
          When screen_AID = cKeyF3;
             isDone = cmd_endPgm;
             //  ... F5  - Refresh screen
          When screen_AID = cKeyF5;
             cmd_refresh();

             //  ... F12 - End program
          When screen_AID = cKeyF12;
             isDone = cmd_endPgm;

             //  ... ENTER
          When screen_AID = cKeyEnter;
             isDone = cmd_enter;

             If isDone;
                io_cpyr   = g_cpyr;
                io_cpyl   = g_cpyl;
                io_equal  = g_equal;
                io_nequal = g_nequal;
             Endif;

          Other;
             //  ... wrong key
             msg = f_newMsg('USR0001');
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
          Endsl;

       Enddo;

       Write RMVWDW;

       rtnKey = screen_AID;

       Return rtnKey;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_endPgm
       //===============================================================*
     P cmd_endPgm...
     P                 B
     D                 PI              N
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       p_rmvPgmMsg(cMsg_Same     :
                  cMsg_ToPgmBdy );

       Return cTrue;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_refresh
       //===============================================================*
     P cmd_refresh...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       ##CPYR   = g_cpyr;
       ##CPYL   = g_cpyl;
       ##EQUAL  = g_equal;
       ##NEQUAL = g_nequal;

       Return;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_enter
       //===============================================================*
     P cmd_enter...
     P                 B
     D                 PI              N

     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       //  Check ##CPYL
       If (##CPYL <> 'Y')  and
          (##CPYL <> 'N');
          msg = f_newMsg('USR0019');
          p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy );
          workstn.cpyl_pc = cTrue;
          workstn.cpyl_ri = cTrue;
          return cFalse;
       Endif;

       //  Check ##CPYR
       If (##CPYR <> 'Y')  and
          (##CPYR <> 'N');
          msg = f_newMsg('USR0019');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          workstn.cpyr_pc = cTrue;
          workstn.cpyr_ri = cTrue;
          return cFalse;
       Endif;

       //  Check ##EQUAL
       If (##EQUAL <> 'Y')  and
          (##EQUAL <> 'N');
          msg = f_newMsg('USR0019');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          workstn.equal_pc = cTrue;
          workstn.equal_ri = cTrue;
          return cFalse;
       Endif;

       //  Check ##NEQUAL
       If (##NEQUAL <> 'Y')  and
          (##NEQUAL <> 'N');
          msg = f_newMsg('USR0019');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          workstn.nequal_pc = cTrue;
          workstn.nequal_ri = cTrue;
          return cFalse;
       Endif;

       g_cpyr = ##CPYR;
       g_cpyl = ##CPYL;
       g_equal = ##EQUAL;
       g_nequal = ##NEQUAL;

       Return cTrue;

      /END-FREE
     P                 E

       //===============================================================*
       //  scrClrInd
       //===============================================================*
     P p_scrClrInd...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       workstn.cpyr_pc   = cFalse;
       workstn.cpyl_pc   = cFalse;
       workstn.equal_pc  = cFalse;
       workstn.nequal_pc = cFalse;

       workstn.cpyr_ri   = cFalse;
       workstn.cpyl_ri   = cFalse;
       workstn.equal_ri  = cFalse;
       workstn.nequal_ri = cFalse;

      /END-FREE
     P                 E

       //===============================================================*
       //  Load Module "Filter"
       //===============================================================*
     P p_loadFilter...
     P                 B                   export
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not %open(CMPMSGFD2);
          Open CMPMSGFD2;
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  Unload Module "Filter"
       //===============================================================*
     P p_unloadFilter...
     P                 B                   export
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If %open(CMPMSGFD2);
          Close CMPMSGFD2;
       Endif;

      /END-FREE
     P                 E

