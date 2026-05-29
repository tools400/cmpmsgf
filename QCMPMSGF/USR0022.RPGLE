**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : USR0022

// Message description &1 not found in message file &2 in &3.

dcl-ds USR0022;
  USR00221 char(007) inz(*blanks);
  USR00222 char(010) inz(*blanks);
  USR00223 char(010) inz(*blanks);
end-ds;
dcl-s USR0022# bindec(8) inz(0027);

