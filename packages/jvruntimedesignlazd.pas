{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit JvRuntimeDesignLazD;

{$warn 5023 off : no warning about unused units}
interface

uses
  JvRuntimeDesignReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('JvRuntimeDesignReg', @JvRuntimeDesignReg.Register);
end;

initialization
  RegisterPackage('JvRuntimeDesignLazD', @Register);
end.
