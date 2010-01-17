object frKeyExpansion: TfrKeyExpansion
  Left = 112
  Top = 154
  Width = 928
  Height = 480
  Caption = 'KeyExpansion'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 121
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
    object rgTestVektori: TRadioGroup
      Left = 8
      Top = 8
      Width = 185
      Height = 105
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      Caption = 'Prepared Test vectors'
      ItemIndex = 0
      Items.Strings = (
        'FIPS 128-1'
        'FIPS 128-2'
        'FIPS 192-1'
        'FIPS 192-2'
        'FIPS 256-1'
        'FIPS 256-2')
      TabOrder = 1
      OnClick = rgTestVektoriClick
    end
    object Kljuc: TEdit
      Left = 198
      Top = 28
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 2
      Text = '2b7e151628aed2a6abf7158809cf4f3c'
    end
    object btExpandKey: TButton
      Left = 200
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Expand key'
      TabOrder = 3
      OnClick = btExpandKeyClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 121
    Width = 920
    Height = 325
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
end
