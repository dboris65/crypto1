{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unInvMixColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, OleCtrls, SHDocVw_Tlb, ExtCtrls;

type
  TfrInvMixColumns = class(TForm)
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
    btInvMixColumns: TButton;
    btClear: TButton;
    Splitter1: TSplitter;
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btInvMixColumnsClick(Sender: TObject);
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
     procedure InvMixColumns;
     function galoa_mul_tab(a : Byte; b : Byte) : Byte;
     procedure fill_grid;
     procedure fill_after_grid;
     function validate_input(ACol, ARow: Integer; Value: String) : boolean;
  end;

var
  frInvMixColumns: TfrInvMixColumns;

implementation

uses MAIN;


{$R *.dfm}

procedure TfrInvMixColumns.fill_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      GridDec.Cells[i, j] := IntToStr(state[i, j]);
      GridHex.Cells[i, j] := IntToHex(state[i, j], 2);
  end;
end;

procedure TfrInvMixColumns.fill_after_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := IntToHex(state[i, j], 2);
      AfterGridDec.Cells[i, j] := IntToStr(state[i, j]);
  end;

end;

function TfrInvMixColumns.galoa_mul_tab(a : Byte; b : Byte) : Byte;
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

procedure TfrInvMixColumns.InvMixColumns;
var c : Byte;
    a : array [0..3] of BYTE;
begin
// 0e 0b 0d 09
// 09 0e 0b 0d
// 0d 09 0e 0b
// 0b 0d 09 0e



  for c := 0 to 3 do
	  a[c] := state[0, c];
	state[0, 0] := galoa_mul_tab(a[0],$0e) xor galoa_mul_tab(a[1],$0b) xor galoa_mul_tab(a[2],$0d) xor galoa_mul_tab(a[3],$09);
	state[0, 1] := galoa_mul_tab(a[0],$09) xor galoa_mul_tab(a[1],$0e) xor galoa_mul_tab(a[2],$0b) xor galoa_mul_tab(a[3],$0d);
	state[0, 2] := galoa_mul_tab(a[0],$0d) xor galoa_mul_tab(a[1],$09) xor galoa_mul_tab(a[2],$0e) xor galoa_mul_tab(a[3],$0b);
	state[0, 3] := galoa_mul_tab(a[0],$0b) xor galoa_mul_tab(a[1],$0d) xor galoa_mul_tab(a[2],$09) xor galoa_mul_tab(a[3],$0e);
  for c := 0 to 3 do
	  a[c] := state[1, c];
	state[1, 0] := galoa_mul_tab(a[0],$0e) xor galoa_mul_tab(a[1],$0b) xor galoa_mul_tab(a[2],$0d) xor galoa_mul_tab(a[3],$09);
	state[1, 1] := galoa_mul_tab(a[0],$09) xor galoa_mul_tab(a[1],$0e) xor galoa_mul_tab(a[2],$0b) xor galoa_mul_tab(a[3],$0d);
	state[1, 2] := galoa_mul_tab(a[0],$0d) xor galoa_mul_tab(a[1],$09) xor galoa_mul_tab(a[2],$0e) xor galoa_mul_tab(a[3],$0b);
	state[1, 3] := galoa_mul_tab(a[0],$0b) xor galoa_mul_tab(a[1],$0d) xor galoa_mul_tab(a[2],$09) xor galoa_mul_tab(a[3],$0e);
  for c := 0 to 3 do
	  a[c] := state[2, c];
	state[2, 0] := galoa_mul_tab(a[0],$0e) xor galoa_mul_tab(a[1],$0b) xor galoa_mul_tab(a[2],$0d) xor galoa_mul_tab(a[3],$09);
	state[2, 1] := galoa_mul_tab(a[0],$09) xor galoa_mul_tab(a[1],$0e) xor galoa_mul_tab(a[2],$0b) xor galoa_mul_tab(a[3],$0d);
	state[2, 2] := galoa_mul_tab(a[0],$0d) xor galoa_mul_tab(a[1],$09) xor galoa_mul_tab(a[2],$0e) xor galoa_mul_tab(a[3],$0b);
	state[2, 3] := galoa_mul_tab(a[0],$0b) xor galoa_mul_tab(a[1],$0d) xor galoa_mul_tab(a[2],$09) xor galoa_mul_tab(a[3],$0e);
  for c := 0 to 3 do
	  a[c] := state[3, c];
	state[3, 0] := galoa_mul_tab(a[0],$0e) xor galoa_mul_tab(a[1],$0b) xor galoa_mul_tab(a[2],$0d) xor galoa_mul_tab(a[3],$09);
	state[3, 1] := galoa_mul_tab(a[0],$09) xor galoa_mul_tab(a[1],$0e) xor galoa_mul_tab(a[2],$0b) xor galoa_mul_tab(a[3],$0d);
	state[3, 2] := galoa_mul_tab(a[0],$0d) xor galoa_mul_tab(a[1],$09) xor galoa_mul_tab(a[2],$0e) xor galoa_mul_tab(a[3],$0b);
	state[3, 3] := galoa_mul_tab(a[0],$0b) xor galoa_mul_tab(a[1],$0d) xor galoa_mul_tab(a[2],$09) xor galoa_mul_tab(a[3],$0e);

end;



procedure TfrInvMixColumns.FormShow(Sender: TObject);
var s : string;
    i, j : integer;
begin
  // after ik_add - FIPS-197 page 37
  s := 'e9f74eec023020f61bf2ccf2353c21c7';

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt('$' + s[2*(4*i + j) + 1] + s[2*(4*i + j) + 2]);

  fill_grid;

  // Result is first InvMixColumns from FIPS-197
  // InvMixColumns = State at start of round (istart on FIPS-197 page 37)

  webBrowser1.Navigate(MainForm.DescriptionPath + 'InvMixColumns.htm');
end;

procedure TfrInvMixColumns.btClearClick(Sender: TObject);
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := '';
      AfterGridDec.Cells[i, j] := '';
  end;
end;

procedure TfrInvMixColumns.btInvMixColumnsClick(Sender: TObject);
var i, j : integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);

  InvMixColumns;
  fill_after_grid;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);

end;

function TfrInvMixColumns.validate_input(ACol, ARow: Integer; Value: String) : boolean;
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



procedure TfrInvMixColumns.GridDecClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrInvMixColumns.GridDecKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrInvMixColumns.GridDecSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrInvMixColumns.GridHexClick(Sender: TObject);
begin
fill_grid;
end;

procedure TfrInvMixColumns.GridHexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
    fill_grid;
end;

procedure TfrInvMixColumns.GridHexSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, '$'+Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrInvMixColumns.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.
