{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
unit unAES;

interface
uses
   StdCtrls, SysUtils {$ifdef win32},Dialogs, ComCtrls {$endif};
type
    TAES = class(TObject)
    private
    public
      tmpkey : array [0..3] of BYTE;
      key : array [0..239] of Byte;
      state : array[0..3, 0..3] of Byte;
      input : array[0..3, 0..3] of Byte;
      output : array[0..3, 0..3] of Byte;

      file_size    : integer;
      byte_counter : integer; // for files

      MemoOut : TMemo; // to show subresults, may be Null

      {$ifdef win32}
      ProgressBar : TProgressBar;
      {$endif}

      // helper functions and procedures
      procedure fillState(var buff: array of byte);
      procedure printstate(sout : string);
      function galoa_mul_tab(a : Byte; b : Byte) : Byte;
      procedure string_to_key(keyString : string);

      // AES
      procedure RotWord;
      function rcon (a : Byte) : Byte;
      procedure key_exp_base(i : Byte);
      procedure KeyExpansion128;
      procedure KeyExpansion192;
      procedure KeyExpansion256;
      procedure AddRoundKey(key_index : byte);

      procedure MixColumns;
      procedure InvMixColumns;
      procedure ShiftRows;
      procedure InvShiftRows;

      // key_len - 128, 192 or 256 - indicate algorithm
      procedure Cipher(key_len : Integer);
      procedure InvCipher(key_len : Integer);

      // For TESTING only - large number of subresults
      procedure Cipher_watch(key_len : Integer);
      procedure InvCipher_watch(key_len : Integer);

      //------------------------------------------------------------------------
      // from here, names of functions are not from FIPS-197

      procedure set_input(inp : array of byte);

      //***************************************************************************
      // Set State, Input, Output and Key buffers to $00, and perform Key Expansion
      // key_len - 128, 192 or 256 - indicate algorithm
      procedure initialise(in_key : array of byte; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});

      //************************************************************************
      // real cipher/invcipher,
      // Arguments:
      // in_file_name, out_file_name - file names (string)
      // InKey as string of hex values. For example: '2b7e151628aed2a6abf7158809cf4f3c'
      // key_len - 128, 192 or 256 - indicate algorithm
      procedure cipher_file(in_file_name : string; out_file_name : string;
                              inkey : string; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});
      procedure inv_cipher_file(in_file_name : string; out_file_name : string;
                              inkey : string; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});


      //************************************************************************
      // TESTING with large number of subresults
      // For testing only - initialise with MEMO as output device
      // Set State, Input, Output and Key buffers to $00, and perform Key Expansion
      // key_len - 128, 192 or 256 - indicate algorithm
      procedure inicijalizuj_watch(OutDevice : TMemo; in_key : array of byte; key_len : Integer);
      // For testing only - take 3 files as args - input, output and KEY file
      // This is VERY slow, because of large number of subresults given in Memo
      procedure SifrujDatoteku(in_file_name : string; out_file_name : string;
                               key_file_name : string; duzina_kljuca : Integer;
                               OutDevice : TMemo);
      // For testing only - take 3 files as args - input, output and KEY IN FILE
      // This is VERY slow, because of large number of subresults given in Memo
      procedure DeSifrujDatoteku(in_file_name : string; out_file_name : string;
                                 key_file_name : string; duzina_kljuca : Integer;
                                 OutDevice : TMemo);
    end;


function hexToByte(y: string): byte;
function hexToBit(a: char): byte;

implementation
var
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


InvSBox : array [0..255] of Byte = (
$52, $09, $6a, $d5, $30, $36, $a5, $38, $bf, $40, $a3, $9e, $81, $f3, $d7, $fb,
$7c, $e3, $39, $82, $9b, $2f, $ff, $87, $34, $8e, $43, $44, $c4, $de, $e9, $cb,
$54, $7b, $94, $32, $a6, $c2, $23, $3d, $ee, $4c, $95, $0b, $42, $fa, $c3, $4e,
$08, $2e, $a1, $66, $28, $d9, $24, $b2, $76, $5b, $a2, $49, $6d, $8b, $d1, $25,
$72, $f8, $f6, $64, $86, $68, $98, $16, $d4, $a4, $5c, $cc, $5d, $65, $b6, $92, 
$6c, $70, $48, $50, $fd, $ed, $b9, $da, $5e, $15, $46, $57, $a7, $8d, $9d, $84, 
$90, $d8, $ab, $00, $8c, $bc, $d3, $0a, $f7, $e4, $58, $05, $b8, $b3, $45, $06, 
$d0, $2c, $1e, $8f, $ca, $3f, $0f, $02, $c1, $af, $bd, $03, $01, $13, $8a, $6b,
$3a, $91, $11, $41, $4f, $67, $dc, $ea, $97, $f2, $cf, $ce, $f0, $b4, $e6, $73, 
$96, $ac, $74, $22, $e7, $ad, $35, $85, $e2, $f9, $37, $e8, $1c, $75, $df, $6e,
$47, $f1, $1a, $71, $1d, $29, $c5, $89, $6f, $b7, $62, $0e, $aa, $18, $be, $1b, 
$fc, $56, $3e, $4b, $c6, $d2, $79, $20, $9a, $db, $c0, $fe, $78, $cd, $5a, $f4,
$1f, $dd, $a8, $33, $88, $07, $c7, $31, $b1, $12, $10, $59, $27, $80, $ec, $5f,
$60, $51, $7f, $a9, $19, $b5, $4a, $0d, $2d, $e5, $7a, $9f, $93, $c9, $9c, $ef,
$a0, $e0, $3b, $4d, $ae, $2a, $f5, $b0, $c8, $eb, $bb, $3c, $83, $53, $99, $61,
$17, $2b, $04, $7e, $ba, $77, $d6, $26, $e1, $69, $14, $63, $55, $21, $0c, $7d);


//Tabela logaritama dobijena koristenjem 0xe5 (229) kao generatora
ltable : array [0..255] of Byte = (
$00, $ff, $c8, $08, $91, $10, $d0, $36,
$5a, $3e, $d8, $43, $99, $77, $fe, $18,
$23, $20, $07, $70, $a1, $6c, $0c, $7f,
$62, $8b, $40, $46, $c7, $4b, $e0, $0e,
$eb, $16, $e8, $ad, $cf, $cd, $39, $53,
$6a, $27, $35, $93, $d4, $4e, $48, $c3,
$2b, $79, $54, $28, $09, $78, $0f, $21,
$90, $87, $14, $2a, $a9, $9c, $d6, $74,
$b4, $7c, $de, $ed, $b1, $86, $76, $a4,
$98, $e2, $96, $8f, $02, $32, $1c, $c1,
$33, $ee, $ef, $81, $fd, $30, $5c, $13,
$9d, $29, $17, $c4, $11, $44, $8c, $80,
$f3, $73, $42, $1e, $1d, $b5, $f0, $12,
$d1, $5b, $41, $a2, $d7, $2c, $e9, $d5,
$59, $cb, $50, $a8, $dc, $fc, $f2, $56,
$72, $a6, $65, $2f, $9f, $9b, $3d, $ba,
$7d, $c2, $45, $82, $a7, $57, $b6, $a3,
$7a, $75, $4f, $ae, $3f, $37, $6d, $47,
$61, $be, $ab, $d3, $5f, $b0, $58, $af,
$ca, $5e, $fa, $85, $e4, $4d, $8a, $05,
$fb, $60, $b7, $7b, $b8, $26, $4a, $67,
$c6, $1a, $f8, $69, $25, $b3, $db, $bd,
$66, $dd, $f1, $d2, $df, $03, $8d, $34,
$d9, $92, $0d, $63, $55, $aa, $49, $ec,
$bc, $95, $3c, $84, $0b, $f5, $e6, $e7,
$e5, $ac, $7e, $6e, $b9, $f9, $da, $8e,
$9a, $c9, $24, $e1, $0a, $15, $6b, $3a,
$a0, $51, $f4, $ea, $b2, $97, $9e, $5d,
$22, $88, $94, $ce, $19, $01, $71, $4c,
$a5, $e3, $c5, $31, $bb, $cc, $1f, $2d,
$3b, $52, $6f, $f6, $2e, $89, $f7, $c0,
$68, $1b, $64, $04, $06, $bf, $83, $38 );

// tabela eksponenata
exptable : array [0..255] of Byte = (
$01, $e5, $4c, $b5, $fb, $9f, $fc, $12,
$03, $34, $d4, $c4, $16, $ba, $1f, $36,
$05, $5c, $67, $57, $3a, $d5, $21, $5a,
$0f, $e4, $a9, $f9, $4e, $64, $63, $ee,
$11, $37, $e0, $10, $d2, $ac, $a5, $29,
$33, $59, $3b, $30, $6d, $ef, $f4, $7b,
$55, $eb, $4d, $50, $b7, $2a, $07, $8d,
$ff, $26, $d7, $f0, $c2, $7e, $09, $8c,
$1a, $6a, $62, $0b, $5d, $82, $1b, $8f,
$2e, $be, $a6, $1d, $e7, $9d, $2d, $8a,
$72, $d9, $f1, $27, $32, $bc, $77, $85,
$96, $70, $08, $69, $56, $df, $99, $94,
$a1, $90, $18, $bb, $fa, $7a, $b0, $a7,
$f8, $ab, $28, $d6, $15, $8e, $cb, $f2,
$13, $e6, $78, $61, $3f, $89, $46, $0d,
$35, $31, $88, $a3, $41, $80, $ca, $17,
$5f, $53, $83, $fe, $c3, $9b, $45, $39,
$e1, $f5, $9e, $19, $5e, $b6, $cf, $4b,
$38, $04, $b9, $2b, $e2, $c1, $4a, $dd,
$48, $0c, $d0, $7d, $3d, $58, $de, $7c,
$d8, $14, $6b, $87, $47, $e8, $79, $84,
$73, $3c, $bd, $92, $c9, $23, $8b, $97,
$95, $44, $dc, $ad, $40, $65, $86, $a2,
$a4, $cc, $7f, $ec, $c0, $af, $91, $fd,
$f7, $4f, $81, $2f, $5b, $ea, $a8, $1c,
$02, $d1, $98, $71, $ed, $25, $e3, $24,
$06, $68, $b3, $93, $2c, $6f, $3e, $6c,
$0a, $b8, $ce, $ae, $74, $b1, $42, $b4,
$1e, $d3, $49, $e9, $9c, $c8, $c6, $c7,
$22, $6e, $db, $20, $bf, $43, $51, $52,
$66, $b2, $76, $60, $da, $c5, $f3, $f6,
$aa, $cd, $9a, $a0, $75, $54, $0e, $01 );


function hexToBit(a: char): byte;
begin
  Result := byte($FF);
  case a of
    '0': Result := $00;
    '1': Result := $01;
    '2': Result := $02;
    '3': Result := $03;
    '4': Result := $04;
    '5': Result := $05;
    '6': Result := $06;
    '7': Result := $07;
    '8': Result := $08;
    '9': Result := $09;
    'a': Result := $0A;
    'b': Result := $0B;
    'c': Result := $0C;
    'd': Result := $0D;
    'e': Result := $0E;
    'f': Result := $0F;
  end;
end;

{$HINTS OFF}
function hexToByte(y: string): byte;
var
  a, b: char;
  lout: byte;
begin
  a := PChar(y)[0];
  b := PChar(y)[1];
  lout := $00;
  lout := hexToBit(a);
  lout := lout shl 4;
  lout := lout xor hexToBit(b);
  Result := lout;
end;
{$HINTS ON}

//------------------------------------------------------------
//------------------------------------------------------------

procedure TAES.string_to_key(keyString : string);
var
  i: integer;
begin
  for i := 0 to 15 do
  begin
    key[i] := hexToByte(copy(keyString, 1, 2));
    keyString := copy(keyString, 3, length(keyString));
  end;
end;


procedure TAES.fillState(var buff: array of byte);
begin
  state[0, 0] := buff[byte_counter];
  inc(byte_counter);
  state[0, 1] := buff[byte_counter];
  inc(byte_counter);
  state[0, 2] := buff[byte_counter];
  inc(byte_counter);
  state[0, 3] := buff[byte_counter];
  inc(byte_counter);
  state[1, 0] := buff[byte_counter];
  inc(byte_counter);
  state[1, 1] := buff[byte_counter];
  inc(byte_counter);
  state[1, 2] := buff[byte_counter];
  inc(byte_counter);
  state[1, 3] := buff[byte_counter];
  inc(byte_counter);
  state[2, 0] := buff[byte_counter];
  inc(byte_counter);
  state[2, 1] := buff[byte_counter];
  inc(byte_counter);
  state[2, 2] := buff[byte_counter];
  inc(byte_counter);
  state[2, 3] := buff[byte_counter];
  inc(byte_counter);
  state[3, 0] := buff[byte_counter];
  inc(byte_counter);
  state[3, 1] := buff[byte_counter];
  inc(byte_counter);
  state[3, 2] := buff[byte_counter];
  inc(byte_counter);
  state[3, 3] := buff[byte_counter];
  inc(byte_counter);
end;

procedure TAES.printstate(sout : string);
CONST Nb = 4;
var i, j: integer;
    s : string;
begin
{$ifdef win32}
  if MemoOut <> nil then
  begin
    MemoOut.Lines.Add(sout);
    MemoOut.Lines.Add('---------------------------');
    MemoOut.Lines.Add('State:');
    s := '';
    
    for j := 0 to 3 do
    begin
      for i := 0 to 3 do
        s := s + IntToHex(state[i, j], 2) + ' ';
      MemoOut.Lines.Add(s);
      s := '';
    end;
    MemoOut.Lines.Add('---------------------------');
  end;
{$else}
  writeln(sout);
  writeln('---------------------------');
  writeln('State:');
  s := '';

  for j := 0 to 3 do
  begin
    for i := 0 to 3 do
      s := s + HexToString(state[i, j]) + ' ';
    writeln(s);
    s := '';
  end;
  writeln('---------------------------');
{$endif}
end;


//------------------------------------------------------------
// RotWord
procedure TAES.RotWord;
var a, c : Byte;
begin
		a := tmpkey[0];
		for c := 0 to 3 do
      tmpkey[c] := tmpkey[c + 1];
		tmpkey[3] := a;
end;


//------------------------------------------------------------
// Calculate rcon for key expansion
function TAES.rcon (a : Byte) : Byte;
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


//------------------------------------------------------------
// key_exp_base
procedure TAES.key_exp_base(i : Byte);
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
				tmpkey[a] := sbox[ tmpkey[a] ];
        
		//                     XOR  2 ^ i
    tmpkey[0] := tmpkey[0] XOR rcon(i);
end;



//------------------------------------------------------------
{ 128 bits = 16 bytes (16x8)  }
procedure TAES.KeyExpansion128;
var c, i, a : Byte;
begin
  {c = 16 - 16 bytes are user defined}
  c := 16;
	i := 1;

  // (10+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  //        4*(10+1) * 4 bajta u rijeci
  while(c < 176) do
  begin
      // Last 4 bytes -> temp var.
      for  a := 0 to 3 do
              tmpkey[a] := key[a + c - 4];

     // Every four blocks (of four bytes),
     // do a little extra work
      if ((c mod 16) = 0) then
      begin
       key_exp_base(i); // work with tmpkey
       inc(i);
      end;

      for a := 0 to 3 do
      begin
         // new key
         key[c] := key[c - 16] XOR tmpkey[a];
         inc(c);
      end;
  end;

end;


//------------------------------------------------------------
{ 192 bits = 24 bytes, (24x8)  }
procedure TAES.KeyExpansion192;
var c, i, a : Byte;
begin
  {c = 24 - 24 bytes are user defined}
  c := 24;
	i := 1;

  // (12+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  while(c < 208) do
  begin
      // Last 4 bytes in temp var.
      for  a := 0 to 3 do
              tmpkey[a] := key[a + c - 4];

     // Every 6 blocks (of four bytes),
     // do a little extra work
      if ((c mod 24) = 0) then
      begin
       key_exp_base(i); // work with tmpkey
       inc(i);
      end;

      for a := 0 to 3 do
      begin
         key[c] := key[c - 24] XOR tmpkey[a];
         inc(c);
      end;
  end;

end;


//------------------------------------------------------------
{ 256 bits = 32 bytes (32x8)   }
procedure TAES.KeyExpansion256;
var c, i, a : Byte;
begin
  //c = 32 - 32 bytes are user defined
  c := 32;
	i := 1;

  // (14+1) x 16 bytes
  //    c < Nb*(Nr+1)     Nb-no.of columns = 4, Nr-no.of rounds, 10, 12 or 14
  //        4*(10+1) * 4 bytes in word
  while(c < 239) do
  begin
      // Last 4 bytes in temp var.
      for  a := 0 to 3 do
              tmpkey[a] := key[a + c - 4];

     // Every 8 blocks (of four bytes),
     // do a little extra work
      if ((c mod 32) = 0) then
      begin
       key_exp_base(i);  // work with tmpkey
       inc(i);
      end;

      // 256 bit key - Extra S-Box
      if ((c mod 32) = 16) then
      begin
        for a := 0 to 3 do
            tmpkey[a] := sbox[ tmpkey[a] ];
      end;

      for a := 0 to 3 do
      begin
         key[c] := key[c - 32] XOR tmpkey[a];
         inc(c);
      end;
  end;

end;



//------------------------------------------------------------
procedure TAES.AddRoundKey(key_index : byte);
var i, j : Byte;
begin
  for j := 0 to 3 do
    for i := 0 to 3 do
      state[i, j] := state[i, j] xor key[key_index + 4*i + j];
  // We already know what is Galois addition, so we will use XOR
end;

//------------------------------------------------------------
// Tabelar multiplication
function TAES.galoa_mul_tab(a : Byte; b : Byte) : Byte;
var s, z : integer;
begin
  z := 0;
  //For AES multiplication, we will use well known formula:
  // log(x*y) = log(x) + log(y), e.g.
  // x*y = antilog( log(x) + log(y)

  s := ltable[a] + ltable[b];
  s := s mod 255;
  s := exptable[s];
  if a = 0 then
    s := z;

  if b = 0 then
    s := z;

	result := s;
end;

//------------------------------------------------------------
// MixColumns
procedure TAES.MixColumns;
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


//------------------------------------------------------------
// InvMixColumns
procedure TAES.InvMixColumns;
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



//------------------------------------------------------------
// ShiftRows
procedure TAES.ShiftRows;
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

//------------------------------------------------------------
procedure TAES.InvShiftRows;
var temp1, temp2 : byte;
begin

  temp1 := state[0, 1];
  temp2 := state[2, 1];

  state[0, 1] := state[3, 1];
  state[2, 1] := state[1, 1];
  state[1, 1] := temp1;
  state[3, 1] := temp2;

  temp1 := state[3, 2];
  temp2 := state[0, 2];
  state[0, 2] := state[2, 2];
  state[3, 2] := state[1, 2];
  state[1, 2] := temp1;
  state[2, 2] := temp2;

  temp1 := state[0, 3];
  state[0, 3] := state[1, 3];
  state[1, 3] := state[2, 3];
  state[2, 3] := state[3, 3];
  state[3, 3] := temp1;
end;



//------------------------------------------------------------
procedure TAES.Cipher(key_len : Integer);
var i, j : integer;
    round1, round2 : integer;
    Nb : Byte;  // No.of Columns - always 4
    Nr : Byte;  // No.of rounds (+ 1 initial round)
begin
    //Nk - In FIPS-197, this is Number of 32-bit Words in inital key
    //Nk := 4; (128)
    //Nk := 6; (192)
    //Nk := 8; (256)
    // Key length TEST
    case key_len of
      128 : begin
              Nb := 4;     // No.of Columns - always 4
              Nr := 10;    // No.of rounds (+ 1 initial round)
            end;
      192 : begin
              Nb := 4;
              Nr := 12;
            end;
      256 : begin
              Nb := 4;
              Nr := 14;
            end;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;


    // copy input to state
    for i := 0 to Nb-1 do
      for j := 0 to Nb-1 do
        state[i, j] := input[i, j];


    Round2 := 0;

    //---------Initial round -------
    AddRoundKey(0);

    for round1 := 1 to Nr-1 do
    begin
      // SubBytes
      for i := 0 to 3 do
        for j := 0 to 3 do
          state[i, j] := sbox[ state[i, j] ];

      ShiftRows;
      MixColumns;
      AddRoundKey( 4*round1*Nb );  // Nb - No.of columns = 4

      // to avoid hints
      round2 := round1;

    end;


    // ---- Final round -------
    // SubBytes
    for i := 0 to 3 do
      for j := 0 to 3 do
       state[i, j] := sbox[ state[i, j] ];

    ShiftRows;

    inc(round2);
    AddRoundKey( 4*round2*Nb  );


    for i := 0 to 3 do
      for j := 0 to 3 do
        output[i, j] := state[i, j];

    Inc(byte_counter, 16);
    {$ifdef win32}
    ProgressBar.Position := byte_counter;
    {$endif}
end;

//------------------------------------------------------------
//*******************************************************************************
// This is VERY SLOW Cipher - use Cipher/InvCipher for real encryption/decryption
// only for TESTING
// gives subresults on MEMO
// for win32 only
procedure TAES.Cipher_watch(key_len : Integer);
var i, j : integer;
    round1, round2 : integer;
    Nb : Byte;
    //Nk : Byte;
    Nr : Byte;
begin
    // Key length TEST
    case key_len of
      128 : begin
              Nb := 4;  //No.of Columns
              //Nk := 4;  //Words in inital key
              Nr := 10; //No.of rounds (+ 1 initial round)
            end;
      192 : begin
              Nb := 4;
              //Nk := 6;
              Nr := 12;
            end;
      256 : begin
              Nb := 4;
              //Nk := 8;
              Nr := 14;
            end;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;



    for i := 0 to Nb-1 do
      for j := 0 to Nb-1 do
        state[i, j] := input[i, j];


    round1 := 0;
    round2 := 0;

    printstate('Input');
    //*************************************
    //Initial round
    AddRoundKey(0);

    printstate('After initial AddRoundKey: ' + IntToStr(round1));

    for round1 := 1 to Nr-1 do
    begin
        printstate('---------- Start round: ' + IntToStr(round1));

      // SubBytes
      for i := 0 to 3 do
        for j := 0 to 3 do
          state[i, j] := sbox[ state[i, j] ];
      printstate('---------- After SubBytes rond: ' + IntToStr(round1));

      ShiftRows;
      printstate('---------- After ShiftRows rond: ' + IntToStr(round1));


      MixColumns;
      printstate('---------- After MixColumns rond: ' + IntToStr(round1));

      //*************************************
      AddRoundKey( 4*round1*Nb );
      printstate('---------- After AddRoundKey rond: ' + IntToStr(round1));

      round2 := round1;
    end;


     //-----Final round-----------------------------
    // SubBytes
    for i := 0 to 3 do
      for j := 0 to 3 do
       state[i, j] := sbox[ state[i, j] ];
    printstate('---------- Final round SubBytes: ');

    ShiftRows;
    printstate('---------- Final round ShiftRows: ');

    inc(round2);
    AddRoundKey( 4*round2*Nb  );
    printstate('---------- Final round AddRoundKey: ');


    for i := 0 to 3 do
      for j := 0 to 3 do
        output[i, j] := state[i, j];

    Inc(byte_counter, 16);
end;



//**********************************************
// InvCipher()
// key_len indicate algorithm
// works with global var. State
// and byte_counter - for files
// State is already initialized with initialise()
procedure TAES.InvCipher(key_len : Integer);
var i, j : integer;
    round : integer;
    Nb : Byte; // No.of Columns - always 4
    Nr : Byte; // No.of rounds (+ 1 initial round)
begin
    //Nk - In FIPS-197, this is Number of 32-bit Words in inital key
    //Nk := 4; (128)
    //Nk := 6; (192)
    //Nk := 8; (256)
    // Key length TEST

case key_len of
  128 : begin
          Nb := 4;    //number of columns 
          //Nk := 4;  //no.of words in key
          Nr := 10;   //number of rounds
        end;
  192 : begin
          Nb := 4;
          //Nk := 6;
          Nr := 12;
        end;
  256 : begin
          Nb := 4;
          //Nk := 8;
          Nr := 14;
        end;
  else  begin
          {$ifdef win32}
          ShowMessage('Key size = 128, 192 or 256!!');
          {$else}
          Writeln('Key size = 128, 192 or 256!');
          {$endif}
          exit;
        end;
end;


for i := 0 to Nb-1 do
  for j := 0 to Nb-1 do
    state[i, j] := input[i, j];


//***********************
// Initial round
AddRoundKey( 4*Nr*Nb );
//*************************


//*************************
// rounds 10, 12 or 14 downto 1
for round := Nr-1 downto 1 do
begin
  InvShiftRows;
  //------------
  // InvSubBytes
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := InvSBox[ state[i, j] ];
  //------------

  //-------------------------------------------------------------------------------------
  // InvMixColumns(State xor RoundKey) = InvMixColumns(state) xor InvMixColumns(RoundKey)
  AddRoundKey( 4*round*Nb );
  InvMixColumns;
end;
//*************************



//*************************
// Final round
  InvShiftRows;
  //------------
  // InvSubBytes
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := InvSBox[ state[i, j] ];
  //------------
  AddRoundKey( 0 );
//*************************



//*************************
// Output
for i := 0 to 3 do
  for j := 0 to 3 do
    output[i, j] := state[i, j];
//*************************

// for files
Inc(byte_counter, 16);
{$ifdef win32}
ProgressBar.Position := byte_counter;
{$endif}

end;




//*******************************************************************************
// This is VERY SLOW InvCipher - use Cipher/InvCipher for real encryption/decryption
// only for TESTING
// gives subresults on MEMO
// for win32 only
procedure TAES.InvCipher_watch(key_len : Integer);
var i, j : integer;
    runda : integer;
    Nb : Byte;
    //Nk : Byte;
    Nr : Byte;
begin
case key_len of
  128 : begin
          Nb := 4;  //no.columns
          //Nk := 4;  //words in key
          Nr := 10; //rounds
        end;
  192 : begin
          Nb := 4;
          //Nk := 6;
          Nr := 12;
        end;
  256 : begin
          Nb := 4;
          //Nk := 8;
          Nr := 14;
        end;
  else  begin
          {$ifdef win32}
          ShowMessage('Key size = 128, 192 or 256!!');
          {$else}
          Writeln('Key size = 128, 192 or 256!');
          {$endif}
          exit;
        end;
end;


for i := 0 to Nb-1 do
  for j := 0 to Nb-1 do
    state[i, j] := input[i, j];

Runda := 0;

printstate('Ulaz');
//*************************************
//       last Cipher round - backwards
AddRoundKey( 4*Nr*Nb );

printstate('---------- After initial AddRoundKey: ' + IntToStr(runda));



for runda := Nr-1 downto 1 do
begin
  printstate('---------- Start of round: ' + IntToStr(runda));


  InvShiftRows;
  printstate('---------- After InvShiftRows round: ' + IntToStr(runda));


  // InvSubBytes
  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i, j] := InvSBox[ state[i, j] ];
  printstate('---------- After InvSubBytes round: ' + IntToStr(runda));


  //*************************************
  AddRoundKey( 4*runda*Nb );
  printstate('---------- After AddRoundKey round: ' + IntToStr(runda));

  InvMixColumns;
  printstate('---------- After InvMixColumns round: ' + IntToStr(runda));


end;



InvShiftRows;
printstate('---------- Final round InvShiftRows: ');


// SubBytes
for i := 0 to 3 do
  for j := 0 to 3 do
    state[i, j] := InvSBox[ state[i, j] ];
printstate('---------- Final round SubBytes: ');


AddRoundKey( 0 );
printstate('---------- Final round AddRoundKey: ');


// output
for i := 0 to 3 do
  for j := 0 to 3 do
    output[i, j] := state[i, j];

Inc(byte_counter, 16);
end;



procedure TAES.set_input(inp : array of byte);
var i, j : integer;
begin
  FillChar(input, 16, 0);

  for i := 0 to 3 do
    for j := 0 to 3 do
      input[i, j] := inp[4*i + j];

end;

procedure TAES.inicijalizuj_watch(OutDevice : TMemo; in_key : array of byte; key_len : Integer);
var i, j: integer;
begin
  byte_counter := 0;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i][j] := $00;

  for i := 0 to 3 do
    for j := 0 to 3 do
      input[i, j] := $00;

  for i := 0 to 3 do
    for j := 0 to 3 do
      output[i, j] := $00;

  for i := 0 to 239 do
      key[i] := $00;

  if key_len = 128 then
  begin
    for i := 0 to 15 do
      key[i] := in_key[i];
    KeyExpansion128;
  end
  else
  if key_len = 192 then
  begin
    for i := 0 to 23 do
      key[i] := in_key[i];
    KeyExpansion192;
  end
  else
  if key_len = 256 then
  begin
    for i := 0 to 31 do
      key[i] := in_key[i];
    KeyExpansion256;
  end
  else
  {$ifdef win32}
  ShowMessage('Wrong key size!');
  {$else}
  Writeln('Wrong key size!');
  {$endif}

  MemoOut := OutDevice

end;

//****************************************************************************
// Set State, Input, Output and Key buffers to $00, and perform Key Expansion
// key_len - 128, 192 or 256 - indicate algorithm
procedure TAES.initialise(in_key : array of byte; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});
var i, j: integer;
begin
  byte_counter := 0;

  for i := 0 to 3 do
    for j := 0 to 3 do
      state[i][j] := $00;

  for i := 0 to 3 do
    for j := 0 to 3 do
      input[i, j] := $00;

  for i := 0 to 3 do
    for j := 0 to 3 do
      output[i, j] := $00;

  for i := 0 to 239 do
      key[i] := $00;

  if key_len = 128 then
  begin
    for i := 0 to 15 do
      key[i] := in_key[i];
    KeyExpansion128;
  end
  else
  if key_len = 192 then
  begin
    for i := 0 to 23 do
      key[i] := in_key[i];
    KeyExpansion192;
  end
  else
  if key_len = 256 then
  begin
    for i := 0 to 31 do
      key[i] := in_key[i];
    KeyExpansion256;
  end
  else
  {$ifdef win32}
  ShowMessage('Wrong key size!');
  ProgressBar := Progress;
  Progressbar.Position := 0;
  {$else}
  Writeln('Wrong key size!');
  {$endif}



end;


//************************************************************************
// real cipher
// Arguments:
// in_file_name, out_file_name - file names (string)
// InKey as string of hex values. For example: '2b7e151628aed2a6abf7158809cf4f3c'
// key_len - 128, 192 or 256 - indicate algorithm
procedure TAES.cipher_file(in_file_name : string; out_file_name : string;
                              inkey : string; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});
var in_file, out_file : file;
    skljuc : array [0..31] of Byte;
    TempFileMode: Byte;
    init_key_len : integer;
    inp  : array [0..15] of Byte;
    input_len, i : integer;
    padding : byte;
    pad16 : boolean;
begin

    case key_len of
      128 : init_key_len := 16;
      192 :init_key_len := 24;
      256 : init_key_len := 32;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;

    // if initial key length < 16, 24 or 32
    // (depending on key length), rest will be zeroes
    FillChar(skljuc, 31, 0);
    for i := 0 to init_key_len do
    begin
          if 2*i+1 > Length(inkey) then break;
          skljuc[i] := StrToInt('$' + inkey[2*i+1] + inkey[2*i+2]);
    end;



    initialise(skljuc, key_len, Progress);


    //----- Input --------------------
    System.Assign(in_file, in_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(in_file, 1);
    FileMode := TempFileMode;

    //----- Output -------------------
    System.Assign(out_file, out_file_name);
    rewrite(out_file);
    reset(out_file, 1);

    input_len := FileSize(in_file);
    file_size := input_len;

    {$ifdef win32}
    ProgressBar.Max := file_size;
    {$endif}

    pad16 := false;
    while ( byte_counter < input_len ) do
    begin
      FillChar(inp, 16, 0);

      if ( input_len - byte_counter ) > 16 then
        BlockRead(in_file, inp, 16)
      else
      if ( input_len - byte_counter ) = 16 then
      begin
        BlockRead(in_file, inp, 16);
        pad16 := true;
      end
      else
      begin
        //---------------------------------------------------
        // padding by Schneier and Freguson
        // pad the last block with n bytes all with value n.
        padding := 16 - ( input_len - byte_counter );
        FillChar(inp, 16, padding);
        // first fill all bytes of inp with padding
        //---------------------------------------------------

        // on first places of inp buffer, actual data
        BlockRead(in_file, inp,  ( input_len - byte_counter ) );
      end;

      set_input(inp);
      Cipher(key_len);
      BlockWrite(out_file, state, 16);
      if pad16 then
      begin
        FillChar(inp, 16, 16);
        set_input(inp);
        Cipher(key_len);
        BlockWrite(out_file, state, 16);
      end;
    end;
    closefile(in_file);
    closefile(out_file);

end;

//************************************************************************
// real invcipher,
// Arguments:
// in_file_name, out_file_name - file names (string)
// InKey as string of hex values. For example: '2b7e151628aed2a6abf7158809cf4f3c'
// key_len - 128, 192 or 256 - indicate algorithm
procedure TAES.inv_cipher_file(in_file_name : string; out_file_name : string;
                              inkey : string; key_len : Integer{$ifdef win32}; Progress : TProgressBar{$endif});
var in_file, out_file : file;
    skljuc : array [0..31] of Byte;
    TempFileMode: Byte;
    init_key_len : integer;
    inp  : array [0..15] of Byte;
    input_len : integer;
    padding, bytes_of_padding : byte;
    i, j : integer;
    is_padding : boolean;
    pad16 : boolean;
begin

    case key_len of
      128 : init_key_len := 16;
      192 : init_key_len := 24;
      256 : init_key_len := 32;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;

    // if initial key length < 16, 24 or 32
    // (depending on key length), rest will be zeroes
    FillChar(skljuc, 31, 0);
    for i := 0 to init_key_len do
    begin
          if 2*i+1 > Length(inkey) then break;
          skljuc[i] := StrToInt('$' + inkey[2*i+1] + inkey[2*i+2]);
    end;


    initialise(skljuc, key_len, progress);

    //----- Input --------------------
    System.Assign(in_file, in_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(in_file, 1);
    FileMode := TempFileMode;

    //----- Output -------------------
    System.Assign(out_file, out_file_name);
    rewrite(out_file);
    reset(out_file, 1);

    is_padding := false;
    padding := 0;

    input_len := FileSize(in_file);
    while ( byte_counter < input_len ) do
    begin
      FillChar(inp, 16, 0);

      if ( input_len - byte_counter ) >= 16 then
        BlockRead(in_file, inp, 16)
      else
        // this should newer be executed, but...
        BlockRead(in_file, inp,  ( input_len - byte_counter ));

      set_input(inp);
      InvCipher(key_len);


      pad16 := false;
      if (input_len = byte_counter) then
      begin
          // at the end is n bytes with padding n
          // so we will remove them
          is_padding := true;
          padding := state[3, 3];
          bytes_of_padding := padding;
          if padding = 16 then
             pad16 := true
          else
          begin
            for i := 3 downto 0 do
            begin
              for j := 3 downto 0 do
              begin
               if state[i, j] <> padding then
               begin
                  // end - this is padding
                  if bytes_of_padding = 0 then
                     break;

                  // this is not padding, so break the loop
                  is_padding := false;
                  break;
               end
               else
                  dec(bytes_of_padding);
              end;
               if is_padding = false then
                  break;
               if bytes_of_padding = 0 then
                  break;
            end;
            // remove padding
            if is_padding then
            for i := 3 downto 0 do
              for j := 3 downto 0 do
               if state[i, j] = padding then
                  state[i, j] := 0;
          end;
      end;

      if pad16 = false then
      begin
        if is_padding then
          BlockWrite(out_file, state, 16-padding)
        else
          BlockWrite(out_file, state, 16);
      end;
    end;
    closefile(in_file);
    closefile(out_file);

end;




// Ovoj proceduri dajemo kao argumente imena datoteka,
// te podatak o kom se algoritmu radi (duzina_kljuca)
// i izlazni uredjaj (ako hocemo da prikazuje medjurezultate)
procedure TAES.SifrujDatoteku(in_file_name : string; out_file_name : string;
                              key_file_name : string; duzina_kljuca : Integer;
                              OutDevice : TMemo);
var key_file, in_file, out_file : file;
    skljuc : array [0..31] of Byte;
    TempFileMode: Byte;
    inicijalna_duzina_kljuca : integer;
    ulaz  : array [0..15] of Byte;
    duzina_ulaza : integer;
    dopuna : byte;
begin

    case duzina_kljuca of
      128 : inicijalna_duzina_kljuca := 16;
      192 :inicijalna_duzina_kljuca := 24;
      256 : inicijalna_duzina_kljuca := 32;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;

    // ako je inicijalni kljuc u datoteci kraci od 16, 24 ili 32
    // (zavisno od duzine kljuca), ostatak (npr. do 16 bajta) ce biti nule
    FillChar(skljuc, 31, 0);

    //----- Kljuc --------------------
    System.Assign(key_file, key_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(key_file, 1);
    FileMode := TempFileMode;
    BlockRead(key_file, skljuc, inicijalna_duzina_kljuca);
    closefile(key_file);

    inicijalizuj_watch(OutDevice, skljuc, duzina_kljuca);
    printstate('--------test--------');

    //----- Ulaz --------------------
    System.Assign(in_file, in_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(in_file, 1);
    FileMode := TempFileMode;

    //----- Izlaz -------------------
    System.Assign(out_file, out_file_name);
    rewrite(out_file);
    reset(out_file, 1);

    duzina_ulaza := FileSize(in_file);
    while ( byte_counter < duzina_ulaza ) do
    begin
      FillChar(Ulaz, 16, 0);

      if ( duzina_ulaza - byte_counter ) >= 16 then
        BlockRead(in_file, ulaz, 16)
      else
      begin
        //---------------------------------------------------
        // Dopuna po Schneieru i Fregusonu (padding)
        // n bajtova popunjenih sa dopunom n
        dopuna := 16 - ( duzina_ulaza - byte_counter );
        FillChar(ulaz, 16, dopuna);
        // najprije popunimo sve bajtove ulaza sa dopunom
        //---------------------------------------------------


        // pa zatim na prva mjesta niza ucitamo stvarne bajtove iz datoteke
        BlockRead(in_file, ulaz,  ( duzina_ulaza - byte_counter ) );
      end;

      set_input(ulaz);
      Cipher(duzina_kljuca);
      BlockWrite(out_file, state, 16);
    end;
    closefile(in_file);
    closefile(out_file);

end;


// Ovoj proceduri dajemo kao argumente imena datoteka,
// te podatak o kom se algoritmu radi (duzina_kljuca)
// i izlazni uredjaj (ako hocemo da prikazuje medjurezultate)
procedure TAES.DeSifrujDatoteku(in_file_name : string; out_file_name : string;
                                key_file_name : string; duzina_kljuca : Integer;
                                OutDevice : TMemo);
var key_file, in_file, out_file : file;
    skljuc : array [0..31] of Byte;
    TempFileMode: Byte;
    inicijalna_duzina_kljuca : integer;
    ulaz  : array [0..15] of Byte;
    duzina_ulaza : integer;
    dopuna, bajtova_dopune : byte;
    i, j : integer;
    jeste_dopuna : boolean;
begin

    case duzina_kljuca of
      128 : inicijalna_duzina_kljuca := 16;
      192 : inicijalna_duzina_kljuca := 24;
      256 : inicijalna_duzina_kljuca := 32;
      else  begin
              {$ifdef win32}
              ShowMessage('Key size = 128, 192 or 256!!');
              {$else}
              Writeln('Key size = 128, 192 or 256!');
              {$endif}
              exit;
            end;
    end;

    // ako je inicijalni kljuc u datoteci kraci od 16, 24 ili 32
    // (zavisno od duzine kljuca), ostatak (npr. do 16 bajta) ce biti nule
    FillChar(skljuc, 31, 0);

    //----- Kljuc --------------------
    System.Assign(key_file, key_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(key_file, 1);
    FileMode := TempFileMode;
    BlockRead(key_file, skljuc, inicijalna_duzina_kljuca);
    closefile(key_file);

    inicijalizuj_watch(OutDevice, skljuc, duzina_kljuca);
    printstate('--------test--------');

    //----- Ulaz --------------------
    System.Assign(in_file, in_file_name);
    TempFileMode := FileMode;
    FileMode := $0000; // openread mode
    reset(in_file, 1);
    FileMode := TempFileMode;

    //----- Izlaz -------------------
    System.Assign(out_file, out_file_name);
    rewrite(out_file);
    reset(out_file, 1);

    jeste_dopuna := false;
    dopuna := 0;

    duzina_ulaza := FileSize(in_file);
    while ( byte_counter < duzina_ulaza ) do
    begin
      FillChar(Ulaz, 16, 0);

      if ( duzina_ulaza - byte_counter ) >= 16 then
        BlockRead(in_file, ulaz, 16)
      else
        // ovdje nikad ne bi trebao uci, ali ipak
        BlockRead(in_file, ulaz,  ( duzina_ulaza - byte_counter ));

      set_input(ulaz);
      InvCipher(duzina_kljuca);



      if duzina_ulaza = byte_counter then
      begin
          // na kraju se nalazi n bajtova popunjenih sa dopunom n
          // koje treba da uklonimo
          jeste_dopuna := true;
          dopuna := state[3, 3];
          bajtova_dopune := dopuna;
          for i := 3 downto 0 do
            for j := 3 downto 0 do
             if state[i, j] <> dopuna then
             begin
                // kraj - ovo jeste dopuna
                if bajtova_dopune = 0 then
                   break;

                // nije u pitanju dopuna, pa prekidamo
                jeste_dopuna := false;
                break;
             end
             else
                dec(bajtova_dopune);

          // uklanjamo dopunu      
          if jeste_dopuna then
          for i := 3 downto 0 do
            for j := 3 downto 0 do
             if state[i, j] = dopuna then
                state[i, j] := 0;
      end;

      if jeste_dopuna then
        BlockWrite(out_file, state, 16-dopuna)
      else
        BlockWrite(out_file, state, 16);
    end;
    closefile(in_file);
    closefile(out_file);

end;
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------

end.
