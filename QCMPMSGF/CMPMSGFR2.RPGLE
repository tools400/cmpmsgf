**free
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
//  Datum       Name          nderung                                 *
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
ctl-opt debug nomain;
ctl-opt extbinint(*yes);
ctl-opt option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
/copy QCMPMSGF,COPYRIGHT
//===============================================================*
dcl-f CMPMSGFD2 workstn(*ext) usage(*input: *output) usropn infds(Screen) indds(workstn);

dcl-ds workstn qualified;
  cpyl_pc   ind pos(61);
  cpyr_pc   ind;
  equal_pc  ind;
  nequal_pc ind;
  cpyl_ri   ind pos(71);
  cpyr_ri   ind;
  equal_ri  ind;
  nequal_ri ind;
  msgsflend ind pos(89);
end-ds;


//== Workstation information data structure =====================*
dcl-ds screen;
  screen_Open   char(1) pos(9);
  screen_status zoned(5) pos(11);
  screen_AID    char(1) pos(369);
end-ds;
//===============================================================*

//== Prototypes and Constants ===================================*
/copy QCMPMSGF,CMPMSGFR4
//===============================================================*

//== Private Prototypes =========================================*

// ... end program
dcl-pr cmd_endPgm ind;
end-pr;

// ... refresh screen
dcl-pr cmd_refresh;
end-pr;

// ... process enter key
dcl-pr cmd_enter ind;
end-pr;

//  ... clear screen indicators
dcl-pr p_scrClrInd;
end-pr;
//===============================================================*

//== Global fields ==============================================*
dcl-s g_cpyr char(1) inz;
dcl-s g_cpyl char(1) inz;
dcl-s g_equal char(1) inz;
dcl-s g_nequal char(1) inz;
//===============================================================*

//===============================================================*
//   Main procedure (with local variables)
//===============================================================*
dcl-proc f_chgFilter export;
  dcl-pi *n char(1);
    io_cpyr   char(1);
    io_cpyl   char(1);
    io_equal  char(1);
    io_nequal char(1);
  end-pi;

  //  Return value
  dcl-s rtnKey char(1) inz;

  //  Fields
  dcl-s isDone ind inz;
  dcl-ds msg likeds(msg_t) inz;

/copy QCMPMSGF,USR0017
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_cpyr = io_cpyr;
  g_cpyl = io_cpyl;
  g_equal = io_equal;
  g_nequal = io_nequal;

  ZEI = 3;
  POS = 3;

  //  Load screen values
  cmd_refresh();

  //  Initialize MsgQ Name
  //**                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
  PGMQ = '_CL_PEP';

  //  Remove program messages
  p_rmvPgmMsg(cMsg_Same: cMsg_ToPgmBdy);

  //  Clear indicators
  p_scrClrInd();

  //  Loop until no more changes
  isDOne = cFalse;

  Dou (isDone);

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
    p_rmvPgmMsg(cMsg_Same: cMsg_ToPgmBdy);

    //  Process command key ...
    Select;
    //  ... F3  - End program
    When (screen_AID = cKeyF3);
      isDone = cmd_endPgm();
    //  ... F5  - Refresh screen
    When (screen_AID = cKeyF5);
      cmd_refresh();

    //  ... F12 - End program
    When (screen_AID = cKeyF12);
      isDone = cmd_endPgm();

    //  ... ENTER
    When (screen_AID = cKeyEnter);
      isDone = cmd_enter();

      If (isDone);
        io_cpyr = g_cpyr;
        io_cpyl = g_cpyl;
        io_equal = g_equal;
        io_nequal = g_nequal;
      Endif;

    Other;
      //  ... wrong key
      msg = f_newMsg('USR0001');
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Endsl;

  Enddo;

  Write RMVWDW;

  rtnKey = screen_AID;

  Return rtnKey;

end-proc;

//===============================================================*
//  cmd_endPgm
//===============================================================*
dcl-proc cmd_endPgm;
  dcl-pi *n ind;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_rmvPgmMsg(cMsg_Same: cMsg_ToPgmBdy);

  Return cTrue;

end-proc;

//===============================================================*
//  cmd_refresh
//===============================================================*
dcl-proc cmd_refresh;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ##CPYR = g_cpyr;
  ##CPYL = g_cpyl;
  ##EQUAL = g_equal;
  ##NEQUAL = g_nequal;

  Return;

end-proc;

//===============================================================*
//  cmd_enter
//===============================================================*
dcl-proc cmd_enter;
  dcl-pi *n ind;
  end-pi;

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Check ##CPYL
  If (##CPYL <> 'Y' and ##CPYL <> 'N');
    msg = f_newMsg('USR0019');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.cpyl_pc = cTrue;
    workstn.cpyl_ri = cTrue;
    return cFalse;
  Endif;

  //  Check ##CPYR
  If (##CPYR <> 'Y' and ##CPYR <> 'N');
    msg = f_newMsg('USR0019');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.cpyr_pc = cTrue;
    workstn.cpyr_ri = cTrue;
    return cFalse;
  Endif;

  //  Check ##EQUAL
  If (##EQUAL <> 'Y' and ##EQUAL <> 'N');
    msg = f_newMsg('USR0019');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.equal_pc = cTrue;
    workstn.equal_ri = cTrue;
    return cFalse;
  Endif;

  //  Check ##NEQUAL
  If (##NEQUAL <> 'Y' and ##NEQUAL <> 'N');
    msg = f_newMsg('USR0019');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.nequal_pc = cTrue;
    workstn.nequal_ri = cTrue;
    return cFalse;
  Endif;

  g_cpyr = ##CPYR;
  g_cpyl = ##CPYL;
  g_equal = ##EQUAL;
  g_nequal = ##NEQUAL;

  Return cTrue;

end-proc;

//===============================================================*
//  scrClrInd
//===============================================================*
dcl-proc p_scrClrInd;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstn.cpyr_pc = cFalse;
  workstn.cpyl_pc = cFalse;
  workstn.equal_pc = cFalse;
  workstn.nequal_pc = cFalse;

  workstn.cpyr_ri = cFalse;
  workstn.cpyl_ri = cFalse;
  workstn.equal_ri = cFalse;
  workstn.nequal_ri = cFalse;

end-proc;

//===============================================================*
//  Load Module "Filter"
//===============================================================*
dcl-proc p_loadFilter export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not %open(CMPMSGFD2));
    Open CMPMSGFD2;
  Endif;

end-proc;

//===============================================================*
//  Unload Module "Filter"
//===============================================================*
dcl-proc p_unloadFilter export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (%open(CMPMSGFD2));
    Close CMPMSGFD2;
  Endif;

end-proc;

