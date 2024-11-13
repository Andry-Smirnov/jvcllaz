{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvNetLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvNetReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvNetReg', @JvNetReg.Register);
end;

initialization
  RegisterPackage('JvNetLazD', @Register);
end.
