(*============================================================================
| cursor.pas
|   assembly routines to hide/show the cursor in text mode.
|   this module is not tightly connected to the rest of hexed.
|   you should be able to use it elsewhere if needed.
|
| History:
| Date       Author     Comment
| ----       ------     -------
| -- --- 94  G. Ollis	 created and developed program
============================================================================*)

{$I-}

Unit Cursor;

INTERFACE

{++PROCEDURES++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure HideCursor;
Procedure ShowCursor;
Procedure BigCursor;

{++FUNCTIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPLEMENTATION

{----------------------------------------------------------------------------}

Procedure HideCursor;
Begin
  asm
    mov ah,0fh
    int 10h
    mov ah,01h
    mov ch,20h
    int 10h
  End;
End;

{----------------------------------------------------------------------------}

Procedure ShowCursor;
Begin
  asm
    mov ah,0fh
    int 10h
    mov ah,1
    mov ch,6
    mov cl,7
    int 10h
  End;
End;

{----------------------------------------------------------------------------}

Procedure BigCursor;
Begin
  asm
    mov ah,0fh
    int 10h
    mov ah,1
    mov ch,1
    mov cl,7
    int 10h
  End;
End;

{======================================================================}

End.
