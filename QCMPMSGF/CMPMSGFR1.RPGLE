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
       //  Datum       Name          Änderung                                 *
       //  ----------  ------------  ---------------------------------------  *
       //  13.11.2001  Th.Raddatz    Fixed problem that the color of $$CD     *
       //                            was not set when $$CD was changed        *
       //                            manually.                                *
       //  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
       //                            "Position to" and added binary search.   *
       //  13.11.2001  Th.Raddatz    Changed filter "First Message ID" to     *
       //                            "Position to" and added binary search.   *
       //  20.12.2001  Th.Raddatz    Added the "Filter" panel.                *
       //  24.12.2001  Th.Raddatz    Added support for the RTVM0400 format    *
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
     H DEBUG
     H NOMAIN
     H EXTBININT(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
      /COPY QCMPMSGF,COPYRIGHT
       //===============================================================*
     FCMPMSGFD1 CF   E             WORKSTN usropn
     F                                     infds(Screen)
     F                                     indds(workstn)
     F                                     sfile(SFL:SFLRRN)

     D workstn         DS                  qualified

     D  cd_white              50     50N
     D  cd_grn                51     51N
     D  cd_ylw                52     52N
     D  cd_red                53     53N
     D  msgf1_pc              61     61N
     D  lib1_pc               62     62N
     D  msgf2_pc              65     65N
     D  lib2_pc               66     66N
     D  msgf1_ri              71     71N
     D  lib1_ri               72     72N
     D  msgf2_ri              75     75N
     D  lib2_ri               76     76N
     D  sfldsp                80     80N
     D  sfldspctl             81     81N
     D  sflclr                82     82N
     D  sflend                83     83N
     D  sflmode               84     84N
     D  sflnxtchg             85     85N
     D  opt_ri                86     86N
     D  posto_ri              87     87N
     D  find_ri               88     88N
     D  msgsflend             89     89N
     D  options_1             91     91N
     D  options_2             92     92N
     D  options_3             93     93N

       //== Workstation information data structure =====================*
     D screen          DS                  qualified
     D Open                    9      9A
     D status                 11     15S 0
     D AID                   369    369A
       //===============================================================*

       //== Prototypes and Constants ===================================*
      /COPY QCMPMSGF,CMPMSGFR4
       //===============================================================*

       //== Private Prototypes =========================================*
       //  ... end program
     D cmd_endPgm...
     D                 PR              N

       //  ... refresh screen
     D cmd_refresh...
     D                 PR
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value

       //  ... process
     D cmd_process...
     D                 PR              N
     D  o_msg                                     like(msg_t     )

       //  ... goto top of subfile
     D cmd_gotoTop...
     D                 PR

       //  ... goto botton of subfile
     D cmd_gotoBot...
     D                 PR

       //  ... show more cmd keys
     D cmd_moreKeys...
     D                 PR

       //  ... show more options
     D cmd_moreOptions...
     D                 PR

       //  ... command line
     D cmd_cmdLine...
     D                 PR

       //  ... process enter key
     D cmd_enter...
     D                 PR              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value

       //  ... page up
     D cmd_pageUp...
     D                 PR

       //  ... page down
     D cmd_pageDown...
     D                 PR

       //  ... validate screen
     D f_validateScreen...
     D                 PR              N

       //  ... read changed records
     D f_sflReadChg...
     D                 PR              N

       //  ... check if there are changed records
     D f_sflChkChg...
     D                 PR              N
     D  o_sflRrn                     10I 0        options(*nopass)

       //  ... initialize subfile
     D p_sflInit...
     D                 PR

       //  ... position file pointer and read first record
     D p_sflPosKey...
     D                 PR              N
     D  i_lowerMsgID                  7A   value

       //  ... read next record
     D f_sflReadRcd...
     D                 PR              N

       //  ... load page into subfile
     D f_sflLoadPage...
     D                 PR              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value

       //  ... clear selection
     D p_sflClrSlc...
     D                 PR
     D  i_sflRrn                     10I 0 const

       //  ... set error status
     D p_sflsetErr...
     D                 PR
     D  i_sflRrn                     10I 0 const

       //  ... clear subfile/screen indicators
     D p_sflClrInd...
     D                 PR

       //  ... position to
     D p_sflPosTo...
     D                 PR
     D  i_posTo                            value  like(##POSTO   )

       //  ... get first message id
     D f_getFirstMsgID...
     D                 PR              N
     D  i_msgId                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msgID                       7A

       //  ... retrieve message text
     D f_rtvMsgText...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  ... retrieve message help
     D f_rtvMsgHelp...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  ... retrieve replacement variables
     D f_rtvRplVars...
     D                 PR          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  ... open message file 1
     D p_openMsgF1...
     D                 PR
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... open message file 2
     D p_openMsgF2...
     D                 PR
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... close message file 1
     D p_closeMsgF1...
     D                 PR

       //  ... close message file 2
     D p_closeMsgF2...
     D                 PR

       //  ... is message file 1 open?
     D f_isOpenMsgF1...
     D                 PR              N

       //  ... is message file 2 open?
     D f_isOpenMsgF2...
     D                 PR              N

       //  ... get message file library
     D f_getMsgFLib...
     D                 PR            10A
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... check if message file exists
     D f_chkMsgF...
     D                 PR              N
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msg                                     like(msg_t     )

       //  ... change subfile action code
     D p_sflChgCode...
     D                 PR
     D  i_rrn                        10I 0 value
     D  i_newCode                          value  like($$CD)

       //  ... subfile add message ID
     D f_sflAddMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  ... subfile change message ID
     D f_sflChgMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  ... subfile delete message ID
     D f_sflDltMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  ... subfile display message ID
     D f_sflDspMsgID...
     D                 PR              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  ... add message id
     D f_addMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  i_baseMsgF                   10A   value
     D  i_baseLib                    10A   value

       //  ... change message id
     D f_changeMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... delete message id
     D f_deleteMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... display message id
     D f_displayMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  ... copy message id
     D f_copyMsgID...
     D                 PR              N
     D  i_msgID                       7A   value
     D  i_fromMsgF                   10A   value
     D  i_fromLib                    10A   value
     D  i_toMsgF                     10A   value
     D  i_toLib                      10A   value

       //  ... fill subfile record
     D p_sflFilRcd...
     D                 PR
     D  i_rtvm0400_1                       value  likeds(RTVM0400_t)
     D  i_rtvm0400_2                       value  likeds(RTVM0400_t)

       //  ... set action code color attribute
     D p_sflSetCdColor...
     D                 PR
     D  i_cd                               value  like($$CD      )

       //  ... refresh subfile record
     D p_sflRfrRcd...
     D                 PR
     D  i_rrn                        10I 0 value

       //  ... retrieve message description format RTVM0400
     D f_rtvMsgD...
     D                 PR                  likeds(RTVM0400_t)
     D  i_msgId                       7A   value
     D  i_qMsgF                            value like(qobj_t)
     D  i_rtvOpt                     10A   value
     D  o_errCode                          value likeds(errCode_t)

       //  ... create an new (empty) RTVM0300 format
     D f_newRtvm0300...
     D                 PR                  likeds(RTVM0300_t)

       //  ... create an new (empty) RTVM0400 format
     D f_newRtvm0400...
     D                 PR                  likeds(RTVM0400_t)

       //  ... convert string to lower case
     D f_toLower...
     D                 PR          1024A           varying
     D  i_string                   1024A   const   varying

     D f_rtvCmdValues...
     D                 PR          8192A          varying
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //===============================================================*

       //== Global fields ==============================================*
       //    g_sflPage = SFLPAG *  number of unfolded lines per entry
       //    g_sflPage =    5   *    2
       //g_sflPage       S             10I 0 inz(10)
     D g_sflPage       S             10I 0 inz(*hival)
       //    show options
     D g_sflOpt        S             10I 0 inz(1)
     D g_sflNumOpt     S             10I 0 inz(3)
       //    show footer
     D g_sflBot        S             10I 0 inz(1)
     D g_sflNumBot     S             10I 0 inz(2)
       //    subfile control
     D g_sflNumRcd     S             10I 0 inz
     D g_sflMaxRcd     S             10I 0 inz(9999)

       //    format name
     D g_fmtName       S              8A   inz('RTVM0400')

       //    filter options
     D g_filterCpyR    S              1A   inz
     D g_filterCpyL    S              1A   inz
     D g_filterEqual   S              1A   inz
     D g_filterNEqual  S              1A   inz

       //    compare options
     D g_cmpDate       S              1A   inz
     D g_cmpLvl        S              1A   inz

       //    find string
     D g_find          S           1024A   varying inz

       //  Message Description IO (Open Data Paths)
     D g_RTVM0400_1    DS                  likeds(rtvm0400_t) inz
     D g_RTVM0400_2    DS                  likeds(rtvm0400_t) inz

     D g_qMsgF_1       DS                  likeds(qObj_t) inz
     D g_qMsgF_2       DS                  likeds(qObj_t) inz

     D g_msgId_1       S              7A   inz(cMSGID_HIVAL)
     D g_msgId_2       S              7A   inz(cMSGID_HIVAL)

     D g_rtvOpt_1      S             10A   inz(cMSGID_EOF  )
     D g_rtvOpt_2      S             10A   inz(cMSGID_EOF  )

       //===============================================================*

       //===============================================================*
       //   Main procedure (with local variables)
       //===============================================================*
     P f_cmpMsgF...
     P                 B                   export
     D                 PI             1A
     D  i_file1                      10A   const
     D  i_lib1                       10A   const
     D  i_file2                      10A   const
     D  i_lib2                       10A   const
     D  i_range                            const likeds(range_t)
     D  i_cmpDate                     1A   const
     D  i_cmpLvl                      1A   const
     D  i_error                       1A   const

       //  Return value
     D rtnKey          S              1A   inz

       //  Fields
     D isDone          S               N   inz
     D range           DS                  likeds(i_range) inz
     D msg             DS                  likeds(msg_t) inz
     D isConfirmed_F9  S               N   inz

      /COPY QCMPMSGF,USR0017
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       range = i_range;

       //  Set range selection for "*ALL"
       If range.lower = '*ALL';
          range.lower = '*FIRST';
          range.upper = '*LAST';
       Endif;

       //  Validate range selection
       If (%subst(range.lower: 1: 1) <> '*' )  and
          (%subst(range.upper: 1: 1) <> '*' )  and
          (range.lower > range.upper        );
          msg = f_newMsg('USR0018'  :
                        ''         :
                        '*ESCAPE'  );
          p_sndPgmMsg(msg           :
                     cMsg_Prv      :
                     cMsg_ToPgmBdy );
       Endif;

       //  Set screen fields
       ##MSGF1  = i_file1;
       ##LIB1   = i_lib1;
       ##MSGF2  = i_file2;
       ##LIB2   = i_lib2;
       ##POSTO = '';
       ##FIND  = '';

       f_validateScreen();

       //  Display local location name
       $$SYSTEM = f_rtvNetAtrA('LCLLOCNAME');

       //  Set filter options
       If i_error = 'Y';
          g_filterCpyR   = 'Y';
          g_filterCpyL   = 'Y';
          g_filterEqual  = 'N';
          g_filterNEqual = 'Y';
       Else;
          g_filterCpyR   = 'Y';
          g_filterCpyL   = 'Y';
          g_filterEqual  = 'Y';
          g_filterNEqual = 'Y';
       Endif;

       //  Set compare options
       g_cmpDate = i_cmpDate;
       g_cmpLvl  = i_cmpLvl;

       //  Open files and initialize "filter" module
       p_openMsgF1(##MSGF1: ##LIB1);
       p_openMsgF2(##MSGF2: ##LIB2);

       Open CMPMSGFD1;
       p_loadFilter();

       //  Initialize MsgQ Name
       //**                Eval      PGMQ = '_QRNP_PEP_' + sds_pgmProc
       PGMQ = '_CL_PEP';

       //  Remove program messages
       p_rmvPgmMsg(cMsg_Same     :
                  cMsg_ToPgmBdy );

       //  Set initial subfile mode
       SFLMODE = cSflDrop;

       //  Clear indicators
       p_sflClrInd();

       //  Initial load of subfile
       cmd_refresh(range.lower :
                  range.upper );

       //  Loop until no more changes
       isDOne = cFalse;

       Dou isDone;

          //  Set subfile mode
          workstn.sflmode = SFLMODE;

          //  Display messages
          workstn.msgsflend = cFalse;
          Write MSGCTL;

          //  Display "no entries found"
          If not workstn.sfldsp;
             Write EMPTY;
          Endif;

          //  Display options
          workstn.options_1 = cFalse;
          workstn.options_2 = cFalse;
          workstn.options_3 = cFalse;

          Select;
          When g_sflOpt = 2;
             workstn.options_2 = cTrue;
          When g_sflOpt = 3;
             workstn.options_3 = cTrue;
          Other;
             workstn.options_1 = cTrue;
          Endsl;

          //  Display command keys
          Select;
          When g_sflBot = 2;
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
          p_rmvPgmMsg(cMsg_Same     :
                     cMsg_ToPgmBdy );

          //  Keep subfile position
          If SFLCSRRRN > 0;
             SFLRCDNBR = SFLCSRRRN;
          Endif;

          //  Reset confirmation of F9 (Process)
          If screen.AID <> cKeyF9;
             isConfirmed_F9 = cFalse;
          Endif;

          //  Process command key ...
          Select;
             //  ... F3  - End program
          When screen.AID = cKeyF3;
             isDone = cmd_endPgm;
             //  ... F5  - Refresh screen
          When screen.AID = cKeyF5;
             cmd_refresh(range.lower :
                        range.upper );

             //  ... F9  - Process
          When screen.AID = cKeyF9;
             If isConfirmed_F9;
                If not cmd_process(msg);
                   p_sndPgmMsg(msg           :
                              cMsg_Same     :
                              cMsg_ToPgmBdy );
                Endif;
                isConfirmed_F9 = cFalse;
             Else;
                Clear USR0017;
                USR00171 = 'F9';
                msg = f_newMsg('USR0017' :
                              USR0017   );
                p_sndPgmMsg(msg           :
                           cMsg_Same     :
                           cMsg_ToPgmBdy );
                isConfirmed_F9 = cTrue;
             Endif;

             isDOne = cFalse;

             //  ... F12 - End program
          When screen.AID = cKeyF12;
             isDone = cmd_endPgm;

             //  ... F17 - Goto top of subfile
          When screen.AID = cKeyF17;
             cmd_gotoTop();

             //  ... F18 - Goto end of subfile
          When screen.AID = cKeyF18;
             cmd_gotoBot();

             //  ... F19 - Change Filter
          When screen.AID = cKeyF19;
             If f_chgFilter(g_filterCpyR   :
                         g_filterCpyL   :
                         g_filterEqual  :
                         g_filterNEqual ) = cKeyEnter;
                cmd_refresh(range.lower :
                           range.upper );
             Endif;

             //  ... F21 - Command line
          When screen.AID = cKeyF21;
             cmd_cmdLine();

             //  ... F23 - More options
          When screen.AID = cKeyF23;
             cmd_moreOptions();

             //  ... F24 - More keys
          When screen.AID = cKeyF24;
             cmd_moreKeys();

             //  ... ENTER
          When screen.AID = cKeyEnter;
             isDone = cmd_enter(range.lower :
                               range.upper );

             //  ... Page up
          When screen.AID = cKeyPageUp;
             cmd_pageUp();

             //  ... Page down
          When screen.AID = cKeyPageDown;
             cmd_pageDown();

          Other;
             //  ... wrong key
             msg = f_newMsg('USR0001');
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
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
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       ##MSGF1 = g_qMsgF_1.name;
       ##LIB1  = g_qMsgF_1.lib;

       ##MSGF2 = g_qMsgF_2.name;
       ##LIB2  = g_qMsgF_2.lib;

       p_sflInit();

       If p_sflPosKey(i_lowerMsgID);
          f_sflLoadPage(i_lowerMsgID: i_upperMsgID);
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_process
       //===============================================================*
     P cmd_process...
     P                 B
     D                 PI              N
     D  o_msg                                     like(msg_t     )

       //  Local fields
     D rrn             S             10I 0 inz

      /COPY QCMPMSGF,USR0016
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;
          Return cTrue;
       Endif;

       //  Loop through the subfile
       For rrn = 1 to g_sflNumRcd;
          Chain rrn SFL;

          Select;

             //  Copy to the right side
          When $$CD = cCmpCopyRight;
             If not f_copyMsgID($$MSGID:
                             ##MSGF1: ##LIB1:
                             ##MSGF2: ##LIB2);
                Clear USR0016;
                USR00161 = $$MSGID;
                o_msg = f_newMsg('USR0016' :
                                USR0016   );
                p_sflSetErr(SFLRRN);
                Return cFalse;
             Else;
                p_sflRfrRcd(rrn);
             Endif;

             //  Copy to the left side
          When $$CD = cCmpCopyLeft;
             If not f_copyMsgID($$MSGID:
                             ##MSGF2: ##LIB2:
                             ##MSGF1: ##LIB1);
                Clear USR0016;
                USR00161 = $$MSGID;
                o_msg = f_newMsg('USR0016' :
                                USR0016   );
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

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_gotoTop
       //===============================================================*
     P cmd_gotoTop...
     P                 B
     D                 PI

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;

          msg = f_newMsg('USR0007');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );

       Else;
          SFLRCDNBR = 1;
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_gotoBot
       //===============================================================*
     P cmd_gotoBot...
     P                 B
     D                 PI

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;

          msg = f_newMsg('USR0007');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );

       Else;
          SFLRCDNBR = g_sflNumRcd;
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_moreKeys
       //===============================================================*
     P cmd_moreKeys...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If g_sflBot < g_sflNumBot;
          g_sflBot = g_sflBot + 1;
       Else;
          g_sflBot = 1;
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_cmdLine
       //===============================================================*
     P cmd_cmdLine...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       QUSCMDLN();

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_moreOptions
       //===============================================================*
     P cmd_moreOptions...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If g_sflOpt < g_sflNumOpt;
          g_sflOpt = g_sflOpt + 1;
       Else;
          g_sflOpt = 1;
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_enter
       //===============================================================*
     P cmd_enter...
     P                 B
     D                 PI              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value

       //  Return value
     D isDone          S               N   inz

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
     D rrn             S             10I 0 inz
     D isSflDirty      S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       isSflDirty = cFalse;
       isDone     = cTrue;

       //  Validate screen ...
       If not f_validateScreen;
          Return cFalse;
       Endif;

       //  Process MsgF 1 fields ...
       If (##MSGF1 <> g_qMsgF_1.name)  or
          (##LIB1  <> g_qMsgF_1.lib );

          isSflDirty = cTrue;

          If f_isOpenMsgF1;
             p_closeMsgF1();
          Endif;
          p_openMsgF1(##MSGF1: ##LIB1);

       Endif;

       //  Process MsgF 2 fields ...
       If (##MSGF2 <> g_qMsgF_2.name)  or
          (##LIB2  <> g_qMsgF_2.lib );

          isSflDirty = cTrue;

          If f_isOpenMsgF2;
             p_closeMsgF2();
          Endif;
          p_openMsgF2(##MSGF2: ##LIB2);

       Endif;

       //  Find string ...
       If f_toLower(##FIND) <> g_find;
          isDone     = cFalse;
          isSflDirty = cTrue;
          g_find     = %trimR(f_toLower(##FIND));
       Endif;

       //  Refresh subfile if necessary ...
       If isSflDirty;
          cmd_refresh(i_lowerMsgID :
                     i_upperMsgID );
          isDone  = cFalse;
       Endif;

       //  Position to ...
       If ##POSTO <> ' ';
          p_sflPosTo(##POSTO);
          ##POSTO = '';
          isDone  = cFalse;
       Endif;

       //  Process changed records
       If f_sflReadChg;
          isDone = cFalse;
       Endif;

       Return isDone;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_pageUp
       //===============================================================*
     P cmd_pageUp...
     P                 B
     D                 PI

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;
          msg = f_newMsg('USR0007');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );

       Else;
          msg = f_newMsg('USR0005');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  cmd_pageDown
       //===============================================================*
     P cmd_pageDown...
     P                 B
     D                 PI

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;
          msg = f_newMsg('USR0007');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );

       Else;
          msg = f_newMsg('USR0003');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
       Endif;

      /END-FREE
     P                 E

       //===============================================================*
       //  Validate Screen.
       //===============================================================*
     P f_validateScreen...
     P                 B
     D                 PI              N

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       //  Message file 1
       If not f_chkMsgF(##MSGF1: ##LIB1: msg);
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          workstn.msgF1_pc = *on;
          workstn.msgF1_ri = *on;
          workstn.lib1_pc = *on;
          workstn.lib1_ri = *on;
          Return cFalse;
       Endif;

       //  Message file 2
       If not f_chkMsgF(##MSGF2: ##LIB2: msg);
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          workstn.msgF2_pc = *on;
          workstn.msgF2_ri = *on;
          workstn.lib2_pc = *on;
          workstn.lib2_ri = *on;
          Return cFalse;
       Endif;

       //  User should enter different message files
       If (##MSGF1 = ##MSGF2)  and
          (##LIB1  = ##LIB2 );
          msg = f_newMsg('USR0010');
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
          Return cFalse;
       Endif;

       Return cTrue;

      /END-FREE
     P                 E

       //===============================================================*
       //  f_sflReadChg
       //===============================================================*
     P f_sflReadChg...
     P                 B
     D                 PI              N

       //  Return value
     D isChanged       S               N   inz

       //  Local fields
     D msg             DS                  likeds(msg_t) inz
     D sflError        S               N   inz

       //  Message data structures
      /COPY QCMPMSGF,USR0006
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If not workstn.sfldsp;
          Return cFalse;
       Endif;

       //  Loop through the subfile
       isChanged = cFalse;
       sflError  = cFalse;

       Dou sflError;
          Readc SFL;
          If %EOF(CMPMSGFD1);
             Leave;
          Endif;

          isChanged = cTrue;

          //  Remember last record processed
          SFLRCDNBR = SFLRRN;

          //  Process user option ...
          ##OPT = %trim(##OPT);
          //  ... no option
          Select;
          When ##OPT = '';
             //  ... "Copy to left"
          When ##OPT = 'L';
             If H_MSGID2 <> '';
                p_sflChgCode(SFLRRN: cCmpCopyLeft);
             Else;
                p_sflChgCode(SFLRRN: cCmpNoAction);
             Endif;
             //  ... "Copy to right"
          When ##OPT = 'R';
             If H_MSGID1 <> '';
                p_sflChgCode(SFLRRN: cCmpCopyRight);
             Else;
                p_sflChgCode(SFLRRN: cCmpNoAction);
             Endif;
             //  ... "No Action"
          When ##OPT = 'N';
             p_sflChgCode(SFLRRN: cCmpNoAction);
             //  ... "Change left"
          When ##OPT = '21';
             sflError = not f_sflChgMsgID(SFLRRN: 'L');
             //  ... "Copy to left"
          When ##OPT = '31';
             sflError = not f_sflAddMsgID(SFLRRN: 'L');
             //  ... "Delete left"
          When ##OPT = '41';
             sflError = not f_sflDltMsgID(SFLRRN: 'L');
             //  ... "Display left"
          When ##OPT = '51';
             sflError = not f_sflDspMsgID(SFLRRN: 'L');
             //  ... "Change right"
          When ##OPT = '22';
             sflError = not f_sflChgMsgID(SFLRRN: 'R');
             //  ... "Copy to right"
          When ##OPT = '32';
             sflError = not f_sflAddMsgID(SFLRRN: 'R');
             //  ... "Delete right"
          When ##OPT = '42';
             sflError = not f_sflDltMsgID(SFLRRN: 'R');
             //  ... "Display right"
          When ##OPT = '52';
             sflError = not f_sflDspMsgID(SFLRRN: 'R');
             //  ... invalid option
          Other;
             workstn.opt_ri = cTrue;
             sflError = cTrue;

             Clear USR0006;
             USR00061 = ##OPT;
             msg = f_newMsg('USR0006': USR0006);
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
          Endsl;

          //  Update subfile record
          If sflError;
             p_sflSetErr(SFLRRN);
          Else;
             p_sflClrSlc(SFLRRN);
          Endif;

       Enddo;

       Return isChanged;

      /END-FREE
     P f_sflReadChg...
     P                 E

       //===============================================================*
       //  f_sflChkChg
       //===============================================================*
     P f_sflChkChg...
     P                 B
     D                 PI              N
     D o_sflRrn                      10I 0 options(*nopass)

       //  Return value
     D isChanged       S               N   inz

       //  Parameter positions
     D p_sflRrn        C                   const(1)

       //  *  Local fields
     D rrn             S                   like(o_sflRrn  )        inz
     D sfldsp          S                   like(workstn.sfldsp   ) inz
     D sfldspctl       S                   like(workstn.sfldspctl) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       //  If there are no records in the subfile ...
       If not workstn.sfldsp;
          //  ... then
          //      return "no chnages"
          isChanged = cFalse;
          rrn       = 0;
       Else;
          //  ... else
          //      search for a selection <> ' '
          Dou (##OPT <> ''    )  or
             (%EOF(CMPMSGFD1));
             Readc SFL;
             If ##OPT = '';
                p_sflClrSlc(SFLRRN);
             Endif;
          Enddo;
          //      If no selection was found ...
          If %EOF(CMPMSGFD1);
             //      ... then
             //          return "no changes"
             isChanged = cFalse;
             rrn       = 0;
          Else;
             //      ... else
             //          return "changes!"
             isChanged = cTrue;
             rrn       = SFLRRN;

             //          and re-activate subfile record
             workstn.sflnxtchg = cTrue;
             Update SFL;

             sfldsp    = workstn.sfldsp;
             sfldspctl = workstn.sfldspctl;

             workstn.sfldsp    = cTrue;
             workstn.sfldspctl = cFalse;
             WRITE CTL;
             workstn.sfldsp    = sfldsp;
             workstn.sfldspctl = sfldspctl;

          Endif;
       Endif;

       //  Return RRN if passed
       If %parms >= p_sflRrn;
          o_sflRrn = rrn;
       Endif;

       Return isChanged;

      /END-FREE
     P                 E

       //===============================================================*
       //  p_sflInit
       //===============================================================*
     P p_sflInit...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       workstn.sfldsp    = cFalse;
       workstn.sfldspctl = cFalse;
       workstn.sflclr    = cTrue;
       workstn.sflend    = cFalse;
       WRITE CTL;

       workstn.sfldspctl = cTrue;
       workstn.sflclr    = cFalse;

       Reset g_sflPage;
       Reset g_sflBot;
       Reset g_sflNumBot;
       Reset g_sflNumRcd;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflPosKey
       //===============================================================*
     P p_sflPosKey...
     P                 B
     D                 PI              N
     D  i_lowerMsgID                  7A   value

       //  Return value
     D isFound         S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       f_getFirstMsgID(i_lowerMsgID :
                      ##MSGF1      :
                      ##LIB1       :
                      g_msgId_1    );
       g_rtvOpt_1 = cMSGID_SAME;

       f_getFirstMsgID(i_lowerMsgID :
                      ##MSGF2      :
                      ##LIB2       :
                      g_msgId_2    );
       g_rtvOpt_2 = cMSGID_SAME;

       //  Position file Pointer ...
       Dou (g_rtvm0400_1.msgId >= ' ')  or
          (g_rtvm0400_2.msgId >= ' ');
          isFound    = f_sflReadRcd;
          If not isFound;
             Leave;
          Endif;
       Enddo;

       Return isFound;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflReadRcd
       //===============================================================*
     P f_sflReadRcd...
     P                 B
     D                 PI              N

       //  Return value
     D isFound         S               N   inz(cFalse)

       //  Fields
     D errCode_1       DS                  likeds(errCode_t) inz
     D errCode_2       DS                  likeds(errCode_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       errCode_1 = f_newApiErrCode(cTrue);

       //  Retrieve message description of 1. file
       If g_rtvOpt_1 <> cMSGID_EOF;
          g_RTVM0400_1 = f_rtvMsgD(g_msgId_1  :
                                  g_qMsgF_1  :
                                  g_rtvOpt_1 :
                                  errCode_1  );

          If (f_isApiErr(errCode_1)  )  or
             (g_rtvm0400_1.bytAvl = 0);
             g_msgId_1  = cMSGID_HIVAL;
             g_rtvOpt_1 = cMSGID_EOF;
             g_RTVM0400_1 = f_newRtvm0400;
          Else;
             g_msgId_1  = g_rtvm0400_1.msgID;
             g_rtvOpt_1 = '*NEXT';
          Endif;
       Endif;

       errCode_2 = f_newApiErrCode(cTrue);

       //  Retrieve message description of 2. file
       If g_rtvOpt_2 <> cMSGID_EOF;
          g_RTVM0400_2 = f_rtvMsgD(g_msgId_2  :
                                  g_qMsgF_2  :
                                  g_rtvOpt_2 :
                                  errCode_2  );

          If (f_isApiErr(errCode_2)  )  or
             (g_rtvm0400_2.bytAvl = 0);
             g_msgId_2  = cMSGID_HIVAL;
             g_rtvOpt_2 = cMSGID_EOF;
             g_RTVM0400_2 = f_newRtvm0400;
          Else;
             g_msgId_2  = g_rtvm0400_2.msgID;
             g_rtvOpt_2 = '*NEXT';
          Endif;
       Endif;

       //  File 1 has to wait for file 2
       If g_msgId_1 > g_msgId_2;
          If g_rtvOpt_1 <> cMSGID_EOF;
             g_rtvOpt_1 = cMSGID_SAME;
             g_RTVM0400_1 = f_newRtvm0400;
          Endif;
       Endif;

       //  File 2 has to wait for file 1
       If g_msgId_1 < g_msgId_2;
          If g_rtvOpt_2 <> cMSGID_EOF;
             g_rtvOpt_2 = cMSGID_SAME;
             g_RTVM0400_2 = f_newRtvm0400;
          Endif;
       Endif;

       If (g_rtvOpt_1 <> cMSGID_EOF)  or
          (g_rtvOpt_2 <> cMSGID_EOF);
          isFound    = cTrue;
       Else;
          isFound    = cFalse;
       Endif;

       Return isFound;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflLoadPage
       //===============================================================*
     P f_sflLoadPage...
     P                 B

     D f_sflLoadPage...
     D                 PI              N
     D  i_lowerMsgID                  7A   value
     D  i_upperMsgID                  7A   value

       //  Return value
     D isFound         S               N   inz

       //  Local fields
     D isFirstRcd      S               N   inz
     D numRcd          S             10I 0 inz
     D isSelected      S               N   inz

     D msg             DS                  likeds(msg_t) inz

       //  Message data structures
      /COPY QCMPMSGF,USR0009
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       isFirstRcd = cTrue;
       numRcd     = 0;

       Dou (numRcd      >= g_sflPage  )  or
          (g_sflNumRcd >= g_sflMaxRcd)  or
          (not isFound               );
          //
          p_sflFilRcd(g_RTVM0400_1 :
                     g_RTVM0400_2 );

          //  Check upper range value ...
          If i_lowerMsgID = '*FIRST';
             i_lowerMsgID = $$MSGID;
          Endif;

          Select;
             //  ... *ONLY
          When i_upperMsgID = '*ONLY';
             If $$MSGID <> i_lowerMsgID;
                Leave;
             Endif;
             //  ... *LAST
          When i_upperMsgID = '*LAST';
             //  ... specific MsgID
          Other;
             If $$MSGID > i_upperMsgID;
                Leave;
             Endif;
          Endsl;

          //  Process filter options
          Select;
          When (g_filterCpyR   = 'Y'          )   and
             ($$CD           = cCmpCopyRight);
             isSelected = cTrue;
          When (g_filterCpyL   = 'Y'          )   and
             ($$CD           = cCmpCopyLeft );
             isSelected = cTrue;
          When (g_filterEqual  = 'Y'          )   and
             ($$CD           = cCmpEqual    );
             isSelected = cTrue;
          When (g_filterNEqual = 'Y'          )   and
             ($$CD           = cCmpNotEqual );
             isSelected = cTrue;
          Other;
             If $$CD = cCmpNoAction;
                isSelected = cTrue;
             Else;
                isSelected = cFalse;
             Endif;
          Endsl;

          //  Process find string
          If g_find <> '';
             If %scan(g_find:
                f_toLower(f_rtvMsgText(g_RTVM0400_1))) = 0
                and
                %scan(g_find:
                f_toLower(f_rtvMsgText(g_RTVM0400_2))) = 0;
                isSelected = cFalse;
             Endif;
          Endif;

          //  Write to subfile and ...
          If isSelected;
             g_sflNumRcd = g_sflNumRcd + 1;
             SFLRRN      = g_sflNumRcd;
             Write SFL;
             numRcd     = numRcd + 1;

             //  ... position subfile to first new record
             If isFirstRcd;
                isFirstRcd =  cFalse;
                SFLRCDNBR  =  SFLRRN;
             Endif;
          Endif;

          //  Read next record
          isFound = f_sflReadRcd;
       Enddo;

       //  Display subfile
       If numRcd > 0;
          workstn.sfldsp = cTrue;
       Endif;

       //  Set subfile end indicator
       If not isFound;
          workstn.sflend = cTrue;
       Else;
          workstn.sflend = cFalse;
       Endif;

       //  Send warning message
       If g_sflNumRcd >= g_sflMaxRcd;
          Clear USR0009;
          USR00091 = g_sflMaxRcd;
          msg     = f_newMsg('USR0009': USR0009);
          p_sndPgmMsg(msg           :
                     cMsg_Same     :
                     cMsg_ToPgmBdy );
       Endif;

       Return isFound;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflClrSlc
       //===============================================================*
     P p_sflClrSlc...
     P                 B

     D p_sflClrSlc...
     D                 PI
     D  i_sflRrn                     10I 0 const
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       Chain i_sflRrn SFL;
       ##OPT = '';
       workstn.opt_ri    = cFalse;
       workstn.sflnxtchg = cFalse;
       Update SFL;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflSetErr
       //===============================================================*
     P p_sflSetErr...
     P                 B
     D                 PI
     D  i_sflRrn                     10I 0 const
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       Chain i_sflRrn SFL;
       workstn.opt_ri    = cTrue;
       workstn.sflnxtchg = cTrue;
       Update SFL;

       SFLRCDNBR = i_sflRrn;

       Return;

      /END-FREE
     P                 E

       //===============================================================*
       //  sflClrInd
       //===============================================================*
     P p_sflClrInd...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       workstn.msgf1_pc = cFalse;
       workstn.lib1_pc  = cFalse;
       workstn.msgf2_pc = cFalse;
       workstn.lib2_pc  = cFalse;

       workstn.msgf1_ri = cFalse;
       workstn.lib1_ri  = cFalse;
       workstn.msgf2_ri = cFalse;
       workstn.lib2_ri  = cFalse;

       workstn.posto_ri = cFalse;
       workstn.find_ri  = cFalse;

      /END-FREE
     P                 E

       //===============================================================*
       //  Position to ...
       //===============================================================*
     P p_sflPosTo...
     P                 B
     D                 PI
     D  i_posTo                            value  like(##POSTO   )

       //  Local fields
     D lowEnd          S             10I 0 inz
     D highEnd         S             10I 0 inz
     D x               S             10I 0 inz
     D rrn             S             10I 0 inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If g_sflNumRcd > 0;

          lowEnd  = 1;
          highEnd = g_sflNumRcd;

          Dou (lowEnd > highEnd) or (highEnd < lowEnd);
             x = %int((highEnd - lowEnd) / 2);

             rrn = lowEnd + x;
             Chain rrn SFL;

             Select;
             When i_posTo < $$MSGID;
                highEnd = rrn - 1;
             When i_posTo > $$MSGID;
                lowEnd  = rrn + 1;
             Other;
                Leave;
             Endsl;

          Enddo;

          If $$MSGID < i_posTo;
             rrn = rrn + 1;
          Endif;

          Select;
          When rrn <= 0;
             SFLRCDNBR = 1;
          When rrn > g_sflNumRcd;
             SFLRCDNBR = g_sflNumRcd;
          Other;
             SFLRCDNBR= rrn;
          Endsl;

       Endif;

       Return;

      /END-FREE
     P                 E

       //===============================================================*
       //  Check for message ID
       //===============================================================*
     P f_getFirstMsgID...
     P                 B
     D                 PI              N
     D  i_msgId                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msgID                       7A

       //  Return value
     D isFound         S               N   inz(cFalse)

       //  Fields
     D qMsgF           DS                  likeds(qObj_t) inz
     D errCode         DS                  likeds(errCode_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz

       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       qMsgF.name = i_msgF;
       qMsgF.lib  = i_lib;

       //  Retrieve message description
       RTVM0400 = f_rtvMsgD(i_msgId     :
                           qMsgF       :
                           cMSGID_SAME :
                           errCode     );

       If (f_isApiErr(errCode)  )  or
          (rtvm0400.bytAvl   = 0);
          RTVM0400 = f_rtvMsgD(i_msgId  :
                              qMsgF    :
                              '*NEXT'  :
                              errCode  );
          If (f_isApiErr(errCode)  )  or
             (rtvm0400.bytAvl   = 0);
             isFound = cFalse;
          Else;
             isFound = cTrue;
          Endif;
       Else;
          isFound = cTrue;
       Endif;

       If not isFound;
          o_msgID = '';
       Else;
          o_msgID = rtvm0400.msgID;
       Endif;

       Return isFound;

      /END-FREE
     P                 E

       //==================================================================*
       //  Retrieve Message Text
       //==================================================================*
     P f_rtvMsgText...
     P                 B
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  Return Value
     D o_msgText       S           1024A   inz
       //-------------------------------------------------------------------
      /FREE

       If i_rtvm0400.bytAvl = 0;
          o_msgText = '';
       Else;
          If i_rtvm0400.lenMsgR = 0;
             o_msgText = '';
          Else;
             o_msgText = %subst(i_rtvm0400           :
                               i_rtvm0400.ofsMsg + 1:
                               i_rtvm0400.lenMsgR   );
          Endif;
       Endif;

       Return o_msgText;

      /END-FREE
     P                 E

       //==================================================================*
       //  Retrieve Message Help
       //==================================================================*
     P f_rtvMsgHelp...
     P                 B
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  Return Value
     D o_msgHelp       S           1024A   inz
       //-------------------------------------------------------------------
      /FREE

       If i_rtvm0400.bytAvl = 0;
          o_msgHelp = '';
       Else;
          If i_rtvm0400.lenMsgHlpR = 0;
             o_msgHelp = '';
          Else;
             o_msgHelp = %subst(i_rtvm0400              :
                               i_rtvm0400.ofsMsgHlp + 1:
                               i_rtvm0400.lenMsgHlpR   );
          Endif;
       Endif;

       Return o_msgHelp;

      /END-FREE
     P                 E

       //==================================================================*
       //  Retrieve Replacement Variables
       //==================================================================*
     P f_rtvRplVars...
     P                 B
     D                 PI          1024A
     D  i_rtvm0400                         value  likeds(RTVM0400_t)

       //  Return Value
     D o_rplVars       S           1024A   inz

       //  Fields
     D x               S             10I 0 inz

     D rplVar          DS                  qualified            based(pRplVar)
     D  length                       10I 0
     D  decPos                       10I 0
     D  type                         10A
       //-------------------------------------------------------------------
      /FREE

       o_rplVars = '';

       If i_RTVM0400.NUMVARFMT > 0;
          pRplVar = %addr(i_RTVM0400)
                   + i_RTVM0400.OFSVARFMT;

          //  Spin through replacement variables
          For x = 1 to i_RTVM0400.NUMVARFMT;

             o_rplVars = %trimR(o_rplVars) + '(';

             //  ... check type and get length and decimal positions
             Select;
             When rplVar.type = '*QTDCHAR';
                o_rplVars = %trimR(o_rplVars) +
                           %trimR(rplVar.type ) + ' ' +
                           %char(rplVar.length);
             When rplVar.type = '*CHAR';
                o_rplVars = %trimR(o_rplVars) +
                           %trimR(rplVar.type ) + ' ' +
                           %char(rplVar.length);
             When rplVar.type = '*HEX';
                o_rplVars = %trimR(o_rplVars) +
                           %trimR(rplVar.type ) + ' ' +
                           %char(rplVar.length);
             When rplVar.type = '*DEC';
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

      /END-FREE
     P                 E
       //==================================================================*
       //  Open Message File 1
       //==================================================================*
     P p_openMsgF1...
     P                 B
     D                 PI
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Fields
      /COPY QCMPMSGF,USR0012

     D msg             DS                  likeds(msg_t) inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_1 <> '';
          Clear USR0012;
          USR00121 = 1;
          msg = f_newMsg('USR0012'  :
                        USR0012    :
                        '*ESCAPE'  );
          p_sndPgmMsg(msg           :
                     cMsg_Prv      :
                     cMsg_ToMyself );
       Else;
          g_qMsgF_1.name = i_msgF;
          g_qMsgF_1.lib  = f_getMsgFLib(i_msgF: i_lib);
          g_msgId_1      = cMSGID_LOVAL;
          g_rtvOpt_1     = '';
       Endif;

      /END-FREE
     P                 E

       //==================================================================*
       //  Open Message File 2
       //==================================================================*
     P p_openMsgF2...
     P                 B
     D                 PI
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Fields
      /COPY QCMPMSGF,USR0012

     D msg             DS                  likeds(msg_t) inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_2 <> '';
          Clear USR0012;
          USR00121 = 2;
          msg = f_newMsg('USR0012'  :
                        USR0012    :
                        '*ESCAPE'  );
          p_sndPgmMsg(msg           :
                     cMsg_Prv      :
                     cMsg_ToMyself );
       Else;
          g_qMsgF_2.name = i_msgF;
          g_qMsgF_2.lib  = f_getMsgFLib(i_msgF: i_lib);
          g_msgId_2      = cMSGID_LOVAL;
          g_rtvOpt_2     = '';
       Endif;

      /END-FREE
     P                 E

       //==================================================================*
       //  Close Message File 1.
       //==================================================================*
     P p_closeMsgF1...
     P                 B
     D                 PI

       //  Fields
      /COPY QCMPMSGF,USR0013

     D msg             DS                  likeds(msg_t) inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_1 = '';
          Clear USR0013;
          USR00131 = 1;
          msg = f_newMsg('USR0013'  :
                        USR0013    :
                        '*ESCAPE'  );
          p_sndPgmMsg(msg           :
                     cMsg_Prv      :
                     cMsg_ToMyself );
       Else;
          g_msgId_1      = cMSGID_HIVAL;
          g_rtvOpt_1     = cMSGID_EOF;
          g_qMsgF_1.name = '';
          g_qMsgF_1.lib  = '';
       Endif;

      /END-FREE
     P                 E

       //==================================================================*
       //  Close Message File 2.
       //==================================================================*
     P p_closeMsgF2...
     P                 B
     D                 PI

       //  Fields
      /COPY QCMPMSGF,USR0013

     D msg             DS                  likeds(msg_t) inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_2 = '';
          Clear USR0013;
          USR00131 = 2;
          msg = f_newMsg('USR0013'  :
                        USR0013    :
                        '*ESCAPE'  );
          p_sndPgmMsg(msg           :
                     cMsg_Prv      :
                     cMsg_ToMyself );
       Else;
          g_msgId_2      = cMSGID_HIVAL;
          g_rtvOpt_2     = cMSGID_EOF;
          g_qMsgF_2.name = '';
          g_qMsgF_2.lib  = '';
       Endif;

      /END-FREE
     P                 E

       //==================================================================*
       //  Check if Message File 1 is open.
       //==================================================================*
     P f_isOpenMsgF1...
     P                 B
     D                 PI              N

       //  Return value
     D isOpen          S               N   inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_1 = '';
          isOpen = cFalse;
       Else;
          isOpen = cTrue;
       Endif;

       Return isOpen;

      /END-FREE
     P                 E

       //==================================================================*
       //  Check if Message File 2 is open.
       //==================================================================*
     P f_isOpenMsgF2...
     P                 B
     D                 PI              N

       //  Return value
     D isOpen          S               N   inz
       //-------------------------------------------------------------------
      /FREE

       If g_qMsgF_2 = '';
          isOpen = cFalse;
       Else;
          isOpen = cTrue;
       Endif;

       Return isOpen;

      /END-FREE
     P                 E

       //==================================================================*
       //  Get Message File Library.
       //==================================================================*
     P f_getMsgFLib...
     P                 B
     D                 PI            10A
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Return Value
     D lib             S             10A   inz

       //  Fields
     D qObj            DS                  likeds(qObj_t) inz
     D OBJD0100        DS                  likeds(objd0100_t) inz
       //-------------------------------------------------------------------
      /FREE

       qObj.name = i_msgF;
       qObj.lib  = i_lib;

       QUSROBJD(OBJD0100        :
               %size(OBJD0100) :
               'OBJD0100'      :
               qObj            :
               '*MSGF'         );

       lib = OBJD0100.rtnLib;

       Return lib;

      /END-FREE
     P                 E

       //==================================================================*
       //  Check Message File.
       //==================================================================*
     P f_chkMsgF...
     P                 B
     D                 PI              N
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  o_msg                                     like(msg_t     )

       //  Fields
      /COPY QCMPMSGF,USR0014
      /COPY QCMPMSGF,USR0015
       //-------------------------------------------------------------------
      /FREE

       //  Check Library ...
       If i_lib = '';
          i_lib = '*LIBL';
       Endif;

       If %subst(i_lib: 1: 1) <> '*';
          If not f_exist(i_lib: '*LIBL': '*LIB');
             Clear USR0014;
             USR00141 = i_lib;
             o_msg    = f_newMsg('USR0014' :
                                USR0014   );
             Return cFalse;
          Endif;
       Endif;

       //  Check message file ...
       If not f_exist(i_msgF: i_lib: '*MSGF');
          Clear USR0015;
          USR00151 = i_msgF;
          USR00152 = i_lib;
          o_msg    = f_newMsg('USR0015' :
                             USR0015   );
          Return cFalse;
       Endif;

       Return cTrue;

      /END-FREE
     P                 E

       //==================================================================*
       //  Change code.
       //==================================================================*
     P p_sflChgCode...
     P                 B
     D                 PI
     D  i_rrn                        10I 0 value
     D  i_newCode                          value  like($$CD)
       //-------------------------------------------------------------------
      /FREE

       Chain i_rrn SFL;
       $$CD = i_newCode;
       p_sflSetCdColor($$CD);
       Update SFL;

      /END-FREE
     P                 E

       //==================================================================*
       //  Add message ID.
       //==================================================================*
     P f_sflAddMsgID...
     P                 B
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  Return value
     D isAdded         S               N   inz(cFalse)

       //  Fields
     D msg             DS                  likeds(msg_t) inz

       //  Messages
      /COPY QCMPMSGF,USR0022
       //-------------------------------------------------------------------
      /FREE

       Chain i_rrn SFL;

       //  Copy message description ...
       Select;
          //  ... from right to left
       When i_code = 'L';
          If H_MSGID2 <> '';
             isAdded = f_copyMsgID(H_MSGID2:
                                  H_FILE2: H_LIB2:
                                  H_FILE1: H_LIB1);
          Else;
             isAdded = cFalse;
             Clear USR0022;
             USR00221 = $$MSGID;
             USR00222 = H_FILE2;
             USR00223 = H_LIB2;
             msg = f_newMsg('USR0022'  :
                           USR0022    );
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
          Endif;
          //  ... from left to right
       When i_code = 'R';
          If H_MSGID1 <> '';
             isAdded = f_copyMsgID(H_MSGID1:
                                  H_FILE1: H_LIB1:
                                  H_FILE2: H_LIB2);
          Else;
             isAdded = cFalse;
             Clear USR0022;
             USR00221 = $$MSGID;
             USR00222 = H_FILE1;
             USR00223 = H_LIB1;
             msg = f_newMsg('USR0022'  :
                           USR0022    );
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
          Endif;
          //  ... invalid code
       Other;
          isAdded = cFalse;
       Endsl;

       If isAdded;
          p_sflRfrRcd(i_rrn);
       Endif;

       Return isAdded;

      /END-FREE
     P                 E

       //==================================================================*
       //  Change message ID.
       //==================================================================*
     P f_sflChgMsgID...
     P                 B
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  Return value
     D isChanged       S               N   inz(cFalse)
       //-------------------------------------------------------------------
      /FREE

       Chain i_rrn SFL;

       Select;
       When i_code = 'L';
          isChanged = f_changeMsgID(H_MSGID1:
                                   H_FILE1 :
                                   H_LIB1  );
       When i_code = 'R';
          isChanged = f_changeMsgID(H_MSGID2:
                                   H_FILE2 :
                                   H_LIB2  );
       Other;
          isChanged = cFalse;
       Endsl;

       If isChanged;
          p_sflRfrRcd(i_rrn);
       Endif;

       Return isChanged;

      /END-FREE
     P                 E

       //==================================================================*
       //  Delete message ID.
       //==================================================================*
     P f_sflDltMsgID...
     P                 B
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  Return value
     D isDeleted       S               N   inz(cFalse)
       //-------------------------------------------------------------------
      /FREE

       Chain i_rrn SFL;

       Select;
       When i_code = 'L';
          isDeleted = f_deleteMsgID(H_MSGID1:
                                   H_FILE1 :
                                   H_LIB1  );
       When i_code = 'R';
          isDeleted = f_deleteMsgID(H_MSGID2:
                                   H_FILE2 :
                                   H_LIB2  );
       Other;
          isDeleted = cFalse;
       Endsl;

       If isDeleted;
          p_sflRfrRcd(i_rrn);
       Endif;

       Return isDeleted;

      /END-FREE
     P                 E

       //==================================================================*
       //  Display message ID.
       //==================================================================*
     P f_sflDspMsgID...
     P                 B
     D                 PI              N
     D  i_rrn                        10I 0 value
     D  i_code                        1A   value

       //  Return value
     D isDisplayed     S               N   inz(cFalse)
       //-------------------------------------------------------------------
      /FREE

       Chain i_rrn SFL;

       Select;
       When i_code = 'L';
          isDisplayed = f_displayMsgID(H_MSGID1:
                                      H_FILE1 :
                                      H_LIB1  );
       When i_code = 'R';
          isDisplayed = f_displayMsgID(H_MSGID2:
                                      H_FILE2 :
                                      H_LIB2  );
       Other;
          isDisplayed = cFalse;
       Endsl;

       Return isDisplayed;

      /END-FREE
     P                 E

       //==================================================================*
       //  Copy Message ID.
       //==================================================================*
     P f_copyMsgID...
     P                 B
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_fromMsgF                   10A   value
     D  i_fromLib                    10A   value
     D  i_toMsgF                     10A   value
     D  i_toLib                      10A   value

       //  Return value
     D isCopied        S               N   inz

       //  Fields
     D cmd             S            512A   inz
       //-------------------------------------------------------------------
      /FREE

       cmd = 'MRGMSGF ' +
            'FROMMSGF(' +
               %trim(i_fromLib) +
               '/' +
               %trim(i_fromMsgF) +
               ') ' +
            'TOMSGF(' +
               %trim(i_toLib) +
               '/' +
               %trim(i_toMsgF) +
               ') ' +
            'RPLMSGF(' +
               %trim('*NONE') +
               ') ' +
            'SELECT(' +
               %trim(i_msgID) +
               ') ';
       If system(cmd) <> 0;
          isCopied = cFalse;
       Else;
          isCopied = cTrue;
       Endif;

       Return isCopied;

      /END-FREE
     P                 E

       //==================================================================*
       //  Add Message ID.
       //==================================================================*
     P f_addMsgID...
     P                 B
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value
     D  i_baseMsgF                   10A   value
     D  i_baseLib                    10A   value

       //  Return value
     D isAdded         S               N   inz

       //  Fields
     D cmd             S            512A   inz
       //-------------------------------------------------------------------
      /FREE

       cmd = '?ADDMSGD ' +
            '?*MSGID(' +
               %trim(i_msgID) +
               ') ' +
            '?*MSGF(' +
               %trim(i_lib) +
               '/' +
               %trim(i_msgF) +
               ') ' +
            f_rtvCmdValues(i_msgID:
                           i_baseMsgF: i_baseLib);
       If system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801';
          isAdded = cFalse;
       Else;
          isAdded = cTrue;
       Endif;

       Return isAdded;

      /END-FREE
     P                 E

       //==================================================================*
       //  Change Message ID.
       //==================================================================*
     P f_changeMsgID...
     P                 B
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Return value
     D isChanged       S               N   inz

       //  Fields
     D cmd             S           8192A   inz
     D msgHelp         S           1024A   inz
     D rplVars         S           1024A   inz
     D qMsgF           DS                  likeds(qObj_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D errCode         DS                  likeds(errCode_t) inz
       //-------------------------------------------------------------------
      /FREE

       qMsgF.name = i_msgF;
       qMsgF.lib  = i_lib;
       RTVM0400 = f_rtvMsgD(i_msgID     :
                           qMsgF       :
                           cMSGID_SAME :
                           errCode     );

       If (f_isApiErr(errCode))  or
          (RTVM0400.bytAvl = 0);
          isChanged = cFalse;
       Else;

          //  Get second level text
          msgHelp = f_rtvMsgHelp(RTVM0400);
          If msgHelp = '';
             msgHelp = '*N';
          Else;
             msgHelp = cQuote + %trimR(msgHelp) + cQuote;
          Endif;

          //  Get replacement variables
          rplVars = f_rtvRplVars(RTVM0400);
          If rplVars = '';
             rplVars = '*N';
          Endif;

          //  Produce CHGMSGD command
          cmd = '?CHGMSGD ' +
               '?*MSGID(' +
                  %trim(i_msgID) +
                  ') ' +
               '?*MSGF(' +
                  %trim(i_lib) +
                  '/' +
                  %trim(i_msgF) +
                  ') ' +
               f_rtvCmdValues(i_msgID: i_msgF: i_lib);
          If system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801';
             isChanged = cFalse;
          Else;
             isChanged = cTrue;
          Endif;
       Endif;

       Return isChanged;

      /END-FREE
     P                 E

       //==================================================================*
       //  Delete Message ID.
       //==================================================================*
     P f_deleteMsgID...
     P                 B
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Return value
     D isDeleted       S               N   inz

       //  Fields
     D cmd             S            512A   inz
       //-------------------------------------------------------------------
      /FREE

       cmd = '?RMVMSGD ' +
            '?*MSGID(' +
               %trim(i_msgID) +
               ') ' +
            '?*MSGF(' +
               %trim(i_lib) +
               '/' +
               %trim(i_msgF) +
               ') ';
       If system(cmd) <> 0 and EXCP_MSGID <> 'CPF6801';
          isDeleted = cFalse;
       Else;
          isDeleted = cTrue;
       Endif;

       Return isDeleted;

      /END-FREE
     P                 E

       //==================================================================*
       //  Display Message ID.
       //==================================================================*
     P f_displayMsgID...
     P                 B
     D                 PI              N
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Return value
     D isDisplayed     S               N   inz

       //  Fields
     D cmd             S            512A   inz
       //-------------------------------------------------------------------
      /FREE

       cmd = 'DSPMSGD ' +
            'RANGE(' +
               %trim(i_msgID) +
               ') ' +
            'MSGF(' +
               %trim(i_lib) +
               '/' +
               %trim(i_msgF) +
               ') ';
       If system(cmd) <> 0;
          isDisplayed = cFalse;
       Else;
          isDisplayed = cTrue;
       Endif;

       Return isDisplayed;

      /END-FREE
     P                 E

       //==================================================================*
       //  Fill Subfile Record.
       //==================================================================*
     P p_sflFilRcd...
     P                 B
     D                 PI
     D  i_rtvm0400_1                       value  likeds(RTVM0400_t)
     D  i_rtvm0400_2                       value  likeds(RTVM0400_t)

       //  Fields
     D                 DS
     D date7$                         7A
     D date7                          7S 0 inz overlay(date7$: 1)
     D mod_1           DS                  qualified
     D  crtDate                        D   inz
     D  crtLvl                       10I 0 inz
     D  modDate                        D   inz
     D  modLvl                       10I 0 inz
     D mod_2           DS                  qualified
     D  crtDate                        D   inz
     D  crtLvl                       10I 0 inz
     D  modDate                        D   inz
     D  modLvl                       10I 0 inz
       //-------------------------------------------------------------------
      /FREE

       //  Compare date : Y/N
       If g_cmpDate = 'Y';
          //            keep information
       Else;
          i_RTVM0400_1.crtDate = cLowDat7;
          i_RTVM0400_1.modDate = cLowDat7;
          i_RTVM0400_2.crtDate = cLowDat7;
          i_RTVM0400_2.modDate = cLowDat7;
       Endif;

       //  Compare level: Y/N
       If g_cmpLvl  = 'Y';
          //            keep information
       Else;
          i_RTVM0400_1.crtLvlNbr = 0;
          i_RTVM0400_1.modLvlNbr = 0;
          i_RTVM0400_2.crtLvlNbr = 0;
          i_RTVM0400_2.modLvlNbr = 0;
       Endif;

       //  Create creation/modification level data structure
       date7$ = i_RTVM0400_1.crtDate;
      /END-FREE
     C     *CYMD         Move      date7         mod_1.crtDate
      /FREE
       date7$ = i_RTVM0400_1.modDate;
      /END-FREE
     C     *CYMD         Move      date7         mod_1.modDate

      /FREE
       mod_1.crtLvl = i_RTVM0400_1.crtLvlNbr;
       mod_1.modLvl = i_RTVM0400_1.modLvlNbr;

       date7$ = i_RTVM0400_2.crtDate;
      /END-FREE
     C     *CYMD         Move      date7         mod_2.crtDate
      /FREE
       date7$ = i_RTVM0400_2.modDate;
      /END-FREE
     C     *CYMD         Move      date7         mod_2.modDate

      /FREE
       mod_2.crtLvl = i_RTVM0400_2.crtLvlNbr;
       mod_2.modLvl = i_RTVM0400_2.modLvlNbr;

       //  Set subfile hidden fields ...
       H_MSGID1 = i_RTVM0400_1.msgId;
       H_FILE1  = g_qMsgF_1.name;
       H_LIB1   = g_qMsgF_1.lib;
       H_MSGID2 = i_RTVM0400_2.msgId;
       H_FILE2  = g_qMsgF_2.name;
       H_LIB2   = g_qMsgF_2.lib;

       //  Set subfile fields ...
       ##OPT          = '';
       workstn.opt_ri = cFalse;

       If i_RTVM0400_1.msgId <> '';
          $$MSGID   = i_RTVM0400_1.msgId;
       Else;
          $$MSGID   = i_RTVM0400_2.msgId;
       Endif;

       $$TEXT1   = f_rtvMsgText(i_RTVM0400_1);
       $$HELP1   = f_rtvMsgHelp(i_RTVM0400_1);

       $$TEXT2   = f_rtvMsgText(i_RTVM0400_2);
       $$HELP2   = f_rtvMsgHelp(i_RTVM0400_2);

       //  ... determine action code
       Select;
          //      ... no-action     (missing both descriptions)
       When i_RTVM0400_1.msgId = '' and
          i_RTVM0400_2.msgId = '';
          $$CD = cCmpNoAction;
          //      ... copy-to-left  (missing left description)
       When i_RTVM0400_1.msgId = '';
          $$CD = cCmpCopyLeft;
          //      ... copy-to-right (missing right description)
       When i_RTVM0400_2.msgId = '';
          $$CD = cCmpCopyRight;
       Other;
          //      ... others
          If i_RTVM0400_1 = i_RTVM0400_2;
             //          ... equal descriptions
             $$CD = cCmpEqual;
          Else;

             //          ... not equal so ...
             Select;
                //              ... copy-to-left
             When mod_2 > mod_1;
                $$CD = cCmpCopyLeft;
                //              ... copy-to-right
             When mod_1 > mod_2;
                $$CD = cCmpCopyRight;
                //              ... don't know what to do
             Other;
                $$CD = cCmpNotEqual;
             Endsl;

          Endif;
       Endsl;

       p_sflSetCdColor($$CD);

      /END-FREE
     P                 E

       //==================================================================*
       //  Set Code Color.
       //==================================================================*
     P p_sflSetCdColor...
     P                 B
     D                 PI
     D  i_cd                               value  like($$CD      )
       //-------------------------------------------------------------------
      /FREE

       workstn.cd_white = *off;
       workstn.cd_grn   = *off;
       workstn.cd_ylw   = *off;
       workstn.cd_red   = *off;

       Select;
       When i_cd = cCmpCopyLeft;
          workstn.cd_ylw = *on;
       When i_cd = cCmpCopyRight;
          workstn.cd_ylw = *on;
       When i_cd = cCmpNotEqual;
          workstn.cd_red = *on;
       Other;
          workstn.cd_white = *on;
       Endsl;

      /END-FREE
     P                 E

       //==================================================================*
       //  Refresh Subfile Record.
       //==================================================================*
     P p_sflRfrRcd...
     P                 B
     D                 PI
     D  i_rrn                        10I 0 value

       //  Fields
     D qMsgF_1         DS                  likeds(qObj_t) inz
     D qMsgF_2         DS                  likeds(qObj_t) inz
     D rtvm0400_1      DS                  likeds(rtvm0400_t) inz
     D rtvm0400_2      DS                  likeds(rtvm0400_t) inz
     D errCode_1       DS                  likeds(errCode_t) inz
     D errCode_2       DS                  likeds(errCode_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       //  Retrieve message description of 1. file
       qMsgF_1.name = ##MSGF1;
       qMsgF_1.lib  = ##LIB1;
       RTVM0400_1 = f_rtvMsgD($$MSGID     :
                             qMsgF_1     :
                             cMSGID_SAME :
                             errCode_1   );

       If (f_isApiErr(errCode_1)  )  or
          (rtvm0400_1.bytAvl = 0  );
          rtvm0400_1 = f_newRtvm0400;
       Endif;

       //  Retrieve message description of 2. file
       qMsgF_2.name = ##MSGF2;
       qMsgF_2.lib  = ##LIB2;
       rtvm0400_2 = f_rtvMsgD($$MSGID     :
                             qMsgF_2     :
                             cMSGID_SAME :
                             errCode_2   );

       If (f_isApiErr(errCode_2)  )  or
          (rtvm0400_2.bytAvl = 0  );
          rtvm0400_2 = f_newRtvm0400;
       Endif;

       Chain i_rrn SFL;

       p_sflFilRcd(RTVM0400_1 :
                  RTVM0400_2 );

       Update SFL;

      /END-FREE
     P                 E

       //==================================================================*
       //  Retrieve Message Description.
       //==================================================================*
     P f_rtvMsgD...
     P                 B
     D                 PI                  likeds(rtvm0400_t)
     D  i_msgId                       7A   value
     D  i_qMsgF                            value like(qobj_t)
     D  i_rtvOpt                     10A   value
     D  o_errCode                          value likeds(errCode_t)

       //  Fields
     D RTVM0300        DS                  likeds(rtvm0300_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D msg             DS                  likeds(msg_t) inz
     D sizeAdj         S             10I 0 inz static
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       RTVM0400 = f_newRtvm0400;
       o_errCode  = f_newApiErrCode(cTrue);

       //  Retrieve message description
       If g_fmtName = 'RTVM0400';
          QMHRTVM(RTVM0400            :
                 %size(RTVM0400)     :
                 g_fmtName           :
                 i_msgId             :
                 i_qMsgF             :
                 ''                  :
                 0                   :
                 '*NO'               :
                 '*YES'              :
                 o_errCode           :
                 i_rtvOpt            :
                 0                   :
                 0                   );

          If o_errCode.excId = 'CPF3C21';
             sizeAdj   = %size(RTVM0400) - %size(RTVM0300);
             g_fmtName = 'RTVM0300';
             msg = f_newMsg('USR0021');
             p_sndPgmMsg(msg           :
                        cMsg_Same     :
                        cMsg_ToPgmBdy );
          Endif;
       Endif;

       If g_fmtName = 'RTVM0300';
          RTVM0300 = f_newRtvm0300;
          QMHRTVM(RTVM0300            :
                 %size(RTVM0300)     :
                 g_fmtName           :
                 i_msgId             :
                 i_qMsgF             :
                 ''                  :
                 0                   :
                 '*NO'               :
                 '*YES'              :
                 o_errCode           :
                 i_rtvOpt            :
                 0                   :
                 0                   );
          RTVM0400 = f_newRtvm0400;
          RTVM0400.BYTRET = RTVM0300.BYTRET;
          RTVM0400.BYTAVL = RTVM0300.BYTAVL;
          RTVM0400.MSGSEV = RTVM0300.MSGSEV;
          RTVM0400.ALTIDX = RTVM0300.ALTIDX;
          RTVM0400.ALTOPT = RTVM0300.ALTOPT;
          RTVM0400.LOGIND = RTVM0300.LOGIND;
          RTVM0400.MSGID = RTVM0300.MSGID;
          RTVM0400.reserved_01 = RTVM0300.reserved_01;

          RTVM0400.NUMVARFMT = RTVM0300.NUMVARFMT;
          RTVM0400.CSINDTXT = RTVM0300.CSINDTXT;
          RTVM0400.CSINDDTA = RTVM0300.CSINDDTA;
          RTVM0400.CCSIDTXT = RTVM0300.CCSIDTXT;
          RTVM0400.OFSDFTR = RTVM0300.OFSDFTR +
                                        sizeAdj;
          RTVM0400.LENDFTRPYR = RTVM0300.LENDFTRPYR;
          RTVM0400.LENDFTRPYA = RTVM0300.LENDFTRPYA;
          RTVM0400.OFSMSG = RTVM0300.OFSMSG  +
                                        sizeAdj;
          RTVM0400.LENMSGR = RTVM0300.LENMSGR;
          RTVM0400.LENMSGA = RTVM0300.LENMSGA;
          RTVM0400.OFSMSGHLP = RTVM0300.OFSMSGHLP +
                                          sizeAdj;
          RTVM0400.LENMSGHLPR = RTVM0300.LENMSGHLPR;
          RTVM0400.LENMSGHLPA = RTVM0300.LENMSGHLPA;
          RTVM0400.OFSVARFMT = RTVM0300.OFSVARFMT +
                                          sizeAdj;
          RTVM0400.LENVARFMTR = RTVM0300.LENVARFMTR;
          RTVM0400.LENVARFMTA = RTVM0300.LENVARFMTA;
          RTVM0400.LENVARFMTE = RTVM0300.LENVARFMTE;
          RTVM0400.DATA = RTVM0300.DATA;
       Endif;

       If RTVM0400.crtDate = '';
          RTVM0400.crtDate = cLowDat7;
       Endif;

       If RTVM0400.modDate = '';
          RTVM0400.modDate = cLowDat7;
       Endif;

       Return RTVM0400;

      /END-FREE
     P                 E

       //==================================================================*
       //  Create a new RTVM0300 format.
       //==================================================================*
     P f_newRtvm0300...
     P                 B
     D                 PI                  likeds(RTVM0300_t)

       //  Fields
     D RTVM0300        DS                  likeds(rtvm0300_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       Clear RTVM0300;

       Return RTVM0300;

      /END-FREE
     P f_newRtvm0300...
     P                 E

       //==================================================================*
       //  Create a new RTVM0400 format.
       //==================================================================*
     P f_newRtvm0400...
     P                 B
     D                 PI                  likeds(RTVM0400_t)

       //  Fields
     D RTVM0400        DS                  likeds(rtvm0400_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       Clear RTVM0400;

       RTVM0400.crtDate = cLowDat7;
       RTVM0400.modDate = cLowDat7;

       Return RTVM0400;

      /END-FREE
     P                 E

       //==================================================================*
       //  Convert string to lower case.
       //==================================================================*
     P f_toLower...
     P                 B
     D                 PI          1024A          varying
     D  i_string                   1024A   const  varying

       //  Return value
     D  lowerString    S           1024A   varying inz

       //  Conversion constants
     D lc              C                   const('abcdefghijklmnopqrstuvwxyz')
     D uc              C                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       If %len(i_string) > 0;
          lowerString = %xlate(uc: lc: i_string);
       Else;
          lowerString = '';
       Endif;

       Return lowerString;

      /END-FREE
     P                 E

       //==================================================================*
       //  Retrieve command values
       //==================================================================*
     P f_rtvCmdValues...
     P                 B
     D                 PI          8192A          varying
     D  i_msgID                       7A   value
     D  i_msgF                       10A   value
     D  i_lib                        10A   value

       //  Return value
     D cmdValues       S           8192A   varying inz

       //  Fields
     D msgHelp         S           1024A   inz
     D rplVars         S           1024A   inz
     D qMsgF           DS                  likeds(qObj_t) inz
     D rtvm0400        DS                  likeds(rtvm0400_t) inz
     D errCode         DS                  likeds(errCode_t) inz
       //-------------------------------------------------------------------
      /FREE

       qMsgF.name = i_msgF;
       qMsgF.lib  = i_lib;
       RTVM0400 = f_rtvMsgD(i_msgID     :
                           qMsgF       :
                           cMSGID_SAME :
                           errCode     );

       If (f_isApiErr(errCode))  or
          (RTVM0400.bytAvl = 0);
          cmdValues = '';
       Else;

          //  Get second level text
          msgHelp = f_rtvMsgHelp(RTVM0400);
          If msgHelp = '';
             msgHelp = '*N';
          Else;
             msgHelp = cQuote + %trimR(msgHelp) + cQuote;
          Endif;

          //  Get replacement variables
          rplVars = f_rtvRplVars(RTVM0400);
          If rplVars = '';
             rplVars = '*N';
          Endif;

          //  Produce CHGMSGD command
          cmdValues = ' ' +
               'MSG(' +
                  cQuote +
                     %trimR(f_rtvMsgText(RTVM0400)) +
                  cQuote +
                  ') ' +
               'SECLVL(' +
                  %trimR(msgHelp) +
                  ') ' +
               'FMT(' +
                  %trimR(rplVars) +
                  ') ' +
               'SEV(' +
                  %char(RTVM0400.MSGSEV) +
                  ') ';

       Endif;

       Return cmdValues;

      /END-FREE
     P                 E

