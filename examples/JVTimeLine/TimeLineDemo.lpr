program TimeLineDemo;

{$mode objfpc}{$H+}

uses
  Forms, Interfaces, LCLVersion,
  TimelineNotesFormU in 'TimelineNotesFormU.pas' {TimelineNotesForm},
  TimelineMainFormU in 'TimelineMainFormU.pas' {TimelineMainForm};

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TTimelineMainForm, TimelineMainForm);
  Application.Run;
end.
