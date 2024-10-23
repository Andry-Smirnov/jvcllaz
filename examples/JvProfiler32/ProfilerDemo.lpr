program ProfilerDemo;

uses
  Interfaces,
  Forms,
  Profiler32MainFormU in 'Profiler32MainFormU.pas' {Profiler32MainForm};

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TProfiler32MainForm, Profiler32MainForm);
  Application.Run;
end.
