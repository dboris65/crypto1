unit unRealCipher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, unAES, ComCtrls;

type
  TfrRealCipher = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    rgAlgoritam: TRadioGroup;
    btEncryptFile: TButton;
    FileToEncrypt: TEdit;
    CipFileName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lKljuc: TLabel;
    Key: TEdit;
    btDecryptFile: TButton;
    Label3: TLabel;
    FileToDecrypt: TEdit;
    Label4: TLabel;
    PlainFileName: TEdit;
    ProgressBar1: TProgressBar;
    procedure rgAlgoritamClick(Sender: TObject);
    procedure btEncryptFileClick(Sender: TObject);
    procedure btDecryptFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    AES : TAES;
  end;

var
  frRealCipher: TfrRealCipher;

implementation

{$R *.dfm}

procedure TfrRealCipher.rgAlgoritamClick(Sender: TObject);
begin
// some predefined keys
if rgAlgoritam.ItemIndex = 0 then
  Key.Text := '2b7e151628aed2a6abf7158809cf4f3c'
else
if rgAlgoritam.ItemIndex = 1 then
  Key.Text := '000102030405060708090a0b0c0d0e0f1011121314151617'
else
if rgAlgoritam.ItemIndex = 2 then
  Key.Text := '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';

end;

procedure TfrRealCipher.btEncryptFileClick(Sender: TObject);
var in_file_name : string;
    out_file_name : string;
    init_key_len : integer;
begin

  case rgAlgoritam.ItemIndex of
    0 : init_key_len := 128;
    1 : init_key_len := 192;
    2 : init_key_len := 256;
    else  begin
            init_key_len := 128;
          end;
  end;

  if Length(Trim(Key.Text)) <> 2*init_key_len/8 then
  begin
    if idNo = Application.MessageBox(PChar('Key lenght <> ' + IntToStr(init_key_len) +' bytes. Key will be padded with zeroes. Do you want to continue?'),
                                      'Warning', MB_YESNO	) then
    exit;
  end;
  
  OpenDialog1.Title := 'Select input file (Plain Text)';
  if OpenDialog1.Execute then
     in_file_name := OpenDialog1.FileName
  else
     exit;

  FileToEncrypt.Text := in_file_name;
  out_file_name := ExtractFilePath(in_file_name) + 'cip_' + ExtractFileName(in_file_name);
  CipFileName.Text := out_file_name;

  AES := TAES.Create;
  AES.cipher_file(in_file_name, out_file_name, Trim(Key.Text), init_key_len, ProgressBar1);
  AES.Destroy;

end;


procedure TfrRealCipher.btDecryptFileClick(Sender: TObject);
var in_file_name : string;
    out_file_name : string;
    init_key_len : integer;
begin

  case rgAlgoritam.ItemIndex of
    0 : init_key_len := 128;
    1 : init_key_len := 192;
    2 : init_key_len := 256;
    else  begin
            init_key_len := 128;
          end;
  end;

  if Length(Trim(Key.Text)) <> 2*init_key_len/8 then
  begin
    if idNo = Application.MessageBox(PChar('Key lenght <> ' + IntToStr(init_key_len) +' bytes. Key will be padded with zeroes. Do you want to continue?'),
                                      'Warning', MB_YESNO	) then
    exit;
  end;

  OpenDialog1.Title := 'Select input file (Cipher Text)';
  if OpenDialog1.Execute then
     in_file_name := OpenDialog1.FileName
  else
     exit;

  FileToDecrypt.Text := in_file_name;
  out_file_name := ExtractFilePath(in_file_name) + 'inv_' + ExtractFileName(in_file_name);
  PlainFileName.Text := out_file_name;

  AES := TAES.Create;
  AES.inv_cipher_file(in_file_name, out_file_name, Trim(Key.Text), init_key_len, ProgressBar1);
  AES.Destroy;
end;

procedure TfrRealCipher.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.
