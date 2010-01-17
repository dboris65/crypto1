{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unKeyExpansion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrKeyExpansion = class(TForm)
    Panel1: TPanel;
    rgAlgoritam: TRadioGroup;
    rgTestVektori: TRadioGroup;
    Kljuc: TEdit;
    lKljuc: TLabel;
    btExpandKey: TButton;
    Memo1: TMemo;
    procedure rgTestVektoriClick(Sender: TObject);
    procedure btExpandKeyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tmpkey : array [0..3] of BYTE;
    key : array [0..240] of Byte;
    memo_line : string;

    function galoa_mul_tab(a : Byte; b : Byte) : Byte;
    function rcon (a : Byte) : Byte;
    procedure RotWord;
    procedure key_exp_base(i : Byte);
    procedure KeyExpansion128;
    procedure KeyExpansion192;
    procedure KeyExpansion256;

  end;

var
  frKeyExpansion: TfrKeyExpansion;

implementation

uses MAIN;

{$R *.dfm}
{
function IntToBin ( value: LongInt; digits: integer ): string;
begin
    result := StringOfChar ( '0', digits ) ;
    while value > 0 do begin
      if ( value and 1 ) = 1 then
        result [ digits ] := '1';
      dec ( digits ) ;
      value := value shr 1;
    end;
end;

function hexChar(x: byte): char;
begin
  Result := #0;
  case x of
    0: Result := '0';
    1: Result := '1';
    2: Result := '2';
    3: Result := '3';
    4: Result := '4';
    5: Result := '5';
    6: Result := '6';
    7: Result := '7';
    8: Result := '8';
    9: Result := '9';
    10: Result := 'a';
    11: Result := 'b';
    12: Result := 'c';
    13: Result := 'd';
    14: Result := 'e';
    15: Result := 'f';
  end;
end;
}
{$WARNINGS OFF}
{
function hexToString(a: byte): string;
var
  x, y: byte;
begin
  x := a;
  if x < 0 then begin
    x := x shr 4;
    x := x xor $F0;
  end else
    x := x shr 4;

  y := a shl 4;
  if y < 0 then begin
    y := y shr 4;
    y := y xor $F0;
  end else
    y := y shr 4;
  Result := hexchar(x) + hexchar(y);
end;
}
{$WARNINGS ON}

function TfrKeyExpansion.galoa_mul_tab(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  z := 0;
  s := Main.ltable[a] + Main.ltable[b];
  s := s mod 255;
  s := exptable[s];
  if a = 0 then
    s := z;

  if b = 0 then
    s := z;

	result := s;
end;

function TfrKeyExpansion.rcon (a : Byte) : Byte;
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

procedure TfrKeyExpansion.RotWord;
var a, c : Byte;
begin
		a := tmpkey[0];
		for c := 0 to 3 do
    begin
      tmpkey[c] := tmpkey[c + 1];
      if c <> 3 then
         memo_line := memo_line + IntToHex(tmpkey[c], 2);
		end;
    tmpkey[3] := a;
    memo_line := memo_line + IntToHex(tmpkey[3], 2) + ' | ';
end;


procedure TfrKeyExpansion.key_exp_base(i : Byte);
var a : Byte;
begin
		// RotWord
		//---------------------    ---------------------
		//| 1d | 2c | 3a | 4f | -> | 2c | 3a | 4f | 1d |
		//---------------------    ---------------------
		RotWord; // work with tmpkey

		// AES S-box
    // SubWord
		for a := 0 to 3 do
    begin
				tmpkey[a] := sbox[ tmpkey[a] ];
        memo_line := memo_line + IntToHex(tmpkey[a], 2);
    end;
    memo_line := memo_line + ' | ';

    memo_line := memo_line + IntToHex(rcon(i), 2) + '000000 | ';

		//                     XOR  2 ^ i
    tmpkey[0] := tmpkey[0] XOR rcon(i);

		for a := 0 to 3 do
        memo_line := memo_line + IntToHex(tmpkey[a], 2);
    memo_line := memo_line + ' | ';

end;



//------------------------------------------------------------
{ 128 bits = 16 bytes (16x8)  }
procedure TfrKeyExpansion.KeyExpansion128;
var c, i, a : Byte;
    tmp_line1, tmp_line2 : string;
begin
  {c = 16 - 16 bytes are user defined}
  Memo1.Clear;


  c := 16;
	i := 1;
  memo_line := ' |          | After    | After    |          | After    |           | key[i]=temp     ';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | temp     | RotWord  | SubWord  | Rcon     | xor Rcon | key[i-16] | xor key[i-16]';
  Memo1.Lines.Add(memo_line);
  memo_line := ' |----------|----------|----------|----------|----------|-----------|--------------';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | ';
  tmp_line1 := '';
  tmp_line2 := '';

  // (10+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  while(c < 176) do
  begin
      // Last 4 bytes -> temp var.
      for  a := 0 to 3 do
      begin
        tmpkey[a] := key[a + c - 4];
        memo_line := memo_line + IntToHex(tmpkey[a], 2);
      end;
      memo_line := memo_line + ' | ';

     // Every four blocks (of four bytes),
     // do a little extra work
      if ((c mod 16) = 0) then
      begin
       key_exp_base(i); // work with tmpkey
       inc(i);
      end
      else
       memo_line := memo_line + '         |          |          |          | ';


      for a := 0 to 3 do
      begin
         tmp_line1 := tmp_line1 + IntToHex(key[c - 16], 2);
         // new key
         key[c] := key[c - 16] XOR tmpkey[a];
         tmp_line2 := tmp_line2 + IntToHex(key[c], 2);
         inc(c);
      end;
      memo_line := memo_line + tmp_line1 + '  | ' + tmp_line2;
      Memo1.Lines.Add(memo_line);
      memo_line := ' | ';
      tmp_line1 := '';
      tmp_line2 := '';

  end;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('------------------------------------------------------------------------------');
  memo_line := '';
  for i := 0 to 175 do
     memo_line := memo_line + IntToHex(key[i], 2);
  Memo1.Lines.Add(memo_line);

end;


//------------------------------------------------------------
{ 192 bits = 24 bytes, (24x8)  }
procedure TfrKeyExpansion.KeyExpansion192;
var c, i, a : Byte;
    tmp_line1, tmp_line2 : string;
begin
  {c = 24 - 24 bytes are user defined}
  Memo1.Clear;


  c := 24;
	i := 1;
  memo_line := ' |          | After    | After    |          | After    |           | key[i]=temp     ';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | temp     | RotWord  | SubWord  | Rcon     | xor Rcon | key[i-16] | xor key[i-16]';
  Memo1.Lines.Add(memo_line);
  memo_line := ' |----------|----------|----------|----------|----------|-----------|--------------';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | ';
  tmp_line1 := '';
  tmp_line2 := '';

  // (12+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  while(c < 208) do
  begin
      // Last 4 bytes in temp var.
      for  a := 0 to 3 do
      begin
        tmpkey[a] := key[a + c - 4];
        memo_line := memo_line + IntToHex(tmpkey[a], 2);
      end;
      memo_line := memo_line + ' | ';

     // Every 6 blocks (of four bytes),
     // do a little extra work
      if ((c mod 24) = 0) then
      begin
       key_exp_base(i); // work with tmpkey
       inc(i);
      end
      else
       memo_line := memo_line + '         |          |          |          | ';


      for a := 0 to 3 do
      begin
         tmp_line1 := tmp_line1 + IntToHex(key[c - 16], 2);
         key[c] := key[c - 24] XOR tmpkey[a];
         tmp_line2 := tmp_line2 + IntToHex(key[c], 2);
         inc(c);
      end;
      memo_line := memo_line + tmp_line1 + '  | ' + tmp_line2;
      Memo1.Lines.Add(memo_line);
      memo_line := ' | ';
      tmp_line1 := '';
      tmp_line2 := '';

  end;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('------------------------------------------------------------------------------');
  memo_line := '';
  for i := 0 to 207 do
     memo_line := memo_line + IntToHex(key[i], 2);
  Memo1.Lines.Add(memo_line);

end;


//------------------------------------------------------------
{ 256 bits = 32 bytes (32x8)   }
procedure TfrKeyExpansion.KeyExpansion256;
var c, i, a : Byte;
    tmp_line1, tmp_line2 : string;
begin
  //c = 32 - 32 bytes are user defined
  Memo1.Clear;

  c := 32;
	i := 1;

  memo_line := ' |          | After    | After    |          | After    |           | key[i]=temp     ';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | temp     | RotWord  | SubWord  | Rcon     | xor Rcon | key[i-16] | xor key[i-16]';
  Memo1.Lines.Add(memo_line);
  memo_line := ' |----------|----------|----------|----------|----------|-----------|--------------';
  Memo1.Lines.Add(memo_line);
  memo_line := ' | ';
  tmp_line1 := '';
  tmp_line2 := '';


  // (14+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  while(c < 240) do
  begin
      // Last 4 bytes in temp var.
      for  a := 0 to 3 do
      begin
        tmpkey[a] := key[a + c - 4];
        memo_line := memo_line + IntToHex(tmpkey[a], 2);
      end;
      memo_line := memo_line + ' | ';

     // Every 8 blocks (of four bytes),
     // do a little extra work
      if ((c mod 32) = 0) then
      begin
       key_exp_base(i);  // work with tmpkey
       inc(i);
      end
      else
       memo_line := memo_line + '         |          |          |          | ';


      // 256 bit key - Extra S-Box
      if ((c mod 32) = 16) then
      begin
        for a := 0 to 3 do
        begin
            tmpkey[a] := sbox[ tmpkey[a] ];
            tmp_line1 := tmp_line1 + IntToHex(tmpkey[a], 2);
        end;

        for a := 1 to 8 do
            memo_line[25 + a] := tmp_line1[a];
        tmp_line1 := '';
      end;

      for a := 0 to 3 do
      begin
         tmp_line1 := tmp_line1 + IntToHex(key[c - 16], 2);
         key[c] := key[c - 32] XOR tmpkey[a];
         tmp_line2 := tmp_line2 + IntToHex(key[c], 2);
         inc(c);
      end;
      memo_line := memo_line + tmp_line1 + '  | ' + tmp_line2;
      Memo1.Lines.Add(memo_line);
      memo_line := ' | ';
      tmp_line1 := '';
      tmp_line2 := '';

  end;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('------------------------------------------------------------------------------');
  memo_line := '';
  for i := 0 to 239 do
     memo_line := memo_line + IntToHex(key[i], 2);
  Memo1.Lines.Add(memo_line);

end;

procedure TfrKeyExpansion.rgTestVektoriClick(Sender: TObject);
begin

if rgTestVektori.ItemIndex = 0 then
begin
  rgAlgoritam.ItemIndex := 0;
  Kljuc.Text := '2b7e151628aed2a6abf7158809cf4f3c';
end
else
if rgTestVektori.ItemIndex = 1 then
begin
  rgAlgoritam.ItemIndex := 0;
  Kljuc.Text := '000102030405060708090a0b0c0d0e0f';
end
else
if rgTestVektori.ItemIndex = 2 then
begin
  rgAlgoritam.ItemIndex := 1;
  Kljuc.Text := '8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b';
end
else
if rgTestVektori.ItemIndex = 3 then
begin
  rgAlgoritam.ItemIndex := 1;
  Kljuc.Text := '000102030405060708090a0b0c0d0e0f1011121314151617';
end
else
if rgTestVektori.ItemIndex = 4 then
begin
  rgAlgoritam.ItemIndex := 2;
  Kljuc.Text := '603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4';
end
else
if rgTestVektori.ItemIndex = 5 then
begin
  rgAlgoritam.ItemIndex := 2;
  Kljuc.Text := '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';
end;



end;

procedure TfrKeyExpansion.btExpandKeyClick(Sender: TObject);
var skljuc : array [0..240] of Byte;
    s : string;
    i : integer;
    init_key_len, key_len : integer;
begin

  init_key_len := 16;
  key_len := 128;
  if rgAlgoritam.ItemIndex = 0 then
  begin
    init_key_len := 16;
    key_len := 128;
  end
  else
  if rgAlgoritam.ItemIndex = 1 then
  begin
    init_key_len := 24;
    key_len := 192;
  end
  else
  if rgAlgoritam.ItemIndex = 2 then
  begin
    init_key_len := 32;
    key_len := 256;
  end;


  FillChar(skljuc, 240, 0);
  s := Kljuc.Text;
  if Length(s) <> 2 * init_key_len then
  begin
    if idYES = Application.MessageBox(PChar('Key lenght <> ' + IntToStr(init_key_len + 1) +' bytes. Key will be padded with zeroes. Do you want to continue?'),
                                      'Warning', MB_YESNO	) then
    begin
      for i := 0 to init_key_len do
      begin
            if 2*i+1 > Length(s) then break;
            skljuc[i] := StrToInt('$' + s[2*i+1] + s[2*i+2]);
      end;
    end
    else
    exit;
  end
  else
      for i := 0 to init_key_len - 1 do
            skljuc[i] := StrToInt('$' + s[2*i+1] + s[2*i+2]);



  for i := 0 to 240 do
      key[i] := $00;

  if key_len = 128 then
  begin
    for i := 0 to 15 do
      key[i] := skljuc[i];
    KeyExpansion128;
  end
  else
  if key_len = 192 then
  begin
    for i := 0 to 23 do
      key[i] := skljuc[i];
    KeyExpansion192;
  end
  else
  if key_len = 256 then
  begin
    for i := 0 to 31 do
      key[i] := skljuc[i];
    KeyExpansion256;
  end;


end;

procedure TfrKeyExpansion.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TfrKeyExpansion.FormShow(Sender: TObject);
begin
memo_line := '';
end;

end.
