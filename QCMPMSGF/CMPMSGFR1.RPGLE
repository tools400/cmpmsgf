**free
// =================================================================== *
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : CMPMSGF                                            *
//  Objekt  . . . : CMPMSGFR1                                          *
//  Beschreibung  : Tool: CMPMSGF    (Compare Message File     )       *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 25.10.2001                                         *
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
//  13.11.2001  Th.Raddatz    Fixed problem that the color of $$CD     *
//                            was not set when $$CD was changed        *
//                            manually.                                *
//  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
//                            "Position to" and added binary search.   *
//  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
//                            "Position to" and added binary search.   *
//  20.12.2001  Th.Raddatz    Added the "Filter" panel.                *
//  24.12.2001  Th.Raddatz    Added support for the rtvm0400 format    *
//                            and enhanced compare rules to use        *
//                            the message creation date/level and      *
//                            the message modification date/level.     *
//  14.04.2004  Th.Raddatz    Added addtional options:                 *
//                               - Copy to  (31/32)                    *
//                               - Change   (21/22)                    *
//                               - Delete   (41/42)                    *
//                               - Display  (51/52)                    *
//  15.04.2004  Th.Raddatz    Added addtional command keys:            *
//                               - Display Command Line Window (F21)   *
//  08.06.2005  Th.Raddatz    Fixed bug that the color of field "Cd"   *
//                            was not set properly on change.          *
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
dcl-f CMPMSGFD1 workstn(*ext) usage(*input: *output) usropn infds(Screen) indds(workstn)
  sfile(SFL: SFLRRN);

dcl-ds workstn qualified;
  cd_white  ind pos(50);
  cd_grn    ind;
  cd_ylw    ind;
  cd_red    ind;
  msgf1_pc  ind pos(61);
  lib1_pc   ind;
  msgf2_pc  ind pos(65);
  lib2_pc   ind;
  msgf1_ri  ind pos(71);
  lib1_ri   ind;
  msgf2_ri  ind pos(75);
  lib2_ri   ind;
  sfldsp    ind pos(80);
  sfldspctl ind;
  sflclr    ind;
  sflend    ind;
  sflmode   ind;
  sflnxtchg ind;
  opt_ri    ind;
  posto_ri  ind;
  find_ri   ind;
  msgsflend ind;
  options_1 ind pos(91);
  options_2 ind;
  options_3 ind;
end-ds;

//== Workstation information data structure =====================*
dcl-ds screen qualified;
  dcl-subf Open char(1) pos(9);
  status        zoned(5) pos(11);
  AID           char(1) pos(369);
end-ds;
//===============================================================*

//== Prototypes and Constants ===================================*
/copy QCMPMSGF,CMPMSGFR4
//===============================================================*

//== Private Prototypes =========================================*
//  ... end program
dcl-pr cmd_endPgm ind;
end-pr;

//  ... refresh screen
dcl-pr cmd_refresh;
  i_lowerMsgID char(7) value;
  i_upperMsgID char(7) value;
end-pr;

//  ... process
dcl-pr cmd_process ind;
  o_msg like(msg_t);
end-pr;

//  ... goto top of subfile
dcl-pr cmd_gotoTop;
end-pr;

//  ... goto botton of subfile
dcl-pr cmd_gotoBot;
end-pr;

//  ... show more cmd keys
dcl-pr cmd_moreKeys;
end-pr;

//  ... show more options
dcl-pr cmd_moreOptions;
end-pr;

//  ... command line
dcl-pr cmd_cmdLine;
end-pr;

//  ... process enter key
dcl-pr cmd_enter ind;
  i_lowerMsgID char(7) value;
  i_upperMsgID char(7) value;
end-pr;

//  ... page up
dcl-pr cmd_pageUp;
end-pr;

//  ... page down
dcl-pr cmd_pageDown;
end-pr;

//  ... validate screen
dcl-pr f_validateScreen ind;
end-pr;

//  ... read changed records
dcl-pr f_sflReadChg ind;
end-pr;

//  ... check if there are changed records
dcl-pr f_sflChkChg ind;
  o_sflRrn int(10) options(*nopass);
end-pr;

//  ... initialize subfile
dcl-pr p_sflInit;
end-pr;

//  ... position file pointer and read first record
dcl-pr p_sflPosKey ind;
  i_lowerMsgID char(7) value;
end-pr;

//  ... read next record
dcl-pr f_sflReadRcd ind;
end-pr;

//  ... load page into subfile
dcl-pr f_sflLoadPage ind;
  i_lowerMsgID char(7) value;
  i_upperMsgID char(7) value;
end-pr;

//  ... clear selection
dcl-pr p_sflClrSlc;
  i_sflRrn int(10) const;
end-pr;

//  ... set error status
dcl-pr p_sflsetErr;
  i_sflRrn int(10) const;
end-pr;

//  ... clear subfile/screen indicators
dcl-pr p_sflClrInd;
end-pr;

//  ... position to
dcl-pr p_sflPosTo;
  i_posTo like(##POSTO) value;
end-pr;

//  ... get first message id
dcl-pr f_getFirstMsgID ind;
  i_msgId char(7) value;
  i_msgF  char(10) value;
  i_lib   char(10) value;
  o_msgID char(7);
end-pr;

//  ... retrieve message text
dcl-pr f_rtvMsgText char(1024);
  i_rtvm0400 likeds(RTVM0400_t) value;
end-pr;

//  ... retrieve message help
dcl-pr f_rtvMsgHelp char(1024);
  i_rtvm0400 likeds(RTVM0400_t) value;
end-pr;

//  ... retrieve replacement variables
dcl-pr f_rtvRplVars char(1024);
  i_rtvm0400 likeds(RTVM0400_t) value;
end-pr;

//  ... open message file 1
dcl-pr p_openMsgF1;
  i_msgF char(10) value;
  i_lib  char(10) value;
end-pr;

//  ... open message file 2
dcl-pr p_openMsgF2;
  i_msgF char(10) value;
  i_lib  char(10) value;
end-pr;

//  ... close message file 1
dcl-pr p_closeMsgF1;
end-pr;

//  ... close message file 2
dcl-pr p_closeMsgF2;
end-pr;

//  ... is message file 1 open?
dcl-pr f_isOpenMsgF1 ind;
end-pr;

//  ... is message file 2 open?
dcl-pr f_isOpenMsgF2 ind;
end-pr;

//  ... get message file library
dcl-pr f_getMsgFLib char(10);
  i_msgF char(10) value;
  i_lib  char(10) value;
end-pr;

//  ... check if message file exists
dcl-pr f_chkMsgF ind;
  i_msgF char(10) value;
  i_lib  char(10) value;
  o_msg  like(msg_t);
end-pr;

//  ... change subfile action code
dcl-pr p_sflChgCode;
  i_rrn     int(10) value;
  i_newCode like($$CD) value;
end-pr;

//  ... subfile add message ID
dcl-pr f_sflAddMsgID ind;
  i_rrn  int(10) value;
  i_code char(1) value;
end-pr;

//  ... subfile change message ID
dcl-pr f_sflChgMsgID ind;
  i_rrn  int(10) value;
  i_code char(1) value;
end-pr;

//  ... subfile delete message ID
dcl-pr f_sflDltMsgID ind;
  i_rrn  int(10) value;
  i_code char(1) value;
end-pr;

//  ... subfile display message ID
dcl-pr f_sflDspMsgID ind;
  i_rrn  int(10) value;
  i_code char(1) value;
end-pr;

//  ... add message id
dcl-pr f_addMsgID ind;
  i_msgID    char(7) value;
  i_msgF     char(10) value;
  i_lib      char(10) value;
  i_baseMsgF char(10) value;
  i_baseLib  char(10) value;
end-pr;

//  ... change message id
dcl-pr f_changeMsgID ind;
  i_msgID char(7) value;
  i_msgF  char(10) value;
  i_lib   char(10) value;
end-pr;

//  ... delete message id
dcl-pr f_deleteMsgID ind;
  i_msgID char(7) value;
  i_msgF  char(10) value;
  i_lib   char(10) value;
end-pr;

//  ... display message id
dcl-pr f_displayMsgID ind;
  i_msgID char(7) value;
  i_msgF  char(10) value;
  i_lib   char(10) value;
end-pr;

//  ... copy message id
dcl-pr f_copyMsgID ind;
  i_msgID    char(7) value;
  i_fromMsgF char(10) value;
  i_fromLib  char(10) value;
  i_toMsgF   char(10) value;
  i_toLib    char(10) value;
end-pr;

//  ... fill subfile record
dcl-pr p_sflFilRcd;
  i_rtvm0400_1 likeds(RTVM0400_t) value;
  i_rtvm0400_2 likeds(RTVM0400_t) value;
end-pr;

//  ... set action code color attribute
dcl-pr p_sflSetCdColor;
  i_cd like($$CD) value;
end-pr;

//  ... refresh subfile record
dcl-pr p_sflRfrRcd;
  i_rrn int(10) value;
end-pr;

//  ... retrieve message description format rtvm0400
dcl-pr f_rtvMsgD likeds(RTVM0400_t);
  i_msgId   char(7) value;
  i_qMsgF   like(qobj_t) value;
  i_rtvOpt  char(10) value;
  o_errCode likeds(errCode_t) value;
end-pr;

//  ... create an new (empty) RTVM0300 format
dcl-pr f_newRtvm0300 likeds(RTVM0300_t);
end-pr;

//  ... create an new (empty) rtvm0400 format
dcl-pr f_newRtvm0400 likeds(RTVM0400_t);
end-pr;

//  ... convert string to lower case
dcl-pr f_toLower varchar(1024);
  i_string varchar(1024) const;
end-pr;

dcl-pr f_rtvCmdValues varchar(8192);
  i_msgID char(7) value;
  i_msgF  char(10) value;
  i_lib   char(10) value;
end-pr;
//===============================================================*

//== Global fields ==============================================*
//    g_sflPage = SFLPAG *  number of unfolded lines per entry
//    g_sflPage =    5   *    2
//g_sflPage       S             10I 0 inz(10)
dcl-s g_sflPage int(10) inz(*hival);
//    show options
dcl-s g_sflOpt int(10) inz(1);
dcl-s g_sflNumOpt int(10) inz(3);
//    show footer
dcl-s g_sflBot int(10) inz(1);
dcl-s g_sflNumBot int(10) inz(2);
//    subfile control
dcl-s g_sflNumRcd int(10) inz;
dcl-s g_sflMaxRcd int(10) inz(9999);
//    format name
dcl-s g_fmtName char(8) inz('RTVM0400');
//    filter options
dcl-s g_filterCpyR char(1) inz;
dcl-s g_filterCpyL char(1) inz;
dcl-s g_filterEqual char(1) inz;
dcl-s g_filterNEqual char(1) inz;
//    compare options
dcl-s g_cmpDate char(1) inz;
dcl-s g_cmpLvl char(1) inz;
//    find string
dcl-s g_find varchar(1024) inz;
//  Message Description IO (Open Data Paths)
dcl-ds g_RTVM0400_1 likeds(rtvm0400_t) inz;
dcl-ds g_RTVM0400_2 likeds(rtvm0400_t) inz;
dcl-ds g_qMsgF_1 likeds(qObj_t) inz;
dcl-ds g_qMsgF_2 likeds(qObj_t) inz;
dcl-s g_msgId_1 char(7) inz(cMSGID_HIVAL);
dcl-s g_msgId_2 char(7) inz(cMSGID_HIVAL);
dcl-s g_rtvOpt_1 char(10) inz(cMSGID_EOF);
dcl-s g_rtvOpt_2 char(10) inz(cMSGID_EOF);
//===============================================================*

//===============================================================*
//   Main procedure (with local variables)
//===============================================================*
dcl-proc f_cmpMsgF export;
  dcl-pi *n char(1);
    i_file1   char(10) const;
    i_lib1    char(10) const;
    i_file2   char(10) const;
    i_lib2    char(10) const;
    i_range   likeds(range_t) const;
    i_cmpDate char(1) const;
    i_cmpLvl  char(1) const;
    i_error   char(1) const;
  end-pi;

  //  Return value
  dcl-s rtnKey char(1) inz;

  //  Fields
  dcl-s isDone ind inz;
  dcl-ds range likeds(i_range) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-s isConfirmed_F9 ind inz;

/copy QCMPMSGF,USR0017
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  range = i_range;

  //  Set range selection for "*ALL"
  If (range.lower = '*ALL');
    range.lower = '*FIRST';
    range.upper = '*LAST';
  Endif;

  //  Validate range selection
  If (%subst(range.lower: 1: 1) <> '*' and
      %subst(range.upper: 1: 1) <> '*' and
      range.lower > range.upper);
    msg = f_newMsg('USR0018': '': '*ESCAPE');
    p_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
  Endif;

  //  Set screen fields
  ##MSGF1 = i_file1;
  ##LIB1 = i_lib1;
  ##MSGF2 = i_file2;
  ##LIB2 = i_lib2;
  ##POSTO = '';
  ##FIND = '';

  f_validateScreen();

  //  Display local location name
  $$SYSTEM = f_rtvNetAtrA('LCLLOCNAME');

  //  Set filter options
  If (i_error = 'Y');
    g_filterCpyR = 'Y';
    g_filterCpyL = 'Y';
    g_filterEqual = 'N';
    g_filterNEqual = 'Y';
  Else;
    g_filterCpyR = 'Y';
    g_filterCpyL = 'Y';
    g_filterEqual = 'Y';
    g_filterNEqual = 'Y';
  Endif;

  //  Set compare options
  g_cmpDate = i_cmpDate;
  g_cmpLvl = i_cmpLvl;

  //  Open files and initialize "filter" module
  p_openMsgF1(##MSGF1: ##LIB1);
  p_openMsgF2(##MSGF2: ##LIB2);

  Open CMPMSGFD1;
  p_loadFilter();

  //  Initialize MsgQ Name
  //**                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
  PGMQ = '_CL_PEP';

  //  Remove program messages
  p_rmvPgmMsg(cMsg_Same: cMsg_ToPgmBdy);

  //  Set initial subfile mode
  SFLMODE = cSflDrop;

  //  Clear indicators
  p_sflClrInd();

  //  Initial load of subfile
  cmd_refresh(range.lower: range.upper);

  //  Loop until no more changes
  isDOne = cFalse;

  Dou (isDone);

    //  Set subfile mode
    workstn.sflmode = SFLMODE;

    //  Display messages
    workstn.msgsflend = cFalse;
    Write MSGCTL;

    //  Display "no entries found"
    If (not workstn.sfldsp);
      Write EMPTY;
    Endif;

    //  Display options
    workstn.options_1 = cFalse;
    workstn.options_2 = cFalse;
    workstn.options_3 = cFalse;

    Select;
    When (g_sflOpt = 2);
      workstn.options_2 = cTrue;
    When (g_sflOpt = 3);
      workstn.options_3 = cTrue;
    Other;
      workstn.options_1 = cTrue;
    Endsl;

    //  Display command keys
    Select;
    When (g_sflBot = 2);
      Write BOT#2;
    Other;
      g_sflBot = 1;
      Write BOT#1;
    Endsl;

    //  Display subfile
    Exfmt CTL;

    //  Clear indicators
    p_sflClrInd();

    //  Remove messages
    p_rmvPgmMsg(cMsg_Same: cMsg_ToPgmBdy);

    //  Keep subfile position
    If (SFLCSRRRN > 0);
      SFLRCDNBR = SFLCSRRRN;
    Endif;

    //  Reset confirmation of F9 (Process)
    If (screen.AID <> cKeyF9);
      isConfirmed_F9 = cFalse;
    Endif;

    //  Process command key ...
    Select;
    //  ... F3  - End program
    When (screen.AID = cKeyF3);
      isDone = cmd_endPgm;

    //  ... F5  - Refresh screen
    When (screen.AID = cKeyF5);
      cmd_refresh(range.lower: range.upper);

    //  ... F9  - Process
    When (screen.AID = cKeyF9);
      If (isConfirmed_F9);
        If (not cmd_process(msg));
          p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
        Endif;
        isConfirmed_F9 = cFalse;
      Else;
        Clear USR0017;
        USR00171 = 'F9';
        msg = f_newMsg('USR0017': USR0017);
        p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
        isConfirmed_F9 = cTrue;
      Endif;

      isDOne = cFalse;

    //  ... F12 - End program
    When (screen.AID = cKeyF12);
      isDone = cmd_endPgm;

    //  ... F17 - Goto top of subfile
    When (screen.AID = cKeyF17);
      cmd_gotoTop();

    //  ... F18 - Goto end of subfile
    When (screen.AID = cKeyF18);
      cmd_gotoBot();

    //  ... F19 - Change Filter
    When (screen.AID = cKeyF19);
      If (f_chgFilter(g_filterCpyR: g_filterCpyL: g_filterEqual
                      : g_filterNEqual) = cKeyEnter);
        cmd_refresh(range.lower: range.upper);
      Endif;

    //  ... F21 - Command line
    When (screen.AID = cKeyF21);
      cmd_cmdLine();

    //  ... F23 - More options
    When (screen.AID = cKeyF23);
      cmd_moreOptions();

    //  ... F24 - More keys
    When (screen.AID = cKeyF24);
      cmd_moreKeys();

    //  ... ENTER
    When (screen.AID = cKeyEnter);
      isDone = cmd_enter(range.lower: range.upper);

    //  ... Page up
    When (screen.AID = cKeyPageUp);
      cmd_pageUp();

    //  ... Page down
    When (screen.AID = cKeyPageDown);
      cmd_pageDown();

    Other;
      //  ... wrong key
      msg = f_newMsg('USR0001');
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Endsl;

  Enddo;

  //  Close files
  Close CMPMSGFD1;
  p_unloadFilter();

  p_closeMsgF1();
  p_closeMsgF2();

  //  Pass back last key stroke
  rtnKey = screen.AID;

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
    i_lowerMsgID char(7) value;
    i_upperMsgID char(7) value;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ##MSGF1 = g_qMsgF_1.name;
  ##LIB1 = g_qMsgF_1.lib;

  ##MSGF2 = g_qMsgF_2.name;
  ##LIB2 = g_qMsgF_2.lib;

  p_sflInit();

  If (p_sflPosKey(i_lowerMsgID));
    f_sflLoadPage(i_lowerMsgID: i_upperMsgID);
  Endif;

end-proc;

//===============================================================*
//  cmd_process
//===============================================================*
dcl-proc cmd_process;
  dcl-pi *n ind;
    o_msg like(msg_t);
  end-pi;

  //  Local fields
  dcl-s rrn int(10) inz;

/copy QCMPMSGF,USR0016
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    Return cTrue;
  Endif;

  //  Loop through the subfile
  For rrn = 1 to g_sflNumRcd;
    Chain rrn SFL;

    Select;

    //  Copy to the right side
    When ($$CD = cCmpCopyRight);
      If (not f_copyMsgID($$MSGID: ##MSGF1: ##LIB1: ##MSGF2: ##LIB2));
        Clear USR0016;
        USR00161 = $$MSGID;
        o_msg = f_newMsg('USR0016': USR0016);
        p_sflSetErr(SFLRRN);
        Return cFalse;
      Else;
        p_sflRfrRcd(rrn);
      Endif;

    //  Copy to the left side
    When ($$CD = cCmpCopyLeft);
      If (not f_copyMsgID($$MSGID: ##MSGF2: ##LIB2: ##MSGF1: ##LIB1));
        Clear USR0016;
        USR00161 = $$MSGID;
        o_msg = f_newMsg('USR0016': USR0016);
        p_sflSetErr(SFLRRN);
        Return cFalse;
      Else;
        p_sflRfrRcd(rrn);
      Endif;

    //  Ignore other Codes
    Other;
      Iter;
    Endsl;

  Endfor;

  Return cTrue;

end-proc;

//===============================================================*
//  cmd_gotoTop
//===============================================================*
dcl-proc cmd_gotoTop;
  dcl-pi *n;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    msg = f_newMsg('USR0007');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Else;
    SFLRCDNBR = 1;
  Endif;

end-proc;

//===============================================================*
//  cmd_gotoBot
//===============================================================*
dcl-proc cmd_gotoBot;
  dcl-pi *n;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    msg = f_newMsg('USR0007');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Else;
    SFLRCDNBR = g_sflNumRcd;
  Endif;

end-proc;

//===============================================================*
//  cmd_moreKeys
//===============================================================*
dcl-proc cmd_moreKeys;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (g_sflBot < g_sflNumBot);
    g_sflBot = g_sflBot + 1;
  Else;
    g_sflBot = 1;
  Endif;

end-proc;

//===============================================================*
//  cmd_cmdLine
//===============================================================*
dcl-proc cmd_cmdLine;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  QUSCMDLN();

end-proc;

//===============================================================*
//  cmd_moreOptions
//===============================================================*
dcl-proc cmd_moreOptions;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (g_sflOpt < g_sflNumOpt);
    g_sflOpt = g_sflOpt + 1;
  Else;
    g_sflOpt = 1;
  Endif;

end-proc;

//===============================================================*
//  cmd_enter
//===============================================================*
dcl-proc cmd_enter;
  dcl-pi *n ind;
    i_lowerMsgID char(7) value;
    i_upperMsgID char(7) value;
  end-pi;

  //  Return value
  dcl-s isDone ind inz;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  dcl-s rrn int(10) inz;
  dcl-s isSflDirty ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  isSflDirty = cFalse;
  isDone     = cTrue;

  //  Validate screen ...
  If (not f_validateScreen());
    Return cFalse;
  Endif;

  //  Process MsgF 1 fields ...
  If (##MSGF1 <> g_qMsgF_1.name or ##LIB1 <> g_qMsgF_1.lib);

    isSflDirty = cTrue;

    If (f_isOpenMsgF1());
      p_closeMsgF1();
    Endif;
    p_openMsgF1(##MSGF1: ##LIB1);

  Endif;

  //  Process MsgF 2 fields ...
  If (##MSGF2 <> g_qMsgF_2.name or ##LIB2 <> g_qMsgF_2.lib);

    isSflDirty = cTrue;

    If (f_isOpenMsgF2());
      p_closeMsgF2();
    Endif;
    p_openMsgF2(##MSGF2: ##LIB2);

  Endif;

  //  Find string ...
  If (f_toLower(##FIND) <> g_find);
    isDone = cFalse;
    isSflDirty = cTrue;
    g_find = %trimR(f_toLower(##FIND));
  Endif;

  //  Refresh subfile if necessary ...
  If (isSflDirty);
    cmd_refresh(i_lowerMsgID: i_upperMsgID);
    isDone  = cFalse;
  Endif;

  //  Position to ...
  If (##POSTO <> ' ');
    p_sflPosTo(##POSTO);
    ##POSTO = '';
    isDone = cFalse;
  Endif;

  //  Process changed records
  If (f_sflReadChg());
    isDone = cFalse;
  Endif;

  Return isDone;

end-proc;

//===============================================================*
//  cmd_pageUp
//===============================================================*
dcl-proc cmd_pageUp;
  dcl-pi *n;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    msg = f_newMsg('USR0007');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Else;
    msg = f_newMsg('USR0005');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Endif;

end-proc;

//===============================================================*
//  cmd_pageDown
//===============================================================*
dcl-proc cmd_pageDown;
  dcl-pi *n;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    msg = f_newMsg('USR0007');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy );
  Else;
    msg = f_newMsg('USR0003');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Endif;

end-proc;

//===============================================================*
//  Validate Screen.
//===============================================================*
dcl-proc f_validateScreen;
  dcl-pi *n ind;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Message file 1
  If (not f_chkMsgF(##MSGF1: ##LIB1: msg));
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.msgF1_pc = *on;
    workstn.msgF1_ri = *on;
    workstn.lib1_pc = *on;
    workstn.lib1_ri = *on;
    Return cFalse;
  Endif;

  //  Message file 2
  If (not f_chkMsgF(##MSGF2: ##LIB2: msg));
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    workstn.msgF2_pc = *on;
    workstn.msgF2_ri = *on;
    workstn.lib2_pc = *on;
    workstn.lib2_ri = *on;
    Return cFalse;
  Endif;

  //  User should enter different message files
  If (##MSGF1 = ##MSGF2 and ##LIB1 = ##LIB2);
    msg = f_newMsg('USR0010');
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Return cFalse;
  Endif;

  Return cTrue;

end-proc;

//===============================================================*
//  f_sflReadChg
//===============================================================*
dcl-proc f_sflReadChg;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isChanged ind inz;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  dcl-s sflError ind inz;

  //  Message data structures
/copy QCMPMSGF,USR0006
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (not workstn.sfldsp);
    Return cFalse;
  Endif;

  //  Loop through the subfile
  isChanged = cFalse;
  sflError = cFalse;

  Dou (sflError);
    Readc SFL;
    If (%EOF(CMPMSGFD1));
      Leave;
    Endif;

    isChanged = cTrue;

    //  Remember last record processed
    SFLRCDNBR = SFLRRN;

    //  Process user option ...
    ##OPT = %trim(##OPT);
    //  ... no option
    Select;
    When (##OPT = '');
    //  ... "Copy to left"
    When (##OPT = 'L');
      If (H_MSGID2 <> '');
        p_sflChgCode(SFLRRN: cCmpCopyLeft);
      Else;
        p_sflChgCode(SFLRRN: cCmpNoAction);
      Endif;
    //  ... "Copy to right"
    When (##OPT = 'R');
      If (H_MSGID1 <> '');
        p_sflChgCode(SFLRRN: cCmpCopyRight);
      Else;
        p_sflChgCode(SFLRRN: cCmpNoAction);
      Endif;
    //  ... "No Action"
    When (##OPT = 'N');
      p_sflChgCode(SFLRRN: cCmpNoAction);
    //  ... "Change left"
    When (##OPT = '21');
      sflError = not f_sflChgMsgID(SFLRRN: 'L');
    //  ... "Copy to left"
    When (##OPT = '31');
      sflError = not f_sflAddMsgID(SFLRRN: 'L');
    //  ... "Delete left"
    When (##OPT = '41');
      sflError = not f_sflDltMsgID(SFLRRN: 'L');
    //  ... "Display left"
    When (##OPT = '51');
      sflError = not f_sflDspMsgID(SFLRRN: 'L');
    //  ... "Change right"
    When (##OPT = '22');
      sflError = not f_sflChgMsgID(SFLRRN: 'R');
    //  ... "Copy to right"
    When (##OPT = '32');
      sflError = not f_sflAddMsgID(SFLRRN: 'R');
    //  ... "Delete right"
    When (##OPT = '42');
      sflError = not f_sflDltMsgID(SFLRRN: 'R');
    //  ... "Display right"
    When (##OPT = '52');
      sflError = not f_sflDspMsgID(SFLRRN: 'R');
    //  ... invalid option
    Other;
      workstn.opt_ri = cTrue;
      sflError = cTrue;

      Clear USR0006;
      USR00061 = ##OPT;
      msg = f_newMsg('USR0006': USR0006);
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Endsl;

    //  Update subfile record
    If (sflError);
      p_sflSetErr(SFLRRN);
    Else;
      p_sflClrSlc(SFLRRN);
    Endif;

  Enddo;

  Return isChanged;

end-proc;

//===============================================================*
//  f_sflChkChg
//===============================================================*
dcl-proc f_sflChkChg;
  dcl-pi *n ind;
    o_sflRrn int(10) options(*nopass);
  end-pi;

  //  Return value
  dcl-s isChanged ind inz;

  //  Parameter positions
  dcl-c p_sflRrn 1;

  //  *  Local fields
  dcl-s rrn like(o_sflRrn) inz;
  dcl-s sfldsp like(workstn.sfldsp) inz;
  dcl-s sfldspctl like(workstn.sfldspctl) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  If there are no records in the subfile ...
  If (not workstn.sfldsp);
    isChanged = cFalse;
    rrn = 0;
  Else;

    Dou (##OPT <> '' or %EOF(CMPMSGFD1));
      Readc SFL;
      If (##OPT = '');
        p_sflClrSlc(SFLRRN);
      Endif;
    Enddo;

    // If no selection was found
    If (%EOF(CMPMSGFD1));
      isChanged = cFalse;
      rrn = 0;
    Else;

      isChanged = cTrue;
      rrn = SFLRRN;

      // re-activate subfile record
      workstn.sflnxtchg = cTrue;
      Update SFL;

      sfldsp = workstn.sfldsp;
      sfldspctl = workstn.sfldspctl;

      workstn.sfldsp = cTrue;
      workstn.sfldspctl = cFalse;
      WRITE CTL;
      workstn.sfldsp = sfldsp;
      workstn.sfldspctl = sfldspctl;

    Endif;
  Endif;

  //  Return RRN if passed
  If (%parms >= p_sflRrn);
    o_sflRrn = rrn;
  Endif;

  Return isChanged;

end-proc;

//===============================================================*
//  p_sflInit
//===============================================================*
dcl-proc p_sflInit;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstn.sfldsp = cFalse;
  workstn.sfldspctl = cFalse;
  workstn.sflclr = cTrue;
  workstn.sflend = cFalse;
  WRITE CTL;

  workstn.sfldspctl = cTrue;
  workstn.sflclr = cFalse;

  Reset g_sflPage;
  Reset g_sflBot;
  Reset g_sflNumBot;
  Reset g_sflNumRcd;

end-proc;

//===============================================================*
//  sflPosKey
//===============================================================*
dcl-proc p_sflPosKey;
  dcl-pi *n ind;
    i_lowerMsgID char(7) value;
  end-pi;

  //  Return value
  dcl-s isFound ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  f_getFirstMsgID(i_lowerMsgID: ##MSGF1: ##LIB1: g_msgId_1);
  g_rtvOpt_1 = cMSGID_SAME;

  f_getFirstMsgID(i_lowerMsgID: ##MSGF2: ##LIB2: g_msgId_2);
  g_rtvOpt_2 = cMSGID_SAME;

  //  Position file Pointer ...
  Dou (g_rtvm0400_1.msgId >= ' ' or g_rtvm0400_2.msgId >= ' ');
    isFound = f_sflReadRcd();
    If (not isFound);
      Leave;
    Endif;
  Enddo;

  Return isFound;

end-proc;

//===============================================================*
//  sflReadRcd
//===============================================================*
dcl-proc f_sflReadRcd;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isFound ind inz(cFalse);

  //  Fields
  dcl-ds errCode_1 likeds(errCode_t) inz;
  dcl-ds errCode_2 likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  errCode_1 = f_newApiErrCode(cTrue);

  //  Retrieve message description of 1. file
  If (g_rtvOpt_1 <> cMSGID_EOF);
    g_RTVM0400_1 = f_rtvMsgD(g_msgId_1: g_qMsgF_1: g_rtvOpt_1: errCode_1);
    If (f_isApiErr(errCode_1) or g_rtvm0400_1.bytAvl = 0);
      g_msgId_1 = cMSGID_HIVAL;
      g_rtvOpt_1 = cMSGID_EOF;
      g_RTVM0400_1 = f_newRtvm0400;
    Else;
      g_msgId_1 = g_rtvm0400_1.msgID;
      g_rtvOpt_1 = '*NEXT';
    Endif;
  Endif;

  errCode_2 = f_newApiErrCode(cTrue);

  //  Retrieve message description of 2. file
  If (g_rtvOpt_2 <> cMSGID_EOF);
    g_RTVM0400_2 = f_rtvMsgD(g_msgId_2: g_qMsgF_2: g_rtvOpt_2: errCode_2);
    If (f_isApiErr(errCode_2) or g_rtvm0400_2.bytAvl = 0);
      g_msgId_2 = cMSGID_HIVAL;
      g_rtvOpt_2 = cMSGID_EOF;
      g_RTVM0400_2 = f_newRtvm0400;
    Else;
      g_msgId_2 = g_rtvm0400_2.msgID;
      g_rtvOpt_2 = '*NEXT';
    Endif;
  Endif;

  //  File 1 has to wait for file 2
  If (g_msgId_1 > g_msgId_2);
    If (g_rtvOpt_1 <> cMSGID_EOF);
      g_rtvOpt_1 = cMSGID_SAME;
      g_RTVM0400_1 = f_newRtvm0400;
    Endif;
  Endif;

  //  File 2 has to wait for file 1
  If (g_msgId_1 < g_msgId_2);
    If (g_rtvOpt_2 <> cMSGID_EOF);
      g_rtvOpt_2 = cMSGID_SAME;
      g_RTVM0400_2 = f_newRtvm0400;
    Endif;
  Endif;

  If (g_rtvOpt_1 <> cMSGID_EOF or g_rtvOpt_2 <> cMSGID_EOF);
    isFound = cTrue;
  Else;
    isFound = cFalse;
  Endif;

  Return isFound;

end-proc;

//===============================================================*
//  sflLoadPage
//===============================================================*
dcl-proc f_sflLoadPage;
  dcl-pi *n ind;
    i_lowerMsgID char(7) value;
    i_upperMsgID char(7) value;
  end-pi;

  //  Return value
  dcl-s isFound ind inz;

  //  Local fields
  dcl-s isFirstRcd ind inz;
  dcl-s numRcd int(10) inz;
  dcl-s isSelected ind inz;

  dcl-ds msg likeds(msg_t) inz;

  //  Message data structures
/copy QCMPMSGF,USR0009
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  isFirstRcd = cTrue;
  numRcd     = 0;

  Dou (numRcd >= g_sflPage or g_sflNumRcd >= g_sflMaxRcd or not isFound);
    p_sflFilRcd(g_RTVM0400_1 :
               g_RTVM0400_2 );

    //  Check upper range value ...
    If (i_lowerMsgID = '*FIRST');
      i_lowerMsgID = $$MSGID;
    Endif;

    Select;
    //  ... *ONLY
    When (i_upperMsgID = '*ONLY');
      If ($$MSGID <> i_lowerMsgID);
        Leave;
      Endif;
    //  ... *LAST
    When (i_upperMsgID = '*LAST');
    //  ... specific MsgID
    Other;
      If ($$MSGID > i_upperMsgID);
        Leave;
      Endif;
    Endsl;

    //  Process filter options
    Select;
    When (g_filterCpyR   = 'Y' and $$CD = cCmpCopyRight);
      isSelected = cTrue;
    When (g_filterCpyL   = 'Y' and $$CD = cCmpCopyLeft);
      isSelected = cTrue;
    When (g_filterEqual  = 'Y' and $$CD = cCmpEqual);
      isSelected = cTrue;
    When (g_filterNEqual = 'Y' and $$CD = cCmpNotEqual);
      isSelected = cTrue;
    Other;
      If ($$CD = cCmpNoAction);
        isSelected = cTrue;
      Else;
        isSelected = cFalse;
      Endif;
    Endsl;

    //  Process find string
    If (g_find <> '');
      If (%scan(g_find: f_toLower(f_rtvMsgText(g_RTVM0400_1))) = 0
          and %scan(g_find: f_toLower(f_rtvMsgText(g_RTVM0400_2))) = 0);
        isSelected = cFalse;
      Endif;
    Endif;

    //  Write to subfile and ...
    If (isSelected);
      g_sflNumRcd = g_sflNumRcd + 1;
      SFLRRN = g_sflNumRcd;
      Write SFL;
      numRcd = numRcd + 1;

      //  ... position subfile to first new record
      If (isFirstRcd);
        isFirstRcd = cFalse;
        SFLRCDNBR = SFLRRN;
      Endif;
    Endif;

    //  Read next record
    isFound = f_sflReadRcd;
  Enddo;

  //  Display subfile
  If (numRcd > 0);
    workstn.sfldsp = cTrue;
  Endif;

  //  Set subfile end indicator
  If (not isFound);
    workstn.sflend = cTrue;
  Else;
    workstn.sflend = cFalse;
  Endif;

  //  Send warning message
  If (g_sflNumRcd >= g_sflMaxRcd);
    Clear USR0009;
    USR00091 = g_sflMaxRcd;
    msg = f_newMsg('USR0009': USR0009);
    p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
  Endif;

  Return isFound;

end-proc;

//===============================================================*
//  sflClrSlc
//===============================================================*
dcl-proc p_sflClrSlc;
  dcl-pi *n;
    i_sflRrn int(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Chain i_sflRrn SFL;
  ##OPT = '';
  workstn.opt_ri = cFalse;
  workstn.sflnxtchg = cFalse;
  Update SFL;

end-proc;

//===============================================================*
//  sflSetErr
//===============================================================*
dcl-proc p_sflSetErr;
  dcl-pi *n;
    i_sflRrn int(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Chain i_sflRrn SFL;
  workstn.opt_ri = cTrue;
  workstn.sflnxtchg = cTrue;
  Update SFL;

  SFLRCDNBR = i_sflRrn;

  Return;

end-proc;

//===============================================================*
//  sflClrInd
//===============================================================*
dcl-proc p_sflClrInd;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstn.msgf1_pc = cFalse;
  workstn.lib1_pc = cFalse;
  workstn.msgf2_pc = cFalse;
  workstn.lib2_pc = cFalse;

  workstn.msgf1_ri = cFalse;
  workstn.lib1_ri = cFalse;
  workstn.msgf2_ri = cFalse;
  workstn.lib2_ri = cFalse;

  workstn.posto_ri = cFalse;
  workstn.find_ri = cFalse;

end-proc;

//===============================================================*
//  Position to ...
//===============================================================*
dcl-proc p_sflPosTo;
  dcl-pi *n;
    i_posTo like(##POSTO) value;
  end-pi;

  //  Local fields
  dcl-s lowEnd int(10) inz;
  dcl-s highEnd int(10) inz;
  dcl-s x int(10) inz;
  dcl-s rrn int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (g_sflNumRcd > 0);

    lowEnd = 1;
    highEnd = g_sflNumRcd;

    Dou (lowEnd > highEnd or highEnd < lowEnd);
      x = %int((highEnd - lowEnd) / 2);

      rrn = lowEnd + x;
      Chain rrn SFL;

      Select;
      When (i_posTo < $$MSGID);
        highEnd = rrn - 1;
      When (i_posTo > $$MSGID);
        lowEnd  = rrn + 1;
      Other;
        Leave;
      Endsl;

    Enddo;

    If ($$MSGID < i_posTo);
      rrn = rrn + 1;
    Endif;

    Select;
    When (rrn <= 0);
      SFLRCDNBR = 1;
    When (rrn > g_sflNumRcd);
      SFLRCDNBR = g_sflNumRcd;
    Other;
      SFLRCDNBR= rrn;
    Endsl;

  Endif;

  Return;

end-proc;

//===============================================================*
//  Check for message ID
//===============================================================*
dcl-proc f_getFirstMsgID;
  dcl-pi *n ind;
    i_msgId char(7) value;
    i_msgF  char(10) value;
    i_lib   char(10) value;
    o_msgID char(7);
  end-pi;

  //  Return value
  dcl-s isFound ind inz(cFalse);

  //  Fields
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  dcl-ds rtvm0400 likeds(rtvm0400_t) inz;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qMsgF.name = i_msgF;
  qMsgF.lib  = i_lib;

  //  Retrieve message description
  rtvm0400 = f_rtvMsgD(i_msgId: qMsgF: cMSGID_SAME: errCode);

  If (f_isApiErr(errCode) or rtvm0400.bytAvl = 0);
    rtvm0400 = f_rtvMsgD(i_msgId: qMsgF: '*NEXT': errCode);
    If (f_isApiErr(errCode) or rtvm0400.bytAvl = 0);
      isFound = cFalse;
    Else;
      isFound = cTrue;
    Endif;
  Else;
    isFound = cTrue;
  Endif;

  If (not isFound);
    o_msgID = '';
  Else;
    o_msgID = rtvm0400.msgID;
  Endif;

  Return isFound;

end-proc;

//==================================================================*
//  Retrieve Message Text
//==================================================================*
dcl-proc f_rtvMsgText;
  dcl-pi *n char(1024);
    i_rtvm0400 likeds(RTVM0400_t) value;
  end-pi;

  //  Return Value
  dcl-s o_msgText char(1024) inz;
  //-------------------------------------------------------------------

  If (i_rtvm0400.bytAvl = 0);
    o_msgText = '';
  Else;
    If (i_rtvm0400.lenMsgR = 0);
      o_msgText = '';
    Else;
      o_msgText =
         %subst(i_rtvm0400: i_rtvm0400.ofsMsg + 1: i_rtvm0400.lenMsgR);
    Endif;
  Endif;

  Return o_msgText;

end-proc;

//==================================================================*
//  Retrieve Message Help
//==================================================================*
dcl-proc f_rtvMsgHelp;
  dcl-pi *n char(1024);
    i_rtvm0400 likeds(RTVM0400_t) value;
  end-pi;

  //  Return Value
  dcl-s o_msgHelp char(1024) inz;
  //-------------------------------------------------------------------

  If (i_rtvm0400.bytAvl = 0);
    o_msgHelp = '';
  Else;
    If (i_rtvm0400.lenMsgHlpR = 0);
      o_msgHelp = '';
    Else;
      o_msgHelp =
         %subst(
            i_rtvm0400: i_rtvm0400.ofsMsgHlp + 1: i_rtvm0400.lenMsgHlpR);
    Endif;
  Endif;

  Return o_msgHelp;

end-proc;

//==================================================================*
//  Retrieve Replacement Variables
//==================================================================*
dcl-proc f_rtvRplVars;
  dcl-pi *n char(1024);
    i_rtvm0400 likeds(RTVM0400_t) value;
  end-pi;

  //  Return Value
  dcl-s o_rplVars char(1024) inz;

  //  Fields
  dcl-s x int(10) inz;

  dcl-ds rplVar qualified based(pRplVar);
    length int(10);
    decPos int(10);
    type   char(10);
  end-ds;
  //-------------------------------------------------------------------

  o_rplVars = '';

  If (i_RTVM0400.NUMVARFMT > 0);
    pRplVar = %addr(i_RTVM0400) + i_RTVM0400.OFSVARFMT;

    //  Spin through replacement variables
    For x = 1 to i_RTVM0400.NUMVARFMT;

      o_rplVars = %trimR(o_rplVars) + '(';

      //  ... check type and get length and decimal positions
      Select;
      When (rplVar.type = '*QTDCHAR');
        o_rplVars = %trimR(o_rplVars) +
                    %trimR(rplVar.type ) + ' ' +
                    %char(rplVar.length);
      When (rplVar.type = '*CHAR');
        o_rplVars = %trimR(o_rplVars) +
                    %trimR(rplVar.type ) + ' ' +
                    %char(rplVar.length);
      When (rplVar.type = '*HEX');
        o_rplVars = %trimR(o_rplVars) +
                    %trimR(rplVar.type ) + ' ' +
                    %char(rplVar.length);
      When (rplVar.type = '*DEC');
        o_rplVars = %trimR(o_rplVars) +
                    %trimR(rplVar.type ) + ' ' +
                    %char(rplVar.length) + ' ' +
                    %char(rplVar.decPos);
      Other;
        o_rplVars = '';
        Leave;
      Endsl;

      o_rplVars = %trimR(o_rplVars) + ')';

      pRplVar = pRplVar + i_RTVM0400.LENVARFMTE;
    Endfor;

  Endif;

  Return o_rplVars;

end-proc;
//==================================================================*
//  Open Message File 1
//==================================================================*
dcl-proc p_openMsgF1;
  dcl-pi *n;
    i_msgF char(10) value;
    i_lib  char(10) value;
  end-pi;

  //  Fields
/copy QCMPMSGF,USR0012

  dcl-ds msg likeds(msg_t) inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_1 <> '');
    Clear USR0012;
    USR00121 = 1;
    msg = f_newMsg('USR0012': USR0012: '*ESCAPE');
    p_sndPgmMsg(msg : cMsg_Prv: cMsg_ToMyself);
  Else;
    g_qMsgF_1.name = i_msgF;
    g_qMsgF_1.lib = f_getMsgFLib(i_msgF: i_lib);
    g_msgId_1 = cMSGID_LOVAL;
    g_rtvOpt_1 = '';
  Endif;

end-proc;

//==================================================================*
//  Open Message File 2
//==================================================================*
dcl-proc p_openMsgF2;
  dcl-pi *n;
    i_msgF char(10) value;
    i_lib  char(10) value;
  end-pi;

  //  Fields
/copy QCMPMSGF,USR0012

  dcl-ds msg likeds(msg_t) inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_2 <> '');
    Clear USR0012;
    USR00121 = 2;
    msg = f_newMsg('USR0012': USR0012: '*ESCAPE');
    p_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
  Else;
    g_qMsgF_2.name = i_msgF;
    g_qMsgF_2.lib = f_getMsgFLib(i_msgF: i_lib);
    g_msgId_2 = cMSGID_LOVAL;
    g_rtvOpt_2 = '';
  Endif;

end-proc;

//==================================================================*
//  Close Message File 1.
//==================================================================*
dcl-proc p_closeMsgF1;
  dcl-pi *n;
  end-pi;

  //  Fields
/copy QCMPMSGF,USR0013

  dcl-ds msg likeds(msg_t) inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_1 = '');
    Clear USR0013;
    USR00131 = 1;
    msg = f_newMsg('USR0013': USR0013: '*ESCAPE');
    p_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
  Else;
    g_msgId_1 = cMSGID_HIVAL;
    g_rtvOpt_1 = cMSGID_EOF;
    g_qMsgF_1.name = '';
    g_qMsgF_1.lib = '';
  Endif;

end-proc;

//==================================================================*
//  Close Message File 2.
//==================================================================*
dcl-proc p_closeMsgF2;
  dcl-pi *n;
  end-pi;

  //  Fields
/copy QCMPMSGF,USR0013

  dcl-ds msg likeds(msg_t) inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_2 = '');
    Clear USR0013;
    USR00131 = 2;
    msg = f_newMsg('USR0013': USR0013: '*ESCAPE');
    p_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
  Else;
    g_msgId_2 = cMSGID_HIVAL;
    g_rtvOpt_2 = cMSGID_EOF;
    g_qMsgF_2.name = '';
    g_qMsgF_2.lib = '';
  Endif;

end-proc;

//==================================================================*
//  Check if Message File 1 is open.
//==================================================================*
dcl-proc f_isOpenMsgF1;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isOpen ind inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_1 = '');
    isOpen = cFalse;
  Else;
    isOpen = cTrue;
  Endif;

  Return isOpen;

end-proc;

//==================================================================*
//  Check if Message File 2 is open.
//==================================================================*
dcl-proc f_isOpenMsgF2;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isOpen ind inz;
  //-------------------------------------------------------------------

  If (g_qMsgF_2 = '');
    isOpen = cFalse;
  Else;
    isOpen = cTrue;
  Endif;

  Return isOpen;

end-proc;

//==================================================================*
//  Get Message File Library.
//==================================================================*
dcl-proc f_getMsgFLib;
  dcl-pi *n char(10);
    i_msgF char(10) value;
    i_lib  char(10) value;
  end-pi;

  //  Return Value
  dcl-s lib char(10) inz;

  //  Fields
  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds OBJD0100 likeds(objd0100_t) inz;
  //-------------------------------------------------------------------

  qObj.name = i_msgF;
  qObj.lib = i_lib;

  QUSROBJD(OBJD0100: %size(OBJD0100): 'OBJD0100': qObj: '*MSGF');

  lib = OBJD0100.rtnLib;

  Return lib;

end-proc;

//==================================================================*
//  Check Message File.
//==================================================================*
dcl-proc f_chkMsgF;
  dcl-pi *n ind;
    i_msgF char(10) value;
    i_lib  char(10) value;
    o_msg  like(msg_t);
  end-pi;

  //  Fields
/copy QCMPMSGF,USR0014
/copy QCMPMSGF,USR0015
  //-------------------------------------------------------------------

  //  Check Library ...
  If (i_lib = '');
    i_lib = '*LIBL';
  Endif;

  If (%subst(i_lib: 1: 1) <> '*');
    If (not f_exist(i_lib: '*LIBL': '*LIB'));
      Clear USR0014;
      USR00141 = i_lib;
      o_msg = f_newMsg('USR0014': USR0014);
      Return cFalse;
    Endif;
  Endif;

  //  Check message file ...
  If (not f_exist(i_msgF: i_lib: '*MSGF'));
    Clear USR0015;
    USR00151 = i_msgF;
    USR00152 = i_lib;
    o_msg = f_newMsg('USR0015': USR0015);
    Return cFalse;
  Endif;

  Return cTrue;

end-proc;

//==================================================================*
//  Change code.
//==================================================================*
dcl-proc p_sflChgCode;
  dcl-pi *n;
    i_rrn     int(10) value;
    i_newCode like($$CD) value;
  end-pi;
  //-------------------------------------------------------------------

  Chain i_rrn SFL;
  $$CD = i_newCode;
  p_sflSetCdColor($$CD);
  Update SFL;

end-proc;

//==================================================================*
//  Add message ID.
//==================================================================*
dcl-proc f_sflAddMsgID;
  dcl-pi *n ind;
    i_rrn  int(10) value;
    i_code char(1) value;
  end-pi;

  //  Return value
  dcl-s isAdded ind inz(cFalse);

  //  Fields
  dcl-ds msg likeds(msg_t) inz;

  //  Messages
/copy QCMPMSGF,USR0022
  //-------------------------------------------------------------------

  Chain i_rrn SFL;

  //  Copy message description ...
  Select;
  //  ... from right to left
  When (i_code = 'L');
    If (H_MSGID2 <> '');
      isAdded = f_copyMsgID(H_MSGID2: H_FILE2: H_LIB2: H_FILE1: H_LIB1);
    Else;
      isAdded = cFalse;
      Clear USR0022;
      USR00221 = $$MSGID;
      USR00222 = H_FILE2;
      USR00223 = H_LIB2;
      msg = f_newMsg('USR0022': USR0022);
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Endif;
  //  ... from left to right
  When (i_code = 'R');
    If (H_MSGID1 <> '');
      isAdded = f_copyMsgID(H_MSGID1: H_FILE1: H_LIB1: H_FILE2: H_LIB2);
    Else;
      isAdded = cFalse;
      Clear USR0022;
      USR00221 = $$MSGID;
      USR00222 = H_FILE1;
      USR00223 = H_LIB1;
      msg = f_newMsg('USR0022': USR0022);
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy );
    Endif;
  //  ... invalid code
  Other;
    isAdded = cFalse;
  Endsl;

  If (isAdded);
    p_sflRfrRcd(i_rrn);
  Endif;

  Return isAdded;

end-proc;

//==================================================================*
//  Change message ID.
//==================================================================*
dcl-proc f_sflChgMsgID;
  dcl-pi *n ind;
    i_rrn  int(10) value;
    i_code char(1) value;
  end-pi;

  //  Return value
  dcl-s isChanged ind inz(cFalse);
  //-------------------------------------------------------------------

  Chain i_rrn SFL;

  Select;
  When (i_code = 'L');
    isChanged = f_changeMsgID(H_MSGID1: H_FILE1: H_LIB1);
  When (i_code = 'R');
    isChanged = f_changeMsgID(H_MSGID2: H_FILE2: H_LIB2);
  Other;
    isChanged = cFalse;
  Endsl;

  If (isChanged);
    p_sflRfrRcd(i_rrn);
  Endif;

  Return isChanged;

end-proc;

//==================================================================*
//  Delete message ID.
//==================================================================*
dcl-proc f_sflDltMsgID;
  dcl-pi *n ind;
    i_rrn  int(10) value;
    i_code char(1) value;
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(cFalse);
  //-------------------------------------------------------------------

  Chain i_rrn SFL;

  Select;
  When (i_code = 'L');
    isDeleted = f_deleteMsgID(H_MSGID1: H_FILE1: H_LIB1);
  When (i_code = 'R');
    isDeleted = f_deleteMsgID(H_MSGID2: H_FILE2: H_LIB2);
  Other;
    isDeleted = cFalse;
  Endsl;

  If (isDeleted);
    p_sflRfrRcd(i_rrn);
  Endif;

  Return isDeleted;

end-proc;

//==================================================================*
//  Display message ID.
//==================================================================*
dcl-proc f_sflDspMsgID;
  dcl-pi *n ind;
    i_rrn  int(10) value;
    i_code char(1) value;
  end-pi;

  //  Return value
  dcl-s isDisplayed ind inz(cFalse);
  //-------------------------------------------------------------------

  Chain i_rrn SFL;

  Select;
  When (i_code = 'L');
    isDisplayed = f_displayMsgID(H_MSGID1: H_FILE1: H_LIB1);
  When (i_code = 'R');
    isDisplayed = f_displayMsgID(H_MSGID2: H_FILE2: H_LIB2);
  Other;
    isDisplayed = cFalse;
  Endsl;

  Return isDisplayed;

end-proc;

//==================================================================*
//  Copy Message ID.
//==================================================================*
dcl-proc f_copyMsgID;
  dcl-pi *n ind;
    i_msgID    char(7) value;
    i_fromMsgF char(10) value;
    i_fromLib  char(10) value;
    i_toMsgF   char(10) value;
    i_toLib    char(10) value;
  end-pi;

  //  Return value
  dcl-s isCopied ind inz;

  //  Fields
  dcl-s cmd char(512) inz;
  //-------------------------------------------------------------------

  cmd = 'MRGMSGF ' +
          'FROMMSGF(' + %trim(i_fromLib) + '/' + %trim(i_fromMsgF) + ') ' +
          'TOMSGF(' + %trim(i_toLib) + '/' + %trim(i_toMsgF) + ') ' +
          'RPLMSGF(' + %trim('*NONE') + ') ' +
          'SELECT(' + %trim(i_msgID) + ') ';
  If (system(cmd) <> 0);
    isCopied = cFalse;
  Else;
    isCopied = cTrue;
  Endif;

  Return isCopied;

end-proc;

//==================================================================*
//  Add Message ID.
//==================================================================*
dcl-proc f_addMsgID;
  dcl-pi *n ind;
    i_msgID    char(7) value;
    i_msgF     char(10) value;
    i_lib      char(10) value;
    i_baseMsgF char(10) value;
    i_baseLib  char(10) value;
  end-pi;

  //  Return value
  dcl-s isAdded ind inz;

  //  Fields
  dcl-s cmd char(512) inz;
  //-------------------------------------------------------------------

  cmd = '?ADDMSGD ' +
           '?*MSGID(' + %trim(i_msgID) + ') ' +
           '?*MSGF(' + %trim(i_lib) + '/' + %trim(i_msgF) + ') ' +
           f_rtvCmdValues(i_msgID: i_baseMsgF: i_baseLib);
  If (system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801');
    isAdded = cFalse;
  Else;
    isAdded = cTrue;
  Endif;

  Return isAdded;

end-proc;

//==================================================================*
//  Change Message ID.
//==================================================================*
dcl-proc f_changeMsgID;
  dcl-pi *n ind;
    i_msgID char(7) value;
    i_msgF  char(10) value;
    i_lib   char(10) value;
  end-pi;

  //  Return value
  dcl-s isChanged ind inz;

  //  Fields
  dcl-s cmd char(8192) inz;
  dcl-s msgHelp char(1024) inz;
  dcl-s rplVars char(1024) inz;
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-ds rtvm0400 likeds(rtvm0400_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  qMsgF.name = i_msgF;
  qMsgF.lib = i_lib;
  rtvm0400 = f_rtvMsgD(i_msgID: qMsgF: cMSGID_SAME: errCode);

  If (f_isApiErr(errCode) or rtvm0400.bytAvl = 0);
    isChanged = cFalse;
  Else;

    //  Get second level text
    msgHelp = f_rtvMsgHelp(rtvm0400);
    If (msgHelp = '');
      msgHelp = '*N';
    Else;
      msgHelp = cQuote + %trimR(msgHelp) + cQuote;
    Endif;

    //  Get replacement variables
    rplVars = f_rtvRplVars(rtvm0400);
    If (rplVars = '');
      rplVars = '*N';
    Endif;

    //  Produce CHGMSGD command
    cmd = '?CHGMSGD ' +
             '?*MSGID(' + %trim(i_msgID) + ') ' +
             '?*MSGF(' + %trim(i_lib) + '/' + %trim(i_msgF) + ') ' +
             f_rtvCmdValues(i_msgID: i_msgF: i_lib);
    If (system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801');
      isChanged = cFalse;
    Else;
      isChanged = cTrue;
    Endif;
  Endif;

  Return isChanged;

end-proc;

//==================================================================*
//  Delete Message ID.
//==================================================================*
dcl-proc f_deleteMsgID;
  dcl-pi *n ind;
    i_msgID char(7) value;
    i_msgF  char(10) value;
    i_lib   char(10) value;
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz;

  //  Fields
  dcl-s cmd char(512) inz;
  //-------------------------------------------------------------------

  cmd = '?RMVMSGD ' +
           '?*MSGID(' + %trim(i_msgID) + ') ' +
           '?*MSGF(' + %trim(i_lib) + '/' + %trim(i_msgF) + ') ';
  If (system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801');
    isDeleted = cFalse;
  Else;
    isDeleted = cTrue;
  Endif;

  Return isDeleted;

end-proc;

//==================================================================*
//  Display Message ID.
//==================================================================*
dcl-proc f_displayMsgID;
  dcl-pi *n ind;
    i_msgID char(7) value;
    i_msgF  char(10) value;
    i_lib   char(10) value;
  end-pi;

  //  Return value
  dcl-s isDisplayed ind inz;

  //  Fields
  dcl-s cmd char(512) inz;
  //-------------------------------------------------------------------

  cmd = 'DSPMSGD ' +
           'RANGE(' + %trim(i_msgID) + ') ' +
           'MSGF(' + %trim(i_lib) + '/' + %trim(i_msgF) + ') ';
  If (system(cmd) <> 0);
    isDisplayed = cFalse;
  Else;
    isDisplayed = cTrue;
  Endif;

  Return isDisplayed;

end-proc;

//==================================================================*
//  Fill Subfile Record.
//==================================================================*
dcl-proc p_sflFilRcd;
  dcl-pi *n;
    i_rtvm0400_1 likeds(RTVM0400_t) value;
    i_rtvm0400_2 likeds(RTVM0400_t) value;
  end-pi;

  //  Fields
  dcl-ds *n;
    date7$ char(7);
    date7  zoned(7) inz overlay(date7$: 1);
  end-ds;
  dcl-ds mod_1 qualified;
    crtDate date inz;
    crtLvl  int(10) inz;
    modDate date inz;
    modLvl  int(10) inz;
  end-ds;
  dcl-ds mod_2 qualified;
    crtDate date inz;
    crtLvl  int(10) inz;
    modDate date inz;
    modLvl  int(10) inz;
  end-ds;
  //-------------------------------------------------------------------

  //  Compare date : Y/N
  If (g_cmpDate = 'Y');
  // keep information
  Else;
    i_RTVM0400_1.crtDate = cLowDat7;
    i_RTVM0400_1.modDate = cLowDat7;
    i_RTVM0400_2.crtDate = cLowDat7;
    i_RTVM0400_2.modDate = cLowDat7;
  Endif;

  //  Compare level: Y/N
  If (g_cmpLvl  = 'Y');
  // keep information
  Else;
    i_RTVM0400_1.crtLvlNbr = 0;
    i_RTVM0400_1.modLvlNbr = 0;
    i_RTVM0400_2.crtLvlNbr = 0;
    i_RTVM0400_2.modLvlNbr = 0;
  Endif;

  //  Create creation/modification level data structure
  mod_1.crtDate = %date(i_RTVM0400_1.crtDate: *cymd0);
  mod_1.modDate = %date(i_RTVM0400_1.modDate: *cymd0);

  mod_1.crtLvl = i_RTVM0400_1.crtLvlNbr;
  mod_1.modLvl = i_RTVM0400_1.modLvlNbr;

  mod_2.crtDate = %date(i_RTVM0400_2.crtDate: *cymd0);
  mod_2.modDate = %date(i_RTVM0400_2.modDate: *cymd0);

  mod_2.crtLvl = i_RTVM0400_2.crtLvlNbr;
  mod_2.modLvl = i_RTVM0400_2.modLvlNbr;

  //  Set subfile hidden fields ...
  H_MSGID1 = i_RTVM0400_1.msgId;
  H_FILE1 = g_qMsgF_1.name;
  H_LIB1 = g_qMsgF_1.lib;
  H_MSGID2 = i_RTVM0400_2.msgId;
  H_FILE2 = g_qMsgF_2.name;
  H_LIB2 = g_qMsgF_2.lib;

  //  Set subfile fields ...
  ##OPT          = '';
  workstn.opt_ri = cFalse;

  If (i_RTVM0400_1.msgId <> '');
    $$MSGID = i_RTVM0400_1.msgId;
  Else;
    $$MSGID = i_RTVM0400_2.msgId;
  Endif;

  $$TEXT1 = f_rtvMsgText(i_RTVM0400_1);
  $$HELP1 = f_rtvMsgHelp(i_RTVM0400_1);

  $$TEXT2 = f_rtvMsgText(i_RTVM0400_2);
  $$HELP2 = f_rtvMsgHelp(i_RTVM0400_2);

  //  ... determine action code
  Select;
  //  ... no-action     (missing both descriptions)
  When (i_RTVM0400_1.msgId = '' and i_RTVM0400_2.msgId = '');
    $$CD = cCmpNoAction;
  //  ... copy-to-left  (missing left description)
  When (i_RTVM0400_1.msgId = '');
    $$CD = cCmpCopyLeft;
  //  ... copy-to-right (missing right description)
  When (i_RTVM0400_2.msgId = '');
    $$CD = cCmpCopyRight;
  Other;
    //  ... others
    If (i_RTVM0400_1 = i_RTVM0400_2);
      //  ... equal descriptions
      $$CD = cCmpEqual;
    Else;

      //  ... not equal so ...
      Select;
      //  ... copy-to-left
      When (mod_2 > mod_1);
        $$CD = cCmpCopyLeft;
      //  ... copy-to-right
      When (mod_1 > mod_2);
        $$CD = cCmpCopyRight;
      //  ... don't know what to do
      Other;
        $$CD = cCmpNotEqual;
      Endsl;

    Endif;
  Endsl;

  p_sflSetCdColor($$CD);

end-proc;

//==================================================================*
//  Set Code Color.
//==================================================================*
dcl-proc p_sflSetCdColor;
  dcl-pi *n;
    i_cd like($$CD) value;
  end-pi;
  //-------------------------------------------------------------------

  workstn.cd_white = *off;
  workstn.cd_grn = *off;
  workstn.cd_ylw = *off;
  workstn.cd_red = *off;

  Select;
  When (i_cd = cCmpCopyLeft);
    workstn.cd_ylw = *on;
  When (i_cd = cCmpCopyRight);
    workstn.cd_ylw = *on;
  When (i_cd = cCmpNotEqual);
    workstn.cd_red = *on;
  Other;
    workstn.cd_white = *on;
  Endsl;

end-proc;

//==================================================================*
//  Refresh Subfile Record.
//==================================================================*
dcl-proc p_sflRfrRcd;
  dcl-pi *n;
    i_rrn int(10) value;
  end-pi;

  //  Fields
  dcl-ds qMsgF_1 likeds(qObj_t) inz;
  dcl-ds qMsgF_2 likeds(qObj_t) inz;
  dcl-ds rtvm0400_1 likeds(rtvm0400_t) inz;
  dcl-ds rtvm0400_2 likeds(rtvm0400_t) inz;
  dcl-ds errCode_1 likeds(errCode_t) inz;
  dcl-ds errCode_2 likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Retrieve message description of 1. file
  qMsgF_1.name = ##MSGF1;
  qMsgF_1.lib = ##LIB1;
  RTVM0400_1 = f_rtvMsgD($$MSGID: qMsgF_1: cMSGID_SAME: errCode_1);

  If (f_isApiErr(errCode_1) or rtvm0400_1.bytAvl = 0 );
    rtvm0400_1 = f_newRtvm0400;
  Endif;

  //  Retrieve message description of 2. file
  qMsgF_2.name = ##MSGF2;
  qMsgF_2.lib = ##LIB2;
  rtvm0400_2 = f_rtvMsgD($$MSGID: qMsgF_2: cMSGID_SAME: errCode_2);

  If (f_isApiErr(errCode_2) or rtvm0400_2.bytAvl = 0);
    rtvm0400_2 = f_newRtvm0400;
  Endif;

  Chain i_rrn SFL;

  p_sflFilRcd(RTVM0400_1: RTVM0400_2);

  Update SFL;

end-proc;

//==================================================================*
//  Retrieve Message Description.
//==================================================================*
dcl-proc f_rtvMsgD;
  dcl-pi *n likeds(rtvm0400_t);
    i_msgId   char(7) value;
    i_qMsgF   like(qobj_t) value;
    i_rtvOpt  char(10) value;
    o_errCode likeds(errCode_t) value;
  end-pi;

  //  Fields
  dcl-ds RTVM0300 likeds(rtvm0300_t) inz;
  dcl-ds rtvm0400 likeds(rtvm0400_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-s sizeAdj int(10) inz static;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  rtvm0400 = f_newRtvm0400;
  o_errCode  = f_newApiErrCode(cTrue);

  //  Retrieve message description
  If (g_fmtName = 'RTVM0400');
    QMHRTVM(rtvm0400: %size(rtvm0400): g_fmtName: i_msgId: i_qMsgF
            : '': 0: '*NO': '*YES': o_errCode: i_rtvOpt: 0: 0);

    If (o_errCode.excId = 'CPF3C21');
      sizeAdj = %size(rtvm0400) - %size(RTVM0300);
      g_fmtName = 'RTVM0300';
      msg = f_newMsg('USR0021');
      p_sndPgmMsg(msg: cMsg_Same: cMsg_ToPgmBdy);
    Endif;
  Endif;

  If (g_fmtName = 'RTVM0300');
    RTVM0300 = f_newRtvm0300;
    QMHRTVM(RTVM0300: %size(RTVM0300): g_fmtName: i_msgId: i_qMsgF
            :'' : 0: '*NO': '*YES': o_errCode: i_rtvOpt: 0: 0);
    rtvm0400 = f_newRtvm0400;
    rtvm0400.BYTRET = RTVM0300.BYTRET;
    rtvm0400.BYTAVL = RTVM0300.BYTAVL;
    rtvm0400.MSGSEV = RTVM0300.MSGSEV;
    rtvm0400.ALTIDX = RTVM0300.ALTIDX;
    rtvm0400.ALTOPT = RTVM0300.ALTOPT;
    rtvm0400.LOGIND = RTVM0300.LOGIND;
    rtvm0400.MSGID = RTVM0300.MSGID;
    rtvm0400.reserved_01 = RTVM0300.reserved_01;

    rtvm0400.NUMVARFMT = RTVM0300.NUMVARFMT;
    rtvm0400.CSINDTXT = RTVM0300.CSINDTXT;
    rtvm0400.CSINDDTA = RTVM0300.CSINDDTA;
    rtvm0400.CCSIDTXT = RTVM0300.CCSIDTXT;
    rtvm0400.OFSDFTR = RTVM0300.OFSDFTR + sizeAdj;
    rtvm0400.LENDFTRPYR = RTVM0300.LENDFTRPYR;
    rtvm0400.LENDFTRPYA = RTVM0300.LENDFTRPYA;
    rtvm0400.OFSMSG = RTVM0300.OFSMSG + sizeAdj;
    rtvm0400.LENMSGR = RTVM0300.LENMSGR;
    rtvm0400.LENMSGA = RTVM0300.LENMSGA;
    rtvm0400.OFSMSGHLP = RTVM0300.OFSMSGHLP + sizeAdj;
    rtvm0400.LENMSGHLPR = RTVM0300.LENMSGHLPR;
    rtvm0400.LENMSGHLPA = RTVM0300.LENMSGHLPA;
    rtvm0400.OFSVARFMT = RTVM0300.OFSVARFMT + sizeAdj;
    rtvm0400.LENVARFMTR = RTVM0300.LENVARFMTR;
    rtvm0400.LENVARFMTA = RTVM0300.LENVARFMTA;
    rtvm0400.LENVARFMTE = RTVM0300.LENVARFMTE;
    rtvm0400.DATA = RTVM0300.DATA;
  Endif;

  If (rtvm0400.crtDate = '');
    rtvm0400.crtDate = cLowDat7;
  Endif;

  If (rtvm0400.modDate = '');
    rtvm0400.modDate = cLowDat7;
  Endif;

  Return rtvm0400;

end-proc;

//==================================================================*
//  Create a new RTVM0300 format.
//==================================================================*
dcl-proc f_newRtvm0300;
  dcl-pi *n likeds(RTVM0300_t);
  end-pi;

  //  Fields
  dcl-ds RTVM0300 likeds(rtvm0300_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Clear RTVM0300;

  Return RTVM0300;

end-proc;

//==================================================================*
//  Create a new rtvm0400 format.
//==================================================================*
dcl-proc f_newRtvm0400;
  dcl-pi *n likeds(RTVM0400_t);
  end-pi;

  //  Fields
  dcl-ds rtvm0400 likeds(rtvm0400_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Clear rtvm0400;

  rtvm0400.crtDate = cLowDat7;
  rtvm0400.modDate = cLowDat7;

  Return rtvm0400;

end-proc;

//==================================================================*
//  Convert string to lower case.
//==================================================================*
dcl-proc f_toLower;
  dcl-pi *n varchar(1024);
    i_string varchar(1024) const;
  end-pi;

  //  Return value
  dcl-s lowerString varchar(1024) inz;

  //  Conversion constants
  dcl-c lc 'abcdefghijklmnopqrstuvwxyz';
  dcl-c uc 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If (%len(i_string) > 0);
    lowerString = %xlate(uc: lc: i_string);
  Else;
    lowerString = '';
  Endif;

  Return lowerString;

end-proc;

//==================================================================*
//  Retrieve command values
//==================================================================*
dcl-proc f_rtvCmdValues;
  dcl-pi *n varchar(8192);
    i_msgID char(7) value;
    i_msgF  char(10) value;
    i_lib   char(10) value;
  end-pi;

  //  Return value
  dcl-s cmdValues varchar(8192) inz;

  //  Fields
  dcl-s msgHelp char(1024) inz;
  dcl-s rplVars char(1024) inz;
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-ds rtvm0400 likeds(rtvm0400_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  qMsgF.name = i_msgF;
  qMsgF.lib = i_lib;
  rtvm0400 = f_rtvMsgD(i_msgID: qMsgF: cMSGID_SAME: errCode);

  If (f_isApiErr(errCode) or rtvm0400.bytAvl = 0);
    cmdValues = '';
  Else;

    //  Get second level text
    msgHelp = f_rtvMsgHelp(rtvm0400);
    If (msgHelp = '');
      msgHelp = '*N';
    Else;
      msgHelp = cQuote + %trimR(msgHelp) + cQuote;
    Endif;

    //  Get replacement variables
    rplVars = f_rtvRplVars(rtvm0400);
    If (rplVars = '');
      rplVars = '*N';
    Endif;

    //  Produce CHGMSGD command
    cmdValues = ' ' +
       'MSG(' + cQuote + %trimR(f_rtvMsgText(rtvm0400)) + cQuote + ') ' +
       'SECLVL(' + %trimR(msgHelp) + ') ' +
       'FMT(' + %trimR(rplVars) + ') ' +
       'SEV(' + %char(rtvm0400.MSGSEV) + ') ';
  Endif;

  Return cmdValues;

end-proc;

