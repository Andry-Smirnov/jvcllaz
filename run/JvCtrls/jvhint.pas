{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvHint.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Andrei Prygounkov <a dott prygounkov att gmx dott de>
Copyright (c) 1999, 2002 Andrei Prygounkov
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

component   : TJvHint
description : Custom activated hint

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvHint;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes,
  Controls, Forms, ExtCtrls,
  JvTypes;

type
  TJvHintWindow = class(THintWindow)
  public
    property Caption;
  end;
  TJvHintWindowClass = class of TJvHintWindow;

  TJvHintState = (tmBeginShow, tmShowing, tmStopped);
  
  TJvHint = class(TComponent)
  private
    FAutoHide: Boolean;
  protected
    // (rom) definitely needs cleanup here  bad structuring
    R: TRect;
    Area: TRect;
    State: TJvHintState;
    Txt: THintString;
    HintWindow: TJvHintWindow;
    TimerHint: TTimer;
    FDelay: Integer;
    procedure TimerHintTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(AArea: TRect; ATxt: THintString);
    procedure ActivateHintAt(AArea: TRect; ATxt: THintString; ScreenPos: TPoint);
    procedure CancelHint;
  published
    property AutoHide: Boolean read FAutoHide write FAutoHide default True;
  end;

  TJvHTHintWindow = class(THintWindow)
  public
    function CalcHintRect({%H-}MaxWidth: Integer;
      const AHint: THintString; {%H-}AData: Pointer): TRect; override;
    procedure Paint; override;
  end;

procedure RegisterHtHints;

implementation

uses
  Graphics, Math, LCLIntf, LCLType,
  JvResources, JvHTControls;

//=== { TJvHint } ============================================================

constructor TJvHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TimerHint := TTimer.Create(Self);
  TimerHint.Enabled := False;
  TimerHint.Interval := 50;
  TimerHint.OnTimer := @TimerHintTimer;
  HintWindow := TJvHintWindowClass.Create(Self);
  ShowWindow(HintWindow.Handle, SW_HIDE);
  FAutoHide := True;
end;

destructor TJvHint.Destroy;
begin
  TimerHint.Free;
  HintWindow.Free;
  inherited Destroy;
end;

procedure TJvHint.ActivateHint(AArea: TRect; ATxt: THintString);
var
  P: TPoint = (X:0; y:0);  // silence the compiler...
begin
  GetCursorPos(P);
  Inc(P.Y, 20);
  ActivateHintAt(AArea, ATxt, P);
end;

procedure TJvHint.ActivateHintAt(AArea: TRect; ATxt: THintString; ScreenPos: TPoint);
var
  P: TPoint = (X: 0; Y: 0);  // silence the compiler
begin
  Area := AArea;
  if ATxt = '' then
  begin
    CancelHint;
    Exit;
  end
  else
    Txt := ATxt;
  GetCursorPos(P);
  if not PtInRect(Area, P) then
  begin
    if IsWindowVisible(HintWindow.Handle) then
      ShowWindow(HintWindow.Handle, SW_HIDE);
    Exit;
  end;
  if HintWindow.Caption <> Txt then
  begin
    R := HintWindow.CalcHintRect(Screen.Width, Txt, nil);
    R.Top := ScreenPos.Y;
    R.Left := ScreenPos.X;
    Inc(R.Bottom, R.Top);
    Inc(R.Right, R.Left);
    State := tmBeginShow;
    TimerHint.Enabled := True;
  end;
end;

procedure TJvHint.TimerHintTimer(Sender: TObject);
var
  P: TPoint = (X: 0; Y: 0);  // silence the compiler
  bPoint, bDelay: Boolean;
  Delay: Integer;
  HintPause: Integer;
begin
  HintWindow.Color := Application.HintColor;
  Delay := FDelay * Integer(TimerHint.Interval);
  case State of
    tmBeginShow:
      begin
        GetCursorPos(P);
        bPoint := not PtInRect(Area, P);
        if bPoint then
        begin
          State := tmStopped;
          Exit;
        end;
        if IsWindowVisible(HintWindow.Handle) then
          HintPause := Application.HintShortPause
        else
          HintPause := Application.HintPause;
        if Delay >= HintPause then
        begin
          HintWindow.ActivateHint(R, Txt);
          FDelay := 0;
          State := tmShowing;
        end
        else
          Inc(FDelay);
      end;
    tmShowing:
      begin
        GetCursorPos(P);
        bDelay := FAutoHide and (Delay > Application.HintHidePause);
        bPoint := not PtInRect(Area, P);
        if bPoint or bDelay then
        begin
          if IsWindowVisible(HintWindow.Handle) then
            ShowWindow(HintWindow.Handle, SW_HIDE);
          FDelay := 0;
          if bPoint then
            HintWindow.Caption := RsHintCaption;
          State := tmStopped;
        end
        else
          Inc(FDelay);
      end;
    tmStopped:
      begin
        FDelay := 0;
        GetCursorPos(P);
        bPoint := not PtInRect(Area, P);
        if IsWindowVisible(HintWindow.Handle) then
          ShowWindow(HintWindow.Handle, SW_HIDE);
        if bPoint then
        begin
          HintWindow.Caption := RsHintCaption;
          TimerHint.Enabled := False;
        end;
      end;
  end; 
end;

procedure TJvHint.CancelHint;
begin
  if IsWindowVisible(HintWindow.Handle) then
    ShowWindow(HintWindow.Handle, SW_HIDE);
  HintWindow.Caption := '';
end;


//=== { TJvHTHintWindow } ====================================================

function TJvHTHintWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: THintString; AData: Pointer): TRect;
var
  W, H: Integer;
begin
  H := ItemHTHeight(Canvas, AHint, DefaultSuperSubScriptRatio);
  W := ItemHTWidth(Canvas, Bounds(0, 0, 0, 0), [], AHint, DefaultSuperSubScriptRatio);
  Result := Bounds(0, 0, W + 6, H + 6);
  if Application.HintHidePause > 0 then
    Application.HintHidePause :=
      Max(2500, // default
      Length(ItemHtPlain(AHint)) *
      1000 div 20  // 20 symbols per second
    );
end;

procedure TJvHTHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Pen.Color := clActiveBorder;
  Canvas.Frame(R);
  InflateRect(R, -3, -3);
  ItemHTDrawHL(Canvas, R, [], Caption, -1, -1, DefaultSuperSubScriptRatio);
end;


//==============================================================================

procedure RegisterHtHints;
begin
  if Application.ShowHint then
  begin
    Application.ShowHint := False;
    HintWindowClass := TJvHTHintWindow;
    Application.ShowHint := True;
  end
  else
    HintWindowClass := TJvHTHintWindow;
end;

end.
