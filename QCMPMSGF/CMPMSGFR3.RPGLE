      * =================================================================== *
      *                                                                     *
      *  Kurzdokumentation :                                                *
      *                                                                     *
      *  Bereich . . . : CMPMSGF                                            *
      *  Objekt  . . . : CMPMSGFR3                                          *
      *  Beschreibung  : Tool: CMPMSGF    (Compare Message File     ) SRVMOD*
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Datum . . . . : 23.12.2001                                         *
      *                                                                     *
      * =================================================================== *
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      * =================================================================== *
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *                                                                     *
      *                                                                     *
      *                                                                     *
      * =================================================================== *
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< OPTION(*EVENTF);                                     *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      * =================================================================== *
     H DEBUG
     H NOMAIN
     H EXTBININT(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
      /COPY QCMPMSGF,COPYRIGHT
      *===============================================================*
      *
      *== Prototypes =================================================*
      /COPY QCMPMSGF,CMPMSGFR4
      *===============================================================*
      *
      *===============================================================*
      *  rmvPgmMsg     (not fully tested)
      *===============================================================*
      *
     P p_rmvPgmMsg...
     P                 B                   export
     D                 PI
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)
      *
      *  Parameter positions
     D p_toStkC        C                   const(1)
     D p_toProc        C                   const(2)
     D p_toMod         C                   const(3)
     D p_toPgm         C                   const(4)
      *
      *  Local fields
     D toStkC          S                   like(i_toStkC  ) inz
     D toProc          S                   like(i_toProc  ) inz
     D toMod           S                   like(i_toMod   ) inz
     D toPgm           S                   like(i_toPgm   ) inz
      *
     D isPresent       S             10I 0 inz
      *
      *  API: QMHRMVPM
     D stackQ          DS
     D  stackQ_mod                   10A   inz
     D  stackQ_pgm                   10A   inz
      *
     D errCode         DS                  likeds(errCode_t) inz
      *
     D p1_callStkE     S            256A   inz
     D p1_callStkCtr   S             10I 0 inz
     D p1_msgKey       S              4A   inz
     D p1_msgToRmv     S             10A   inz
     D p1_errCode      DS                  likeds(errCode_t) inz
      * Optional Parameter Group 1
     D p1_lenCallStkE  S             10I 0 inz
     D p1_callStkEQ    DS            20
     D  p1_callStkEQM          1     10A   inz
     D  p1_callStkEQP         11     20A   inz
     D p1_rmvUnhExc    S             10A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Set defaults ...
      *  ... stack counter
     C                   If        %parms >= p_toStkC
     C                   Eval      toStkC = i_toStkC
     C                   Else
     C                   Eval      toStkC = cMsg_Same
     C                   Endif
      *
      *  Set defaults ...
      *  ... stack counter
     C                   If        %parms >= p_toStkC
     C                   Eval      toStkC = i_toStkC
     C                   Else
     C                   Eval      toStkC = cMsg_Same
     C                   Endif
      *
      *  ... to procedure
     C                   If        %parms >= p_toProc
     C                   Eval      toProc = i_toProc
     C                   Else
     C                   Eval      toProc = cMsg_ToMyself
     C                   Endif
      *
      *  ... to modul
     C                   If        %parms >= p_toMod
     C                   Callp     p_TestOmit(isPresent: p_toMod: *omit)
     C                   If        isPresent = 1
     C                   Eval      toMod  = i_toMod
     C                   Else
     C                   Eval      toMod  = '*NONE'
     C                   Endif
     C                   Else
     C                   Eval      toMod  = '*NONE'
     C                   Endif
      *
      *  ... to program
     C                   IF        %parms >= p_toPgm
     C                   Eval      toPgm  = i_toPgm
     C                   Else
     C                   Eval      toPgm  = '*NONE'
     C                   Endif
      *
      *  Set parameter
      *  Call stack counter ...
     C                   Select
      *  ... *EXT
     C                   When      toStkC        = cMsg_Ext
     C                   Eval      p1_callStkCtr = 0
     C                   Eval      toProc        = '*EXT'
      *  ... *PERVIOUS
     C                   When      toStkC        = cMsg_Prv
     C                   Eval      p1_callStkCtr = 1
      *  ... *SAME
     C                   When      toStkC        = cMsg_Same
     C                   Eval      p1_callStkCtr = 0
      *  ... sonst
     C                   Other
     C                   Eval      p1_callStkCtr = 0
     C                   Endsl
      *
      *  To procedure ...
     C                   Select
      *  ... *
     C                   When      toProc        = cMsg_ToMyself
     C                   Eval      p1_callStkE   = '*'
      *      ... skip RmvPgmMsg
     C                   Eval      p1_callStkCtr = p1_callStkCtr + 1
      *  ... *PGMBDY
     C                   When      toProc        = cMsg_ToPgmBdy
      ***                Eval      p1_callStkE   = '_QRNP_PEP_' + sds_pgmProc
     C                   Eval      p1_callStkE   = '_CL_PEP'
      *  ... *PGMNAME
     C                   When      toProc        = cMsg_ToPgm
     C                   Eval      p1_callStkE   = sds_pgmName
      *  ... *EXT
     C                   When      toProc        = '*EXT'
     C                   Eval      p1_callStkE   = '*EXT'
      *  ... procedure
     C                   Other
     C                   Eval      p1_callStkE   = toProc
     C                   Endsl
      *
      *  To modul ...
     C                   Eval      p1_CallStkEQM = toMod
      *
      *  To program ...
     C                   Eval      p1_callStkEQP = toPgm
      *
      *  Message key ...
     C                   Eval      p1_msgKey      = ''
      *  Message to remove ...
     C                   Eval      p1_msgToRmv    = '*ALL'
      *  Errorcode ...
     C                   Eval      p1_errCode = f_newApiErrCode(cFalse)
      *
      *  Others ...
     C                   Eval      p1_lenCallStkE = %size(p1_CallStkE)
     C                   Eval      p1_RmvUnhExc   = '*NO'
      *
     C                   Call      'QMHRMVPM'
     C                   Parm                    p1_callStkE
     C                   Parm                    p1_callStkCtr
     C                   Parm                    p1_msgKey
     C                   Parm                    p1_msgToRmv
     C                   Parm                    p1_errCode
     C                   Parm                    p1_lenCallStkE
     C                   Parm                    p1_callStkEQ
     C                   Parm                    p1_rmvUnhExc
      *
     C                   Return
      *
     P                 E
      *
      *===============================================================*
      *  sndPgmMsg
      *===============================================================*
      *
     P p_sndPgmMsg...
     P                 B                   export
     D                 PI
     D  i_msg                              const  like(msg_t     )
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)
      *
      *  Splitt i_msg
     D msg             DS                  likeds(msg_t) inz
      *
      *  Parameter positions
     D p_toStkC        C                   const(2)
     D p_toProc        C                   const(3)
     D p_toMod         C                   const(4)
     D p_toPgm         C                   const(5)
      *
      *  Local fields
     D toStkC          S                   like(i_toStkC  ) inz
     D toProc          S                   like(i_toProc  ) inz
     D toMod           S                   like(i_toMod   ) inz
     D toPgm           S                   like(i_toPgm   ) inz
      *
     D isPresent       S             10I 0 inz
      *
      *  API: QMHSNDPM
     D p1_msgID        S              7A   inz
     D p1_DSMsgFObj    DS            20
     D  p1_DSMsgF              1     10A   inz
     D  p1_DSMsgL             11     20A   inz
     D p1_msgData      S            512A   inz
     D p1_lenMsgData   S             10I 0 inz
     D p1_msgType      S             10A   inz
     D p1_callStkE     S            256A   inz
     D p1_callStkCtr   S             10I 0 inz
     D p1_msgKey       S              4A   inz
     D p1_errCode      DS                  likeds(errCode_t) inz
      * Optional Parameter Group 1
     D p1_lenCallStkE  S             10I 0 inz
     D p1_callStkEQ    DS            20
     D  p1_callStkEQM          1     10A   inz
     D  p1_callStkEQP         11     20A   inz
     D p1_waitTime     S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Splitt i_msg
     C                   Eval      msg = i_msg
      *
      *  Set defaults ...
      *  ... stack counter
     C                   If        %parms >= p_toStkC
     C                   Eval      toStkC = i_toStkC
     C                   Else
     C                   Eval      toStkC = cMsg_Same
     C                   Endif
      *
      *  ... to procedure
     C                   If        %parms >= p_toProc
     C                   Eval      toProc = i_toProc
     C                   Else
     C                   Eval      toProc = cMsg_ToMyself
     C                   Endif
      *
      *  ... to modul
     C                   If        %parms >= p_toMod
     C                   Callp     p_TestOmit(isPresent: p_toMod: *omit)
     C                   If        isPresent = 1
     C                   Eval      toMod  = i_toMod
     C                   Else
     C                   Eval      toMod  = '*NONE'
     C                   Endif
     C                   Else
     C                   Eval      toMod  = '*NONE'
     C                   Endif
      *
      *  ... to program
     C                   IF        %parms >= p_toPgm
     C                   Eval      toPgm  = i_toPgm
     C                   Else
     C                   Eval      toPgm  = '*NONE'
     C                   Endif
      *
      *  Set parameter
      *  Call stack counter ...
     C                   Select
      *  ... *EXT
     C                   When      toStkC        = cMsg_Ext
     C                   Eval      p1_callStkCtr = 0
     C                   Eval      toProc        = '*EXT'
      *  ... *PERVIOUS
     C                   When      toStkC        = cMsg_Prv
     C                   Eval      p1_callStkCtr = 1
      *  ... *SAME
     C                   When      toStkC        = cMsg_Same
     C                   Eval      p1_callStkCtr = 0
      *  ... sonst
     C                   Other
     C                   Eval      p1_callStkCtr = 0
     C                   Endsl
      *
      *  To procedure ...
     C                   Select
      *  ... *
     C                   When      toProc        = cMsg_ToMyself
     C                   Eval      p1_callStkE   = '*'
      *      ... skip SndPgmMsg
     C                   Eval      p1_callStkCtr = p1_callStkCtr + 1
      *  ... *PGMBDY
     C                   When      toProc        = cMsg_ToPgmBdy
     C                   Eval      p1_callStkE   = '*PGMBDY'
     C                   If        toPgm         = ''
     C                   Eval      toPgm         = '_CL_PEP'
     C                   Endif
      *  ... *CTLBDY
     C                   When      toProc        = cMsg_ToCtlBdy
     C                   Eval      p1_callStkE   = '*CTLBDY'
      *  ... *PGMNAME
     C                   When      toProc        = cMsg_ToPgm
     C                   Eval      p1_callStkE   = '*PGMNAME'
      *  ... *EXT
     C                   When      toProc        = '*EXT'
     C                   Eval      p1_callStkE   = '*EXT'
      *  ... procedure
     C                   Other
     C                   Eval      p1_callStkE   = toProc
     C                   Endsl
      *
      *  To modul ...
     C                   Eval      p1_CallStkEQM = toMod
      *
      *  To program ...
     C                   Eval      p1_callStkEQP = toPgm
      *
      *  Message ...
     C                   Eval      p1_DSMsgF      = msg.file
     C                   Eval      p1_DSMsgL      = msg.lib
     C                   Eval      p1_msgType     = msg.type
     C                   Eval      p1_msgID       = msg.ID
     C                   Eval      p1_lenMsgData  = %size(p1_msgData)
     C                   Eval      p1_msgData     = msg.data
      *
      *  Message key ...
     C                   Eval      p1_msgKey      = ''
      *  Errorcode ...
     C                   Eval      p1_errCode = f_newApiErrCode(cFalse)
      *
      *  Others ...
     C                   Eval      p1_lenCallStkE = %size(p1_CallStkE)
     C                   Eval      p1_waitTime    = -1
      *
     C                   Call      'QMHSNDPM'
     C                   Parm                    p1_msgID
     C                   Parm                    p1_DSMsgFObj
     C                   Parm                    p1_msgData
     C                   Parm                    p1_lenMsgData
     C                   Parm                    p1_msgType
     C                   Parm                    p1_callStkE
     C                   Parm                    p1_callStkCtr
     C                   Parm                    p1_msgKey
     C                   Parm                    p1_errCode
     C                   Parm                    p1_lenCallStkE
     C                   Parm                    p1_callStkEQ
     C                   Parm                    p1_waitTime
      *
     C                   Return
      *
     P                 E
      *
      *===============================================================*
      *  newMsg
      *===============================================================*
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
      *
      *  Return value
     D msg             DS                  likeds(msg_t) inz
      *
      *  Parameter positions
     D p_msgID         C                   const(1)
     D p_msgData       C                   const(2)
     D p_msgType       C                   const(3)
     D p_msgFile       C                   const(4)
     D p_msgLib        C                   const(5)
      *
      *  Optional parameter fields
     D msgID           S              7A   inz
     D msgData         S            512A   inz
     D msgType         S             10A   inz
     D msgFile         S             10A   inz
     D msgLib          S             10A   inz
      *
     D isPresent       S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Optionale Parameter ...
      *  ... Msg-ID
     C                   If        %parms >= p_msgID
     C                   Callp     p_testOmit(isPresent: p_msgID : *omit)
     C                   Else
     C                   Eval      isPresent = 0
     C                   Endif
      *
     C                   If        isPresent = 1
     C                   Eval      msgID    = i_msgID
     C                   Else
     C                   Eval      msgID    = ''
     C                   Endif
      *  ... Msg-Data
     C                   If        %parms >= p_msgData
     C                   Callp     p_testOmit(isPresent: p_msgData: *omit)
     C                   Else
     C                   Eval      isPresent = 0
     C                   Endif
      *
     C                   If        isPresent = 1
     C                   Eval      msgData  = i_msgData
     C                   Else
     C                   Eval      msgData  = ''
     C                   Endif
      *  ... Msg-Typ
     C                   If        %parms >= p_msgType
     C                   Callp     p_testOmit(isPresent: p_msgType: *omit)
     C                   Else
     C                   Eval      isPresent = 0
     C                   Endif
      *
     C                   If        isPresent = 1
     C                   Eval      msgType  = i_msgType
     C                   Else
     C                   Eval      msgType  = '*INFO'
     C                   Endif
      *  ... Msg-File
     C                   If        %parms >= p_msgFile
     C                   Callp     p_testOmit(isPresent: p_msgFile : *omit)
     C                   Else
     C                   Eval      isPresent = 0
     C                   Endif
      *
     C                   If        isPresent = 1
     C                   Eval      msgFile  = i_msgFile
     C                   Else
     C                   Eval      msgFile  = cAppMsgF
     C                   Endif
      *  ... Msg-Lib
     C                   If        %parms >= p_msgLib
     C                   Callp     p_testOmit(isPresent: p_msgLib  : *omit)
     C                   Else
     C                   Eval      isPresent = 0
     C                   Endif
      *
     C                   If        isPresent = 1
     C                   Eval      msgLib   = i_msgLib
     C                   Else
     C                   Eval      msgLib   = cAppMsgL
     C                   Endif
      *
      *  Create message
     C                   Clear                   msg
      *
     C                   Eval      msg.file = msgFile
     C                   Eval      msg.lib  = msgLib
     C                   Eval      msg.type = msgType
     C                   Eval      msg.ID   = msgID
     C                   Eval      msg.data = msgData
      *
     C                   Return    msg
      *
     P                 E
      *
      *==================================================================*
      *  Create new API error code
      *==================================================================*
      *
     P f_newApiErrCode...
     P                 B                   export
     D                 PI                         like(errCode_t)
     D  i_monMsg                       N   value
      *
      *  Deklarieren Funktionswert
     D errCode         DS                  likeds(errCode_t) inz
      *-------------------------------------------------------------------
      *
     C                   Clear                   errCode
      *
     C                   If        i_monMsg
     C                   Eval      errCode.bytPrv = %size(errCode)
     C                   Else
     C                   Eval      errCode.bytPrv = 0
     C                   Endif
      *
     C                   Return    errCode
      *
     P                 E
      *
      *==================================================================*
      *  Is API Error
      * -----------------------------------------------------------------
      *    cTrue  - error
      *    cFalse - no error
      *==================================================================*
      *
     P f_isApiErr...
     P                 B                   export
     D                 PI              N
     D  i_errCode                          value  likeds(errCode_t)
      *
      *  Deklarieren Funktionswert
     D o_isError       S               N   inz(cFalse)
      *-------------------------------------------------------------------
      *
     C                   If        i_errCode.bytAvl = 0
     C                   Eval      o_isError = cFalse
     C                   Else
     C                   Eval      o_isError = cTrue
     C                   Endif
      *
     C                   Return    o_isError
      *
     P                 E
      *
      *=========================================================================
      *  Retrieve aplha-numeric System Value.
      *=========================================================================
      *
     P f_rtvNetAtrA...
     P                 B                   export
     D                 PI          4096A
     D  i_netAtrName                 10A   value
      *
      *  return value
     D netAtrA         S           4096A   inz
      *
      *  work fields
     D rcvVar          S                   inz like(netAtrA )
     D rcvVarLen       S             10I 0 inz(%size(rcvVar))
     D numNetAtr       S             10I 0 inz(1)
     D errCode         DS                  likeds(errCode_t) inz
      *
     D dataRet         DS                  based(pDataRet)
     D  dataRet_numNetAtr...
     D                               10I 0
     D  dataRet_ofsInfTbl...
     D                               10I 0
      *
     D infTbl          DS                  based(pInfTbl )
     D  infTbl_netAtrName...
     D                               10A
     D  infTbl_dataType...
     D                                1A
     D  infTbl_infSts...
     D                                1A
     D  infTbl_dataLen...
     D                               10I 0
     D  infTbl_data...
     D                                     like(netAtrA )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Call      'QWCRNETA'
     C                   Parm                    rcvVar
     C                   Parm                    rcvVarLen
     C                   Parm                    numNetAtr
     C                   Parm                    i_netAtrName
     C                   Parm                    errCode
      *
     C                   Eval      pDataRet = %addr(rcvVar)
     C                   Eval      pInfTbl  = %addr(rcvVar) + dataRet_ofsInfTbl
      *
     C                   If        (infTbl_dataType = 'C')  and
     C                             (infTbl_infSts   <>'L')
     C                   Eval      netAtrA  = %subst(infTbl_data: 1:
     C                                               infTbl_dataLen)
     C                   Else
     C                   Eval      netAtrA  = '*ERROR'
     C                   Endif
      *
     C                   return    netAtrA
      *
     P                 E
      *
      *==================================================================*
      *  Check for Object Existance.
      *==================================================================*
      *
     P f_exist...
     P                 B                   export
     D                 PI              N
     D  i_obj                        10A   value
     D  i_lib                        10A   value
     D  i_objType                    10A   value
      *
      *  Return Value
     D isAvailable     S               N   inz
      *
      *  Fields
     D qObj            DS                  likeds(qObj_t) inz
     D OBJD0100        DS                  likeds(objd0100_t) inz
     D errCode         DS                  likeds(errCode_t) inz
      *-------------------------------------------------------------------
      *
     C                   Eval      qObj.name = i_obj
     C                   Eval      qObj.lib = i_lib
     C                   Eval      errCode = f_newApiErrCode(cTrue)
      *
     C                   Callp     QUSROBJD(OBJD0100        :
     C                                      %size(OBJD0100) :
     C                                      'OBJD0100'      :
     C                                      qObj            :
     C                                      i_objType       :
     C                                      errCode         )
      *
     C                   If        f_isApiErr(errCode)
     C                   Eval      isAvailable = cFalse
     C                   Else
     C                   Eval      isAvailable = cTrue
     C                   Endif
      *
     C                   Return    isAvailable
      *
     P                 E
      *
