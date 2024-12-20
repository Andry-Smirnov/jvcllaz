{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvID3v2Define.PAS, released on 2003-04-16.

The Initial Developer of the Original Code is Remko Bonte [remkobonte att myrealbox dott com]
Portions created by Remko Bonte are Copyright (C) 2003 Remko Bonte.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvId3v2DefineForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  //DesignEditors, DesignIntf, DesignMenus, DesignWindows,
  JvId3v2Base, JvId3v2Types;

type

  { TJvID3DefineDlg }

  TJvID3DefineDlg = class(TForm)  //TJvForm)
    lblFrames: TLabel;
    cmbFrames: TComboBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    //FDesigner: TJvID3ControllerDesigner; //IDesigner;
    FController: TJvID3Controller;
    FFSDesigner: TJvID3ControllerDesigner;
    FFrame: TJvID3Frame;
    procedure SetController(const Value: TJvID3Controller);
    function GetFrameClass: TJvID3FrameClass;
    function GetFrameID: TJvID3FrameID;
    function GetFrameIDStr: AnsiString;
  protected
    procedure FillFrames(const Strings: TStrings);
  public
    property FrameClass: TJvID3FrameClass read GetFrameClass;
    property FrameID: TJvID3FrameID read GetFrameID;
    property FrameIDStr: AnsiString read GetFrameIDStr;
    property Frame: TJvID3Frame read FFrame;
    property Controller: TJvID3Controller read FController write SetController;
//    property Designer: IDesigner read FDesigner write FDesigner;
    property FSDesigner: TJvID3ControllerDesigner read FFSDesigner write FFSDesigner;
  end;

implementation

{$R *.lfm}

uses
  JvID3v2EditorForm;

procedure TJvID3DefineDlg.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrNone;
  FSDesigner.BeginDesign;
  try
    FFrame := Controller.AddFrame(FrameID);
  finally
    FSDesigner.EndDesign;
  end;
  ModalResult := mrOk;
end;

procedure TJvID3DefineDlg.FormShow(Sender: TObject);
begin
  ClientHeight := CancelBtn.Top + CancelBtn.Height + 8;
end;

procedure TJvID3DefineDlg.FillFrames(const Strings: TStrings);
var
  lFrameID: TJvID3FrameID;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    for lFrameID := Low(TJvID3FrameID) to High(TJvID3FrameID) do
      if Controller.CanAddFrame(lFrameID) then
        Strings.AddObject(
          Format('%s - %s',
            [ID3_FrameIDToString(lFrameID), TFSDesigner(FSDesigner).FrameDescription[lFrameID]]),
          TObject(PtrInt(lFrameID)));
  finally
    Strings.EndUpdate;
  end;
end;

procedure TJvID3DefineDlg.SetController(const Value: TJvID3Controller);
begin
  FController := Value;
  FillFrames(cmbFrames.Items);
end;

type
  TControllerAccess = class(TJvID3Controller);

function TJvID3DefineDlg.GetFrameClass: TJvID3FrameClass;
begin
  Result := TControllerAccess(Controller).GetFrameClass(FrameID);
  if Result = nil then
    Result := TJvID3SkipFrame;
end;

function TJvID3DefineDlg.GetFrameID: TJvID3FrameID;
begin
  with cmbFrames do
    if ItemIndex >= 0 then
      Result := TJvID3FrameID(PtrInt(Items.Objects[ItemIndex]))
    else
      Result := fiUnknownFrame;
end;

function TJvID3DefineDlg.GetFrameIDStr: AnsiString;
begin
  Result := ID3_FrameIDToString(FrameID);
end;

end.
