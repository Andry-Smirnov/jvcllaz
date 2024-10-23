unit JvPascalInterpreterReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Register;

implementation

{$IFDEF CPU64}
procedure Register;
begin
end;
{$ELSE}

{$R ..\..\resource\jvpascalinterpreterreg.res}

uses
  JvDsgnConsts, JvInterpreter;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclNonVisual, [TJvInterpreterProgram]);
end;
{$ENDIF}

end.

