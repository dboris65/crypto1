object frGMul: TfrGMul
  Left = 183
  Top = 196
  Width = 742
  Height = 374
  Caption = 'Galoa Multiplication'
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
  object Splitter1: TSplitter
    Left = 461
    Top = 0
    Height = 340
    Align = alRight
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 461
    Height = 340
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 464
    Top = 0
    Width = 270
    Height = 340
    Align = alRight
    TabOrder = 1
    object pnTopRight: TPanel
      Left = 1
      Top = 1
      Width = 268
      Height = 216
      Align = alTop
      TabOrder = 0
      object Label3: TLabel
        Left = 120
        Top = 8
        Width = 50
        Height = 13
        Caption = 'Generator:'
      end
      object Label1: TLabel
        Left = 8
        Top = 90
        Width = 10
        Height = 13
        Caption = 'A:'
      end
      object Label2: TLabel
        Left = 72
        Top = 90
        Width = 17
        Height = 13
        Caption = '* B:'
      end
      object Label4: TLabel
        Left = 8
        Top = 122
        Width = 35
        Height = 13
        Caption = 'R(dec):'
      end
      object Label5: TLabel
        Left = 8
        Top = 154
        Width = 34
        Height = 13
        Caption = 'R(hex):'
      end
      object btGenExpTableHex: TButton
        Left = 8
        Top = 24
        Width = 105
        Height = 25
        Caption = 'GenExpTable (hex)'
        TabOrder = 0
        OnClick = btGenExpTableHexClick
      end
      object cbGenerators: TComboBox
        Left = 120
        Top = 24
        Width = 121
        Height = 21
        ItemHeight = 13
        TabOrder = 1
      end
      object btGMulTab: TButton
        Left = 8
        Top = 56
        Width = 137
        Height = 25
        Caption = 'GMul using tables R=A*B'
        TabOrder = 2
        OnClick = btGMulTabClick
      end
      object A: TEdit
        Left = 24
        Top = 88
        Width = 41
        Height = 21
        TabOrder = 3
        Text = '87'
      end
      object B: TEdit
        Left = 96
        Top = 88
        Width = 41
        Height = 21
        TabOrder = 4
        Text = '19'
      end
      object R: TEdit
        Left = 48
        Top = 120
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object Rhex: TEdit
        Left = 48
        Top = 152
        Width = 121
        Height = 21
        TabOrder = 6
      end
      object btGMulSlow: TButton
        Left = 152
        Top = 56
        Width = 105
        Height = 25
        Caption = 'Slow GMul R=A*B'
        TabOrder = 7
        OnClick = btGMulSlowClick
      end
    end
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 217
      Width = 268
      Height = 122
      Align = alClient
      TabOrder = 1
      ControlData = {
        4C000000B31B00009C0C00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
