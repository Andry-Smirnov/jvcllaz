{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvTimeFrameworkLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvTimeFrameworkReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvTimeFrameworkReg', @JvTimeFrameworkReg.Register);
end;

initialization
  RegisterPackage('JvTimeFrameworkLazD', @Register);
end.
