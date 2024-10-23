unit JvDBReg;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, PropEdits, DBPropEdits;

procedure Register;


implementation

{$R ../../resource/jvdbreg.res}

uses
  Classes, JvDsgnConsts, //JvDBSearchCombobox,
  JvDBSearchEdit, JvDBTreeView, JvDBControls, JvDBHTLabel, JvDBLookup, JvDBLookupTreeView;

procedure Register;
const
//  cDataField = 'DataField';
  cKeyField = 'KeyField';
  cListField = 'ListField';
//  cDisplayField = 'DisplayField';
//  cListKeyField = 'ListKeyField';
  cMasterField = 'MasterField';
  cDetailField = 'DetailField';
  cIconField = 'IconField';
  cItemField = 'ItemField';
//  cLookupField = 'LookupField';
// cSectionField = 'SectionField';
//  cValueField = 'ValueField';
//  cEditControls = 'EditControls';
//  cSortedField = 'SortedField';
//  cSortMarker = 'SortMarker';

begin
  RegisterComponents(RsPaletteJvclDB, [     // was: TsPaletteDBVisual
    TJvDBCalcEdit,
    TJvDBSearchEdit,
//    TJvDBSearchCombobox,
    TJvDBTreeView,
    TJvDBHTLabel,
    TJvDBLookupList, TJvDBLookupCombo, TJvDBLookupTreeView
  ]);
                
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cItemField, TFieldProperty); 
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cMasterField, TFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cDetailField, TFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBTreeView, cIconField, TFieldProperty);

  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cKeyField, TLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cListField, TLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cMasterField, TLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cDetailField, TLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDBLookupTreeView, cIconField, TLookupFieldProperty);
end;

end.

