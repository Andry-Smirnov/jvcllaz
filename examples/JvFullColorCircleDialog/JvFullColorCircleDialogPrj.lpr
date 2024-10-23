program JvFullColorCircleDialogPrj;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms,
  JvFullColorCircleDialogMainForm in 'JvFullColorCircleDialogMainForm.pas' {JvFullColorCircleDlgMainFrm};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJvFullColorCircleDlgMainFrm, JvFullColorCircleDlgMainFrm);
  Application.Run;
end.
