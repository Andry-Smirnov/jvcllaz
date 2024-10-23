unit JvTimeFrameworkReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PropEdits;

procedure Register;

implementation

{$R ../../resource/jvtimeframeworkreg.res}

uses
  //Controls,
  JvDsgnConsts,
  JvTFGlance, JvTFGlanceTextViewer, JvTFMonths, JvTFWeeks, JvTFDays,
  JvTFAlarm, JvTFManager;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclVisual, [
    TJvTFScheduleManager,
    TJvTFMonths, TJvTFWeeks, TJvTFDays, TJvTFAlarm, TJvTFGlanceTextViewer,
    TJvTFUniversalPrinter, TJvTFDaysPrinter
  ]);

  // register a nil property editor for now, so cells cannot be added,
  // deleted, or moved at design time... BAD THINGS HAPPEN
  RegisterPropertyEditor(TypeInfo(TJvTFGlanceCells), TJvTFMonths, 'Cells', nil);

  // The LCL TTime property editor is not installed by default.
  RegisterPropertyEditor(TypeInfo(TTime), TJvTFDaysPrimeTime, '', TTimePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TDate), TJvTFDaysTemplate, '', TDatePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TDate), TJvTFWeeks, 'DisplayDate', TDatePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TDate), TJvTFMonths, 'DisplayDate', TDatePropertyEditor);

  (*
//  RegisterPropertyEditor(TypeInfo(string), TJvTFControl, 'Version', TutfVersionEditor);
//  RegisterPropertyEditor(TypeInfo(string), TJvTFScheduleManager, 'Version', TutfVersionEditor);
//  RegisterPropertyEditor(TypeInfo(TJvTFGlanceCells), '', 'Cells',
//    TJvTFGlanceCellsProperty);

  RegisterPropertyEditor(TypeInfo(TJvTFGlanceCells), TJvTFMonths, 'Cells', nil);
  RegisterComponents(RsPaletteTimeFramework, [TJvTFDays, TJvTFDaysPrinter]);
*)
end;

end.

