unit JvCoreReg;

{$mode objfpc}{$H+}

interface

procedure Register;

implementation

uses
  Classes, PropEdits,
  JvTypes, JvDsgnEditors;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TJvPersistentProperty), nil, '', TJvPersistentPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TComponentName), TJvPersistentProperty, 'Name', THiddenPropertyEditor);
end;

end.

