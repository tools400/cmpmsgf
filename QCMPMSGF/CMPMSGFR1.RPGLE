      * =================================================================== *
      *                                                                     *
      *  Kurzdokumentation :                                                *
      *                                                                     *
      *  Bereich . . . : CMPMSGF                                            *
      *  Objekt  . . . : CMPMSGFR1                                          *
      *  Beschreibung  : Tool: CMPMSGF    (Compare Message File     )       *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Datum . . . . : 25.10.2001                                         *
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
      *  13.11.2001  Th.Raddatz    Fixed problem that the color of $$CD     *
      *                            was not set when $$CD was changed        *
      *                            manually.                                *
      *  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
      *                            "Position to" and added binary search.   *
      *  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
      *                            "Position to" and added binary search.   *
      *  20.12.2001  Th.Raddatz    Added the "Filter" panel.                *
      *  24.12.2001  Th.Raddatz    Added support for the RTVM0400 format    *
      *                            and enhanced compare rules to use        *
      *                            the message creation date/level and      *
      *                            the message modification date/level.     *
      *  14.04.2004  Th.Raddatz    Added addtional options:                 *
      *                               - Copy to  (31/32)                    *
      *                               - Change   (21/22)                    *
      *                               - Delete   (41/42)                    *
      *                               - Display  (51/52)                    *
      *  15.04.2004  Th.Raddatz    Added addtional command keys:            *
      *                               - Display Command Line Window (F21)   *
      *  08.06.2005  Th.Raddatz    Fixed bug that the color of field "Cd"   *
      *                            was not set properly on change.          *
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
     FCMPMSGFD1 CF   E             WORKSTN usropn
     F                                     infds(Screen)
     F                                     indds(workstn)
     F                                     sfile(SFL:SFLRRN)
      *
     D workstn         DS
      *
     D  workstn_cd_white...
     D                        50     50N
     D  workstn_cd_grn...
     D                        51     51N
     D  workstn_cd_ylw...
     D                        52     52N
     D  workstn_cd_red...
     D                        53     53N
      *
     D  workstn_msgf1_pc...
     D                        61     61N
     D  workstn_lib1_pc...
     D                        62     62N
     D  workstn_msgf2_pc...
     D                        65     65N
     D  workstn_lib2_pc...
     D                        66     66N
      *
     D  workstn_msgf1_ri...
     D                        71     71N
     D  workstn_lib1_ri...
     D                        72     72N
     D  workstn_msgf2_ri...
     D                        75     75N
     D  workstn_lib2_ri...
     D                        76     76N
      *
     D  workstn_sfldsp...
     D                        80     80N
     D  workstn_sfldspctl...
     D                        81     81N
     D  workstn_sflclr...
     D                        82     82N
     D  workstn_sflend...
     D                        83     83N
     D  workstn_sflmode...
     D                        84     84N
     D  workstn_sflnxtchg...
     D                        85     85N
     D  workstn_opt_ri...
     D                        86     86N
     D  workstn_posto_ri...
     D                        87     87N
     D  workstn_find_ri...
     D                        88     88N
     D  workstn_msgsflend...
     D                        89     89N
     D  workstn_options_1...
     D                        91     91N
     D  workstn_options_2...
     D                        92     92N
     D  workstn_options_3...
     D                        93     93N
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
      *  ... end program
     D cmd_endPgm...
     D                 PR              N
      *
      *  ... refresh screen
     D cmd_refresh...
     D                 PR
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      *
      *  ... process
     D cmd_process...
     D                 PR              N
     D  o_msg                                     like(msg_t     )
      *
      *  ... goto top of subfile
     D cmd_gotoTop...
     D                 PR
      *
      *  ... goto botton of subfile
     D cmd_gotoBot...
     D                 PR
      *
      *  ... show more cmd keys
     D cmd_moreKeys...
     D                 PR
      *
      *  ... show more options
     D cmd_moreOptions...
     D                 PR
      *
      *  ... command line
     D cmd_cmdLine...
     D                 PR
      *
      *  ... process enter key
     D cmd_enter...
     D                 PR              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      *
      *  ... page up
     D cmd_pageUp...
     D                 PR
      *
      *  ... page down
     D cmd_pageDown...
     D                 PR
      *
      *  ... validate screen
     D f_validateScreen...
     D                 PR              N
      *
      *  ... read changed records
     D f_sflReadChg...
     D                 PR              N
      *
      *  ... check if there are changed records
     D f_sflChkChg...
     D                 PR              N
     D  o_sflRrn                     10I 0        options(*nopass)
      *
      *  ... initialize subfile
     D p_sflInit...
     D                 PR
      *
      *  ... position file pointer and read first record
     D p_sflPosKey...
     D                 PR              N
     D  i_lowerMsgID                  7A   value
      *
      *  ... read next record
     D f_sflReadRcd...
     D                 PR              N
      *
      *  ... load page into subfile
     D f_sflLoadPage...
     D                 PR              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      *
      *  ... clear selection
     D p_sflClrSlc...
     D                 PR
     D  i_sflRrn                     10I 0 const
      *
      *  ... set error status
     D p_sflsetErr...
     D                 PR
     D  i_sflRrn                     10I 0 const
      *
      *  ... clear subfile/screen indicators
     D p_sflClrInd...
     D                 PR
      *
      *  ... position to
     D p_sflPosTo...
     D                 PR
     D  i_posTo                            value  like(##POSTO   )
      *
      *  ... get first message id
     D f_getFirstMsgID...
     D                 PR              N
     D  i_msgId                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msgID                       7A
      *
      *  ... retrieve message text
     D f_rtvMsgText...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  ... retrieve message help
     D f_rtvMsgHelp...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  ... retrieve replacement variables
     D f_rtvRplVars...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  ... open message file 1
     D p_openMsgF1...
     D                 PR
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... open message file 2
     D p_openMsgF2...
     D                 PR
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... close message file 1
     D p_closeMsgF1...
     D                 PR
      *
      *  ... close message file 2
     D p_closeMsgF2...
     D                 PR
      *
      *  ... is message file 1 open?
     D f_isOpenMsgF1...
     D                 PR              N
      *
      *  ... is message file 2 open?
     D f_isOpenMsgF2...
     D                 PR              N
      *
      *  ... get message file library
     D f_getMsgFLib...
     D                 PR            10A
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... check if message file exists
     D f_chkMsgF...
     D                 PR              N
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msg                                     like(msg_t     )
      *
      *  ... change subfile action code
     D p_sflChgCode...
     D                 PR
     D  i_rrn                        10I 0 value
     D  i_newCode                          value  like($$CD)
      *
      *  ... subfile add message ID
     D f_sflAddMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  ... subfile change message ID
     D f_sflChgMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  ... subfile delete message ID
     D f_sflDltMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  ... subfile display message ID
     D f_sflDspMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  ... add message id
     D f_addMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  i_baseMsgF                   10A   value
     D  i_baseLib                    10A   value
      *
      *  ... change message id
     D f_changeMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... delete message id
     D f_deleteMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... display message id
     D f_displayMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  ... copy message id
     D f_copyMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_fromMsgF                   10A   value
     D  i_fromLib                    10A   value
     D  i_toMsgF                     10A   value
     D  i_toLib                      10A   value
      *
      *  ... fill subfile record
     D p_sflFilRcd...
     D                 PR
     D  i_rtvm0400_1                       value  likeds(RTVM0400_t)
     D  i_rtvm0400_2                       value  likeds(RTVM0400_t)
      *
      *  ... set action code color attribute
     D p_sflSetCdColor...
     D                 PR
     D  i_cd                               value  like($$CD      )
      *
      *  ... refresh subfile record
     D p_sflRfrRcd...
     D                 PR
     D  i_rrn                        10I 0 value
      *
      *  ... retrieve message description format RTVM0400
     D f_rtvMsgD...
     D                 PR                  likeds(RTVM0400_t)
     D  i_msgId                       7A   value
     D  i_qMsgF                            value like(qobj_t)
     D  i_rtvOpt                     10A   value
     D  o_errCode                          value likeds(errCode_t)
      *
      *  ... create an new (empty) RTVM0300 format
     D f_newRtvm0300...
     D                 PR                  likeds(RTVM0300_t)
      *
      *  ... create an new (empty) RTVM0400 format
     D f_newRtvm0400...
     D                 PR                  likeds(RTVM0400_t)
      *
      *  ... convert string to lower case
     D f_toLower...
     D                 PR          1024A           varying
     D  i_string                   1024A   const   varying
      *
     D f_rtvCmdValues...
     D                 PR          8192A          varying
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *===============================================================*
      *
      *== Global fields ==============================================*
      *    g_sflPage = SFLPAG *  number of unfolded lines per entry
      *    g_sflPage =    5   *    2
    R *g_sflPage       S             10I 0 inz(10)
     D g_sflPage       S             10I 0 inz(*hival)
      *    show options
     D g_sflOpt        S             10I 0 inz(1)
     D g_sflNumOpt     S             10I 0 inz(3)
      *    show footer
     D g_sflBot        S             10I 0 inz(1)
     D g_sflNumBot     S             10I 0 inz(2)
      *    subfile control
     D g_sflNumRcd     S             10I 0 inz
     D g_sflMaxRcd     S             10I 0 inz(9999)
      *
      *    format name
     D g_fmtName       S              8A   inz('RTVM0400')
      *
      *    filter options
     D g_filterCpyR    S              1A   inz
     D g_filterCpyL    S              1A   inz
     D g_filterEqual   S              1A   inz
     D g_filterNEqual  S              1A   inz
      *
      *    compare options
     D g_cmpDate       S              1A   inz
     D g_cmpLvl        S              1A   inz
      *
      *    find string
     D g_find          S           1024A   varying inz
      *
      *  Message Description IO (Open Data Paths)
     D g_RTVM0400_1    DS                  likeds(rtvm0400_t) inz
     D g_RTVM0400_2    DS                  likeds(rtvm0400_t) inz
      *
     D g_qMsgF_1       DS                  likeds(qObj_t) inz
     D g_qMsgF_2       DS                  likeds(qObj_t) inz
      *
     D g_msgId_1       S              7A   inz(cMSGID_HIVAL)
     D g_msgId_2       S              7A   inz(cMSGID_HIVAL)
      *
     D g_rtvOpt_1      S             10A   inz(cMSGID_EOF  )
     D g_rtvOpt_2      S             10A   inz(cMSGID_EOF  )
      *
      *===============================================================*
      *
      *===============================================================*
      *   Main procedure (with local variables)
      *===============================================================*
      *
     P f_cmpMsgF...
     P                 B                   export
      *
     D f_cmpMsgF...
     D                 PI             1A
     D  i_file1                      10A   const
     D  i_lib1                       10A   const
     D  i_file2                      10A   const
     D  i_lib2                       10A   const
     D  i_range                      16A   const
     D  i_cmpDate                     1A   const
     D  i_cmpLvl                      1A   const
     D  i_error                       1A   const
      *
      *  Return value
     D rtnKey          S              1A   inz
      *
      *  Fields
     D isDone          S               N   inz
     D msg             DS                  likeds(msg_t) inz
     D isConfirmed_F9  S               N   inz
      *
     D range           DS
     D  range_numVal                  5I 0 inz
     D  range_lower                   7A   inz
     D  range_upper                   7A   inz
      *
     D msgID1          S              7A   inz
     D msgID2          S              7A   inz
      *
      /COPY QCMPMSGF,USR0017
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Set range selection for "*ALL"
     C                   Eval      range = i_range
     C                   If        range_lower = '*ALL'
     C                   Eval      range_lower = '*FIRST'
     C                   Eval      range_upper = '*LAST'
     C                   Endif
      *
      *  Validate range selection
     C                   If        (%subst(range_lower: 1: 1) <> '*' )  and
     C                             (%subst(range_upper: 1: 1) <> '*' )  and
     C                             (range_lower > range_upper        )
     C                   Eval      msg = f_newMsg('USR0018'  :
     C                                            ''         :
     C                                            '*ESCAPE'  )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Prv      :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *
      *  Set screen fields
     C                   Eval      ##MSGF1  = i_file1
     C                   Eval      ##LIB1   = i_lib1
     C                   Eval      ##MSGF2  = i_file2
     C                   Eval      ##LIB2   = i_lib2
     C                   Eval      ##POSTO = ''
     C                   Eval      ##FIND  = ''
      *
     C                   Callp     f_validateScreen
      *
      *  Display local location name
     C                   Eval      $$SYSTEM = f_rtvNetAtrA('LCLLOCNAME')
      *
      *  Set filter options
     C                   If        i_error = 'Y'
     C                   Eval      g_filterCpyR   = 'Y'
     C                   Eval      g_filterCpyL   = 'Y'
     C                   Eval      g_filterEqual  = 'N'
     C                   Eval      g_filterNEqual = 'Y'
     C                   Else
     C                   Eval      g_filterCpyR   = 'Y'
     C                   Eval      g_filterCpyL   = 'Y'
     C                   Eval      g_filterEqual  = 'Y'
     C                   Eval      g_filterNEqual = 'Y'
     C                   Endif
      *
      *  Set compare options
     C                   Eval      g_cmpDate = i_cmpDate
     C                   Eval      g_cmpLvl  = i_cmpLvl
      *
      *  Open files and initialize "filter" module
     C                   Callp     p_openMsgF1(##MSGF1: ##LIB1)
     C                   Callp     p_openMsgF2(##MSGF2: ##LIB2)
      *
     C                   Open      CMPMSGFD1
     C                   Callp     p_loadFilter
      *
      *  Initialize MsgQ Name
      ***                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
     C                   Eval      PGMQ = '_CL_PEP'
      *
      *  Remove program messages
     C                   Callp     p_rmvPgmMsg(cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
      *  Set initial subfile mode
     C                   Eval      SFLMODE = cSflDrop
      *
      *  Clear indicators
     C                   Callp     p_sflClrInd
      *
      *  Initial load of subfile
     C                   Callp     cmd_refresh(range_lower :
     C                                         range_upper )
      *
      *  Loop until no more changes
     C                   Eval      isDOne = cFalse
      *
     C                   Dou       isDone
      *
      *  Set subfile mode
     C                   Eval      workstn_sflmode = SFLMODE
      *
      *  Display messages
     C                   Eval      workstn_msgsflend = cFalse
     C                   Write     MSGCTL
      *
      *  Display "no entries found"
     C                   If        not workstn_sfldsp
     C                   Write     EMPTY
     C                   Endif
      *
      *  Display options
     C                   Eval      workstn_options_1 = cFalse
     C                   Eval      workstn_options_2 = cFalse
     C                   Eval      workstn_options_3 = cFalse
      *
     C                   Select
     C                   When      g_sflOpt = 2
     C                   Eval      workstn_options_2 = cTrue
     C                   When      g_sflOpt = 3
     C                   Eval      workstn_options_3 = cTrue
     C                   Other
     C                   Eval      workstn_options_1 = cTrue
     C                   Endsl
      *
      *  Display command keys
     C                   Select
     C                   When      g_sflBot = 2
     C                   Write     BOT#2
     C                   Other
     C                   Eval      g_sflBot = 1
     C                   Write     BOT#1
     C                   Endsl
      *
      *  Display subfile
     C                   Exfmt     CTL
      *
      *  Clear indicators
     C                   Callp     p_sflClrInd
      *
      *  Remove messages
     C                   Callp     p_rmvPgmMsg(cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
      *  Keep subfile position
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLRCDNBR = SFLCSRRRN
     C                   Endif
      *
      *  Reset confirmation of F9 (Process)
     C                   If        screen_AID <> cKeyF9
     C                   Eval      isConfirmed_F9 = cFalse
     C                   Endif
      *
      *  Process command key ...
     C                   Select
      *  ... F3  - End program
     C                   When      screen_AID = cKeyF3
     C                   Eval      isDone = cmd_endPgm
      *  ... F5  - Refresh screen
     C                   When      screen_AID = cKeyF5
     C                   Callp     cmd_refresh(range_lower :
     C                                         range_upper )
      *
      *  ... F9  - Process
     C                   When      screen_AID = cKeyF9
     C                   If        isConfirmed_F9
     C                   If        not cmd_process(msg)
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
     C                   Eval      isConfirmed_F9 = cFalse
     C                   Else
     C                   Clear                   USR0017
     C                   Eval      USR00171 = 'F9'
     C                   Eval      msg = f_newMsg('USR0017' :
     C                                            USR0017   )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      isConfirmed_F9 = cTrue
     C                   Endif
      *
     C                   Eval      isDOne = cFalse
      *
      *  ... F12 - End program
     C                   When      screen_AID = cKeyF12
     C                   Eval      isDone = cmd_endPgm
      *
      *  ... F17 - Goto top of subfile
     C                   When      screen_AID = cKeyF17
     C                   Callp     cmd_gotoTop
      *
      *  ... F18 - Goto end of subfile
     C                   When      screen_AID = cKeyF18
     C                   Callp     cmd_gotoBot
      *
      *  ... F19 - Change Filter
     C                   When      screen_AID = cKeyF19
     C                   If        f_chgFilter(g_filterCpyR   :
     C                                         g_filterCpyL   :
     C                                         g_filterEqual  :
     C                                         g_filterNEqual ) = cKeyEnter
     C                   Callp     cmd_refresh(range_lower :
     C                                         range_upper )
     C                   Endif
      *
      *  ... F21 - Command line
     C                   When      screen_AID = cKeyF21
     C                   Callp     cmd_cmdLine
      *
      *  ... F23 - More options
     C                   When      screen_AID = cKeyF23
     C                   Callp     cmd_moreOptions
      *
      *  ... F24 - More keys
     C                   When      screen_AID = cKeyF24
     C                   Callp     cmd_moreKeys
      *
      *  ... ENTER
     C                   When      screen_AID = cKeyEnter
     C                   Eval      isDone = cmd_enter(range_lower :
     C                                                range_upper )
      *
      *  ... Page up
     C                   When      screen_AID = cKeyPageUp
     C                   Callp     cmd_pageUp
      *
      *  ... Page down
     C                   When      screen_AID = cKeyPageDown
     C                   Callp     cmd_pageDown
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
      *  Close files
     C                   Close     CMPMSGFD1
     C                   Callp     p_unloadFilter
      *
     C                   Callp     p_closeMsgF1
     C                   Callp     p_closeMsgF2
      *
      *  Pass back last key stroke
     C                   Eval      rtnKey = screen_AID
      *
     C                   Return    rtnKey
      *
     P f_cmpMsgF...
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
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      ##MSGF1 = g_qMsgF_1.name
     C                   Eval      ##LIB1  = g_qMsgF_1.lib
      *
     C                   Eval      ##MSGF2 = g_qMsgF_2.name
     C                   Eval      ##LIB2  = g_qMsgF_2.lib
      *
     C                   Callp     p_sflInit
      *
     C                   If        p_sflPosKey(i_lowerMsgID)
     C                   Callp     f_sflLoadPage(i_lowerMsgID: i_upperMsgID)
     C                   Endif
      *
     C                   Return
      *
     P cmd_refresh...
     P                 E
      *
      *===============================================================*
      *  cmd_process
      *===============================================================*
      *
     P cmd_process...
     P                 B
      *
     D cmd_process...
     D                 PI              N
     D  o_msg                                     like(msg_t     )
      *
      *  Return Value
     D isOK            S               N   inz
      *
      *  Local fields
     D rrn             S             10I 0 inz
      *
      /COPY QCMPMSGF,USR0016
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      isOK = cTrue
      *
     C                   If        not workstn_sfldsp
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Loop through the subfile
     C                   For       rrn = 1 to g_sflNumRcd
     C     rrn           Chain     SFL
      *
     C                   Select
      *
      *  Copy to the right side
     C                   When      $$CD = cCmpCopyRight
     C                   If        not f_copyMsgID($$MSGID:
     C                                             ##MSGF1: ##LIB1:
     C                                             ##MSGF2: ##LIB2)
     C                   Clear                   USR0016
     C                   Eval      USR00161 = $$MSGID
     C                   Eval      o_msg = f_newMsg('USR0016' :
     C                                              USR0016   )
     C                   Callp     p_sflSetErr(SFLRRN)
     C                   Eval      isOK = cFalse
     C                   Leave
     C                   Else
     C                   Callp     p_sflRfrRcd(rrn)
     C                   Endif
      *
      *  Copy to the left side
     C                   When      $$CD = cCmpCopyLeft
     C                   If        not f_copyMsgID($$MSGID:
     C                                             ##MSGF2: ##LIB2:
     C                                             ##MSGF1: ##LIB1)
     C                   Clear                   USR0016
     C                   Eval      USR00161 = $$MSGID
     C                   Eval      o_msg = f_newMsg('USR0016' :
     C                                              USR0016   )
     C                   Callp     p_sflSetErr(SFLRRN)
     C                   Eval      isOK = cFalse
     C                   Leave
     C                   Else
     C                   Callp     p_sflRfrRcd(rrn)
     C                   Endif
      *
      *  Ignore other Codes
     C                   Other
     C                   Iter
     C                   Endsl
      *
     C                   Endfor                                                              R
      *
     C     exitProcedure Tag
      *
     C                   Return    isOK
      *
     P cmd_process...
     P                 E
      *
      *===============================================================*
      *  cmd_gotoTop
      *===============================================================*
      *
     P cmd_gotoTop...
     P                 B
      *
     D cmd_gotoTop...
     D                 PI
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not workstn_sfldsp
      *
     C                   Eval      msg = f_newMsg('USR0007')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
     C                   Else
     C                   Eval      SFLRCDNBR = 1
     C                   Endif
      *
     C                   Return
      *
     P cmd_gotoTop...
     P                 E
      *
      *===============================================================*
      *  cmd_gotoBot
      *===============================================================*
      *
     P cmd_gotoBot...
     P                 B
      *
     D cmd_gotoBot...
     D                 PI
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not workstn_sfldsp
      *
     C                   Eval      msg = f_newMsg('USR0007')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
     C                   Else
     C                   Eval      SFLRCDNBR = g_sflNumRcd
     C                   Endif
      *
     C                   Return
      *
     P cmd_gotoBot...
     P                 E
      *
      *===============================================================*
      *  cmd_moreKeys
      *===============================================================*
      *
     P cmd_moreKeys...
     P                 B
      *
     D cmd_moreKeys...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        g_sflBot < g_sflNumBot
     C                   Eval      g_sflBot = g_sflBot + 1
     C                   Else
     C                   Eval      g_sflBot = 1
     C                   Endif
      *
     C                   Return
      *
     P cmd_moreKeys...
     P                 E
      *
      *===============================================================*
      *  cmd_cmdLine
      *===============================================================*
      *
     P cmd_cmdLine...
     P                 B
      *
     D cmd_cmdLine...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Callp     QUSCMDLN
      *
     C                   Return
      *
     P cmd_cmdLine...
     P                 E
      *
      *===============================================================*
      *  cmd_moreOptions
      *===============================================================*
      *
     P cmd_moreOptions...
     P                 B
      *
     D cmd_moreOptions...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        g_sflOpt < g_sflNumOpt
     C                   Eval      g_sflOpt = g_sflOpt + 1
     C                   Else
     C                   Eval      g_sflOpt = 1
     C                   Endif
      *
     C                   Return
      *
     P cmd_moreOptions...
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
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      *
      *  Return value
     D isDone          S               N   inz
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
     D rrn             S             10I 0 inz
     D isSflDirty      S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      isSflDirty = cFalse
     C                   Eval      isDone     = cTrue
      *
      *  Validate screen ...
     C                   If        not f_validateScreen
     C                   Eval      isDone     = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Process MsgF 1 fields ...
     C                   If        (##MSGF1 <> g_qMsgF_1.name)  or
     C                             (##LIB1  <> g_qMsgF_1.lib )
      *
     C                   Eval      isSflDirty = cTrue
      *
     C                   If        f_isOpenMsgF1
     C                   Callp     p_closeMsgF1
     C                   Endif
     C                   Callp     p_openMsgF1(##MSGF1: ##LIB1)
      *
     C                   Endif
      *
      *  Process MsgF 2 fields ...
     C                   If        (##MSGF2 <> g_qMsgF_2.name)  or
     C                             (##LIB2  <> g_qMsgF_2.lib )
      *
     C                   Eval      isSflDirty = cTrue
      *
     C                   If        f_isOpenMsgF2
     C                   Callp     p_closeMsgF2
     C                   Endif
     C                   Callp     p_openMsgF2(##MSGF2: ##LIB2)
      *
     C                   Endif
      *
      *  Find string ...
     C                   If        f_toLower(##FIND) <> g_find
     C                   Eval      isDone     = cFalse
     C                   Eval      isSflDirty = cTrue
     C                   Eval      g_find     = %trimR(f_toLower(##FIND))
     C                   Endif
      *
      *  Refresh subfile if necessary ...
     C                   If        isSflDirty
     C                   Callp     cmd_refresh(i_lowerMsgID :
     C                                         i_upperMsgID )
     C                   Eval      isDone  = cFalse
     C                   Endif
      *
      *  Position to ...
     C                   If        ##POSTO <> ' '
     C                   Callp     p_sflPosTo(##POSTO)
     C                   Eval      ##POSTO = ''
     C                   Eval      isDone  = cFalse
     C                   Endif
      *
      *  Process changed records
     C                   If        f_sflReadChg
     C                   Eval      isDone = cFalse
     C                   Endif
      *
     C     exitProcedure Tag
      *
     C                   Return    isDone
      *
     P cmd_enter...
     P                 E
      *
      *===============================================================*
      *  cmd_pageUp
      *===============================================================*
      *
     P cmd_pageUp...
     P                 B
      *
     D cmd_pageUp...
     D                 PI
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not workstn_sfldsp
     C                   Eval      msg = f_newMsg('USR0007')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
     C                   Else
     C                   Eval      msg = f_newMsg('USR0005')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *
     C                   Return
      *
     P cmd_pageUp...
     P                 E
      *
      *===============================================================*
      *  cmd_pageDown
      *===============================================================*
      *
     P cmd_pageDown...
     P                 B
      *
     D cmd_pageDown...
     D                 PI
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not workstn_sfldsp
     C                   Eval      msg = f_newMsg('USR0007')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
      *
     C                   Else
     C                   Eval      msg = f_newMsg('USR0003')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *
     C                   Return
      *
     P cmd_pageDown...
     P                 E
      *
      *===============================================================*
      *  Validate Screen.
      *===============================================================*
      *
     P f_validateScreen...
     P                 B
      *
     D f_validateScreen...
     D                 PI              N
      *
      *  Return value
     D isOK            S               N   inz
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Message file 1
     C                   If        not f_chkMsgF(##MSGF1: ##LIB1: msg)
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_msgF1_pc = *on
     C                   Eval      workstn_msgF1_ri = *on
     C                   Eval      workstn_lib1_pc  = *on
     C                   Eval      workstn_lib1_ri  = *on
     C                   Eval      isOK = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Message file 2
     C                   If        not f_chkMsgF(##MSGF2: ##LIB2: msg)
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      workstn_msgF2_pc = *on
     C                   Eval      workstn_msgF2_ri = *on
     C                   Eval      workstn_lib2_pc  = *on
     C                   Eval      workstn_lib2_ri  = *on
     C                   Eval      isOK = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  User should enter different message files
     C                   If        (##MSGF1 = ##MSGF2)  and
     C                             (##LIB1  = ##LIB2 )
     C                   Eval      msg = f_newMsg('USR0010')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Eval      isOK = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
     C                   Eval      isOK = cTrue
      *
     C     exitProcedure Tag
      *
     C                   Return    isOK
      *
     P f_validateScreen...
     P                 E
      *
      *===============================================================*
      *  f_sflReadChg
      *===============================================================*
      *
     P f_sflReadChg...
     P                 B
      *
     D f_sflReadChg...
     D                 PI              N
      *
      *  Return value
     D isChanged       S               N   inz
      *
      *  Local fields
     D msg             DS                  likeds(msg_t) inz
     D sflError        S               N   inz
      *
      *  Message data structures
      /COPY QCMPMSGF,USR0006
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        not workstn_sfldsp
     C                   Eval      isChanged = cFalse
     C                   Goto      exitProcedure
     C                   Endif
      *
      *  Loop through the subfile
     C                   Eval      isChanged = cFalse
     C                   Eval      sflError  = cFalse
      *
     C                   Dou       sflError
     C                   Readc     SFL
     C                   If        %EOF(CMPMSGFD1)
     C                   Leave
     C                   Endif
      *
     C                   Eval      isChanged = cTrue
      *
      *  Remember last record processed
     C                   Eval      SFLRCDNBR = SFLRRN
      *
      *  Process user option ...
     C                   Eval      ##OPT = %trim(##OPT)
      *  ... no option
     C                   Select
     C                   When      ##OPT = ''
      *  ... "Copy to left"
     C                   When      ##OPT = 'L'
     C                   If        H_MSGID2 <> ''
     C                   Callp     p_sflChgCode(SFLRRN: cCmpCopyLeft)
     C                   Else
     C                   Callp     p_sflChgCode(SFLRRN: cCmpNoAction)
     C                   Endif
      *  ... "Copy to right"
     C                   When      ##OPT = 'R'
     C                   If        H_MSGID1 <> ''
     C                   Callp     p_sflChgCode(SFLRRN: cCmpCopyRight)
     C                   Else
     C                   Callp     p_sflChgCode(SFLRRN: cCmpNoAction)
     C                   Endif
      *  ... "No Action"
     C                   When      ##OPT = 'N'
     C                   Callp     p_sflChgCode(SFLRRN: cCmpNoAction)
      *  ... "Change left"
     C                   When      ##OPT = '21'
     C                   Eval      sflError = not f_sflChgMsgID(SFLRRN: 'L')
      *  ... "Copy to left"
     C                   When      ##OPT = '31'
     C                   Eval      sflError = not f_sflAddMsgID(SFLRRN: 'L')
      *  ... "Delete left"
     C                   When      ##OPT = '41'
     C                   Eval      sflError = not f_sflDltMsgID(SFLRRN: 'L')
      *  ... "Display left"
     C                   When      ##OPT = '51'
     C                   Eval      sflError = not f_sflDspMsgID(SFLRRN: 'L')
      *  ... "Change right"
     C                   When      ##OPT = '22'
     C                   Eval      sflError = not f_sflChgMsgID(SFLRRN: 'R')
      *  ... "Copy to right"
     C                   When      ##OPT = '32'
     C                   Eval      sflError = not f_sflAddMsgID(SFLRRN: 'R')
      *  ... "Delete right"
     C                   When      ##OPT = '42'
     C                   Eval      sflError = not f_sflDltMsgID(SFLRRN: 'R')
      *  ... "Display right"
     C                   When      ##OPT = '52'
     C                   Eval      sflError = not f_sflDspMsgID(SFLRRN: 'R')
      *  ... invalid option
     C                   Other
     C                   Eval      workstn_opt_ri = cTrue
     C                   Eval      sflError = cTrue
      *
     C                   Clear                   USR0006
     C                   Eval      USR00061 = ##OPT
     C                   Eval      msg = f_newMsg('USR0006': USR0006)
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endsl
      *
      *  Update subfile record
     C                   If        sflError
     C                   Callp     p_sflSetErr(SFLRRN)
     C                   Else
     C                   Callp     p_sflClrSlc(SFLRRN)
     C                   Endif
      *
     C                   Enddo
      *
     C     exitProcedure Tag
      *
     C                   Return    isChanged
      *
     P f_sflReadChg...
     P                 E
      *
      *===============================================================*
      *  f_sflChkChg
      *===============================================================*
      *
     P f_sflChkChg...
     P                 B
      *
     D f_sflChkChg...
     D                 PI              N
     D o_sflRrn                      10I 0 options(*nopass)
      *
      *  Return value
     D isChanged       S               N   inz
      *
      *  Parameter positions
     D p_sflRrn        C                   const(1)
      *
      *  *  Local fields
     D rrn             S                   like(o_sflRrn  )        inz
     D sfldsp          S                   like(workstn_sfldsp   ) inz
     D sfldspctl       S                   like(workstn_sfldspctl) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  If there are no records in the subfile ...
     C                   If        not workstn_sfldsp
      *  ... then
      *      return "no chnages"
     C                   Eval      isChanged = cFalse
     C                   Eval      rrn       = 0
     C                   Else
      *  ... else
      *      search for a selection <> ' '
     C                   Dou       (##OPT <> ''    )  or
     C                             (%EOF(CMPMSGFD1))
     C                   Readc     SFL
     C                   If        ##OPT = ''
     C                   Callp     p_sflClrSlc(SFLRRN)
     C                   Endif
     C                   Enddo
      *      If no selection was found ...
     C                   If        %EOF(CMPMSGFD1)
      *      ... then
      *          return "no changes"
     C                   Eval      isChanged = cFalse
     C                   Eval      rrn       = 0
     C                   Else
      *      ... else
      *          return "changes!"
     C                   Eval      isChanged = cTrue
     C                   Eval      rrn       = SFLRRN
      *
      *          and re-activate subfile record
     C                   Eval      workstn_sflnxtchg = cTrue
     C                   Update    SFL
      *
     C                   Eval      sfldsp    = workstn_sfldsp
     C                   Eval      sfldspctl = workstn_sfldspctl
      *
     C                   Eval      workstn_sfldsp    = cTrue
     C                   Eval      workstn_sfldspctl = cFalse
     C                   WRITE     CTL
     C                   Eval      workstn_sfldsp    = sfldsp
     C                   Eval      workstn_sfldspctl = sfldspctl
      *
     C                   Endif
     C                   Endif
      *
      *  Return RRN if passed
     C                   If        %parms >= p_sflRrn
     C                   Eval      o_sflRrn = rrn
     C                   Endif
      *
     C                   Return    isChanged
      *
     P f_sflChkChg...
     P                 E
      *
      *===============================================================*
      *  p_sflInit
      *===============================================================*
      *
     P p_sflInit...
     P                 B
      *
     D p_sflInit...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      workstn_sfldsp    = cFalse
     C                   Eval      workstn_sfldspctl = cFalse
     C                   Eval      workstn_sflclr    = cTrue
     C                   Eval      workstn_sflend    = cFalse
     C                   WRITE     CTL
      *
     C                   Eval      workstn_sfldspctl = cTrue
     C                   Eval      workstn_sflclr    = cFalse
      *
     C                   Reset                   g_sflPage
     C                   Reset                   g_sflBot
     C                   Reset                   g_sflNumBot
     C                   Reset                   g_sflNumRcd
      *
     C                   Return
      *
     P p_sflInit...
     P                 E
      *
      *===============================================================*
      *  sflPosKey
      *===============================================================*
      *
     P p_sflPosKey...
     P                 B
      *
     D p_sflPosKey...
     D                 PI              N
     D  i_lowerMsgID                  7A   value
      *
      *  Return value
     D isFound         S               N   inz(cFalse)
      *
      *  Fields
     D msgID           S              7A   inz
     D rtvOpt          S             10A   inz
      *
     D errCode         DS                  likeds(errCode_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Callp     f_getFirstMsgID(i_lowerMsgID :
     C                                             ##MSGF1      :
     C                                             ##LIB1       :
     C                                             g_msgId_1    )
     C                   Eval      g_rtvOpt_1 = cMSGID_SAME
      *
     C                   Callp     f_getFirstMsgID(i_lowerMsgID :
     C                                             ##MSGF2      :
     C                                             ##LIB2       :
     C                                             g_msgId_2    )
     C                   Eval      g_rtvOpt_2 = cMSGID_SAME
      *
      *  Position file Pointer ...
     C                   Dou       (g_rtvm0400_1.msgId >= ' ')  or
     C                             (g_rtvm0400_2.msgId >= ' ')
     C                   Eval      isFound    = f_sflReadRcd
     C                   If        not isFound
     C                   Leave
     C                   Endif
     C                   Enddo
      *
     C                   Return    isFound
      *
     P p_sflPosKey...
     P                 E
      *
      *===============================================================*
      *  sflReadRcd
      *===============================================================*
      *
     P f_sflReadRcd...
     P                 B
      *
     D f_sflReadRcd...
     D                 PI              N
      *
      *  Return value
     D isFound         S               N   inz(cFalse)
      *
      *  Fields
     D errCode_1       DS                  likeds(errCode_t) inz
     D errCode_2       DS                  likeds(errCode_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      errCode_1 = f_newApiErrCode(cTrue)
      *
      *  Retrieve message description of 1. file
     C                   If        g_rtvOpt_1 <> cMSGID_EOF
     C                   Eval      g_RTVM0400_1 = f_rtvMsgD(g_msgId_1  :
     C                                                      g_qMsgF_1  :
     C                                                      g_rtvOpt_1 :
     C                                                      errCode_1  )
      *
     C                   If        (f_isApiErr(errCode_1)  )  or
     C                             (g_rtvm0400_1.bytAvl = 0)
     C                   Eval      g_msgId_1  = cMSGID_HIVAL
     C                   Eval      g_rtvOpt_1 = cMSGID_EOF
     C                   Eval      g_RTVM0400_1 = f_newRtvm0400
     C                   Else
     C                   Eval      g_msgId_1  = g_rtvm0400_1.msgID
     C                   Eval      g_rtvOpt_1 = '*NEXT'
     C                   Endif
     C                   Endif
      *
     C                   Eval      errCode_2 = f_newApiErrCode(cTrue)
      *
      *  Retrieve message description of 2. file
     C                   If        g_rtvOpt_2 <> cMSGID_EOF
     C                   Eval      g_RTVM0400_2 = f_rtvMsgD(g_msgId_2  :
     C                                                      g_qMsgF_2  :
     C                                                      g_rtvOpt_2 :
     C                                                      errCode_2  )
      *
     C                   If        (f_isApiErr(errCode_2)  )  or
     C                             (g_rtvm0400_2.bytAvl = 0)
     C                   Eval      g_msgId_2  = cMSGID_HIVAL
     C                   Eval      g_rtvOpt_2 = cMSGID_EOF
     C                   Eval      g_RTVM0400_2 = f_newRtvm0400
     C                   Else
     C                   Eval      g_msgId_2  = g_rtvm0400_2.msgID
     C                   Eval      g_rtvOpt_2 = '*NEXT'
     C                   Endif
     C                   Endif
      *
      *  File 1 has to wait for file 2
     C                   If        g_msgId_1 > g_msgId_2
     C                   If        g_rtvOpt_1 <> cMSGID_EOF
     C                   Eval      g_rtvOpt_1 = cMSGID_SAME
     C                   Eval      g_RTVM0400_1 = f_newRtvm0400
     C                   Endif
     C                   Endif
      *
      *  File 2 has to wait for file 1
     C                   If        g_msgId_1 < g_msgId_2
     C                   If        g_rtvOpt_2 <> cMSGID_EOF
     C                   Eval      g_rtvOpt_2 = cMSGID_SAME
     C                   Eval      g_RTVM0400_2 = f_newRtvm0400
     C                   Endif
     C                   Endif
      *
     C                   If        (g_rtvOpt_1 <> cMSGID_EOF)  or
     C                             (g_rtvOpt_2 <> cMSGID_EOF)
     C                   Eval      isFound    = cTrue
     C                   Else
     C                   Eval      isFound    = cFalse
     C                   Endif
      *
     C                   Return    isFound
      *
     P f_sflReadRcd...
     P                 E
      *
      *===============================================================*
      *  sflLoadPage
      *===============================================================*
      *
     P f_sflLoadPage...
     P                 B
      *
     D f_sflLoadPage...
     D                 PI              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
      *
      *  Return value
     D isFound         S               N   inz
      *
      *  Local fields
     D isFirstRcd      S               N   inz
     D numRcd          S             10I 0 inz
     D isSelected      S               N   inz
      *
     D msg             DS                  likeds(msg_t) inz
      *
      *  Message data structures
      /COPY QCMPMSGF,USR0009
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      isFirstRcd = cTrue
     C                   Eval      numRcd     = 0
      *
     C                   Dou       (numRcd      >= g_sflPage  )  or
     C                             (g_sflNumRcd >= g_sflMaxRcd)  or
     C                             (not isFound               )
      *
     C                   Callp     p_sflFilRcd(g_RTVM0400_1 :
     C                                         g_RTVM0400_2 )
      *
      *  Check upper range value ...
     C                   If        i_lowerMsgID = '*FIRST'
     C                   Eval      i_lowerMsgID = $$MSGID
     C                   Endif
      *
     C                   Select
      *  ... *ONLY
     C                   When      i_upperMsgID = '*ONLY'
     C                   If        $$MSGID <> i_lowerMsgID
     C                   Leave
     C                   Endif
      *  ... *LAST
     C                   When      i_upperMsgID = '*LAST'
      *  ... specific MsgID
     C                   Other
     C                   If        $$MSGID > i_upperMsgID
     C                   Leave
     C                   Endif
     C                   Endsl
      *
      *  Process filter options
     C                   Select
     C                   When      (g_filterCpyR   = 'Y'          )   and
     C                             ($$CD           = cCmpCopyRight)
     C                   Eval      isSelected = cTrue
     C                   When      (g_filterCpyL   = 'Y'          )   and
     C                             ($$CD           = cCmpCopyLeft )
     C                   Eval      isSelected = cTrue
     C                   When      (g_filterEqual  = 'Y'          )   and
     C                             ($$CD           = cCmpEqual    )
     C                   Eval      isSelected = cTrue
     C                   When      (g_filterNEqual = 'Y'          )   and
     C                             ($$CD           = cCmpNotEqual )
     C                   Eval      isSelected = cTrue
     C                   Other
     C                   If        $$CD = cCmpNoAction
     C                   Eval      isSelected = cTrue
     C                   Else
     C                   Eval      isSelected = cFalse
     C                   Endif
     C                   Endsl
      *
      *  Process find string
     C                   If        g_find <> ''
     C                   If        %scan(g_find:
     C                                f_toLower(f_rtvMsgText(g_RTVM0400_1))) = 0
     C                             and
     C                             %scan(g_find:
     C                                f_toLower(f_rtvMsgText(g_RTVM0400_2))) = 0
     C                   Eval      isSelected = cFalse
     C                   Endif
     C                   Endif
      *
      *  Write to subfile and ...
     C                   If        isSelected
     C                   Eval      g_sflNumRcd = g_sflNumRcd + 1
     C                   Eval      SFLRRN      = g_sflNumRcd
     C                   Write     SFL
     C                   Eval      numRcd     = numRcd + 1
      *
      *  ... position subfile to first new record
     C                   If        isFirstRcd
     C                   Eval      isFirstRcd =  cFalse
     C                   Eval      SFLRCDNBR  =  SFLRRN
     C                   Endif
     C                   Endif
      *
      *  Read next record
     C                   Eval      isFound = f_sflReadRcd
     C                   Enddo
      *
      *  Display subfile
     C                   If        numRcd > 0
     C                   Eval      workstn_sfldsp = cTrue
     C                   Endif
      *
      *  Set subfile end indicator
     C                   If        not isFound
     C                   Eval      workstn_sflend = cTrue
     C                   Else
     C                   Eval      workstn_sflend = cFalse
     C                   Endif
      *
      *  Send warning message
     C                   If        g_sflNumRcd >= g_sflMaxRcd
     C                   Clear                   USR0009
     C                   Eval      USR00091 = g_sflMaxRcd
     C                   Eval      msg     = f_newMsg('USR0009': USR0009)
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *
     C                   Return    isFound
      *
     P f_sflLoadPage...
     P                 E
      *
      *===============================================================*
      *  sflClrSlc
      *===============================================================*
      *
     P p_sflClrSlc...
     P                 B
      *
     D p_sflClrSlc...
     D                 PI
     D  i_sflRrn                     10I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C     i_sflRrn      Chain     SFL
     C                   Eval      ##OPT = ''
     C                   Eval      workstn_opt_ri    = cFalse
     C                   Eval      workstn_sflnxtchg = cFalse
     C                   Update    SFL
      *
     C                   Return
      *
     P p_sflClrSlc...
     P                 E
      *
      *===============================================================*
      *  sflSetErr
      *===============================================================*
      *
     P p_sflSetErr...
     P                 B
      *
     D p_sflSetErr...
     D                 PI
     D  i_sflRrn                     10I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C     i_sflRrn      Chain     SFL
     C                   Eval      workstn_opt_ri    = cTrue
     C                   Eval      workstn_sflnxtchg = cTrue
     C                   Update    SFL
      *
     C                   Eval      SFLRCDNBR = i_sflRrn
      *
     C                   Return
      *
     P p_sflSetErr...
     P                 E
      *
      *===============================================================*
      *  sflClrInd
      *===============================================================*
      *
     P p_sflClrInd...
     P                 B
      *
     D p_sflClrInd...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      workstn_msgf1_pc = cFalse
     C                   Eval      workstn_lib1_pc  = cFalse
     C                   Eval      workstn_msgf2_pc = cFalse
     C                   Eval      workstn_lib2_pc  = cFalse
      *
     C                   Eval      workstn_msgf1_ri = cFalse
     C                   Eval      workstn_lib1_ri  = cFalse
     C                   Eval      workstn_msgf2_ri = cFalse
     C                   Eval      workstn_lib2_ri  = cFalse
      *
     C                   Eval      workstn_posto_ri = cFalse
     C                   Eval      workstn_find_ri  = cFalse
      *
     C                   Return
      *
     P p_sflClrInd...
     P                 E
      *
      *===============================================================*
      *  Position to ...
      *===============================================================*
      *
     P p_sflPosTo...
     P                 B
      *
     D p_sflPosTo...
     D                 PI
     D  i_posTo                            value  like(##POSTO   )
      *
      *  Local fields
     D lowEnd          S             10I 0 inz
     D highEnd         S             10I 0 inz
     D x               S             10I 0 inz
     D rrn             S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        g_sflNumRcd > 0
      *
     C                   Eval      lowEnd  = 1
     C                   Eval      highEnd = g_sflNumRcd
      *
     C                   Dou       (lowEnd > highEnd) or (highEnd < lowEnd)
     C                   Eval      x = %int((highEnd - lowEnd) / 2)
      *
     C                   Eval      rrn = lowEnd + x
     C     rrn           Chain     SFL
      *
     C                   Select
     C                   When      i_posTo < $$MSGID
     C                   Eval      highEnd = rrn - 1
     C                   When      i_posTo > $$MSGID
     C                   Eval      lowEnd  = rrn + 1
     C                   Other
     C                   Leave
     C                   Endsl
      *
     C                   Enddo
      *
     C                   If        $$MSGID < i_posTo
     C                   Eval      rrn = rrn + 1
     C                   Endif
      *
     C                   Select
     C                   When      rrn <= 0
     C                   Eval      SFLRCDNBR = 1
     C                   When      rrn > g_sflNumRcd
     C                   Eval      SFLRCDNBR = g_sflNumRcd
     C                   Other
     C                   Eval      SFLRCDNBR= rrn
     C                   Endsl
      *
     C                   Endif
      *
     C                   Return
      *
     P p_sflPosTo...
     P                 E
      *
      *===============================================================*
      *  Check for message ID
      *===============================================================*
      *
     P f_getFirstMsgID...
     P                 B
      *
     D f_getFirstMsgID...
     D                 PI              N
     D  i_msgId                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msgID                       7A
      *
      *  Return value
     D isFound         S               N   inz(cFalse)
      *
      *  Fields
     D qMsgF           DS                  likeds(qObj_t) inz
     D errCode         DS                  likeds(errCode_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Eval      qMsgF.name = i_msgF
     C                   Eval      qMsgF.lib  = i_lib
      *
      *  Retrieve message description
     C                   Eval      RTVM0400 = f_rtvMsgD(i_msgId     :
     C                                                  qMsgF       :
     C                                                  cMSGID_SAME :
     C                                                  errCode     )
      *
     C                   If        (f_isApiErr(errCode)  )  or
     C                             (rtvm0400.bytAvl   = 0)
     C                   Eval      RTVM0400 = f_rtvMsgD(i_msgId  :
     C                                                  qMsgF    :
     C                                                  '*NEXT'  :
     C                                                  errCode  )
     C                   If        (f_isApiErr(errCode)  )  or
     C                             (rtvm0400.bytAvl   = 0)
     C                   Eval      isFound = cFalse
     C                   Else
     C                   Eval      isFound = cTrue
     C                   Endif
     C                   Else
     C                   Eval      isFound = cTrue
     C                   Endif
      *
     C                   If        not isFound
     C                   Eval      o_msgID = ''
     C                   Else
     C                   Eval      o_msgID = rtvm0400.msgID
     C                   Endif
      *
     C                   Return    isFound
      *
     P f_getFirstMsgID...
     P                 E
      *
      *==================================================================*
      *  Retrieve Message Text
      *==================================================================*
      *
     P f_rtvMsgText...
     P                 B
      *
     D f_rtvMsgText...
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  Return Value
     D o_msgText       S           1024A   inz
      *-------------------------------------------------------------------
      *
     C                   If        i_rtvm0400.bytAvl = 0
     C                   Eval      o_msgText = ''
     C                   Else
     C                   If        i_rtvm0400.lenMsgR = 0
     C                   Eval      o_msgText = ''
     C                   Else
     C                   Eval      o_msgText = %subst(i_rtvm0400           :
     C                                                i_rtvm0400.ofsMsg + 1:
     C                                                i_rtvm0400.lenMsgR   )
     C                   Endif
     C                   Endif
      *
     C                   Return    o_msgText
      *
     P f_rtvMsgText...
     P                 E
      *
      *==================================================================*
      *  Retrieve Message Help
      *==================================================================*
      *
     P f_rtvMsgHelp...
     P                 B
      *
     D f_rtvMsgHelp...
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  Return Value
     D o_msgHelp       S           1024A   inz
      *-------------------------------------------------------------------
      *
     C                   If        i_rtvm0400.bytAvl = 0
     C                   Eval      o_msgHelp = ''
     C                   Else
     C                   If        i_rtvm0400.lenMsgHlpR = 0
     C                   Eval      o_msgHelp = ''
     C                   Else
     C                   Eval      o_msgHelp = %subst(i_rtvm0400              :
     C                                                i_rtvm0400.ofsMsgHlp + 1:
     C                                                i_rtvm0400.lenMsgHlpR   )
     C                   Endif
     C                   Endif
      *
     C                   Return    o_msgHelp
      *
     P f_rtvMsgHelp...
     P                 E
      *
      *==================================================================*
      *  Retrieve Replacement Variables
      *==================================================================*
      *
     P f_rtvRplVars...
     P                 B
      *
     D f_rtvRplVars...
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)
      *
      *  Return Value
     D o_rplVars       S           1024A   inz
      *
      *  Fields
     D x               S             10I 0 inz
      *
     D rplVar          DS                  qualified            based(pRplVar)
     D  length                       10I 0
     D  decPos                       10I 0
     D  type                         10A
      *-------------------------------------------------------------------
      *
     C                   Eval      o_rplVars = ''
      *
     C                   If        i_RTVM0400.NUMVARFMT > 0
     C                   Eval      pRplVar = %addr(i_RTVM0400)
     C                                       + i_RTVM0400.OFSVARFMT
      *
      *  Spin through replacement variables
     C                   For       x = 1 to i_RTVM0400.NUMVARFMT
      *
     C                   Eval      o_rplVars = %trimR(o_rplVars) + '('
      *
      *  ... check type and get length and decimal positions
     C                   Select
     C                   When      rplVar.type = '*QTDCHAR'
     C                   Eval      o_rplVars = %trimR(o_rplVars) +
     C                                         %trimR(rplVar.type ) + ' ' +
     C                                         %char(rplVar.length)
     C                   When      rplVar.type = '*CHAR'
     C                   Eval      o_rplVars = %trimR(o_rplVars) +
     C                                         %trimR(rplVar.type ) + ' ' +
     C                                         %char(rplVar.length)
     C                   When      rplVar.type = '*HEX'
     C                   Eval      o_rplVars = %trimR(o_rplVars) +
     C                                         %trimR(rplVar.type ) + ' ' +
     C                                         %char(rplVar.length)
     C                   When      rplVar.type = '*DEC'
     C                   Eval      o_rplVars = %trimR(o_rplVars) +
     C                                         %trimR(rplVar.type ) + ' ' +
     C                                         %char(rplVar.length) + ' ' +
     C                                         %char(rplVar.decPos)
     C                   Other
     C                   Eval      o_rplVars = ''
     C                   Leave
     C                   Endsl
      *
     C                   Eval      o_rplVars = %trimR(o_rplVars) + ')'
      *
     C                   Eval      pRplVar = pRplVar + i_RTVM0400.LENVARFMTE
     C                   Endfor
      *
     C                   Endif
      *
     C                   Return    o_rplVars
      *
     P f_rtvRplVars...
     P                 E
      *
      *==================================================================*
      *  Open Message File 1
      *==================================================================*
      *
     P p_openMsgF1...
     P                 B
      *
     D p_openMsgF1...
     D                 PI
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Fields
      /COPY QCMPMSGF,USR0012
      *
     D msg             DS                  likeds(msg_t) inz
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_1 <> ''
     C                   Clear                   USR0012
     C                   Eval      USR00121 = 1
     C                   Eval      msg = f_newMsg('USR0012'  :
     C                                            USR0012    :
     C                                            '*ESCAPE'  )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Prv      :
     C                                         cMsg_ToMyself )
     C                   Else
     C                   Eval      g_qMsgF_1.name = i_msgF
     C                   Eval      g_qMsgF_1.lib  = f_getMsgFLib(i_msgF: i_lib)
     C                   Eval      g_msgId_1      = cMSGID_LOVAL
     C                   Eval      g_rtvOpt_1     = ''
     C                   Endif
      *
     C                   Return
      *
     P p_openMsgF1...
     P                 E
      *
      *==================================================================*
      *  Open Message File 2
      *==================================================================*
      *
     P p_openMsgF2...
     P                 B
      *
     D p_openMsgF2...
     D                 PI
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Fields
      /COPY QCMPMSGF,USR0012
      *
     D msg             DS                  likeds(msg_t) inz
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_2 <> ''
     C                   Clear                   USR0012
     C                   Eval      USR00121 = 2
     C                   Eval      msg = f_newMsg('USR0012'  :
     C                                            USR0012    :
     C                                            '*ESCAPE'  )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Prv      :
     C                                         cMsg_ToMyself )
     C                   Else
     C                   Eval      g_qMsgF_2.name = i_msgF
     C                   Eval      g_qMsgF_2.lib  = f_getMsgFLib(i_msgF: i_lib)
     C                   Eval      g_msgId_2      = cMSGID_LOVAL
     C                   Eval      g_rtvOpt_2     = ''
     C                   Endif
      *
     C                   Return
      *
     P p_openMsgF2...
     P                 E
      *
      *==================================================================*
      *  Close Message File 1.
      *==================================================================*
      *
     P p_closeMsgF1...
     P                 B
      *
     D p_closeMsgF1...
     D                 PI
      *
      *  Fields
      /COPY QCMPMSGF,USR0013
      *
     D msg             DS                  likeds(msg_t) inz
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_1 = ''
     C                   Clear                   USR0013
     C                   Eval      USR00131 = 1
     C                   Eval      msg = f_newMsg('USR0013'  :
     C                                            USR0013    :
     C                                            '*ESCAPE'  )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Prv      :
     C                                         cMsg_ToMyself )
     C                   Else
     C                   Eval      g_msgId_1      = cMSGID_HIVAL
     C                   Eval      g_rtvOpt_1     = cMSGID_EOF
     C                   Eval      g_qMsgF_1.name = ''
     C                   Eval      g_qMsgF_1.lib  = ''
     C                   Endif
      *
     C                   Return
      *
     P p_closeMsgF1...
     P                 E
      *
      *==================================================================*
      *  Close Message File 2.
      *==================================================================*
      *
     P p_closeMsgF2...
     P                 B
      *
     D p_closeMsgF2...
     D                 PI
      *
      *  Fields
      /COPY QCMPMSGF,USR0013
      *
     D msg             DS                  likeds(msg_t) inz
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_2 = ''
     C                   Clear                   USR0013
     C                   Eval      USR00131 = 2
     C                   Eval      msg = f_newMsg('USR0013'  :
     C                                            USR0013    :
     C                                            '*ESCAPE'  )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Prv      :
     C                                         cMsg_ToMyself )
     C                   Else
     C                   Eval      g_msgId_2      = cMSGID_HIVAL
     C                   Eval      g_rtvOpt_2     = cMSGID_EOF
     C                   Eval      g_qMsgF_2.name = ''
     C                   Eval      g_qMsgF_2.lib  = ''
     C                   Endif
      *
     C                   Return
      *
     P p_closeMsgF2...
     P                 E
      *
      *==================================================================*
      *  Check if Message File 1 is open.
      *==================================================================*
      *
     P f_isOpenMsgF1...
     P                 B
      *
     D f_isOpenMsgF1...
     D                 PI              N
      *
      *  Return value
     D isOpen          S               N   inz
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_1 = ''
     C                   Eval      isOpen = cFalse
     C                   Else
     C                   Eval      isOpen = cTrue
     C                   Endif
      *
     C                   Return    isOpen
      *
     P f_isOpenMsgF1...
     P                 E
      *
      *==================================================================*
      *  Check if Message File 2 is open.
      *==================================================================*
      *
     P f_isOpenMsgF2...
     P                 B
      *
     D f_isOpenMsgF2...
     D                 PI              N
      *
      *  Return value
     D isOpen          S               N   inz
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C                   If        g_qMsgF_2 = ''
     C                   Eval      isOpen = cFalse
     C                   Else
     C                   Eval      isOpen = cTrue
     C                   Endif
      *
     C                   Return    isOpen
      *
     P f_isOpenMsgF2...
     P                 E
      *
      *==================================================================*
      *  Get Message File Library.
      *==================================================================*
      *
     P f_getMsgFLib...
     P                 B
      *
     D f_getMsgFLib...
     D                 PI            10A
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Return Value
     D lib             S             10A   inz
      *
      *  Fields
     D qObj            DS                  likeds(qObj_t) inz
     D OBJD0100        DS                  likeds(objd0100_t) inz
      *-------------------------------------------------------------------
      *
     C                   Eval      qObj.name = i_msgF
     C                   Eval      qObj.lib  = i_lib
      *
     C                   Callp     QUSROBJD(OBJD0100        :
     C                                      %size(OBJD0100) :
     C                                      'OBJD0100'      :
     C                                      qObj            :
     C                                      '*MSGF'         )
      *
     C                   Eval      lib = OBJD0100.rtnLib
      *
     C                   Return    lib
      *
     P f_getMsgFLib...
     P                 E
      *
      *==================================================================*
      *  Check Message File.
      *==================================================================*
      *
     P f_chkMsgF...
     P                 B
      *
     D f_chkMsgF...
     D                 PI              N
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msg                                     like(msg_t     )
      *
      *  Return Value
     D isOK            S               N   inz
      *
      *  Fields
      /COPY QCMPMSGF,USR0014
      /COPY QCMPMSGF,USR0015
      *-------------------------------------------------------------------
      *
      *  Check Library ...
     C                   If        i_lib = ''
     C                   Eval      i_lib = '*LIBL'
     C                   Endif
      *
     C                   If        %subst(i_lib: 1: 1) <> '*'
     C                   If        not f_exist(i_lib: '*LIBL': '*LIB')
     C                   Eval      isOK = cFalse
     C                   Clear                   USR0014
     C                   Eval      USR00141 = i_lib
     C                   Eval      o_msg    = f_newMsg('USR0014' :
     C                                                 USR0014   )
     C                   Goto      exitProcedure
     C                   Endif
     C                   Endif
      *
      *  Check message file ...
     C                   If        not f_exist(i_msgF: i_lib: '*MSGF')
     C                   Eval      isOK             = cFalse
     C                   Clear                   USR0015
     C                   Eval      USR00151 = i_msgF
     C                   Eval      USR00152 = i_lib
     C                   Eval      o_msg    = f_newMsg('USR0015' :
     C                                                 USR0015   )
     C                   Goto      exitProcedure
     C                   Endif
      *
     C                   Eval      isOK = cTrue
      *
     C     exitProcedure Tag
      *
     C                   Return    isOK
      *
     P f_chkMsgF...
     P                 E
      *
      *==================================================================*
      *  Change code.
      *==================================================================*
      *
     P p_sflChgCode...
     P                 B
      *
     D p_sflChgCode...
     D                 PI
     D  i_rrn                        10I 0 value
     D  i_newCode                          value  like($$CD)
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C     i_rrn         Chain     SFL
     C                   Eval      $$CD = i_newCode
     C                   Callp     p_sflSetCdColor($$CD)
     C                   Update    SFL
      *
     C                   Return
      *
     P p_sflChgCode...
     P                 E
      *
      *==================================================================*
      *  Add message ID.
      *==================================================================*
      *
     P f_sflAddMsgID...
     P                 B
      *
     D f_sflAddMsgID...
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  Return value
     D isAdded         S               N   inz(cFalse)
      *
      *  Fields
     D msg             DS                  likeds(msg_t) inz
      *
      *  Messages
      /COPY QCMPMSGF,USR0022
      *-------------------------------------------------------------------
      *
     C     i_rrn         Chain     SFL
      *
      *  Copy message description ...
     C                   Select
      *  ... from right to left
     C                   When      i_code = 'L'
     C                   If        H_MSGID2 <> ''
     C                   Eval      isAdded = f_copyMsgID(H_MSGID2:
     C                                                   H_FILE2: H_LIB2:
     C                                                   H_FILE1: H_LIB1)
     C                   Else
     C                   Eval      isAdded = cFalse
     C                   Clear                   USR0022
     C                   Eval      USR00221 = $$MSGID
     C                   Eval      USR00222 = H_FILE2
     C                   Eval      USR00223 = H_LIB2
     C                   Eval      msg = f_newMsg('USR0022'  :
     C                                            USR0022    )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *  ... from left to right
     C                   When      i_code = 'R'
     C                   If        H_MSGID1 <> ''
     C                   Eval      isAdded = f_copyMsgID(H_MSGID1:
     C                                                   H_FILE1: H_LIB1:
     C                                                   H_FILE2: H_LIB2)
     C                   Else
     C                   Eval      isAdded = cFalse
     C                   Clear                   USR0022
     C                   Eval      USR00221 = $$MSGID
     C                   Eval      USR00222 = H_FILE1
     C                   Eval      USR00223 = H_LIB1
     C                   Eval      msg = f_newMsg('USR0022'  :
     C                                            USR0022    )
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
      *  ... invalid code
     C                   Other
     C                   Eval      isAdded = cFalse
     C                   Endsl
      *
     C                   If        isAdded
     C                   Callp     p_sflRfrRcd(i_rrn)
     C                   Endif
      *
     C                   Return    isAdded
      *
     P f_sflAddMsgID...
     P                 E
      *
      *==================================================================*
      *  Change message ID.
      *==================================================================*
      *
     P f_sflChgMsgID...
     P                 B
      *
     D f_sflChgMsgID...
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  Return value
     D isChanged       S               N   inz(cFalse)
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C     i_rrn         Chain     SFL
      *
     C                   Select
     C                   When      i_code = 'L'
     C                   Eval      isChanged = f_changeMsgID(H_MSGID1:
     C                                                       H_FILE1 :
     C                                                       H_LIB1  )
     C                   When      i_code = 'R'
     C                   Eval      isChanged = f_changeMsgID(H_MSGID2:
     C                                                       H_FILE2 :
     C                                                       H_LIB2  )
     C                   Other
     C                   Eval      isChanged = cFalse
     C                   Endsl
      *
     C                   If        isChanged
     C                   Callp     p_sflRfrRcd(i_rrn)
     C                   Endif
      *
     C                   Return    isChanged
      *
     P f_sflChgMsgID...
     P                 E
      *
      *==================================================================*
      *  Delete message ID.
      *==================================================================*
      *
     P f_sflDltMsgID...
     P                 B
      *
     D f_sflDltMsgID...
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C     i_rrn         Chain     SFL
      *
     C                   Select
     C                   When      i_code = 'L'
     C                   Eval      isDeleted = f_deleteMsgID(H_MSGID1:
     C                                                       H_FILE1 :
     C                                                       H_LIB1  )
     C                   When      i_code = 'R'
     C                   Eval      isDeleted = f_deleteMsgID(H_MSGID2:
     C                                                       H_FILE2 :
     C                                                       H_LIB2  )
     C                   Other
     C                   Eval      isDeleted = cFalse
     C                   Endsl
      *
     C                   If        isDeleted
     C                   Callp     p_sflRfrRcd(i_rrn)
     C                   Endif
      *
     C                   Return    isDeleted
      *
     P f_sflDltMsgID...
     P                 E
      *
      *==================================================================*
      *  Display message ID.
      *==================================================================*
      *
     P f_sflDspMsgID...
     P                 B
      *
     D f_sflDspMsgID...
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value
      *
      *  Return value
     D isDisplayed     S               N   inz(cFalse)
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C     i_rrn         Chain     SFL
      *
     C                   Select
     C                   When      i_code = 'L'
     C                   Eval      isDisplayed = f_displayMsgID(H_MSGID1:
     C                                                          H_FILE1 :
     C                                                          H_LIB1  )
     C                   When      i_code = 'R'
     C                   Eval      isDisplayed = f_displayMsgID(H_MSGID2:
     C                                                          H_FILE2 :
     C                                                          H_LIB2  )
     C                   Other
     C                   Eval      isDisplayed = cFalse
     C                   Endsl
      *
     C                   Return    isDisplayed
      *
     P f_sflDspMsgID...
     P                 E
      *
      *==================================================================*
      *  Copy Message ID.
      *==================================================================*
      *
     P f_copyMsgID...
     P                 B
      *
     D f_copyMsgID...
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_fromMsgF                   10A   value
     D  i_fromLib                    10A   value
     D  i_toMsgF                     10A   value
     D  i_toLib                      10A   value
      *
      *  Return value
     D isCopied        S               N   inz
      *
      *  Fields
     D cmd             S            512A   inz
      *-------------------------------------------------------------------
      *
     C                   Eval      cmd = 'MRGMSGF ' +
     C                                   'FROMMSGF(' +
     C                                      %trim(i_fromLib) +
     C                                      '/' +
     C                                      %trim(i_fromMsgF) +
     C                                      ') ' +
     C                                   'TOMSGF(' +
     C                                      %trim(i_toLib) +
     C                                      '/' +
     C                                      %trim(i_toMsgF) +
     C                                      ') ' +
     C                                   'RPLMSGF(' +
     C                                      %trim('*NONE') +
     C                                      ') ' +
     C                                   'SELECT(' +
     C                                      %trim(i_msgID) +
     C                                      ') '
     C                   If        system(cmd) <> 0
     C                   Eval      isCopied = cFalse
     C                   Else
     C                   Eval      isCopied = cTrue
     C                   Endif
      *
     C                   Return    isCopied
      *
     P f_copyMsgID...
     P                 E
      *
      *==================================================================*
      *  Add Message ID.
      *==================================================================*
      *
     P f_addMsgID...
     P                 B
      *
     D f_addMsgID...
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  i_baseMsgF                   10A   value
     D  i_baseLib                    10A   value
      *
      *  Return value
     D isAdded         S               N   inz
      *
      *  Fields
     D cmd             S            512A   inz
      *-------------------------------------------------------------------
      *
     C                   Eval      cmd = '?ADDMSGD ' +
     C                                   '?*MSGID(' +
     C                                      %trim(i_msgID) +
     C                                      ') ' +
     C                                   '?*MSGF(' +
     C                                      %trim(i_lib) +
     C                                      '/' +
     C                                      %trim(i_msgF) +
     C                                      ') ' +
     C                                   f_rtvCmdValues(i_msgID:
     C                                                  i_baseMsgF: i_baseLib)
     C                   If        system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801'
     C                   Eval      isAdded = cFalse
     C                   Else
     C                   Eval      isAdded = cTrue
     C                   Endif
      *
     C                   Return    isAdded
      *
     P f_addMsgID...
     P                 E
      *
      *==================================================================*
      *  Change Message ID.
      *==================================================================*
      *
     P f_changeMsgID...
     P                 B
      *
     D f_changeMsgID...
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Return value
     D isChanged       S               N   inz
      *
      *  Fields
     D cmd             S           8192A   inz
     D msgHelp         S           1024A   inz
     D rplVars         S           1024A   inz
     D qMsgF           DS                  likeds(qObj_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D errCode         DS                  likeds(errCode_t) inz
      *-------------------------------------------------------------------
      *
     C                   Eval      qMsgF.name = i_msgF
     C                   Eval      qMsgF.lib  = i_lib
     C                   Eval      RTVM0400 = f_rtvMsgD(i_msgID     :
     C                                                  qMsgF       :
     C                                                  cMSGID_SAME :
     C                                                  errCode     )
      *
     C                   If        (f_isApiErr(errCode))  or
     C                             (RTVM0400.bytAvl = 0)
     C                   Eval      isChanged = cFalse
     C                   Else
      *
      *  Get second level text
     C                   Eval      msgHelp = f_rtvMsgHelp(RTVM0400)
     C                   If        msgHelp = ''
     C                   Eval      msgHelp = '*N'
     C                   Else
     C                   Eval      msgHelp = cQuote + %trimR(msgHelp) + cQuote
     C                   Endif
      *
      *  Get replacement variables
     C                   Eval      rplVars = f_rtvRplVars(RTVM0400)
     C                   If        rplVars = ''
     C                   Eval      rplVars = '*N'
     C                   Endif
      *
      *  Produce CHGMSGD command
     C                   Eval      cmd = '?CHGMSGD ' +
     C                                   '?*MSGID(' +
     C                                      %trim(i_msgID) +
     C                                      ') ' +
     C                                   '?*MSGF(' +
     C                                      %trim(i_lib) +
     C                                      '/' +
     C                                      %trim(i_msgF) +
     C                                      ') ' +
     C                                   f_rtvCmdValues(i_msgID: i_msgF: i_lib)
     C                   If        system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801'
     C                   Eval      isChanged = cFalse
     C                   Else
     C                   Eval      isChanged = cTrue
     C                   Endif
     C                   Endif
      *
     C                   Return    isChanged
      *
     P f_changeMsgID...
     P                 E
      *
      *==================================================================*
      *  Delete Message ID.
      *==================================================================*
      *
     P f_deleteMsgID...
     P                 B
      *
     D f_deleteMsgID...
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Return value
     D isDeleted       S               N   inz
      *
      *  Fields
     D cmd             S            512A   inz
      *-------------------------------------------------------------------
      *
     C                   Eval      cmd = '?RMVMSGD ' +
     C                                   '?*MSGID(' +
     C                                      %trim(i_msgID) +
     C                                      ') ' +
     C                                   '?*MSGF(' +
     C                                      %trim(i_lib) +
     C                                      '/' +
     C                                      %trim(i_msgF) +
     C                                      ') '
     C                   If        system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801'
     C                   Eval      isDeleted = cFalse
     C                   Else
     C                   Eval      isDeleted = cTrue
     C                   Endif
      *
     C                   Return    isDeleted
      *
     P f_deleteMsgID...
     P                 E
      *
      *==================================================================*
      *  Display Message ID.
      *==================================================================*
      *
     P f_displayMsgID...
     P                 B
      *
     D f_displayMsgID...
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Return value
     D isDisplayed     S               N   inz
      *
      *  Fields
     D cmd             S            512A   inz
      *-------------------------------------------------------------------
      *
     C                   Eval      cmd = 'DSPMSGD ' +
     C                                   'RANGE(' +
     C                                      %trim(i_msgID) +
     C                                      ') ' +
     C                                   'MSGF(' +
     C                                      %trim(i_lib) +
     C                                      '/' +
     C                                      %trim(i_msgF) +
     C                                      ') '
     C                   If        system(cmd) <> 0
     C                   Eval      isDisplayed = cFalse
     C                   Else
     C                   Eval      isDisplayed = cTrue
     C                   Endif
      *
     C                   Return    isDisplayed
      *
     P f_displayMsgID...
     P                 E
      *
      *==================================================================*
      *  Fill Subfile Record.
      *==================================================================*
      *
     P p_sflFilRcd...
     P                 B
      *
     D p_sflFilRcd...
     D                 PI
     D  i_rtvm0400_1                       value  likeds(RTVM0400_t)
     D  i_rtvm0400_2                       value  likeds(RTVM0400_t)
      *
      *  Fields
     D                 DS
     D date7$                         7A
     D date7                          7S 0 inz overlay(date7$: 1)
     D mod_1           DS
     D  mod_crtDate_1                  D   inz
     D  mod_crtLvl_1                 10I 0 inz
     D  mod_modDate_1                  D   inz
     D  mod_modLvl_1                 10I 0 inz
     D mod_2           DS
     D  mod_crtDate_2                  D   inz
     D  mod_crtLvl_2                 10I 0 inz
     D  mod_modDate_2                  D   inz
     D  mod_modLvl_2                 10I 0 inz
      *-------------------------------------------------------------------
      *
      *  Compare date : Y/N
     C                   If        g_cmpDate = 'Y'
      *            keep information
     C                   Else
     C                   Eval      i_RTVM0400_1.crtDate = cLowDat7
     C                   Eval      i_RTVM0400_1.modDate = cLowDat7
     C                   Eval      i_RTVM0400_2.crtDate = cLowDat7
     C                   Eval      i_RTVM0400_2.modDate = cLowDat7
     C                   Endif
      *
      *  Compare level: Y/N
     C                   If        g_cmpLvl  = 'Y'
      *            keep information
     C                   Else
     C                   Eval      i_RTVM0400_1.crtLvlNbr = 0
     C                   Eval      i_RTVM0400_1.modLvlNbr = 0
     C                   Eval      i_RTVM0400_2.crtLvlNbr = 0
     C                   Eval      i_RTVM0400_2.modLvlNbr = 0
     C                   Endif
      *
      *  Create creation/modification level data structure
     C                   Eval      date7$ = i_RTVM0400_1.crtDate
     C     *CYMD         Move      date7         mod_crtDate_1
     C                   Eval      date7$ = i_RTVM0400_1.modDate
     C     *CYMD         Move      date7         mod_modDate_1
      *
     C                   Eval      mod_crtLvl_1 = i_RTVM0400_1.crtLvlNbr
     C                   Eval      mod_modLvl_1 = i_RTVM0400_1.modLvlNbr
      *
     C                   Eval      date7$ = i_RTVM0400_2.crtDate
     C     *CYMD         Move      date7         mod_crtDate_2
     C                   Eval      date7$ = i_RTVM0400_2.modDate
     C     *CYMD         Move      date7         mod_modDate_2
      *
     C                   Eval      mod_crtLvl_2 = i_RTVM0400_2.crtLvlNbr
     C                   Eval      mod_modLvl_2 = i_RTVM0400_2.modLvlNbr
      *
      *  Set subfile hidden fields ...
     C                   Eval      H_MSGID1 = i_RTVM0400_1.msgId
     C                   Eval      H_FILE1  = g_qMsgF_1.name
     C                   Eval      H_LIB1   = g_qMsgF_1.lib
     C                   Eval      H_MSGID2 = i_RTVM0400_2.msgId
     C                   Eval      H_FILE2  = g_qMsgF_2.name
     C                   Eval      H_LIB2   = g_qMsgF_2.lib
      *
      *  Set subfile fields ...
     C                   Eval      ##OPT          = ''
     C                   Eval      workstn_opt_ri = cFalse
      *
     C                   If        i_RTVM0400_1.msgId <> ''
     C                   Eval      $$MSGID   = i_RTVM0400_1.msgId
     C                   Else
     C                   Eval      $$MSGID   = i_RTVM0400_2.msgId
     C                   Endif
      *
     C                   Eval      $$TEXT1   = f_rtvMsgText(i_RTVM0400_1)
     C                   Eval      $$HELP1   = f_rtvMsgHelp(i_RTVM0400_1)
      *
     C                   Eval      $$TEXT2   = f_rtvMsgText(i_RTVM0400_2)
     C                   Eval      $$HELP2   = f_rtvMsgHelp(i_RTVM0400_2)
      *
      *  ... determine action code
     C                   Select
      *      ... no-action     (missing both descriptions)
     C                   When      i_RTVM0400_1.msgId = '' and
     C                             i_RTVM0400_2.msgId = ''
     C                   Eval      $$CD = cCmpNoAction
      *      ... copy-to-left  (missing left description)
     C                   When      i_RTVM0400_1.msgId = ''
     C                   Eval      $$CD = cCmpCopyLeft
      *      ... copy-to-right (missing right description)
     C                   When      i_RTVM0400_2.msgId = ''
     C                   Eval      $$CD = cCmpCopyRight
     C                   Other
      *      ... others
     C                   If        i_RTVM0400_1 = i_RTVM0400_2
      *          ... equal descriptions
     C                   Eval      $$CD = cCmpEqual
     C                   Else
      *
      *          ... not equal so ...
     C                   Select
      *              ... copy-to-left
     C                   When      mod_2 > mod_1
     C                   Eval      $$CD = cCmpCopyLeft
      *              ... copy-to-right
     C                   When      mod_1 > mod_2
     C                   Eval      $$CD = cCmpCopyRight
      *              ... don't know what to do
     C                   Other
     C                   Eval      $$CD = cCmpNotEqual
     C                   Endsl
      *
     C                   Endif
     C                   Endsl
      *
     C                   Callp     p_sflSetCdColor($$CD)
      *
     C                   Return
      *
     P p_sflFilRcd...
     P                 E
      *
      *==================================================================*
      *  Set Code Color.
      *==================================================================*
      *
     P p_sflSetCdColor...
     P                 B
      *
     D p_sflSetCdColor...
     D                 PI
     D  i_cd                               value  like($$CD      )
      *
      *  Fields
      *-------------------------------------------------------------------
      *
     C                   Eval      workstn_cd_white = *off
     C                   Eval      workstn_cd_grn   = *off
     C                   Eval      workstn_cd_ylw   = *off
     C                   Eval      workstn_cd_red   = *off
      *
     C                   Select
     C                   When      i_cd = cCmpCopyLeft
     C                   Eval      workstn_cd_ylw = *on
     C                   When      i_cd = cCmpCopyRight
     C                   Eval      workstn_cd_ylw = *on
     C                   When      i_cd = cCmpNotEqual
     C                   Eval      workstn_cd_red = *on
     C                   Other
     C                   Eval      workstn_cd_white = *on
     C                   Endsl
      *
     C                   Return
      *
     P p_sflSetCdColor...
     P                 E
      *
      *==================================================================*
      *  Refresh Subfile Record.
      *==================================================================*
      *
     P p_sflRfrRcd...
     P                 B
      *
     D p_sflRfrRcd...
     D                 PI
     D  i_rrn                        10I 0 value
      *
      *  Fields
     D qMsgF_1         DS                  likeds(qObj_t) inz
     D qMsgF_2         DS                  likeds(qObj_t) inz
     D rtvm0400_1      DS                  likeds(rtvm0400_t) inz
     D rtvm0400_2      DS                  likeds(rtvm0400_t) inz
     D errCode_1       DS                  likeds(errCode_t) inz
     D errCode_2       DS                  likeds(errCode_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Retrieve message description of 1. file
     C                   Eval      qMsgF_1.name = ##MSGF1
     C                   Eval      qMsgF_1.lib  = ##LIB1
     C                   Eval      RTVM0400_1 = f_rtvMsgD($$MSGID     :
     C                                                    qMsgF_1     :
     C                                                    cMSGID_SAME :
     C                                                    errCode_1   )
      *
     C                   If        (f_isApiErr(errCode_1)  )  or
     C                             (rtvm0400_1.bytAvl = 0  )
     C                   Eval      rtvm0400_1 = f_newRtvm0400
     C                   Endif
      *
      *  Retrieve message description of 2. file
     C                   Eval      qMsgF_2.name = ##MSGF2
     C                   Eval      qMsgF_2.lib  = ##LIB2
     C                   Eval      rtvm0400_2 = f_rtvMsgD($$MSGID     :
     C                                                    qMsgF_2     :
     C                                                    cMSGID_SAME :
     C                                                    errCode_2   )
      *
     C                   If        (f_isApiErr(errCode_2)  )  or
     C                             (rtvm0400_2.bytAvl = 0  )
     C                   Eval      rtvm0400_2 = f_newRtvm0400
     C                   Endif
      *
     C     i_rrn         Chain     SFL
      *
     C                   Callp     p_sflFilRcd(RTVM0400_1 :
     C                                         RTVM0400_2 )
      *
     C                   Update    SFL
      *
     C                   Return
      *
     P p_sflRfrRcd...
     P                 E
      *
      *==================================================================*
      *  Retrieve Message Description.
      *==================================================================*
      *
     P f_rtvMsgD...
     P                 B
      *
     D f_rtvMsgD...
     D                 PI                  likeds(rtvm0400_t)
     D  i_msgId                       7A   value
     D  i_qMsgF                            value like(qobj_t)
     D  i_rtvOpt                     10A   value
     D  o_errCode                          value likeds(errCode_t)
      *
      *  Fields
     D RTVM0300        DS                  likeds(rtvm0300_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D msg             DS                  likeds(msg_t) inz
     D sizeAdj         S             10I 0 inz static
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *
     C                   Eval      RTVM0400 = f_newRtvm0400
     C                   Eval      o_errCode  = f_newApiErrCode(cTrue)
      *
      *  Retrieve message description
     C                   If        g_fmtName = 'RTVM0400'
     C                   Callp     QMHRTVM(RTVM0400            :
     C                                     %size(RTVM0400)     :
     C                                     g_fmtName           :
     C                                     i_msgId             :
     C                                     i_qMsgF             :
     C                                     ''                  :
     C                                     0                   :
     C                                     '*NO'               :
     C                                     '*YES'              :
     C                                     o_errCode           :
     C                                     i_rtvOpt            :
     C                                     0                   :
     C                                     0                   )
      *
     C                   If        o_errCode.excId = 'CPF3C21'
     C                   Eval      sizeAdj   = %size(RTVM0400) - %size(RTVM0300)
     C                   Eval      g_fmtName = 'RTVM0300'
     C                   Eval      msg = f_newMsg('USR0021')
     C                   Callp     p_sndPgmMsg(msg           :
     C                                         cMsg_Same     :
     C                                         cMsg_ToPgmBdy )
     C                   Endif
     C                   Endif
      *
     C                   If        g_fmtName = 'RTVM0300'
     C                   Eval      RTVM0300 = f_newRtvm0300
     C                   Callp     QMHRTVM(RTVM0300            :
     C                                     %size(RTVM0300)     :
     C                                     g_fmtName           :
     C                                     i_msgId             :
     C                                     i_qMsgF             :
     C                                     ''                  :
     C                                     0                   :
     C                                     '*NO'               :
     C                                     '*YES'              :
     C                                     o_errCode           :
     C                                     i_rtvOpt            :
     C                                     0                   :
     C                                     0                   )
     C                   Eval      RTVM0400 = f_newRtvm0400
     C                   Eval      RTVM0400.BYTRET = RTVM0300.BYTRET
     C                   Eval      RTVM0400.BYTAVL = RTVM0300.BYTAVL
     C                   Eval      RTVM0400.MSGSEV = RTVM0300.MSGSEV
     C                   Eval      RTVM0400.ALTIDX = RTVM0300.ALTIDX
     C                   Eval      RTVM0400.ALTOPT = RTVM0300.ALTOPT
     C                   Eval      RTVM0400.LOGIND = RTVM0300.LOGIND
     C                   Eval      RTVM0400.MSGID = RTVM0300.MSGID
     C                   Eval      RTVM0400.reserved_01 = RTVM0300.reserved_01
     C
     C                   Eval      RTVM0400.NUMVARFMT = RTVM0300.NUMVARFMT
     C                   Eval      RTVM0400.CSINDTXT = RTVM0300.CSINDTXT
     C                   Eval      RTVM0400.CSINDDTA = RTVM0300.CSINDDTA
     C                   Eval      RTVM0400.CCSIDTXT = RTVM0300.CCSIDTXT
     C                   Eval      RTVM0400.OFSDFTR = RTVM0300.OFSDFTR +
     C                                                            sizeAdj
     C                   Eval      RTVM0400.LENDFTRPYR = RTVM0300.LENDFTRPYR
     C                   Eval      RTVM0400.LENDFTRPYA = RTVM0300.LENDFTRPYA
     C                   Eval      RTVM0400.OFSMSG = RTVM0300.OFSMSG  +
     C                                                            sizeAdj
     C                   Eval      RTVM0400.LENMSGR = RTVM0300.LENMSGR
     C                   Eval      RTVM0400.LENMSGA = RTVM0300.LENMSGA
     C                   Eval      RTVM0400.OFSMSGHLP = RTVM0300.OFSMSGHLP +
     C                                                              sizeAdj
     C                   Eval      RTVM0400.LENMSGHLPR = RTVM0300.LENMSGHLPR
     C                   Eval      RTVM0400.LENMSGHLPA = RTVM0300.LENMSGHLPA
     C                   Eval      RTVM0400.OFSVARFMT = RTVM0300.OFSVARFMT +
     C                                                              sizeAdj
     C                   Eval      RTVM0400.LENVARFMTR = RTVM0300.LENVARFMTR
     C                   Eval      RTVM0400.LENVARFMTA = RTVM0300.LENVARFMTA
     C                   Eval      RTVM0400.LENVARFMTE = RTVM0300.LENVARFMTE
     C                   Eval      RTVM0400.DATA = RTVM0300.DATA
     C                   Endif
      *
     C                   If        RTVM0400.crtDate = ''
     C                   Eval      RTVM0400.crtDate = cLowDat7
     C                   Endif
      *
     C                   If        RTVM0400.modDate = ''
     C                   Eval      RTVM0400.modDate = cLowDat7
     C                   Endif
      *
     C                   Return    RTVM0400
      *
     P f_rtvMsgD...
     P                 E
      *
      *==================================================================*
      *  Create a new RTVM0300 format.
      *==================================================================*
      *
     P f_newRtvm0300...
     P                 B
      *
     D f_newRtvm0300...
     D                 PI                  likeds(RTVM0300_t)
      *
      *  Fields
     D RTVM0300        DS                  likeds(rtvm0300_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Clear                   RTVM0300
      *
     C                   Return    RTVM0300
      *
     P f_newRtvm0300...
     P                 E
      *
      *==================================================================*
      *  Create a new RTVM0400 format.
      *==================================================================*
      *
     P f_newRtvm0400...
     P                 B
      *
     D f_newRtvm0400...
     D                 PI                  likeds(RTVM0400_t)
      *
      *  Fields
     D RTVM0400        DS                  likeds(rtvm0400_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   Clear                   RTVM0400
      *
     C                   Eval      RTVM0400.crtDate = cLowDat7
     C                   Eval      RTVM0400.modDate = cLowDat7
      *
     C                   Return    RTVM0400
      *
     P f_newRtvm0400...
     P                 E
      *
      *==================================================================*
      *  Convert string to lower case.
      *==================================================================*
      *
     P f_toLower...
     P                 B
      *
     D f_toLower...
     D                 PI          1024A          varying
     D  i_string                   1024A   const  varying
      *
      *  Return value
     D  lowerString    S           1024A   varying inz
      *
      *  Conversion constants
     D lc              C                   const('abcdefghijklmnopqrstuvwxyz')
     D uc              C                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     C                   If        %len(i_string) > 0
     C                   Eval      lowerString = %xlate(uc: lc: i_string)
     C                   Else
     C                   Eval      lowerString = ''
     C                   Endif
      *
     C                   Return    lowerString
      *
     P f_toLower...
     P                 E
      *
      *==================================================================*
      *  Retrieve command values
      *==================================================================*
      *
     P f_rtvCmdValues...
     P                 B
      *
     D f_rtvCmdValues...
     D                 PI          8192A          varying
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
      *
      *  Return value
     D cmdValues       S           8192A   varying inz
      *
      *  Fields
     D msgHelp         S           1024A   inz
     D rplVars         S           1024A   inz
     D qMsgF           DS                  likeds(qObj_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D errCode         DS                  likeds(errCode_t) inz
      *-------------------------------------------------------------------
      *
     C                   Eval      qMsgF.name = i_msgF
     C                   Eval      qMsgF.lib  = i_lib
     C                   Eval      RTVM0400 = f_rtvMsgD(i_msgID     :
     C                                                  qMsgF       :
     C                                                  cMSGID_SAME :
     C                                                  errCode     )
      *
     C                   If        (f_isApiErr(errCode))  or
     C                             (RTVM0400.bytAvl = 0)
     C                   Eval      cmdValues = ''
     C                   Else
      *
      *  Get second level text
     C                   Eval      msgHelp = f_rtvMsgHelp(RTVM0400)
     C                   If        msgHelp = ''
     C                   Eval      msgHelp = '*N'
     C                   Else
     C                   Eval      msgHelp = cQuote + %trimR(msgHelp) + cQuote
     C                   Endif
      *
      *  Get replacement variables
     C                   Eval      rplVars = f_rtvRplVars(RTVM0400)
     C                   If        rplVars = ''
     C                   Eval      rplVars = '*N'
     C                   Endif
      *
      *  Produce CHGMSGD command
     C                   Eval      cmdValues = ' ' +
     C                                   'MSG(' +
     C                                      cQuote +
     C                                         %trimR(f_rtvMsgText(RTVM0400)) +
     C                                      cQuote +
     C                                      ') ' +
     C                                   'SECLVL(' +
     C                                      %trimR(msgHelp) +
     C                                      ') ' +
     C                                   'FMT(' +
     C                                      %trimR(rplVars) +
     C                                      ') ' +
     C                                   'SEV(' +
     C                                      %char(RTVM0400.MSGSEV) +
     C                                      ') '
      *
     C                   Endif
      *
     C                   Return    cmdValues
      *
     P f_rtvCmdValues...
     P                 E
      *
