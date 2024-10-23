{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvHMILazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvHMIReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvHMIReg', @JvHMIReg.Register);
end;

initialization
  RegisterPackage('JvHMILazD', @Register);
end.
