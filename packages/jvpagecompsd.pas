{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvPageCompsD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvPageCompsReg, JvNavPaneEditors, JvPageListEditors, JvPageLinkEditorForm, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvPageCompsReg', @JvPageCompsReg.Register);
end;

initialization
  RegisterPackage('JvPageCompsD', @Register);
end.