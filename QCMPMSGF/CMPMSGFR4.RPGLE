 RAD  * =================================================================== *
 RAD  *                                                                     *
 RAD  *  Kurzdokumentation :                                                *
 RAD  *                                                                     *
 RAD  *  Bereich . . . : CMPMSGF                                            *
 RAD  *  Objekt  . . . : CMPMSGFR4                                          *
 RAD  *  Beschreibung  : Tool: CMPMSGF    (Compare Message File     ) GLOBAL*
 RAD  *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
 RAD  *  Datum . . . . : 23.12.2001                                         *
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
 RAD  * =================================================================== *
      *
      *== Workstation Constants ======================================*
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
      *
     D cKeyClear       C                   CONST(X'BD')
     D cKeyDelete      C                   CONST(X'BD')
      *
     D cKeyEnter       C                   CONST(X'F1')
      *          Nicht definiert                   F2
     D cKeyHelp        C                   CONST(X'F3')
     D cKeyPageDown    C                   CONST(X'F4')
     D cKeyPageUp      C                   CONST(X'F5')
     D cKeyPrintScr    C                   CONST(X'F6')
      *          Nicht definiert                   F7
     D cKeyReset       C                   CONST(X'F8')
      *
     D cKeyLightPen    C                   CONST(X'3F')
      *
     D cSflFold        C                   CONST(*off)
     D cSflDrop        C                   CONST(*on )
      *===============================================================*
      *
      *== Global Constants============================================*
      *
      *  Boolean Constants ...
     D cTrue           C                   const(*on )
     D cFalse          C                   const(*off)
      *
      *  Application Message File ...
     D cAppMsgF        C                   const('CMPMSGF')
     D cAppMsgL        C                   const('*LIBL')
      *
      *  Messages ...
      *  ... to stack counter
     D cMsg_Ext        C                   const(-1)
     D cMsg_Prv        C                   const(-2)
     D cMsg_Same       C                   const(-3)
      *
      *  ... to procedure
     D cMsg_ToMyself   C                   const('*')
     D cMsg_ToPgmBdy   C                   const('*PGMBDY')
     D cMsg_ToCtlBdy   C                   const('*CTLBDY')
     D cMsg_ToPgm      C                   const('*PGMNAME')
      *
     D cMSGID_LOVAL    C                   const(*LOVAL)
     D cMSGID_HIVAL    C                   const(*HIVAL)
     D cMSGID_EOF      C                   const('*EOF')
     D cMSGID_SAME     C                   const('*MSGID')
      *
     D cCmpCopyLeft    C                   const('<=')
     D cCmpCopyRight   C                   const('=>')
     D cCmpEqual       C                   const('==')
     D cCmpNotEqual    C                   const('<>')
     D cCmpNoAction    C                   const('| ')
      *
      *  Others ...
     D cLowDat7        C                   const('0010101')
     D cQuote          C                   const('''')
      *===============================================================*
      *
      *== Templates ==================================================*
     D msg_t         E DS                  extname(xdmsg     ) based(pDummy)
     D                                     prefix(msg_t_     )
     D qobj_t        E DS                  extname(xdqobj    ) based(pDummy)
     D                                     prefix(qobj_t_    )
     D errCode_t     E DS                  extname(xderrcode )  based(pDummy)
     D                                     prefix(errCode_t_ )
     D RTVM0300_t    E DS                  extname(xdrtvm0300)  based(pDummy)
     D                                     prefix(rtvm0300_t_)
     D RTVM0400_t    E DS                  extname(xdrtvm0400)  based(pDummy)
     D                                     prefix(rtvm0400_t_)
      *===============================================================*
      *
      *== Prototypes =================================================*
      *
      *  ... compare message file       (CMPMSGFR1)
     D f_cmpMsgF...
     D                 PR             1A
     D  i_file1                      10A   const
     D  i_lib1                       10A   const
     D  i_file2                      10A   const
     D  i_lib2                       10A   const
     D  i_range                      16A   const
     D  i_cmpDate                     1A   const
     D  i_cmpLvl                      1A   const
     D  i_error                       1A   const
      *
      *  ... change filter              (CMPMSGFR2)
     D f_chgFilter...
     D                 PR             1A
     D  io_cpyr                       1A
     D  io_cpyl                       1A
     D  io_equal                      1A
     D  io_nequal                     1A
      *
      *  ... load module filter         (CMPMSGFR2)
     D p_loadFilter...
     D                 PR
      *
      *  ... unload module filter       (CMPMSGFR2)
     D p_unloadFilter...
     D                 PR
      *
      *  ... remove program messages    (CMPMSGFR3)
     D p_rmvPgmMsg...
     D                 PR
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)
      *
      *  ... send program message       (CMPMSGFR3)
     D p_sndPgmMsg...
     D                 PR
     D  i_msg                              const  like(msg_t     )
     D  i_toStkC                     10I 0 const  options(*NOPASS)
     D  i_toProc                    256A   const  options(*NOPASS)
     D  i_toMod                      10A   const  options(*NOPASS: *OMIT)
     D  i_toPgm                      10A   const  options(*NOPASS)
      *
      *  ... create a new message       (CMPMSGFR3)
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
      *
      *  ... create a new API errorcode (CMPMSGFR3)
     D f_newApiErrCode...
     D                 PR                         like(errCode_t)
     D  i_monMsg                       N   value
      *
      *  ... test for API error         (CMPMSGFR3)
     D f_isApiErr...
     D                 PR              N
     D  i_errCode                          value  like(errCode_t)
      *
      *  ... retrieve network attribute (CMPMSGFR3)
     D f_rtvNetAtrA...
     D                 PR          4096A
     D  i_netAtrName                 10A   value
      *
      *  ... check if object exists     (CMPMSGFR3)
     D f_exist...
     D                 PR              N
     D  i_obj                        10A   value
     D  i_lib                        10A   value
     D  i_objType                    10A   value
      *===============================================================*
      *
      *== external Prototypes ========================================*
      *
      *  ... test omitted argument
     D p_testOmit...
     D                 PR                         extproc('CEETSTA')
     D  o_isPresent                  10I 0
     D  i_argNum                     10I 0 const
     D  o_fc                         12A          options(*omit)
      *
      *  ... Display Command Line Window (QUSCMDLN) API
     D QUSCMDLN...
     D                 PR                  extpgm('QUSCMDLN')
      *
      *  ... Retrieve Message (QMHRTVM) API
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
      *
      *  ... Retrieve Object Description (QUSROBJD) API
     D QUSROBJD...
     D                 PR                  extpgm('QUSROBJD')
     D  i_objD                    32767A         options(*varsize)
     D  i_lenObjD                    10I 0 const
     D  i_format                      8A   const
     D  i_qObj                       20A   const
     D  i_objType                    10A   const
     D  io_errCode                32767A         options(*varsize:
     D                                                   *nopass )
      *
      *  ... system -- Execute a Command
     D system...
     D                 PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
      *
     D EXCP_MSGID      S              7A   import('_EXCP_MSGID')
      *
      *===============================================================*
      *
      *== Program status data structure===============================*
     D sds            SDS
      *  program name
     D  sds_pgmName                  10A
      *  program error status
     D  sds_pgmStat                   5S 0
      *  previous program error status
     D  sds_pPrevStat                 5S 0
      *  last sequence number
     D  sds_lastSeq                   8A
      *  last sub routine
     D  sds_lastSubr                  8A
      *  number of arguments passed to the program
     D  sds_numParm                   3S 0
      *  error message id
     D  sds_msgID                     7A
      *  mi instruction number
     D  sds_miInstr                   4A
      *  work area
     D  sds_workArea                 30A
      *  library
     D  sds_pgmLib                   10A
      *  message text
     D  sds_msgText                  80A
      *  exception indicator
     D  sds_excpInd                   4A
      *  unused
     D  sds_unused1                  16A
      *  date format
     D  sds_datFmt                    8A
      *  *YEAR
     D  sds_year                      2S 0
      *  last file operation
     D  sds_fileOpr                   8A
      *  last file status
     D  sds_fileStat                 35A
      *  job name
     D  sds_job                      10A
      *  user
     D  sds_user                     10A
      *  job number
     D  sds_jobNbr                    6S 0
      *  job date
     D  sds_jobD                      6S 0
      *  program execution date
     D  sds_pgmDate                   6S 0
      *  job time
     D  sds_jobTime                   6S 0
      *  creation date
     D  sds_crtDate                   6A
      *  creation time
     D  sds_crtTime                   6A
      *  compiler version
     D  sds_compVer                   4A
      *  source file
     D  sds_srcFile                  10A
      *  source library
     D  sds_srcLib                   10A
      *  source member i
     D  sds_srcMbr                   10A
      *  program
     D  sds_pgmProc                  10A
      *  module
     D  sds_modProc                  10A
      *  unused t
     D  sds_unused2                  76A
      *===============================================================*
