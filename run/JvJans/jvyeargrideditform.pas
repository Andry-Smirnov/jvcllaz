{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvYearGridEdit.PAS, released on 2002-06-15.

The Initial Developer of the Original Code is Jan Verhoeven [jan1 dott verhoeven att wxs dott nl]
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): Robert Love [rlove att slcdug dott org].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvYearGridEditForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ColorBox;

type

  { TYearGridEditForm }

  TYearGridEditForm = class(TForm) //JvForm)
    ColorBox: TColorBox;
    LblColor: TLabel;
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BitCancel: TBitBtn;
    MemoText: TMemo;
    BtnLoad: TButton;
    BtnSave: TButton;
    OpenDialog: TOpenDialog;
    Panel2: TPanel;
    SaveDialog: TSaveDialog;
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
  end;


implementation

{$R *.lfm}

const
  DEFAULT_COLOR = 206 + 250 shl 8 + 253 shl 16;

procedure TYearGridEditForm.BtnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    MemoText.Lines.LoadFromFile(OpenDialog.FileName);
  MemoText.SetFocus;
end;

procedure TYearGridEditForm.BtnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    MemoText.Lines.SaveToFile(SaveDialog.FileName);
  MemoText.SetFocus;
end;

procedure TYearGridEditForm.FormCreate(Sender: TObject);
begin
  ColorBox.DefaultColorColor := DEFAULT_COLOR;
  ColorBox.Selected := DEFAULT_COLOR;
end;

procedure TYearGridEditForm.FormShow(Sender: TObject);
begin
  MemoText.SetFocus;
end;

end.

