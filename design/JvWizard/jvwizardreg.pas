unit JvWizardReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Register;

implementation

uses
  JvWizard, JvWizardRouteMapNodes, JvWizardRouteMapSteps, JvWizardRouteMapList,
  JvWizardEditorForm, JvDsgnConsts, PropEdits, ComponentEditors, FormEditingIntf;

{$R ../../resource/jvwizardsreg.res}

var
  JvWizardIdeHelper: TJvWizardLazIDEHelper = nil;

procedure Register;
const
  cActivePage = 'ActivePage';
  cPages = 'Pages';
begin
  RegisterComponents({RsPaletteWizard}RsPaletteJvclVisual, [TJvWizard, TJvWizardRouteMapSteps,
    TJvWizardRouteMapNodes, TJvWizardRouteMapList]);
  RegisterNoIcon([TJvWizardCustomPage, TJvWizardWelcomePage,
    TJvWizardInteriorPage]);
  RegisterComponentEditor(TJvWizard, TJvWizardEditor);
  RegisterComponentEditor(TJvWizardCustomPage, TJvWizardEditor);
  RegisterComponentEditor(TJvWizardWelcomePage, TJvWizardEditor);
  RegisterComponentEditor(TJvWizardInteriorPage, TJvWizardEditor);
  RegisterPropertyEditor(TypeInfo(TJvWizardCustomPage), TJvWizard, cActivePage,
    TJvWizardActivePageProperty);
  RegisterPropertyEditor(TypeInfo(TJvWizardWelcomePage), TJvWizard, cActivePage,
    TJvWizardActivePageProperty);
  RegisterPropertyEditor(TypeInfo(TJvWizardInteriorPage), TJvWizard, cActivePage,
    TJvWizardActivePageProperty);
  // JvWizard Page List Editor
  RegisterPropertyEditor(TypeInfo(TJvWizardPageList), TJvWizard, cPages,
    TJvWizardPageListProperty);

  if Assigned(GlobalDesignHook) and (not Assigned(JvWizardIdeHelper)) then
    JvWizardIdeHelper := TJvWizardLazIDEHelper.Create;
end;

finalization
  if Assigned(JvWizardIdeHelper) then
    JvWizardIdeHelper.Free;

end.

