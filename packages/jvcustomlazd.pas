{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvCustomLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvCustomReg, JvTimeLineEditor, JvOutlookBarEditors, JvOutlookBarForm, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvCustomReg', @JvCustomReg.Register);
end;

initialization
  RegisterPackage('JvCustomLazD', @Register);
end.
