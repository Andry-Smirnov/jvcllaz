{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvgRuler.PAS, released on 2003-01-15.

The Initial Developer of the Original Code is Andrey V. Chudin,  [chudin att yandex dott ru]
Portions created by Andrey V. Chudin are Copyright (C) 2003 Andrey V. Chudin.
All Rights Reserved.

Contributor(s):
Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvRuler;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LCLVersion, Types,
  Classes, SysUtils, Graphics, Controls,
  JvComponent;

const
  DEFAULT_JVR_MAJOR_TICKLENGTH = 8;
  DEFAULT_JVR_MINOR_TICKLENGTH = 3;
  DEFAULT_JVR_MARKER_SIZE = 6;

type
  TJvRulerUnit = (ruCentimeters, ruInches, ruPixels);
  TJvRulerOrientation = (roHorizontal, roVertical);

  TJvRuler = class(TJvGraphicControl)
  private
    FUseUnit: TJvRulerUnit;
    FOrientation: TJvRulerOrientation;
    FPosition: Double;
    FTickColor: TColor;
    FMarkerColor: TColor;
    FMarkerFilled: Boolean;
    FMarkerSize: Integer;
    FMajorTickLength: Integer;
    FMinorTickCount: Integer;
    FMinorTickLength: Integer;
    FShowBaseline: Boolean;
    FShowPositionMarker: Boolean;
    procedure SetMarkerColor(const Value: TColor);
    procedure SetMarkerFilled(const Value: Boolean);
    procedure SetMarkerSize(const Value: Integer);
    procedure SetMajorTickLength(const Value: Integer);
    procedure SetMinorTickCount(const Value: Integer);
    procedure SetMinorTickLength(const Value: Integer);
    procedure SetOrientation(const Value: TJvRulerOrientation);
    procedure SetPosition(const Value: Double);
    procedure SetShowBaseline(const Value: Boolean);
    procedure SetShowPositionMarker(const Value: Boolean);
    procedure SetTickColor(const Value: TColor);
    procedure SetUseUnit(const Value: TJvRulerUnit);
  protected
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
    class function GetControlClassDefaultSize: TSize; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property BorderSpacing;
    property Font;
    property MarkerColor: TColor read FMarkerColor write SetMarkerColor default clBlack;
    property MarkerFilled: Boolean read FMarkerFilled write SetMarkerFilled default true;
    property MarkerSize: Integer read FMarkerSize write SetMarkerSize default DEFAULT_JVR_MARKER_SIZE;
    property MajorTickLength: Integer read FMajorTickLength write SetMajorTickLength default DEFAULT_JVR_MAJOR_TICKLENGTH;
    property MinorTickCount: Integer read FMinorTickCount write SetMinorTickCount default 1;
    property MinorTickLength: Integer read FMinorTickLength write SetMinorTicklength default DEFAULT_JVR_MINOR_TICKLENGTH;
    property Orientation: TJvRulerOrientation read FOrientation write SetOrientation  default roHorizontal;
    property Position: Double read FPosition write SetPosition;
    property ShowBaseline: Boolean read FShowBaseline write SetShowBaseLine default false;
    property ShowPositionMarker: Boolean read FShowPositionMarker write SetShowPositionMarker default false;
    property TickColor: TColor read FTickColor write SetTickColor default clBlack;
    property UseUnit: TJvRulerUnit read FUseUnit write SetUseUnit default ruCentimeters;
  end;


implementation

uses
  Math;

const
  LogPixels: array [Boolean] of Integer = (LOGPIXELSY, LOGPIXELSX);

function InchesToPixels(DC: HDC; Value: Double; IsHorizontal: Boolean): Integer;
begin
  Result := Round(Value * GetDeviceCaps(DC, LogPixels[IsHorizontal]));
end;

function CentimetersToPixels(DC: HDC; Value: Double; IsHorizontal: Boolean): Integer;
begin
  Result := Round(Value * GetDeviceCaps(DC, LogPixels[IsHorizontal]) / 2.54);
end;

function IsMultipleOf(a, b: Double): Boolean;
var
  c: Double;
begin
  c := a / b;
  Result := SameValue(c, round(c));
end;


//=== { TJvRuler } ===========================================================

constructor TJvRuler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := roHorizontal;
  FTickColor := clBlack;
  FUseUnit := ruCentimeters;
  FMarkerFilled := true;
  FMarkerSize := DEFAULT_JVR_MARKER_SIZE;
  FMajorTickLength := DEFAULT_JVR_MAJOR_TICKLENGTH;
  FMinorTickLength := DEFAULT_JVR_MINOR_TICKLENGTH;
  FMinorTickCount := 1;
  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, CX, CY);
end;

procedure TJvRuler.DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
  const AXProportion, AYProportion: Double);
var
  proportion: Double;
begin
  inherited;
  if AMode in [lapAutoAdjustWithoutHorizontalScrolling, lapAutoAdjustForDPI] then
  begin
    case FOrientation of
      roHorizontal: proportion := AYProportion;
      roVertical: proportion := AXProportion;
    end;
    FMarkerSize := round(FMarkerSize * proportion);
    FMajorTickLength := round(FMajorTickLength * proportion);
    FMinorTicklength := round(FMinorTickLength * proportion);
  end;
end;

class function TJvRuler.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 380;
  Result.CY := 25;
end;

procedure TJvRuler.Paint;
const
  MAJOR_DIST: array[TJvRulerUnit] of Double = (1.0, 1.0, 100.0);
var
  X, Y: Double;
  PX, PY, Pos: Integer;
  S: string;
  R: TRect;
  ts: TTextStyle;
  h, w: Integer;
  delta: Double;
  isLabeledTick: Boolean;
  isLongTick: Boolean;
  tickLength: Integer;
  baselineOffset: Integer;
  markerSizeL, markerSizeS: Integer;
  Pts: array[0..2] of TPoint;
begin
  w := inherited Width;
  h := inherited Height;
  ts := Canvas.TextStyle;
  ts.SingleLine := true;
  Canvas.Font := Font;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := FTickColor;
  X := 0;
  Y := 0;
  delta := MAJOR_DIST[FUseUnit] / (FMinorTickCount + 1);
  case FUseUnit of
    ruInches: Pos := InchesToPixels(Canvas.Handle, Position, Orientation = roHorizontal);
    ruCentimeters: Pos := CentimetersToPixels(Canvas.Handle, Position, Orientation = roHorizontal);
    ruPixels: Pos := Round(Position);
  end;

  // Draw baseline
  baseLineOffset := 0;
  if FShowBaseLine then
  begin
    case FOrientation of
      roHorizontal: Canvas.Line(0, h-1, w, h-1);
      roVertical: Canvas.Line(w-1, 0, w-1, h);
    end;
    baseLineOffset := 1;
  end;

  // Draw labels and ticks
  while true do begin
    case FUseUnit of
      ruInches:
        begin
          PX := InchesToPixels(Canvas.Handle, X, True);
          PY := InchesToPixels(Canvas.Handle, Y, False);
        end;
      ruCentimeters:
        begin
          PX := CentimetersToPixels(Canvas.Handle, X, True);
          PY := CentimetersToPixels(Canvas.Handle, Y, False);
        end;
      ruPixels:
        begin
          PX := Round(X);
          PY := Round(Y);
          Pos := Round(Position);
        end;
      else
        raise Exception.Create('Units not supported.');
    end;

    case Orientation of
      roHorizontal: if PX > w then break;
      roVertical: if PY > h then break;
    end;

    //SetBkMode(Canvas.Handle, TRANSPARENT);
    with Canvas do begin
      if Orientation = roHorizontal then
      begin
        isLabeledTick := IsMultipleOf(X, MAJOR_DIST[FUseUnit]) and (X <> 0);
        if isLabeledTick then
        begin
          //R := Rect(PX - 10, 0, PX + 10, h);
          if UseUnit = ruPixels then
            S := IntToStr(PX)
          else
            S := IntToStr(Round(X));
          R := Rect(PX - TextWidth(S), 0, PX + TextWidth(S), h);
          ts.Alignment := taCenter;
          TextRect(R, R.Left, R.Top, S, ts);
          //Windows.DrawText(Handle, PChar(S), Length(S), R, DT_SINGLELINE or DT_CENTER);
        end;
        isLongTick := isLabeledTick or (IsMultipleOf(2*X, MAJOR_DIST[FUseUnit]) and (FMinorTickCount > 1));
        tickLength := IfThen(isLongTick, FMajorTickLength, FMinorTickLength);
        MoveTo(PX, h - baselineOffset - tickLength);
        LineTo(PX, h - baselineOffset);
      end else
      begin
        isLabeledTick := IsMultipleOf(Y, MAJOR_DIST[FUseUnit]) and (Y <> 0);
        if isLabeledTick then
        begin
          if UseUnit = ruPixels then
            S := IntToStr(PY)
          else
            S := IntToStr(Round(Y));
          R := Rect(0, PY - TextHeight(S), w, PY + TextHeight(S));
          ts.Layout := tlCenter;
          TextRect(R, R.Left, R.Top, S, ts);
          //Windows.DrawText(Handle, PChar(S), Length(S), R, DT_SINGLELINE or DT_VCENTER);
        end;
        isLongTick := isLabeledTick or (IsMultipleOf(2*Y, MAJOR_DIST[FUseUnit]) and (FMinorTickCount > 1));
        tickLength := IfThen(isLongTick, FMajorTickLength, FMinorTickLength);
        MoveTo(w - baselineOffset - tickLength, PY);
        LineTo(w - baselineOffset, PY);
      end;
      X := X + delta;
      Y := Y + delta;
    end;
  end;

  // Draw Position marker
  if FShowPositionMarker and (Position > 0.0) then
  begin
    markerSizeL := FMarkerSize;
    markerSizeS := FMarkerSize div 2;
    case Orientation of
      roHorizontal:
        begin
          Pts[0] := Point(Pos - markerSizeS, h - markerSizeL - baseLineOffset);
          Pts[1] := Point(Pos + markerSizeS, h - markerSizeL - baseLineOffset);
          Pts[2] := Point(Pos, h - baselineOffset);
        end;
      roVertical:
        begin
          Pts[0] := Point(w - markerSizeL - baselineOffset, Pos - markerSizeS);
          Pts[1] := Point(w - markerSizeL - baselineOffset, Pos + markerSizeS);
          Pts[2] := Point(w - baselineOffset, Pos);
        end;
    end;
    with Canvas do
    begin
      Pen.Color := FMarkerColor;
      Brush.Color := FMarkerColor;
      if FMarkerFilled then
        Brush.Style := bsSolid
      else
        Brush.Style := bsClear;
      Polygon(Pts);
    end;
    {

      if Orientation = roHorizontal then
      begin
        MoveTo(Pos - markerSizeS, h - markerSizeL - baselineOffset);
        LineTo(Pos + markerSizeS, h - markerSizeL - baselineOffset);
        LineTo(Pos, h - baselineOffset);
        LineTo(Pos - markerSizeS, h - markerSizeL - baselineOffset);
      end else
      begin
        MoveTo(w - markerSizeL - baselineOffset, Pos - markerSizeS);
        LineTo(w - markerSizeL - baselineOffset, Pos + markerSizeS);
        LineTo(w - baselineOffset, Pos);
        LineTo(w - markerSizeL - baselineOffset, Pos - markersizeS);
      end;
      }
  end;
end;

procedure TJvRuler.SetMarkerColor(const Value: TColor);
begin
  if FMarkerColor <> Value then
  begin
    FMarkerColor := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetMarkerFilled(const Value: Boolean);
begin
  if FMarkerFilled <> Value then
  begin
    FMarkerFilled := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetMarkerSize(const Value: Integer);
begin
  if FMarkerSize <> Value then
  begin
    FMarkerSize := abs(Value);
    Invalidate;
  end;
end;

procedure TJvRuler.SetMajorTickLength(const Value: Integer);
begin
  if FMajorTickLength <> Value then
  begin
    FMajorTickLength := abs(Value);
    Invalidate;
  end;
end;

procedure TJvRuler.SetMinorTickCount(const Value: Integer);
begin
  if FMinorTickCount <> Value then
  begin
    FMinorTickCount := abs(Value);
    Invalidate;
  end;
end;

procedure TJvRuler.SetMinorTickLength(const Value: Integer);
begin
  if FMinorTickLength <> Value then
  begin
    FMinorTickLength := abs(Value);
    Invalidate;
  end;
end;

procedure TJvRuler.SetOrientation(const Value: TJvRulerOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if ([csDesigning, csLoading] * ComponentState = [csDesigning]) then
      SetBounds(Left, Top, Height, Width);
    Invalidate;
  end;
end;

procedure TJvRuler.SetPosition(const Value: Double);
begin
  if FPosition <> Value then
  begin
    FPosition := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetShowBaseline(const Value: Boolean);
begin
  if FShowBaseLine <> Value then
  begin
    FShowBaseLine := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetShowPositionMarker(const Value: Boolean);
begin
  if FShowPositionMarker <> Value then
  begin
    FShowPositionMarker := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetTickColor(const Value: TColor);
begin
  if FTickColor <> Value then
  begin
    FTickColor := Value;
    Invalidate;
  end;
end;

procedure TJvRuler.SetUseUnit(const Value: TJvRulerUnit);
begin
  if FUseUnit <> Value then
  begin
    FUseUnit := Value;
    Invalidate;
  end;
end;


end.
