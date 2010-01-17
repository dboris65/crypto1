object frRealCipher: TfrRealCipher
  Left = 218
  Top = 84
  Width = 606
  Height = 393
  Caption = 'Real cipher'
  Color = 16762566
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 88
    Width = 119
    Height = 13
    Caption = 'File to encrypt (open text)'
  end
  object Label2: TLabel
    Left = 200
    Top = 128
    Width = 93
    Height = 13
    Caption = 'Encrypted file name'
  end
  object lKljuc: TLabel
    Left = 200
    Top = 16
    Width = 49
    Height = 13
    Caption = 'Key (HEX)'
  end
  object Label3: TLabel
    Left = 200
    Top = 192
    Width = 121
    Height = 13
    Caption = 'File to decrypt (ciphertext)'
  end
  object Label4: TLabel
    Left = 200
    Top = 232
    Width = 91
    Height = 13
    Caption = 'Plain text File name'
  end
  object rgAlgoritam: TRadioGroup
    Left = 6
    Top = 12
    Width = 185
    Height = 65
    HelpContext = 20
    Caption = 'Algorithm'
    ItemIndex = 0
    Items.Strings = (
      'AES 128'
      'AES 192'
      'AES 256')
    TabOrder = 0
    OnClick = rgAlgoritamClick
  end
  object btEncryptFile: TButton
    Left = 70
    Top = 103
    Width = 121
    Height = 25
    HelpContext = 40
    Caption = 'Encrypt file (cipher)'
    TabOrder = 1
    OnClick = btEncryptFileClick
  end
  object FileToEncrypt: TEdit
    Left = 200
    Top = 104
    Width = 353
    Height = 21
    TabOrder = 2
    Text = 'FileToEncrypt'
  end
  object CipFileName: TEdit
    Left = 200
    Top = 144
    Width = 353
    Height = 21
    TabOrder = 3
    Text = 'CipFileName'
  end
  object Key: TEdit
    Left = 200
    Top = 32
    Width = 353
    Height = 21
    HelpType = htKeyword
    HelpKeyword = 'PrviNacin'
    TabOrder = 4
    Text = '2b7e151628aed2a6abf7158809cf4f3c'
  end
  object btDecryptFile: TButton
    Left = 70
    Top = 207
    Width = 121
    Height = 25
    HelpContext = 40
    Caption = 'Decrypt file (Invcipher)'
    TabOrder = 5
    OnClick = btDecryptFileClick
  end
  object FileToDecrypt: TEdit
    Left = 200
    Top = 208
    Width = 353
    Height = 21
    TabOrder = 6
    Text = 'FileToDecrypt'
  end
  object PlainFileName: TEdit
    Left = 200
    Top = 248
    Width = 353
    Height = 21
    TabOrder = 7
    Text = 'PlainFileName'
  end
  object ProgressBar1: TProgressBar
    Left = 200
    Top = 280
    Width = 353
    Height = 17
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 128
  end
  object SaveDialog1: TSaveDialog
    Left = 40
    Top = 128
  end
end
