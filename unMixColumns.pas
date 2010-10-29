{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unMixColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, OleCtrls, SHDocVw_Tlb, ExtCtrls;

type
  TfrMixColumns = class(TForm)
    pnLeft: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GridDec: TStringGrid;
    GridHex: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    AfterGridDec: TStringGrid;
    AfterGridHex: TStringGrid;
    btMixColumns: TButton;
    btClear: TButton;
    Splitter1: TSplitter;
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btMixColumnsClick(Sender: TObject);
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
     state : array[0..3, 0..3] of Byte;
     procedure MixColumns;
     function galoa_mul_tab(a : Byte; b : Byte) : Byte;
     procedure fill_grid;
     procedure fill_after_grid;
     function validate_input(ACol, ARow: Integer; Value: String) : boolean;
  end;

var
  frMixColumns: TfrMixColumns;

implementation

uses MAIN;


{$R *.dfm}

procedure TfrMixColumns.fill_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      GridDec.Cells[i, j] := IntToStr(state[i, j]);
      GridHex.Cells[i, j] := IntToHex(state[i, j], 2);
  end;
end;

procedure TfrMixColumns.fill_after_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := IntToHex(state[i, j], 2);
      AfterGridDec.Cells[i, j] := IntToStr(state[i, j]);
  end;

end;

function TfrMixColumns.galoa_mul_tab(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  z := 0;
  s := Main.ltable[a] + Main.ltable[b]; // Tables are in main unit
  s := s mod 255;
  s := Main.exptable[s];
  if a = 0 then
    s := z;
  if b = 0 then
    s := z;
	result := s;
end;

procedure TfrMixColumns.MixColumns;
var c : Byte;
    a : array [0..3] of BYTE;
begin

// 02 03 01 01
// 01 02 03 01
// 01 01 02 03
// 03 01 01 02

  for c := 0 to 3 do
	  a[c] := state[0, c];
	state[0, 0] := galoa_mul_tab(a[0],2) xor galoa_mul_tab(a[1],3) xor galoa_mul_tab(a[3],1) xor galoa_mul_tab(a[2],1);
	state[0, 1] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],2) xor galoa_mul_tab(a[2],3) xor galoa_mul_tab(a[3],1);
	state[0, 2] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],2) xor galoa_mul_tab(a[3],3);
	state[0, 3] := galoa_mul_tab(a[0],3) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],1) xor galoa_mul_tab(a[3],2);
  for c := 0 to 3 do
	  a[c] := state[1, c];
	state[1, 0] := galoa_mul_tab(a[0],2) xor galoa_mul_tab(a[1],3) xor galoa_mul_tab(a[3],1) xor galoa_mul_tab(a[2],1);
	state[1, 1] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],2) xor galoa_mul_tab(a[2],3) xor galoa_mul_tab(a[3],1);
	state[1, 2] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],2) xor galoa_mul_tab(a[3],3);
	state[1, 3] := galoa_mul_tab(a[0],3) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],1) xor galoa_mul_tab(a[3],2);
  for c := 0 to 3 do
	  a[c] := state[2, c];
	state[2, 0] := galoa_mul_tab(a[0],2) xor galoa_mul_tab(a[1],3) xor galoa_mul_tab(a[3],1) xor galoa_mul_tab(a[2],1);
	state[2, 1] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],2) xor galoa_mul_tab(a[2],3) xor galoa_mul_tab(a[3],1);
	state[2, 2] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],2) xor galoa_mul_tab(a[3],3);
	state[2, 3] := galoa_mul_tab(a[0],3) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],1) xor galoa_mul_tab(a[3],2);
  for c := 0 to 3 do
	  a[c] := state[3, c];
	state[3, 0] := galoa_mul_tab(a[0],2) xor galoa_mul_tab(a[1],3) xor galoa_mul_tab(a[3],1) xor galoa_mul_tab(a[2],1);
	state[3, 1] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],2) xor galoa_mul_tab(a[2],3) xor galoa_mul_tab(a[3],1);
	state[3, 2] := galoa_mul_tab(a[0],1) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],2) xor galoa_mul_tab(a[3],3);
	state[3, 3] := galoa_mul_tab(a[0],3) xor galoa_mul_tab(a[1],1) xor galoa_mul_tab(a[2],1) xor galoa_mul_tab(a[3],2);

end;



procedure TfrMixColumns.FormShow(Sender: TObject);
var s : string;
    i, j : integer;
begin
  // First MixColumns from FIPS-197, page 33
  s := 'd4bf5d30e0b452aeb84111f11e2798e5';
{  state[0, 0] := $d4;
  state[1, 0] := $e0;
  state[2, 0] := $b8;
  state[3, 0] := $1e;

  state[0, 1] := $bf;
  state[1, 1] := $b4;
  state[2, 1] := $41;
  state[3, 1] := $27;

  state[0, 2] := $5d;
  state[1, 2] := $52;
  state[2, 2] := $11;
  state[3, 2] := $98;

  state[0, 3] := $30;
  state[1, 3] := $ae;
  state[2, 3] := $f1;
  state[3, 3] := $e5;
}

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt('$' + s[2*(4*i + j) + 1] + s[2*(4*i + j) + 2]);

  fill_grid;

  webBrowser1.Navigate(MainForm.DescriptionPath + 'MixColumns.htm');

end;

procedure TfrMixColumns.btClearClick(Sender: TObject);
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := '';
      AfterGridDec.Cells[i, j] := '';
  end;
end;

procedure TfrMixColumns.btMixColumnsClick(Sender: TObject);
var i, j : integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);

  MixColumns;
  fill_after_grid;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);
  
end;

function TfrMixColumns.validate_input(ACol, ARow: Integer; Value: String) : boolean;
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



procedure TfrMixColumns.GridDecClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrMixColumns.GridDecKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrMixColumns.GridDecSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrMixColumns.GridHexClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrMixColumns.GridHexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrMixColumns.GridHexSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, '$'+Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrMixColumns.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.
