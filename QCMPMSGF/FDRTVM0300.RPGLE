**free
/if not defined(rtvm0300_t)
/define rtvm0300_t
//===============================================================*
//  QMHRTVM API - RTVM0300                                       *
//===============================================================*

dcl-ds rtvm0300_t qualified based(pDummy);
  //  Bytes returned
  bytRet      int(10);
  //  Bytes available
  bytAvl      int(10);
  //  Message severity
  msgSev      int(10);
  //  Alert index
  altIdx      int(10);
  // Alert Option
  altOpt      char(9);
  // Log indicator
  logInd      char(1);
  // Message ID
  msgID       char(7);
  // Reserved
  reserved_01 char(3);
  // Nbr. of subst. var. formats
  numVarFmt   int(10);
  // CCSID conv. stat. ind. text
  csIndTxt    int(10);
  // CCSID conv. stat. ind. data
  csIndDta    int(10);
  // CCSID of Text returned
  ccsidTxt    int(10);
  // Offset of default reply
  ofsDftR     int(10);
  // Length of default reply ret.
  lenDftRpyR  int(10);
  // Length of default reply avl.
  lenDftRpyA  int(10);
  // Offset of message
  ofsMsg      int(10);
  // Length of message returned
  lenMsgR     int(10);
  // Length of message available
  lenMsgA     int(10);
  // Offset of message
  ofsMsgHlp   int(10);
  // Length of message help ret.
  lenMsgHlpR  int(10);
  // Length of message help avl.
  lenMsgHlpA  int(10);
  // Ofs. of subst. var. formats
  ofsVarFmt   int(10);
  // Length subst. var. fmt. ret.
  lenVarFmtR  int(10);
  // Length subst. var. fmt. avl.
  lenVarFmtA  int(10);
  // Length subst. var. element
  lenVarFmtE  int(10);
  // Data
  data        char(4096);
//                       CHAR(*)  Default reply
//                       CHAR(*)  Message
//                       CHAR(*)  Message help
//                       CHAR(*)  Substitution variable formats

end-ds;

/endif
