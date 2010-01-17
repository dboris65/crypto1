{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unShiftRows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, OleCtrls, SHDocVw_TLB;

type
  TfrShiftRows = class(TForm)
    pnLeft: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GridDec: TStringGrid;
    GridHex: TStringGrid;
    btShiftRows: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    AfterGridDec: TStringGrid;
    AfterGridHex: TStringGrid;
    btClear: TButton;
    WebBrowser1: TWebBrowser;
    Splitter1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btShiftRowsClick(Sender: TObject);
    procedure GridHexDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure AfterGridHexDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridDecSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure GridHexSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure GridDecDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridHexClick(Sender: TObject);
    procedure GridHexKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridDecKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridDecClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
     state : array[0..3, 0..3] of Byte;
     procedure ShiftRows;
     procedure fill_grid;
     procedure fill_after_grid;
     function validate_input(ACol, ARow: Integer; Value: String) : boolean;
  end;

var
  frShiftRows: TfrShiftRows;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrShiftRows.fill_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      GridDec.Cells[i, j] := IntToStr(state[i, j]);
      GridHex.Cells[i, j] := IntToHex(state[i, j], 2);
  end;
end;



procedure TfrShiftRows.fill_after_grid;
var i, j : integer;
begin
for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := IntToHex(state[i, j], 2);
      AfterGridDec.Cells[i, j] := IntToStr(state[i, j]);
  end;

end;

procedure TfrShiftRows.ShiftRows;
var temp1, temp2 : byte;
begin

  temp1 := state[0, 1];
  state[0, 1] := state[1, 1];
  state[1, 1] := state[2, 1];
  state[2, 1] := state[3, 1];
  state[3, 1] := temp1;

  temp1 := state[0, 2];
  temp2 := state[1, 2];
  state[0, 2] := state[2, 2];
  state[1, 2] := state[3, 2];
  state[2, 2] := temp1;
  state[3, 2] := temp2;

  temp1 := state[0, 3];
  state[0, 3] := state[3, 3];
  state[3, 3] := state[2, 3];
  state[2, 3] := state[1, 3];
  state[1, 3] := temp1;
end;

procedure TfrShiftRows.FormShow(Sender: TObject);
var s : string;
    i, j : integer;
begin
  // First ShiftRows from FIPS-197, page 33
  s := 'd42711aee0bf98f1b8b45de51e415230';

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt('$' + s[2*(4*i + j) + 1] + s[2*(4*i + j) + 2]);


  fill_grid;

  webBrowser1.Navigate(MainForm.DescriptionPath + 'ShiftRows.htm');
  
end;

procedure TfrShiftRows.btClearClick(Sender: TObject);
var i, j : integer;
begin

for i := 0 to 3 do
  for j := 0 to 3 do
  begin
      AfterGridHex.Cells[i, j] := '';
      AfterGridDec.Cells[i, j] := '';
  end;
end;

procedure TfrShiftRows.btShiftRowsClick(Sender: TObject);
var i, j : integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);


  ShiftRows;
  fill_after_grid;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := StrToInt(GridDec.Cells[i, j]);

end;

procedure TfrShiftRows.GridHexDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var s : string;
begin

  if ARow = 1 then
  begin
    if ACol = 0 then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end
  end
  else
  if ARow = 2 then
  begin
    if (ACol = 0) or (ACol = 1) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end
  else
  if ARow = 3 then
  begin
    if (ACol = 0) or (ACol = 1) or (ACol = 2) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end;

end;

procedure TfrShiftRows.AfterGridHexDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var s : string;
begin
  if ARow = 1 then
  begin
    if ACol = 3 then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end
  end
  else
  if ARow = 2 then
  begin
    if (ACol = 2) or (ACol = 3) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end
  else
  if ARow = 3 then
  begin
    if (ACol = 1) or (ACol = 2) or (ACol = 3) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end;

end;

function TfrShiftRows.validate_input(ACol, ARow: Integer; Value: String) : boolean;
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


procedure TfrShiftRows.GridDecSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrShiftRows.GridHexSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if Trim(Value) <> '' then
   if validate_input(ACol, ARow, '$'+Trim(Value)) = false then
   begin
      ShowMessage('Invalid input!');
      SysUtils.Abort;
   end;
end;

procedure TfrShiftRows.GridDecDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var s : string;
begin

  if ARow = 1 then
  begin
    if ACol = 0 then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end
  end
  else
  if ARow = 2 then
  begin
    if (ACol = 0) or (ACol = 1) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end
  else
  if ARow = 3 then
  begin
    if (ACol = 0) or (ACol = 1) or (ACol = 2) then
    begin
        (Sender as TStringGrid).Canvas.Font.Color := clRed;
        (Sender as TStringGrid).Canvas.Font.Style := [fsBold];
        (Sender as TStringGrid).Canvas.FillRect(Rect);
        S := (Sender as TStringGrid).Cells[ACol, ARow];
        (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end;
  end;

end;

procedure TfrShiftRows.GridHexClick(Sender: TObject);
begin
  fill_grid;
end;

procedure TfrShiftRows.GridHexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
  fill_grid;

end;

procedure TfrShiftRows.GridDecKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
  fill_grid;

end;

procedure TfrShiftRows.GridDecClick(Sender: TObject);
begin
  fill_grid;
end;

procedure TfrShiftRows.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.

