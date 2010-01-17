object frInvMonteCarlo: TfrInvMonteCarlo
  Left = 294
  Top = 196
  Width = 928
  Height = 480
  Caption = 'InvMonteCarlo'
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
    Height = 217
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
      Top = 44
      Width = 105
      Height = 13
      Caption = 'Input vector CT (HEX)'
    end
    object lRezultat: TLabel
      Left = 200
      Top = 76
      Width = 99
      Height = 13
      Caption = 'Result Plain text (PT)'
    end
    object Label1: TLabel
      Left = 8
      Top = 168
      Width = 77
      Height = 13
      Caption = 'Predefined Keys'
    end
    object Label2: TLabel
      Left = 296
      Top = 168
      Width = 168
      Height = 13
      Caption = 'Predefined Plain Texts (PT) - results'
    end
    object Label3: TLabel
      Left = 584
      Top = 168
      Width = 136
      Height = 13
      Caption = 'Predefined Cipher Texts (CT)'
    end
    object Label4: TLabel
      Left = 584
      Top = 120
      Width = 190
      Height = 13
      Caption = 'Monte Carlo tests = 10000x decrypt CT, '
    end
    object Label5: TLabel
      Left = 584
      Top = 136
      Width = 236
      Height = 13
      Caption = 'where Result from prev.encryption is Input for next'
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
    object Kljuc: TEdit
      Left = 320
      Top = 12
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 1
      Text = '2b7e151628aed2a6abf7158809cf4f3c'
    end
    object btMonteCarloCipher: TButton
      Left = 8
      Top = 88
      Width = 145
      Height = 25
      Caption = 'Inv MonteCarlo Cipher 1 by 1'
      TabOrder = 2
      OnClick = btMonteCarloCipherClick
    end
    object UlazniVektor: TEdit
      Left = 320
      Top = 44
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 3
      Text = '3243f6a8885a308d313198a2e0370734'
    end
    object Rezultat: TEdit
      Left = 320
      Top = 76
      Width = 489
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'PrviNacin'
      TabOrder = 4
    end
    object cbKeys: TComboBox
      Left = 8
      Top = 184
      Width = 281
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 5
      Text = 'cbKeys'
      OnChange = cbKeysChange
      Items.Strings = (
        'cbKeys')
    end
    object cbPlains: TComboBox
      Left = 296
      Top = 184
      Width = 281
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 6
      Text = 'cbPlains'
      OnChange = cbPlainsChange
      Items.Strings = (
        'cbPlains')
    end
    object cbCiphers: TComboBox
      Left = 584
      Top = 184
      Width = 281
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 7
      Text = 'cbCiphers'
      OnChange = cbCiphersChange
      Items.Strings = (
        'cbCiphers')
    end
    object btMonteCarloAll: TButton
      Left = 8
      Top = 120
      Width = 145
      Height = 25
      Caption = 'Inv MonteCarlo Cipher all 399'
      TabOrder = 8
      OnClick = btMonteCarloAllClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 217
    Width = 920
    Height = 229
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
