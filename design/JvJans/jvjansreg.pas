unit JvJansReg;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure Register;

implementation

{$R ../../resource/jvjansreg.res}

uses
  Classes, JvDsgnConsts,
  JvYearGrid,
  //JvCSVData, JvCSVBaseControls, //JvCsvBaseEditor,
  JvMarkupViewer, JvMarkupLabel,
  JvGridFilter,
  JvSimScope, JvSimIndicator, JvSimPID, JvSimPIDLinker, JvSimLogic,
  JvJanLED, JvJanToggle;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclVisual, [
    TJvYearGrid
  ]);

  // Simulator Components
  RegisterComponents(RsPaletteJvclVisual, [            // was: RsPaletteJansSim
    TJvSimScope, TJvSimIndicator, TJvSimPID,
    TJvSimPIDLinker, TJvSimConnector, TJvLogic, TJvSimButton, TJvSimLight,
    TJvSimLogicBox, TJvSimReverse,
    TJvJanLed, TJvJanToggle
  ]);

  // Markup components
  RegisterComponents(RsPaletteJvclVisual, [
    TJvMarkupViewer, TJvMarkupLabel
  ]);

  // Grid-related components
  RegisterComponents(RsPaletteJvclVisual, [
    TJvGridFilter
  ]);

                     (*
  // CSV Components
  RegisterComponents('Data Access', [TJvCSVDataset]);
  RegisterComponents(RsPaletteJansCsv, [TJvCSVBase, TJvCSVEdit, TJvCSVComboBox,
    TJvCSVCheckBox, TJvCSVNavigator]);
//  RegisterPropertyEditor(TypeInfo(string), TJvCSVBase, cCSVFieldName, TJvCSVFileNameProperty);
//  RegisterPropertyEditor(TypeInfo(string), TJvCSVEdit, cCSVField, TJvCSVFieldProperty);
//  RegisterPropertyEditor(TypeInfo(string), TJvCSVComboBox, cCSVField, TJvCSVFieldProperty);
//  RegisterPropertyEditor(TypeInfo(string), TJvCSVCheckBox, cCSVField, TJvCSVFieldProperty);
*)

end;

end.

