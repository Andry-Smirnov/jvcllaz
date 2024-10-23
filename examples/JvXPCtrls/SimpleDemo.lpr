program SimpleDemo;

uses
  Forms, Interfaces,
  MainFrm in 'MainFrm.pas';

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
