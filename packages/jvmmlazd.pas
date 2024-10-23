{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvMMLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvMMReg, JvId3v2EditorForm, JvId3v2DefineForm, JvFullColorEditors, 
  JvFullColorSpacesEditors, JvFullColorListForm, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvMMReg', @JvMMReg.Register);
end;

initialization
  RegisterPackage('JvMMLazD', @Register);
end.
