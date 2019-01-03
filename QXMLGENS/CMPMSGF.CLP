/* -------------------------------------------------------------------------- */
/* CMPMSGF    - SCRIPT MEMBER                                                 */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QCMPMSGF) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QCMPMSGF)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(TXT   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG ) XMBRATR(CLP) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT   ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

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
                          XGENCRT(*NO) XPARAM('RSTDSP(*YES)')

             XMLGENMBR  XMBR(CMPMSGFD2 ) XMBRATR(DSPF ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM('RSTDSP(*YES)')

             XMLGENMBR  XMBR(CMPMSGFE  ) XMBRATR(CMD  ) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CMPMSGFPE ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO) XPARAM(*BLANK)

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

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDMSG     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDOBJD0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDQOBJ    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDRTVM0300) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDRTVM0400) XMBRATR(RPGLE) +
                          XFROMSRCF(QCMPMSGF  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCMPMSGF  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

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

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QCMPMSGF) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' 'ENG'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

