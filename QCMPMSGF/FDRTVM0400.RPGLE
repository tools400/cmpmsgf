      /if not defined(rtvm0400_t)
      /define rtvm0400_t
      *===============================================================*
      *  QMHRTVM API - RTVM0400                                       *
      *===============================================================*
      *
     d rtvm0400_t      ds                  qualified           based(pDummy)
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
      * Reply type
     d  rpyType                      10a
      * Reserved
     d  reserved_02                   2a
      * Maximum reply length
     d  maxRpyLen                    10i 0
      * Maximum reply decimal positions
     d  maxRpyDecPos                 10i 0
      * Offset of valid reply value entries
     d  ofsRpyE                      10i 0
      * Number of valid reply values entries returned
     d  numRpyER                     10i 0
      * Length of valid reply value entries returned
     d  lenRpyER                     10i 0
      * Length of valid reply value entries available
     d  lenRpyEA                     10i 0
      * Length of valid reply value entry
     d  lenRpyE                      10i 0
      * Offset of special reply value entries
     d  ofsSpcRpyE                   10i 0
      * Number of special reply values returned
     d  numSpcRpyER                  10i 0
      * Length of special reply value entries returned
     d  lenSpcRpyER                  10i 0
      * Length of special reply value entries available
     d  lenSpcRpyEA                  10i 0
      * Length of special reply value entry
     d  lenSpcRpyE                   10i 0
      * Offset of lower range reply value
     d  ofsLowRpyE                   10i 0
      * Length of lower range reply value returned
     d  lenLowRpyER                  10i 0
      * Length of lower range reply value available
     d  lenLowRpyEA                  10i 0
      * Offset of upper range reply value
     d  ofsUpRpyE                    10i 0
      * Length of upper range reply value returned
     d  ofsUpRpyER                   10i 0
      * Length of upper range reply value available
     d  ofsUpRpyEA                   10i 0
      * Offset of relational test entry
     d  ofsRelTestE                  10i 0
      * Length of relational test entry returned
     d  lenRelTestER                 10i 0
      * Length of relational test entry available
     d  lenRelTestEA                 10i 0
      * Message creation date
     d  crtDate                       7a
      * Reserved
     d  reserved_03                   1a
      * Message creation level number
     d  crtLvlNbr                    10i 0
      * Message modification date
     d  modDate                       7a
      * Reserved
     d  reserved_04                   1a
      * Message modification level number
     d  modLvlNbr                    10i 0
      * Stored CCSID of message
     d  storedCCSID                  10i 0
      * Offset of dump list entries
     d  ofsDmpListE                  10i 0
      * Number of dump list entries returned
     d  numDmpListER                 10i 0
      * Length of dump list entries returned
     d  lenDmpListER                 10i 0
      * Length of dump list entries available
     d  lenDmpListEA                 10i 0
      * Default program name
     d  dftPgmName                   10a
      * Default program library name
     d  dftPgmLib                    10a
      * Data
     d  data                       4096A
      *                       CHAR(*)  Default reply
      *                       CHAR(*)  Message
      *                       CHAR(*)  Message help
      *                       CHAR(*)  Substitution variable formats
      *                       CHAR(*)  Valid reply value entries
      *                       CHAR(*)  Special reply value entries
      *                       CHAR(*)  Lower range reply value
      *                       CHAR(*)  Upper range reply value
      *                       CHAR(*)  Relational test entry
      *                       CHAR(*)  Dump list entries
      *
      /endif
