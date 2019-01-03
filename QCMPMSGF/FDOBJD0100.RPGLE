      /if not defined(objd0100_t)
      /define objd0100_t
      *===============================================================*
      *  QUSROBJD API - OBJD0300                                      *
      *===============================================================*
      *
     d objd0100_t      ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  name                         10a
     d  lib                          10a
     d  type                         10a
     d  rtnLib                       10a
     d  auxStgP                      10i 0
     d  owner                        10a
     d  domain                        2a
     d  crtDatTim                    13A
     d  chgDatTim                    13A
      *
      /endif
