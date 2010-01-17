{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit MAIN;

interface

uses Windows, SysUtils, Classes, Forms, Controls, Menus,
     ComCtrls, unGMul, unSBox, unShiftRows, unMixColumns,
     unKeyExpansion, unCipher, unCipher_line_by_line,
     unInvShiftRows, unInvMixColumns, unInvCipher, unInvCipher_line_by_line,
     unMonteCarlo, unInvMonteCarlo, unRealCipher,
     StdCtrls;

type tipovi = (
NISTA,
GMUL,
_SBOX,
_SHIFTROWS,
_MIXCOLUMNS,
_KEYEXPANSION,
_CIPHER,
_CIPHER_LINE_BY_LINE,

_INVSHIFTROWS,
_INVMIXCOLUMNS,
_INVCIPHER,
_INVCIPHER_LINE_BY_LINE,

_MONTECARLO,
_INVMONTECARLO,
_REALCIPHER
);


type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    StatusBar: TStatusBar;
    Cipherelements1: TMenuItem;
    GMul1: TMenuItem;
    N2: TMenuItem;
    SBox1: TMenuItem;
    ShiftRows1: TMenuItem;
    MixColumns1: TMenuItem;
    Keyexpansion1: TMenuItem;
    Cipher3: TMenuItem;
    Cipher4: TMenuItem;
    InvCipherelements1: TMenuItem;
    InvShiftRows1: TMenuItem;
    InvMixColums1: TMenuItem;
    InvCipher1: TMenuItem;
    InvCipher2: TMenuItem;
    Cipherlinebylineview1: TMenuItem;
    InvCipherlinebylineview1: TMenuItem;
    MonteCarlotests1: TMenuItem;
    MonteCarlo1: TMenuItem;
    InvMonteCarlo1: TMenuItem;
    Realcipher1: TMenuItem;
    RealCipher2: TMenuItem;
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GMul1Click(Sender: TObject);
    procedure SBox1Click(Sender: TObject);
    procedure ShiftRows1Click(Sender: TObject);
    procedure MixColumns1Click(Sender: TObject);
    procedure Keyexpansion1Click(Sender: TObject);
    procedure Cipher4Click(Sender: TObject);
    procedure InvShiftRows1Click(Sender: TObject);
    procedure InvMixColums1Click(Sender: TObject);
    procedure InvCipher2Click(Sender: TObject);
    procedure Cipherlinebylineview1Click(Sender: TObject);
    procedure InvCipherlinebylineview1Click(Sender: TObject);
    procedure MonteCarlo1Click(Sender: TObject);
    procedure InvMonteCarlo1Click(Sender: TObject);
    procedure RealCipher2Click(Sender: TObject);
  private
    { Private declarations }
    procedure CreateMDIChild(tip2 : tipovi; const Name: string);
  public
    { Public declarations }
    AppPath, DescriptionPath : string;

    key_len : integer;
    in_key : array [0..31] of Byte;
    key : array[0..239] of Byte;
    tmpkey : array [0..3] of BYTE;
    state : array[0..3, 0..3] of Byte;
    input : array[0..3, 0..3] of Byte;
    output : array[0..3, 0..3] of Byte;
    byte_counter : integer;


    ch_GMul                          : TfrGMul;
    ch_SBox                          : TfrSBox;
    ch_ShiftRows                     : TfrShiftRows;
    ch_MixColumns                    : TfrMixColumns;
    ch_KeyExpansion                  : TfrKeyExpansion;
    ch_Cipher                        : TfrCipher;
    ch_Cipher_line_by_line           : TfrCipher_line_by_line;

    ch_InvShiftRows                  : TfrInvShiftRows;
    ch_InvMixColumns                 : TfrInvMixColumns;
    ch_InvCipher                     : TfrInvCipher;
    ch_InvCipher_line_by_line        : TfrInvCipher_line_by_line;

    ch_MonteCarlo                    : TfrMonteCarlo;
    ch_InvMonteCarlo                 : TfrInvMonteCarlo;

    ch_RealCipher                    : TfrRealCipher;

{    procedure rotate;
    function galoa_mul_tab(a : Byte; b : Byte) : Byte;
    function rcon (a : Byte) : Byte;
}
  end;

var
  MainForm: TMainForm;

SBox : array [0..255] of Byte = (
$63, $7c, $77, $7b, $f2, $6b, $6f, $c5, $30, $01, $67, $2b, $fe, $d7, $ab, $76,
$ca, $82, $c9, $7d, $fa, $59, $47, $f0, $ad, $d4, $a2, $af, $9c, $a4, $72, $c0,
$b7, $fd, $93, $26, $36, $3f, $f7, $cc, $34, $a5, $e5, $f1, $71, $d8, $31, $15,
$04, $c7, $23, $c3, $18, $96, $05, $9a, $07, $12, $80, $e2, $eb, $27, $b2, $75,
$09, $83, $2c, $1a, $1b, $6e, $5a, $a0, $52, $3b, $d6, $b3, $29, $e3, $2f, $84,
$53, $d1, $00, $ed, $20, $fc, $b1, $5b, $6a, $cb, $be, $39, $4a, $4c, $58, $cf,
$d0, $ef, $aa, $fb, $43, $4d, $33, $85, $45, $f9, $02, $7f, $50, $3c, $9f, $a8,
$51, $a3, $40, $8f, $92, $9d, $38, $f5, $bc, $b6, $da, $21, $10, $ff, $f3, $d2,
$cd, $0c, $13, $ec, $5f, $97, $44, $17, $c4, $a7, $7e, $3d, $64, $5d, $19, $73,
$60, $81, $4f, $dc, $22, $2a, $90, $88, $46, $ee, $b8, $14, $de, $5e, $0b, $db,
$e0, $32, $3a, $0a, $49, $06, $24, $5c, $c2, $d3, $ac, $62, $91, $95, $e4, $79,
$e7, $c8, $37, $6d, $8d, $d5, $4e, $a9, $6c, $56, $f4, $ea, $65, $7a, $ae, $08,
$ba, $78, $25, $2e, $1c, $a6, $b4, $c6, $e8, $dd, $74, $1f, $4b, $bd, $8b, $8a,
$70, $3e, $b5, $66, $48, $03, $f6, $0e, $61, $35, $57, $b9, $86, $c1, $1d, $9e,
$e1, $f8, $98, $11, $69, $d9, $8e, $94, $9b, $1e, $87, $e9, $ce, $55, $28, $df,
$8c, $a1, $89, $0d, $bf, $e6, $42, $68, $41, $99, $2d, $0f, $b0, $54, $bb, $16);

//Tabela logaritama dobijena koristenjem 0xe5 (229) kao generatora
ltable : array [0..255] of Byte = (
$00, $ff, $c8, $08, $91, $10, $d0, $36, $5a, $3e, $d8, $43, $99, $77, $fe, $18,
$23, $20, $07, $70, $a1, $6c, $0c, $7f, $62, $8b, $40, $46, $c7, $4b, $e0, $0e,
$eb, $16, $e8, $ad, $cf, $cd, $39, $53, $6a, $27, $35, $93, $d4, $4e, $48, $c3,
$2b, $79, $54, $28, $09, $78, $0f, $21, $90, $87, $14, $2a, $a9, $9c, $d6, $74,
$b4, $7c, $de, $ed, $b1, $86, $76, $a4, $98, $e2, $96, $8f, $02, $32, $1c, $c1,
$33, $ee, $ef, $81, $fd, $30, $5c, $13, $9d, $29, $17, $c4, $11, $44, $8c, $80,
$f3, $73, $42, $1e, $1d, $b5, $f0, $12, $d1, $5b, $41, $a2, $d7, $2c, $e9, $d5,
$59, $cb, $50, $a8, $dc, $fc, $f2, $56, $72, $a6, $65, $2f, $9f, $9b, $3d, $ba,
$7d, $c2, $45, $82, $a7, $57, $b6, $a3, $7a, $75, $4f, $ae, $3f, $37, $6d, $47,
$61, $be, $ab, $d3, $5f, $b0, $58, $af, $ca, $5e, $fa, $85, $e4, $4d, $8a, $05,
$fb, $60, $b7, $7b, $b8, $26, $4a, $67, $c6, $1a, $f8, $69, $25, $b3, $db, $bd,
$66, $dd, $f1, $d2, $df, $03, $8d, $34, $d9, $92, $0d, $63, $55, $aa, $49, $ec,
$bc, $95, $3c, $84, $0b, $f5, $e6, $e7, $e5, $ac, $7e, $6e, $b9, $f9, $da, $8e,
$9a, $c9, $24, $e1, $0a, $15, $6b, $3a, $a0, $51, $f4, $ea, $b2, $97, $9e, $5d,
$22, $88, $94, $ce, $19, $01, $71, $4c, $a5, $e3, $c5, $31, $bb, $cc, $1f, $2d,
$3b, $52, $6f, $f6, $2e, $89, $f7, $c0, $68, $1b, $64, $04, $06, $bf, $83, $38 );

// tabela eksponenata
exptable : array [0..255] of Byte = (
$01, $e5, $4c, $b5, $fb, $9f, $fc, $12, $03, $34, $d4, $c4, $16, $ba, $1f, $36,
$05, $5c, $67, $57, $3a, $d5, $21, $5a, $0f, $e4, $a9, $f9, $4e, $64, $63, $ee,
$11, $37, $e0, $10, $d2, $ac, $a5, $29, $33, $59, $3b, $30, $6d, $ef, $f4, $7b,
$55, $eb, $4d, $50, $b7, $2a, $07, $8d, $ff, $26, $d7, $f0, $c2, $7e, $09, $8c,
$1a, $6a, $62, $0b, $5d, $82, $1b, $8f, $2e, $be, $a6, $1d, $e7, $9d, $2d, $8a,
$72, $d9, $f1, $27, $32, $bc, $77, $85, $96, $70, $08, $69, $56, $df, $99, $94,
$a1, $90, $18, $bb, $fa, $7a, $b0, $a7, $f8, $ab, $28, $d6, $15, $8e, $cb, $f2,
$13, $e6, $78, $61, $3f, $89, $46, $0d, $35, $31, $88, $a3, $41, $80, $ca, $17,
$5f, $53, $83, $fe, $c3, $9b, $45, $39, $e1, $f5, $9e, $19, $5e, $b6, $cf, $4b,
$38, $04, $b9, $2b, $e2, $c1, $4a, $dd, $48, $0c, $d0, $7d, $3d, $58, $de, $7c,
$d8, $14, $6b, $87, $47, $e8, $79, $84, $73, $3c, $bd, $92, $c9, $23, $8b, $97,
$95, $44, $dc, $ad, $40, $65, $86, $a2, $a4, $cc, $7f, $ec, $c0, $af, $91, $fd,
$f7, $4f, $81, $2f, $5b, $ea, $a8, $1c, $02, $d1, $98, $71, $ed, $25, $e3, $24,
$06, $68, $b3, $93, $2c, $6f, $3e, $6c, $0a, $b8, $ce, $ae, $74, $b1, $42, $b4,
$1e, $d3, $49, $e9, $9c, $c8, $c6, $c7, $22, $6e, $db, $20, $bf, $43, $51, $52,
$66, $b2, $76, $60, $da, $c5, $f3, $f6, $aa, $cd, $9a, $a0, $75, $54, $0e, $01 );

implementation

{$R *.dfm}

uses about;

{
procedure TMainForm.rotate;
var a, c : Byte;
begin
		a := tmpkey[0];
		for c := 0 to 3 do
      tmpkey[c] := tmpkey[c + 1];
		tmpkey[3] := a;
end;

//------------------------------------------------------------
// tabelarno mnozenje
function TMainForm.galoa_mul_tab(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  z := 0;
  // korak 1. pronadji brojeve u tabelama logaritama
  // korak 2. saberi i pronadji moduo 255
  s := ltable[a] + ltable[b];
  s := s mod 255;
  // korak 3. pronadji rezultat u tabeli eksponenata
  s := exptable[s];
  // treba da vratimo rezultat nula ako je ili a ili b nula (ili oba)
  if a = 0 then
    s := z;

  if b = 0 then
    s := z;

	result := s;
end;

//------------------------------------------------------------
// Racuna rcon za expanziju kljuceva
function TMainForm.rcon (a : Byte) : Byte;
var c : Byte;
begin
  c := 1;
  if a = 0 then
  begin
    result := 0;
    exit;
  end;
  while a <> 1 do
  begin
    c := galoa_mul_tab(c,2);
    dec(a);
  end;
  result := c;
end;
}

procedure TMainForm.CreateMDIChild(tip2 : tipovi; const Name: string);
begin
  if MainForm.MDIChildCount > 0 then
  begin
     MainForm.ActiveMDIChild.Close;
     MainForm.ActiveMDIChild.Release;
  end;
  Application.ProcessMessages;
  //-------------------------------------------

  if tip2 = GMUL then
  begin
    ch_GMul := TfrGMul.Create(Application);
    ch_GMul.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _SBOX then
  begin
    ch_SBox := TfrSBox.Create(Application);
    ch_SBox.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _SHIFTROWS then
  begin
    ch_ShiftRows := TfrShiftRows.Create(Application);
    ch_ShiftRows.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _MIXCOLUMNS then
  begin
    ch_MixColumns := TfrMixColumns.Create(Application);
    ch_MixColumns.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _KEYEXPANSION then
  begin
    ch_KeyExpansion := TfrKeyExpansion.Create(Application);
    ch_KeyExpansion.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _CIPHER then
  begin
    ch_Cipher := TfrCipher.Create(Application);
    ch_Cipher.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _CIPHER_LINE_BY_LINE then
  begin
    ch_Cipher_line_by_line := TfrCipher_line_by_line.Create(Application);
    ch_Cipher_line_by_line.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _INVSHIFTROWS then
  begin
    ch_InvShiftRows := TfrInvShiftRows.Create(Application);
    ch_InvShiftRows.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _INVMIXCOLUMNS then
  begin
    ch_InvMixColumns := TfrInvMixColumns.Create(Application);
    ch_InvMixColumns.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;


  if tip2 = _INVCIPHER then
  begin
    ch_InvCipher := TfrInvCipher.Create(Application);
    ch_InvCipher.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _INVCIPHER_LINE_BY_LINE then
  begin
    ch_InvCipher_line_by_line := TfrInvCipher_line_by_line.Create(Application);
    ch_InvCipher_line_by_line.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _MONTECARLO then
  begin
    ch_MonteCarlo := TfrMonteCarlo.Create(Application);
    ch_MonteCarlo.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _INVMONTECARLO then
  begin
    ch_InvMonteCarlo := TfrInvMonteCarlo.Create(Application);
    ch_InvMonteCarlo.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

  if tip2 = _REALCIPHER then
  begin
    ch_RealCipher := TfrRealCipher.Create(Application);
    ch_RealCipher.Caption := Name;
    exit;
  end;
  Application.ProcessMessages;

end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var s : string;
    i : integer;
begin
  S := Application.ExeName;
  i := Length(S);
  while (S[i]<> '\')  do Dec(i);
    System.Delete(s, i, Length(s)-i+1);
  AppPath := s;
  DescriptionPath := AppPath + '\descriptions.eng\';


  key_len := 0;
  

end;



procedure TMainForm.GMul1Click(Sender: TObject);
begin
  CreateMDIChild(GMUL, 'Galois multiplication');
end;

procedure TMainForm.SBox1Click(Sender: TObject);
begin
  CreateMDIChild(_SBOX, 'S Box - SubBytes transformation');
end;

procedure TMainForm.ShiftRows1Click(Sender: TObject);
begin
  CreateMDIChild(_SHIFTROWS, 'ShiftRows transformation');
end;

procedure TMainForm.MixColumns1Click(Sender: TObject);
begin
  CreateMDIChild(_MIXCOLUMNS, 'MixColumns transformation');
end;

procedure TMainForm.Keyexpansion1Click(Sender: TObject);
begin
  CreateMDIChild(_KEYEXPANSION, 'Key Expansion');
end;

procedure TMainForm.Cipher4Click(Sender: TObject);
begin
  CreateMDIChild(_CIPHER, 'Cipher - block by block view');
end;

procedure TMainForm.Cipherlinebylineview1Click(Sender: TObject);
begin
  CreateMDIChild(_CIPHER_LINE_BY_LINE, 'Cipher - line by line view');
end;

procedure TMainForm.InvShiftRows1Click(Sender: TObject);
begin
  CreateMDIChild(_INVSHIFTROWS, 'InvShiftRows');
end;

procedure TMainForm.InvMixColums1Click(Sender: TObject);
begin
  CreateMDIChild(_INVMIXCOLUMNS, 'InvMixColumns');
end;

procedure TMainForm.InvCipher2Click(Sender: TObject);
begin
  CreateMDIChild(_INVCIPHER, 'InvCipher - block by block view');
end;

procedure TMainForm.InvCipherlinebylineview1Click(Sender: TObject);
begin
  CreateMDIChild(_INVCIPHER_LINE_BY_LINE, 'InvCipher - line by line view');
end;

procedure TMainForm.MonteCarlo1Click(Sender: TObject);
begin
  CreateMDIChild(_MONTECARLO, 'Monte Carlo test');
end;

procedure TMainForm.InvMonteCarlo1Click(Sender: TObject);
begin
  CreateMDIChild(_INVMONTECARLO, 'Inv Monte Carlo test');
end;

procedure TMainForm.RealCipher2Click(Sender: TObject);
begin
  CreateMDIChild(_REALCIPHER, 'Real cipher');
end;

end.
