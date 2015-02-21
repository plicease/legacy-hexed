(*============================================================================
| chfile.pas
|   user interface for chosing a file.  unlike the rest of hexed this is
|   somewhat "drop in"  you can use this module elsewhere with little
|   effort.  i vaguely recall using it in another program somewhere....
|
| History:
| Date       Author     Comment
| ----       ------     -------
| -- --- 94  G. Ollis	 created and developed program
============================================================================*)

{$I-}

Unit ChFile;

INTERFACE

Type
  MaskString=String [78];

{++PROCEDURES++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++FUNCTIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Function ChooseFileName(Product,Func:String; Var Path:MaskString):String;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPLEMENTATION

Uses Crt,DOS;

{----------------------------------------------------------------------}

Function ChooseFileName(Product,Func:String;  Var Path:MaskString):String;
Var
  I:Integer;
  C:Char;
  FileList:Array [1..4,1..20] Of String[12];
  Ofset:LongInt;
  RealPath:String;
  X,Y:Byte;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Function WildCard2Dir(Path:String):String;
Var
  Dir   : DirStr;
  Name  : NameStr;
  Ext   : ExtStr;
Begin
  FSplit(Path,Dir,Name,Ext);
  WildCard2Dir:=Dir;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Procedure WriteChooseData;
Var B:Byte;
Begin
  GotoXY(1,4);
  For B:=1 To 80 Do
    Write(#$CD);
  GotoXY(1,1);
  Write(Product);
  GotoXY(40,1);
  Write(Ofset:3,Func+' ':30);
  GotoXY(1,2);
  Write('enter in file name, or use arrow keys to move cursor.  <ENTER> to select');
  GotoXY(1,3);
  ClrEol;
  Write('> ');
  TextAttr:=Blue * $10 or Yellow;
  Write(Path);
  TextAttr:=Blue * $10 or LightGray;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Procedure WriteCurrPath;
Var
  S:String;
Begin
  Window(1,25,80,25);
  GetDir(0,S);
  TextBackGround(Black);
  ClrEOL;
  Write(S);
  TextBackGround(Blue);
  Window(1,1,80,25);
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Procedure WriteFileList(Var X,Y:Byte);
Var
  Ser:SearchRec;
  I:Integer;
  X1,Y1:Word;
Begin
  For X1:=1 To 4 Do
    For Y1:=1 To 21 Do
      FileList[X1,Y1]:='';
  GotoXY(1,5);
  If Path[Length(Path)]='\' Then
    FindFirst(Path+'*.*',anyfile-Hidden-SysFile-VolumeID,Ser)
  Else
    FindFirst(Path,anyfile-Hidden-SysFile-VolumeID,Ser);
  X1:=1;
  Y1:=1;
  For I:=1 To Ofset*4 Do
    Begin
      FindNext(Ser);
      If DosError<>0 Then
        Begin
          Dec(Ofset);
          WriteFileList(X,Y);
          Exit;
        End;
    End;
  While (DosError=0) And (X1<>5) And (Y1<>21) Do
    Begin
      If Ser.Name<>'.' Then
        Begin
          FileList[X1,Y1]:=Ser.Name;
          If Boolean(Ser.Attr And Directory) Then
            FileList[X1,Y1]:=FileList[X1,Y1]+'\';
          X1:=X1+1;
          If X1=5 Then
            Begin
              X1:=1;
              Y1:=Y1+1;
            End;
        End;
      FindNext(Ser);
    End;
  While (FileList[X,Y]='') Do
    Begin
      X:=X-1;
      If X<1 Then
        Begin
          X:=4;
          Y:=Y-1;
        End;
    End;
  If FileList[1,1]='' Then
    Begin
      X:=1;
      Y:=1;
    End;
  For Y1:=1 To 20 Do
    For X1:=1 To 4 Do
      Begin
        If (Y1=Y) And (X1=X) Then
          TextAttr:=Black * $10 Or Yellow;
        Write(FileList[X1,Y1]:20);
        If (Y1=Y) And (X1=X) Then
          TextAttr:=Blue * $10 Or LightGray;
      End;

  WriteCurrPath;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Procedure ChangeDirectory(S:String);
Begin
  Dec(S[0]);
  ChDir(WildCard2Dir(Path));
  While Pos('\',Path)<>0 Do
    Begin
      Delete(Path,1,Pos('\',Path));
    End;
  ChDir(S);
  Path:='*.*';
  WriteCurrPath;
  X:=1;
  Y:=1;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Function Valid(B:Byte):Boolean;
Begin
  If DiskFree(B)=-1 Then
    Valid:=FALSE
  Else
    Valid:=TRUE;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Function WhatDir:String;
Var
  Temp:String;
Begin
  GetDir(0,Temp);
  If Temp[Byte(Temp[0])]<>'\' Then
    Temp:=Temp+'\';
  WhatDir:=Temp;
End;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }


Begin
  GetDir(0,RealPath);
  Ofset:=0;
  Window(1,1,80,25);
  TextAttr:=Blue*$10 or LightGray;
  ClrScr;
  X:=1;
  Y:=1;
  Repeat
    WriteFileList(X,Y);
    WriteChooseData;
    C:=UpCase(Readkey);
    If ((C>='A') And (C<='Z')) Or
       ((C>='a') And (C<='z')) Or
       ((C>='0') And (C<='9')) Or
       ((C>='!') And (C<='$')) Or
       ((C>='^') And (C<='*')) Or
       (C='*') Or
       (C='-') Or
       (C='.') Or (C='\') Or (C=':') Then
      Path:=Path+C
    Else If (C=#8) Then
      Delete(Path,Length(Path),1)
    Else If (C=#13) Then
      Begin
        If FileList[X,Y][Length(FileList[X,Y])]='\' Then
          ChangeDirectory(FileList[X,Y]);
      End
    Else If (C=#27) Then
    Else If (C=#0) Then
      Begin
        C:=Readkey;
        If C=#72 Then
          Y:=Y-1
        Else If C=#75 Then
          X:=X-1
        Else If C=#77 Then
          X:=X+1
        Else If C=#80 Then
          Y:=Y+1
        Else If C=#73 Then
          Ofset:=Ofset-1
        Else If C=#81 Then
          Ofset:=Ofset+1
        Else
          Write(^G);
        If Ofset<0 Then
          Ofset:=0;
        If X<1 Then
          X:=1;
        If X>4 Then
          X:=4;
        If Y<1 Then
          Y:=1;
        If Y>20 Then
          Y:=20;
      End
    Else
      Write(^G);
  Until ((C=#13) And (FileList[X,Y][Length(FileList[X,Y])]<>'\')) Or (C=#27);
  If C=#13 Then
    ChooseFileName:=WildCard2Dir(Path)+FileList[X,Y]
  Else If C=#27 Then
    ChooseFileName:='';
  Window(1,1,80,25);
  TextAttr:=Black * $10 or LightGray;
  ClrScr;
  ChDir(RealPath);
End;

{======================================================================}

End.
