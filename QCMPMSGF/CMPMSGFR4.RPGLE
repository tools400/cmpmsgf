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
       //  Datum       Name          Änderung                                 *
       //  ----------  ------------  ---------------------------------------  *
       //                                                                     *
       // =================================================================== *
       //
       //== Workstation Constants ======================================*
     D cKeyF1          C                   CONST(X'31')
     D cKeyF2          C                   CONST(X'32')
     D cKeyF3          C                   CONST(X'33')
     D cKeyF4          C                   CONST(X'34')
     D cKeyF5          C                   CONST(X'35')
     D cKeyF6          C                   CONST(X'36')
     D cKeyF7          C                   CONST(X'37')
     D cKeyF8          C                   CONST(X'38')
     D cKeyF9          C                   CONST(X'39')
     D cKeyF10         C                   CONST(X'3A')
     D cKeyF11         C                   CONST(X'3B')
     D cKeyF12         C                   CONST(X'3C')
     D cKeyF13         C                   CONST(X'B1')
     D cKeyF14         C                   CONST(X'B2')
     D cKeyF15         C                   CONST(X'B3')
     D cKeyF16         C                   CONST(X'B4')
     D cKeyF17         C                   CONST(X'B5')
     D cKeyF18         C                   CONST(X'B6')
     D cKeyF19         C                   CONST(X'B7')
     D cKeyF20         C                   CONST(X'B8')
     D cKeyF21         C                   CONST(X'B9')
     D cKeyF22         C                   CONST(X'BA')
     D cKeyF23         C                   CONST(X'BB')
     D cKeyF24         C                   CONST(X'BC')

     D cKeyClear       C                   CONST(X'BD')
     D cKeyDelete      C                   CONST(X'BD')

     D cKeyEnter       C                   CONST(X'F1')
       //          Nicht definiert                   F2
     D cKeyHelp        C                   CONST(X'F3')
     D cKeyPageDown    C                   CONST(X'F4')
     D cKeyPageUp      C                   CONST(X'F5')
     D cKeyPrintScr    C                   CONST(X'F6')
       //          Nicht definiert                   F7
     D cKeyReset       C                   CONST(X'F8')

     D cKeyLightPen    C                   CONST(X'3F')

     D cSflFold        C                   CONST(*off)
     D cSflDrop        C                   CONST(*on )
       //===============================================================*

       //== Global Constants============================================*

       //  Boolean Constants ...
     D cTrue           C                   const(*on )
     D cFalse          C                   const(*off)

       //  Application Message File ...
     D cAppMsgF        C                   const('CMPMSGF')
     D cAppMsgL        C                   const('*LIBL')

       //  Messages ...
       //  ... to stack counter
     D cMsg_Ext        C                   const(-1)
     D cMsg_Prv        C                   const(-2)
     D cMsg_Same       C                   const(-3)

       //  ... to procedure
     D cMsg_ToMyself   C                   const('*')
     D cMsg_ToPgmBdy   C                   const('*PGMBDY')
     D cMsg_ToCtlBdy   C                   const('*CTLBDY')
     D cMsg_ToPgm      C                   const('*PGMNAME')

     D cMSGID_LOVAL    C                   const(*LOVAL)
     D cMSGID_HIVAL    C                   const(*HIVAL)
     D cMSGID_EOF      C                   const('*EOF')
     D cMSGID_SAME     C                   const('*MSGID')

     D cCmpCopyLeft    C                   const('<=')
     D cCmpCopyRight   C                   const('=>')
     D cCmpEqual       C                   const('==')
     D cCmpNotEqual    C                   const('<>')
     D cCmpNoAction    C                   const('| ')

       //  Others ...
     D cLowDat7        C                   const('0010101')
     D cQuote          C                   const('''')
       //===============================================================*

       //== Templates ==================================================*
      /COPY QCMPMSGF,FDMSG
      /COPY QCMPMSGF,FDQOBJ
      /COPY QCMPMSGF,FDERRCODE
      /COPY QCMPMSGF,FDRTVM0300
      /COPY QCMPMSGF,FDRTVM0400
      /COPY QCMPMSGF,FDOBJD0100

     D range_t         DS                  based(pDummy)
     D  numVal                        5I 0
     D  lower                         7A
     D  upper                         7A
       //===============================================================*

       //== Prototypes =================================================*
       //  ... compare message file       (CMPMSGFR1)
     D f_cmpMsgF...
     D                 PR             1A
     D  i_file1                      10A   const
     D  i_lib1                       10A   const
     D  i_file2                      10A   const
     D  i_lib2                       10A   const
     D  i_range                            const likeds(range_t)
     D  i_cmpDate                     1A   const
     D  i_cmpLvl                      1A   const
     D  i_error                       1A   const

       //  ... change filter              (CMPMSGFR2)
     D f_chgFilter...
     D                 PR             1A
     D  io_cpyr                       1A
     D  io_cpyl                       1A
     D  io_equal                      1A
     D  io_nequal                     1A

       //  ... load module filter         (CMPMSGFR2)
     D p_loadFilter...
     D                 PR

       //  ... unload module filter       (CMPMSGFR2)
     D p_unloadFilter...
     D                 PR

       //  ... remove program messages    (CMPMSGFR3)
     D p_rmvPgmMsg...
     D                 PR
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)

       //  ... send program message       (CMPMSGFR3)
     D p_sndPgmMsg...
     D                 PR
     D  i_msg                              const  like(msg_t     )
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)

       //  ... create a new message       (CMPMSGFR3)
     D f_newMsg...
     D                 PR                         like(msg_t     )
     D  i_msgID                       7A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgDta                    512A   const  options(*nopass :
     D                                                    *omit   )
     D  i_msgType                    10A   const  options(*nopass :
     D                                                    *omit   )
     D  i_file                       10A   const  options(*nopass :
     D                                                    *omit   )
     D  i_lib                        10A   const  options(*nopass :
     D                                                    *omit   )

       //  ... create a new API errorcode (CMPMSGFR3)
     D f_newApiErrCode...
     D                 PR                         like(errCode_t)
     D  i_monMsg                       N   value

       //  ... test for API error         (CMPMSGFR3)
     D f_isApiErr...
     D                 PR              N
     D  i_errCode                          value  likeds(errCode_t)

       //  ... retrieve network attribute (CMPMSGFR3)
     D f_rtvNetAtrA...
     D                 PR          4096A
     D  i_netAtrName                 10A   value

       //  ... check if object exists     (CMPMSGFR3)
     D f_exist...
     D                 PR              N
     D  i_obj                        10A   value
     D  i_lib                        10A   value
     D  i_objType                    10A   value
       //===============================================================*

       //== external Prototypes ========================================*
       //  ... test omitted argument
     D p_testOmit...
     D                 PR                         extproc('CEETSTA')
     D  o_isPresent                  10I 0
     D  i_argNum                     10I 0 const
     D  o_fc                         12A          options(*omit)

       //  ... Display Command Line Window (QUSCMDLN) API
     D QUSCMDLN...
     D                 PR                  extpgm('QUSCMDLN')

       //  ... Remove Program Messages (QMHRMVPM) API
     D QMHRMVPM        PR                  EXTPGM('QMHRMVPM')
     D  i_callStkE                  256a   const
     D  i_callStkC                   10i 0 const
     D  i_msgKey                      4a   const
     D  i_msgToRmv                   10a   const
     D  io_ErrCode                65535a          options(*varsize)
     D  i_lenStkE                    10i 0 const  options(*nopass )             | optGrp 1
     D  i_callStkEQ                  20A   const  options(*nopass )             |
     D  i_rmvUnhdlExc                10a   const  options(*nopass )             |
     D  i_callStkEDT                 10a   const  options(*nopass )             | optGrp 2
     D  i_alwDfRpyRjc                10a   const  options(*nopass )             | optGrp 3

       //  ... Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                  EXTPGM('QMHSNDPM')
     D  i_msgID                       7a   const
     D  i_qMsgF                      20A   const
     D  i_msgData                 32767A   const  options(*varsize )
     D  i_length                     10i 0 const
     D  i_msgType                    10a   const
     D  i_callStkE                  256a   const
     D  i_callStkC                   10i 0 const
     D  o_msgKey                      4a
     D  io_ErrCode                32767A          options(*varsize )
     D  i_lenStkE                    10i 0 const  options(*nopass  )            | optGrp 1
     D  i_callStkEQ                  20A   const  options(*nopass  )            |
     D  i_wait                       10i 0 const  options(*nopass  )            |
     D  i_callStkEDT                 10a   const  options(*nopass  )            | optGrp 2
     D  i_ccsid                      10i 0 const  options(*nopass  )            |

       //  ... Retrieve Network Attributes (QWCRNETA) API
     D QWCRNETA        PR                  EXTPGM('QWCRNETA')
     D  o_rcvVar                  32767A          options(*varsize)
     D  i_lenRcv                     10i 0 const
     D  i_numAttr                    10i 0 const
     D  i_attrNames                  10a   const  dim(50) options(*varsize)
     D  io_errorCode              32767A          options(*varsize)

       //  ... Retrieve Message (QMHRTVM) API
     D QMHRTVM...
     D                 PR                  extpgm('QMHRTVM')
     D  i_msgD                    32767A         options(*varsize)
     D  i_lenMsgD                    10I 0 const
     D  i_format                      8A   const
     D  i_msgID                       7A   const
     D  i_qMsgF                      20A   const
     D  i_rplcData                32767A   const options(*varsize)
     D  i_lenRplcData                10I 0 const
     D  i_rplcSubstV                 10A   const
     D  i_rtnFmtCtlC                 10A   const
     D  io_errCode                32767A         options(*varsize)
     D  i_rtvOpt                     10A   const options(*nopass)
     D  i_ccsid                      10I 0 const options(*nopass)
     D  i_rplDtaCcsid                10I 0 const options(*nopass)

       //  ... Retrieve Object Description (QUSROBJD) API
     D QUSROBJD...
     D                 PR                  extpgm('QUSROBJD')
     D  i_objD                    32767A         options(*varsize)
     D  i_lenObjD                    10I 0 const
     D  i_format                      8A   const
     D  i_qObj                       20A   const
     D  i_objType                    10A   const
     D  io_errCode                32767A         options(*varsize:
     D                                                   *nopass )

       //  ... system -- Execute a Command
     D system...
     D                 PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)

     D EXCP_MSGID      S              7A   import('_EXCP_MSGID')

       //===============================================================*

       //== Program status data structure===============================*
     D sds            SDS                  qualified
     D  pgmName                      10A
     D  pgmStat                       5S 0
     D  pPrevStat                     5S 0
     D  lastSeq                       8A
     D  lastSubr                      8A
     D  numParm                       3S 0
     D  msgID                         7A
     D  miInstr                       4A
     D  workArea                     30A
     D  pgmLib                       10A
     D  msgText                      80A
     D  excpInd                       4A
     D  unused1                      16A
     D  datFmt                        8A
     D  year                          2S 0
     D  fileOpr                       8A
     D  fileStat                     35A
     D  job                          10A
     D  user                         10A
     D  jobNbr                        6S 0
     D  jobD                          6S 0
     D  pgmDate                       6S 0
     D  jobTime                       6S 0
     D  crtDate                       6A
     D  crtTime                       6A
     D  compVer                       4A
     D  srcFile                      10A
     D  srcLib                       10A
     D  srcMbr                       10A
     D  pgmProc                      10A
     D  modProc                      10A
     D  unused2                      76A
       //===============================================================*
