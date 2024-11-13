{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvAppFrmLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvAppFrmReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvAppFrmReg', @JvAppFrmReg.Register);
end;

initialization
  RegisterPackage('JvAppFrmLazD', @Register);
end.
