program JvItemViewerDemo;

{$MODE Delphi}

uses
  Forms, Interfaces,
  MainFrm in 'MainFrm.pas' {frmMain},
  ViewerFrm in 'ViewerFrm.pas' {frmImageViewer};

{$R *.res}

begin
  Application.Scaled := true;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
