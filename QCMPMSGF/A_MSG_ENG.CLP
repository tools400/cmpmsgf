     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0001                    */
     /* You pressed an invalid function key.                        */
     /* ----------------------------------------------------------- */

             PGM        PARM(&LI      )

             DCL        VAR(&LI       ) TYPE(*CHAR) LEN(10)

             RMVMSGD MSGID(USR0001) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0001) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'You pressed an invalid function key.'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0002                    */
     /* Combination not allowed.                                    */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0002) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0002) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Combination not allowed.'                                            +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0003                    */
     /* Already at top of subfile.                                  */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0003) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0003) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Already at top of subfile.'                                          +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0004                    */
     /* Already at botton of subfile.                               */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0004) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0004) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Already at botton of subfile.'                                       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0005                    */
     /* No more records available.                                  */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0005) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0005) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'No more records available.'                                          +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0006                    */
     /* Option &1 is not valid.                                     */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0006) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0006) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Option &1 is not valid.'                                             +
                ) +
                SEV(00) +
                FMT( +
                    (*QTDCHAR 002) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0007                    */
     /* No data in subfile.                                         */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0007) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0007) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'No data in subfile.'                                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0008                    */
     /* Reading ...                                                 */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0008) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0008) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Reading ...'                                                         +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0009                    */
     /* Warning: Not all entries loaded!                            */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0009) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0009) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Warning: Not all entries loaded!'                                    +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   Not all entries could be loaded into the su-
bfile. The subfile has reached its limit of &1 items. Use the "Positio-
n to" to move to another starting point.'                             +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 005 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0010                    */
     /* New and old message file must be different.                 */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0010) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0010) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'New and old message file must be different.'                         +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0011                    */
     /* Abnormal program end. See job log for details.              */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0011) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0011) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Abnormal program end. See job log for details.'                      +
                ) +
                SEV(30) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0012                    */
     /* Message file &1 is alredy open.                             */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0012) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0012) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Message file &1 is already open.'                                    +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 005 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0013                    */
     /* Message file &1 is not open.                                */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0013) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0013) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Message file &1 is not open.'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 005 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0014                    */
     /* Message file &1 is not open.                                */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0014) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0014) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Library & does not exist.'                                           +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0015                    */
     /* Message file &1 is not open.                                */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0015) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0015) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Message file &1 in library &2 does not exist.'                       +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0016                    */
     /* Could not copy message ID &1. See job log for details.      */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0016) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0016) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Could not copy message ID &1. See job log for details.'              +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 007) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0017                    */
     /* Press &1 to confirm.                                        */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0017) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0017) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Press &1 to confirm.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0018                    */
     /* Lower range limit greater than upper range limit.           */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0018) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0018) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Lower range limit greater than upper range limit.'                   +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0019                    */
     /* Choose Y or N.                                              */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0019) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0019) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Choose Y or N.'                                                      +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0020                    */
     /* Compare level *YES not allowed without compare date *YES.   */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0020) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0020) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Compare level *YES not allowed without compare date *YES.'           +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0021                    */
     /* PTF missing. CMPMSGF has to use the RTVM0300 format.        */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0021) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0021) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'PTF missing. CMPMSGF has to use the RTVM0300 format.'                +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   A PTF is missing. CMPMSGF can not use the -
RTVM0400 format to get better results. Please refer to the online help -
for more information.'                                                +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   USR0022                    */
     /* Message description &1 not found in message file &2 in &3.  */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(USR0022) MSGF(&LI/CMPMSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(USR0022) +
                MSGF(&LI/CMPMSGF) +
                MSG(+
'Message description &1 not found in message file &2 in &3.'          +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 007) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

             ENDPGM
