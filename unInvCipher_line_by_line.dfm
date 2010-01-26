object frInvCipher_line_by_line: TfrInvCipher_line_by_line
  Left = 301
  Top = 153
  Width = 928
  Height = 480
  Caption = 'InvCipher - line by line'
  Color = clBtnFace
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 137
    Align = alTop
    Color = 16762566
    TabOrder = 0
    object lKljuc: TLabel
      Left = 200
      Top = 12
      Width = 49
      Height = 13
      Caption = 'Key (HEX)'
    end
    object lUlazniVektor: TLabel
      Left = 200
      Top = 52
      Width = 88
      Height = 13
      Caption = 'Input vector (HEX)'
    end
    object lRezultat: TLabel
      Left = 200
      Top = 92
      Width = 30
      Height = 13
      Caption = 'Result'
    end
    object rgAlgoritam: TRadioGroup
      Left = 726
      Top = 8
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
    end
    object Kljuc: TEdit
      Left = 200
      Top = 28
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 1
      Text = '2b7e151628aed2a6abf7158809cf4f3c'
    end
    object btCipher: TButton
      Left = 40
      Top = 96
      Width = 75
      Height = 25
      Caption = 'InvCipher'
      TabOrder = 2
      OnClick = btCipherClick
    end
    object rgTestVektori: TRadioGroup
      Left = 8
      Top = 8
      Width = 185
      Height = 73
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      Caption = 'Prepared Test vectors'
      ItemIndex = 0
      Items.Strings = (
        'FIPS 128-1'
        'FIPS 128-2'
        'FIPS 192'
        'FIPS 256')
      TabOrder = 3
      OnClick = rgTestVektoriClick
    end
    object UlazniVektor: TEdit
      Left = 200
      Top = 68
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 4
      Text = '3243f6a8885a308d313198a2e0370734'
    end
    object Rezultat: TEdit
      Left = 200
      Top = 108
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 5
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 137
    Width = 920
    Height = 309
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btClear: TButton
    Left = 120
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btClearClick
  end
end
