{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvPascalInterpreterD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvPascalInterpreterReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvPascalInterpreterReg', @JvPascalInterpreterReg.Register);
end;

initialization
  RegisterPackage('JvPascalInterpreterD', @Register);
end.
