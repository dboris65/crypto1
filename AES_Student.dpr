{******************************************************************************}
{ Boris Damjanovic                                                             }
{ Ind. master-230/08                                                           }
{ Faculty of Organizational Sciences (FON), Belgrade                            }
{ August 2009                                                                  }
{******************************************************************************}
program AES_Student;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  about in 'about.pas' {AboutBox},
  unAES in 'unAES.pas',
  unCipher in 'unCipher.pas' {frCipher},
  unCipher_line_by_line in 'unCipher_line_by_line.pas' {frCipher_line_by_line},
  unGMul in 'unGMul.pas' {frGMul},
  unInvCipher in 'unInvCipher.pas' {frInvCipher},
  unInvCipher_line_by_line in 'unInvCipher_line_by_line.pas' {frInvCipher_line_by_line},
  unInvMixColumns in 'unInvMixColumns.pas' {frInvMixColumns},
  unInvMonteCarlo in 'unInvMonteCarlo.pas' {frInvMonteCarlo},
  unInvMonteCarloVars in 'unInvMonteCarloVars.pas',
  unInvShiftRows in 'unInvShiftRows.pas' {frInvShiftRows},
  unKeyExpansion in 'unKeyExpansion.pas' {frKeyExpansion},
  unMixColumns in 'unMixColumns.pas' {frMixColumns},
  unMonteCarlo in 'unMonteCarlo.pas' {frMonteCarlo},
  unMonteCarloVars in 'unMonteCarloVars.pas',
  unRealCipher in 'unRealCipher.pas' {frRealCipher},
  unSBox in 'unSBox.pas' {frSBox},
  unShiftRows in 'unShiftRows.pas' {frShiftRows};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
