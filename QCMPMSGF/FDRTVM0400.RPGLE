**free
/if not defined(rtvm0400_t)
/define rtvm0400_t
//===============================================================*
//  QMHRTVM API - RTVM0400                                       *
//===============================================================*

dcl-ds rtvm0400_t qualified based(pDummy);
  //  Bytes returned
  bytRet       int(10);
  //  Bytes available
  bytAvl       int(10);
  //  Message severity
  msgSev       int(10);
  //  Alert index
  altIdx       int(10);
  // Alert Option
  altOpt       char(9);
  // Log indicator
  logInd       char(1);
  // Message ID
  msgID        char(7);
  // Reserved
  reserved_01  char(3);
  // Nbr. of subst. var. formats
  numVarFmt    int(10);
  // CCSID conv. stat. ind. text
  csIndTxt     int(10);
  // CCSID conv. stat. ind. data
  csIndDta     int(10);
  // CCSID of Text returned
  ccsidTxt     int(10);
  // Offset of default reply
  ofsDftR      int(10);
  // Length of default reply ret.
  lenDftRpyR   int(10);
  // Length of default reply avl.
  lenDftRpyA   int(10);
  // Offset of message
  ofsMsg       int(10);
  // Length of message returned
  lenMsgR      int(10);
  // Length of message available
  lenMsgA      int(10);
  // Offset of message
  ofsMsgHlp    int(10);
  // Length of message help ret.
  lenMsgHlpR   int(10);
  // Length of message help avl.
  lenMsgHlpA   int(10);
  // Ofs. of subst. var. formats
  ofsVarFmt    int(10);
  // Length subst. var. fmt. ret.
  lenVarFmtR   int(10);
  // Length subst. var. fmt. avl.
  lenVarFmtA   int(10);
  // Length subst. var. element
  lenVarFmtE   int(10);
  // Reply type
  rpyType      char(10);
  // Reserved
  reserved_02  char(2);
  // Maximum reply length
  maxRpyLen    int(10);
  // Maximum reply decimal positions
  maxRpyDecPos int(10);
  // Offset of valid reply value entries
  ofsRpyE      int(10);
  // Number of valid reply values entries returned
  numRpyER     int(10);
  // Length of valid reply value entries returned
  lenRpyER     int(10);
  // Length of valid reply value entries available
  lenRpyEA     int(10);
  // Length of valid reply value entry
  lenRpyE      int(10);
  // Offset of special reply value entries
  ofsSpcRpyE   int(10);
  // Number of special reply values returned
  numSpcRpyER  int(10);
  // Length of special reply value entries returned
  lenSpcRpyER  int(10);
  // Length of special reply value entries available
  lenSpcRpyEA  int(10);
  // Length of special reply value entry
  lenSpcRpyE   int(10);
  // Offset of lower range reply value
  ofsLowRpyE   int(10);
  // Length of lower range reply value returned
  lenLowRpyER  int(10);
  // Length of lower range reply value available
  lenLowRpyEA  int(10);
  // Offset of upper range reply value
  ofsUpRpyE    int(10);
  // Length of upper range reply value returned
  ofsUpRpyER   int(10);
  // Length of upper range reply value available
  ofsUpRpyEA   int(10);
  // Offset of relational test entry
  ofsRelTestE  int(10);
  // Length of relational test entry returned
  lenRelTestER int(10);
  // Length of relational test entry available
  lenRelTestEA int(10);
  // Message creation date
  crtDate      char(7);
  // Reserved
  reserved_03  char(1);
  // Message creation level number
  crtLvlNbr    int(10);
  // Message modification date
  modDate      char(7);
  // Reserved
  reserved_04  char(1);
  // Message modification level number
  modLvlNbr    int(10);
  // Stored CCSID of message
  storedCCSID  int(10);
  // Offset of dump list entries
  ofsDmpListE  int(10);
  // Number of dump list entries returned
  numDmpListER int(10);
  // Length of dump list entries returned
  lenDmpListER int(10);
  // Length of dump list entries available
  lenDmpListEA int(10);
  // Default program name
  dftPgmName   char(10);
  // Default program library name
  dftPgmLib    char(10);
  // Data
  data         char(4096);
//                       CHAR(*)  Default reply
//                       CHAR(*)  Message
//                       CHAR(*)  Message help
//                       CHAR(*)  Substitution variable formats
//                       CHAR(*)  Valid reply value entries
//                       CHAR(*)  Special reply value entries
//                       CHAR(*)  Lower range reply value
//                       CHAR(*)  Upper range reply value
//                       CHAR(*)  Relational test entry
//                       CHAR(*)  Dump list entries
end-ds;

/endif
