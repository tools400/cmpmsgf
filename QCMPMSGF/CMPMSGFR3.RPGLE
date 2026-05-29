**free
// =================================================================== *
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : CMPMSGF                                            *
//  Objekt  . . . : CMPMSGFR3                                          *
//  Beschreibung  : Tool: CMPMSGF    (Compare Message File     ) SRVMOD*
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

//== Prototypes =================================================*
/copy QCMPMSGF,CMPMSGFR4
//===============================================================*

//===============================================================*
//  rmvPgmMsg     (not fully tested)
//===============================================================*
dcl-proc p_rmvPgmMsg export;
  dcl-pi *n;
    i_toStkC int(10) options(*nopass) const;
    i_toProc char(256) options(*nopass) const;
    i_toMod  char(10) options(*nopass: *omit) const;
    i_toPgm  char(10) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_toStkC 1;
  dcl-c p_toProc 2;
  dcl-c p_toMod 3;
  dcl-c p_toPgm 4;

  //  Local fields
  dcl-s toStkC like(i_toStkC) inz;
  dcl-s toProc like(i_toProc) inz;
  dcl-s toMod like(i_toMod) inz;
  dcl-s toPgm like(i_toPgm) inz;

  dcl-s isPresent int(10) inz;

  //  API: QMHRMVPM
  dcl-ds stackQ;
    stackQ_mod char(10) inz;
    stackQ_pgm char(10) inz;
  end-ds;

  dcl-ds errCode likeds(errCode_t) inz;

  dcl-s p1_callStkE char(256) inz;
  dcl-s p1_callStkCtr int(10) inz;
  dcl-s p1_msgKey char(4) inz;
  dcl-s p1_msgToRmv char(10) inz;
  dcl-ds p1_errCode likeds(errCode_t) inz;
  // Optional Parameter Group 1
  dcl-s p1_lenCallStkE int(10) inz;
  dcl-ds p1_qCallStkE len(20) qualified;
    module  char(10) inz;
    program char(10) inz;
  end-ds;
  dcl-s p1_rmvUnhExc char(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Set defaults ...
  //  ... stack counter
  If (%parms >= p_toStkC);
    toStkC = i_toStkC;
  Else;
    toStkC = cMsg_Same;
  Endif;

  //  Set defaults ...
  //  ... stack counter
  If (%parms >= p_toStkC);
    toStkC = i_toStkC;
  Else;
    toStkC = cMsg_Same;
  Endif;

  //  ... to procedure
  If (%parms >= p_toProc);
    toProc = i_toProc;
  Else;
    toProc = cMsg_ToMyself;
  Endif;

  //  ... to modul
  If (%parms >= p_toMod);
    p_TestOmit(isPresent: p_toMod: *omit);
    If (isPresent = 1);
      toMod = i_toMod;
    Else;
      toMod = '*NONE';
    Endif;
  Else;
    toMod = '*NONE';
  Endif;

  //  ... to program
  IF (%parms >= p_toPgm);
    toPgm = i_toPgm;
  Else;
    toPgm = '*NONE';
  Endif;

  //  Set parameter
  //  Call stack counter ...
  Select;
  //  ... *EXT
  When (toStkC = cMsg_Ext);
    p1_callStkCtr = 0;
    toProc = '*EXT';
  //  ... *PERVIOUS
  When (toStkC = cMsg_Prv);
    p1_callStkCtr = 1;
  //  ... *SAME
  When (toStkC = cMsg_Same);
    p1_callStkCtr = 0;
  //  ... sonst
  Other;
    p1_callStkCtr = 0;
  Endsl;

  //  To procedure ...
  Select;
  //  ... *
  When (toProc = cMsg_ToMyself);
    p1_callStkE = '*';
    //      ... skip RmvPgmMsg
    p1_callStkCtr = p1_callStkCtr + 1;
  //  ... *PGMBDY
  When (toProc = cMsg_ToPgmBdy);
    //**                Eval      p1_callStkE   = '_QRNP_PEP_' + sds.pgmProc
    p1_callStkE = '_CL_PEP';
  //  ... *PGMNAME
  When (toProc = cMsg_ToPgm);
    p1_callStkE = sds.pgmName;
  //  ... *EXT
  When (toProc = '*EXT');
    p1_callStkE = '*EXT';
  //  ... procedure
  Other;
    p1_callStkE = toProc;
  Endsl;

  //  To modul ...
  p1_qCallStkE.module = toMod;

  //  To program ...
  p1_qCallStkE.program = toPgm;

  //  Message key ...
  p1_msgKey = '';
  //  Message to remove ...
  p1_msgToRmv = '*ALL';
  //  Errorcode ...
  p1_errCode = f_newApiErrCode(cFalse);

  //  Others ...
  p1_lenCallStkE = %size(p1_CallStkE);
  p1_RmvUnhExc = '*NO';

  QMHRMVPM(p1_callStkE: p1_callStkCtr: p1_msgKey: p1_msgToRmv
           : p1_errCode: p1_lenCallStkE: p1_qCallStkE: p1_rmvUnhExc);

end-proc;

//===============================================================*
//  sndPgmMsg
//===============================================================*
dcl-proc p_sndPgmMsg export;
  dcl-pi *n;
    i_msg    like(msg_t) const;
    i_toStkC int(10) options(*nopass) const;
    i_toProc char(256) options(*nopass) const;
    i_toMod  char(10) options(*nopass: *omit) const;
    i_toPgm  char(10) options(*nopass) const;
  end-pi;

  //  Splitt i_msg
  dcl-ds msg likeds(msg_t) inz;

  //  Parameter positions
  dcl-c p_toStkC 2;
  dcl-c p_toProc 3;
  dcl-c p_toMod 4;
  dcl-c p_toPgm 5;

  //  Local fields
  dcl-s toStkC like(i_toStkC) inz;
  dcl-s toProc like(i_toProc) inz;
  dcl-s toMod like(i_toMod) inz;
  dcl-s toPgm like(i_toPgm) inz;

  dcl-s isPresent int(10) inz;

  //  API: QMHSNDPM
  dcl-s p1_msgID char(7) inz;
  dcl-ds p1_DSMsgFObj len(20);
    p1_DSMsgF char(10) inz;
    p1_DSMsgL char(10) inz;
  end-ds;
  dcl-s p1_msgData char(512) inz;
  dcl-s p1_lenMsgData int(10) inz;
  dcl-s p1_msgType char(10) inz;
  dcl-s p1_callStkE char(256) inz;
  dcl-s p1_callStkCtr int(10) inz;
  dcl-s p1_msgKey char(4) inz;
  dcl-ds p1_errCode likeds(errCode_t) inz;
  // Optional Parameter Group 1
  dcl-s p1_lenCallStkE int(10) inz;
  dcl-ds p1_qCallStkE len(20) qualified;
    module  char(10) inz;
    program char(10) inz;
  end-ds;
  dcl-s p1_waitTime int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Splitt i_msg
  msg = i_msg;

  //  Set defaults ...
  //  ... stack counter
  If (%parms >= p_toStkC);
    toStkC = i_toStkC;
  Else;
    toStkC = cMsg_Same;
  Endif;

  //  ... to procedure
  If (%parms >= p_toProc);
    toProc = i_toProc;
  Else;
    toProc = cMsg_ToMyself;
  Endif;

  //  ... to modul
  If (%parms >= p_toMod);
    p_TestOmit(isPresent: p_toMod: *omit);
    If (isPresent = 1);
      toMod = i_toMod;
    Else;
      toMod = '*NONE';
    Endif;
  Else;
    toMod = '*NONE';
  Endif;

  //  ... to program
  IF (%parms >= p_toPgm);
    toPgm = i_toPgm;
  Else;
    toPgm = '*NONE';
  Endif;

  //  Set parameter
  //  Call stack counter ...
  Select;
  //  ... *EXT
  When (toStkC = cMsg_Ext);
    p1_callStkCtr = 0;
    toProc        = '*EXT';
  //  ... *PERVIOUS
  When (toStkC = cMsg_Prv);
    p1_callStkCtr = 1;
  //  ... *SAME
  When (toStkC = cMsg_Same);
    p1_callStkCtr = 0;
  //  ... sonst
  Other;
    p1_callStkCtr = 0;
  Endsl;

  //  To procedure ...
  Select;
  //  ... *
  When (toProc = cMsg_ToMyself);
    p1_callStkE = '*';
    //      ... skip SndPgmMsg
    p1_callStkCtr = p1_callStkCtr + 1;
  //  ... *PGMBDY
  When (toProc = cMsg_ToPgmBdy);
    p1_callStkE = '*PGMBDY';
    If toPgm = '';
      toPgm = '_CL_PEP';
    Endif;
  //  ... *CTLBDY
  When (toProc = cMsg_ToCtlBdy);
    p1_callStkE = '*CTLBDY';
  //  ... *PGMNAME
  When (toProc = cMsg_ToPgm);
    p1_callStkE = '*PGMNAME';
  //  ... *EXT
  When (toProc = '*EXT');
    p1_callStkE = '*EXT';
  //  ... procedure
  Other;
    p1_callStkE = toProc;
  Endsl;

  //  To module ...
  p1_qCallStkE.module = toMod;

  //  To program ...
  p1_qCallStkE.program = toPgm;

  //  Message ...
  p1_DSMsgF = msg.file;
  p1_DSMsgL = msg.lib;
  p1_msgType = msg.type;
  p1_msgID = msg.ID;
  p1_lenMsgData = %size(p1_msgData);
  p1_msgData = msg.data;

  //  Message key ...
  p1_msgKey = '';
  //  Errorcode ...
  p1_errCode = f_newApiErrCode(cFalse);

  //  Others ...
  p1_lenCallStkE = %size(p1_CallStkE);
  p1_waitTime = -1;

  QMHSNDPM(p1_msgID: p1_DSMsgFObj: p1_msgData: p1_lenMsgData: p1_msgType
           : p1_callStkE: p1_callStkCtr: p1_msgKey: p1_errCode
           : p1_lenCallStkE: p1_qCallStkE: p1_waitTime);

end-proc;

//===============================================================*
//  newMsg
//===============================================================*
dcl-proc f_newMsg export;
  dcl-pi *n like(msg_t);
    i_msgID   char(7) options(*nopass: *omit) const;
    i_msgData char(512) options(*nopass: *omit) const;
    i_msgType char(10) options(*nopass: *omit) const;
    i_msgFile char(10) options(*nopass: *omit) const;
    i_msgLib  char(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-ds msg likeds(msg_t) inz;

  //  Parameter positions
  dcl-c p_msgID 1;
  dcl-c p_msgData 2;
  dcl-c p_msgType 3;
  dcl-c p_msgFile 4;
  dcl-c p_msgLib 5;

  //  Optional parameter fields
  dcl-s msgID char(7) inz;
  dcl-s msgData char(512) inz;
  dcl-s msgType char(10) inz;
  dcl-s msgFile char(10) inz;
  dcl-s msgLib char(10) inz;

  dcl-s isPresent int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Optionale Parameter ...
  //  ... Msg-ID
  If (%parms >= p_msgID);
    p_testOmit(isPresent: p_msgID : *omit);
  Else;
    isPresent = 0;
  Endif;

  If (isPresent = 1);
    msgID    = i_msgID;
  Else;
    msgID    = '';
  Endif;

  //  ... Msg-Data
  If (%parms >= p_msgData);
    p_testOmit(isPresent: p_msgData: *omit);
  Else;
    isPresent = 0;
  Endif;

  If (isPresent = 1);
    msgData  = i_msgData;
  Else;
    msgData  = '';
  Endif;

  //  ... Msg-Typ
  If (%parms >= p_msgType);
    p_testOmit(isPresent: p_msgType: *omit);
  Else;
    isPresent = 0;
  Endif;

  If (isPresent = 1);
    msgType  = i_msgType;
  Else;
    msgType  = '*INFO';
  Endif;

  //  ... Msg-File
  If (%parms >= p_msgFile);
    p_testOmit(isPresent: p_msgFile : *omit);
  Else;
    isPresent = 0;
  Endif;

  If (isPresent = 1);
    msgFile  = i_msgFile;
  Else;
    msgFile  = cAppMsgF;
  Endif;

  //  ... Msg-Lib
  If (%parms >= p_msgLib);
    p_testOmit(isPresent: p_msgLib  : *omit);
  Else;
    isPresent = 0;
  Endif;

  If (isPresent = 1);
    msgLib   = i_msgLib;
  Else;
    msgLib   = cAppMsgL;
  Endif;

  //  Create message
  Clear msg;

  msg.file = msgFile;
  msg.lib = msgLib;
  msg.type = msgType;
  msg.ID = msgID;
  msg.data = msgData;

  Return msg;

end-proc;

//==================================================================*
//  Create new API error code
//==================================================================*
dcl-proc f_newApiErrCode export;
  dcl-pi *n like(errCode_t);
    i_monMsg ind value;
  end-pi;

  //  Deklarieren Funktionswert
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  Clear errCode;

  If (i_monMsg);
    errCode.bytPrv = %size(errCode);
  Else;
    errCode.bytPrv = 0;
  Endif;

  Return errCode;

end-proc;

//==================================================================*
//  Is API Error
// -----------------------------------------------------------------
//    cTrue  - error
//    cFalse - no error
//==================================================================*
dcl-proc f_isApiErr export;
  dcl-pi *n ind;
    i_errCode likeds(errCode_t) value;
  end-pi;

  //  Deklarieren Funktionswert
  dcl-s o_isError ind inz(cFalse);
  //-------------------------------------------------------------------

  If (i_errCode.bytAvl = 0);
    o_isError = cFalse;
  Else;
    o_isError = cTrue;
  Endif;

  Return o_isError;

end-proc;

//=========================================================================
//  Retrieve aplha-numeric System Value.
//=========================================================================
dcl-proc f_rtvNetAtrA export;
  dcl-pi *n char(4096);
    i_netAtrName char(10) value;
  end-pi;

  //  return value
  dcl-s netAtrA char(4096) inz;

  //  work fields
  dcl-s rcvVar inz like(netAtrA);
  dcl-s rcvVarLen int(10) inz(%size(rcvVar));
  dcl-s numNetAtr int(10) inz(1);
  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds dataRet qualified based(pDataRet);
    numNetAtr int(10);
    ofsInfTbl int(10);
  end-ds;

  dcl-ds infTbl qualified based(pInfTbl);
    netAtrName char(10);
    dataType   char(1);
    infSts     char(1);
    dataLen    int(10);
    data       like(netAtrA);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  QWCRNETA(rcvVar: rcvVarLen: numNetAtr: i_netAtrName: errCode);

  pDataRet = %addr(rcvVar);
  pInfTbl = %addr(rcvVar) + dataRet.ofsInfTbl;

  If (infTbl.dataType = 'C' and infTbl.infSts <> 'L');
    netAtrA = %subst(infTbl.data: 1: infTbl.dataLen);
  Else;
    netAtrA = '*ERROR';
  Endif;

  return netAtrA;

end-proc;

//==================================================================*
//  Check for Object Existance.
//==================================================================*
dcl-proc f_exist export;
  dcl-pi *n ind;
    i_obj     char(10) value;
    i_lib     char(10) value;
    i_objType char(10) value;
  end-pi;

  //  Return Value
  dcl-s isAvailable ind inz;

  //  Fields
  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds OBJD0100 likeds(objd0100_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  qObj.name = i_obj;
  qObj.lib = i_lib;
  errCode = f_newApiErrCode(cTrue);

  QUSROBJD(
     OBJD0100: %size(OBJD0100): 'OBJD0100': qObj: i_objType: errCode);

  If (f_isApiErr(errCode));
    isAvailable = cFalse;
  Else;
    isAvailable = cTrue;
  Endif;

  Return isAvailable;

end-proc;

