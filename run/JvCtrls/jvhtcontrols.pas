{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvHTControls.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Andrei Prygounkov <a dott prygounkov att gmx dott de>
CopyRight (c) 1999, 2002 Andrei Prygounkov
All Rights Reserved.

Contributor(s):
  Maciej Kaczkowski
  Timo Tegtmeier
  Andreas Hausladen

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Description:
  HT Controls

Known Issues:
Maciej Kaczkowski:
  [X] alignment not work correctly on JvHTButtonGlyph
  [X] not tested on BCB & Kylix
  [X] hyperlink work only whet alignment is left

Some information about coding:
  [?] If you want use few times function <ALIGN> you must use before next <ALIGN> function <BR>

Changes:
========
Peter Thornqvist:
  2004-01-279
    + Moved implementations to TJvCustomXXX classed
    + Now the registered controls only publish properties and events
Andrй Snepvangers:
  2004-01-06
      VisualCLX compatible version
Maciej Kaczkowski:
  2003-09-16
  [+] <BR> - new line
  [+] <HR> - horizontal line
  [+] <S> and </S> - StrikeOut
  [+] Multiline for JvHTListBox, JvHTComboBox, TJvHTButton
  [+] You can change Height of JvHTComboBox
  [+] Tags: &amp; &quot; &reg; &copy; &trade; &nbsp; &lt; &gt;
  [+] <ALIGN [CENTER, LEFT, Right]>
  [*] <C:color> was changed to ex.: <FONT COLOR="clRed" BGCOLOR="clWhite">
      </FONT>
  [*] procedure ItemHTDrawEx - rewrited
  [*] function ItemHTPlain - optimized

  2003-09-23
  [*] fixed problem with <hr><br> - just use <hr>
  [-] fixed problem with inserting htcombobox on form
  [-] variable height is not work in design time, to use this put in code ex.:
      htcombobox1.SetHeight(40)
    to read height
      Value := htcombobox1.GetItemHeight;
  [-] Removed (var PlainItem: string) from header ItemHTDrawEx;
  [-] Alignment from TJvHTLabel was removed
  [+] SelectedColor, SelectedTextColor from JvMultilineListBox was moved to
      JvHTListBox and JvHTComboBox as ColorHighlight and ColorHighlightText

  2003-09-27
  [-] fixed problem transparent color on JvHTlabel
  [-] fixed problem with layout on JvHTlabel
  [*] when TJvHTlabel is not enabled has pseudo 3D color
  [+] ColorDisabledText (JvHTcombobox, JvHTlistbox) was moved from
      jvmultilinelistbox
  [-] fixed vertical scroll on JvHTlistbox
  [-] minor bugs fixed

  2003-10-04
  [-] JVCL 3.0 compatibility

  2003-10-09
  [-] Removed +1 pixel from each line (place for <hr>) to save compatibility
      with other labels
  [*] reorganized <ALIGN> function
  [+] Added tag &euro; (non-standard but useful)
  [+] Added <A HREF="%s"> </A> for hyper link where %s is linkname
      but work only when alignment is left
  [+] Added to TJvHTLabel: OnHyperLinkClick(Sender; LinkText)
  [+] Added <IND="%d"> where %d is indention from left

  2003-10-11
  [*] fixed <A HREF> with alignment but work only when autosize=True
  [*] fixed probem with autosize when alignment not left
  [+] Added <A HREF> to JvHTListBox but the same problem with hyperlinks
      when alignement is not left (need to rebuild the ItemHTDrawEx draw
      function)
-----------------------------------------------------------------------------}
// $Id$

unit JvHtControls;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, {LMessages,} Types,
  SysUtils, Classes, Graphics, {Contnrs,} Controls, StdCtrls, Dialogs, Forms,
  JvJVCLUtils {JvDataSourceIntf, JvExStdCtrls} ;

const
  DefaultSuperSubScriptRatio: Double = 0.67;

type
(*********** NOT PORTED ************
  TJvCustomListBoxDataConnector = class(TJvFieldDataConnector)
  private
    FListBox: TCustomListBox;
    FMap: TList;
    FRecNoMap: TBucketList;
  protected
    procedure Populate; virtual;
    procedure ActiveChanged; override;
    procedure RecordChanged; override;
    property ListBox: TCustomListBox read FListBox;
  public
    constructor Create(AListBox: TCustomListBox);
    destructor Destroy; override;

    procedure GotoCurrent;
  end;
************************************)

  TJvHyperLinkClickEvent = procedure(Sender: TObject; LinkName: string) of object;

  { TJvCustomHTListBox }

  TJvCustomHTListBox = class(TCustomListBox{TJvExCustomListBox})
  private
    //FDataConnector: TJvCustomListBoxDataConnector;
    FOnHyperLinkClick: TJvHyperLinkClickEvent;
    FHideSel: Boolean;
    FColorHighlight: TColor;
    FColorHighlightText: TColor;
    FColorDisabledText: TColor;
    //FDataConnector: TJvCustomListBoxDataConnector;
    FSuperSubScriptRatio: Double;
    //procedure SetDataConnector(AValue: TJvCustomListBoxDataConnector);
    procedure SetHideSel(Value: Boolean);
    function GetPlainItems(Index: Integer): string;
    //procedure SetDataConnector(const Value: TJvCustomListBoxDataConnector);
    function ISuperSuperSubScriptRatioStored: Boolean;
    procedure SetSuperSubScriptRation(const Value: Double);
  protected
    //function CreateDataConnector: TJvCustomListBoxDataConnector; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure FontChanged(Sender: TObject); override;
    //procedure Loaded; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    //procedure CMChanged(var Message: TLMessage); message CM_CHANGED;

    property HideSel: Boolean read FHideSel write SetHideSel default false;
    property SuperSubScriptRatio: Double read FSuperSubScriptRatio write SetSuperSubScriptRation stored ISuperSuperSubScriptRatioStored;

    property ColorHighlight: TColor read FColorHighlight write FColorHighlight;
    property ColorHighlightText: TColor read FColorHighlightText write FColorHighlightText;
    property ColorDisabledText: TColor read FColorDisabledText write FColorDisabledText;
    property OnHyperLinkClick: TJvHyperLinkClickEvent read FOnHyperLinkClick write FOnHyperLinkClick;
    //property DataConnector: TJvCustomListBoxDataConnector read FDataConnector write SetDataConnector;
  public
    constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
    procedure MeasureItem(Index: Integer; var AHeight: Integer); override;
    property PlainItems[Index: Integer]: string read GetPlainItems;
  end;

  TJvHTListBox = class(TJvCustomHTListBox)
  published
    property HideSel;
    property OnHyperLinkClick;

    property Align;
    property BorderStyle;
    property Color;
    property ColorHighlight;
    property ColorHighlightText;
    property ColorDisabledText;
    property Columns;
    property DragCursor;
    property AutoSize;
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    //property IntegralHeight;
    //property ItemHeight;
    property Items;
    property MultiSelect;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property SuperSubScriptRatio;
    //property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    //property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    //property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property Anchors;
    property Constraints;

    //property DataConnector;
  end;

  { TJvCustomHTComboBox }

  TJvCustomHTComboBox = class(TCustomComboBox{TJvExCustomComboBox})
  private
    FHideSel: Boolean;
    //FDropWidth: Integer;
    FColorHighlight: TColor;
    FColorHighlightText: TColor;
    FColorDisabledText: TColor;
    FSuperSubScriptRatio: Double;
    procedure SetHideSel(Value: Boolean);
    function GetPlainItems(Index: Integer): string;
    //procedure SetDropWidth(ADropWidth: Integer);
    function ISuperSuperSubScriptRatioStored: Boolean;
    procedure SetSuperSubScriptRation(const Value: Double);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure MeasureItem(Index: Integer; var TheHeight: Integer); override;
    property HideSel: Boolean read FHideSel write SetHideSel default false;
    //property DropWidth: Integer read FDropWidth write SetDropWidth;
    property ColorHighlight: TColor read FColorHighlight write FColorHighlight default clHighlight;
    property ColorHighlightText: TColor read FColorHighlightText write FColorHighlightText default clHighlightText;
    property ColorDisabledText: TColor read FColorDisabledText write FColorDisabledText default clGrayText;
    property SuperSubScriptRatio: Double read FSuperSubScriptRatio write SetSuperSubScriptRation stored ISuperSuperSubScriptRatioStored;
  public
    constructor Create(AOwner: TComponent); override;
    property PlainItems[Index: Integer]: string read GetPlainItems;
  end;

  TJvHTComboBox = class(TJvCustomHTComboBox)
  published
    property Anchors;
    property HideSel;
    //property DropWidth;
    property ColorHighlight;
    property ColorHighlightText;
    property ColorDisabledText;
    property Color;
    // property Style;
    property AutoSize;
    property DragCursor;
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    // property ItemHeight;
    property Items;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property SuperSubScriptRatio;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    // property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    // property OnMeasureItem;
    property OnStartDrag;
    property Constraints;
  end;

  TJvHTLabelMouseButtons = set of TMouseButton;

  { TJvCustomHTLabel }

  TJvCustomHTLabel = class(TCustomLabel{TJvExCustomLabel})
  private
    FHyperlinkHovered: Boolean;
    FOnHyperLinkClick: TJvHyperLinkClickEvent;
    FMouseX, FMouseY: Integer;
    FHyperLinkMouseButtons: TJvHTLabelMouseButtons;
    FSuperSubScriptRatio: Double;
    function IsSuperSuperSubScriptRatioStored: Boolean;
    procedure SetSuperSubScriptRatio(const Value: Double);
  protected
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer;
      {%H-}WithThemeSpace: Boolean); override;
    procedure CalculateSize(MaxWidth: integer; out NeededWidth, NeededHeight: integer);
    function ComputeLayoutRect: TRect;
    procedure FontChanged(Sender: TObject); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure PrepareCanvas;

    property HyperLinkMouseButtons: TJvHTLabelMouseButtons read FHyperLinkMouseButtons write FHyperLinkMouseButtons default [mbLeft];
    property OnHyperLinkClick: TJvHyperLinkClickEvent read FOnHyperLinkClick write FOnHyperLinkClick;
    property SuperSubScriptRatio: Double read FSuperSubScriptRatio write SetSuperSubScriptRatio stored IsSuperSuperSubScriptRatioStored;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  end;

  TJvHTLabel = class(TJvCustomHTLabel)
  private
    procedure IgnoreWordWrap(Reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler); override; // ignore former published WordWrap
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption;
    property Color;
    property DragCursor;
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    // property ShowAccelChar;   not supported
    property ShowHint;
    property SuperSubScriptRatio;
    property Transparent;
    property Visible;
    // property WordWrap;   not supported
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property Layout;
    property Constraints;
    property HyperLinkMouseButtons;
    property OnHyperLinkClick;
  end;

{ example for Text parameter : 'Item 1 <b>bold</b> <i>italic ITALIC <br><FONT COLOR="clRed">red <FONT COLOR="clgreen">green <FONT COLOR="clblue">blue </i>' }

procedure ItemHTDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: LCLType.TOwnerDrawState; const Text: string; out Width: Integer;
  CalcType: TJvHTMLCalcType;  MouseX, MouseY: Integer; out MouseOnLink: Boolean;
  var LinkName: string; SuperSubScriptRatio: Double; Scale: Integer = 100);

procedure ItemHTDraw(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100);

procedure ItemHTDrawHL(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; MouseX, MouseY: Integer; SuperSubScriptRatio: Double;
  Scale: Integer = 100);

function ItemHTPlain(const Text: string): string;

function ItemHTExtent(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100): TSize;

function ItemHTWidth(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100): Integer;

function ItemHTHeight(Canvas: TCanvas; const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100): Integer;

function PrepareText(const A: string): string; deprecated;


implementation

const
  cMAILTO = 'MAILTO:';
  cURLTYPE = '://';

procedure ExecuteHyperlink(Sender: TObject; HyperLinkClick: TJvHyperLinkClickEvent; const LinkName: string);
begin
  if (Pos(cURLTYPE, LinkName) > 0) or // ftp:// http://
     (Pos(cMAILTO, UpperCase(LinkName)) > 0) then // mailto:name@server.com
    //ShellExecute(0, 'open', PChar(LinkName), nil, nil, SW_NORMAL);
    OpenURL(LinkName);
  if Assigned(HyperLinkClick) then
    HyperLinkClick(Sender, LinkName);
end;

function PrepareText(const A: string): string;
begin
  Result := HTMLPrepareText(A);
end;

// Made Width and MouseOnLink out parameters (instead of var) to silence
// the compiler
procedure ItemHTDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: LCLType.TOwnerDrawState; const Text: string; out Width: Integer;
  CalcType: TJvHTMLCalcType; MouseX, MouseY: Integer; out MouseOnLink: Boolean;
  var LinkName: string; SuperSubScriptRatio: Double; Scale: Integer = 100);
begin
  HTMLDrawTextEx(Canvas, Rect, State, Text, Width, CalcType, MouseX, MouseY, MouseOnLink, LinkName, SuperSubScriptRatio, Scale);
end;

// Made this a procedure because the result in the original function was not
// set
procedure ItemHTDraw(Canvas: TCanvas; Rect: TRect; const State: LCLType.TOwnerDrawState;
  const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100);
begin
  HTMLDrawText(Canvas, Rect, State, Text, SuperSubScriptRatio, Scale);
end;

// Made this a procedure because the result in the original function was not
// set
procedure ItemHTDrawHL(Canvas: TCanvas; Rect: TRect; const State: LCLType.TOwnerDrawState;
  const Text: string; MouseX, MouseY: Integer; SuperSubScriptRatio: Double;
  Scale: Integer = 100);
begin
  HTMLDrawTextHL(Canvas, Rect, State, Text, MouseX, MouseY, SuperSubScriptRatio, Scale);
end;

function ItemHTPlain(const Text: string): string;
begin
  Result := HTMLPlainText(Text);
end;

function ItemHTExtent(Canvas: TCanvas; Rect: TRect; const State: LCLType.TOwnerDrawState;
  const Text: string; SuperSubScriptRatio: Double; Scale: Integer = 100): TSize;
begin
  Result := HTMLTextExtent(Canvas, Rect, State, Text, SuperSubScriptRatio, Scale);
end;

function ItemHTWidth(Canvas: TCanvas; Rect: TRect;
  const State: LCLType.TOwnerDrawState; const Text: string;
  SuperSubScriptRatio: Double; Scale: Integer = 100): Integer;
begin
  Result := HTMLTextWidth(Canvas, Rect, State, Text, SuperSubScriptRatio, Scale);
end;

function ItemHTHeight(Canvas: TCanvas; const Text: string; SuperSubScriptRatio: Double;
  Scale: Integer = 100): Integer;
begin
  Result := HTMLTextHeight(Canvas, Text, SuperSubScriptRatio, Scale);
end;

function IsHyperLinkPaint(Canvas: TCanvas; Rect: TRect; const State: LCLType.TOwnerDrawState;
  const Text: string; MouseX, MouseY: Integer; var HyperLink: string): Boolean;
var
  W: Integer;
begin
  ItemHTDrawEx(
    Canvas, Rect, State, Text, W, htmlShow, MouseX, MouseY,
    Result, HyperLink, DefaultSuperSubScriptRatio
  );
end;

function IsHyperLink(Canvas: TCanvas; Rect: TRect; const Text: string;
  MouseX, MouseY: Integer; var HyperLink: string): Boolean;
var
  W: Integer;
begin
  ItemHTDrawEx(
    Canvas, Rect, [], Text, W, htmlHyperLink, MouseX, MouseY,
    Result, HyperLink, DefaultSuperSubScriptRatio
  );
end;


//=== { TJvCustomListBoxDataConnector } ======================================

(*
constructor TJvCustomListBoxDataConnector.Create(AListBox: TCustomListBox);
begin
  inherited Create;
  FListBox := AListBox;
  FRecNoMap := TBucketList.Create;
  FMap := TList.Create;
end;

destructor TJvCustomListBoxDataConnector.Destroy;
begin
  FMap.Free;
  FRecNoMap.Free;
  inherited Destroy;
end;

procedure TJvCustomListBoxDataConnector.GotoCurrent;
begin
  if Field.IsValid and (FListBox.ItemIndex <> -1) then
    DataSource.RecNo := Integer(FMap[FListBox.ItemIndex]);
end;

procedure TJvCustomListBoxDataConnector.ActiveChanged;
begin
  Populate;
  inherited ActiveChanged;
end;

procedure TJvCustomListBoxDataConnector.Populate;
var
  Index: Integer;
begin
  FMap.Clear;
  FRecNoMap.Clear;
  FListBox.Items.BeginUpdate;
  try
    FListBox.Items.Clear;
    if Field.IsValid then
    begin
      DataSource.BeginUpdate;
      try
        DataSource.First;
        while not DataSource.Eof do
        begin
          Index := FListBox.Items.Add(Field.AsString);
          FMap.Add(TObject(DataSource.RecNo));
          FRecNoMap.Add(TObject(DataSource.RecNo), TObject(Index));
          DataSource.Next;
        end;
      finally
        DataSource.EndUpdate;
      end;
      if FRecNoMap.Find(TObject(DataSource.RecNo), Pointer(Index)) then
        FListBox.ItemIndex := Index;
    end;
  finally
    FListBox.Items.EndUpdate;
  end;
end;

procedure TJvCustomListBoxDataConnector.RecordChanged;
var
  Index: Integer;
begin
  if Field.IsValid then
  begin
    if FListBox.Items.Count <> DataSource.RecordCount then
      Populate
    else
      if FRecNoMap.Find(TObject(DataSource.RecNo), Pointer(Index)) then
      begin
        FListBox.Items[Index] := Field.AsString;
        FListBox.ItemIndex := Index;
      end;
  end;
end;
*)

//=== { TJvCustomHTListBox } =================================================

constructor TJvCustomHTListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FDataConnector := CreateDataConnector;
  Style := lbOwnerDrawVariable;
  FColorHighlight := clHighlight;
  FColorHighlightText := clHighlightText;
  FColorDisabledText := clGrayText;
  FSuperSubScriptRatio := DefaultSuperSubScriptRatio;
end;

//destructor TJvCustomHTListBox.Destroy;
//begin
//  FDataConnector.Free;
//  inherited Destroy;
//end;

//procedure TJvCustomHTListBox.Loaded;
//begin
//  inherited Loaded;
//  DataConnector.Reset;
//end;

//procedure TJvCustomHTListBox.CMChanged(var Message: TLMessage);
//begin
//  inherited;
//  DataConnector.GotoCurrent;
//end;

procedure TJvCustomHTListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  if LCLType.odSelected in State then
  begin
   Canvas.Brush.Color := ColorHighlight;
   Canvas.Font.Color := ColorHighlightText;
  end;
  if not Enabled then
    Canvas.Font.Color := ColorDisabledText;

  Canvas.FillRect(Rect);
  Inc(Rect.Left, 2);
  ItemHTDraw(Canvas, Rect, State, Items[Index], SuperSubScriptRatio);
end;

procedure TJvCustomHTListBox.MeasureItem(Index: Integer; var AHeight: Integer);
begin
  AHeight := ItemHTHeight(Canvas, Items[Index], SuperSubScriptRatio);
end;

//function TJvCustomHTListBox.CreateDataConnector: TJvCustomListBoxDataConnector;
//begin
//  Result := TJvCustomListBoxDataConnector.Create(Self);
//end;

procedure TJvCustomHTListBox.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  if not Assigned(Canvas) then
    Exit; // VisualCLX needs this
  Canvas.Font := Font;
  ItemHeight := CanvasMaxTextHeight(Canvas);
end;

//procedure TJvCustomHTListBox.SetDataConnector(const Value: TJvCustomListBoxDataConnector);
//begin
//  if Value <> FDataConnector then
//    FDataConnector.Assign(Value);
//end;

procedure TJvCustomHTListBox.SetHideSel(Value: Boolean);
begin
  FHideSel := Value;
  Invalidate;
end;

procedure TJvCustomHTListBox.SetSuperSubScriptRation(const Value: Double);
begin
  if FSuperSubScriptRatio <> Value then
  begin
    FSuperSubScriptRatio := Value;
    Invalidate;
  end;
end;

function TJvCustomHTListBox.GetPlainItems(Index: Integer): string;
begin
  Result := ItemHTPlain(Items[Index]);
end;

function TJvCustomHTListBox.ISuperSuperSubScriptRatioStored: Boolean;
begin
  Result := FSuperSubScriptRatio <> DefaultSuperSubScriptRatio;
end;

procedure TJvCustomHTListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  LinkName: string = '';
  State: TOwnerDrawState;
  I: Integer;
begin
  inherited MouseMove(Shift,X,Y);
  I := Self.ItemAtPos(Point(X, Y), True);
  if I = -1 then
    Exit;
  R := Self.ItemRect(I);
  State := [];
  if Self.Selected[I] then
  begin
    State := [odSelected];
    Canvas.Font.Color := FColorHighlightText;
    Canvas.Brush.Color := FColorHighlight;
  end
  else
  begin
    Canvas.Font.Color := Font.Color;
    Canvas.Brush.Color := Color;
  end;
  Inc(R.Left, 2);
  if IsHyperLinkPaint(Canvas, R, State, Items[I], X, Y, LinkName) then
    Cursor := crHandPoint
  else
    Cursor := crDefault;
end;

procedure TJvCustomHTListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  R: TRect;
  LinkName: string = '';
  State: TOwnerDrawState;
  I: Integer;
begin
  inherited MouseUp(Button,Shift, X, Y);
  I := Self.ItemAtPos(Point(X, Y), True);
  if I <> -1 then
  begin
    R := Self.ItemRect(I);
    State := [];
    if Self.Selected[I] then
    begin
      State := [odSelected];
      Canvas.Font.Color := ColorHighlightText
    end
    else
      Canvas.Font.Color := Font.Color;
    Inc(R.Left, 2);
    if IsHyperLinkPaint(Canvas, R, State, Items[I], X, Y, LinkName) then
      ExecuteHyperlink(Self, FOnHyperLinkClick, LinkName);
  end;
end;


//=== { TJvCustomHTComboBox } ================================================

constructor TJvCustomHTComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawVariable;
  FColorHighlight := clHighlight;
  FColorHighlightText := clHighlightText;
  FColorDisabledText := clGrayText;
  FSuperSubScriptRatio := DefaultSuperSubScriptRatio;
end;

procedure TJvCustomHTComboBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  if odSelected in State then
  begin
    Canvas.Brush.Color := ColorHighlight;
    Canvas.Font.Color  := ColorHighlightText;
  end;
  if not Enabled then
    Canvas.Font.Color := ColorDisabledText;

  Canvas.FillRect(Rect);
  Inc(Rect.Left, 2);
  ItemHTDraw(Canvas, Rect, State, Items[Index], SuperSubScriptRatio);
end;

procedure TJvCustomHTComboBox.MeasureItem(Index: Integer; var TheHeight: Integer
  );
begin
  if Index = -1 then
    inherited
  else
    TheHeight := ItemHTHeight(Canvas, Items[Index], SuperSubScriptRatio);
end;

(*
function TJvCustomHTComboBox.GetHeight: Integer;
begin
  Result := SendMessage(Self.Handle, CB_GETITEMHEIGHT, -1, 0);
end;

procedure TJvCustomHTComboBox.SetHeight(Value: Integer);
begin
  SendMessage(Self.Handle, CB_SETITEMHEIGHT, -1, Value);
end;
*)

procedure TJvCustomHTComboBox.SetHideSel(Value: Boolean);
begin
  FHideSel := Value;
  Invalidate;
end;

procedure TJvCustomHTComboBox.SetSuperSubScriptRation(const Value: Double);
begin
  if FSuperSubScriptRatio <> Value then
  begin
    FSuperSubScriptRatio := Value;
    Invalidate;
  end;
end;

function TJvCustomHTComboBox.GetPlainItems(Index: Integer): string;
begin
  Result := ItemHTPlain(Items[Index]);
end;

function TJvCustomHTComboBox.ISuperSuperSubScriptRatioStored: Boolean;
begin
  Result := FSuperSubScriptRatio <> DefaultSuperSubScriptRatio;
end;

{procedure TJvCustomHTComboBox.CreateWnd;
var
  Tmp: Integer;
begin
  inherited CreateWnd;
  if DropWidth = 0 then
    DropWidth := Width
  else
  begin
    Tmp := DropWidth;
    DropWidth := 0;
    DropWidth := Tmp;
  end;
end;

procedure TJvCustomHTComboBox.SetDropWidth(ADropWidth: Integer);
begin
  if FDropWidth <> ADropWidth then
  begin
    FDropWidth := ADropWidth;
    Perform(CB_SETDROPPEDWIDTH, FDropWidth, 0);
  end;
end;}


//=== { TJvCustomHTLabel } ===================================================

constructor TJvCustomHTLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHyperLinkMouseButtons := [mbLeft];
  FSuperSubScriptRatio := DefaultSuperSubScriptRatio;
end;

procedure TJvCustomHTLabel.FontChanged(Sender: TObject);
begin
  inherited;
  AdjustSize;
end;

function TJvCustomHTLabel.IsSuperSuperSubScriptRatioStored: Boolean;
begin
  Result := FSuperSubScriptRatio <> DefaultSuperSubScriptRatio;
end;

procedure TJvCustomHTLabel.PrepareCanvas;
begin
  Canvas.Lock;
  try
    Canvas.Font := Font;
    Canvas.Brush.Color := Color;
  finally
    Canvas.Unlock;
  end;
end;

{ This code is copied from TCustomLabel.
  Could be avoided if CalculateSize were virtual. }
procedure TJvCustomHTLabel.CalculatePreferredSize(
  var PreferredWidth, PreferredHeight: integer; WithThemeSpace: Boolean);
var
  AWidth: Integer;
begin
  if (Parent = nil) or (not Parent.HandleAllocated) then Exit;
  if WidthIsAnchored and WordWrap then
    AWidth := Width
  else
    AWidth := 10000;
  AWidth := Constraints.MinMaxWidth(AWidth);
  CalculateSize(AWidth,PreferredWidth,PreferredHeight);
end;

procedure TJvCustomHTLabel.CalculateSize(MaxWidth: integer;
  out NeededWidth, NeededHeight: integer);
begin
  Canvas.Handle;
  Canvas.Font.Assign(Font);
  NeededHeight := ItemHTHeight(Canvas, Caption, SuperSubScriptRatio);
  NeededWidth := ItemHTWidth(Canvas, Bounds(0, 0, 0, 0), [], Caption, SuperSubScriptRatio);
end;

function TJvCustomHTLabel.ComputeLayoutRect: TRect;
var
  W, H: Integer;
begin
  Result := ClientRect;
  CalculateSize(Width, W, H);
  case Alignment of
    taLeftJustify:
      ;
    taRightJustify:
      Result.Left := Result.Right - W;
    taCenter:
      Result.Left := (Result.Left + Result.Right - W) div 2;
  end;
  case Layout of
    tlTop:
      ;
    tlBottom:
      Result.Top := Result.Bottom - H;
    tlCenter:
      Result.Top := (Result.Top + Result.Bottom - H) div 2;
  end;
end;

procedure TJvCustomHTLabel.SetSuperSubScriptRatio(const Value: Double);
begin
  if FSuperSubScriptRatio <> Value then
  begin
    FSuperSubScriptRatio := Value;
    Invalidate;
  end;
end;

procedure TJvCustomHTLabel.Paint;
var
  Rect: TRect;
  PaintText: String;
begin
  PaintText := GetLabelText;
  PrepareCanvas;
  if Transparent then
    Canvas.Brush.Style := bsClear
  else
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
  end;
  Rect := ComputeLayoutRect;
  Canvas.Font.Style := []; // only font name and font size is important
  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    ItemHTDrawHL(Canvas, Rect, [odDisabled], PaintText, FMouseX, FMouseY, SuperSubScriptRatio);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    ItemHTDrawHL(Canvas, Rect, [odDisabled], PaintText, FMouseX, FMouseY, SuperSubScriptRatio);
  end
  else
    ItemHTDrawHL(Canvas, Rect, [], PaintText, FMouseX, FMouseY, SuperSubScriptRatio);
end;

procedure TJvCustomHTLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  LinkName: string = '';
  LastHovered: Boolean;
begin
  FMouseX := X;
  FMouseY := Y;
  inherited MouseMove(Shift, X, Y);

  LastHovered := FHyperlinkHovered;
  Canvas.Lock;
  try
    PrepareCanvas;
    R := ComputeLayoutRect;
    FHyperlinkHovered := IsHyperLink(Canvas, R, Caption, X, Y, LinkName);
  finally
    Canvas.Unlock;
  end;

  if FHyperlinkHovered then
    Cursor := crHandPoint
  else
    Cursor := crDefault;

  if FHyperlinkHovered <> LastHovered then
  begin
    if Transparent then
      Invalidate
    else
      Paint;
  end;
end;

procedure TJvCustomHTLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  LinkName: string = '';
begin
  FMouseX := X;
  FMouseY := Y;
  inherited MouseUp(Button, Shift, X, Y);
  if Button in FHyperLinkMouseButtons then
  begin
    R := ClientRect;
    case Layout of
      tlTop:
        ;
      tlBottom:
        R.Top := R.Bottom - ItemHTHeight(Canvas, Caption, SuperSubScriptRatio);
      tlCenter:
        R.Top := (R.Bottom - R.Top - ItemHTHeight(Canvas, Caption, SuperSubScriptRatio)) div 2;
    end;
    if IsHyperLink(Canvas, R, Caption, X, Y, LinkName) then
      ExecuteHyperlink(Self, FOnHyperLinkClick, LinkName);
  end;
end;

procedure TJvCustomHTLabel.MouseLeave;
begin
  FMouseX := 0;
  FMouseY := 0;
  inherited MouseLeave;
  if FHyperlinkHovered then
  begin
    FHyperlinkHovered := False;
    if Transparent then
      Invalidate
    else
      Paint;
  end;
end;


{ TJvHTLabel }

procedure TJvHTLabel.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('WordWrap', @IgnoreWordWrap, nil, False);
end;

procedure TJvHTLabel.IgnoreWordWrap(Reader: TReader);
begin
  Reader.ReadBoolean;
end;


end.

