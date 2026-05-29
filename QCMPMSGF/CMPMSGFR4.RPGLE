**free
// =================================================================== *
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : CMPMSGF                                            *
//  Objekt  . . . : CMPMSGFR4                                          *
//  Beschreibung  : Tool: CMPMSGF    (Compare Message File     ) GLOBAL*
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 23.12.2001                                         *
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
// =================================================================== *

//== Workstation Constants ======================================*
dcl-c cKeyF1 X'31';
dcl-c cKeyF2 X'32';
dcl-c cKeyF3 X'33';
dcl-c cKeyF4 X'34';
dcl-c cKeyF5 X'35';
dcl-c cKeyF6 X'36';
dcl-c cKeyF7 X'37';
dcl-c cKeyF8 X'38';
dcl-c cKeyF9 X'39';
dcl-c cKeyF10 X'3A';
dcl-c cKeyF11 X'3B';
dcl-c cKeyF12 X'3C';
dcl-c cKeyF13 X'B1';
dcl-c cKeyF14 X'B2';
dcl-c cKeyF15 X'B3';
dcl-c cKeyF16 X'B4';
dcl-c cKeyF17 X'B5';
dcl-c cKeyF18 X'B6';
dcl-c cKeyF19 X'B7';
dcl-c cKeyF20 X'B8';
dcl-c cKeyF21 X'B9';
dcl-c cKeyF22 X'BA';
dcl-c cKeyF23 X'BB';
dcl-c cKeyF24 X'BC';

dcl-c cKeyClear X'BD';
dcl-c cKeyDelete X'BD';

dcl-c cKeyEnter X'F1';
//          Nicht definiert                   F2
dcl-c cKeyHelp X'F3';
dcl-c cKeyPageDown X'F4';
dcl-c cKeyPageUp X'F5';
dcl-c cKeyPrintScr X'F6';
//          Nicht definiert                   F7
dcl-c cKeyReset X'F8';

dcl-c cKeyLightPen X'3F';

dcl-c cSflFold *off;
dcl-c cSflDrop *on;
//===============================================================*

//== Global Constants============================================*

//  Boolean Constants ...
dcl-c cTrue *on;
dcl-c cFalse *off;

//  Application Message File ...
dcl-c cAppMsgF 'CMPMSGF';
dcl-c cAppMsgL '*LIBL';

//  Messages ...
//  ... to stack counter
dcl-c cMsg_Ext -1;
dcl-c cMsg_Prv -2;
dcl-c cMsg_Same -3;

//  ... to procedure
dcl-c cMsg_ToMyself '*';
dcl-c cMsg_ToPgmBdy '*PGMBDY';
dcl-c cMsg_ToCtlBdy '*CTLBDY';
dcl-c cMsg_ToPgm '*PGMNAME';

dcl-c cMSGID_LOVAL *loval;
dcl-c cMSGID_HIVAL *hival;
dcl-c cMSGID_EOF '*EOF';
dcl-c cMSGID_SAME '*MSGID';

dcl-c cCmpCopyLeft '<=';
dcl-c cCmpCopyRight '=>';
dcl-c cCmpEqual '==';
dcl-c cCmpNotEqual '<>';
dcl-c cCmpNoAction '| ';

//  Others ...
dcl-c cLowDat7 '0010101';
dcl-c cQuote '''';
//===============================================================*

//== Templates ==================================================*
/copy QCMPMSGF,FDMSG
/copy QCMPMSGF,FDQOBJ
/copy QCMPMSGF,FDERRCODE
/copy QCMPMSGF,FDRTVM0300
/copy QCMPMSGF,FDRTVM0400
/copy QCMPMSGF,FDOBJD0100

dcl-ds range_t based(pDummy);
  numVal int(5);
  lower  char(7);
  upper  char(7);
end-ds;
//===============================================================*

//== Prototypes =================================================*
//  ... compare message file       (CMPMSGFR1)
dcl-pr f_cmpMsgF char(1);
  i_file1   char(10) const;
  i_lib1    char(10) const;
  i_file2   char(10) const;
  i_lib2    char(10) const;
  i_range   likeds(range_t) const;
  i_cmpDate char(1) const;
  i_cmpLvl  char(1) const;
  i_error   char(1) const;
end-pr;

//  ... change filter              (CMPMSGFR2)
dcl-pr f_chgFilter char(1);
  io_cpyr   char(1);
  io_cpyl   char(1);
  io_equal  char(1);
  io_nequal char(1);
end-pr;

//  ... load module filter         (CMPMSGFR2)
dcl-pr p_loadFilter;
end-pr;

//  ... unload module filter       (CMPMSGFR2)
dcl-pr p_unloadFilter;
end-pr;

//  ... remove program messages    (CMPMSGFR3)
dcl-pr p_rmvPgmMsg;
  i_toStkC int(10) options(*nopass) const;
  i_toProc char(256) options(*nopass) const;
  i_toMod  char(10) options(*nopass: *omit) const;
  i_toPgm  char(10) options(*nopass) const;
end-pr;

//  ... send program message       (CMPMSGFR3)
dcl-pr p_sndPgmMsg;
  i_msg    like(msg_t) const;
  i_toStkC int(10) options(*nopass) const;
  i_toProc char(256) options(*nopass) const;
  i_toMod  char(10) options(*nopass: *omit) const;
  i_toPgm  char(10) options(*nopass) const;
end-pr;

//  ... create a new message       (CMPMSGFR3)
dcl-pr f_newMsg like(msg_t);
  i_msgID   char(7) options(*nopass: *omit) const;
  i_msgDta  char(512) options(*nopass: *omit) const;
  i_msgType char(10) options(*nopass: *omit) const;
  i_file    char(10) options(*nopass: *omit) const;
  i_lib     char(10) options(*nopass: *omit) const;
end-pr;

//  ... create a new API errorcode (CMPMSGFR3)
dcl-pr f_newApiErrCode like(errCode_t);
  i_monMsg ind value;
end-pr;

//  ... test for API error         (CMPMSGFR3)
dcl-pr f_isApiErr ind;
  i_errCode likeds(errCode_t) value;
end-pr;

//  ... retrieve network attribute (CMPMSGFR3)
dcl-pr f_rtvNetAtrA char(4096);
  i_netAtrName char(10) value;
end-pr;

//  ... check if object exists     (CMPMSGFR3)
dcl-pr f_exist ind;
  i_obj     char(10) value;
  i_lib     char(10) value;
  i_objType char(10) value;
end-pr;
//===============================================================*

//== external Prototypes ========================================*
//  ... test omitted argument
dcl-pr p_testOmit extproc('CEETSTA');
  o_isPresent int(10);
  i_argNum    int(10) const;
  o_fc        char(12) options(*omit);
end-pr;

//  ... Display Command Line Window (QUSCMDLN) API
dcl-pr QUSCMDLN extpgm('QUSCMDLN');
end-pr;

//  ... Remove Program Messages (QMHRMVPM) API
dcl-pr QMHRMVPM extpgm('QMHRMVPM');
  i_callStkE    char(256) const;
  i_callStkC    int(10) const;
  i_msgKey      char(4) const;
  i_msgToRmv    char(10) const;
  io_ErrCode    char(65535) options(*varsize);
  i_lenStkE     int(10) options(*nopass) const; // | optGrp 1
  i_callStkEQ   char(20) options(*nopass) const; // |
  i_rmvUnhdlExc char(10) options(*nopass) const; // |
  i_callStkEDT  char(10) options(*nopass) const; // | optGrp 2
  i_alwDfRpyRjc char(10) options(*nopass) const; // | optGrp 3
end-pr;

//  ... Send Program Message (QMHSNDPM) API
dcl-pr QMHSNDPM extpgm('QMHSNDPM');
  i_msgID      char(7) const;
  i_qMsgF      char(20) const;
  i_msgData    char(32767) options(*varsize) const;
  i_length     int(10) const;
  i_msgType    char(10) const;
  i_callStkE   char(256) const;
  i_callStkC   int(10) const;
  o_msgKey     char(4);
  io_ErrCode   char(32767) options(*varsize);
  i_lenStkE    int(10) options(*nopass) const; // | optGrp 1
  i_callStkEQ  char(20) options(*nopass) const; // |
  i_wait       int(10) options(*nopass) const; // |
  i_callStkEDT char(10) options(*nopass) const; // | optGrp 2
  i_ccsid      int(10) options(*nopass) const; // |
end-pr;

//  ... Retrieve Network Attributes (QWCRNETA) API
dcl-pr QWCRNETA extpgm('QWCRNETA');
  o_rcvVar     char(32767) options(*varsize);
  i_lenRcv     int(10) const;
  i_numAttr    int(10) const;
  i_attrNames  char(10) dim(50) options(*varsize) const;
  io_errorCode char(32767) options(*varsize);
end-pr;

//  ... Retrieve Message (QMHRTVM) API
dcl-pr QMHRTVM extpgm('QMHRTVM');
  i_msgD        char(32767) options(*varsize);
  i_lenMsgD     int(10) const;
  i_format      char(8) const;
  i_msgID       char(7) const;
  i_qMsgF       char(20) const;
  i_rplcData    char(32767) options(*varsize) const;
  i_lenRplcData int(10) const;
  i_rplcSubstV  char(10) const;
  i_rtnFmtCtlC  char(10) const;
  io_errCode    char(32767) options(*varsize);
  i_rtvOpt      char(10) options(*nopass) const;
  i_ccsid       int(10) options(*nopass) const;
  i_rplDtaCcsid int(10) options(*nopass) const;
end-pr;

//  ... Retrieve Object Description (QUSROBJD) API
dcl-pr QUSROBJD extpgm('QUSROBJD');
  i_objD     char(32767) options(*varsize);
  i_lenObjD  int(10) const;
  i_format   char(8) const;
  i_qObj     char(20) const;
  i_objType  char(10) const;
  io_errCode char(32767) options(*varsize: *nopass);
end-pr;

//  ... system -- Execute a Command
dcl-pr system int(10) extproc('system');
  i_cmd pointer options(*string) value;
end-pr;

dcl-s EXCP_MSGID char(7) import('_EXCP_MSGID');

//===============================================================*

//== Program status data structure===============================*
dcl-ds sds qualified psds;
  pgmName   char(10);
  pgmStat   zoned(5);
  pPrevStat zoned(5);
  lastSeq   char(8);
  lastSubr  char(8);
  numParm   zoned(3);
  msgID     char(7);
  miInstr   char(4);
  workArea  char(30);
  pgmLib    char(10);
  msgText   char(80);
  excpInd   char(4);
  unused1   char(16);
  datFmt    char(8);
  year      zoned(2);
  fileOpr   char(8);
  fileStat  char(35);
  job       char(10);
  user      char(10);
  jobNbr    zoned(6);
  jobD      zoned(6);
  pgmDate   zoned(6);
  jobTime   zoned(6);
  crtDate   char(6);
  crtTime   char(6);
  compVer   char(4);
  srcFile   char(10);
  srcLib    char(10);
  srcMbr    char(10);
  pgmProc   char(10);
  modProc   char(10);
  unused2   char(76);
end-ds;
//===============================================================*
