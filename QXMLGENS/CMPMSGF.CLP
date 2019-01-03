/* -------------------------------------------------------------------------- */
/* CMPMSGF    - SCRIPT MEMBER                                                 */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENCMD  XCMD(DLTCMD CMD(&TOLIB/CMPMSGF))

             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/CMPMSGFD1 ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/CMPMSGFD2 ))

             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDERRCODE ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDGLSTHDR ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDMSG     ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDOBJD0100))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDQOBJ    ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDRTVM0300))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDRTVM0400))

             XMLGENCMD  XCMD(DLTMSGF MSGF(&TOLIB/CMPMSGF  ))

             XMLGENCMD  XCMD(CRTMSGF MSGF(&TOLIB/CMPMSGF  ) +
                          TEXT('Tool: CMPMSGF    (Compare +
                          Message File    )'))

             XMLGENMBR  XMBR(A_MSG_ENG) XMBRATR(CLP) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*PGM) +
                          XGENCRT(*YES) XPARAM(*BLANK)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_MSG_ENG) PARM('&TOLIB'))

             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_MSG_ENG))

             XMLGENMBR  XMBR(XDERRCODE ) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDGLSTHDR ) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDMSG     ) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDOBJD0100) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDQOBJ    ) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDRTVM0300) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(XDRTVM0400) XMBRATR(PF   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*YES) XPARAM('MAXMBRS(1)  +
                                                SIZE(1 0 0)')

             XMLGENMBR  XMBR(USR0001   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0002   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0003   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0004   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0005   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0006   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0007   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0008   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0009   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0010   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0011   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0012   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0013   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0014   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0015   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0016   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0017   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0018   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0019   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0020   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0021   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0022   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFC  ) XMBRATR(MAKPGM) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFC1 ) XMBRATR(CLLE ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFD1 ) XMBRATR(DSPF ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*YES) XPARAM('RSTDSP(*YES)')

             XMLGENMBR  XMBR(CMPMSGFD2 ) XMBRATR(DSPF ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*YES) XPARAM('RSTDSP(*YES)')

             XMLGENMBR  XMBR(CMPMSGFP  ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*YES) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CMPMSGFR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFR2 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFR3 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(CMPMSGFR4 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENCMD  XCMD(CRTCLMOD MODULE(&TOLIB/CMPMSGFC1) +
                          SRCFILE(&TOLIB/QCMPMSGF) SRCMBR(*MODULE) +
                          DBGVIEW(*LIST))

             XMLGENCMD  XCMD(CRTRPGMOD MODULE(&TOLIB/CMPMSGFR1) +
                          SRCFILE(&TOLIB/QCMPMSGF) SRCMBR(*MODULE) +
                          DBGVIEW(*LIST) TRUNCNBR(*NO))

             XMLGENCMD  XCMD(CRTRPGMOD MODULE(&TOLIB/CMPMSGFR2) +
                          SRCFILE(&TOLIB/QCMPMSGF) SRCMBR(*MODULE) +
                          DBGVIEW(*LIST) TRUNCNBR(*NO))

             XMLGENCMD  XCMD(CRTRPGMOD MODULE(&TOLIB/CMPMSGFR3) +
                          SRCFILE(&TOLIB/QCMPMSGF) SRCMBR(*MODULE) +
                          DBGVIEW(*LIST) TRUNCNBR(*NO))

             XMLGENCMD  XCMD(CRTPGM PGM(&TOLIB/CMPMSGFC) +
                          MODULE(&TOLIB/CMPMSGFC1 &TOLIB/CMPMSGFR1  +
                                                  &TOLIB/CMPMSGFR2  +
                                                  &TOLIB/CMPMSGFR3) +
                          TEXT(*ENTMODTXT) ENTMOD(&TOLIB/CMPMSGFC1) +
                          USRPRF(*USER) ACTGRP(*NEW      ) +
                          BNDDIR(QC2LE) )

             XMLGENMBR  XMBR(CMPMSGF   ) XMBRATR(CMD  ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*YES) XPARAM(*BLANK)

             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDERRCODE ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDGLSTHDR ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDMSG     ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDOBJD0100))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDQOBJ    ))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDRTVM0300))
             XMLGENCMD  XCMD(DLTF FILE(&TOLIB/XDRTVM0400))

             XMLGENCMD  XCMD(DLTMOD MODULE(&TOLIB/CMPMSGFC1))
             XMLGENCMD  XCMD(DLTMOD MODULE(&TOLIB/CMPMSGFR1))
             XMLGENCMD  XCMD(DLTMOD MODULE(&TOLIB/CMPMSGFR2))
             XMLGENCMD  XCMD(DLTMOD MODULE(&TOLIB/CMPMSGFR3))

