{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvCmpD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvCmpReg, JvStrHolderEditor, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvCmpReg', @JvCmpReg.Register);
end;

initialization
  RegisterPackage('JvCmpD', @Register);
end.
