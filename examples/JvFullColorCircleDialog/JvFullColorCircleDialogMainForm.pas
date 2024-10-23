{******************************************************************

                       JEDI-VCL Demo

 Copyright (C) 2004 Project JEDI

 Original author: Florent Ouchet [ouchet dott florent att laposte dott net]

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

unit JvFullColorCircleDialogMainForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Types, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvFullColorSpaces, JvFullColorCircleForm,
  JvFullColorDialogs, JvFullColorRotate;

type

  { TJvFullColorCircleDlgMainFrm }

  TJvFullColorCircleDlgMainFrm = class(TForm)
    Image: TImage;
    Bevel: TBevel;
    Label1: TLabel;
    LabelImage: TLabel;
    cmbFileName: TComboBox;
    JvFullColorCircleDialog: TJvFullColorCircleDialog;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbFileNameSelect(Sender: TObject);
    procedure JvFullColorCircleDialogApply(Sender: TObject);
  private
    procedure FormatLabel(ALabel: TLabel; const Delta: TJvColorDelta);
    function MeasureLabels: TSize;
  public
    Images: array [0..6] of TImage;
    Memos: array [0..6] of TMemo;
    Labels: array[0..6] of TLabel;
    procedure CustomizeDblClick(Sender: TObject);
    procedure RotateCustomValues;
//    procedure FormatMemo(AMemo: TMemo; const Delta: TJvColorDelta);
  end;

var
  JvFullColorCircleDlgMainFrm: TJvFullColorCircleDlgMainFrm;

implementation

{$R *.lfm}

uses
  LCLIntf, LCLType, Math, Contnrs;

resourcestring
  RsCustomize = 'Dbl-click to customize';

var
  ImgDir: String = '';

type
  TJvColorDeltaList = class (TObjectList)
  private
    function GetItems(Index: Integer): TJvColorDelta;
    procedure SetItems(Index: Integer; const Value: TJvColorDelta);
  public
    property Items[Index: Integer]: TJvColorDelta read GetItems write SetItems; default;
  end;

var
  ColorDeltas: TJvColorDeltaList;

procedure TJvFullColorCircleDlgMainFrm.FormCreate(Sender: TObject);
var
  LSearchRec: TSearchRec;
begin
  ImgDir := IncludeTrailingPathDelimiter(GetCurrentDir) + '../../design/JvCtrls/images/';
  if FindFirst(ImgDir + '*.png', faAnyFile, LSearchRec) = 0 then
    repeat
      cmbFileName.Items.Add(LSearchRec.Name);
    until FindNext(LSearchRec) <> 0;
  FindClose(LSearchRec);
end;

function TJvFullColorCircleDlgMainFrm.MeasureLabels: TSize;
var
  i, j: Integer;
  axIndex: TJvAxisIndex;
  ColorSpc: TJvColorSpace;
  L: TStrings;
  s: String;
  bmp: TBitmap;
  R: TRect;
begin
  Result := Size(0, 0);
  ColorSpc := ColorSpaceManager.ColorSpace[csCMY];
  L := TStringList.Create;
  try
    L.Add(Format('%s (%s)',[ColorSpc.Name, ColorSpc.ShortName]));
    for axIndex := Low(TJvAxisIndex) to High(TJvAxisIndex) do
      L.Add(Format('%s : %d, %d, %d',[ColorSpc.AxisName[axIndex], 255, 255, 255]));
    s := L.Text;
  finally
    L.Free;
  end;

  bmp := TBitmap.Create;
  try
    bmp.SetSize(1, 1);
    bmp.Canvas.Brush.Color := clWhite;
    bmp.Canvas.FillRect(0, 0, 1, 1);
    bmp.Canvas.Font.Assign(Label1.Font);
    R := Rect(0, 0, MaxInt, MaxInt);
    DrawText(bmp.Canvas.Handle, PChar(s), Length(s), R, DT_WORDBREAK or DT_CALCRECT or DT_NOCLIP);
    Result.CX := Max(Result.CX, R.Right);
    Result.CY := Max(Result.CY, R.Bottom);
  finally
    bmp.Free;
  end;
end;

procedure TJvFullColorCircleDlgMainFrm.FormActivate(Sender: TObject);
var
  X, Y: Integer;
  PitchX, PitchY: Integer;
  LabelSize: TSize;
  Index: Integer;
  lBevel: TBevel;
  lImage: TImage;
  lLabel: TLabel;
  h: Integer;
begin
  LabelSize := MeasureLabels;
  h := Label1.Canvas.Textheight('Tg');
  PitchX := LabelSize.CX + 32;
  PitchY := LabelSize.CY + Bevel.Height + 16;

  Label1.Left := 8;
  Label1.Width := LabelSize.CX;
  Bevel.Left := Label1.Left + (Label1.Width - Bevel.Width) div 2;

  Index := 0;
  for Y := 0 to 1 do
    for X := 0 to 3 do
      if (X <> 0) or (Y <> 0) then
      begin
        lBevel := TBevel.Create(Self);
        lBevel.Parent := Self;
        lBevel.Style := bsRaised;
        lBevel.SetBounds(Bevel.Left + X*PitchX, Bevel.Top + Y*PitchY, Bevel.Width, Bevel.Height);

        lImage := TImage.Create(Self);
        lImage.Parent := Self;
        lImage.Stretch := false;
        lImage.Center := true;
        lImage.SetBounds(Image.Left + X*PitchX, Image.Top + Y*PitchY, Image.Width, Image.Height);

        lLabel := TLabel.Create(Self);
        lLabel.Parent := Self;
        lLabel.AutoSize := false;
        lLabel.WordWrap := true;
        lLabel.Alignment := taCenter;
//        lLabel.SetBounds(Label1.Left + X*PitchX, Label1.Top + Y*PitchY, LabelSize.CX, LabelSize.CY);
        lLabel.Left := Label1.Left + X*PitchX;
        lLabel.Top := Label1.Top + Y*PitchY;
        lLabel.Width := LabelSize.CX;
        lLabel.Height := LabelSize.CY + Y*h;

        if (X = 3) and (Y = 1) then begin
          lImage.OnDblClick := @CustomizeDblClick;
          lLabel.OnDblClick := @CustomizeDblClick;
          ClientWidth := lBevel.Left + lBevel.Width + Bevel.Left;
          ClientHeight := lLabel.Top + lLabel.Height + cmbFileName.Top;
        end;

        Images[Index] := lImage;
        Labels[Index] := lLabel;
        Inc(Index);
      end;

  cmbFileName.ItemIndex := 0;
  cmbFileNameSelect(cmbFileName);
end;

(*
var
  X, Y: Integer;
  PitchX, PitchY: Integer;
  LImage: TImage;
  LMemo: TMemo;
  LBevel: TBevel;
  Index: Integer;
begin
  PitchX := Memo.Width + 32;
  PitchY := Memo.Top + Memo.Height - Image.Top + 31;
  Index := 0;
  for X := 0 to 3 do
    for Y := 0 to 1 do
      if (X <> 0) or (Y <> 0) then
      begin
        LBevel := TBevel.Create(Self);
        LBevel.Parent := Self;
        LBevel.Style := bsRaised;
        LBevel.SetBounds(Bevel.Left+X*PitchX, Bevel.Top+Y*PitchY, Bevel.Width, Bevel.Height);

        LImage := TImage.Create(Self);
        LImage.Parent := Self;
        LImage.Stretch := False;
        LImage.Center := true;
        LImage.SetBounds(Image.Left+X*PitchX, Image.Top+Y*PitchY, Image.Width, Image.Height);

        LMemo := TMemo.Create(Self);
        LMemo.Parent := Self;
        LMemo.BorderStyle := bsNone;
        LMemo.ParentColor := True;
        LMemo.OnKeyDown := @MemoKeyDown;
        LMemo.OnKeyPress := @MemoKeyPress;
        LMemo.SetBounds(Memo.Left+X*PitchX, Memo.Top+Y*PitchY, Memo.Width, Memo.Height);
        LMemo.Alignment := taCenter;

        if (X = 3) and (Y = 1) then
        begin
          LImage.OnDblClick := @CustomizeDblClick;
          LMemo.OnDblClick := @CustomizeDblClick;
          ClientWidth := LMemo.Left+LMemo.Width-1+Memo.Left;
          ClientHeight := LMemo.Top+LMemo.Height-1+cmbFileName.Top;
        end;

        Memos[Index] := LMemo;
        Images[Index] := LImage;
        Inc(Index);
      end;
  cmbFileName.ItemIndex := 0;
  ComboBoxFileNameSelect(cmbFileName);
end;       *)

procedure TJvFullColorCircleDlgMainFrm.CustomizeDblClick(Sender: TObject);
begin
  if JvFullColorCircleDialog.Execute then
    RotateCustomValues;
end;

procedure TJvFullColorCircleDlgMainFrm.cmbFileNameSelect(Sender: TObject);
var
  Index: Integer;
  fn: String;
begin
  if cmbFileName.ItemIndex = -1 then
    exit;

  if Image.Picture.Bitmap <> nil then begin
    fn := ImgDir + cmbFileName.Items[cmbFileName.ItemIndex];
    if FileExists(fn) then
      Image.Picture.LoadFromFile(fn)
    else
      MessageDlg(Format('File "%s" not found.', [fn]), mtError, [mbOK], 0);
  end;

  //  Image.Picture.Bitmap := TBitmap.Create;
//  Image.Picture.Bitmap.LoadFromFile(cmbFileName.Items[cmbFileName.ItemIndex]);

  Labels[6].Caption := RsCustomize;

  {
  with Memos[6].Lines do
  begin
    Clear;
    Add(RsCustomize);
  end;
  }
  Images[6].Picture.Bitmap.FreeImage;
  for Index := Low(Images) to High(Images)-1 do
  begin
    Images[Index].Picture.Bitmap.FreeImage;
    RotateBitmap(Image.Picture.Bitmap,Images[Index].Picture.Bitmap,ColorDeltas[Index]);
    FormatLabel(Labels[Index], ColorDeltas[Index]);
//    FormatMemo(Memos[Index], ColorDeltas[Index]);
  end;
  RotateCustomValues;
end;

procedure TJvFullColorCircleDlgMainFrm.RotateCustomValues;
begin
  RotateBitmap(Image.Picture.Bitmap,Images[6].Picture.Bitmap,JvFullColorCircleDialog.Delta);
  FormatLabel(Labels[6], JvFullColorCircleDialog.Delta);
//  FormatMemo(Memos[6],JvFullColorCircleDialog.Delta);
end;

procedure TJvFullColorCircleDlgMainFrm.FormatLabel(ALabel: TLabel;
  const Delta: TJvColorDelta);
var
  Index: TJvAxisIndex;
  L: TStringList;
begin
  L := TStringList.Create;
  try
    with ColorSpaceManager, ColorSpace[Delta.ColorID] do begin
      L.Add(Format('%s (%s)', [Name, ShortName]));
      for Index := Low(TJvAxisIndex) to High(TJvAxisIndex) do
        L.Add(Format('%s: %d, %d, %d', [
          AxisName[Index],
          Delta.AxisRed[Index].Value,
          Delta.AxisGreen[Index].Value,
          Delta.AxisBlue[Index].Value
        ]));
      if ALabel = Labels[6] then
        L.Add(RsCustomize);
    end;
    ALabel.Caption := L.Text;
  finally
    L.Free;
  end;
end;

    (*
procedure TJvFullColorCircleDlgMainFrm.FormatMemo(AMemo: TMemo; const Delta: TJvColorDelta);
var
  Index: TJvAxisIndex;
begin
  AMemo.Lines.Clear;
  with ColorSpaceManager, ColorSpace[Delta.ColorID], AMemo.Lines do
  begin
    Add(Format('%s (%s)',[Name, ShortName]));
    for Index := Low(TJvAxisIndex) to High(TJvAxisIndex) do
      Add(Format('%s : %d, %d, %d',[AxisName[Index],Delta.AxisRed[Index].Value,
                 Delta.AxisGreen[Index].Value,Delta.AxisBlue[Index].Value]));
    if AMemo = Memos[6] then
      Add(RsCustomize);
  end;
end;    *)


{ TJvColorDeltaList }

function TJvColorDeltaList.GetItems(Index: Integer): TJvColorDelta;
begin
  Result := TJvColorDelta(TObjectList(Self).Items[Index]);
end;

procedure TJvColorDeltaList.SetItems(Index: Integer;
  const Value: TJvColorDelta);
begin
  TObjectList(Self).Items[Index] := Value;
end;

procedure FillColorDeltas;
var
  Delta : TJvColorDelta;
begin
  Delta := TJvColorDelta.Create;
  Delta.ColorID := csRGB;
  Delta.AxisRed[axIndex0].Value := 100;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := 0;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := 0;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 0;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := 0;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 0;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := 0;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 50;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);

  Delta := TJvColorDelta.Create;
  Delta.ColorID := csHLS;
  Delta.AxisRed[axIndex0].Value := 0;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := 0;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := 0;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 40;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := 0;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 0;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := 0;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 0;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);

  Delta := TJvColorDelta.Create;
  Delta.ColorID := csHSV;
  Delta.AxisRed[axIndex0].Value := 0;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := -176;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := -180;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 0;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := 0;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 0;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := 0;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 0;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);

  Delta := TJvColorDelta.Create;
  Delta.ColorID := csYUV;
  Delta.AxisRed[axIndex0].Value := 0;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := 38;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := 0;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 0;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := 68;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 0;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := 0;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 0;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);

  Delta := TJvColorDelta.Create;
  Delta.ColorID := csHLS;
  Delta.AxisRed[axIndex0].Value := 0;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := -30;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := 0;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 0;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := -30;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 0;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := -30;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 0;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);

  Delta := TJvColorDelta.Create;
  Delta.ColorID := csXYZ;
  Delta.AxisRed[axIndex0].Value := 0;
  Delta.AxisRed[axIndex0].SaturationMethod := smRange;
  Delta.AxisRed[axIndex1].Value := 0;
  Delta.AxisRed[axIndex1].SaturationMethod := smRange;
  Delta.AxisRed[axIndex2].Value := 0;
  Delta.AxisRed[axIndex2].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex0].Value := 0;
  Delta.AxisGreen[axIndex0].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex1].Value := 0;
  Delta.AxisGreen[axIndex1].SaturationMethod := smRange;
  Delta.AxisGreen[axIndex2].Value := 0;
  Delta.AxisGreen[axIndex2].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex0].Value := 80;
  Delta.AxisBlue[axIndex0].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex1].Value := 0;
  Delta.AxisBlue[axIndex1].SaturationMethod := smRange;
  Delta.AxisBlue[axIndex2].Value := 0;
  Delta.AxisBlue[axIndex2].SaturationMethod := smRange;
  ColorDeltas.Add(Delta);
end;

procedure TJvFullColorCircleDlgMainFrm.JvFullColorCircleDialogApply(Sender: TObject);
begin
  RotateCustomValues;
end;

initialization
  ColorDeltas := TJvColorDeltaList.Create;
  FillColorDeltas;

finalization
  ColorDeltas.Free;

end.
