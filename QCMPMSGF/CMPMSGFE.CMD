/* =================================================================== */
/*                                                                     */
/*  Kurzdokumentation :                                                */
/*                                                                     */
/*  Bereich . . . : CMPMSGF                                            */
/*  Objekt  . . . : CMPMSGF                                            */
/*  Beschreibung  : Tool: CMPMSGF    (Compare Message File     )       */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
/*  Datum . . . . : 25.10.2001                                         */
/*                                                                     */
/* =================================================================== */
/*                                                                     */
/*  This software is free software, you can redistribute it and/or     */
/*  modify it under the terms of the GNU General Public License (GPL)  */
/*  as published by the Free Software Foundation.                      */
/*                                                                     */
/*  See GNU General Public License for details.                        */
/*          http://www.opensource.org                                  */
/*          http://www.opensource.org/licenses/gpl-license.html        */
/*                                                                     */
/* =================================================================== */
/*  History:                                                           */
/*                                                                     */
/*  Datum       Name          nderung                                 */
/*  ----------  ------------  ---------------------------------------  */
/*                                                                     */
/* =================================================================== */
/* >>PRE-COMPILER<<                                                    */
/*                                                                     */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/CMPMSGF) +                        */
/*                           SRCFILE(&SL/&SF) +                        */
/*                           SRCMBR(&SM);                              */
/*                                                                     */
/*   >>COMPILE<<                                                       */
/*     >>PARM<< PGM(*LIBL/CMPMSGFC);                                   */
/*     >>PARM<< HLPPNLGRP(*LIBL/CMPMSGFP);                             */
/*     >>PARM<< HLPID(CMPMSGF);                                        */
/*     >>PARM<< PRDLIB(&LI);                                           */
/*     >>PARM<< MSGF(*LIBL/CMPMSGF);                                   */
/*   >>END-COMPILE<<                                                   */
/*                                                                     */
/*   >>EXECUTE<<                                                       */
/*                                                                     */
/* >>END-PRE-COMPILER<<                                                */
/* =================================================================== */
           CMD      PROMPT('Compare Message File')

             PARM       KWD(NEWMSGF)                     +
                          TYPE(QUAL1)                    +
                          MIN(1)                         +
                          PROMPT('New message file')

             PARM       KWD(OLDMSGF)                     +
                          TYPE(QUAL1)                    +
                          MIN(1)                         +
                          PROMPT('Old message file')

             PARM       KWD(RANGE)                                  +
                          TYPE(ELEM1)                               +
                          SNGVAL(                                   +
                            (*ALL ))                                +
                          PROMPT('Range of message identifiers')

             PARM       KWD(CMPDATE)                     +
                          TYPE(*CHAR)                    +
                          LEN(1)                         +
                          MIN(0)                         +
                          DFT(*YES)                      +
                          RSTD(*YES)                     +
                          SPCVAL((*YES Y)                +
                                 (*NO  N))               +
                          PROMPT('Compare modif./creation date')

             PARM       KWD(CMPLVL)                      +
                          TYPE(*CHAR)                    +
                          LEN(1)                         +
                          MIN(0)                         +
                          DFT(*NO)                       +
                          RSTD(*YES)                     +
                          SPCVAL((*YES Y)                +
                                 (*NO  N))               +
                          PROMPT('Compare modif./creation level')

             PARM       KWD(ERROR)                       +
                          TYPE(*CHAR)                    +
                          LEN(1)                         +
                          MIN(0)                         +
                          DFT(*NO)                       +
                          RSTD(*YES)                     +
                          SPCVAL((*YES Y)                +
                                 (*NO  N))               +
                          PROMPT('Show errors only')

/* ----------------------------------------------------------------- */

 QUAL1:      QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(1)
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB))              +
                          PROMPT('Library')

ELEM1:       ELEM       TYPE(*NAME)                                 +
                          LEN(7)                                    +
                          DFT(*FIRST)                               +
                          SPCVAL((*FIRST   ))                       +
                          FULL(*YES)                                +
                          EXPR(*YES)                                +
                          PROMPT('Lower value')
             ELEM       TYPE(*NAME)                                 +
                          LEN(7)                                    +
                          DFT(*LAST)                                +
                          SPCVAL((*ONLY    )                        +
                                 (*LAST    ))                       +
                          FULL(*YES)                                +
                          EXPR(*YES)                                +
                          PROMPT('Upper Value')

/* ----------------------------------------------------------------- */

 /* ... If CMPLVL is *YES, then CMPDATE must be *YES, too.  */
             DEP        CTL(&CMPLVL *EQ 'Y') +
                        PARM((&CMPDATE         +
                              *EQ 'Y'))        +
                        NBRTRUE(*ALL)          +
                        MSGID(USR0020)

