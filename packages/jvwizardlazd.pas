{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvWizardLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvWizardEditorForm, JvWizardReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvWizardReg', @JvWizardReg.Register);
end;

initialization
  RegisterPackage('JvWizardLazD', @Register);
end.
