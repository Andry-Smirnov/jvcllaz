{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvFullColorListFrm.pas, released on 2004-09-27.

The Initial Developer of the Original Code is Florent Ouchet [ouchet dott florent att laposte dott net]
Portions created by Florent Ouchet are Copyright (C) 2004 Florent Ouchet.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvFullColorListForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons, ImgList,
  JvFullColorSpaces, JvFullColorDialogs, JvFullColorCtrls;

type

  { TJvFullColorListFrm }

  TJvFullColorListFrm = class(TForm)
    ImageList: TImageList;
    JvFullColorDialog: TJvFullColorDialog;
    ListBoxColors: TListBox;
    ActionList: TActionList;
    ActionNew: TAction;
    ActionModify: TAction;
    ActionDelete: TAction;
    ButtonNew: TButton;
    ButtonModify: TButton;
    ButtonDelete: TButton;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    BitBtnMoveUp: TBitBtn;
    ActionMoveUp: TAction;
    ActionMoveDown: TAction;
    BitBtnMoveDown: TBitBtn;
    ButtonApply: TButton;
    ButtonClear: TButton;
    ActionClear: TAction;
    ButtonInsert: TButton;
    ActionInsert: TAction;
    procedure ActionNewUpdate(Sender: TObject);
    procedure ActionModifyUpdate(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionMoveUpUpdate(Sender: TObject);
    procedure ActionMoveDownUpdate(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure ActionClearUpdate(Sender: TObject);
    procedure ActionModifyExecute(Sender: TObject);
    procedure ActionInsertUpdate(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionInsertExecute(Sender: TObject);
    procedure ActionMoveUpExecute(Sender: TObject);
    procedure ActionMoveDownExecute(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JvFullColorDialogApply(Sender: TObject;
      AFullColor: TJvFullColor);
    procedure ListBoxColorsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    FColorList: TJvFullColorList;
    FOnApply: TNotifyEvent;
    procedure SetColorList(const Value: TJvFullColorList);
    function GetColorList: TJvFullColorList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property ColorList: TJvFullColorList read GetColorList write SetColorList;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
  end;

var
  JvFullColorListFrm: TJvFullColorListFrm;

implementation

uses
  Math, LCLType, LCLIntf, LCLVersion,
  JvDsgnConsts;

{$R *.lfm}

constructor TJvFullColorListFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorList := TJvFullColorList.Create;
end;

destructor TJvFullColorListFrm.Destroy;
begin
  FColorList.Free;
  inherited Destroy;
end;

procedure TJvFullColorListFrm.ActionClearExecute(Sender: TObject);
begin
  ListBoxColors.Clear;
end;

procedure TJvFullColorListFrm.ActionClearUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := ListBoxColors.Items.Count > 0;
end;

procedure TJvFullColorListFrm.ActionDeleteExecute(Sender: TObject);
begin
  ListBoxColors.DeleteSelected;
end;

procedure TJvFullColorListFrm.ActionDeleteUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := ListBoxColors.SelCount >= 1;
end;

procedure TJvFullColorListFrm.ActionInsertExecute(Sender: TObject);
begin
  JvFullColorDialog.Options := JvFullColorDialog.Options - [foShowApply];
  if JvFullColorDialog.Execute then
    ListBoxColors.Items.InsertObject(ListBoxColors.ItemIndex, '',
      TObject(PtrInt(JvFullColorDialog.FullColor)));
end;

procedure TJvFullColorListFrm.ActionInsertUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := ListBoxColors.SelCount = 1;
end;

procedure TJvFullColorListFrm.ActionModifyExecute(Sender: TObject);
begin
  JvFullColorDialog.Options := JvFullColorDialog.Options + [foShowApply];
  JvFullColorDialog.FullColor := TJvFullColor(PtrInt(ListBoxColors.Items.Objects[ListBoxColors.ItemIndex]));
  if JvFullColorDialog.Execute then
    ListBoxColors.Items.Objects[ListBoxColors.ItemIndex] := TObject(PtrInt(JvFullColorDialog.FullColor));
end;

procedure TJvFullColorListFrm.ActionModifyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := ListBoxColors.SelCount = 1;
end;

procedure TJvFullColorListFrm.ActionMoveDownExecute(Sender: TObject);
var
  OldIndex: Integer;
begin
  with ListBoxColors do
  begin
    OldIndex := ItemIndex;
    Items.Move(ItemIndex, ItemIndex + 1);
    Selected[OldIndex + 1] := True;
  end;
end;

procedure TJvFullColorListFrm.ActionMoveDownUpdate(Sender: TObject);
begin
  with ListBoxColors do
    (Sender as TAction).Enabled := (SelCount = 1) and (ItemIndex < (Items.Count - 1));
end;

procedure TJvFullColorListFrm.ActionMoveUpExecute(Sender: TObject);
var
  OldIndex: Integer;
begin
  with ListBoxColors do
  begin
    OldIndex := ItemIndex;
    Items.Move(ItemIndex, ItemIndex - 1);
    Selected[OldIndex - 1] := True;
  end;
end;

procedure TJvFullColorListFrm.ActionMoveUpUpdate(Sender: TObject);
begin
  with ListBoxColors do
    (Sender as TAction).Enabled := (SelCount = 1) and (ItemIndex > 0);
end;

procedure TJvFullColorListFrm.ActionNewExecute(Sender: TObject);
begin
  JvFullColorDialog.Options := JvFullColorDialog.Options - [foShowApply];
  if JvFullColorDialog.Execute then begin
    ListBoxColors.Items.AddObject('', TObject(PtrInt(JvFullColorDialog.FullColor)));
    ListBoxColors.ItemIndex := ListBoxColors.Items.Count-1;
  end;
end;

procedure TJvFullColorListFrm.ActionNewUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

function TJvFullColorListFrm.Execute: Boolean;
begin
  Result := (ShowModal = mrOK);
end;

procedure TJvFullColorListFrm.FormCreate(Sender: TObject);
begin
  BitBtnMoveUp.Width := BitBtnMoveUp.Height;
  BitBtnMoveDown.Width := BitBtnMoveDown.Height;
  {$IF LCL_FullVersion >= 2000000}
  BitBtnMoveUp.Images := ImageList;
  BitBtnMoveUp.ImageIndex := 0;
  BitBtnMoveDown.Images := ImageList;
  BitBtnMoveDown.ImageIndex := 1;
  {$ELSE}
  ImageList.GetBitmap(0, BitBtnMoveUp.Glyph);
  ImageList.GetBitmap(1, BitBtnMoveDown.Glyph);
  {$IFEND}
end;

procedure TJvFullColorListFrm.FormShow(Sender: TObject);
var
  i, w: Integer;
  s: string;
begin
  w := 0;
  ListBoxColors.Canvas.Font.Assign(ListboxColors.Font);
  for i := 0 to ColorSpaceManager.Count-1 do begin;
    with ColorSpaceManager.ColorSpaceByIndex[i] do
      if ID <> csDEF then begin
        s := Format('%s: %s = $FF; %s = $FF; %s = $FF',
          [ Name, AxisName[axIndex0], AxisName[axIndex1], AxisName[axIndex2] ]);
        w := Max(w, ListBoxColors.Canvas.TextWidth(s));
      end;
  end;
  ListBoxColors.ClientWidth := w + ListBoxColors.ItemHeight + GetSystemMetrics(SM_CXVSCROLL) + 8;
end;

function TJvFullColorListFrm.GetColorList: TJvFullColorList;
var
  Index: Integer;
begin
  FColorList.BeginUpdate;
  FColorList.Clear;
  for Index := 0 to ListBoxColors.Items.Count - 1 do
    FColorList.Add(TJvFullColor(PtrInt(ListBoxColors.Items.Objects[Index])));
  FColorList.EndUpdate;
  Result := FColorList;
end;

procedure TJvFullColorListFrm.SetColorList(const Value: TJvFullColorList);
var
  I: Integer;
begin                                                    
  with ListBoxColors.Items, ColorSpaceManager do
  begin
    BeginUpdate;
    for I := 0 to Value.Count - 1 do
      AddObject('', TObject(PtrInt(Value.Items[I])));
    EndUpdate;
  end;
end;

procedure TJvFullColorListFrm.ButtonApplyClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
    FOnApply(Self);
end;

procedure TJvFullColorListFrm.JvFullColorDialogApply(Sender: TObject;
  AFullColor: TJvFullColor);
begin
  ListBoxColors.Items.Objects[ListBoxColors.ItemIndex] := TObject(PtrInt(JvFullColorDialog.FullColor));
end;

procedure TJvFullColorListFrm.ListBoxColorsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  AFullColor: TJvFullColor;
  AText: string;
  ColorIndex: Integer;
  AColor: TColor;
  AColorSpace: TJvColorSpace;
begin
  with TListBox(Control), Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := Brush.Color;
    Brush.Style := bsSolid;

    Rectangle(Rect);

    AFullColor := TJvFullColor(PtrInt(Items.Objects[Index]));

    with ColorSpaceManager do
    begin
      AColorSpace := ColorSpace[GetColorSpaceID(AFullColor)];

      if AColorSpace.ID = csDEF then
        with TJvDEFColorSpace(AColorSpace) do
        begin
          AColor := ConvertToColor(AFullColor);
          AText := Format(RsUnnamedColorFmt, [Name, AFullColor]);
          for ColorIndex := 0 to ColorCount - 1 do
            if AColor = ColorValue[ColorIndex] then
            begin
              AText := Format(RsUnnamedColorFmt, [Name, ColorName[ColorIndex], ColorPrettyName[ColorIndex]]);
              Break;
            end;
        end
      else
        with AColorSpace do
          AText := Format('%s: %s = $%.2x; %s = $%.2x; %s = $%.2x',
            [Name,
             AxisName[axIndex0], GetAxisValue(AFullColor, axIndex0),
             AxisName[axIndex1], GetAxisValue(AFullColor, axIndex1),
             AxisName[axIndex2], GetAxisValue(AFullColor, axIndex2)]);

      TextOut(Rect.Left + Rect.Bottom - Rect.Top + 2, Rect.Top + 2, AText);
    end;

    Brush.Color := ColorSpaceManager.ConvertToColor(AFullColor);
    Pen.Color := clBlack;
    Rectangle(Rect.Left + 2, Rect.Top + 2, Rect.Left + Rect.Bottom - Rect.Top - 2, Rect.Bottom - 2);
  end;
end;

end.
