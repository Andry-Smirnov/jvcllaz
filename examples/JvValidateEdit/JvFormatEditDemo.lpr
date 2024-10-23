program JvFormatEditDemo;

uses
  Forms, Interfaces,
  MainFrm in 'MainFrm.pas' {frmValidateEditDemo};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmValidateEditDemo, frmValidateEditDemo);
  Application.Run;
end.

