{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvWizardEditorForm.PAS, released on 2002-01-29.

The Initial Developer of the Original Code is William Yu Wei.
Portions created by William Yu Wei are Copyright (C) 2002 William Yu Wei.
All Rights Reserved.

Contributor(s):
Peter Thцrnqvist - converted to JVCL naming conventions on 2003-07-11
Michaі Gawrycki - Lazarus port (2019)

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{*****************************************************************************
  Purpose:   Jv Wizard Component Editor

  History:
  ---------------------------------------------------------------------------
  Date(mm/dd/yy)   Comments
  ---------------------------------------------------------------------------
  01/29/2002       Initial create
                   1) Move TJvWizardActivePageProperty, TJvWizardEditor
                      class from JvWizardReg to here
                   2) TJvWizardPageListProperty added
                      TJvWizardPageList dialog form added
******************************************************************************}

unit JvWizardEditorForm;

{$mode objfpc}
{$H+}

interface

uses
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, ActnList, ImgList, ComCtrls, StdCtrls,
  ToolWin, Menus, PropEdits, ComponentEditors, FormEditingIntf,
  JvWizard;

type
  TJvWizardActivePageProperty = class(TComponentPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  // JvWizard Component Local Menu Editor

  { TJvWizardEditor }

  TJvWizardEditor = class(TComponentEditor)
  protected
    function GetWizard: TJvWizard; virtual;
    function GetPageOwner: TComponent;
    procedure AddPage(Page: TJvWizardCustomPage);
    procedure AddWelcomePage;
    procedure AddInteriorPage;
    procedure NextPage(Step: Integer);
    property Wizard: TJvWizard read GetWizard;
  public
    constructor Create(AComponent: TComponent;
      ADesigner: TComponentEditorDesigner); override;
    destructor Destroy; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TJvWizardPageListProperty = class(TPropertyEditor)
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  { TJvWizardLazIDEHelper }

  TJvWizardLazIDEHelper = class
  private
    procedure SetSelection(const ASelection: TPersistentSelectionList);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TJvWizardPageListEditor }

  TJvWizardPageListEditor = class({TDesignWindow}TForm)
    tbrWizardPages: TToolBar;
    lbxWizardPages: TListBox;
    btnAddWelcomePage: TToolButton;
    btnDeletePages: TToolButton;
    ToolButton1: TToolButton;
    imgWizardPages: TImageList;
    actWizardPages: TActionList;
    actAddWelcomePage: TAction;
    actAddInteriorPage: TAction;
    actDeletePages: TAction;
    popWizard: TPopupMenu;
    AddWelcomePage1: TMenuItem;
    AddInteriorPage1: TMenuItem;
    tbMoveUp: TToolButton;
    tbMoveDown: TToolButton;
    acMoveUp: TAction;
    acMoveDown: TAction;
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure actAddWelcomePageExecute(Sender: TObject);
    procedure actAddInteriorPageExecute(Sender: TObject);
    procedure actDeletePagesExecute(Sender: TObject);
    procedure actDeletePagesUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxWizardPagesClick(Sender: TObject);
    procedure lbxWizardPagesMouseDown(Sender: TObject;
      {%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure lbxWizardPagesDragOver(Sender, Source: TObject; X, Y: Integer;
      {%H-}State: TDragState; var Accept: Boolean);
    procedure lbxWizardPagesDragDrop(Sender, {%H-}Source: TObject; X, Y: Integer);
    procedure actWizardPagesUpdate({%H-}AAction: TBasicAction;
      var {%H-}Handled: Boolean);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
  private
    FDesigner: TComponentEditorDesigner;
    FWizard: TJvWizard;
    procedure SetWizard(const Value: TJvWizard);
    procedure UpdatePageList(const CurrItemIndex: Integer);
    procedure SelectWizardPage(const Index: Integer);
    function GetPageOwner: TComponent;

    procedure DeletePersist(APersistent: TPersistent);
    procedure ItemModified(Sender: TObject);
  protected
    procedure AddPage(Page: TJvWizardCustomPage);
    procedure AddWelcomePage;
    procedure AddInteriorPage;
    property Wizard: TJvWizard read FWizard write SetWizard;
  public
    property CompDesigner: TComponentEditorDesigner read FDesigner write FDesigner;
  end;

implementation

uses
  JvDsgnConsts;

{$R *.lfm}

procedure ShowWizardPageListEditor(Designer: TComponentEditorDesigner; AWizard: TJvWizard);
var
  I: Integer;
  AWizardPageListEditor: TJvWizardPageListEditor;
begin
  // because the page list editor is not show modal, so
  // we need to find it rather than create a new instance.
  AWizardPageListEditor := nil;
  for I := 0 to Screen.FormCount - 1 do
    if Screen.Forms[I] is TJvWizardPageListEditor then
      if TJvWizardPageListEditor(Screen.Forms[I]).Wizard = AWizard then
      begin
        AWizardPageListEditor := TJvWizardPageListEditor(Screen.Forms[I]);
        Break;
      end;
  // Show the wizard editor
  if Assigned(AWizardPageListEditor) then
  begin
    AWizardPageListEditor.Show;
    if AWizardPageListEditor.WindowState = wsMinimized then
      AWizardPageListEditor.WindowState := wsNormal;
  end
  else
  begin
    AWizardPageListEditor := TJvWizardPageListEditor.Create(Application);
    try
      AWizardPageListEditor.CompDesigner := Designer;
      AWizardPageListEditor.Wizard := AWizard;
      AWizardPageListEditor.Show;
    except
      AWizardPageListEditor.Free;
      raise;
    end;
  end;
end;

{ TJvWizardLazIDEHelper }

procedure TJvWizardLazIDEHelper.SetSelection(
  const ASelection: TPersistentSelectionList);
begin
  if (ASelection.Count = 1) and (ASelection.Items[0] is TJvWizardCustomPage) and
    Assigned(TJvWizardCustomPage(ASelection.Items[0]).Wizard) then
    TJvWizardCustomPage(ASelection.Items[0]).Wizard.ActivePage := TJvWizardCustomPage(ASelection.Items[0]);
end;

constructor TJvWizardLazIDEHelper.Create;
begin
  if GlobalDesignHook <> nil then
    GlobalDesignHook.AddHandlerSetSelection(@SetSelection);
end;

destructor TJvWizardLazIDEHelper.Destroy;
begin
  if GlobalDesignHook <> nil then
    GlobalDesignHook.RemoveAllHandlersForObject(Self);
  inherited Destroy;
end;

//=== { TJvWizardActivePageProperty } ========================================

function TJvWizardActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TJvWizardActivePageProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Component: TComponent;
  Root: TPersistent;
begin
  Root := PropertyHook.LookupRoot;
  if not (Root is TComponent) then
    Root := GetComponent(0);
  for I := 0 to TComponent(Root).ComponentCount - 1 do
  begin
    Component := TComponent(Root).Components[I];
    if (Component.Name <> '') and (Component is TJvWizardCustomPage) and
      (TJvWizardCustomPage(Component).Wizard = GetComponent(0)) then
      Proc(Component.Name);
  end;
end;

//=== { TJvWizardEditor } ====================================================

procedure TJvWizardEditor.AddPage(Page: TJvWizardCustomPage);
begin
  Page.Parent := Wizard;
  Page.Wizard := Wizard;
  Wizard.ActivePage := Page;
  Designer.PropertyEditorHook.PersistentAdded(Page, True);
  Designer.PropertyEditorHook.RefreshPropertyValues;
  Designer.Modified;
  if GlobalDesignHook <> nil then
    GlobalDesignHook.Modified(Self);
end;

procedure TJvWizardEditor.AddInteriorPage;
var
  Page: TJvWizardInteriorPage;
begin
  Page := TJvWizardInteriorPage.Create(GetPageOwner);
  try
    Page.Name := Designer.UniqueName(TJvWizardInteriorPage.ClassName);
    AddPage(Page);
  except
    Page.Free;
    raise;
  end;
end;

procedure TJvWizardEditor.AddWelcomePage;
var
  Page: TJvWizardWelcomePage;
begin
  Page := TJvWizardWelcomePage.Create(GetPageOwner);
  try
    Page.Name := Designer.UniqueName(TJvWizardWelcomePage.ClassName);
    AddPage(Page);
  except
    Page.Free;
    raise;
  end;
end;

procedure TJvWizardEditor.ExecuteVerb(Index: Integer);
var
  Page: TPersistent;
begin
  case Index of
    0:
      ShowWizardPageListEditor(Designer, GetWizard);
    1:
      AddWelcomePage;
    2:
      AddInteriorPage;
    3:
      NextPage(1);
    4:
      NextPage(-1);
    5:
      if Assigned(Wizard.ActivePage) then
      begin
        GlobalDesignHook.SelectOnlyThis(Wizard);
        Page := Wizard.ActivePage;
        GlobalDesignHook.DeletePersistent(Page);
      end;
  end;
end;

function TJvWizardEditor.GetWizard: TJvWizard;
begin
  if Component is TJvWizard then
    Result := TJvWizard(Component)
  else
    Result := TJvWizard(TJvWizardCustomPage(Component).Wizard);
end;

function TJvWizardEditor.GetPageOwner: TComponent;
begin
  if Wizard <> nil then
  begin
    Result := Wizard.Owner;
    if Result = nil then
      Result := Wizard;
  end
  else
    Result := nil;
end;

function TJvWizardEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
      Result := RsPageListEllipsis;
    1:
      Result := RsNewWelcomePage;
    2:
      Result := RsNewInteriorPage;
    3:
      Result := RsNextPage;
    4:
      Result := RsPreviousPage;
    5:
      Result := RsDeletePage;
  end;
end;

function TJvWizardEditor.GetVerbCount: Integer;
begin
  Result := 6;
end;

procedure TJvWizardEditor.NextPage(Step: Integer);
var
  Page: TJvWizardCustomPage;
begin
  Page := Wizard.FindNextPage(Wizard.ActivePageIndex, Step, False);
  if Assigned(Page) and (Page <> Wizard.ActivePage) then
  begin
    if Component is TJvWizardCustomPage then
      Designer.SelectOnlyThisComponent(Page);
    Wizard.ActivePage := Page;
    Designer.Modified;
  end;
end;

constructor TJvWizardEditor.Create(AComponent: TComponent;
  ADesigner: TComponentEditorDesigner);
begin
  inherited Create(AComponent, ADesigner);
end;

destructor TJvWizardEditor.Destroy;
begin
  inherited Destroy;
end;

//=== { TJvWizardPageListEditor } ============================================

procedure TJvWizardPageListProperty.Edit;
begin
  //ShowWizardPageListEditor(Designer, TJvWizard(GetComponent(0)));
end;

function TJvWizardPageListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TJvWizardPageListProperty.GetValue: string;
var
  APageList: TList;
begin
  APageList := TList(GetObjectValue);
  if not Assigned(APageList) or (APageList.Count <= 0) then
    Result := RsNone
  else
    Result := Format('(%s)', [GetPropType^.Name]);
end;

//=== { TJvWizardPageList Dialog Form } ======================================

procedure TJvWizardPageListEditor.UpdatePageList(const CurrItemIndex: Integer);
var
  I: Integer;
begin
  if Assigned(FWizard) then
  begin
    lbxWizardPages.Items.BeginUpdate;
    try
      lbxWizardPages.Items.Clear;
      for I := 0 to FWizard.PageCount - 1 do
        lbxWizardPages.Items.Add(TJvWizardCustomPage(FWizard.Pages[I]).Name);
      if (CurrItemIndex >= 0) and (CurrItemIndex < lbxWizardPages.Items.Count) then
        lbxWizardPages.ItemIndex := CurrItemIndex
      else
        lbxWizardPages.ItemIndex := -1;
    finally
      lbxWizardPages.Items.EndUpdate;
    end;
  end;
end;

procedure TJvWizardPageListEditor.SelectWizardPage(const Index: Integer);
var
  Page: TJvWizardCustomPage;
begin
  if Assigned(FWizard) and Active then
  begin
    Page := nil;
    if (Index >= 0) and (Index < FWizard.PageCount) then
      Page := TJvWizardCustomPage(FWizard.Pages[Index]);
    if Assigned(Page) then
      CompDesigner.SelectOnlyThisComponent(Page)
    else
      if Assigned(Wizard) then
        CompDesigner.SelectOnlyThisComponent(Wizard);
    Wizard.ActivePage := Page;
    CompDesigner.Modified;
  end;
end;

function TJvWizardPageListEditor.GetPageOwner: TComponent;
begin
  if Wizard <> nil then
  begin
    Result := Wizard.Owner;
    if Result = nil then
      Result := Wizard;
  end
  else
    Result := nil;
end;

procedure TJvWizardPageListEditor.DeletePersist(APersistent: TPersistent);
begin
  if APersistent = FWizard then
  begin
    FWizard := nil;
    Close;
  end
  else if APersistent is TJvWizardCustomPage then
    ItemModified(nil);
end;

procedure TJvWizardPageListEditor.ItemModified(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    UpdatePageList(lbxWizardPages.ItemIndex);
end;

procedure TJvWizardPageListEditor.SetWizard(const Value: TJvWizard);
begin
  if FWizard <> Value then
  begin
    FWizard := Value;
    UpdatePageList(0);
  end;
end;

procedure TJvWizardPageListEditor.AddPage(Page: TJvWizardCustomPage);
begin
  Page.Parent := Wizard;
  Page.Wizard := Wizard;
  Wizard.ActivePage := Page;
  //list box will show twice when adding either welcome page or interior page.
  lbxWizardPages.ItemIndex := lbxWizardPages.Items.Add(Page.Name);
  CompDesigner.PropertyEditorHook.PersistentAdded(Page, True);
  CompDesigner.PropertyEditorHook.RefreshPropertyValues;
  CompDesigner.PropertyEditorHook.Modified(Self);
  if GlobalDesignHook <> nil then
    GlobalDesignHook.Modified(Self);
end;

procedure TJvWizardPageListEditor.AddInteriorPage;
var
  APage: TJvWizardCustomPage;
begin
  APage := TJvWizardInteriorPage.Create(GetPageOwner);
  try
    APage.Name := CompDesigner.UniqueName(APage.ClassName);
    AddPage(APage);
  except
    APage.Free;
    raise;
  end;
end;

procedure TJvWizardPageListEditor.AddWelcomePage;
var
  APage: TJvWizardCustomPage;
begin
  APage := TJvWizardWelcomePage.Create(GetPageOwner);
  try
    APage.Name := CompDesigner.UniqueName(APage.ClassName);
    AddPage(APage);
  except
    APage.Free;
    raise;
  end;
end;

procedure TJvWizardPageListEditor.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
  AAction := caFree;
  GlobalDesignHook.RemoveAllHandlersForObject(Self);
end;

procedure TJvWizardPageListEditor.actAddWelcomePageExecute(Sender: TObject);
begin
  AddWelcomePage;
end;

procedure TJvWizardPageListEditor.actAddInteriorPageExecute(Sender: TObject);
begin
  AddInteriorPage;
end;

procedure TJvWizardPageListEditor.actDeletePagesExecute(Sender: TObject);
begin
  if Assigned(Wizard.ActivePage) then
  begin
    if lbxWizardPages.ItemIndex >= 0 then
      lbxWizardPages.Items.Delete(Wizard.ActivePage.PageIndex);
    CompDesigner.SelectOnlyThisComponent(Wizard);
    Wizard.ActivePage.Free;
    CompDesigner.Modified;
  end;
end;

procedure TJvWizardPageListEditor.actDeletePagesUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (lbxWizardPages.Items.Count > 0) and (lbxWizardPages.ItemIndex >= 0);
end;

procedure TJvWizardPageListEditor.FormShow(Sender: TObject);
begin
  GlobalDesignHook.AddHandlerPersistentDeleting(@DeletePersist);
  GlobalDesignHook.AddHandlerModified(@ItemModified);
end;

procedure TJvWizardPageListEditor.lbxWizardPagesClick(Sender: TObject);
begin
  SelectWizardPage(lbxWizardPages.ItemIndex);
end;

procedure TJvWizardPageListEditor.lbxWizardPagesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lbxWizardPages.BeginDrag(False);
end;

procedure TJvWizardPageListEditor.lbxWizardPagesDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept :=
    (Source is TListBox) and
    (lbxWizardPages.ItemAtPos(Point(X, Y), True) <> -1) and
    (lbxWizardPages.ItemAtPos(Point(X, Y), True) <> lbxWizardPages.ItemIndex);
end;

procedure TJvWizardPageListEditor.lbxWizardPagesDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  OldIndex, NewIndex: Integer;
begin
  OldIndex := lbxWizardPages.ItemIndex;
  NewIndex := lbxWizardPages.ItemAtPos(Point(X,Y), True);
  lbxWizardPages.Items.Move(OldIndex, NewIndex);
  if Assigned(FWizard) then
  begin
    TJvWizardCustomPage(FWizard.Pages[OldIndex]).PageIndex := NewIndex;
    lbxWizardPages.ItemIndex := NewIndex;
  end;
end;

procedure TJvWizardPageListEditor.actWizardPagesUpdate(AAction: TBasicAction;
  var Handled: Boolean);
begin
  acMoveUp.Enabled := lbxWizardPages.ItemIndex > 0;
  acMoveDown.Enabled :=
    (lbxWizardPages.ItemIndex <> -1) and
    (lbxWizardPages.ItemIndex < lbxWizardPages.Items.Count - 1);
end;

procedure TJvWizardPageListEditor.acMoveUpExecute(Sender: TObject);
var
  I: Integer;
begin
  I := lbxWizardPages.ItemIndex;
  lbxWizardPages.Items.Move(I, I-1);
  if Assigned(FWizard) then
  begin
    TJvWizardCustomPage(FWizard.Pages[I]).PageIndex := I - 1;
    lbxWizardPages.ItemIndex := I - 1;
  end;
end;

procedure TJvWizardPageListEditor.acMoveDownExecute(Sender: TObject);
var
  I: Integer;
begin
  I := lbxWizardPages.ItemIndex;
  lbxWizardPages.Items.Move(I, I+1);
  if Assigned(FWizard) then
  begin
    TJvWizardCustomPage(FWizard.Pages[I]).PageIndex := I + 1;
    lbxWizardPages.ItemIndex := I + 1;
  end;
end;

end.
