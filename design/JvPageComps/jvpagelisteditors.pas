{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPageListEditors.PAS, released on 2004-03-31.

The Initial Developer of the Original Code is Peter Thцrnqvist [peter3 at sourceforge dot net] .
Portions created by Peter Thцrnqvist are Copyright (C) 2003 Peter Thцrnqvist.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvPageListEditors;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ImgList, Graphics, Classes,
  PropEdits, ComponentEditors, GraphPropEdits, PropEditUtils,
  JvPageList; //, JvDsgnEditors;

type
  { a property editor for the ActivePage property of TJvPageList }
  TJvActivePageProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TJvShowDesignCaptionProperty = class(TEnumProperty)
    function GetAttributes: TPropertyAttributes; override;
  end;

  { a component editor for the TJvPageList }
  TJvCustomPageEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;

    function GetPageControl: TJvCustomPageList;
    procedure InsertPage;
    procedure PrevPage;
    procedure NextPage;
    procedure RemovePage;
  end;

  TJvSettingsTreeImagesProperty = class(TImageIndexPropertyEditor{TJvDefaultImageIndexProperty})
  protected
    function GetImageList: TCustomImageList; override;
  end;

implementation

uses
  TypInfo,
  JvDsgnConsts, JvPageListTreeView, JvPageListEditorForm;

type
  THackTreeView = class(TJvCustomPageListTreeView);

const
  cShowEditor = 0;
  cDash = 1;
  cNewPage = 2;
  cNextPage = 3;
  cPrevPage = 4;
  cDelPage = 5;

  cElementCount = 6;

procedure TJvCustomPageEditor.Edit;
begin
  ExecuteVerb(cShowEditor);
end;

procedure TJvCustomPageEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    cShowEditor:
      ShowPageListEditor(Self, GetPageControl);
    cNextPage:
      NextPage;
    cPrevPage:
      PrevPage;
    cNewPage:
      InsertPage;
    cDelPage:
      RemovePage;
  end;
end;

function TJvCustomPageEditor.GetPageControl: TJvCustomPageList;
begin
  if GetComponent is TJvCustomPageList then
    Result := TJvCustomPageList(Component)
  else
    Result := TJvCustomPageList(TJvCustomPage(Component).PageList);
end;

function TJvCustomPageEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    cShowEditor:
      Result := RsPageListEditorEllipsis;
    cDash:
      Result := '-';
    cNewPage:
      Result := RsNewPage;
    cNextPage:
      Result := RsNextPageAmp;
    cPrevPage:
      Result := RsPrevPage;
    cDelPage:
      Result := RsDelPage;
  end;
end;

function TJvCustomPageEditor.GetVerbCount: Integer;
begin
  Result := cElementCount; // list, div, new, next, previous, delete
end;

procedure TJvCustomPageEditor.InsertPage;
var
  P: TJvCustomPage;
  C: TJvCustomPageList;
  Hook: TPropertyEditorHook = nil;
begin
  if not GetHook(Hook) then
    Exit;
  C := GetPageControl;
  P := C.GetPageClass.Create(C.Owner);
  try
    P.Parent := C;
    P.Name := GetDesigner.CreateUniqueComponentName(C.GetPageClass.ClassName);
    P.PageList := C;
    C.ActivePage := P;
    Hook.PersistentAdded(P, True);
    GlobalDesignHook.SelectOnlyThis(P);
    Modified;
  except
    P.Free;
    raise;
  end;
end;

procedure TJvCustomPageEditor.NextPage;
begin
  GetPageControl.NextPage;
end;

procedure TJvCustomPageEditor.PrevPage;
begin
  GetPageControl.PrevPage;
end;

procedure TJvCustomPageEditor.RemovePage;
var
  AList: TJvCustomPageList;
  APage: TJvCustomPage;
  APers: TPersistent;
  Hook: TPropertyEditorHook;
begin
  AList := GetPageControl;
  if (AList <> nil) and (AList.ActivePage <> nil) then
  begin
    APage := AList.ActivePage;
    APage.PageList := nil;
    //APage.Free;
    //Designer.Modified;
    APers := TPersistent(APage);
    if GetHook(Hook) then
      Hook.DeletePersistent(APers);
  end;
end;

//=== { TJvActivePageProperty } ==============================================

function TJvActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TJvActivePageProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Component: TComponent;
begin
  if (GlobalDesignHook <> nil) and (GlobalDesignHook.LookupRoot <> nil) and
    (GlobalDesignHook.LookupRoot is TComponent) then
    for I := 0 to TComponent(GlobalDesignHook.LookupRoot).ComponentCount - 1 do
    begin
      Component := TComponent(GlobalDesignHook.LookupRoot).Components[I];
      if (Component.Name <> '') and (Component is TJvCustomPage) and
        (TJvCustomPage(Component).PageList = GetComponent(0)) then
        Proc(Component.Name);
    end;
end;

//=== { TJvSettingsTreeImagesProperty } ======================================

function TJvSettingsTreeImagesProperty.GetImageList: TCustomImageList;
var
  T: TJvCustomPageListTreeView;
begin
  if (GetComponent(0) is TJvSettingsTreeImages) and
    (TJvSettingsTreeImages(GetComponent(0)).TreeView <> nil) then
  begin
    T := TJvSettingsTreeImages(GetComponent(0)).TreeView;
    Result := THackTreeView(T).Images;
  end
  else
    Result := nil;
end;

//=== { TJvShowDesignCaptionProperty } =======================================

function TJvShowDesignCaptionProperty.GetAttributes: TPropertyAttributes;
begin
  // we don't want sorting for this property
  Result := [paMultiSelect, paValueList, paRevertable];
end;

end.
