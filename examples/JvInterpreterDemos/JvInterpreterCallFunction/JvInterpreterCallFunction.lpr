program JvInterpreterCallFunction;

uses
  Interfaces, Forms,
  JvInterpreterCallFunctionFm in 'JvInterpreterCallFunctionFm.pas' {Form1};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
