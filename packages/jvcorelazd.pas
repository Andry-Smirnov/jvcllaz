{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvCoreLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvCoreReg, JvDsgnConsts, JvStringsForm, JvDsgnEditors, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvCoreReg', @JvCoreReg.Register);
end;

initialization
  RegisterPackage('JvCoreLazD', @Register);
end.
