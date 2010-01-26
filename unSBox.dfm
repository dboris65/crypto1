object frSBox: TfrSBox
  Left = 178
  Top = 133
  Width = 846
  Height = 426
  Caption = 'S Box'
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
    Left = 429
    Top = 0
    Height = 392
    Align = alRight
  end
  object Panel1: TPanel
    Left = 432
    Top = 0
    Width = 406
    Height = 392
    Align = alRight
    TabOrder = 0
    object pnTopRight: TPanel
      Left = 1
      Top = 1
      Width = 404
      Height = 136
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 176
        Top = 106
        Width = 9
        Height = 13
        Caption = 'a:'
      end
      object Label8: TLabel
        Left = 160
        Top = 16
        Width = 30
        Height = 13
        Caption = 'Value:'
      end
      object Label9: TLabel
        Left = 160
        Top = 48
        Width = 30
        Height = 13
        Caption = 'Value:'
      end
      object A: TEdit
        Left = 200
        Top = 104
        Width = 49
        Height = 21
        TabOrder = 0
        Text = '83'
      end
      object btGMulInv: TButton
        Left = 8
        Top = 104
        Width = 145
        Height = 25
        Caption = 'Multiplicative inverse of a:'
        TabOrder = 1
        OnClick = btGMulInvClick
      end
      object btCalcSBoxTable: TButton
        Left = 8
        Top = 72
        Width = 145
        Height = 25
        Caption = 'Calculate SBox table'
        TabOrder = 2
        OnClick = btCalcSBoxTableClick
      end
      object btCalcOneSBoxValue: TButton
        Left = 8
        Top = 40
        Width = 145
        Height = 25
        Caption = 'Calc.one SBox value-fast'
        TabOrder = 3
        OnClick = btCalcOneSBoxValueClick
      end
      object OneVal: TEdit
        Left = 200
        Top = 43
        Width = 49
        Height = 21
        TabOrder = 4
        Text = '83'
      end
      object btCalc_One_SBox_Val_By_Matrix: TButton
        Left = 8
        Top = 8
        Width = 145
        Height = 25
        Caption = 'Calc.one SBox val.-by Matrix'
        TabOrder = 5
        OnClick = btCalc_One_SBox_Val_By_MatrixClick
      end
      object OneValM: TEdit
        Left = 200
        Top = 11
        Width = 49
        Height = 21
        TabOrder = 6
        Text = '83'
      end
    end
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 137
      Width = 404
      Height = 254
      Align = alClient
      TabOrder = 1
      ControlData = {
        4C000000C1290000401A00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnLeft: TPanel
    Left = 0
    Top = 0
    Width = 429
    Height = 392
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 427
      Height = 159
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
    object pnLeftDn: TPanel
      Left = 1
      Top = 160
      Width = 427
      Height = 231
      Align = alBottom
      TabOrder = 1
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 79
        Height = 13
        Caption = 'Before SubBytes'
      end
      object Label3: TLabel
        Left = 104
        Top = 8
        Width = 72
        Height = 13
        Caption = 'State - Decimal'
      end
      object Label4: TLabel
        Left = 272
        Top = 8
        Width = 53
        Height = 13
        Caption = 'State - Hex'
      end
      object Label5: TLabel
        Left = 8
        Top = 120
        Width = 70
        Height = 13
        Caption = 'After SubBytes'
      end
      object Label6: TLabel
        Left = 104
        Top = 120
        Width = 38
        Height = 13
        Caption = 'Decimal'
      end
      object Label7: TLabel
        Left = 272
        Top = 120
        Width = 19
        Height = 13
        Caption = 'Hex'
      end
      object GridDec: TStringGrid
        Left = 104
        Top = 24
        Width = 153
        Height = 89
        ColCount = 4
        DefaultColWidth = 32
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
        TabOrder = 0
        OnClick = GridDecClick
        OnKeyUp = GridDecKeyUp
        OnSetEditText = GridDecSetEditText
      end
      object GridHex: TStringGrid
        Left = 272
        Top = 24
        Width = 153
        Height = 89
        ColCount = 4
        DefaultColWidth = 32
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
        TabOrder = 1
        OnClick = GridHexClick
        OnKeyUp = GridHexKeyUp
        OnSetEditText = GridHexSetEditText
      end
      object AfterGridDec: TStringGrid
        Left = 104
        Top = 134
        Width = 153
        Height = 89
        ColCount = 4
        DefaultColWidth = 32
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        TabOrder = 2
      end
      object AfterGridHex: TStringGrid
        Left = 272
        Top = 134
        Width = 153
        Height = 89
        ColCount = 4
        DefaultColWidth = 32
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        TabOrder = 3
      end
      object btSubButes: TButton
        Left = 8
        Top = 24
        Width = 75
        Height = 25
        Caption = 'SubButes'
        TabOrder = 4
        OnClick = btSubButesClick
      end
      object btClear: TButton
        Left = 8
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 5
        OnClick = btClearClick
      end
    end
  end
end
