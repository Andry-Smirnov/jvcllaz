unit JvCmpReg;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure Register;

implementation

{$R ../../resource/jvcmpreg.res}

uses
  Classes, PropEdits, ComponentEditors,
  JvDsgnConsts,
  JvStringHolder, JvSpellChecker,
  JvStrHolderEditor, JvProfilerForm;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclNonVisual, [
    TJvStrHolder, TJvMultiStringHolder,
    TJvProfiler,
    TJvSpellChecker
  ]);
  RegisterComponentEditor(TJvStrHolder, TJvStrHolderEditor);
end;

end.

