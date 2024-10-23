program Install2LabelDemo;

{$MODE Delphi}

uses
  Forms, Interfaces,
  InstallLabelMainFormU in 'InstallLabelMainFormU.pas' {InstallLabelMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TInstallLabelMainForm, InstallLabelMainForm);
  Application.Run;
end.
