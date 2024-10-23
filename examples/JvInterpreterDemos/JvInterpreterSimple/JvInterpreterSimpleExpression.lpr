program JvInterpreterSimpleExpression;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms,
  JvInterpreterSimpleExpressionFm in 'JvInterpreterSimpleExpressionFm.pas' {Form1};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
