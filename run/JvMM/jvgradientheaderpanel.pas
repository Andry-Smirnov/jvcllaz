{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvGradientCaption.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse att buypin dott com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$mode objfpc}{$H+}

unit JvGradientHeaderPanel;

interface

uses
  LMessages, LCLVersion,
  SysUtils, Classes, Graphics, Controls, StdCtrls,
  JvGradient, JvTypes, JvComponent;

type

  { TJvGradientHeaderPanel }

  TJvGradientHeaderPanel = class(TJvCustomControl)
  private
    FGradient: TJvGradient;
    FLabel: TLabel;
    FLabelLeft: Integer;
    FLabelTop: Integer;
    FLabelRight: Integer;
    FLabelBottom: Integer;
    FHint: Boolean;
    FOldLabelFontChange: TNotifyEvent;
    function GetGradientCursor: TCursor;
    procedure SetGradientCursor(Value: TCursor);
    function GetGradientHint: string;
    procedure SetGradientHint(const Value: string);
    function GetGradientStartColor: TColor;
    procedure SetGradientStartColor(Value: TColor);
    function GetGradientEndColor: TColor;
    procedure SetGradientEndColor(Value: TColor);
    function GetGradientSteps: Integer;
    procedure SetGradientSteps(Value: Integer);
    procedure SetLabelLeft(Value: Integer);
    procedure SetLabelTop(Value: Integer);
    procedure SetLabelRight(Value: Integer);
    procedure SetLabelBottom(Value: Integer);
    function GetLabelCursor: TCursor;
    procedure SetLabelCursor(Value: TCursor);
    function GetLabelHint: string;
    procedure SetLabelHint(const Value: string);
    function GetLabelCaption: string;
    procedure SetLabelCaption(const Value: string);
    function GetLabelColor: TColor;
    procedure SetLabelColor(Value: TColor);
    procedure SetShowHint(const Value: Boolean);
    function GetLabelFont: TFont;
    procedure SetLabelFont(const Value: TFont);
    function GetGradientStyle: TJvGradientStyle;
    procedure SetGradientStyle(const Value: TJvGradientStyle);
    function GetLabelAlignment: TAlignment;
    procedure SetLabelAlignment(const Value: TAlignment);
    function GetLabelLayout: TTextLayout;
    procedure SetLabelLayout(const Value: TTextLayout);
    function GetLabelWordwrap: Boolean;
    procedure SetLabelWordwrap(const Value: Boolean);
    procedure WMSize(var Msg: TLMSize); message LM_SIZE;
  protected
    procedure AdjustLabel;
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
//    function DoEraseBackground(Canvas: TCanvas; Param: LPARAM): Boolean; override;
    procedure DoLabelFontChange(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GradientCursor: TCursor read GetGradientCursor write SetGradientCursor default crDefault;
    property GradientHint: string read GetGradientHint write SetGradientHint;
    property GradientStartColor: TColor read GetGradientStartColor write SetGradientStartColor default clBlack;
    property GradientEndColor: TColor read GetGradientEndColor write SetGradientEndColor default clWhite;
    property GradientSteps: Integer read GetGradientSteps write SetGradientSteps default 100;
    property GradientStyle: TJvGradientStyle read GetGradientStyle write SetGradientStyle default grHorizontal;
    property LabelLeft: Integer read FLabelLeft write SetLabelLeft default 10;
    property LabelTop: Integer read FLabelTop write SetLabelTop default 8;
    property LabelRight: Integer read FLabelRight write SetLabelRight default 10;
    property LabelBottom: Integer read FLabelBottom write SetLabelBottom default 8;
    property LabelCursor: TCursor read GetLabelCursor write SetLabelCursor default crDefault;
    property LabelHint: string read GetLabelHint write SetLabelHint;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    // LabelColor sets the background Color of the label (used for text in the control).
    // To get a transparent text background, set LabelColor to clNone
    property LabelColor: TColor read GetLabelColor write SetLabelColor default clNone;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelAlignment: TAlignment read GetLabelAlignment write SetLabelAlignment default taLeftJustify;
    property LabelLayout: TTextLayout read GetLabelLayout write SetLabelLayout default tlTop;
    property LabelWordwrap: Boolean read GetLabelWordwrap write SetLabelWordwrap default false;
    property ShowHint: Boolean read FHint write SetShowHint default False;
    property Align;
    property Anchors;
    property AutoSize;
{
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
}
    property BorderSpacing;
//    property BorderWidth;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragMode;
    property Enabled;
    property Font;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property Visible;
//    property OnCanResize;
    property OnDockDrop;
    property OnDockOver;
    property OnGetSiteInfo;
    property OnUnDock;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
  end;


implementation

uses
  JvResources;

type
  TNoEventLabel = class(TLabel)
  public
    procedure Dispatch(var Message); override;
  end;

  TNoEventGradient = class(TJvGradient)
  public
    procedure Dispatch(var Message); override;
  end;

constructor TJvGradientHeaderPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls];
  Self.Width := 285;
  Self.Height := 30;
  FLabelLeft := 10;
  FLabelTop := 8;
  FLabelRight := 10;
  FLabelBottom := 8;
  FGradient := TNoEventGradient.Create(Self);
  FGradient.Parent := Self;
  FLabel := TNoEventLabel.Create(Self);
  FLabel.AutoSize := true;
//  FLabel.AutoSize := False;  // wp
  FLabel.Align := alClient;
  FLabel.Parent := Self;
  //FGradient.Left := 0;
  //FGradient.Top := 0;
  FGradient.StartColor := clBlack;
  FGradient.EndColor := clWhite;
  FGradient.Steps := 100;
  LabelColor := clNone;
  FOldLabelFontChange := FLabel.Font.OnChange;
  FLabel.Font.OnChange := @DoLabelFontChange;
  FLabel.Font.Color := clWhite;
  FLabel.Caption := RsYourTextHereCaption;
  FLabel.BorderSpacing.Left := FLabelLeft;;
  FLabel.BorderSpacing.Top := FLabelTop;
  FHint := False;
end;

destructor TJvGradientHeaderPanel.Destroy;
begin
  // FGradient.Free;
  //  FLabel.OnChange := FOldLabelFontChange;
  // FLabel.Free;
  inherited Destroy;
end;

function TJvGradientHeaderPanel.GetGradientCursor: TCursor;
begin
  Result := FGradient.Cursor;
end;

procedure TJvGradientHeaderPanel.SetGradientCursor(Value: TCursor);
begin
  FGradient.Cursor := Value;
end;

function TJvGradientHeaderPanel.GetGradientHint: string;
begin
  Result := FGradient.Hint;
end;

procedure TJvGradientHeaderPanel.SetGradientHint(const Value: string);
begin
  FGradient.Hint := Value;
end;

function TJvGradientHeaderPanel.GetGradientStartColor: TColor;
begin
  Result := FGradient.StartColor;
end;

procedure TJvGradientHeaderPanel.SetGradientStartColor(Value: TColor);
begin
  FGradient.StartColor := Value;
end;

function TJvGradientHeaderPanel.GetGradientEndColor: TColor;
begin
  Result := FGradient.EndColor;
end;

procedure TJvGradientHeaderPanel.SetGradientEndColor(Value: TColor);
begin
  FGradient.EndColor := Value;
end;

function TJvGradientHeaderPanel.GetGradientSteps: Integer;
begin
  Result := FGradient.Steps;
end;

procedure TJvGradientHeaderPanel.SetGradientSteps(Value: Integer);
begin
  FGradient.Steps := Value;
end;

procedure TJvGradientHeaderPanel.SetLabelLeft(Value: Integer);
begin
  if FLabelLeft <> Value then
  begin
    if Value < 0 then
      FLabelLeft := 0
    else
      FLabelLeft := Value;
    AdjustLabel;
  end;
end;

procedure TJvGradientHeaderPanel.SetLabelRight(Value: Integer);
begin
  if FLabelRight <> Value then
  begin
    if Value < 0 then
      FLabelRight := 0
    else
      FLabelRight := Value;
    AdjustLabel;
  end;
end;

procedure TJvGradientHeaderPanel.SetLabelTop(Value: Integer);
begin
  if Value < 0 then
    FLabelTop := 0
  else
    FLabelTop := Value;
  AdjustLabel;
end;

procedure TJvGradientHeaderPanel.SetLabelBottom(Value: Integer);
begin
  if Value < 0 then
    FLabelBottom := 0
  else
    FLabelBottom := Value;
  AdjustLabel;
end;

function TJvGradientHeaderPanel.GetLabelCursor: TCursor;
begin
  Result := FLabel.Cursor;
end;

procedure TJvGradientHeaderPanel.SetLabelCursor(Value: TCursor);
begin
  FLabel.Cursor := Value;
end;

function TJvGradientHeaderPanel.GetLabelHint: string;
begin
  Result := FLabel.Hint;
end;

procedure TJvGradientHeaderPanel.SetLabelHint(const Value: string);
begin
  FLabel.Hint := Value;
end;

function TJvGradientHeaderPanel.GetLabelCaption: string;
begin
  Result := FLabel.Caption;
end;

procedure TJvGradientHeaderPanel.SetLabelCaption(const Value: string);
begin
  FLabel.Caption := Value;
  AdjustLabel;
end;

function TJvGradientHeaderPanel.GetLabelColor: TColor;
begin
  Result := FLabel.Color;
end;

procedure TJvGradientHeaderPanel.SetLabelColor(Value: TColor);
begin
  FLabel.Color := Value;
  FLabel.Transparent := (Value = clNone);
end;

procedure TJvGradientHeaderPanel.SetShowHint(const Value: Boolean);
begin
  FHint := Value;
  FLabel.ShowHint := Value;
  FGradient.ShowHint := Value;
end;

function TJvGradientHeaderPanel.GetLabelFont: TFont;
begin
  Result := FLabel.Font;
end;

procedure TJvGradientHeaderPanel.SetLabelFont(const Value: TFont);
begin
  FLabel.Font := Value;
  AdjustLabel;
end;

function TJvGradientHeaderPanel.GetGradientStyle: TJvGradientStyle;
begin
  Result := FGradient.Style;
end;

procedure TJvGradientHeaderPanel.SetGradientStyle(const Value: TJvGradientStyle);
begin
  FGradient.Style := Value;
end;

function TJvGradientHeaderPanel.GetLabelAlignment: TAlignment;
begin
  Result := FLabel.Alignment;
end;

procedure TJvGradientHeaderPanel.SetLabelAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value;
  AdjustLabel;
end;

function TJvGradientHeaderPanel.GetLabelLayout: TTextLayout;
begin
  Result := FLabel.Layout;
end;

procedure TJvGradientHeaderPanel.SetLabelLayout(const Value: TTextLayout);
begin
  FLabel.Layout := Value;
  AdjustLabel;
end;

function TJvGradientHeaderPanel.GetLabelWordWrap: Boolean;
begin
  Result := FLabel.WordWrap;
end;

procedure TJvGradientHeaderPanel.SetLabelWordwrap(const Value: Boolean);
begin
  FLabel.WordWrap := Value;
  Invalidate;
end;

procedure TJvGradientHeaderPanel.WMSize(var Msg: TLMSize);
begin
  inherited;
//  AdjustLabel;
end;

procedure TJvGradientHeaderPanel.AdjustLabel;
begin
  FLabel.BorderSpacing.Left := FLabelLeft;
  FLabel.BorderSpacing.Right := FLabelRight;
  FLabel.BorderSpacing.Top := FLabelTop;
  FLabel.BorderSpacing.Bottom := FLabelBottom;
  if FLabel.Alignment = taCenter then
  begin
    FLabel.BorderSpacing.Left := 0;
    FLabel.BorderSpacing.Right := 0;
  end;
  if FLabel.Layout = tlCenter then
  begin
    FLabel.BorderSpacing.Top := 0;
    FLabel.BorderSpacing.Bottom := 0;
  end;
end;

procedure TJvGradientHeaderPanel.DoAutoAdjustLayout(
  const AMode: TLayoutAdjustmentPolicy; const AXProportion, AYProportion: Double
  );
begin
  inherited;
  if AMode in [lapAutoAdjustWithoutHorizontalScrolling, lapAutoAdjustForDPI] then
  begin
    FLabelLeft := round(FLabelLeft * AXProportion);
    FLabelTop := round(FLabelTop * AYProportion);
    FLabelRight := round(FLabelRight * AXProportion);
    FLabelBottom := round(FLabelBottom * AYProportion);
  end;
end;

procedure TJvGradientHeaderPanel.DoLabelFontChange(Sender: TObject);
begin
  if Assigned(FOldLabelFontChange) then
    FOldLabelFontChange(Sender);
  AdjustLabel;
end;

procedure TJvGradientHeaderPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if CanFocus then
    SetFocus;
end;

(*
function TJvGradientHeaderPanel.DoEraseBackground(Canvas: TCanvas; Param: LPARAM): Boolean;
begin
  { Reduce flickering FGradient completely fills the TJvGradientHeaderPanel }
  Result := True;
end;
*)


//=== { TNoEventLabel } ======================================================

procedure TNoEventLabel.Dispatch(var Message);
begin
  with TLMessage(Message) do
    if (Parent <> nil) and
      (((Msg >= LM_MOUSEFIRST) and (Msg <= LM_MOUSELAST)) or
      ((Msg >= LM_KEYFIRST) and (Msg <= LM_KEYLAST))) then
      Parent.Dispatch(Message)
    else
      inherited Dispatch(Message);
end;


//=== { TNoEventGradient } ===================================================

procedure TNoEventGradient.Dispatch(var Message);
begin
  with TLMessage(Message) do
    if (Parent <> nil) and
      (((Msg >= LM_MOUSEFIRST) and (Msg <= LM_MOUSELAST)) or
      ((Msg >= LM_KEYFIRST) and (Msg <= LM_KEYLAST))) then
      Parent.Dispatch(Message)
    else
      inherited Dispatch(Message);
end;



end.
