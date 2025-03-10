{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExExtCtrls.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvExExtCtrls.pas 10613 2006-05-19 19:21:43Z jfudickar $

// Initial port to Lazarus by Sergio Samayoa - september 2007.
// Conversion is done in incremental way: as types / classes / routines
// are needed they are converted.

{$mode objfpc}{$H+}

unit JvExExtCtrls;

{MACROINCLUDE JvExControls.macros}

{*****************************************************************************
 * WARNING: Do not edit this file.
 * This file is autogenerated from the source in devtools/JvExVCL/src.
 * If you do it despite this warning your changes will be discarded by the next
 * update of this file. Do your changes in the template files.
 ****************************************************************************}
{$D-} // do not step into this unit

interface

uses
  LCLIntf, LCLType, LMessages,
  Classes, Controls, ExtCtrls, Forms, Graphics,
  JvExControls;

type
  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(Shape)

  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(PaintBox)

  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(Image)

  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(Bevel)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(CustomPanel)

  TJvExCustomPanel = class(TCustomPanel, IJvExControl)
  private
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Cardinal; WParam: WPARAM = 0; LParam: LPARAM = 0): LRESULT; overload;
    function BaseWndProc(Msg: Cardinal; WParam: WPARAM; LParam: TObject): LRESULT; overload;
    function BaseWndProcEx(Msg: Cardinal; WParam: WPARAM; var StructLParam): LRESULT;
  protected
    procedure WndProc(var Msg: TLMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState): Boolean; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  public
    constructor Create(AOwner: TComponent); override;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  private
    FDotNetHighlighting: Boolean;
  protected
    procedure BoundsChanged; reintroduce; virtual;
    procedure CursorChanged; reintroduce; dynamic;
    procedure ShowingChanged; reintroduce; dynamic;
    procedure ShowHintChanged; reintroduce; dynamic;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure GetDlgCode(var Code: TDlgCodes); virtual;
    procedure FocusSet(PrevWnd: THandle); virtual;
    procedure FocusKilled(NextWnd: THandle); virtual;
    function DoEraseBackground(ACanvas: TCanvas; AParam: LPARAM): Boolean; virtual;
  {$IFDEF JVCLThemesEnabledD6}
  private
    function GetParentBackground: Boolean;
  protected
    procedure SetParentBackground(Value: Boolean); virtual;
    property ParentBackground: Boolean read GetParentBackground write SetParentBackground;
  {$ENDIF JVCLThemesEnabledD6}
  published
    property DotNetHighlighting: Boolean read FDotNetHighlighting write FDotNetHighlighting default False;
  end;


  (******************** NOT CONVERTED
  TJvExPubCustomPanel = class(TJvExCustomPanel)
  COMMON_PUBLISHED
  end;
  ******************** NOT CONVERTED *)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(CustomRadioGroup)

  TJvExSplitter = class(TSplitter)
  private
    // TODO:
    // FAboutJVCL: TJVCLAboutInfo;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
  protected
    procedure WndProc(var Msg: TLMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    function GetCaption: TCaption; virtual;
    procedure SetCaption(Value: TCaption); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Caption: TCaption read GetCaption write SetCaption;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  published
    // TODO:
    // property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  end;

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(CustomControlBar)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(ControlBar)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(Panel)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(RadioGroup)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(Page)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(Notebook)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(Header)


  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(BoundLabel)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(CustomLabeledEdit)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(LabeledEdit)

  //******************** NOT CONVERTED - Exists in LCL?
  //WINCONTROL_DECL_DEFAULT(CustomColorBox)

  //******************** NOT CONVERTED - Exists in LCL?
  //WINCONTROL_DECL_DEFAULT(ColorBox)

implementation

uses
  Types;

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(Shape)

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(PaintBox)

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(Image)

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(Bevel)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(CustomPanel)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(CustomRadioGroup)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(CustomControlBar)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(ControlBar)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(Panel)

constructor TJvExCustomPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExCustomPanel.BaseWndProc(Msg: Cardinal; WParam: WPARAM = 0; LParam: LPARAM = 0): LRESULT;
var
  Mesg: TLMessage;
begin
  CreateWMMessage(Mesg, Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExCustomPanel.BaseWndProc(Msg: Cardinal; WParam: WPARAM; LParam: TObject): LRESULT;
begin
  Result := BaseWndProc(Msg, WParam, LCLType.LPARAM(LParam));
end;

function TJvExCustomPanel.BaseWndProcEx(Msg: Cardinal; WParam: WPARAM; var StructLParam): LRESULT;
begin
  Result := BaseWndProc(Msg, WParam, LCLType.LPARAM(@StructLParam));
end;

procedure TJvExCustomPanel.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExCustomPanel.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExCustomPanel.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExCustomPanel.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExCustomPanel.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExCustomPanel.ParentFontChanged;
begin
  BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExCustomPanel.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExCustomPanel.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExCustomPanel.WantKey(Key: Integer; Shift: TShiftState): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExCustomPanel.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

function TJvExCustomPanel.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExCustomPanel.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExCustomPanel.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExCustomPanel.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

procedure TJvExCustomPanel.BoundsChanged;
begin
end;

procedure TJvExCustomPanel.CursorChanged;
begin
  BaseWndProc(CM_CURSORCHANGED);
end;

procedure TJvExCustomPanel.ShowingChanged;
begin
  BaseWndProc(CM_SHOWINGCHANGED);
end;

procedure TJvExCustomPanel.ShowHintChanged;
begin
  BaseWndProc(CM_SHOWHINTCHANGED);
end;

{ VCL sends CM_CONTROLLISTCHANGE and CM_CONTROLCHANGE in a different order than
  the CLX methods are used. So we must correct it by evaluating "Inserting". }
procedure TJvExCustomPanel.ControlsListChanging(Control: TControl; Inserting: Boolean);
begin
  if Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, WPARAM(Control), LPARAM(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, WPARAM(Control), LPARAM(Inserting));
end;

procedure TJvExCustomPanel.ControlsListChanged(Control: TControl; Inserting: Boolean);
begin
  if not Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, WPARAM(Control), LPARAM(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, WPARAM(Control), LPARAM(Inserting));
end;

procedure TJvExCustomPanel.GetDlgCode(var Code: TDlgCodes);
begin
end;

procedure TJvExCustomPanel.FocusSet(PrevWnd: THandle);
begin
  BaseWndProc(LM_SETFOCUS, WPARAM(PrevWnd), 0);
end;

procedure TJvExCustomPanel.FocusKilled(NextWnd: THandle);
begin
  BaseWndProc(LM_KILLFOCUS, WPARAM(NextWnd), 0);
end;

function TJvExCustomPanel.DoEraseBackground(ACanvas: TCanvas; AParam: LPARAM): Boolean;
begin
  Result := BaseWndProc(LM_ERASEBKGND, ACanvas.Handle, AParam) <> 0;
end;

{$IFDEF JVCLThemesEnabledD6}
function TJvExCustomPanel.GetParentBackground: Boolean;
begin
  Result := JvThemes.GetParentBackground(Self);
end;

procedure TJvExCustomPanel.SetParentBackground(Value: Boolean);
begin
  JvThemes.SetParentBackground(Self, Value);
end;
{$ENDIF JVCLThemesEnabledD6}

procedure TJvExCustomPanel.WndProc(var Msg: TLMessage);
var
  IdSaveDC: Integer;
  DlgCodes: TDlgCodes;
  lCanvas: TCanvas;
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  begin
    case Msg.Msg of
      (*********** NOT CONVERTED ****
    CM_DENYSUBCLASSING:
      Msg.Result := LRESULT(Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil));
      *******************************)
    CM_DIALOGCHAR:
      with TCMDialogChar{$IFDEF CLR}.Create{$ENDIF}(Msg) do
        Result := LRESULT(Ord(WantKey(CharCode, KeyDataToShiftState(KeyData))));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := LRESULT(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := LRESULT(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    CM_PARENTFONTCHANGED:
      ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
    CM_CURSORCHANGED:
      CursorChanged;
    CM_SHOWINGCHANGED:
      ShowingChanged;
    CM_SHOWHINTCHANGED:
      ShowHintChanged;
    CM_CONTROLLISTCHANGE:
      if Msg.LParam <> 0 then
        ControlsListChanging(TControl(Msg.WParam), True)
      else
        ControlsListChanged(TControl(Msg.WParam), False);
    CM_CONTROLCHANGE:
      if Msg.LParam = 0 then
        ControlsListChanging(TControl(Msg.WParam), False)
      else
        ControlsListChanged(TControl(Msg.WParam), True);
    LM_SETFOCUS:
      FocusSet(THandle(Msg.WParam));
    LM_KILLFOCUS:
      FocusKilled(THandle(Msg.WParam));
    LM_SIZE, LM_MOVE:
      begin
        inherited WndProc(Msg);
        BoundsChanged;
      end;
    LM_ERASEBKGND:
      if (Msg.WParam <> 0) and not IsDefaultEraseBackground(@DoEraseBackground, @TJvExCustomPanel.DoEraseBackground) then
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against Stock-Objects from Canvas
        lCanvas := TCanvas.Create;
        try
          lCanvas.Handle := HDC(Msg.WParam);
          Msg.Result := Ord(DoEraseBackground(lCanvas, Msg.LParam));
        finally
          lCanvas.Handle := 0;
          lCanvas.Free;
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end
      else
        inherited WndProc(Msg);
    (*************************** NOT CONVERTED ***
    {$IFNDEF DELPHI2007_UP}
    LM_PRINTCLIENT, LM_PRINT: // VCL bug fix
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against changes
        try
          inherited WndProc(Msg);
        finally
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end;
    {$ENDIF ~DELPHI2007_UP}
    *********************************************)
    LM_GETDLGCODE:
      begin
        inherited WndProc(Msg);
        DlgCodes := [dcNative] + DlgcToDlgCodes(Msg.Result);
        GetDlgCode(DlgCodes);
        if not (dcNative in DlgCodes) then
          Msg.Result := DlgCodesToDlgc(DlgCodes);
      end;
    else
      inherited WndProc(Msg);
    end;
    case Msg.Msg of // precheck message to prevent access violations on released controls
      CM_MOUSEENTER, CM_MOUSELEAVE, LM_KILLFOCUS, LM_SETFOCUS, LM_NCPAINT:
        if DotNetHighlighting then
          HandleDotNetHighlighting(Self, Msg, MouseOver, Color);
    end;
  end;
end;



//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(RadioGroup)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(Page)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(Notebook)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(Header)

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(BoundLabel)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(CustomLabeledEdit)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(LabeledEdit)

//******************** NOT CONVERTED - Exists in LCL?
//WINCONTROL_IMPL_DEFAULT(CustomColorBox)

//******************** NOT CONVERTED - Exists in LCL?
//WINCONTROL_IMPL_DEFAULT(ColorBox)

constructor TJvExSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExSplitter.BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer;
var
  Mesg: TLMessage;
begin
  CreateWMMessage(Mesg, Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExSplitter.BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer;
begin
  Result := BaseWndProc(Msg, WParam, LCLType.LPARAM(LParam));
end;

function TJvExSplitter.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TJvExSplitter.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExSplitter.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExSplitter.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExSplitter.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExSplitter.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExSplitter.ParentFontChanged;
begin
  // LCL doesn't send this message but left it in case
  //BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExSplitter.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExSplitter.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExSplitter.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExSplitter.HitTest(X, Y: Integer): Boolean;
var
  pt: Types.TSmallPoint;
begin
  pt.X := X;
  pt.Y := Y;
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(pt)) <> 0;
end;

function TJvExSplitter.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExSplitter.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExSplitter.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExSplitter.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

function TJvExSplitter.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

// 25.09.2007 - SESS:
// I have done this because TextChanged wasn't fired as expected.
// I still don't shure if this problem is only for this reintroduced
// method because the way LCL treats Caption or will have the same
// problem with other reintroduced methods. So far, I tested some
// other events and seems not.
procedure TJvExSplitter.SetCaption(Value: TCaption);
begin
  inherited Caption := Value;
  TextChanged;
end;

procedure TJvExSplitter.WndProc(var Msg: TLMessage);
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  case Msg.Msg of
    {
    // TODO: do we need this? I think not...
    CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    }
    CM_DIALOGCHAR:
      with TCMDialogChar(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    // LCL doesn't send this message but left it in case
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    // LCL doesn't send this message but left it in case
    //CM_PARENTFONTCHANGED:
    //  ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
  else
    inherited WndProc(Msg);
  end;
end;

//============================================================================

end.
