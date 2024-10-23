program JvBehaviorLabelDemo;

uses
  Interfaces, Forms,
  JvBehaviorLblMainFrmU in 'JvBehaviorLblMainFrmU.pas' {JvBehaviorLblMainFrm};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJvBehaviorLblMainFrm, JvBehaviorLblMainFrm);
  Application.Run;
end.
