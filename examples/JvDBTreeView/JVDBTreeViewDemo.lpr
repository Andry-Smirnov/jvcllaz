program JVDBTreeViewDemo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  LCLVersion, Forms, Main, RecordEditorFrm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  {$IFDEF LCLVersion >= 1080000}
  Application.Scaled := True;
  {$ENDIF}
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

