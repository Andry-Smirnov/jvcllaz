{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvJansLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvJansReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvJansReg', @JvJansReg.Register);
end;

initialization
  RegisterPackage('JvJansLazD', @Register);
end.
