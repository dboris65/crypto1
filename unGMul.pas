{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unGMul;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw_Tlb;

type
  TfrGMul = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    pnTopRight: TPanel;
    btGenExpTableHex: TButton;
    Label3: TLabel;
    cbGenerators: TComboBox;
    btGMulTab: TButton;
    Label1: TLabel;
    A: TEdit;
    Label2: TLabel;
    B: TEdit;
    Label4: TLabel;
    R: TEdit;
    Label5: TLabel;
    Rhex: TEdit;
    WebBrowser1: TWebBrowser;
    Splitter1: TSplitter;
    btGMulSlow: TButton;
    procedure btGenExpTableHexClick(Sender: TObject);
    procedure btGMulTabClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btGMulSlowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function galois_mul_slow(a : Byte; b : Byte) : Byte;
    function galois_mul_watch(a : Byte; b : Byte) : Byte;

    function galois_mul_tab(a : Byte; b : Byte) : Byte;
    function galois_mul_tab_watch(a : Byte; b : Byte) : Byte;
  end;

var
  frGMul: TfrGMul;
  generators : array [1..128] of Byte = (
    3,   5,   6,   9,  11,  14,  17,  18,  19,  20,  23,  24,  25,  26,  28,  30,  31,
   33,  34,  35,  39,  40,  42,  44,  48,  49,  60,  62,  63,  65,  69,  70,  71,  72,
   73,  75,  76,  78,  79,  82,  84,  86,  87,  88,  89,  90,  91,  95, 100, 101, 104,
  105, 109, 110, 112, 113, 118, 119, 121, 122, 123, 126, 129, 132, 134, 135, 136, 138,
  142, 143, 144, 147, 149, 150, 152, 153, 155, 157, 160, 164, 165, 166, 167, 169, 170,
  172, 173, 178, 180, 183, 184, 185, 186, 190, 191, 192, 193, 196, 200, 201, 206, 207,
  208, 214, 215, 218, 220, 221, 222, 226, 227, 229, 230, 231, 233, 234, 235, 238, 240,
  241, 244, 245, 246, 248, 251, 253, 254, 255);
implementation

uses MAIN;

{$R *.dfm}

//******************************************************************************
procedure TfrGMul.FormShow(Sender: TObject);
var i : integer;
begin
  for i := 1 to 128 do
    cbGenerators.Items.Add(IntToStr(generators[i]));
  cbGenerators.ItemIndex := 111;
  // generator 229 is actualy used to build tables in this program
  webBrowser1.Navigate(MainForm.DescriptionPath + 'GMul.htm');
end;



//******************************************************************************
// Galois multiplication using tables
function TfrGMul.galois_mul_tab(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  z := 0;
  s := Main.ltable[a] + Main.ltable[b]; // Tables are in main unit
  s := s mod 255;                       // Circular reduction - if s >= 255
  s := Main.exptable[s];
  if a = 0 then
    s := z;
  if b = 0 then
    s := z;
	result := s;
end;

//******************************************************************************
// Galois multiplication using tables - with subresults
function TfrGMul.galois_mul_tab_watch(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  Memo1.Lines.Add('----------------------------------------------');
  Memo1.Lines.Add('a = $' + IntToHex(a, 2));
  Memo1.Lines.Add('b = $' + IntToHex(b, 2));

  z := 0;
  Memo1.Lines.Add('ltable[$' + IntToHex(a, 2) + '] = $' + IntToHex(Main.ltable[a], 2));
  Memo1.Lines.Add('ltable[$' + IntToHex(b, 2) + '] = $' + IntToHex(Main.ltable[b], 2));
  Memo1.Lines.Add('');

  s := Main.ltable[a] + Main.ltable[b]; // Tables are in main unit
  Memo1.Lines.Add('ltable[$' + IntToHex(a, 2) + '] + ' + 'ltable[$' + IntToHex(b, 2) + '] = $' + IntToHex(s, 2));

  Memo1.Lines.Add('s = s mod 255 = $' + IntToHex(s, 2) + ' mod $FF = ');
  s := s mod 255;
  Memo1.Lines.Add('s = $' + IntToHex(s, 2) );
  Memo1.Lines.Add('');

  Memo1.Lines.Add('s = exptable[$' + IntToHex(s, 2) + '] =');
  s := Main.exptable[s];
  Memo1.Lines.Add('s = $' + IntToHex(s, 2) );

  if a = 0 then
    s := z;
  if b = 0 then
    s := z;
  Memo1.Lines.Add('if (a = 0) or (b = 0) then result = 0 ');
  Memo1.Lines.Add('s = $' + IntToHex(s, 2) );

	result := s;
end;

//******************************************************************************
// slow version
function TfrGMul.galois_mul_slow(a : Byte; b : Byte) : Byte;
var p                   : Byte;
    cntr                : Byte;
    hi_bit_set          : Byte;
begin
  p := 0; 
  for cntr := 0 to 7 do
  begin
    if((b AND 1) = 1) then
	    p := p XOR a;
    hi_bit_set:= (a AND $80);
    a := a SHL 1;
                                 {SHL already implemented, thus we do not use $11B, but $1B}
    if (hi_bit_set = $80) then   // $1b = 11011
    	a := a XOR $1b;

    b := b SHR 1; 
  end;
  Result := p;
end;
//******************************************************************************
// slow version - with subresults
function TfrGMul.galois_mul_watch(a : Byte; b : Byte) : Byte;
var p                   : Byte;
    cntr                : Byte;
    hi_bit_set          : Byte;
    irreducible         : Byte;
    hex_mul             : string;

    function poly_from_byte(b : byte) : string;
    var counter : Byte;
        bin, poly : string;
    begin
      result := '';
      bin := '';
      poly := '';
      for counter := 0 to 7 do
      begin
        if (b AND $80) = $80 then
        begin
          bin := bin + '1';
          if counter = 7 then
            poly := poly + ' 1'
          else
          if counter = 6 then
            poly := poly + ' X'
          else
            poly := poly + ' X^' + IntToStr(7-counter);

          if counter < 7 then
             poly := poly + '+';
        end
        else
          bin := bin + '0';

        b := b SHL 1;
      end;
      if poly <> '' then
        if poly[length(poly)] = '+' then
           delete(poly, length(poly), 1);
      result := bin + ' ' + poly;
    end;

begin
  p := 0;
  hex_mul := '$' + IntToHex(a, 2) + ' gmul ' + '$' + IntToHex(b, 2) + ' =';
  irreducible := $1b;
  for cntr := 0 to 7 do
  begin
    Memo1.Lines.Add('********************************************************************************************');
    Memo1.Lines.Add('--------------------------------------------------------------------------------------------');
    Memo1.Lines.Add('        cntr = ' + IntToStr(cntr));
    Memo1.Lines.Add('a            = ' + poly_from_byte(a));
    Memo1.Lines.Add('b            = ' + poly_from_byte(b));
    Memo1.Lines.Add('p            = ' + poly_from_byte(p));
    Memo1.Lines.Add('');


    if((b AND 1) = 1) then
	  begin
      Memo1.Lines.Add('---------------------------------------------------------------');
      Memo1.Lines.Add('               //LoBitSet(b)? p=p+a.');
      Memo1.Lines.Add('               if (b AND 1) = 1 then: ');
      Memo1.Lines.Add('p:             ' + poly_from_byte(p));
      Memo1.Lines.Add('               XOR');
      Memo1.Lines.Add('a:             ' + poly_from_byte(a));
      if hex_mul <> '' then
        if hex_mul[length(hex_mul)] = '=' then
          hex_mul := hex_mul + ' ' + '$' + IntToHex(a, 2)
        else
          hex_mul := hex_mul + ' galois_add ' + '$' + IntToHex(a, 2);

      p := p XOR a;

      Memo1.Lines.Add('');
      Memo1.Lines.Add('p=             ' + poly_from_byte(p));
      Memo1.Lines.Add('---------------------------------------------------------------');
    end;

    hi_bit_set:= (a AND $80);
    if (hi_bit_set = $80) then
       Memo1.Lines.Add('               HiBitSet(a) = true; Need reduction!')
    else
       Memo1.Lines.Add('               HiBitSet(a) = false');

    a := a SHL 1;
    Memo1.Lines.Add('---------------------------------------------------------------');
    Memo1.Lines.Add('(a SHL 1):     ' + poly_from_byte(a));

                                 // this is modulo $11b
    if (hi_bit_set = $80) then   // $1b = 11011
    begin
      Memo1.Lines.Add('---------------------------------------------------------------');
      Memo1.Lines.Add('               if HiBitSet_InPreviousStep(a) then: // Reduction!');

      Memo1.Lines.Add('a:             ' + poly_from_byte(a));
      Memo1.Lines.Add('               XOR');
      Memo1.Lines.Add('0x1B:          ' + poly_from_byte(irreducible));
    	a := a XOR $1b;            // We already shifted a, so
                                 // we wont use $11b, but $1b
      Memo1.Lines.Add('a=             ' + poly_from_byte(a));
    end;

    b := b SHR 1;
    Memo1.Lines.Add('---------------------------------------------------------------');
    Memo1.Lines.Add('(b SHR 1):     ' + poly_from_byte(b));

    Memo1.Lines.Add('---------------------------------------------------------------');
    Memo1.Lines.Add('a =            ' + poly_from_byte(a));
    Memo1.Lines.Add('b =            ' + poly_from_byte(b));
    Memo1.Lines.Add('p =            ' + poly_from_byte(p));

  end;
  Memo1.Lines.Add('');
  Memo1.Lines.Add(hex_mul);
  Memo1.Lines.Add('= $' + IntToHex(p, 2));
  Memo1.Lines.Add('=  ' + IntToStr(p) + ' dec');

  Result := p;
end;

//******************************************************************************
// generate exp and log tables and show results
procedure TfrGMul.btGenExpTableHexClick(Sender: TObject);
var ibase : integer;      // ibase = generator
    i, mult : integer;
    s_exp, s_log : string;
    line : integer;
    ltab : array [0..255] of Byte;
    exptab : array [0..255] of Byte;

    JJ : Integer;
begin
  if not TryStrToInt(Trim(cbGenerators.Items[cbGenerators.ItemIndex]), ibase) then
  begin
    ShowMessage('Invalid input!');
    exit;
  end;
  Memo1.Clear;
  s_exp := 'Exp table:';
  Memo1.Lines.Add(s_exp);
  s_exp := '   | 0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f';
  Memo1.Lines.Add(s_exp);
  s_exp := '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|';
  Memo1.Lines.Add(s_exp);


  s_exp := '00 |01, ';
  mult := 1;
  line := 1;

             // 255 + 4 more - to show repetition
  for i := 1 to 259 do
  begin
    // we use slow version only to generate tables
    mult := galois_mul_slow(mult, ibase);
    s_exp := s_exp + IntToHex(mult, 2) + ', ';


    // here we can:
    // store ExpTable in array
    // store LTable in array (recall that i <= 255 )
    if i < 256 then
    begin
      exptab[i] := mult;
      ltab[mult] := i;
    end;

    if Length(s_exp) = 4*17 then
    begin
      Memo1.Lines.Add(s_exp);
      if line < 16 then
         s_exp := IntToHex(line, 2) + ' |'
      else
         s_exp := '........';
      inc(line);
    end;
  end;

  Memo1.Lines.Add('');
  s_exp := s_exp + '...';
  Memo1.Lines.Add(s_exp);




  // print logartihm table
  Memo1.Lines.Add('');

  s_log := 'Logarithm table:';
  Memo1.Lines.Add(s_log);
  s_log := '   | 0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f';
  Memo1.Lines.Add(s_log);
  s_log := '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|';
  Memo1.Lines.Add(s_log);
  s_log := '00 |--, ';
  line := 1;
              // 255 + 4 more - to show repetition
  for i := 1 to 259 do
  begin
    s_log := s_log + IntToHex(ltab[i], 2) + ', ';

    if Length(s_log) = 4*17 then
    begin
      Memo1.Lines.Add(s_log);
      if line < 16 then
         s_log := IntToHex(line, 2) + ' |';
      inc(line);
    end;
  end;
  Memo1.Lines.Add('');


end;


//******************************************************************************
// check input values and call galois_mul_tab_watch
procedure TfrGMul.btGMulTabClick(Sender: TObject);
var ai, bi, ri : integer;
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

  if not TryStrToInt(B.Text, bi) then
  begin
    ShowMessage('Invalid input!');
    B.SetFocus;
    exit;
  end;
  if (bi < 0) or (bi > 255) then
  begin
    ShowMessage('Invalid input!');
    B.SetFocus;
    exit;
  end;

  Memo1.Clear;
  // We will alwais use generator 229 ($E5) in further code
  cbGenerators.ItemIndex := 111;
  btGenExpTableHex.OnClick(nil);


  ri := galois_mul_tab_watch(ai, bi);
  R.Text := IntToStr(ri);
  Rhex.Text := '$' + IntToHex(ri, 2);
end;

procedure TfrGMul.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;


procedure TfrGMul.btGMulSlowClick(Sender: TObject);
var ai, bi, ri : integer;
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

  if not TryStrToInt(B.Text, bi) then
  begin
    ShowMessage('Invalid input!');
    B.SetFocus;
    exit;
  end;
  if (bi < 0) or (bi > 255) then
  begin
    ShowMessage('Invalid input!');
    B.SetFocus;
    exit;
  end;

  Memo1.Clear;
  ri := galois_mul_watch(ai, bi);
  R.Text := IntToStr(ri);
  Rhex.Text := '$' + IntToHex(ri, 2);
end;

end.
