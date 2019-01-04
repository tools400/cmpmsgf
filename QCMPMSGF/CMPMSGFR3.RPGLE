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

       //== Prototypes =================================================*
      /COPY QCMPMSGF,CMPMSGFR4
       //===============================================================*

       //===============================================================*
       //  rmvPgmMsg     (not fully tested)
       //===============================================================*
     P p_rmvPgmMsg...
     P                 B                   export
     D                 PI
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)

       //  Parameter positions
     D p_toStkC        C                   const(1)
     D p_toProc        C                   const(2)
     D p_toMod         C                   const(3)
     D p_toPgm         C                   const(4)

       //  Local fields
     D toStkC          S                   like(i_toStkC  ) inz
     D toProc          S                   like(i_toProc  ) inz
     D toMod           S                   like(i_toMod   ) inz
     D toPgm           S                   like(i_toPgm   ) inz

     D isPresent       S             10I 0 inz

       //  API: QMHRMVPM
     D stackQ          DS
     D  stackQ_mod                   10A   inz
     D  stackQ_pgm                   10A   inz

     D errCode         DS                  likeds(errCode_t) inz

     D p1_callStkE     S            256A   inz
     D p1_callStkCtr   S             10I 0 inz
     D p1_msgKey       S              4A   inz
     D p1_msgToRmv     S             10A   inz
     D p1_errCode      DS                  likeds(errCode_t) inz
       // Optional Parameter Group 1
     D p1_lenCallStkE  S             10I 0 inz
     D p1_qCallStkE    DS            20    qualified
     D    module                     10A   inz
     D    program                    10A   inz
     D p1_rmvUnhExc    S             10A   inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  sndPgmMsg
       //===============================================================*
     P p_sndPgmMsg...
     P                 B                   export
     D                 PI
     D  i_msg                              const  like(msg_t     )
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)

       //  Splitt i_msg
     D msg             DS                  likeds(msg_t) inz

       //  Parameter positions
     D p_toStkC        C                   const(2)
     D p_toProc        C                   const(3)
     D p_toMod         C                   const(4)
     D p_toPgm         C                   const(5)

       //  Local fields
     D toStkC          S                   like(i_toStkC  ) inz
     D toProc          S                   like(i_toProc  ) inz
     D toMod           S                   like(i_toMod   ) inz
     D toPgm           S                   like(i_toPgm   ) inz

     D isPresent       S             10I 0 inz

       //  API: QMHSNDPM
     D p1_msgID        S              7A   inz
     D p1_DSMsgFObj    DS            20
     D p1_DSMsgF                     10A   inz
     D p1_DSMsgL                     10A   inz
     D p1_msgData      S            512A   inz
     D p1_lenMsgData   S             10I 0 inz
     D p1_msgType      S             10A   inz
     D p1_callStkE     S            256A   inz
     D p1_callStkCtr   S             10I 0 inz
     D p1_msgKey       S              4A   inz
     D p1_errCode      DS                  likeds(errCode_t) inz
       // Optional Parameter Group 1
     D p1_lenCallStkE  S             10I 0 inz
     D p1_qCallStkE    DS            20    qualified
     D    module                     10A   inz
     D    program                    10A   inz
     D p1_waitTime     S             10I 0 inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  newMsg
       //===============================================================*
     P f_newMsg...
     P                 B                         export
     D                 PI                         like(msg_t     )
     D  i_msgID                       7A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgData                   512A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgType                    10A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgFile                    10A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgLib                     10A   const  options(*nopass :
     D                                                    *omit   )

       //  Return value
     D msg             DS                  likeds(msg_t) inz

       //  Parameter positions
     D p_msgID         C                   const(1)
     D p_msgData       C                   const(2)
     D p_msgType       C                   const(3)
     D p_msgFile       C                   const(4)
     D p_msgLib        C                   const(5)

       //  Optional parameter fields
     D msgID           S              7A   inz
     D msgData         S            512A   inz
     D msgType         S             10A   inz
     D msgFile         S             10A   inz
     D msgLib          S             10A   inz

     D isPresent       S             10I 0 inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //==================================================================*
       //  Create new API error code
       //==================================================================*
     P f_newApiErrCode...
     P                 B                   export
     D                 PI                         like(errCode_t)
     D  i_monMsg                       N   value

       //  Deklarieren Funktionswert
     D errCode         DS                  likeds(errCode_t) inz
       //-------------------------------------------------------------------

      /FREE
       Clear errCode;

       If (i_monMsg);
          errCode.bytPrv = %size(errCode);
       Else;
          errCode.bytPrv = 0;
       Endif;

       Return errCode;

      /END-FREE
     P                 E

       //==================================================================*
       //  Is API Error
       // -----------------------------------------------------------------
       //    cTrue  - error
       //    cFalse - no error
       //==================================================================*
     P f_isApiErr...
     P                 B                   export
     D                 PI              N
     D  i_errCode                          value  likeds(errCode_t)

       //  Deklarieren Funktionswert
     D o_isError       S               N   inz(cFalse)
       //-------------------------------------------------------------------
      /FREE

       If (i_errCode.bytAvl = 0);
          o_isError = cFalse;
       Else;
          o_isError = cTrue;
       Endif;

       Return o_isError;

      /END-FREE
     P                 E

       //=========================================================================
       //  Retrieve aplha-numeric System Value.
       //=========================================================================
     P f_rtvNetAtrA...
     P                 B                   export
     D                 PI          4096A
     D  i_netAtrName                 10A   value

       //  return value
     D netAtrA         S           4096A   inz

       //  work fields
     D rcvVar          S                   inz like(netAtrA )
     D rcvVarLen       S             10I 0 inz(%size(rcvVar))
     D numNetAtr       S             10I 0 inz(1)
     D errCode         DS                  likeds(errCode_t) inz

     D dataRet         DS                  qualified based(pDataRet)
     D  numNetAtr                    10I 0
     D  ofsInfTbl                    10I 0

     D infTbl          DS                  qualified based(pInfTbl )
     D  netAtrName                   10A
     D  dataType                      1A
     D  infSts                        1A
     D  dataLen                      10I 0
     D  data                               like(netAtrA )
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       QWCRNETA(rcvVar: rcvVarLen: numNetAtr: i_netAtrName: errCode);

       pDataRet = %addr(rcvVar);
       pInfTbl = %addr(rcvVar) + dataRet.ofsInfTbl;

       If (infTbl.dataType = 'C' and infTbl.infSts <> 'L');
          netAtrA = %subst(infTbl.data: 1: infTbl.dataLen);
       Else;
          netAtrA = '*ERROR';
       Endif;

       return netAtrA;

      /END-FREE
     P                 E

       //==================================================================*
       //  Check for Object Existance.
       //==================================================================*
     P f_exist...
     P                 B                   export
     D                 PI              N
     D  i_obj                        10A   value
     D  i_lib                        10A   value
     D  i_objType                    10A   value

       //  Return Value
     D isAvailable     S               N   inz

       //  Fields
     D qObj            DS                  likeds(qObj_t) inz
     D OBJD0100        DS                  likeds(objd0100_t) inz
     D errCode         DS                  likeds(errCode_t) inz
       //-------------------------------------------------------------------
      /FREE

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

      /END-FREE
     P                 E

