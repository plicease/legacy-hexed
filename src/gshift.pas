(*============================================================================
| gshift.pas
|   some kind of assembly function.  don't ask me, i only work here.
|
| History:
| Date       Author     Comment
| ----       ------     -------
| -- --- 94  G. Ollis	 created and developed program
============================================================================*)

{$I-}

Unit GShift;

INTERFACE

Const
  KBRShift  =$01;
  KBLShift  =$02;
  KBCtrl    =$04;
  KBAlt     =$08;
  KBScroll  =$10;
  KBNum     =$20;
  KBCaps    =$40;
  KBInsert  =$80;

{++PROCEDURES++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Function GetShiftByte:Byte;

{++FUNCTIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPLEMENTATION

{----------------------------------------------------------------------}

Function GetShiftByte:Byte;
Var
  Temp:Byte;
Begin
  asm
    mov ah,02h
    int 16h
    mov Temp,al
  End;
  GetShiftByte:=Temp;
End;

{======================================================================}

End.
