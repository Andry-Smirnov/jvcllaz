{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvGammaPanel.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse att buypin dott com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Modifications:
  2/11/2000 Added the Align and AutoSize property (Request of Brad T.)
  2004/01/06 VisualCLX compatibilty

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvGammaPanel;

{$MODE OBJFPC}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Dialogs, ExtCtrls, StdCtrls,
  JvTypes;
  
type
  TJvGammaPanel = class(TWinControl)
  private
    FPanel1: TPanel;
    FPanel2: TPanel;
    FPanel3: TPanel;
    FPanel4: TPanel;
    FGamma: TImage;
    FForegroundColorImg: TShape;
    FBackgroundColorImg: TShape;
    FChosen: TShape;
    FXLabel: TLabel;
    FRLabel: TLabel;
    FGLabel: TLabel;
    FBLabel: TLabel;
    FLastColor: TColor;
    FOnChangeColor: TJvChangeColorEvent;
    procedure BgColorClick(Sender: TObject);
    procedure ChangeColor(Sender: TObject; Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure ColorSeek(Sender: TObject; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure Exchange(Sender: TObject);
    procedure FgColorClick(Sender: TObject);
    function GetBackgroundColor: TColor;
    function GetForegroundColor: TColor;
    function IsHeightStored: Boolean;
    function IsWidthStored: Boolean;
    procedure SetBackgroundColor(const AValue: TColor);
    procedure SetForegroundColor(const AValue: TColor);
  protected
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
    procedure DoChangeColor(AForegroundColor, ABackgroundColor: TColor); virtual;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property Height stored IsHeightStored;
    property Width stored IsWidthStored;
    property ForegroundColor: TColor read GetForegroundColor write SetForegroundColor default clBlack;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor default clWhite;
    property OnChangeColor: TJvChangeColorEvent read FOnChangeColor write FOnChangeColor;
  end;
  
implementation

uses
  LCLIntf,
  JvResources;

{$R ../../resource/jvgammapanel.res}

const
  DEFAULT_WIDTH = 65;
  DEFAULT_HEIGHT = 250;

  MARGIN_1 = 5;
  MARGIN_2 = 2;
  IMG_SIZE = 30;

constructor TJvGammaPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := DEFAULT_WIDTH;   // Scaling of outer dimensions is done automatically
  Height := DEFAULT_HEIGHT;

  FPanel1 := TPanel.Create(Self);
  with FPanel1 do
  begin
    Parent := Self;
    Align := alClient;
    BevelInner := bvLowered;
    BevelOuter := bvRaised;
  end;

  FPanel2 := TPanel.Create(FPanel1);
  with FPanel2 do
  begin
    Parent := FPanel1;
    Align := alClient;
    BorderSpacing.Around := Scale96ToFont(MARGIN_1);  // Scale inner dimensions manually
    BevelInner := bvLowered;
    BevelOuter := bvRaised;
  end;

  FPanel3 := TPanel.Create(FPanel1);
  with FPanel3 do
  begin
    Parent := FPanel1;
    Align := alBottom;
    BorderSpacing.Left := Scale96ToFont(MARGIN_1);
    BorderSpacing.Right := Scale96ToFont(MARGIN_1);
    Height := Scale96ToFont(3*IMG_SIZE div 2 + 2 * MARGIN_2);
    BevelInner := bvLowered;
    BevelOuter := bvRaised;
  end;

  FPanel4 := TPanel.Create(FPanel1);
  with FPanel4 do
  begin
    Parent := FPanel1;
    Align := alBottom;
    BorderSpacing.Around := Scale96ToFont(MARGIN_1);
    BevelInner := bvLowered;
    BevelOuter := bvRaised;
    AutoSize := true;
    Top := self.Height;  // Force to be at very bottom
  end;

  FGamma := TImage.Create(FPanel2);
  with FGamma do
  begin
    Parent := FPanel2;
    Align := alClient;
    Stretch := true;
    OnMouseDown := @ChangeColor;
    OnMouseMove := @ColorSeek;
    Align := alClient;
    Picture.Bitmap.LoadFromResourceName(HInstance, 'JvGammaPanelCOLORS');
    Cursor := crCross;
  end;

  FBackgroundColorImg := TShape.Create(FPanel3);
  with FBackgroundColorImg do
  begin
    Parent := FPanel3;
    Height := Scale96ToFont(IMG_SIZE);
    Width := Height;
    Top := Scale96ToFont(MARGIN_2) + Height div 2;
    Left := Scale96ToFont(MARGIN_2) + Width div 2;
    Brush.Color := clBlack;
    Hint := RsHintBg;
    ShowHint := True;
    OnClick := @BgColorClick;
  end;

  FForegroundColorImg := TShape.Create(FPanel3);
  with FForegroundColorImg do
  begin
    Parent := FPanel3;
    Height := Scale96ToFont(IMG_SIZE);
    Width := Height;
    Left := Scale96ToFont(MARGIN_2);
    Top := Scale96ToFont(MARGIN_2);
    Brush.Color := clWhite;
    Hint := RsHintFg;
    ShowHint := True;
    OnClick := @FgColorClick;
  end;

  FXLabel := TLabel.Create(FPanel3);
  with FXLabel do
  begin
    Parent := FPanel3;
    BorderSpacing.Left := Scale96ToFont(MARGIN_1);
    BorderSpacing.Bottom := 0;
    Alignment := taCenter;
    AutoSize := True;
    Caption := RsXCaption;
    Hint := RsLabelHint;
    OnClick := @Exchange;
    ShowHint := True;
  end;

  FRLabel := TLabel.Create(FPanel4);
  with FRLabel do
  begin
    Parent := FPanel4;
    Align := alTop;
    BorderSpacing.Left := Scale96ToFont(2);
    Caption := RsDefaultR;
    Transparent := True;
  end;

  FGLabel := TLabel.Create(FPanel4);
  with FGLabel do
  begin
    Parent := FPanel4;
    Align := alTop;
    Top := FRLabel.Top + FRLabel.Height;
    BorderSpacing.Left := FRLabel.BorderSpacing.Left;
    Caption := RsDefaultG;
    Transparent := True;
  end;

  FBLabel := TLabel.Create(FPanel4);
  with FBLabel do
  begin
    Parent := FPanel4;
    Align := alTop;
    Top := FGLabel.Top + FGLabel.Height;
    BorderSpacing.Left := FRLabel.BorderSpacing.Left;
    Caption := RsDefaultB;
    Transparent := True;
  end;

  FChosen := TShape.Create(FPanel4);
  with FChosen do
  begin
    Parent := FPanel4;
    Align := alTop;
    Top := FBLabel.Top + FBLabel.Height;
    Height := FBLabel.Height * 2;
    BorderSpacing.Around := Scale96ToFont(MARGIN_1);
    Brush.Color := clBlack;
  end;
end;

procedure TJvGammaPanel.BgColorClick(Sender: TObject);
begin
  with TColorDialog.Create(Self) do
  begin
    if Execute then
      SetBackgroundColor(Color);
    Free;
  end;
end;

procedure TJvGammaPanel.ChangeColor(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FForegroundColorImg.Brush.Color := FLastColor;
    DoChangeColor(FLastColor, FBackgroundColorImg.Brush.Color);
  end else
  if Button = mbRight then
  begin
    FBackgroundColorImg.Brush.Color := FLastColor;
    DoChangeColor(FForegroundColorImg.Brush.Color, FLastColor);
  end;
end;

procedure TJvGammaPanel.ColorSeek(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  col: TColor;
  xbmp, ybmp: Integer;
begin
  if not PtInRect(Bounds(0, 0, FGamma.Width, FGamma.Height), Point(X,Y)) then
    Exit;

  xbmp := round(X * FGamma.Picture.Bitmap.Width / FGamma.Width);
  ybmp := round(Y * FGamma.Picture.Bitmap.Height / FGamma.Height);
  col := FGamma.Picture.Bitmap.Canvas.Pixels[xbmp, ybmp];
  FLastColor := col;
  FRLabel.Caption := Format(RsRedFormat, [GetRValue(col)]);
  FGLabel.Caption := Format(RsGreenFormat, [GetGValue(col)]);
  FBLabel.Caption := Format(RsBlueFormat, [GetBValue(col)]);
  FChosen.Brush.Color := col;
end;

procedure TJvGammaPanel.DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
  const AXProportion, AYProportion: Double);
begin
  inherited;

  FPanel2.BorderSpacing.Around := round(MARGIN_1 * AXProportion);
  FPanel3.BorderSpacing.Left := round(MARGIN_1 * AXProportion);
  FPanel3.BorderSpacing.Right := round(MARGIN_1 * AXProportion);
  FPanel3.Height := round((IMG_SIZE * 3 div 2 + 2 * MARGIN_2) * AYProportion);

  FPanel4.BorderSpacing.Around := round(MARGIN_1 * AXProportion);

  FBackgroundColorImg.Height := round(IMG_SIZE * AYProportion);
  FBackgroundColorImg.Width := round(IMG_SIZE * AXProportion);
  FBackgroundColorImg.Top := round((MARGIN_2 + IMG_SIZE div 2) * AYProportion);
  FBackgroundColorImg.Left := round((MARGIN_2 + IMG_SIZE div 2) * AXProportion);

  FForegroundColorImg.Height := round(IMG_SIZE * AYProportion);
  FBackgroundColorImg.Width := round(IMG_SIZE * AXProportion);
  FBackgroundColorImg.Left := round(MARGIN_2 * AXProportion);
  FBackgroundColorImg.Top := round(MARGIN_2 * AYProportion);

  FXLabel.BorderSpacing.Left := round(MARGIN_1 * AXProportion);

  FRLabel.BorderSpacing.Left := round(MARGIN_2 * AXProportion);
  FGLabel.BorderSpacing.Left := round(MARGIN_2 * AXProportion);
  FBLabel.BorderSpacing.Left := round(MARGIN_2 * AXProportion);
  FChosen.BorderSpacing.Left := round(MARGIN_1 * AXProportion);
end;

procedure TJvGammaPanel.DoChangeColor(AForegroundColor, ABackgroundColor: TColor);
begin
  if Assigned(FOnChangeColor) then
    FOnChangeColor(Self, AForegroundColor, ABackgroundColor);
end;

procedure TJvGammaPanel.Exchange(Sender: TObject);
var
  col: TColor;
  savedOnChangeColor: TJvChangeColorEvent;
begin
  savedOnChangeColor := FOnChangeColor;
  FOnChangeColor := nil;

  // exchange colors
  col := GetForegroundColor;
  SetForegroundColor(GetBackgroundColor);
  SetBackgroundColor(col);

  FOnChangeColor := savedOnChangeColor;
  DoChangeColor(GetForegroundColor, GetBackgroundColor);
end;

procedure TJvGammaPanel.FgColorClick(Sender: TObject);
begin
  with TColorDialog.Create(Self) do
  begin
    if Execute then
      SetForegroundColor(Color);
    Free;
  end;
end;

function TJvGammaPanel.GetBackgroundColor: TColor;
begin
  Result := FBackgroundColorImg.Brush.Color;
end;

function TJvGammaPanel.GetForegroundColor: TColor;
begin
  Result := FForegroundColorImg.Brush.Color;
end;

function TJvGammaPanel.IsHeightStored: Boolean;
begin
  Result := Height <> Scale96ToFont(DEFAULT_HEIGHT);
end;

function TJvGammaPanel.IsWidthStored: Boolean;
begin
  Result := Width <> Scale96ToFont(DEFAULT_WIDTH);
end;

procedure TJvGammaPanel.Resize;
var
  imgSize: Integer;
  p: Integer;
  m: Integer;
begin
  inherited;
  if FPanel3 = nil then
    exit;

  m := Scale96ToFont(MARGIN_1);
  if FPanel3.Width > FPanel3.Height then begin
    imgSize := (FPanel3.ClientHeight - 2*m) div 3 * 2;
    p := (FPanel3.ClientWidth - imgSize*3 div 2) div 2;
    FBackgroundColorImg.SetBounds(
      p + imgSize*3 div 2 - imgSize, FPanel3.ClientHeight - imgSize - m, imgSize, imgSize);
    FForegroundColorImg.SetBounds(p, m, imgSize, imgSize);
    FXLabel.Left := FForegroundColorImg.Left;
    FXLabel.AnchorSideBottom.Control := FPanel3;
    FXLabel.AnchorSideBottom.Side := asrBottom;
    FXLabel.Anchors := [akLeft, akBottom];
    FXLabel.BorderSpacing.Bottom := 0;
  end else begin
    imgSize := (FPanel3.ClientWidth - 2*m) div 3 * 2;
    p := (FPanel3.ClientHeight - imgSize*3 div 2) div 2;
    FBackgroundColorImg.SetBounds(
      FPanel3.ClientWidth - imgSize - m, p + imgSize*3 div 2 - imgSize, imgSize, imgSize);
    FForegroundColorImg.SetBounds(
      m, p, imgSize, imgSize);
  end;
end;

procedure TJvGammaPanel.SetBackgroundColor(const AValue: TColor);
begin
  if GetBackgroundColor = AValue then
    exit;
  FBackgroundColorImg.Brush.Color := AValue;
  DoChangeColor(GetForegroundColor, AValue);
end;

procedure TJvGammaPanel.SetForegroundColor(const AValue: TColor);
begin
  if GetForegroundColor = AValue then
    exit;
  FForegroundColorImg.Brush.Color := AValue;
  DoChangeColor(AValue, GetBackgroundColor);
end;

end.
