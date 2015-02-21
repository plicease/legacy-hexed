(*============================================================================
| vconvert.pas
|    convert various data formats.  usually involving strings on one end or
|    the other (sometimes even the other).
|
| History:
| Date       Author     Comment
| ----       ------     -------
| -- --- 94  G. Ollis	 created and developed program
============================================================================*)

{$I-}

Unit VConvert;

INTERFACE

{++PROCEDURES++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++FUNCTIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Function StrToInt(S:String):LongInt;
Function UpString(S:String):String;
Function IntToStr(I: Longint; fm:Byte): String;
Function Byte2Str(w: word):String;
Function Long2Str(w:LongInt):String;
Function Word2Str(w:LongInt):String;
Function Octal2Permission(W:Word):String;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPLEMENTATION

{----------------------------------------------------------------------}

Function StrToInt(S:String):LongInt;
Var
  Temp:LongInt;
  Error:Integer;
Begin
  Val(S,Temp,Error);
  If Error <> 0 Then
    StrToInt:=0
  Else
    StrToInt:=Temp;
End;

{----------------------------------------------------------------------}

Function UpString(S:String):String;
Var i:Integer;
Begin
  For i:=1 To Length(S) Do
    S[i]:=UpCase(S[i]);
  UpString:=S;
End;

{------------------------------------------------------------------------}
function IntToStr(I: Longint; fm:Byte): String;
{ Convert any integer type to a string }
var
 S: string[11];
begin
 Str(I:fm, S);
 IntToStr := S;
end;
{------------------------------------------------------------------------}

Function Byte2Str(w: word):String;
{pre:word
 post:string containing the low order byte's value in string format}
const
  hexChars: array [0..$F] of Char =
   '0123456789ABCDEF';
begin
 Byte2Str:=hexChars[w shr 4]+hexChars[w and $F];
end;

{-----------------------------------------------------------------}

Function Long2Str(w:LongInt):String;
{pre:LongInt
 Post:two loest order bytes on the LongInt in String format}
Type ByteArray=Array [1..4] Of Byte;
Var
  B:^ByteArray;
  index:Integer;
  ans:String;
Begin
  ans:='';
  B:=@w;
  For index:=4 DownTo 1 Do
    ans:=ans+Byte2Str(B^[index]);
  Long2Str:=ans;
End;

{-----------------------------------------------------------------}

Function Word2Str(w:LongInt):String;
Type ByteArray=Array [1..4] Of Byte;
Var B:^ByteArray;
  index:Integer;
  ans:String;
Begin
  ans:='';
  B:=@w;
  For index:=2 DownTo 1 Do
    ans:=ans+Byte2Str(B^[index]);
  Word2Str:=ans;
End;

{-----------------------------------------------------------------}

Const
  WRL_X = $1;           { o001 }
  WRL_W = $2;           { o002 }
  WRL_R = $4;           { o004 }
  GRP_X = $8;           { o010 }
  GRP_W = $10;          { o020 }
  GRP_R = $20;          { o040 }
  OWN_X = $40;          { o100 }
  OWN_W = $80;          { o200 }
  OWN_R = $100;         { o400 }

Function Octal2Permission(W:Word):String;
Var
  Answer:String;
Begin
  {OWNER}
  Answer := 'own:';
  If boolean(W And OWN_R) Then
    Answer := Answer + 'r'
  Else
    Answer := Answer + '-';
  If boolean(W And OWN_W) Then
    Answer := Answer + 'w'
  Else
    Answer := Answer + '-';
  If boolean(W And OWN_X) Then
    Answer := Answer + 'x'
  Else
    Answer := Answer + '-';

  {GROUP}
  Answer := ' grp:';
  If boolean(W And GRP_R) Then
    Answer := Answer + 'r'
  Else
    Answer := Answer + '-';
  If boolean(W And GRP_W) Then
    Answer := Answer + 'w'
  Else
    Answer := Answer + '-';
  If boolean(W And GRP_X) Then
    Answer := Answer + 'x'
  Else
    Answer := Answer + '-';

  {GROUP}
  Answer := ' wrl:';
  If boolean(W And WRL_R) Then
    Answer := Answer + 'r'
  Else
    Answer := Answer + '-';
  If boolean(W And WRL_W) Then
    Answer := Answer + 'w'
  Else
    Answer := Answer + '-';
  If boolean(W And WRL_X) Then
    Answer := Answer + 'x'
  Else
    Answer := Answer + '-';
End;
{======================================================================}

End.
