unit JvStdCtrlsReg;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure Register;

implementation

{$R ../../resource/jvstdctrlsreg.res}

uses
  Classes, Controls, PropEdits,
  JvDsgnConsts, JvCheckbox, JvPanel, JvBaseEdits;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclVisual, [
    TJvCheckbox, TJvPanel, TJvCalcEdit
  ]);
end;

end.

