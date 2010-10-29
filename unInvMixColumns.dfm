object frInvMixColumns: TfrInvMixColumns
  Left = 235
  Top = 169
  Width = 808
  Height = 410
  Caption = 'InvMixColumns'
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
    Left = 425
    Top = 0
    Height = 376
  end
  object pnLeft: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 376
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 90
      Height = 13
      Caption = 'Before MixColumns'
    end
    object Label2: TLabel
      Left = 16
      Top = 40
      Width = 72
      Height = 13
      Caption = 'State - Decimal'
    end
    object Label3: TLabel
      Left = 184
      Top = 40
      Width = 53
      Height = 13
      Caption = 'State - Hex'
    end
    object Label4: TLabel
      Left = 16
      Top = 152
      Width = 81
      Height = 13
      Caption = 'After MixColumns'
    end
    object Label5: TLabel
      Left = 16
      Top = 168
      Width = 38
      Height = 13
      Caption = 'Decimal'
    end
    object Label6: TLabel
      Left = 184
      Top = 168
      Width = 19
      Height = 13
      Caption = 'Hex'
    end
    object GridDec: TStringGrid
      Left = 16
      Top = 56
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
      Left = 184
      Top = 56
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
      Left = 16
      Top = 184
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
      Left = 184
      Top = 184
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
    object btInvMixColumns: TButton
      Left = 344
      Top = 56
      Width = 75
      Height = 25
      Caption = 'InvMixColumns'
      TabOrder = 4
      OnClick = btInvMixColumnsClick
    end
    object btClear: TButton
      Left = 344
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 5
      OnClick = btClearClick
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 428
    Top = 0
    Width = 372
    Height = 376
    Align = alClient
    TabOrder = 1
    ControlData = {
      4C00000073260000DC2600000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
