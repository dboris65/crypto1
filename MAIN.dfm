object MainForm: TMainForm
  Left = 207
  Top = 108
  Width = 479
  Height = 304
  Caption = 'AES for student education'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 212
    Width = 471
    Height = 19
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 208
    object File1: TMenuItem
      Caption = '&File'
      Hint = 'File related commands'
      object N1: TMenuItem
        Caption = '-'
      end
      object FileExitItem: TMenuItem
        Caption = 'E&xit'
        Hint = 'Exit|Exit application'
        OnClick = FileExit1Execute
      end
    end
    object Cipherelements1: TMenuItem
      Caption = 'Cipher elements'
      object GMul1: TMenuItem
        Caption = 'GMul'
        OnClick = GMul1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SBox1: TMenuItem
        Caption = 'SubBytes (S-Box)'
        OnClick = SBox1Click
      end
      object ShiftRows1: TMenuItem
        Caption = 'ShiftRows'
        OnClick = ShiftRows1Click
      end
      object MixColumns1: TMenuItem
        Caption = 'MixColumns'
        OnClick = MixColumns1Click
      end
    end
    object Cipher3: TMenuItem
      Caption = 'Cipher'
      object Keyexpansion1: TMenuItem
        Caption = 'Key expansion'
        OnClick = Keyexpansion1Click
      end
      object Cipher4: TMenuItem
        Caption = 'Cipher - block by block view'
        OnClick = Cipher4Click
      end
      object Cipherlinebylineview1: TMenuItem
        Caption = 'Cipher - line by line view'
        OnClick = Cipherlinebylineview1Click
      end
    end
    object InvCipherelements1: TMenuItem
      Caption = 'InvCipher elements'
      object InvShiftRows1: TMenuItem
        Caption = 'InvShiftRows'
        OnClick = InvShiftRows1Click
      end
      object InvMixColums1: TMenuItem
        Caption = 'InvMixColums'
        OnClick = InvMixColums1Click
      end
    end
    object InvCipher1: TMenuItem
      Caption = 'InvCipher'
      object InvCipher2: TMenuItem
        Caption = 'InvCipher - block by block view'
        OnClick = InvCipher2Click
      end
      object InvCipherlinebylineview1: TMenuItem
        Caption = 'InvCipher - line by line view'
        OnClick = InvCipherlinebylineview1Click
      end
    end
    object MonteCarlotests1: TMenuItem
      Caption = 'Monte Carlo tests'
      object MonteCarlo1: TMenuItem
        Caption = 'Monte Carlo'
        OnClick = MonteCarlo1Click
      end
      object InvMonteCarlo1: TMenuItem
        Caption = 'Inv Monte Carlo'
        OnClick = InvMonteCarlo1Click
      end
    end
    object Realcipher1: TMenuItem
      Caption = 'Real cipher'
      object RealCipher2: TMenuItem
        Caption = 'Real Cipher'
        OnClick = RealCipher2Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      Hint = 'Help topics'
      object HelpAboutItem: TMenuItem
        Caption = '&About...'
        Hint = 
          'About|Displays program information, version number, and copyrigh' +
          't'
        OnClick = HelpAbout1Execute
      end
    end
  end
end
