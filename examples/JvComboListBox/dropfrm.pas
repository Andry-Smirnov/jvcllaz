{******************************************************************

                       JEDI-VCL Demo

 Copyright (C) 2002 Project JEDI

 Original author:

 Contributor(s):

 You may retrieve the latest version of this file at the JEDI-JVCL
 home page, located at http://jvcl.delphi-jedi.org

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may
 not use this file except in compliance with the License. You may
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit DropFrm;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, //LMessages, Types,
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ShellCtrls;

type
  TDropFrmAcceptEvent = procedure(Sender: TObject; Index: integer; const Value: string) of object;

  { TfrmDrop }

  TfrmDrop = class(TForm)
    Label1: TLabel;
    btnCancel: TButton;
    tvFolders: TShellTreeView;
    ilSmallIcons: TImageList;
    btnOK: TButton;
    PathLabel: TLabel;
    procedure tvFoldersDblClick(Sender: TObject);
    procedure tvFoldersGetImageIndex(Sender: TObject; Node: TTreeNode);
    {
    procedure tvFolders_1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
      }
    procedure FormClose(Sender: TObject; var TheAction: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvFoldersChange(Sender: TObject; Node: TTreeNode);
    procedure tvFoldersGetSelectedIndex(Sender: TObject; Node: TTreeNode);
  private
    FOnAccept: TDropFrmAcceptEvent;
    FIncludeFiles: boolean;
    procedure SetIncludeFiles(AValue: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure WMActivate(var Message: TLMActivate); message LM_ACTIVATE;
  public
    property IncludeFiles: boolean read FIncludeFiles write SetIncludeFiles;
    property OnAccept: TDropFrmAcceptEvent read FOnAccept write FOnAccept;

  end;

var
  frmDrop: TfrmDrop = nil;



implementation

uses
  JvJCLUtils;

{$R *.lfm}


{ TfrmDrop }

procedure TfrmDrop.btnCancelClick(Sender: TObject);
begin
  if not (fsModal in FormState) then
    Close;
end;

procedure TfrmDrop.btnOKClick(Sender: TObject);
begin
  if not (fsModal in FormState) then
    Close;
end;

procedure TfrmDrop.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if BorderStyle = bsDialog then
    Params.Style := Params.Style and not WS_BORDER;
end;

procedure TfrmDrop.FormClose(Sender: TObject; var TheAction: TCloseAction);
begin
  if (ModalResult = mrOK) and Assigned(FOnAccept) then
    FOnAccept(self, -1, (tvFolders.Selected as TShellTreeNode).FullFilename);
end;

procedure TfrmDrop.FormShow(Sender: TObject);
begin
  if tvFolders.CanFocus then tvFolders.SetFocus;
end;

procedure TfrmDrop.SetIncludeFiles(AValue: Boolean);
begin
  if AValue then
    tvFolders.ObjectTypes := tvFolders.ObjectTypes + [otNonFolders]
  else
    tvFolders.ObjectTypes := tvFolders.ObjectTypes - [otNonFolders];
end;

procedure TfrmDrop.tvFoldersChange(Sender: TObject; Node: TTreeNode);
begin
  PathLabel.Caption := MinimizeFileName((Node as TShellTreeNode).FullFileName, Canvas, PathLabel.Width);
end;

procedure TfrmDrop.tvFoldersDblClick(Sender: TObject);
begin
  if (tvFolders.Selected <> nil) and (not tvFolders.Selected.HasChildren) then
    btnOK.Click;
end;

procedure TfrmDrop.tvFoldersGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if not (Node as TShellTreeNode).IsDirectory then
    Node.ImageIndex := -1
  else
  if Node = tvFolders.Selected then
    Node.ImageIndex := 1
  else
    Node.ImageIndex := 0;
end;

procedure TfrmDrop.tvFoldersGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if not (Node as TShellTreeNode).IsDirectory then
    Node.SelectedIndex := -1
  else
  if Node = tvFolders.Selected then
    Node.SelectedIndex := 1
  else
    Node.SelectedIndex := 0;
end;

end.
