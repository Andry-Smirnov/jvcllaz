{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPageListEditorForm.PAS, released on 2004-03-28.

The Initial Developer of the Original Code is Peter Thornqvist <peter3 at sourceforge dot net>
Portions created by Peter Thornqvist are Copyright (C) 2004 Peter Thornqvist.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvPageListEditorForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ComCtrls, StdCtrls, {ToolWin, }Menus,
  PropEdits, PropEditUtils, ComponentEditors,
  JvPageList, JvPageListEditors, IDEWindowIntf;

type

  { TfrmPageListEditor }

  TfrmPageListEditor = class(TForm)
    ToolBar1: TToolBar;
    btnAdd: TToolButton;
    btnDelete: TToolButton;
    ToolButton1: TToolButton;
    tbMoveUp: TToolButton;
    tbMoveDown: TToolButton;
    lbPages: TListBox;
    alEditor: TActionList;
    acAdd: TAction;
    acDelete: TAction;
    acMoveUp: TAction;
    acMoveDown: TAction;
    ilButtons: TImageList;
    StatusBar1: TStatusBar;
    popEditor: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure acDeleteUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbPagesClick(Sender: TObject);
    procedure alEditorUpdate(AAction: TBasicAction; var Handled: Boolean);
    procedure lbPagesKeyPress(Sender: TObject; var Key: Char);
  private
    FPageList: TJvCustomPageList;
    FIgnoreEvents: Boolean;
    FEditor: TJvCustomPageEditor;
    procedure SetPageList(const Value: TJvCustomPageList);
    procedure UpdateList(ItemIndex: Integer);
    procedure SelectPage(const Index: Integer);
    //procedure Add(Page: TJvCustomPage);
    function FindPage(APage: TJvCustomPage; out AIndex: Integer): Boolean;
    procedure OnComponentRenamed(AComponent: TComponent);
    procedure OnPersistentDeleting(APersistent: TPersistent);
    procedure OnPersistentAdded(APersistent: TPersistent; Select: boolean);
  public
    property PageList:TJvCustomPageList read FPageList write SetPageList;
  end;

procedure ShowPageListEditor(Editor: TJvCustomPageEditor; APageList: TJvCustomPageList);

implementation

uses
  JvDsgnConsts;

{$R *.lfm}

procedure ShowPageListEditor(Editor: TJvCustomPageEditor; APageList: TJvCustomPageList);
var
  frmPageListEditor: TfrmPageListEditor = nil;
begin
  // Show the editor
  frmPageListEditor := FindEditorForm(Editor.GetComponent) as TfrmPageListEditor;
  if not Assigned(frmPageListEditor) then
      frmPageListEditor := TfrmPageListEditor.Create(Application);
    try
      frmPageListEditor.FEditor := Editor;
      frmPageListEditor.PageList := APageList;
      frmPageListEditor.Caption := Format(RsFmtCaption,[APageList.Name]);
      RegisterEditorForm(frmPageListEditor, Editor.GetComponent);
    except
      frmPageListEditor.Free;
      raise;
    end;
  frmPageListEditor.EnsureVisible;
end;

type
  TJvCustomPageAccess = class(TJvCustomPage);

procedure TfrmPageListEditor.acAddExecute(Sender: TObject);
//var
  //APage: TJvCustomPage;
  //Hook: TPropertyEditorHook;
begin
  //if not FEditor.GetHook(Hook) then
  //  Exit;
  //APage := PageList.GetPageClass.Create(PageList.Owner);
  //try
  //  APage.Name := FEditor.GetDesigner.CreateUniqueComponentName(APage.ClassName);
  //  Add(APage);
  //  Hook.PersistentAdded(APage, True);
  //  FEditor.Modified;
  //except
  //  APage.Free;
  //  raise;
  //end;
  if FEditor.GetPageControl <> nil then
    FEditor.InsertPage;
end;

procedure TfrmPageListEditor.acDeleteExecute(Sender: TObject);
//var
//  I: Integer;
//  Hook: TPropertyEditorHook;
begin
  //if Assigned(PageList.ActivePage) and FEditor.GetHook(Hook) then
  //begin
  //  I := lbPages.ItemIndex;
  //  if lbPages.ItemIndex >= 0 then
  //    lbPages.Items.Delete(TJvCustomPageAccess(PageList.ActivePage).PageIndex);
  //  if GlobalDesignHook <> nil then
  //    GlobalDesignHook.SelectOnlyThis(PageList);
  //  PageList.ActivePage.Free;
  //  Hook.PersistentDeleted;
  //  if I >= lbPages.Items.Count then
  //    Dec(I);
  //  if (I >= 0) and (I < lbPages.Items.Count) then
  //  begin
  //    lbPages.ItemIndex := I;
  //    SelectPage(I);
  //  end
  //  else
  //    FEditor.Modified;
  //end;
  if (FEditor.GetPageControl <> nil) then
    FEditor.RemovePage;
end;

procedure TfrmPageListEditor.acMoveUpExecute(Sender: TObject);
var
  I: Integer;
begin
  I := lbPages.ItemIndex;
  lbPages.Items.Move(I, I-1);
  if Assigned(PageList) then
  begin
    TJvCustomPageAccess(PageList.Pages[I]).PageIndex := I - 1;
    lbPages.ItemIndex := I - 1;
  end;
end;

procedure TfrmPageListEditor.acMoveDownExecute(Sender: TObject);
var
  I: Integer;
begin
  I := lbPages.ItemIndex;
  lbPages.Items.Move(I, I+1);
  if Assigned(PageList) then
  begin
    TJvCustomPageAccess(PageList.Pages[I]).PageIndex := I + 1;
    lbPages.ItemIndex := I + 1;
  end;
end;

procedure TfrmPageListEditor.SetPageList(const Value: TJvCustomPageList);
begin
  if FPageList <> Value then
  begin
    FPageList := Value;
    UpdateList(0);
  end;
end;

//procedure TfrmPageListEditor.Add(Page: TJvCustomPage);
//var
//  Hook: TPropertyEditorHook;
//begin
//  if not FEditor.GetHook(Hook) then
//    Exit;
//  Page.Parent := PageList;
//  Page.PageList := PageList;
//  PageList.ActivePage := Page;
//  Hook.PersistentAdded(Page, True);
//  GlobalDesignHook.SelectOnlyThis(Page);
//  FEditor.Modified;
//  lbPages.ItemIndex := lbPages.Items.Add(Page.Name);
//end;

function TfrmPageListEditor.FindPage(APage: TJvCustomPage; out AIndex: Integer
  ): Boolean;
var
  I: Integer;
begin
  if Assigned(PageList) and (PageList.PageCount > 0) then
    for I := 0 to PageList.PageCount - 1 do
      if PageList.Pages[I] = APage then
      begin
        AIndex := I;
        Exit(True);
      end;
  AIndex := -1;
  Result := False;
end;

procedure TfrmPageListEditor.OnComponentRenamed(AComponent: TComponent);
var
  I: Integer;
begin
  if FIgnoreEvents then Exit;
  if (AComponent is TJvCustomPage) and FindPage(TJvCustomPage(AComponent), I) then
    UpdateList(I);
end;

procedure TfrmPageListEditor.OnPersistentDeleting(APersistent: TPersistent);
begin
  if FIgnoreEvents then Exit;
  if (APersistent is TJvCustomPage) then
    UpdateList(-1)
  else if (APersistent is TJvCustomPageList) and (FEditor.GetPageControl = APersistent) then
    Close;
end;

procedure TfrmPageListEditor.OnPersistentAdded(APersistent: TPersistent;
  Select: boolean);
var
  I: Integer;
begin
  if FIgnoreEvents then Exit;
  if (APersistent is TJvCustomPage) and FindPage(TJvCustomPage(APersistent), I) then
  begin
    UpdateList(I);
    lbPages.Selected[I] := Select;
  end;
end;

procedure TfrmPageListEditor.SelectPage(const Index: Integer);
var
  Page: TJvCustomPageAccess;
begin
  if Assigned(FPageList) and Active then
  begin
    FIgnoreEvents := True;
    try
      Page := nil;
      if (Index >= 0) and (Index < FPageList.PageCount) then
        Page := TJvCustomPageAccess(FPageList.Pages[Index]);
      PageList.ActivePage := Page;
      if GlobalDesignHook <> nil then
      begin
        GlobalDesignHook.SelectOnlyThis(Page);
        GlobalDesignHook.Modified(PageList);
      end;
    finally
      FIgnoreEvents := False;
    end;
  end;
end;

procedure TfrmPageListEditor.UpdateList(ItemIndex: Integer);
var
  I: Integer;
begin
  if Assigned(FPageList) then
  begin
    FIgnoreEvents := True;
    lbPages.Items.BeginUpdate;
    try
      lbPages.Items.Clear;
      for I := 0 to FPageList.PageCount - 1 do
        lbPages.Items.Add(TJvCustomPageAccess(FPageList.Pages[I]).Name);
      if (ItemIndex >= 0) and (ItemIndex < lbPages.Items.Count) then
        lbPages.ItemIndex := ItemIndex
      else
        lbPages.ItemIndex := -1;
    finally
      lbPages.Items.EndUpdate;
      FIgnoreEvents := False;
    end;
  end
  else
    lbPages.Items.Clear;
end;

procedure TfrmPageListEditor.FormClose(Sender: TObject;
  var AAction: TCloseAction);
begin
  IDEDialogLayoutList.SaveLayout(Self);
  AAction := caFree;
end;

procedure TfrmPageListEditor.acDeleteUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (lbPages.Items.Count > 0) and (lbPages.ItemIndex >= 0);
end;

procedure TfrmPageListEditor.FormDestroy(Sender: TObject);
begin
  if Assigned(GlobalDesignHook) then
    GlobalDesignHook.RemoveAllHandlersForObject(Self);
  UnregisterEditorForm(Self);
end;

procedure TfrmPageListEditor.lbPagesClick(Sender: TObject);
begin
  SelectPage(lbPages.ItemIndex);
end;

procedure TfrmPageListEditor.alEditorUpdate(AAction: TBasicAction;
  var Handled: Boolean);
begin
  acMoveUp.Enabled := lbPages.ItemIndex > 0;
  acMoveDown.Enabled :=
    (lbPages.ItemIndex <> -1) and
    (lbPages.ItemIndex < lbPages.Items.Count - 1);
end;

procedure TfrmPageListEditor.lbPagesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if lbPages.ItemIndex <> -1 then
  begin
    SelectPage(lbPages.ItemIndex);
    //ActivateInspector(Key);
    Key := #0;
  end;
end;

procedure TfrmPageListEditor.FormCreate(Sender: TObject);
begin
  IDEDialogLayoutList.ApplyLayout(Self);
  if Assigned(GlobalDesignHook) then
  begin
    GlobalDesignHook.AddHandlerComponentRenamed(@OnComponentRenamed);
    GlobalDesignHook.AddHandlerPersistentDeleting(@OnPersistentDeleting);
    GlobalDesignHook.AddHandlerPersistentAdded(@OnPersistentAdded);
  end;
end;

end.
