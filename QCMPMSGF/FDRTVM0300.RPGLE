      /if not defined(rtvm0300_t)
      /define rtvm0300_t
      *===============================================================*
      *  QMHRTVM API - RTVM0300                                       *
      *===============================================================*
      *
     d rtvm0300_t      ds                  qualified           based(pDummy)
      *  Bytes returned
     d  bytRet                       10i 0
      *  Bytes available
     d  bytAvl                       10i 0
      *  Message severity
     d  msgSev                       10i 0
      *  Alert index
     d  altIdx                       10i 0
      * Alert Option
     d  altOpt                        9a
      * Log indicator
     d  logInd                        1a
      * Message ID
     d  msgID                         7a
      * Reserved
     d  reserved_01                   3a
      * Nbr. of subst. var. formats
     d  numVarFmt                    10i 0
      * CCSID conv. stat. ind. text
     d  csIndTxt                     10i 0
      * CCSID conv. stat. ind. data
     d  csIndDta                     10i 0
      * CCSID of Text returned
     d  ccsidTxt                     10i 0
      * Offset of default reply
     d  ofsDftR                      10i 0
      * Length of default reply ret.
     d  lenDftRpyR                   10i 0
      * Length of default reply avl.
     d  lenDftRpyA                   10i 0
      * Offset of message
     d  ofsMsg                       10i 0
      * Length of message returned
     d  lenMsgR                      10i 0
      * Length of message available
     d  lenMsgA                      10i 0
      * Offset of message
     d  ofsMsgHlp                    10i 0
      * Length of message help ret.
     d  lenMsgHlpR                   10i 0
      * Length of message help avl.
     d  lenMsgHlpA                   10i 0
      * Ofs. of subst. var. formats
     d  ofsVarFmt                    10i 0
      * Length subst. var. fmt. ret.
     d  lenVarFmtR                   10i 0
      * Length subst. var. fmt. avl.
     d  lenVarFmtA                   10i 0
      * Length subst. var. element
     d  lenVarFmtE                   10i 0
      * Data
     d  data                       4096A
      *                       CHAR(*)  Default reply
      *                       CHAR(*)  Message
      *                       CHAR(*)  Message help
      *                       CHAR(*)  Substitution variable formats
      *
      /endif
