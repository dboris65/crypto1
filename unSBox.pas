{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unSBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, Grids, SHDocVw_TLB;

type
  TfrSBox = class(TForm)
    Panel1: TPanel;
    pnTopRight: TPanel;
    Label1: TLabel;
    A: TEdit;
    btGMulInv: TButton;
    btCalcSBoxTable: TButton;
    WebBrowser1: TWebBrowser;
    btCalcOneSBoxValue: TButton;
    OneVal: TEdit;
    btCalc_One_SBox_Val_By_Matrix: TButton;
    Splitter1: TSplitter;
    pnLeft: TPanel;
    Memo1: TMemo;
    pnLeftDn: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    GridDec: TStringGrid;
    Label4: TLabel;
    GridHex: TStringGrid;
    Label5: TLabel;
    Label6: TLabel;
    AfterGridDec: TStringGrid;
    AfterGridHex: TStringGrid;
    Label7: TLabel;
    btSubButes: TButton;
    btClear: TButton;
    OneValM: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    procedure btCalcSBoxTableClick(Sender: TObject);
    procedure btGMulInvClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btCalcOneSBoxValueClick(Sender: TObject);
    procedure btCalc_One_SBox_Val_By_MatrixClick(Sender: TObject);
    procedure btSubButesClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure GridDecClick(Sender: TObject);
    procedure GridDecKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridDecSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure GridHexClick(Sender: TObject);
    procedure GridHexKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridHexSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
  public
    { Public declarations }
    state : array[0..3, 0..3] of Byte;
    InvSBox : array [0..255] of Byte;
    
    function BinToInt(Value: String): LongInt;
    function galoa_mul_inv(a : Byte) : Byte;
    function sbox_calc(a : Byte) : Byte;
    function sbox_calc_watch(a : Byte) : Byte;

    procedure fill_grid;
    procedure fill_after_grid;
    function validate_input(ACol, ARow: Integer; Value: String) : boolean;

  end;

var
  frSBox: TfrSBox;



implementation

uses MAIN;

{$R *.dfm}

procedure TfrSBox.fill_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      GridDec.Cells[i, j] := IntToStr(state[i, j]);
      GridHex.Cells[i, j] := IntToHex(state[i, j], 2);
  end;
end;

procedure TfrSBox.fill_after_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := IntToHex(state[i, j], 2);
      AfterGridDec.Cells[i, j] := IntToStr(state[i, j]);
  end;

end;

function TfrSBox.validate_input(ACol, ARow: Integer; Value: String) : boolean;
var ival : Integer;
begin

if not TryStrToInt(value, ival) then
begin
  ShowMessage('Invalid input!');
  validate_input := false;
  exit;
end;

if (ival<0) or (ival>255) then
begin
  ShowMessage('Invalid input!');
  validate_input := false;
  exit;
end;

state[ACol, ARow] := StrToInt(Value);
validate_input := true;

end;

function TfrSBox.galoa_mul_inv(a : Byte) : Byte;
begin
	// 0 is self inverting
	if (a = 0) then
		result := 0
	else
    result := exptable[(255 - ltable[a])];
end;

function TfrSBox.sbox_calc(a : Byte) : Byte;
var c, s, x : Byte;
begin
  s := galoa_mul_inv(a);
  x := s;
  for c := 0 to 3 do
  begin
    // circular rotate 1 bit to the left
    s := (s shl 1) or (s shr 7);
    // xor with x
    x := x XOR s;
  end;

  x := x XOR 99;  // $63
  result := x;
end;


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

function TfrSBox.sbox_calc_watch(a : Byte) : Byte;
var c, s, x : Byte;
    s_hex, s_bin : string;
begin

  Memo1.Lines.Add('Calculate one SBox value for given input.');
  Memo1.Lines.Add('    (A bit faster calculation)');

  s_hex := 'Input =        $' + IntToHex(a, 3);
  s_bin := IntToBin(a, 16);
  Memo1.Lines.Add( s_hex + ' ' +  s_bin);
  Memo1.Lines.Add('------------------------------------');
  Memo1.Lines.Add('');

  s := galoa_mul_inv(a);

  Memo1.Lines.Add('Multiplicative inverse of input =');
  s_hex := 's = x =        $' + IntToHex(s, 3);
  s_bin := IntToBin(s, 16);
  Memo1.Lines.Add( s_hex + ' ' +  s_bin);
  Memo1.Lines.Add('------------------------------------');
  Memo1.Lines.Add('');

  x := s;
  for c := 0 to 3 do
  begin

    s_hex := '$' + IntToHex(s shl 1, 3);
    s_bin := IntToBin(s shl 1, 16);
    Memo1.Lines.Add('s shl 1 =      ' + s_hex + ' ' +  s_bin + ' or ');

    s_hex := '$' + IntToHex(s shr 7, 3);
    s_bin := IntToBin(s shr 7, 16);
    Memo1.Lines.Add('s shr 7 =      ' + s_hex + ' ' +  s_bin);


    // circular rotate 1 bit to the left
    Memo1.Lines.Add('------------------------------------');
    s := (s shl 1) or (s shr 7);
    s_hex := '$' + IntToHex(s, 3);
    s_bin := IntToBin(s, 16);
    Memo1.Lines.Add('s = (s shl 1) or (s shr 7) = ');
    Memo1.Lines.Add('s =            ' + s_hex + ' ' +  s_bin);
    Memo1.Lines.Add('');

    // xor with x

    s_hex := '$' + IntToHex(x, 3);
    s_bin := IntToBin(x, 16);
    Memo1.Lines.Add('x =            ' + s_hex + ' ' +  s_bin + ' xor');
    s_hex := '$' + IntToHex(s, 3);
    s_bin := IntToBin(s, 16);
    Memo1.Lines.Add('s =            ' + s_hex + ' ' +  s_bin);
    Memo1.Lines.Add('------------------------------------');
    x := x XOR s;
    s_hex := '$' + IntToHex(x, 3);
    s_bin := IntToBin(x, 16);
    Memo1.Lines.Add('x = x xor s =  ');
    Memo1.Lines.Add('x =            ' + s_hex + ' ' +  s_bin);
    Memo1.Lines.Add('');


  end;

  x := x XOR 99;  // $63
  s_hex := '$' + IntToHex(x, 3);
  s_bin := IntToBin(x, 16);
  Memo1.Lines.Add('x xor $63(99)= ' + s_hex + ' ' +  s_bin);
  Memo1.Lines.Add('');
  Memo1.Lines.Add('------------------------------------');
  Memo1.Lines.Add('---------------------------------------------');
  Memo1.Lines.Add('Result =');
  Memo1.Lines.Add('SBox($' +  IntToHex(a, 2)  + ') = SBox(' +  IntToStr(a)  + ') = ' + s_hex + ' = ' + IntToStr(x) + ' = ' +  IntToBin(x, 8) );
  Memo1.Lines.Add('---------------------------------------------');


  Memo1.Lines.Add('');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('');

  result := x;
end;

procedure TfrSBox.btCalcSBoxTableClick(Sender: TObject);
var i, res : integer;
    s : string;
    line : integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('SBox table:');
  s := '   | 0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f';
  Memo1.Lines.Add(s);
  s := '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|';
  Memo1.Lines.Add(s);

  s := '00 |';
  line := 1;
  for i := 0 to 257 do
  begin
    res := sbox_calc(i);
    s := s + IntToHex(res, 2) + ', ';
    if i <= 255 then
      InvSBox[res] := i;
    if Length(s) = 4*17 then
    begin
      Memo1.Lines.Add(s);
      s := IntToHex(line, 2) + ' |';
      inc(line);
    end;
  end;

  Memo1.Lines.Add('');
  s := s + '...';
  Memo1.Lines.Add(s);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('InvSBox table:');

//***************** InvSBox *******************************
  s := '   | 0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f';
  Memo1.Lines.Add(s);
  s := '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|';
  Memo1.Lines.Add(s);

  s := '00 |';
  line := 1;
  for i := 0 to 255 do
  begin
    res := InvSBox[i];
    s := s + IntToHex(res, 2) + ', ';
    if Length(s) = 4*17 then
    begin
      Memo1.Lines.Add(s);
      s := IntToHex(line, 2) + ' |';
      inc(line);
    end;
  end;

  Memo1.Lines.Add('');
  s := s + '...';
  Memo1.Lines.Add(s);


end;

procedure TfrSBox.btGMulInvClick(Sender: TObject);
var ai, ri : integer;
    s : string;
begin
  if not TryStrToInt(A.Text, ai) then
  begin
    ShowMessage('Invalid input!');
    A.SetFocus;
    exit;
  end;
  if (ai < 0) or (ai > 255) then
  begin
    ShowMessage('Invalid input!');
    A.SetFocus;
    exit;
  end;
  Memo1.Clear;

  ri := galoa_mul_inv(ai);
  s := 'Multiplicative inverse of ' + IntToStr(ai) + ' is ' + IntToStr(ri);
  Memo1.Lines.Add(s);
  Memo1.Lines.Add('');
  s := 'gmul_inv(' + IntToStr(ai) + ') = ' + IntToStr(ri) + ' (dec)';
  Memo1.Lines.Add(s);
  Memo1.Lines.Add('');
  s := 'gmul_inv($' + IntTohex(ai, 2) + ') = $' + IntToHex(ri, 2) + ' (hex)';
  Memo1.Lines.Add(s);



end;

procedure TfrSBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TfrSBox.FormShow(Sender: TObject);
var s : string;
    i, j : integer;
begin
  // first round SubBytes - FIPS 197, page 33
  s := '193de3bea0f4e22b9ac68d2ae9f84808';

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt('$' + s[2*(4*i + j) + 1] + s[2*(4*i + j) + 2]);

  fill_grid;

  // Result should be like first round after SB - FIPS-197 page 33

  webBrowser1.Navigate(MainForm.DescriptionPath + 'SBox.htm');
end;

procedure TfrSBox.btCalcOneSBoxValueClick(Sender: TObject);
var i : integer;
begin

if not TryStrToInt(OneVal.Text, i) then
begin
  ShowMessage('Invalid input!');
  OneVal.SetFocus;
  exit;
end;
if (i < 0) or (i > 255) then
begin
  ShowMessage('Invalid input!');
  OneVal.SetFocus;
  exit;
end;

Memo1.Clear;
sbox_calc_watch(i);

end;

function TfrSBox.BinToInt(Value: String): LongInt;
var i: Integer;
begin
  Result:=0;
//remove leading zeroes
  while Copy(Value,1,1)='0' do
   Value:=Copy(Value,2,Length(Value)-1) ;
//do the conversion
  for i:=Length(Value) downto 1 do
   if Copy(Value,i,1)='1' then
    Result:=Result+(1 shl (Length(Value)-i)) ;
end;


var matrix : array [1..8] of byte =
                 ( 248, // 11111000
                   124, // 01111100
                   62,  // 00111110
                   31,  // 00011111

                   143, // 10001111
                   199, // 11000111
                   227, // 11100011
                   241  // 11110001
                 );

procedure TfrSBox.btCalc_One_SBox_Val_By_MatrixClick(Sender: TObject);
var hi_bit_set, matr, inp, input : byte;
    test : integer;
    matrix_bit, input_bit : byte;
    rez : Byte;
    final_xor : byte;
    i, j : integer;
    bits : string;
    s : string;
begin
  // (if) inp = 83 = 53h = 01010011
  if not TryStrToInt(OneValM.Text, test) then
  begin
    ShowMessage('Invalid input!');
    OneValM.SetFocus;
    exit;
  end;
  if (test < 0) or (test > 255) then
  begin
    ShowMessage('Invalid input!');
    OneValM.SetFocus;
    exit;
  end;
  input := test;

  rez := 0;
  bits := '';
  final_xor := 99;

  Memo1.Clear;

  Memo1.Lines.Add('Calculate one SBox value for given input.');
  Memo1.Lines.Add('     (using Matrix - slower)');

  Memo1.Lines.Add( '-------------------------------' );
  Memo1.Lines.Add( 'Input value' );
  Memo1.Lines.Add( IntToBin(test, 8) + ' = ' + IntToStr(test) + ' = $' + IntToHex(test, 2));
  inp := galoa_mul_inv(test);
  test := inp;

  Memo1.Lines.Add( '-------------------------------' );
  Memo1.Lines.Add( 'Multiplicative inverse of input' );
  Memo1.Lines.Add( IntToBin(test, 8) + ' = ' + IntToStr(test) + ' = $' + IntToHex(test, 2));

  Memo1.Lines.Add( '-------------------------------' );
  Memo1.Lines.Add( 'XOR result with fixed value' );
  Memo1.Lines.Add( IntToBin(final_xor, 8) + ' = ' + IntToStr(final_xor) + ' = $' + IntToHex(final_xor, 2));

  Memo1.Lines.Add( '-------------------------------' );
  Memo1.Lines.Add( 'Matrix multiplication' );
  Memo1.Lines.Add( IntToBin(matrix[1], 8) );
  Memo1.Lines.Add( IntToBin(matrix[2], 8) );
  Memo1.Lines.Add( IntToBin(matrix[3], 8) + '     ' + IntToStr(inp) + '                ' +  IntToStr(final_xor));
  Memo1.Lines.Add( IntToBin(matrix[4], 8) + ' * ' + IntToBin(inp, 8) + '   xor   ' + IntToBin(final_xor, 8));
  Memo1.Lines.Add( IntToBin(matrix[5], 8) );
  Memo1.Lines.Add( IntToBin(matrix[6], 8) );
  Memo1.Lines.Add( IntToBin(matrix[7], 8) );
  Memo1.Lines.Add( IntToBin(matrix[8], 8) );
  Memo1.Lines.Add( '--------------------------------------------------------------------------------' );
  Memo1.Lines.Add( 'a1*b1 xor a2*b2 xor...                                      xor      $63' );
  Memo1.Lines.Add( '                                                                      99 dec' );

  for i := 1 to 8 do
  begin
    inp := test;
    matr := matrix[i];    // 248 = 11111000,
                          // 124 = 01111100,
                          // 124 = 01111100,
                          //  62 = 00111110,
                          //  31 = 00011111,
                          // 143 = 10001111,
                          // 199 = 11000111,
                          // 227 = 11100011,
                          // 241 = 11110001

    s := '';
    Memo1.Lines.Add( 'Matrix row ' + IntToStr(i) + '.=  '+ IntToBin(matr, 8) );
    Memo1.Lines.Add( 'Input           ' + IntToBin(inp, 8) );
    for j := 1 to 8 do
    begin
      //**************************
      // bit 1-8 from matrix
      hi_bit_set:= (matr AND $80);  // 10000000 = 128 if true
      matr := matr SHL 1;
      if hi_bit_set = 128 then
         matrix_bit := 1
      else
         matrix_bit := 0;
      s := s + IntToStr(matrix_bit) + '*';

      //**************************
      // bit 1-8 from input
      hi_bit_set:= (inp AND $80); // 10000000 = 128 if true
      inp := inp SHL 1;
      if hi_bit_set = 128 then
         input_bit := 1
      else
         input_bit := 0;
      s := s + IntToStr(input_bit) + ' xor ';

      if j = 1 then
        rez := (matrix_bit * input_bit)
      else
        rez := rez xor (matrix_bit * input_bit);

    end;


    //**************************
    // bit 1-8 from final_xor = 99 = 01100011
    hi_bit_set:= (final_xor AND $80); // 10000000 = 128 if true
    final_xor := final_xor SHL 1;
    if hi_bit_set = 128 then
    begin
       rez := rez xor 1;
       s := s + '      1';
    end
    else
    begin
       rez := rez xor 0;
       s := s + '      0';
    end;

    Memo1.Lines.Add( s + '   =   ' + IntToStr(rez));
    bits := bits + IntToStr(rez);
    Memo1.Lines.Add( '' );
  end;

    Memo1.Lines.Add( '-------------------------------------------------------------------------------' );
    rez := BinToInt(bits);
    Memo1.Lines.Add('---------------------------------------------');
    Memo1.Lines.Add('Result = '); 
    Memo1.Lines.Add('SBox($' + IntToHex(input, 2) + ') = SBox(' + IntToStr(input) + ') = $' + IntToHex(rez, 2) + ' = ' + IntToStr(rez) + ' = ' +  IntToBin(rez, 8) );
    Memo1.Lines.Add('---------------------------------------------');

    Memo1.Lines.Add('');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('');

end;

procedure TfrSBox.btSubButesClick(Sender: TObject);
var i, j : integer;
begin
  btCalcSBoxTable.OnClick(nil);
  
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);


  // SubBytes
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := sbox[ state[i, j] ];

  fill_after_grid;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);

end;

procedure TfrSBox.btClearClick(Sender: TObject);
var i, j : integer;
begin

for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := '';
      AfterGridDec.Cells[i, j] := '';
  end;
end;

procedure TfrSBox.GridDecClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrSBox.GridDecKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrSBox.GridDecSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrSBox.GridHexClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrSBox.GridHexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrSBox.GridHexSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, '$'+Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

end.
