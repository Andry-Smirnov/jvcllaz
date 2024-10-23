program JvComboListBoxDemo;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms,
  JvComboListBoxDemoForm in 'JvComboListBoxDemoForm.pas' {JvComboListBoxDemoFrm},
  DropFrm in 'DropFrm.pas' {frmDrop};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJvComboListBoxDemoFrm, JvComboListBoxDemoFrm);
  Application.Run;
end.

