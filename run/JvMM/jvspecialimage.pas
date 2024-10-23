{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvSpecialImage.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse att buypin dott com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvSpecialImage;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, {Windows,} Graphics, Controls, ExtCtrls, Forms,
  JvTypes;

type
  TJvBright = -100..100;
  TJvFadingEnd = (feBlack, feWhite);

  TJvSpecialImage = class(TImage)
  private
    FInverted: Boolean;
    FFadingEnd: TJvFadingEnd;
    FFadingSpeed: Integer;
    FFadingIn: Boolean;
    FFlipped: Boolean;
    FBrightness: TJvBright;
    FOriginal: TPicture;
    FMirrored: Boolean;
    FWorking: Boolean;
    FTimer: TTimer;
    FChangingLocalProperty: Boolean;
    FOnFadingComplete: TNotifyEvent;
    procedure SetBright(Value: TJvBright);
    procedure SetFadingSpeed(const Value: Integer);
    procedure SetFlipped(const Value: Boolean);
    procedure SetInverted(const Value: Boolean);
    procedure SetMirrored(const Value: Boolean);
    procedure ApplyChanges;
    procedure FadeTimerHandler(Sender: TObject);
    function GetPicture: TPicture;
    procedure SetPicture(const Value: TPicture);
  protected
    procedure Loaded; override;
    procedure PictureChanged(Sender: TObject); override;  // wp: moved from "private"
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Brightness: TJvBright read FBrightness write SetBright default 0;
    property Inverted: Boolean read FInverted write SetInverted default False;
    property FadingEnd: TJvFadingEnd read FFadingEnd write FFadingEnd default feBlack;
    property FadingSpeed: Integer read FFadingSpeed write SetFadingSpeed default 2;
    property Flipped: Boolean read FFlipped write SetFlipped default False;
    property Mirrored: Boolean read FMirrored write SetMirrored default False;
    property Picture: TPicture read GetPicture write SetPicture;
    procedure FadeIn;
    procedure FadeOut;
    procedure Reset;
    property OnFadingComplete: TNotifyEvent read FOnFadingComplete write FOnFadingComplete;
  end;


implementation

uses
  FPImage, IntfGraphics;

constructor TJvSpecialImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOriginal := TPicture.Create;
  FBrightness := 0;
  FInverted := False;
  FFlipped := False;
  FMirrored := False;
  FWorking := False;
  FChangingLocalProperty := False;
  Picture.OnChange := @PictureChanged;
  FTimer := TTimer.Create(self);
  FTimer.Enabled := false;
  FTimer.Interval := 1;
  FTimer.OnTimer := @FadeTimerHandler;
  FFadingSpeed := 2;
end;

destructor TJvSpecialImage.Destroy;
begin
  Picture.Assign(FOriginal);
  FOriginal.Free;
  inherited Destroy;
end;

procedure TJvSpecialImage.Loaded;
begin
  inherited Loaded;
  FOriginal.Assign(Picture);
end;

procedure TJvSpecialImage.ApplyChanges;
var
  I, J: Integer;
  C, C2: TFPColor;
  Dest: TBitmap;
  Val: Integer;
  IntfImg: TLazIntfImage;
begin
  if FWorking or (csLoading in ComponentState) or (csDestroying in ComponentState) then
    Exit;
  FWorking := True;

  IntfImg := TLazIntfImage.Create(FOriginal.Width, FOriginal.Height);
  try
    IntfImg.LoadFromBitmap(FOriginal.Bitmap.Handle, FOriginal.Bitmap.MaskHandle);
    Val := Integer(65535) * FBrightness div 100;
    if Val > 0 then
    begin
      for J := 0 to IntfImg.Height - 1 do
        for I := 0 to IntfImg.Width - 1 do
        begin
          C := IntfImg.Colors[I, J];
          if C.Blue + Val > 65535 then C.Blue := 65535 else C.Blue := C.Blue + Val;
          if C.Green + Val > 65535 then C.Green := 65535 else C.Green := C.Green + Val;
          if C.Red + Val > 65535 then C.Red := 65535 else C.Red := C.Red + Val;
          IntfImg.Colors[I, J] := C;
        end;
    end else
    if Val < 0 then
    begin
      for J := 0 to IntfImg.Height - 1 do
        for I := 0 to IntfImg.Width - 1 do
        begin
          C := IntfImg.Colors[I, J];
          if C.Blue + Val < 0 then C.Blue := 0 else C.Blue := C.Blue + Val;
          if C.Green + Val < 0 then C.Green := 0 else C.Green := C.Green + Val;
          if C.Red + Val < 0 then C.Red := 0 else C.Red := C.Red + Val;
          IntfImg.Colors[I, J] := C;
        end;
    end;

    //Set Flipped
    if FFlipped then
      for J := 0 to (IntfImg.Height - 1) div 2 do
        for I := 0 to IntfImg.Width - 1 do
        begin
          C := IntfImg.Colors[I, J];
          C2 := IntfImg.Colors[I, IntfImg.Height - J - 1];
          IntfImg.Colors[I, J] := C2;
          IntfImg.Colors[I, IntfImg.Height - J - 1] := C;
        end;

    //Set inverted
    if FInverted then
      for J := 0 to IntfImg.Height - 1 do
        for I := 0 to IntfImg.Width - 1 do
        begin
          C := IntfImg.Colors[I, J];
          C.Red := 65535 - C.Red;
          C.Green := 65535 - C.Green;
          C.Blue := 65535 - C.Blue;
          IntfImg.Colors[I, J] := C;
        end;

    //Set mirrored
    if FMirrored then
      for J := 0 to IntfImg.Height - 1 do
        for I := 0 to (IntfImg.Width - 1) div 2 do
        begin
          C := IntfImg.Colors[I, J];
          C2 := IntfImg.Colors[IntfImg.Width - I - 1, J];
          IntfImg.Colors[I, J] := C2;
          IntfImg.Colors[IntfImg.Width - I - 1, J] := C;
        end;

    Dest := TBitmap.Create;
    try
      Dest.LoadFromIntfImage(IntfImg);
      if FChangingLocalProperty then
        inherited Picture.Assign(Dest);
    finally
      Dest.Free;
    end;

  finally
    IntfImg.Free;
    FWorking := false;
  end;
end;

procedure TJvSpecialImage.FadeIn;
begin
  FFadingIn := true;
  FTimer.Enabled := true;
end;

procedure TJvSpecialImage.FadeOut;
begin
  FFadingIn := false;
  FTimer.Enabled := true;
end;

procedure TJvSpecialImage.FadeTimerHandler(Sender: TObject);
const
  FADE_END_BRIGHTNESS: Array[TJvFadingEnd, boolean] of Integer = (
    { jeBlack }  (-100, 0),   // fading out/in }
    { jeWhite }  ( 100, 0)    // fading out/in
    );
  SGN: array[TJvFadingEnd, boolean] of Integer = (
    { jeBlack } (-1, +1),
    { jeWhite } (+1, -1)
  );

  function AwayFromEndPoint(AFadingEnd: TJvFadingEnd): Boolean;
  begin
    case AFadingEnd of
      feBlack:
        if FFadingIn then
          Result := FBrightness < -FFadingSpeed
        else
          Result := FBrightness >= -100 + FFadingSpeed;
      feWhite:
        if FFadingIn then
          Result := FBrightness > FFadingSpeed
        else
          Result := FBrightness <= 100 - FFadingSpeed;
    end;
  end;

  procedure EndPointReached(AFadingEnd: TJvFadingEnd);
  begin
    Brightness := FADE_END_BRIGHTNESS[AFadingEnd, FFadingIn];
    FTimer.Enabled := false;
    if Assigned(FOnFadingComplete) then
      FOnFadingComplete(Self);
  end;

  function NextFadingEnd: TJvFadingEnd;
  begin
    Result := TJvFadingEnd((ord(FFadingEnd) + 1) mod 2);
  end;

var
  lFadingEnd: TJvFadingEnd;
begin
  if FInverted then
    lFadingEnd := NextFadingEnd
  else
    lFadingEnd := FFadingEnd;
  if AwayFromEndPoint(lFadingEnd) then
    Brightness := FBrightness + SGN[lFadingEnd, FFadingIn] * FFadingSpeed
  else
    EndPointReached(lFadingEnd);
end;

function TJvSpecialImage.GetPicture: TPicture;
begin
  Result := inherited Picture;
end;

procedure TJvSpecialImage.PictureChanged(Sender: TObject);
begin
  if FWorking = False then
  begin
    FOriginal.Assign(inherited Picture);
    ApplyChanges; // SetBright(FBrightness);
  end;
  Invalidate;
end;

procedure TJvSpecialImage.Reset;
begin
  FWorking := True;
  Brightness := 0;
  Inverted := False;
  Flipped := False;
  Mirrored := False;
  FWorking := False;
  Picture.Assign(FOriginal);
end;

procedure TJvSpecialImage.SetBright(Value: TJvBright);
begin
  FChangingLocalProperty := True;
  try
    FBrightness := Value;
    ApplyChanges;
  finally
    FChangingLocalProperty := False;
  end;
end;

procedure TJvSpecialImage.SetFadingSpeed(const Value: Integer);
begin
  if Value <> FFadingSpeed then begin
    FFadingSpeed := abs(Value);
    if FFadingSpeed = 0 then FFadingSpeed := 1;
  end;
end;

procedure TJvSpecialImage.SetFlipped(const Value: Boolean);
begin
  if Value <> FFlipped then
  begin
    FChangingLocalProperty := True;
    try
      FFlipped := Value;
      ApplyChanges;
    finally
      FChangingLocalProperty := False;
    end;
  end;
end;

procedure TJvSpecialImage.SetInverted(const Value: Boolean);
begin
  if Value <> FInverted then
  begin
    FChangingLocalProperty := True;
    try
      FInverted := Value;
      ApplyChanges;
    finally
      FChangingLocalProperty := False;
    end;
  end;
end;

procedure TJvSpecialImage.SetMirrored(const Value: Boolean);
begin
  if Value <> FMirrored then
  begin
    FChangingLocalProperty := True;
    try
      FMirrored := Value;
      ApplyChanges;
    finally
      FChangingLocalProperty := False;
    end;
  end;
end;

procedure TJvSpecialImage.SetPicture(const Value: TPicture);
begin
  FOriginal.Assign(Value);
  inherited Picture := Value;
end;

end.
