program BmpAnimDemo;

uses
  Interfaces,
  Forms,
  BmpAnimMainFormU in 'BmpAnimMainFormU.pas' {BmpAnimMainForm};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TBmpAnimMainForm, BmpAnimMainForm);
  Application.Run;
end.
