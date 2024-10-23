{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvLookup.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

Contributor(s):
  Polaris Software

Lazarus port: Michał Gawrycki

Copyright (c) 1995,1997 Borland International
Portions copyright (c) 1995, 1996 AO ROSNO
Portions copyright (c) 1997, 1998 Master-Bank

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvDBLookup;

{.$I jvcl.inc}
{$mode objfpc}{$H+}

interface

uses
  LCLType, LCLIntf, LMessages, LCLVersion,
  Variants, Classes, Graphics, Controls, Forms, DB, DBCtrls, Themes,
  JvThemes, JvDBUtils;

const
  // (rom) renamed
  DefFieldsDelimiter = ',';

type
  TCloseUpEvent = procedure(Sender: TObject; Accept: Boolean) of object;

  TLookupListStyle = (lsFixed, lsDelimited);
  TJvLookupControl = class;
  TGetImageEvent = procedure(Sender: TObject; IsEmpty: Boolean;
    var Graphic: TGraphic; var TextMargin: Integer) of object;
  TGetImageIndexEvent = procedure(Sender: TObject; IsEmpty: Boolean;
    var ImageIndex: Integer; var TextMargin: Integer) of object;

  TJvDataSourceLink = class(TJvDataLink)
  private
    FDataControl: TJvLookupControl;
  protected
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure FocusControl(const Field: TField); override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  end;

  TJvLookupSourceLinkMethod = procedure of object;

  TLookupSourceLink = class(TDataLink)
  private
    FDataControl: TJvLookupControl;
  protected
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled({%H-}Distance: Integer); override;
  end;

  { TJvLookupControl }

  TJvLookupControl = class(TCustomControl)
  private
    FLookupSource: TDataSource;
    FDataLink: TJvDataSourceLink;
    FLookupLink: TLookupSourceLink;
    FDataFieldName: string;
    FLookupFieldName: string;
    FLookupDisplay: string;
    FDisplayIndex: Integer;
    FDataField: TField;
    FMasterField: TField;
    FKeyField: TField;
    FDisplayField: TField;
    FListFields: TList;
    FOnGetImageIndex: TGetImageIndexEvent;
    FValue: string;
    FDisplayValue: string;
    FDisplayEmpty: string;
    FSearchText: string;
    FEmptyValue: string;
    FEmptyStrIsNull: Boolean;
    FEmptyItemColor: TColor;
    FListActive: Boolean;
    FPopup: Boolean;
    FFocused: Boolean;
    FLocate: TJvLocateObject;
    FIndexSwitch: Boolean;
    FIgnoreCase: Boolean;
    FItemHeight: Integer;
    FFieldsDelimiter: Char;
    FListStyle: TLookupListStyle;
    FLookupFormat: string;
    FOnChange: TNotifyEvent;
    FOnGetImage: TGetImageEvent;
    FLookupMode: Boolean;
    FUseRecordCount: Boolean;
    FRightTrimmedLookup: Boolean;
    FImageList: TImageList;
    procedure CheckNotFixed;
    procedure SetImageList(AValue: TImageList);
    procedure SetLookupMode(Value: Boolean);
    function GetKeyValue: Variant;
    procedure SetKeyValue(const Value: Variant);
    function CanModify: Boolean;
    procedure CheckNotCircular;
    procedure DataLinkActiveChanged;
    procedure CheckDataLinkActiveChanged;
    function GetBorderSize: Integer;
    function GetField: TField;
    function GetDataSource: TDataSource;
    function GetLookupField: string;
    function GetLookupSource: TDataSource;
    function GetTextHeight: Integer;
    function DefaultTextHeight: Integer;
    function GetItemHeight: Integer;
    function LocateKey: Boolean;
    function LocateDisplay: Boolean;
    function ValueIsEmpty(const S: string): Boolean;
    function StoreEmpty: Boolean;
    procedure ProcessSearchKey(Key: TUTF8Char);
    procedure UpdateKeyValue;
    procedure SelectKeyValue(const Value: string);
    procedure SetDataFieldName(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetDisplayEmpty(const Value: string);
    procedure SetEmptyValue(const Value: string);
    procedure SetEmptyStrIsNull(const Value: Boolean);
    procedure SetEmptyItemColor(Value: TColor);
    procedure SetLookupField(const Value: string);
    procedure SetValueKey(const Value: string);
    procedure SetValue(const Value: string);
    procedure SetDisplayValue(const Value: string);
    procedure SetListStyle(Value: TLookupListStyle); virtual;
    procedure SetFieldsDelimiter(Value: Char); virtual;
    procedure SetLookupDisplay(const Value: string);
    procedure SetLookupFormat(const Value: string);
    procedure SetLookupSource(Value: TDataSource);
    procedure SetItemHeight(Value: Integer);
    procedure SetUseRecordCount(const Value: Boolean);
    function ItemHeightStored: Boolean;
    procedure DrawPicture(ACanvas: TCanvas; Rect: TRect; Image: TGraphic);
    procedure DrawImage(ACanvas: TCanvas; Rect: TRect; ImageIndex: Integer);
    procedure UpdateDisplayValue;
    function EmptyRowVisible: Boolean;
    procedure SetDisplayIndex(const Value: Integer);
  protected
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;
    function GetReadOnly: Boolean; virtual;
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure Change; dynamic;
    procedure KeyValueChanged; virtual;
    procedure DisplayValueChanged; virtual;
    function DoFormatLine: string;
    procedure DataLinkRecordChanged(Field: TField); virtual;
    procedure DataLinkUpdateData; virtual;
    procedure ListLinkActiveChanged; virtual;
    procedure ListLinkDataChanged; virtual;
    procedure ListLinkDataSetChanged; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetPicture({%H-}Current, Empty: Boolean; var TextMargin: Integer): TGraphic; virtual;
    function GetImageIndex({%H-}Current, Empty: Boolean; var TextMargin: Integer): Integer; virtual;
    procedure UpdateDisplayEmpty(const {%H-}Value: string); virtual;
    function SearchText(var AValue: string): Boolean;
    function GetWindowWidth: Integer;
    property DataField: string read FDataFieldName write SetDataFieldName;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DisplayEmpty: string read FDisplayEmpty write SetDisplayEmpty;
    property EmptyValue: string read FEmptyValue write SetEmptyValue stored StoreEmpty;
    property EmptyStrIsNull: Boolean read FEmptyStrIsNull write SetEmptyStrIsNull default True;
    property EmptyItemColor: TColor read FEmptyItemColor write SetEmptyItemColor default clWindow;
    property IgnoreCase: Boolean read FIgnoreCase write FIgnoreCase default True;
    property ImageList: TImageList read FImageList write SetImageList;
    property IndexSwitch: Boolean read FIndexSwitch write FIndexSwitch default True;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight stored ItemHeightStored;
    property ListStyle: TLookupListStyle read FListStyle write SetListStyle default lsFixed;
    property FieldsDelimiter: Char read FFieldsDelimiter write SetFieldsDelimiter default DefFieldsDelimiter;
    property LookupDisplay: string read FLookupDisplay write SetLookupDisplay;
    property LookupDisplayIndex: Integer read FDisplayIndex write SetDisplayIndex default 0;
    property LookupField: string read GetLookupField write SetLookupField;
    property LookupFormat: string read FLookupFormat write SetLookupFormat;
    property LookupSource: TDataSource read GetLookupSource write SetLookupSource;
    property ParentColor default False;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property TabStop default True;
    property UseRecordCount: Boolean read FUseRecordCount write SetUseRecordCount default False;
    property Value: string read FValue write SetValue stored False;
    property DisplayValue: string read FDisplayValue write SetDisplayValue stored False;
    property KeyValue: Variant read GetKeyValue write SetKeyValue stored False;
    property RightTrimmedLookup: Boolean read FRightTrimmedLookup write FRightTrimmedLookup default False;
    procedure SetFieldValue(Field: TField; const AValue: string);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnGetImage: TGetImageEvent read FOnGetImage write FOnGetImage;
    property OnGetImageIndex: TGetImageIndexEvent read FOnGetImageIndex write FOnGetImageIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearValue;
    function Locate(const SearchField: TField; const AValue: string; Exact: Boolean): Boolean;
    procedure ResetField; virtual;
    function ExecuteAction(AAction: TBasicAction): Boolean; override;
    function UpdateAction(AAction: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    function GetDefaultColor(const DefaultColorType: TDefaultColorType): TColor; override;
    property Field: TField read GetField;
  end;

  { TJvDBLookupList }

  TJvDBLookupList = class(TJvLookupControl)
  private
    FDisableChangeBounds: Boolean;
    FRecordIndex: Integer;
    FRecordCount: Integer;
    FRowCount: Integer;
    FKeySelected: Boolean;
    FTracking: Boolean;
    FTimerActive: Boolean;
    FLockPosition: Boolean;
    FSelectEmpty: Boolean;
    FMousePos: Integer;
    function GetKeyIndex: Integer;
    procedure ListDataChanged;
    procedure SelectCurrent;
    procedure SelectItemAt({%H-}X, Y: Integer);
    procedure SetRowCount(AValue: Integer);
    procedure StopTimer;
    procedure StopTracking;
    procedure TimerScroll;
    procedure UpdateScrollBar;
    procedure UpdateBufferCount(Rows: Integer);
    procedure WMCancelMode(var Msg: TLMessage); message LM_CANCELMODE;
    procedure WMNCHitTest(var Msg: TLMNCHitTest); message LM_NCHITTEST;
    procedure WMTimer(var {%H-}Msg: TLMessage); message LM_TIMER;
    procedure WMVScroll(var Msg: TLMVScroll); message LM_VSCROLL;
  protected
    procedure FontChanged(Sender: TObject); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyValueChanged; override;
    procedure DisplayValueChanged; override;
    procedure ListLinkActiveChanged; override;
    procedure ListLinkDataChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var Key: TUTF8Char); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure UpdateDisplayEmpty(const AValue: string); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure ChangeBounds(ALeft, ATop, AWidth, AHeight: integer;
      KeepBase: boolean); override;
    procedure CalculatePreferredSize(var PreferredWidth,
      PreferredHeight: integer; WithThemeSpace: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure DrawItemText(ACanvas: TCanvas; Rect: TRect;
      {%H-}Selected, IsEmpty: Boolean); virtual;
    property RowCount: Integer read FRowCount write SetRowCount stored False;
    property DisplayValue;
    property Value;
    property KeyValue;
  published
    property Align;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle default bsSingle;
    property Color;
    property DataField;
    property DataSource;
    property DisplayEmpty;
    property DragCursor;
    property DragMode;
    property EmptyItemColor;
    property EmptyValue;
    property EmptyStrIsNull;
    property Enabled;
    property FieldsDelimiter;
    property Font;
    property IgnoreCase;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property ImageList;
    property IndexSwitch;
    property ItemHeight;
    property ListStyle;
    property LookupField;
    property LookupDisplay;
    property LookupDisplayIndex;
    property LookupFormat;
    property LookupSource;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property UseRecordCount;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImage;
    property OnGetImageIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnContextPopup;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnEndDock;
    property OnStartDock;
    property OnUTF8KeyPress;
  end;

  //TJvPopupDataListWindow = class;

  TJvPopupDataList = class(TJvDBLookupList)
  private
    FCombo: TJvLookupControl;
    procedure CMHintShow(var Msg: TLMessage); message CM_HINTSHOW;
  protected
    procedure Click; override;
    procedure UTF8KeyPress(var Key: TUTF8Char); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TJvPopupDataListForm }

  TJvPopupDataListForm = class(TForm)
  private
    procedure AppDeactivate(Sender: TObject);
  protected
    FCombo: TJvLookupControl;
    FList: TJvPopupDataList;
    procedure Deactivate; override;
    procedure UTF8KeyPress(var Key: TUTF8Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoShow; override;
    procedure DoClose(var CloseAction: TCloseAction); override;
    {$IFDEF WINDOWS}
    //procedure CreateWnd; override;
    procedure WMActivate(var Message: TLMActivate); message LM_ACTIVATE;
    {$ENDIF}
  public
    constructor CreateNew(AOwner: TComponent; Num: Integer = 0); override;
  end;

  { TJvDBLookupCombo }

  TJvDBLookupCombo = class(TJvLookupControl, IJvDataControl)
  private
    FDataListForm: TJvPopupDataListForm;
    FButtonWidth: Integer;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FDropDownAlign: TDropDownAlign;
    FEscapeKeyReset: Boolean;
    FDeleteKeyClear: Boolean;
    FListVisible: Boolean;
    FPressed: Boolean;
    FTracking: Boolean;
    FAlignment: TAlignment;
    FSelImage: TPicture;
    FSelImageIndex: Integer;
    FSelMargin: Integer;
    FSelMarginImg: Integer;
    FDisplayValues: TStringList;
    FDisplayAllFields: Boolean;
    FTabSelects: Boolean;
    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;
    FLastValue: Variant;
    FInListDataSetChanged: Boolean;
    FMouseOverButton: Boolean;
    FMouseOver: Boolean;
    FWhenClosed: Int64;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure StopTracking;
    procedure TrackButton(X, Y: Integer);
    function GetMinHeight: Integer;
    function GetText: string;
    procedure InvalidateText;
    procedure UpdateCurrentImage;
    procedure PaintDisplayValues(ACanvas: TCanvas; R: TRect; ALeft: Integer);
    procedure SetFieldsDelimiter(AValue: Char); override;
    procedure SetListStyle(AValue: TLookupListStyle); override;
    function GetDisplayAllFields: Boolean;
    procedure SetDisplayAllFields(AValue: Boolean);
    function GetDisplayValues(Index: Integer): string;
    procedure CNKeyDown(var Msg: TLMKeyDown); message CN_KEYDOWN;
    procedure CMGetDataLink(var Msg: TLMessage); message CM_GETDATALINK;
    procedure WMCancelMode(var Msg: TLMessage); message LM_CANCELMODE;
    procedure WMSetCursor(var Msg: TLMSetCursor); message LM_SETCURSOR;
    procedure CMBiDiModeChanged(var Msg: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMHintShow(var Msg: TLMessage); message CM_HINTSHOW;
    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
    procedure ReadEscapeClear(Reader: TReader);
    procedure SetMouseOverButton(AValue: Boolean);
  protected
    procedure CreateWnd; override;
    procedure SetReadOnly(AValue: Boolean); override;
    function GetDropDownButtonRect: TRect;
    procedure InvalidateFrame;
    procedure InvalidateDropDownButton;
    function GetDataLink: TDataLink; virtual;
    procedure BoundsChanged; override;
    procedure EnabledChanged; override;
    procedure FontChanged(Sender: TObject); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure DoEnter; override;
    procedure Click; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetPicture(Current, Empty: Boolean; var TextMargin: Integer): TGraphic; override;
    function GetImageIndex(Current, Empty: Boolean; var TextMargin: Integer
  ): Integer; override;
    procedure UpdateFieldText;
    procedure KeyValueChanged; override;
    procedure DisplayValueChanged; override;
    procedure ListLinkActiveChanged; override;
    procedure ListLinkDataChanged; override;
    procedure ListLinkDataSetChanged; override;
    procedure DataLinkRecordChanged(AField: TField); override;
    procedure DataLinkUpdateData; override;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var Key: TUTF8Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure UpdateDisplayEmpty(const AValue: string); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetPreferredSize(var PreferredWidth, PreferredHeight: integer;
      Raw: boolean = false; WithThemeSpace: boolean = true); override;
    procedure CloseUp(Accept: Boolean); dynamic;
    procedure DropDown; virtual;
    procedure ResetField; override;
    property IsDropDown: Boolean read FListVisible;
    property ListVisible: Boolean read FListVisible;
    property Text: string read GetText;
    property DisplayValue;
    property DisplayValues[Index: Integer]: string read GetDisplayValues;
    property Value;
    property KeyValue;
  published
    property Align;
    property AutoSize;
    property DoubleBuffered;
    property BorderSpacing;
    property BorderStyle default bsSingle;
    property DropDownAlign: TDropDownAlign read FDropDownAlign write FDropDownAlign default daLeft;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property EscapeKeyReset: Boolean read FEscapeKeyReset write FEscapeKeyReset default True;
    property DeleteKeyClear: Boolean read FDeleteKeyClear write FDeleteKeyClear default True;
    property DisplayAllFields: Boolean read GetDisplayAllFields write SetDisplayAllFields default False;
    property TabSelects : Boolean read FTabSelects write FTabSelects default False;
    property Color;
    property DataField;
    property DataSource;
    property DisplayEmpty;
    property DragCursor;
    property DragMode;
    property EmptyValue;
    property EmptyStrIsNull;
    property EmptyItemColor;
    property Enabled;
    property FieldsDelimiter;
    property Font;
    property IgnoreCase;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property ImageList;
    property IndexSwitch;
    property ItemHeight;
    property ListStyle;
    property LookupField;
    property LookupDisplay;
    property LookupDisplayIndex;
    property LookupFormat;
    property LookupSource;
    property ParentColor;
    {$IF LCL_FullVersion >= 2000000}
    property ParentDoubleBuffered;
    {$IFEND}
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightTrimmedLookup;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseRecordCount;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImage;
    property OnGetImageIndex;
    property OnKeyDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnContextPopup;
    property OnEndDock;
    property OnStartDock;
    property OnUTF8KeyPress;
  end;

(*  TJvPopupDataWindow = class(TJvPopupDataList)
  private
    FEditor: TWinControl;
    FCloseUp: TCloseUpEvent;
  protected
    procedure InvalidateEditor;
    procedure Click; override;
    procedure DisplayValueChanged; override;
    function GetPicture(Current, Empty: Boolean; var TextMargin: Integer): TGraphic; override;
    procedure KeyPress(var Key: Char); override;
    procedure PopupMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CloseUp(Accept: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
    procedure Show(Origin: TPoint);
    property OnCloseUp: TCloseUpEvent read FCloseUp write FCloseUp;
  end;

  TJvDBLookupEdit = class(TCustomEditButton)
  private
    FChanging: Boolean;
    FIgnoreChange: Boolean;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FPopupOnlyLocate: Boolean;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FBeforePopupValue: Variant;
    function GetListStyle: TLookupListStyle;
    procedure SetListStyle(Value: TLookupListStyle);
    function GetFieldsDelimiter: Char;
    procedure SetFieldsDelimiter(Value: Char);
    function GetLookupDisplay: string;
    procedure SetLookupDisplay(const Value: string);
    function GetDisplayIndex: Integer;
    procedure SetDisplayIndex(Value: Integer);
    function GetLookupField: string;
    procedure SetLookupField(const Value: string);
    function GetLookupSource: TDataSource;
    procedure SetLookupSource(Value: TDataSource);
    procedure SetDropDownCount(Value: Integer);
    function GetLookupValue: string;
    procedure SetLookupValue(const Value: string);
    function GetOnGetImage: TGetImageEvent;
    procedure SetOnGetImage(Value: TGetImageEvent);
    function GetUseRecordCount: Boolean;
    procedure SetUseRecordCount(const Value: Boolean);
  protected
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure ShowPopup(Origin: TPoint); override;
    procedure HidePopup; override;
    procedure PopupChange; override;
    procedure PopupDropDown(DisableEdit: Boolean); override;
    function AcceptPopup(var Value: Variant): Boolean; override;
    procedure SetPopupValue(const Value: Variant); override;
    function GetPopupValue: Variant; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property LookupValue: string read GetLookupValue write SetLookupValue;
  published
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property ListStyle: TLookupListStyle read GetListStyle write SetListStyle default lsFixed;
    property FieldsDelimiter: Char read GetFieldsDelimiter write SetFieldsDelimiter default DefFieldsDelimiter;
    property LookupDisplay: string read GetLookupDisplay write SetLookupDisplay;
    property LookupDisplayIndex: Integer read GetDisplayIndex write SetDisplayIndex default 0;
    property LookupField: string read GetLookupField write SetLookupField;
    property LookupSource: TDataSource read GetLookupSource write SetLookupSource;
    property PopupOnlyLocate: Boolean read FPopupOnlyLocate write FPopupOnlyLocate default True;
    property Alignment;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property ButtonHint;
    property CharCase;
    //property ClickKey;
    property Color;
    property DirectInput;
    property DragCursor;
    property DragMode;
    property EditMask;
    property Enabled;
    property Font;
    //property BevelEdges;
    //property BevelInner;
    //property BevelKind default bkNone;
    //property BevelOuter;
    property Flat;
    //property ParentFlat;
    property HideSelection;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    //property ImeMode;
    //property ImeName;
    property MaxLength;
    //property OEMConvert;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    //property PopupAlign;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property UseRecordCount: Boolean read GetUseRecordCount write SetUseRecordCount default False;
    property Visible;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnGetImage: TGetImageEvent read GetOnGetImage write SetOnGetImage;
    property OnButtonClick;
    property OnChange;
    property OnClick;
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
    property OnStartDrag;
    property OnContextPopup;
    property OnEndDock;
    property OnStartDock;

    {$IFDEF COMPILER14_UP}
    property Touch;
    {$ENDIF COMPILER14_UP}
    property TextHint;
  end;
*)

implementation

uses
  DBConst, SysUtils, Math, LazUTF8, {MultiMon,}
  {JclSysInfo,}
  JvJCLUtils, JvJVCLUtils, JvTypes, JvConsts, JvResources{, JclSysUtils};

procedure CheckLookupFormat(const AFormat: string);
  { AFormat is passed to a Format function, but the only allowed
    format specifiers are %s, %S and %% }
var
  P: PChar;
begin
  P := StrScan(PChar(AFormat), '%');
  while Assigned(P) do
  begin
    Inc(P);
    if P^ = #0 then
      raise EJVCLException.CreateRes(@RsEInvalidFormatNotAllowed)
    else
    if not CharInSet(P^, ['%', 's', 'S']) then
      raise EJVCLException.CreateResFmt(@RsEInvalidFormatsNotAllowed,
        [QuotedStr('%' + P^)]);
    P := StrScan(P + 2, '%');
  end;
end;

function GetSpecifierCount(const AFormat: string): Integer;
  { GetSpecifierCount counts the nr of format specifiers in AFormat }
var
  P: PChar;
begin
  Result := 0;
  P := StrScan(PChar(AFormat), '%');
  while Assigned(P) do
  begin
    Inc(P);
    if P^ = #0 then
      Exit
    else
    if CharInSet(P^, ['s', 'S']) then
      Inc(Result);
    P := StrScan(P + 2, '%');
  end;
end;

//=== { TJvDataSourceLink } ==================================================

procedure TJvDataSourceLink.ActiveChanged;
begin
  if FDataControl <> nil then
    FDataControl.DataLinkActiveChanged;
end;

procedure TJvDataSourceLink.LayoutChanged;
begin
  if FDataControl <> nil then
    FDataControl.CheckDataLinkActiveChanged;
end;

procedure TJvDataSourceLink.RecordChanged(Field: TField);
begin
  if FDataControl <> nil then
    FDataControl.DataLinkRecordChanged(Field);
end;

procedure TJvDataSourceLink.UpdateData;
begin
  if FDataControl <> nil then
    FDataControl.DataLinkUpdateData;
end;

procedure TJvDataSourceLink.FocusControl(const Field: TField);
begin
  if (Field <> nil) and (FDataControl <> nil) and
    (Field = FDataControl.FDataField) and FDataControl.CanFocus then
    FDataControl.SetFocus;
end;

//=== { TLookupSourceLink } ==================================================

procedure TLookupSourceLink.ActiveChanged;
begin
  if FDataControl <> nil then
    FDataControl.ListLinkActiveChanged;
end;

procedure TLookupSourceLink.LayoutChanged;
begin
  if FDataControl <> nil then
    FDataControl.ListLinkActiveChanged;
end;

procedure TLookupSourceLink.DataSetChanged;
begin
  if FDataControl <> nil then
    FDataControl.ListLinkDataSetChanged;
end;

procedure TLookupSourceLink.DataSetScrolled(Distance: Integer);
begin
  if FDataControl <> nil then
    FDataControl.ListLinkDataChanged;
end;

//=== { TJvLookupControl } ===================================================

var
  SearchTickCount: Int64 = 0;

constructor TJvLookupControl.Create(AOwner: TComponent);
const
  LookupStyle = [csOpaque];
begin
  inherited Create(AOwner);
  ControlStyle := LookupStyle;
  IncludeThemeStyle(Self, [csNeedsBorderPaint]);

  ParentColor := False;
  TabStop := True;
  FFieldsDelimiter := DefFieldsDelimiter;
  FLookupSource := TDataSource.Create(Self);
  FDataLink := TJvDataSourceLink.Create;
  FDataLink.FDataControl := Self;
  FLookupLink := TLookupSourceLink.Create;
  FLookupLink.FDataControl := Self;
  FListFields := TList.Create;
  FEmptyValue := '';
  FEmptyStrIsNull := True;
  FEmptyItemColor := clWindow;
  FValue := FEmptyValue;
  FLocate := CreateLocate(nil);
  FIndexSwitch := True;
  FIgnoreCase := True;
  FUseRecordCount := False;
end;

destructor TJvLookupControl.Destroy;
begin
  FListFields.Free;
  FListFields := nil;
  if FLookupLink <> nil then
    FLookupLink.FDataControl := nil;
  FLookupLink.Free;
  FLookupLink := nil;
  if FDataLink <> nil then
    FDataLink.FDataControl := nil;
  FDataLink.Free;
  FDataLink := nil;
  FLocate.Free;
  FLocate := nil;
  inherited Destroy;
end;

function TJvLookupControl.CanModify: Boolean;
begin
  Result := FListActive and not ReadOnly and ((FDataLink.DataSource = nil) or
    (FMasterField <> nil) and FMasterField.CanModify);
end;

procedure TJvLookupControl.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TJvLookupControl.ValueIsEmpty(const S: string): Boolean;
begin
  Result := (S = FEmptyValue);
end;

function TJvLookupControl.StoreEmpty: Boolean;
begin
  Result := (FEmptyValue <> '');
end;

procedure TJvLookupControl.CheckNotFixed;
begin
  if FLookupMode then
    _DBError('SPropDefByLookup');
  if FDataLink.DataSourceFixed then
    _DBError('SDataSourceFixed');
end;

procedure TJvLookupControl.SetImageList(AValue: TImageList);
begin
  if FImageList = AValue then Exit;
  FImageList := AValue;

end;

procedure TJvLookupControl.SetLookupMode(Value: Boolean);
begin
  if FLookupMode <> Value then
    if Value then
    begin
      FMasterField := FDataField.DataSet.FieldByName(FDataField.KeyFields);
      FLookupSource.DataSet := FDataField.LookupDataSet;
      FLookupFieldName := FDataField.LookupKeyFields;
      FLookupMode := True;
      FLookupLink.DataSource := FLookupSource;
    end
    else
    begin
      FLookupLink.DataSource := nil;
      FLookupMode := False;
      FLookupFieldName := '';
      FLookupSource.DataSet := nil;
      FMasterField := FDataField;
    end;
end;

procedure TJvLookupControl.SetUseRecordCount(const Value: Boolean);
begin
  if Value <> FUseRecordCount then
  begin
    FUseRecordCount := Value;
    ListLinkActiveChanged;
    if FListActive then
      DataLinkRecordChanged(nil);
  end;
end;

function TJvLookupControl.GetKeyValue: Variant;
begin
  if ValueIsEmpty(Value) then
  begin
    if (Value = '') and FEmptyStrIsNull then
      Result := Null
    else
      Result := FEmptyValue;
  end
  else
    Result := Value;
end;

procedure TJvLookupControl.SetKeyValue(const Value: Variant);
begin
  if VarIsNull(Value) or VarIsEmpty(Value) then
    Self.Value := FEmptyValue
  else
    Self.Value := Value;
end;

procedure TJvLookupControl.CheckNotCircular;
begin
  {
  if FDataLink.Active and FDataLink.DataSet.IsLinkedTo(LookupSource) then
    _DBError(SCircularDataLink);
  }
  if FDataLink.Active and ((DataSource = LookupSource) or
    (FDataLink.DataSet = FLookupLink.DataSet)) then
    _DBError(SErrCircularDataSourceReferenceNotAllowed);
end;

procedure TJvLookupControl.CheckDataLinkActiveChanged;
var
  TestField: TField;
begin
  if FDataLink.Active and (FDataFieldName <> '') then
  begin
    TestField := FDataLink.DataSet.FieldByName(FDataFieldName);
    if FDataField <> TestField then
    begin
      FDataField := nil;
      FMasterField := nil;
      CheckNotCircular;
      FDataField := TestField;
      FMasterField := FDataField;
    end;
    DataLinkRecordChanged(nil);
  end;
end;

procedure TJvLookupControl.DataLinkActiveChanged;
begin
  FDataField := nil;
  FMasterField := nil;
  if FDataLink.Active and (FDataFieldName <> '') then
  begin
    CheckNotCircular;
    FDataField := FDataLink.DataSet.FieldByName(FDataFieldName);
    FMasterField := FDataField;
  end;
  SetLookupMode((FDataField <> nil) and (FDataField.FieldKind = fkLookup));
  DataLinkRecordChanged(nil);
end;

procedure TJvLookupControl.DataLinkRecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FMasterField) then
  begin
    if (FMasterField <> nil) and FMasterField.DataSet.Active then
      SetValueKey(FMasterField.AsString)
    else
      SetValueKey(FEmptyValue);
  end;
end;

procedure TJvLookupControl.DataLinkUpdateData;
begin
end;

function TJvLookupControl.ExecuteAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(AAction) or ((FDataLink <> nil) and
    FDataLink.ExecuteAction(AAction));
end;

function TJvLookupControl.UpdateAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(AAction) or ((FDataLink <> nil) and
    FDataLink.UpdateAction(AAction));
end;

function TJvLookupControl.UseRightToLeftAlignment: Boolean;
begin
  //Result := DBUseRightToLeftAlignment(Self, Field);
  Result := inherited UseRightToLeftAlignment;
end;

function TJvLookupControl.GetBorderSize: Integer;
begin
  Result := Height - ClientHeight;
end;

function TJvLookupControl.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TJvLookupControl.GetLookupField: string;
begin
  if FLookupMode then
    Result := ''
  else
    Result := FLookupFieldName;
end;

function TJvLookupControl.GetLookupSource: TDataSource;
begin
  if FLookupMode then
    Result := nil
  else
    Result := FLookupLink.DataSource;
end;

function TJvLookupControl.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

function TJvLookupControl.GetField: TField;
begin
  if Assigned(FDataLink) then
    Result := FDataField
  else
    Result := nil;
end;

// (rom) is this useful for other components? It seems superior.

function TJvLookupControl.DefaultTextHeight: Integer;
begin
  //Result := Screen.SystemFont.GetTextHeight('Mg'); //Canvas.TextHeight('Mg');
  Result := Font.GetTextHeight('Mg') + 4;
end;

function TJvLookupControl.GetTextHeight: Integer;
begin
  Result := Max(DefaultTextHeight, FItemHeight);
end;

procedure TJvLookupControl.KeyValueChanged;
begin
end;

procedure TJvLookupControl.DisplayValueChanged;
begin
end;

procedure TJvLookupControl.ListLinkActiveChanged;
var
  DataSet: TDataSet;
  ResultField: TField;
begin
  FListActive := False;
  FKeyField := nil;
  FDisplayField := nil;
  FListFields.Clear;
  if FLookupLink.Active and (FLookupFieldName <> '') then
  begin
    CheckNotCircular;
    DataSet := FLookupLink.DataSet;
    FKeyField := DataSet.FieldByName(FLookupFieldName);
    DataSet.GetFieldList(FListFields, FLookupDisplay);
    if FLookupMode then
    begin
      ResultField := DataSet.FieldByName(FDataField.LookupResultField);
      if FListFields.IndexOf(ResultField) < 0 then
        FListFields.Insert(0, ResultField);
      FDisplayField := ResultField;
    end
    else
    begin
      if FListFields.Count = 0 then
        FListFields.Add(FKeyField);
      if (FDisplayIndex >= 0) and (FDisplayIndex < FListFields.Count) then
        FDisplayField := TField(FListFields[FDisplayIndex])
      else
        FDisplayField := TField(FListFields[0]);
    end;
    { Reset LookupFormat if the number of specifiers > fields count
      else function Format will raise an error }
    if GetSpecifierCount(FLookupFormat) > FListFields.Count then
      FLookupFormat := '';

    FListActive := True;
  end;
  FLocate.DataSet := FLookupLink.DataSet;
end;

procedure TJvLookupControl.ListLinkDataChanged;
begin
end;

procedure TJvLookupControl.ListLinkDataSetChanged;
begin
  ListLinkDataChanged;
end;

function TJvLookupControl.LocateDisplay: Boolean;
begin
  Result := False;
  try
    Result := Locate(FDisplayField, FDisplayValue, True);
  except
  end;
end;

function TJvLookupControl.LocateKey: Boolean;
begin
  Result := False;
  try
    Result := not ValueIsEmpty(FValue) and Locate(FKeyField, FValue, True);
  except
  end;
end;

procedure TJvLookupControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then
      DataSource := nil;
    if (FLookupLink <> nil) and (AComponent = LookupSource) then
      LookupSource := nil;
    if AComponent = FMasterField then
      FMasterField := nil;
  end;
end;

function TJvLookupControl.SearchText(var AValue: string): Boolean;
begin
  Result := False;
  if FDisplayField <> nil then
    if (AValue <> '') and Locate(FDisplayField, AValue, False) then
    begin
      SelectKeyValue(FKeyField.AsString);
      AValue := Copy(FDisplayField.AsString, 1, Length(AValue));
      Result := True;
    end
    else
    if AValue = '' then
    begin
      FLookupLink.DataSet.First;
      SelectKeyValue(FKeyField.AsString);
      AValue := '';
    end;
end;

procedure TJvLookupControl.ProcessSearchKey(Key: TUTF8Char);
var
  TickCount: Int64;
  S: string;
  L: Integer;
begin
  S := '';
  if (FDisplayField <> nil) then
  begin
    L := Length(Key);
    if (L = 1) and (Key[1] in [Tab, Esc]) then
      FSearchText := ''
    else if (L = 1) and (Key[1] < #32) and (Key[1] <> Backspace) then
      exit
    else
    if CanModify then
    begin
      if not FPopup then
      begin
        TickCount := GetTickCount64;
        if TickCount - SearchTickCount > 2000 then
          FSearchText := '';
        SearchTickCount := TickCount;
      end;
      if Key = Backspace then
        S := UTF8Copy(FSearchText, 1, UTF8Length(FSearchText)-1)
      else
      if Length(FSearchText) < 32 then
        S := FSearchText + Key;
      if SearchText(S) or (S = '') then
        FSearchText := S;
    end;
  end;
end;

procedure TJvLookupControl.ResetField;
begin
  if (FDataLink.DataSource = nil) or (FMasterField = nil) or FDataLink.Edit then
  begin
    if (FDataLink.DataSource <> nil) and FDataLink.Edit and (FMasterField <> nil) then
      SetFieldValue(FMasterField, FEmptyValue);
    FValue := FEmptyValue;
    FDisplayValue := '';
    inherited Text := DisplayEmpty;
    Invalidate;
    Click;
  end;
end;

procedure TJvLookupControl.ClearValue;
begin
  SetValueKey(FEmptyValue);
end;

procedure TJvLookupControl.SelectKeyValue(const Value: string);
begin
  if FMasterField <> nil then
  begin
    if CanModify and FDataLink.Edit then
    begin
      if FDataField = FMasterField then
        FDataField.DataSet.Edit;
      SetFieldValue(FMasterField, Value);
    end
    else
      Exit;
  end;
  SetValueKey(Value);
  UpdateDisplayValue;
  Repaint;
  Click;
end;

procedure TJvLookupControl.SetDataFieldName(const Value: string);
begin
  if FDataFieldName <> Value then
  begin
    FDataFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TJvLookupControl.SetDataSource(Value: TDataSource);
begin
  if FDataLink.DataSource <> nil then
    FDataLink.DataSource.RemoveFreeNotification(Self);
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TJvLookupControl.SetListStyle(Value: TLookupListStyle);
begin
  if FListStyle <> Value then
  begin
    FListStyle := Value;
    Invalidate;
  end;
end;

procedure TJvLookupControl.SetFieldsDelimiter(Value: Char);
begin
  if FFieldsDelimiter <> Value then
  begin
    FFieldsDelimiter := Value;
    if ListStyle = lsDelimited then
      Invalidate;
  end;
end;

procedure TJvLookupControl.SetLookupField(const Value: string);
begin
  CheckNotFixed;
  if FLookupFieldName <> Value then
  begin
    FLookupFieldName := Value;
    ListLinkActiveChanged;
    if FListActive then
      DataLinkRecordChanged(nil);
  end;
end;

procedure TJvLookupControl.SetDisplayEmpty(const Value: string);
begin
  if FDisplayEmpty <> Value then
  begin
    UpdateDisplayEmpty(Value);
    FDisplayEmpty := Value;
    if not (csReading in ComponentState) then
      Invalidate;
  end;
end;

procedure TJvLookupControl.SetDisplayIndex(const Value: Integer);
begin
  if Value <> FDisplayIndex then
  begin
    FDisplayIndex := Value;
    ListLinkActiveChanged;
  end;
end;

procedure TJvLookupControl.WMSetFocus(var Message: TLMSetFocus);
begin
  FFocused := True;
  inherited;
  Invalidate;
end;

procedure TJvLookupControl.WMKillFocus(var Message: TLMKillFocus);
begin
  FFocused := False;
  inherited;
  Invalidate;
end;

procedure TJvLookupControl.SetEmptyValue(const Value: string);
begin
  if FEmptyValue <> Value then
  begin
    if ValueIsEmpty(FValue) then
      FValue := Value;
    FEmptyValue := Value;
  end;
end;

procedure TJvLookupControl.SetFieldValue(Field: TField; const AValue: string);
begin
  if AValue = FEmptyValue then
    if (FEmptyValue = '') and FEmptyStrIsNull then
      Field.Clear
    else
      Field.AsString := FEmptyValue
  else
    Field.AsString := AValue;
end;

procedure TJvLookupControl.SetEmptyStrIsNull(const Value: Boolean);
begin
  if FEmptyStrIsNull <> Value then
  begin
    FEmptyStrIsNull := Value;
    if CanModify and (FDataLink.DataSource <> nil) and FDataLink.Edit then
      if FMasterField <> nil then
        SetFieldValue(FMasterField, FValue)
      else
        SetFieldValue(FDataField, FValue);
  end;
end;

procedure TJvLookupControl.SetEmptyItemColor(Value: TColor);
begin
  if FEmptyItemColor <> Value then
  begin
    FEmptyItemColor := Value;
    if not (csReading in ComponentState) and EmptyRowVisible then
      Invalidate;
  end;
end;

procedure TJvLookupControl.UpdateDisplayEmpty(const Value: string);
begin
end;

procedure TJvLookupControl.SetDisplayValue(const Value: string);
begin
  if (FDisplayValue <> Value) and CanModify and (FDataLink.DataSource <> nil) and
    Locate(FDisplayField, Value, True) then
  begin
    if FDataLink.Edit then
    begin
      // if FMasterField <> nil then FMasterField.AsString := S
      //   else FDataField.AsString := S;
      if FMasterField <> nil then
        SetFieldValue(FMasterField, FValue)
      else
        SetFieldValue(FDataField, FValue);
    end;
  end
  else
  if FDisplayValue <> Value then
  begin
    FDisplayValue := Value;
    DisplayValueChanged;
    Change;
  end;
end;

procedure TJvLookupControl.UpdateKeyValue;
begin
  if FMasterField <> nil then
    FValue := FMasterField.AsString
  else
    FValue := FEmptyValue;
  KeyValueChanged;
end;

procedure TJvLookupControl.SetValueKey(const Value: string);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    KeyValueChanged;
  end;
end;

procedure TJvLookupControl.SetValue(const Value: string);
begin
  if Value <> FValue then
  begin
    if CanModify and (FDataLink.DataSource <> nil) and FDataLink.Edit then
    begin
      // if FMasterField <> nil then FMasterField.AsString := Value
      //   else FDataField.AsString := Value;
      if FMasterField <> nil then
        SetFieldValue(FMasterField, Value)
      else
        SetFieldValue(FDataField, Value);
    end
    else
      SetValueKey(Value);
    Change;
  end;
end;

procedure TJvLookupControl.SetLookupDisplay(const Value: string);
begin
  if FLookupDisplay <> Value then
  begin
    FLookupDisplay := Value;
    ListLinkActiveChanged;
    if FListActive then
      DataLinkRecordChanged(nil);
  end;
end;

procedure TJvLookupControl.SetLookupSource(Value: TDataSource);
begin
  CheckNotFixed;
  if FLookupLink.DataSource <> nil then
    FLookupLink.DataSource.RemoveFreeNotification(Self);
  FLookupLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  if Value <> nil then
    FLocate.DataSet := Value.DataSet
  else
    FLocate.DataSet := nil;
  if FListActive then
    DataLinkRecordChanged(nil);
end;

procedure TJvLookupControl.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TJvLookupControl.GetItemHeight: Integer;
begin
  Result := Max(GetTextHeight, FItemHeight); //GetTextHeight;
end;

procedure TJvLookupControl.SetItemHeight(Value: Integer);
begin
  if not (csReading in ComponentState) then
    FItemHeight := Max(DefaultTextHeight, Value)
  else
    FItemHeight := Value;
  Perform(CM_FONTCHANGED, 0, 0);
end;

function TJvLookupControl.ItemHeightStored: Boolean;
begin
  Result := FItemHeight > DefaultTextHeight;
end;

procedure TJvLookupControl.DrawPicture(ACanvas: TCanvas; Rect: TRect;
  Image: TGraphic);
var
  X, Y, SaveIndex: Integer;
  //Ico: HICON;
  //W, H: Integer;
begin
  if Image <> nil then
  begin
    X := (Rect.Right + Rect.Left - Image.Width) div 2;
    Y := (Rect.Top + Rect.Bottom - Image.Height) div 2;
    SaveIndex := SaveDC(ACanvas.Handle);
    try
      IntersectClipRect(ACanvas.Handle, Rect.Left, Rect.Top, Rect.Right,
        Rect.Bottom);
      if Image is TBitmap then
        DrawBitmapTransparent(ACanvas, X, Y, TBitmap(Image),
          TBitmap(Image).TransparentColor)
      else
      {if Image is TIcon then
      begin
        Ico := CreateRealSizeIcon(TIcon(Image));
        try
          GetIconSize(Ico, W, H);
          DrawIconEx(ACanvas.Handle, (Rect.Right + Rect.Left - W) div 2,
            (Rect.Top + Rect.Bottom - H) div 2, Ico, W, H, 0, 0, DI_NORMAL);
        finally
          DestroyIcon(Ico);
        end;
      end
      else}
        ACanvas.Draw(X, Y, Image);
    finally
      RestoreDC(ACanvas.Handle, SaveIndex);
    end;
  end;
end;

procedure TJvLookupControl.DrawImage(ACanvas: TCanvas; Rect: TRect;
  ImageIndex: Integer);
var
  X, Y: Integer;
begin
  if Assigned(ImageList) and (ImageIndex > -1) then
  begin
    ACanvas.FillRect(Rect);
    X := (Rect.Right + Rect.Left - ImageList.Width) div 2;
    Y := (Rect.Top + Rect.Bottom - ImageList.Height) div 2;
    ImageList.Draw(ACanvas, X, Y, ImageIndex);
  end;
end;

function TJvLookupControl.GetPicture(Current, Empty: Boolean;
  var TextMargin: Integer): TGraphic;
begin
  TextMargin := 0;
  Result := nil;
  if Assigned(FOnGetImage) then
    FOnGetImage(Self, Empty, Result, TextMargin);
end;

function TJvLookupControl.GetImageIndex(Current, Empty: Boolean;
  var TextMargin: Integer): Integer;
begin
  Result := -1;
  TextMargin := 0;
  if Assigned(FOnGetImageIndex) then
    FOnGetImageIndex(Self, Empty, Result, TextMargin);
end;

function TJvLookupControl.Locate(const SearchField: TField;
  const AValue: string; Exact: Boolean): Boolean;
begin
  FLocate.IndexSwitch := FIndexSwitch;
  Result := False;
  try
    if not ValueIsEmpty(AValue) and (SearchField <> nil) then
    begin
      Result := FLocate.Locate(SearchField.FieldName, AValue, Exact, not IgnoreCase, True, RightTrimmedLookup);
      if Result then
      begin
        if SearchField = FDisplayField then
          FValue := FKeyField.AsString;
        UpdateDisplayValue;
      end;
    end;
  except
  end;
end;

function TJvLookupControl.EmptyRowVisible: Boolean;
begin
  Result := DisplayEmpty <> '';
end;

procedure TJvLookupControl.UpdateDisplayValue;
begin
  if not ValueIsEmpty(FValue) then
  begin
    if FDisplayField <> nil then
      FDisplayValue := FDisplayField.AsString
    else
      FDisplayValue := '';
  end
  else
    FDisplayValue := '';
end;

function TJvLookupControl.GetWindowWidth: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FListFields.Count - 1 do
    Inc(Result, TField(FListFields[I]).DisplayWidth);
  Canvas.Font := Font;
  Result := Min(Result * Canvas.TextWidth('M') + FListFields.Count * 4 +
    GetSystemMetrics(SM_CXVSCROLL), Screen.Width);
end;

function TJvLookupControl.GetDefaultColor(
  const DefaultColorType: TDefaultColorType): TColor;
begin
  if DefaultColorType = dctBrush then
    Result := clWindow
  else
    Result := inherited GetDefaultColor(DefaultColorType);
end;

procedure TJvLookupControl.SetLookupFormat(const Value: string);
begin
  if Value <> FLookupFormat then
  begin
    CheckLookupFormat(Value);
    FLookupFormat := Value;
    ListLinkActiveChanged;
    if FListActive then
      DataLinkRecordChanged(nil);
  end;
end;

function TJvLookupControl.DoFormatLine: string;
var
  J, LastFieldIndex: Integer;
  AField: TField;
  LStringList: array of string = nil;
  LVarList: array of TVarRec = nil;
begin
  Result := '';
  LastFieldIndex := FListFields.Count - 1;
  if LookupFormat > '' then
  begin
    SetLength(LStringList, LastFieldIndex + 1);
    SetLength(LVarList, LastFieldIndex + 1);

    for J := 0 to LastFieldIndex do
    begin
      LStringList[J] := TField(FListFields[J]).DisplayText;
      {$IFDEF SUPPORTS_UNICODE}
      LVarList[J].VPWideChar := PWideChar(LStringList[J]);
      LVarList[J].VType := vtPWideChar;
      {$ELSE}
      LVarList[J].VPChar := PAnsiChar(LStringList[J]);
      LVarList[J].VType := vtPChar;
      {$ENDIF SUPPORTS_UNICODE}
    end;
    Result := Format(LookupFormat, LVarList);
  end
  else
    for J := 0 to LastFieldIndex do
    begin
      AField := TField(FListFields[J]);
      Result := Result + AField.DisplayText;
      if J < LastFieldIndex then
        Result := Result + FFieldsDelimiter + ' ';
    end;
end;

//=== { TJvDBLookupList } ====================================================

constructor TJvDBLookupList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 121;
  BorderStyle := bsSingle;
  ControlStyle := [csOpaque, csDoubleClicks];
  RowCount := 7;
  FDisableChangeBounds := False;
end;

procedure TJvDBLookupList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style or WS_VSCROLL;
end;

procedure TJvDBLookupList.CreateWnd;
begin
  inherited CreateWnd;
  RowCount := RowCount;
  UpdateScrollBar;
end;

procedure TJvDBLookupList.Loaded;
begin
  inherited Loaded;
  Height := Height;
end;

function TJvDBLookupList.GetKeyIndex: Integer;
var
  FieldValue: string;
begin
  if not ValueIsEmpty(FValue) then
    for Result := 0 to FRecordCount - 1 do
    begin
      FLookupLink.ActiveRecord := Result;
      FieldValue := FKeyField.AsString;
      FLookupLink.ActiveRecord := FRecordIndex;
      if FieldValue = FValue then
        Exit;
    end;
  Result := -1;
end;

procedure TJvDBLookupList.KeyDown(var Key: Word; Shift: TShiftState);
var
  Delta, KeyIndex, EmptyRow: Integer;
begin
  inherited;
  FSelectEmpty := False;
  EmptyRow := Ord(EmptyRowVisible);
  if CanModify then
  begin
    Delta := 0;
    case Key of
      VK_UP, VK_LEFT:
        Delta := -1;
      VK_DOWN, VK_RIGHT:
        Delta := 1;
      VK_PRIOR:
        Delta := 1 - (FRowCount - EmptyRow);
      VK_NEXT:
        Delta := (FRowCount - EmptyRow) - 1;
      VK_HOME:
        Delta := -MaxInt;
      VK_END:
        Delta := MaxInt;
    end;
    if Delta <> 0 then
    begin
      Key := 0;
      if ValueIsEmpty(Value) and (EmptyRow > 0) and (Delta < 0) then
        FSelectEmpty := True;
      FSearchText := '';
      if Delta = -MaxInt then
        FLookupLink.DataSet.First
      else
      if Delta = MaxInt then
        FLookupLink.DataSet.Last
      else
      begin
        KeyIndex := GetKeyIndex;
        if KeyIndex >= 0 then
        begin
          FLookupLink.DataSet.MoveBy(KeyIndex - FRecordIndex);
        end
        else
        begin
          KeyValueChanged;
          Delta := 0;
        end;
        FLookupLink.DataSet.MoveBy(Delta);
        if FLookupLink.DataSet.Bof and (Delta < 0) and (EmptyRow > 0) then
          FSelectEmpty := True;
      end;
      SelectCurrent;
    end;
  end;
end;

procedure TJvDBLookupList.UTF8KeyPress(var Key: TUTF8Char);
begin
  inherited UTF8KeyPress(Key);
  ProcessSearchKey(Key);
end;

procedure TJvDBLookupList.KeyValueChanged;
begin
  if FListActive and not FLockPosition then
    if not LocateKey then
      FLookupLink.DataSet.First;
end;

procedure TJvDBLookupList.DisplayValueChanged;
begin
  if FListActive and not FLockPosition then
    if not LocateDisplay then
      FLookupLink.DataSet.First;
end;

procedure TJvDBLookupList.ListLinkActiveChanged;
begin
  try
    inherited ListLinkActiveChanged;
  finally
    if FListActive and not FLockPosition then
    begin
      if Assigned(FMasterField) then
        UpdateKeyValue
      else
        KeyValueChanged;
    end
    else
      ListDataChanged;
  end;
end;

procedure TJvDBLookupList.ListDataChanged;
begin
  if FListActive then
  begin
    FRecordIndex := FLookupLink.ActiveRecord;

    // Note: if we cannot access the DataSet, then the record count will be
    // the one from the link and can be different from the total record count.
    // This may result in not displaying the scrollbar.
    // This was changed from simply using FLookupLink.RecordCount to fix
    // Mantis 3825.
    if Assigned(FLookupLink.DataSet) and UseRecordCount then
      FRecordCount := FLookupLink.DataSet.RecordCount
    else
      FRecordCount := FLookupLink.RecordCount;
    FKeySelected := not ValueIsEmpty(FValue) or not FLookupLink.DataSet.Bof;
  end
  else
  begin
    FRecordIndex := 0;
    FRecordCount := 0;
    FKeySelected := False;
  end;
  if HandleAllocated then
  begin
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TJvDBLookupList.ListLinkDataChanged;
begin
  ListDataChanged;
end;

procedure TJvDBLookupList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FSearchText := '';
    if not FPopup then
    begin
      if CanFocus then
        SetFocus;
      if not FFocused then
        Exit;
    end;
    if CanModify then
      if ssDouble in Shift then
      begin
        if FRecordIndex = Y div GetTextHeight then
          DblClick;
      end
      else
      begin
        MouseCapture := True;
        FTracking := True;
        SelectItemAt(X, Y);
      end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TJvDBLookupList.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FTracking then
  begin
    SelectItemAt(X, Y);
    FMousePos := Y;
    TimerScroll;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TJvDBLookupList.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FTracking then
  begin
    StopTracking;
    SelectItemAt(X, Y);
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TJvDBLookupList.DrawItemText(ACanvas: TCanvas; Rect: TRect;
  Selected, IsEmpty: Boolean);
var
  J, W, X, ATop, TextWidth, LastFieldIndex: Integer;
  S: string;
  AField: TField;
  R: TRect;
  AAlignment: TAlignment;
begin
  TextWidth := ACanvas.TextWidth('M');
  LastFieldIndex := FListFields.Count - 1;
  R := Rect;
  R.Right := R.Left;
  S := '';
  Canvas.FillRect(Rect);
  ATop := (R.Bottom + R.Top - CanvasMaxTextHeight(ACanvas)) div 2;
  if FListStyle = lsFixed then
    for J := 0 to LastFieldIndex do
    begin
      AField := TField(FListFields[J]);
      if J < LastFieldIndex then
        W := AField.DisplayWidth * TextWidth + 4
      else
        W := ClientWidth - R.Right;
      if IsEmpty then
      begin
        if J = 0 then
        begin
          S := DisplayEmpty;
        end
        else
          S := '';
      end
      else
        S := AField.DisplayText;
      X := 2;
      AAlignment := AField.Alignment;
      if UseRightToLeftAlignment then
        ChangeBiDiModeAlignment(AAlignment);
      case AAlignment of
        taRightJustify:
          X := W - ACanvas.TextWidth(S) - 3;
        taCenter:
          X := (W - ACanvas.TextWidth(S)) div 2;
      end;
      R.Left := R.Right;
      R.Right := R.Right + W;
      //if SysLocale.MiddleEast and UseRightToLeftReading then
      //  ACanvas.TextFlags := ACanvas.TextFlags or ETO_RTLREADING
      //else
      //  ACanvas.TextFlags := ACanvas.TextFlags and not ETO_RTLREADING;
      ACanvas.TextRect(R, R.Left + X, ATop, S);
      if J < LastFieldIndex then
      begin
        ACanvas.MoveTo(R.Right, R.Top);
        ACanvas.LineTo(R.Right, R.Bottom);
        Inc(R.Right);
        if R.Right >= ClientWidth then
          Break;
      end;
    end
  else
  if not IsEmpty then
    S := DoFormatLine;
  if FListStyle = lsDelimited then
  begin
    if IsEmpty then
      S := DisplayEmpty;
    R.Left := Rect.Left;
    R.Right := Rect.Right;
    //if SysLocale.MiddleEast and UseRightToLeftReading then
    //  ACanvas.TextFlags := ACanvas.TextFlags or ETO_RTLREADING
    //else
    //  ACanvas.TextFlags := ACanvas.TextFlags and not ETO_RTLREADING;
    ACanvas.TextRect(R, R.Left + 2, ATop, S);
  end;
end;

procedure TJvDBLookupList.Paint;
var
  I, J, TextHeight: Integer;
  TextMargin: Integer = 0;
  Image: TGraphic;
  R, ImageRect: TRect;
  Selected: Boolean;
  ImgIndex: Integer;
begin
  Canvas.Font := Font;
  TextHeight := GetTextHeight;
  if ColorToRGB(Color) <> ColorToRGB(clBtnFace) then
    Canvas.Pen.Color := clBtnFace
  else
    Canvas.Pen.Color := clBtnShadow;
  for I := 0 to FRowCount - 1 do
  begin
    J := I - Ord(EmptyRowVisible);
    Canvas.Font.Color := Font.Color;
    Canvas.Brush.Color := Color;
    Selected := not FKeySelected and (I = 0) and not EmptyRowVisible;
    R.Top := I * TextHeight;
    R.Bottom := R.Top + TextHeight;
    if I < FRecordCount + Ord(EmptyRowVisible) then
    begin
      if (I = 0) and (J = -1) then
      begin
        if ValueIsEmpty(FValue) then
        begin
          Canvas.Font.Color := clHighlightText;
          Canvas.Brush.Color := clHighlight;
          Selected := True;
        end
        else
          Canvas.Brush.Color := EmptyItemColor;
        R.Left := 0;
        R.Right := ClientWidth;
        Image := GetPicture(False, True, TextMargin);
        if TextMargin > 0 then
        begin
          ImageRect := Bounds(R.Left, R.Top, TextMargin, RectHeight(R));
          if Image <> nil then
            DrawPicture(Canvas, ImageRect, Image);
          DrawItemText(Canvas, Bounds(R.Left + TextMargin, R.Top, RectWidth(R) - TextMargin,
            RectHeight(R)), Selected, True);
        end
        else if Assigned(ImageList) then
        begin
          ImgIndex := GetImageIndex(False, True, TextMargin);
          if TextMargin > 0 then
          begin
            ImageRect := Bounds(R.Left, R.Top, TextMargin, RectHeight(R));
            if ImgIndex > -1 then
              DrawImage(Canvas, ImageRect, ImgIndex);
            DrawItemText(Canvas, Bounds(R.Left + TextMargin, R.Top, RectWidth(R) - TextMargin,
              RectHeight(R)), Selected, True);
          end
          else
            DrawItemText(Canvas, R, Selected, True);
        end
        else
          DrawItemText(Canvas, R, Selected, True);
      end
      else
      begin
        FLookupLink.ActiveRecord := J;
        if not ValueIsEmpty(FValue) and (FKeyField.AsString = FValue) then
        begin
          Canvas.Font.Color := clHighlightText;
          Canvas.Brush.Color := clHighlight;
          Selected := True;
        end;
        R.Left := 0;
        R.Right := ClientWidth;
        Image := GetPicture(False, False, TextMargin);
        if TextMargin > 0 then
        begin
          ImageRect := Bounds(R.Left, R.Top, TextMargin, RectHeight(R));
          if Image <> nil then
            DrawPicture(Canvas, ImageRect, Image);
          DrawItemText(Canvas, Bounds(R.Left + TextMargin, R.Top, RectWidth(R) - TextMargin,
            RectHeight(R)), Selected, False);
        end
        else if Assigned(ImageList) then
        begin
          ImgIndex := GetImageIndex(False, False, TextMargin);
          if TextMargin > 0 then
          begin
            ImageRect := Bounds(R.Left, R.Top, TextMargin, RectHeight(R));
            if ImgIndex > -1 then
              DrawImage(Canvas, ImageRect, ImgIndex);
            DrawItemText(Canvas, Bounds(R.Left + TextMargin, R.Top, RectWidth(R) - TextMargin,
              RectHeight(R)), Selected, False);
          end
          else
            DrawItemText(Canvas, R, Selected, False);
        end
        else
          DrawItemText(Canvas, R, Selected, False);
      end;
    end;
    R.Left := 0;
    R.Right := ClientWidth;
    if J >= FRecordCount then
      Canvas.FillRect(R);
    if Selected and (FFocused or FPopup) then
      Canvas.DrawFocusRect(R);
  end;
  if FRecordCount <> 0 then
    FLookupLink.ActiveRecord := FRecordIndex;
end;

procedure TJvDBLookupList.SelectCurrent;
begin
  FLockPosition := True;
  try
    if FSelectEmpty then
      ResetField
    else
      SelectKeyValue(FKeyField.AsString);
  finally
    FSelectEmpty := False;
    FLockPosition := False;
  end;
end;

procedure TJvDBLookupList.SelectItemAt(X, Y: Integer);
var
  Delta: Integer;
begin
  if Y < 0 then
    Y := 0;
  if Y >= ClientHeight then
    Y := ClientHeight - 1;
  Delta := Y div GetTextHeight;
  if (Delta = 0) and EmptyRowVisible then
    FSelectEmpty := True
  else
  begin
    Delta := Delta - FRecordIndex;
    if EmptyRowVisible then
      Dec(Delta);
    FLookupLink.DataSet.MoveBy(Delta);
  end;
  SelectCurrent;
end;

procedure TJvDBLookupList.UpdateDisplayEmpty(const AValue: string);
begin
  UpdateBufferCount(RowCount - Ord(AValue <> ''));
end;

procedure TJvDBLookupList.UpdateBufferCount(Rows: Integer);
begin
  if FLookupLink.BufferCount <> Rows then
  begin
    FLookupLink.BufferCount := Rows;
    ListLinkDataChanged;
  end;
end;

procedure TJvDBLookupList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FDisableChangeBounds := True;
  UpdateBufferCount(FRowCount - Ord(EmptyRowVisible));
  FDisableChangeBounds := False;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TJvDBLookupList.SetRowCount(AValue: Integer);
begin
  if AValue < 1 then
    AValue := 1;
  if AValue > 50 then
    AValue := 50;
  Height := AValue * GetTextHeight + GetBorderSize;
end;

procedure TJvDBLookupList.StopTimer;
begin
  if FTimerActive then
  begin
    // (rom) why not a TTimer?
    KillTimer(Handle, 1);
    FTimerActive := False;
  end;
end;

procedure TJvDBLookupList.StopTracking;
begin
  if FTracking then
  begin
    StopTimer;
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TJvDBLookupList.TimerScroll;
var
  Delta, Distance, Interval: Integer;
begin
  Delta := 0;
  Distance := 0;
  if FMousePos < 0 then
  begin
    Delta := -1;
    Distance := -FMousePos;
  end;
  if FMousePos >= ClientHeight then
  begin
    Delta := 1;
    Distance := FMousePos - ClientHeight + 1;
  end;
  if Delta = 0 then
    StopTimer
  else
  begin
    if FLookupLink.DataSet.MoveBy(Delta) <> 0 then
      SelectCurrent;
    Interval := 200 - Distance * 15;
    if Interval < 0 then
      Interval := 0;
    SetTimer(Handle, 1, Interval, nil);
    FTimerActive := True;
  end;
end;

procedure TJvDBLookupList.UpdateScrollBar;
var
  Pos, Max: Integer;
  ScrollInfo: TScrollInfo;
  WantScrollbar: Boolean;
begin
  Pos := 0;
  Max := 0;

  if Assigned(FLookupLink.DataSet) and FLookupLink.Active then
  begin
    if UseRecordCount then
      // FRecordCount is #records in the table
      WantScrollbar := FRecordCount > (FRowCount - Ord(EmptyRowVisible))
    else
      // FRecordCount is #records in the link buffer; we don't know the #records
      // in the table, but is it equal or bigger than FRecordCount, if FRecordCount
      // is smaller than the # of rows in the dropdown then FRecordCount is equal
      // to the #records in the table and no scrollbar is shown.
      WantScrollbar := FRecordCount = (FRowCount - Ord(EmptyRowVisible));

    if WantScrollbar then
    begin
      if UseRecordCount and (FLookupLink.DataSet.RecNo <> -1) then
      begin
        // We can be accurate
        Max := FRecordCount{ - 1};
        Pos := FLookupLink.DataSet.RecNo - 1;
      end
      else
      begin
        // Use an approximation
        Max := 4;
        if not FLookupLink.DataSet.Bof then
          if not FLookupLink.DataSet.Eof then
            Pos := 2
          else
            Pos := 4;
      end;
    end;
  end;
  ScrollInfo.cbSize := SizeOf(TScrollInfo);
  ScrollInfo.fMask := SIF_POS or SIF_RANGE;
  if not GetScrollInfo(Handle, SB_VERT, ScrollInfo) or
    (ScrollInfo.nPos <> Pos) or (ScrollInfo.nMax <> Max) then
  begin
    ScrollInfo.nMin := 0;
    ScrollInfo.nMax := Max;
    ScrollInfo.nPos := Pos;
    FDisableChangeBounds := True;
    SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);
    FDisableChangeBounds := False;
  end;
end;

procedure TJvDBLookupList.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  if not (csReading in ComponentState) then
    Height := Height;
end;

procedure TJvDBLookupList.WMCancelMode(var Msg: TLMessage);
begin
  StopTracking;
  inherited;
end;

procedure TJvDBLookupList.WMTimer(var Msg: TLMessage);
begin
  TimerScroll;
end;

procedure TJvDBLookupList.WMNCHitTest(var Msg: TLMNCHitTest);
begin
  if csDesigning in ComponentState then
  begin
    if FLookupLink.Active then
      DefaultHandler(Msg)
    else
      inherited;
  end
  else
    inherited;
end;

function TJvDBLookupList.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  ScrollableRowCount: Integer;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    if FLookupLink.DataSet = nil then
      Exit;

    ScrollableRowCount := RowCount - Ord(EmptyRowVisible);

    with FLookupLink.DataSet do
      { ScrollableRowCount - FRecordIndex - 1  = #records till end of visible list
        ScrollableRowCount div 2               = half visible list.
      }
      if Shift * [ssShift, ssCtrl] <> [] then
        { 1 line down }
        Result := MoveBy(ScrollableRowCount - FRecordIndex) <> 0
      else
        { Half Page down }
        Result := MoveBy(ScrollableRowCount - FRecordIndex + ScrollableRowCount div 2 - 1) <> 0;
  end;
end;

function TJvDBLookupList.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  ScrollableRowCount: Integer;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
  begin
    if FLookupLink.DataSet = nil then
      Exit;

    ScrollableRowCount := RowCount - Ord(EmptyRowVisible);

    with FLookupLink.DataSet do
      { -FRecordIndex                 = #records till begin of visible list
         ScrollableRowCount div 2     = half visible list.
      }
      if Shift * [ssShift, ssCtrl] <> [] then
        { One line up }
        Result := MoveBy(-FRecordIndex - 1) <> 0
      else
        { Half Page up }
        Result := MoveBy(-FRecordIndex - ScrollableRowCount div 2) <> 0;
  end;
end;

procedure TJvDBLookupList.ChangeBounds(ALeft, ATop, AWidth, AHeight: integer;
  KeepBase: boolean);
var
  BorderSize, TextHeight, Rows: Integer;
begin
  if (not FDisableChangeBounds) then
  begin
    BorderSize := GetBorderSize;
    TextHeight := GetTextHeight;
    Rows := (AHeight - BorderSize) div TextHeight;
    if Rows < 1 then
      Rows := 1;
    FRowCount := Rows;
    if not (csReading in ComponentState) then
      AHeight := Rows * TextHeight + BorderSize;
  end;
  inherited ChangeBounds(ALeft, ATop, AWidth, AHeight, KeepBase);
end;

procedure TJvDBLookupList.CalculatePreferredSize(var PreferredWidth,
  PreferredHeight: integer; WithThemeSpace: Boolean);
begin
  inherited CalculatePreferredSize(PreferredWidth, PreferredHeight,
    WithThemeSpace);
  PreferredHeight := RowCount * GetItemHeight + GetBorderSize;
end;

procedure TJvDBLookupList.WMVScroll(var Msg: TLMVScroll);
var
  ScrollableRowCount: Integer;
  ScrollInfo: TScrollInfo;
begin
  FSearchText := '';
  if FLookupLink.DataSet = nil then
    Exit;

  ScrollableRowCount := RowCount - Ord(EmptyRowVisible);

  with Msg, FLookupLink.DataSet do
    case ScrollCode of
      SB_LINEUP:
        MoveBy(-FRecordIndex - 1);
      SB_LINEDOWN:
        MoveBy(ScrollableRowCount - FRecordIndex);
      SB_PAGEUP:
        MoveBy(-FRecordIndex - ScrollableRowCount + 1);
      SB_PAGEDOWN:
        MoveBy(ScrollableRowCount - FRecordIndex + ScrollableRowCount - 2);
      SB_THUMBPOSITION, SB_THUMBTRACK:
        begin
          if UseRecordCount then
          begin
            if Pos = 0 then
              First
            else if Pos = FRecordCount - 1 then
              Last
            else
            begin
              ScrollInfo.cbSize := SizeOf(ScrollInfo);
              ScrollInfo.fMask := SIF_POS;
              if GetScrollInfo(Handle, SB_VERT, ScrollInfo) then
                MoveBy(-ScrollInfo.nPos + Pos);
            end;
          end
          else if ScrollCode = SB_THUMBPOSITION then
          begin
            case Pos of
              0:
                First;
              1:
                MoveBy(-FRecordIndex - ScrollableRowCount + 1);
              2:
                Exit;
              3:
                MoveBy(ScrollableRowCount - FRecordIndex + ScrollableRowCount - 2);
              4:
                Last;
            end;
          end;
        end;
      SB_BOTTOM:
        Last;
      SB_TOP:
        First;
    end;
end;

//=== { TJvPopupDataList } ===================================================

constructor TJvPopupDataList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TJvPopupDataListForm then
    FCombo := TJvPopupDataListForm(AOwner).FCombo;
  FPopup := True;
  TabStop := False;
end;

procedure TJvPopupDataList.CMHintShow(var Msg: TLMessage);
begin
  // never show
  Msg.Result := 1;
end;

procedure TJvPopupDataList.Click;
begin
  inherited Click;
  if Assigned(FCombo) and TJvDBLookupCombo(FCombo).FListVisible then
    TJvDBLookupCombo(FCombo).InvalidateText;
end;

procedure TJvPopupDataList.UTF8KeyPress(var Key: TUTF8Char);
begin
  inherited UTF8KeyPress(Key);
  if Assigned(FCombo) and TJvDBLookupCombo(FCombo).FListVisible then
    TJvDBLookupCombo(FCombo).InvalidateText;
end;

{ TJvPopupDataListForm }

procedure TJvPopupDataListForm.UTF8KeyPress(var Key: TUTF8Char);
begin
  inherited UTF8KeyPress(Key);
  if Assigned(FCombo) then
  begin
    TJvDBLookupCombo(FCombo).UTF8KeyPress(Key);
    if TJvDBLookupCombo(FCombo).FListVisible then
      TJvDBLookupCombo(FCombo).InvalidateText;
  end;
end;

procedure TJvPopupDataListForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Assigned(FCombo) then
    TJvPopupDataList(FCombo).KeyDown(Key, Shift);
end;

procedure TJvPopupDataListForm.DoShow;
begin
  inherited DoShow;
  Application.AddOnDeactivateHandler(@AppDeactivate);
end;

procedure TJvPopupDataListForm.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  Application.RemoveOnDeactivateHandler(@AppDeactivate);
end;

{$IFDEF WINDOWS}
//procedure TJvPopupDataListForm.CreateWnd;
//begin
//  inherited CreateWnd;
//  SetClassLong(WindowHandle, GCL_STYLE,
//    GetClassLong(WindowHandle, GCL_STYLE) or CS_DROPSHADOW);
//end;

procedure TJvPopupDataListForm.WMActivate(var Message: TLMActivate);
begin
  if (Message.Active <> WA_INACTIVE) and Assigned(Self.GetRealPopupParent) then
    SendMessage(Self.GetRealPopupParent.Handle, LM_NCACTIVATE, WPARAM(True), -1);
  inherited;
end;
{$ENDIF}

procedure TJvPopupDataListForm.AppDeactivate(Sender: TObject);
begin
  if Assigned(FCombo) and (FCombo is TJvDBLookupCombo) then
    TJvDBLookupCombo(FCombo).CloseUp(False);
end;

procedure TJvPopupDataListForm.Deactivate;
begin
  if Assigned(FCombo) then
    if FCombo is TJvDBLookupCombo then
    begin
      TJvDBLookupCombo(FCombo).FWhenClosed := GetTickCount64;
      TJvDBLookupCombo(FCombo).CloseUp(False);
    end;
  inherited Deactivate;
end;

constructor TJvPopupDataListForm.CreateNew(AOwner: TComponent; Num: Integer);
begin
  inherited CreateNew(AOwner, Num);
  ControlStyle := ControlStyle + [csNoDesignVisible];
  ShowInTaskBar := stNever;
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  {$IFDEF WINDOWS}
  PopupMode := pmExplicit;
  PopupParent := GetParentForm(TControl(AOwner));
  {$ELSE}
  PopupMode := pmAuto;
  {$ENDIF}
  KeyPreview := True;
  AutoSize := True;
  FList := TJvPopupDataList.Create(Self);
  FList.Parent := Self;
  FList.Left := 0;
  FList.Top := 0;
  //FList.Align := alClient;
end;

//=== { TJvDBLookupCombo } ===================================================

constructor TJvDBLookupCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable] - [csSetCaption];
  FDataListForm := TJvPopupDataListForm.CreateNew(Self);
  FDataListForm.Visible := False;
  FDataListForm.FCombo := Self;
  FDataListForm.FList.FCombo := Self;
  FDataListForm.FList.OnMouseUp := @ListMouseUp;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FDropDownCount := 8;
  FDisplayValues := TStringList.Create;
  FSelImage := TPicture.Create;
  FSelImageIndex := -1;
  Height := GetMinHeight;
  FEscapeKeyReset := True;
  FDeleteKeyClear := True;
  FLastValue := Unassigned;
  BorderStyle := bsSingle;
  Width := 145;
  Height := 0;
end;

destructor TJvDBLookupCombo.Destroy;
begin
  FSelImage.Free;
  FSelImage := nil;
  FreeAndNil(FDisplayValues);
  inherited Destroy;
end;

procedure TJvDBLookupCombo.ReadEscapeClear(Reader: TReader);
begin
  DeleteKeyClear := Reader.ReadBoolean;
end;

procedure TJvDBLookupCombo.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  // backward compatiblity
  Filer.DefineProperty('EscapeClear', @ReadEscapeClear, nil, False);
end;

procedure TJvDBLookupCombo.DataLinkUpdateData;
begin
  inherited DataLinkUpdateData;
  if (Field <> nil) and FDataLink.Active then
    FLastValue := Field.Value;
end;

procedure TJvDBLookupCombo.DataLinkRecordChanged(AField: TField);
begin
  if (AField = nil) and (Field <> nil) and (FDataLink.Active) then
    FLastValue := Field.Value;
  inherited DataLinkRecordChanged(AField);
end;

function ParentFormVisible(AControl: TControl): Boolean;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(AControl);
  Result := Assigned(Form) and Form.Visible;
end;

procedure TJvDBLookupCombo.CloseUp(Accept: Boolean);
var
  ListValue: string;
begin
  if FListVisible then
  begin
    if GetCapture <> 0 then
      SendMessage(GetCapture, LM_CANCELMODE, 0, 0);
    { (rb) Need to check ParentFormVisible always before SetFocus? Delphi doesn't.
           Not checking whether the parent form is visible typically gives errors
           when closing forms with non-focusable buttons (eg speed/toolbuttons) }
    if ParentFormVisible(Self) and CanFocus then
      SetFocus;
    ListValue := FDataListForm.FList.Value;
    FDataListForm.Close;
    FListVisible := False;
    FDataListForm.FList.LookupSource := nil;
    InvalidateDropDownButton;
    Invalidate;
    FSearchText := '';
    FDataListForm.FList.FSearchText := '';
    if Accept and CanModify and (Value <> ListValue) then
      SelectKeyValue(ListValue);
    if Assigned(FOnCloseUp) then
      FOnCloseUp(Self);
  end;
end;

procedure TJvDBLookupCombo.CMHintShow(var Msg: TLMessage);
begin
  // don't show if list is visible
  Msg.Result := LRESULT(Ord(FListVisible));
end;

procedure TJvDBLookupCombo.DoEnter;
begin
  if (Field <> nil) and FDataLink.Active and VarIsEmpty(FLastValue) then
    FLastValue := Field.Value;
  inherited DoEnter;
end;

function TJvDBLookupCombo.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    if FLookupLink.DataSet = nil then
      Exit;

    { Simulate up or down key, see code in KeyDown }
    if FListActive then
      if ssAlt in Shift then
      begin
        if FListVisible then
          CloseUp(True)
        else
          DropDown;
        Result := True;
      end
      else
      if not FListVisible and not ReadOnly then
      begin
        if not LocateKey then
          FLookupLink.DataSet.First
        else
          FLookupLink.DataSet.MoveBy(1);
        SelectKeyValue(FKeyField.AsString);
        Result := True;
      end;
    if not Result and FListVisible then
      Result := FDataListForm.FList.DoMouseWheelDown(Shift, MousePos);
  end;
end;

function TJvDBLookupCombo.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    if FLookupLink.DataSet = nil then
      Exit;

    { Simulate up or down key, see code in KeyDown }
    if FListActive then
      if ssAlt in Shift then
      begin
        if FListVisible then
          CloseUp(True)
        else
          DropDown;
        Result := True;
      end
      else
      if not FListVisible and not ReadOnly then
      begin
        if not LocateKey then
          FLookupLink.DataSet.First
        else
          FLookupLink.DataSet.MoveBy(-1);
        SelectKeyValue(FKeyField.AsString);
        Result := True;
      end;
    if not Result and FListVisible then
      Result := FDataListForm.FList.DoMouseWheelUp(Shift, MousePos);
  end;
end;

procedure TJvDBLookupCombo.DropDown;
var
  P: TPoint;
  I, Y: Integer;
  S: string;
  SelValue: string;
  RecordCount: Integer;
  Monitor: TMonitor;
  Rect: TRect;
begin
  if not FListVisible and {FListActive} CanModify
    and ((FWhenClosed = 0) or (FWhenClosed + 100 < GetTickCount64)) then
  begin
    if Assigned(FOnDropDown) then
      FOnDropDown(Self);
    SelValue := Value; // backup before anything invokes a OnDataChange event

    {$IFDEF WINDOWS}
    FDataListForm.PopupParent := GetParentForm(Self);
    {$ENDIF}

    FDataListForm.FList.Color := Color;
    FDataListForm.FList.Font := Font;
    FDataListForm.FList.EmptyItemColor := EmptyItemColor;

    FDataListForm.FList.ItemHeight := ItemHeight;
    FDataListForm.FList.ReadOnly := not CanModify;
    FDataListForm.FList.EmptyValue := EmptyValue;
    FDataListForm.FList.DisplayEmpty := DisplayEmpty;
    FDataListForm.FList.UseRecordCount := UseRecordCount;
    if Assigned(FLookupLink.DataSet) and UseRecordCount then
    begin
      RecordCount := FLookupLink.DataSet.RecordCount;
      if EmptyRowVisible then   // Mantis 3884
        Inc(RecordCount);
    end
    else
      RecordCount := MaxInt;

    FDataListForm.FList.LookupField := FLookupFieldName;
    FDataListForm.FList.LookupFormat := FLookupFormat;
    FDataListForm.FList.ListStyle := FListStyle;
    FDataListForm.FList.FieldsDelimiter := FFieldsDelimiter;
    FDataListForm.FList.IgnoreCase := FIgnoreCase;
    FDataListForm.FList.IndexSwitch := FIndexSwitch;
    FDataListForm.FList.OnGetImage := OnGetImage;
    FDataListForm.FList.ImageList := ImageList;
    FDataListForm.FList.OnGetImageIndex := OnGetImageIndex;
    // polaris    if FDisplayField <> nil then FAlignment := FDisplayField.Alignment;
    S := '';
    for I := 0 to FListFields.Count - 1 do
      S := S + TField(FListFields[I]).FieldName + ';';
    FDataListForm.FList.LookupDisplay := S;
    FDataListForm.FList.LookupDisplayIndex := FListFields.IndexOf(FDisplayField);
    {FDataListForm.FList.FLockPosition := True;}
    try
      FDataListForm.FList.LookupSource := FLookupLink.DataSource;
    finally
      {FDataListForm.FList.FLockPosition := False;}
    end;
    FDataListForm.FList.SetValueKey(SelValue);
    {FDataListForm.FList.KeyValueChanged;}
    if FDropDownWidth > 0 then
      FDataListForm.FList.Width := FDropDownWidth
    else
    if FDropDownWidth < 0 then
      FDataListForm.FList.Width := Max(Width, FDataListForm.FList.GetWindowWidth)
    else
      FDataListForm.FList.Width := Width;

    if (DropDownCount > RecordCount) then
      FDataListForm.FList.RowCount := RecordCount
    else
      FDataListForm.FList.RowCount := DropDownCount;

    // Adjust if too close to workarea borders

    //Monitor := FindMonitor(MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST));
    //Rect := GetWorkAreaRect(Monitor);
    Monitor := Screen.MonitorFromWindow(Handle);
    Rect := Monitor.WorkareaRect;

    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FDataListForm.FList.Height > Rect.Bottom then
      Y := P.Y - FDataListForm.FList.Height;
    case FDropDownAlign of
      daRight:
        Dec(P.X, FDataListForm.FList.Width - Width);
      daCenter:
        Dec(P.X, (FDataListForm.FList.Width - Width) div 2);
    end;
    if P.X + FDataListForm.FList.Width > Rect.Right then
      P.X := Rect.Right - FDataListForm.FList.Width;

    (*
    { Use slide-open effect for combo boxes if wanted.}
    SystemParametersInfo(SPI_GETCOMBOBOXANIMATION, 0, @Animate, 0);
    if Assigned(AnimateWindowProc) and Animate then
    begin
      { Can't use SWP_SHOWWINDOW here, because the window is then immediately shown }
      SetWindowPos(FDataListForm.FList.Handle, HWND_TOP, Max(P.X, Rect.Left), Y, 0, 0,
        SWP_NOSIZE or SWP_NOACTIVATE {or SWP_SHOWWINDOW});
      if Y < P.Y then
        SlideStyle := AW_VER_NEGATIVE
      else
        SlideStyle := AW_VER_POSITIVE;
      { 150 is a bit arbitrary (<200 is recommended) }
      AnimateWindowProc(FDataListForm.FList.Handle, 150, SlideStyle or AW_SLIDE);
      ShowWindow(FDataListForm.FList.Handle, SW_SHOWNOACTIVATE);
      { Pre XP systems seem to need this }
      FDataListForm.FList.Invalidate;
    end
    else
    *)
    {SetWindowPos(FDataListForm.Handle, HWND_TOP, Max(P.X, Rect.Left), Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);}

    FDataListForm.Left := Max(P.X, Rect.Left);
    FDataListForm.Top := Y;
    if (DropDownCount > RecordCount) then
      FDataListForm.FList.RowCount := RecordCount
    else
      FDataListForm.FList.RowCount := DropDownCount;
    FDataListForm.Width := FDataListForm.FList.Width;
    FDataListForm.Height := FDataListForm.FList.Height;

    FDataListForm.Visible := True;
    //FDataListForm.FList.SetFocus;

    FListVisible := True;
    InvalidateText;
    InvalidateDropDownButton;
    Repaint;
  end;
end;

function TJvDBLookupCombo.GetMinHeight: Integer;
begin
  Result := DefaultTextHeight + GetBorderSize {+ 3};
end;

procedure TJvDBLookupCombo.UpdateFieldText;
var
  I: Integer;
  S: string;
begin
  if FDisplayValues <> nil then
    FDisplayValues.Clear;
  if DisplayAllFields then
  begin
    S := DoFormatLine;
    if (ListStyle = lsFixed) and Assigned(FDisplayValues) then
      for I := 0 to FListFields.Count - 1 do
        //begin
          //if S <> '' then
          //  S := S + FFieldsDelimiter + ' ';
          //S := S + TField(FListFields[I]).DisplayText;
        //  begin
        with TField(FListFields[I]) do
          FDisplayValues.AddObject(DisplayText,
            TObject(PtrInt(MakeLong(DisplayWidth, Ord(Alignment)))));
    //  end;
    //end;
    if S = '' then
      S := FDisplayField.DisplayText;
    inherited Text := S;
  end
  else
    inherited Text := FDisplayField.DisplayText;
  FAlignment := FDisplayField.Alignment;
end;

function TJvDBLookupCombo.GetDisplayValues(Index: Integer): string;
begin
  if Assigned(FDisplayValues) and (FDisplayValues.Count > Index) then
    Result := FDisplayValues[Index]
  else
    Result := FDisplayValue;
end;

function TJvDBLookupCombo.GetText: string;
begin
  Result := inherited Text;
end;

procedure TJvDBLookupCombo.InvalidateText;
var
  R: TRect;
begin
  if BiDiMode = bdRightToLeft then
    R := Rect(FButtonWidth + 1, 1, ClientWidth - 1, ClientHeight - 1)
  else
    R := Rect(1, 1, ClientWidth - FButtonWidth - 1, ClientHeight - 1);
  InvalidateRect(Self.Handle, @R, False);
  UpdateWindow(Self.Handle);
end;

procedure TJvDBLookupCombo.KeyDown(var Key: Word; Shift: TShiftState);
var
  Delta: Integer;
begin
  inherited KeyDown(Key, Shift); // Let the user override the behavior
  if FListActive and ((Key = VK_UP) or (Key = VK_DOWN)) then
  begin
    if ssAlt in Shift then
    begin
      if FListVisible then
        CloseUp(True)
      else
        DropDown;
      Key := 0;
    end
    else
    if not FListVisible and not ReadOnly then
    begin
      if not LocateKey then
        FLookupLink.DataSet.First
      else
      begin
        if Key = VK_UP then
          Delta := -1
        else
          Delta := 1;
        FLookupLink.DataSet.MoveBy(Delta);
      end;
      SelectKeyValue(FKeyField.AsString);
      Key := 0;
    end;
  end
  else if not FListVisible and (Key = VK_DELETE) and ([ssShift, ssAlt, ssCtrl] * Shift = []) then
  begin
    if DeleteKeyClear and not ValueIsEmpty(FValue) and CanModify then
    begin
      ResetField;
      if FValue = FEmptyValue then
        Key := 0;
    end;
  end;

  if (Key <> 0) and FListVisible then
    FDataListForm.FList.KeyDown(Key, Shift);
end;

procedure TJvDBLookupCombo.UTF8KeyPress(var Key: TUTF8Char);
begin
  inherited UTF8KeyPress(Key);
  if FListVisible then
  begin
    if TabSelects and IsDropDown and (Key = Tab) then
      Key := Cr;

    if (Key = Cr) or (Key = Esc) then
    begin
      CloseUp(Key = Cr);
      Key := #0;
    end
    else
      FDataListForm.FList.UTF8KeyPress(Key)
  end
  else
  begin
    if Key >= #32 then
    begin
      DropDown;
      if FListVisible then
        FDataListForm.FList.UTF8KeyPress(Key);
    end
    else
    if (Key = Esc) and FEscapeKeyReset then
    begin
      if (Field <> nil) and FDataLink.Active and CanModify and
         not VarIsEmpty(FLastValue) and (Field.Value <> FLastValue) and FDataLink.Edit then
      begin
        Field.Value := FLastValue;
        Key := #0;
      end;
    end;
  end;
  //if CharInSet(Key, [Cr, Esc]) then
  //  GetParentForm(Self).Perform(CM_DIALOGKEY, Byte(Key), 0);
end;

procedure TJvDBLookupCombo.DisplayValueChanged;
begin
  if FListActive and LocateDisplay then
  begin
    FValue := FKeyField.AsString;
    UpdateFieldText;
  end
  else
  begin
    FValue := FEmptyValue;
    inherited Text := DisplayEmpty;
    if FDisplayValues <> nil then
      FDisplayValues.Clear;
    FAlignment := taLeftJustify;
  end;
  UpdateDisplayValue;
  UpdateCurrentImage;
  Invalidate;
end;

procedure TJvDBLookupCombo.KeyValueChanged;
begin
  if FLookupMode then
  begin
    if FDisplayValues <> nil then
      FDisplayValues.Clear;
    if FDataLink.Active and (FDataField <> nil) then {begin
      inherited Text := FDataField.DisplayText;
      FAlignment := FDataField.Alignment;
    end}
      if ValueIsEmpty(FValue) then
      begin
        inherited Text := DisplayEmpty;
        FAlignment := taLeftJustify;
      end
      else
      begin
        inherited Text := FDataField.DisplayText;
        FAlignment := FDataField.Alignment;
      end
    else
      inherited Text := '';
  end
  else
  if FListActive and LocateKey then
    UpdateFieldText
  else
  if FListActive then
  begin
    FValue := FEmptyValue;
    inherited Text := DisplayEmpty;
    if FDisplayValues <> nil then
      FDisplayValues.Clear;
    FAlignment := taLeftJustify;
  end
  else
  begin
    if csDesigning in ComponentState then
      inherited Text := DisplayEmpty
    else
      inherited Text := '';
    if FDisplayValues <> nil then
      FDisplayValues.Clear;
  end;
  UpdateDisplayValue;
  UpdateCurrentImage;
  Invalidate;
end;

procedure TJvDBLookupCombo.SetFieldsDelimiter(AValue: Char);
begin
  if FFieldsDelimiter <> AValue then
  begin
    inherited SetFieldsDelimiter(AValue);
    if (ListStyle = lsDelimited) and DisplayAllFields and
      not (csReading in ComponentState) then
      KeyValueChanged;
  end;
end;

procedure TJvDBLookupCombo.SetListStyle(AValue: TLookupListStyle);
begin
  if FListStyle <> AValue then
  begin
    FListStyle := AValue;
    if DisplayAllFields and not (csReading in ComponentState) then
      KeyValueChanged;
  end;
end;

function TJvDBLookupCombo.GetDisplayAllFields: Boolean;
begin
  if FLookupMode then
    Result := False
  else
    Result := FDisplayAllFields;
end;

procedure TJvDBLookupCombo.SetDisplayAllFields(AValue: Boolean);
begin
  if FDisplayAllFields <> AValue then
  begin
    if FLookupMode then
      FDisplayAllFields := False
    else
      FDisplayAllFields := AValue;
    if not (csReading in ComponentState) and not FLookupMode then
      KeyValueChanged
    else
      Invalidate;
  end;
end;

procedure TJvDBLookupCombo.ListLinkDataChanged;
begin
  if FDataLink.Active and FDataLink.DataSet.IsLinkedTo(LookupSource) then
    if FListActive then
      DataLinkRecordChanged(nil);
end;

procedure TJvDBLookupCombo.ListLinkDataSetChanged;
begin
  inherited ListLinkDataSetChanged;
  if not FInListDataSetChanged and not FListVisible and
    (FLookupSource <> nil) and (FLookupSource.DataSet <> nil) and (FLookupSource.DataSet.State = dsBrowse) then
  begin
    FInListDataSetChanged := True;
    try
      if FListActive and Assigned(FMasterField) then
        UpdateKeyValue
      else
        KeyValueChanged;
    finally
      FInListDataSetChanged := False;
    end;
  end;
end;

procedure TJvDBLookupCombo.ListLinkActiveChanged;
begin
  inherited ListLinkActiveChanged;
  if FListActive and Assigned(FMasterField) then
    UpdateKeyValue
  else
    KeyValueChanged;
end;

procedure TJvDBLookupCombo.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FDataListForm.FList.ClientRect, Point(X, Y)));
end;

procedure TJvDBLookupCombo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if CanFocus then
      SetFocus;
    if not FFocused then
      Exit;
    if FListVisible then
      CloseUp(False)
    else
    if {FListActive} CanModify then
    begin
      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TJvDBLookupCombo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: {$IFDEF CPU64}TPoint{$ELSE}TSmallPoint{$ENDIF};
begin
  SetMouseOverButton(PtInRect(GetDropDownButtonRect, Point(X, Y)));
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ListPos := FDataListForm.FList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(FDataListForm.FList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos.X := ListPos.X;
        MousePos.Y := ListPos.Y;
        SendMessage(FDataListForm.FList.Handle, LM_LBUTTONDOWN, 0, LPARAM(MousePos));
        Exit;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TJvDBLookupCombo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  StopTracking;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TJvDBLookupCombo.SetMouseOverButton(AValue: Boolean);
begin
  if AValue <> FMouseOverButton then
  begin
    FMouseOverButton := AValue;
    InvalidateDropDownButton;
  end;
end;

procedure TJvDBLookupCombo.CreateWnd;
begin
  inherited CreateWnd;
  Height := Max(Height, GetMinHeight);
end;

procedure TJvDBLookupCombo.SetReadOnly(AValue: Boolean);
begin
  inherited SetReadOnly(AValue);
  InvalidateFrame;
end;

procedure TJvDBLookupCombo.GetPreferredSize(var PreferredWidth,
  PreferredHeight: integer; Raw: boolean; WithThemeSpace: boolean);
begin
  inherited GetPreferredSize(PreferredWidth, PreferredHeight, Raw,
    WithThemeSpace);
  Height := GetMinHeight;
end;

function TJvDBLookupCombo.GetDropDownButtonRect: TRect;
begin
  Result := Rect(ClientWidth - FButtonWidth - (Width - ClientWidth) div 2, 0, Width, ClientHeight);
end;

procedure TJvDBLookupCombo.InvalidateFrame;
begin
  if StyleServices.Enabled and HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME);
end;

procedure TJvDBLookupCombo.InvalidateDropDownButton;
var
  R: TRect;
begin
  if StyleServices.Enabled and HandleAllocated then
  begin
    R := GetDropDownButtonRect;
    InvalidateRect(Handle, @R, True);
  end;
end;

procedure TJvDBLookupCombo.UpdateCurrentImage;
begin
  FSelImage.Assign(nil);
  FSelMargin := 0;
  FSelMarginImg := 0;
  FSelImage.Graphic := inherited GetPicture(False, ValueIsEmpty(Value), FSelMargin);
  FSelImageIndex := inherited GetImageIndex(False, ValueIsEmpty(Value), FSelMarginImg);
end;

function TJvDBLookupCombo.GetPicture(Current, Empty: Boolean;
  var TextMargin: Integer): TGraphic;
begin
  if Current then
  begin
    TextMargin := 0;
    Result := nil;
    if (FSelImage <> nil) and (FSelImage.Graphic <> nil) and not FSelImage.Graphic.Empty then
    begin
      Result := FSelImage.Graphic;
      TextMargin := FSelMargin;
    end;
  end
  else
    Result := inherited GetPicture(Current, Empty, TextMargin);
end;

function TJvDBLookupCombo.GetImageIndex(Current, Empty: Boolean;
  var TextMargin: Integer): Integer;
begin
  if Current then
  begin
    TextMargin := 0;
    Result := -1;
    if FSelImageIndex > -1 then
    begin
      Result := FSelImageIndex;
      TextMargin := FSelMarginImg;
    end;
  end
  else
    Result := inherited GetImageIndex(Current, Empty, TextMargin);
end;

procedure TJvDBLookupCombo.PaintDisplayValues(ACanvas: TCanvas; R: TRect;
  ALeft: Integer);
var
  I, LastIndex, TxtWidth: Integer;
  X, W, ATop, ARight: Integer;
  S: string;
  TStyle: TTextStyle;
begin
  if ColorToRGB(Self.Color) <> ColorToRGB(clBtnFace) then
    ACanvas.Pen.Color := clBtnFace
  else
    ACanvas.Pen.Color := clBtnShadow;
  LastIndex := FDisplayValues.Count - 1;
  TxtWidth := ACanvas.TextWidth('M');
  ATop := 0;
  ARight := R.Right;
  Inc(R.Left, ALeft);
  for I := 0 to LastIndex do
  begin
    S := FDisplayValues[I];
    W := LoWord(PtrInt(FDisplayValues.Objects[I]));
    if I < LastIndex then
      W := W * TxtWidth + 4
    else
      W := ARight - R.Left;
    X := 2;
    R.Right := R.Left + W;
    case TAlignment(HiWord(PtrInt(FDisplayValues.Objects[I]))) of
      taRightJustify:
        X := W - ACanvas.TextWidth(S) - 3;
      taCenter:
        X := (W - ACanvas.TextWidth(S)) div 2;
    end;
    TStyle := ACanvas.TextStyle;
    TStyle.Layout := tlCenter;
    ACanvas.TextStyle := TStyle;
    ACanvas.TextRect(R, R.Left + Max(0, X), ATop, S);
    Inc(R.Left, W);
    if I < LastIndex then
    begin
      ACanvas.MoveTo(R.Right, R.Top);
      ACanvas.LineTo(R.Right, R.Bottom);
      Inc(R.Left);
    end;
    if R.Left >= ARight then
      Break;
  end;
end;

procedure TJvDBLookupCombo.WMEraseBkgnd(var Message: TLMEraseBkgnd);
var
  IsClipped: Boolean;
  SaveRgn: HRGN;
  ButtonLeft: Integer;
begin
  IsClipped := False;
  SaveRgn := 0;
  if not DoubleBuffered and
    (TLMessage(Message).WParam <> WPARAM(TLMessage(Message).LParam)) //and
    { Do not exclude parts if we are painting into a memory device context or
      into a child's device context through DrawParentBackground(). }
    {(WindowFromDC(Message.DC) = Handle)} then
  begin
    SaveRgn := CreateRectRgn(0, 0, 1, 1);
    IsClipped := GetClipRgn(Message.DC, SaveRgn) = 1;
    { Exclude the edit rectangle and the drop down button. }
    ButtonLeft := ClientWidth - FButtonWidth;
    ExcludeClipRect(Message.DC, 1, 1, ButtonLeft - 1, ClientHeight - 1);
    ExcludeClipRect(Message.DC, ButtonLeft, 0, ClientWidth, ClientHeight);
  end;
  inherited;

  { Restore the backuped clipping region }
  if SaveRgn <> 0 then
  begin
    if IsClipped then
      SelectClipRgn(Message.DC, SaveRgn)
    else
      SelectClipRgn(Message.DC, 0);
    DeleteObject(SaveRgn);
  end;
end;

procedure TJvDBLookupCombo.Paint;
var
  W, X, Flags, TextMargin: Integer;
  AText: string;
  Selected, DrawList, IsEmpty: Boolean;
  R, ImageRect: TRect;
  Image: TGraphic;
  ImgIndex: Integer;
  Alignment: TAlignment;
  State: TThemedComboBox;
  Details: TThemedElementDetails;
  TStyle: TTextStyle;
begin
  if csDestroying in ComponentState then
    Exit;
  Selected := FFocused and not FListVisible and  not (csPaintCopy in ControlState);

  Canvas.Font := Font;
  if Color = clDefault then
    Canvas.Brush.Color := GetDefaultColor(dctBrush)
  else
    Canvas.Brush.Color := Color;
  if Selected then
  begin
    Canvas.Font.Color := clHighlightText;
    Canvas.Brush.Color := clHighlight;
  end
  else
    if not Enabled then
      Canvas.Font.Color := clGrayText;

  AText := inherited Text;
  Alignment := FAlignment;
  Image := nil;
  IsEmpty := False;
  ImgIndex := -1;
  DrawList := DisplayAllFields;
  if (csPaintCopy in ControlState) and (FDataField <> nil) then
  begin
    DrawList := False;
    AText := FDataField.DisplayText;
    Alignment := FDataField.Alignment;
  end;
  TextMargin := 0;
  if FListVisible then
  begin
    DrawList := False;
    if FDataListForm.FList.FSearchText <> '' then
      AText := FDataListForm.FList.FSearchText
    else
    begin
      if FDataListForm.FList.ValueIsEmpty(FDataListForm.FList.Value) then
      begin
        AText := DisplayEmpty;
        IsEmpty := True;
        Image := GetPicture(False, True, TextMargin);
        if (Image = nil) and Assigned(ImageList) then
          ImgIndex := GetImageIndex(False, True, TextMargin);
      end
      else
    if FDataListForm.FList.FKeyField.AsString = FDataListForm.FList.Value then
      begin
        AText := FDataListForm.FList.FDisplayField.DisplayText;
        Image := FDataListForm.FList.GetPicture(False, False, TextMargin);
        if (Image = nil) and Assigned(ImageList) then
          ImgIndex := GetImageIndex(False, False, TextMargin);
      end
      else
      begin
        Image := GetPicture(True, False, TextMargin);
        if (Image = nil) and Assigned(ImageList) then
          ImgIndex := GetImageIndex(False, False, TextMargin);
      end;
    end;
  end
  else
  begin
    if csPaintCopy in ControlState then
      Image := nil
    else
    begin
      IsEmpty := ValueIsEmpty(Value);
      Image := GetPicture(True, IsEmpty, TextMargin);
      if (Image = nil) and Assigned(ImageList) then
        ImgIndex := GetImageIndex(False, IsEmpty, TextMargin);
    end;
  end;
  if UseRightToLeftAlignment then
    ChangeBiDiModeAlignment(Alignment);

  W := ClientWidth - FButtonWidth;

  if W > 4 then
  begin
    R := Rect({1}0, {1}0, W - 2, ClientHeight {- 1});
    if TextMargin > 0 then
      Inc(TextMargin);
    X := 4 + TextMargin;
    if not (FListVisible and (FDataListForm.FList.FSearchText <> '')) and not DrawList then
      case Alignment of
        taRightJustify:
          X := W - Canvas.TextWidth(AText) - 6;
        taCenter:
          X := (W + TextMargin - Canvas.TextWidth(AText)) div 2;
      end;
    if BiDiMode = bdRightToLeft then
    begin
      Dec(X, TextMargin);
      Inc(R.Left, FButtonWidth);
      R.Right := ClientWidth;
    end;
    //if SysLocale.MiddleEast then
    //begin
    //  TControlCanvas(Self.Canvas).UpdateTextFlags;
    //  Canvas.TextFlags := Self.Canvas.TextFlags;
    //end;
    Canvas.FillRect(R);
    ImageRect := R;
    if DrawList and (ListStyle = lsFixed) and (FDisplayValues <> nil) and
      (FDisplayValues.Count > 0) then
    begin
      if IsEmpty then
      begin
        AText := DisplayEmpty;
        Canvas.TextRect(ImageRect, X, R.Top + Max(0, (RectHeight(R) -
          Canvas.TextHeight(AText)) div 2), AText);
      end
      else
        PaintDisplayValues(Canvas, ImageRect, TextMargin);
    end
    else
    begin
      TStyle := Canvas.TextStyle;
      TStyle.Layout := tlCenter;
      Canvas.TextStyle := TStyle;
      Canvas.TextRect(ImageRect, X, R.Top, AText);
    end;

    if Image <> nil then
    begin
      if BidiMode = bdRightToLeft then
        ImageRect.Left := ImageRect.Right - (TextMargin + 2)
      else
        ImageRect.Right := ImageRect.Left + TextMargin + 2;
      DrawPicture(Canvas, ImageRect, Image);
    end
    else if (ImgIndex > -1) and Assigned(ImageList) then
    begin
      if BidiMode = bdRightToLeft then
        ImageRect.Left := ImageRect.Right - (TextMargin + 2)
      else
        ImageRect.Right := ImageRect.Left + TextMargin + 2;
      DrawImage(Canvas, ImageRect, ImgIndex);
    end;

    if Selected then
      Canvas.DrawFocusRect(R);
  end;
  SetRect(R, W, 0, ClientWidth, ClientHeight);
  if BiDiMode = bdRightToLeft then
  begin
    R.Left := 0;
    R.Right := FButtonWidth;
  end;
  if StyleServices.Enabled then
  begin
      if not FListActive or not Enabled or ReadOnly then
        State := tcDropDownButtonDisabled
      else
      if FPressed or FListVisible then
        State := tcDropDownButtonPressed
      else
      if FMouseOver and FMouseOverButton and not FListVisible then
        State := tcDropDownButtonHot
      else
        State := tcDropDownButtonNormal;
      Details := StyleServices.GetElementDetails(State);
      StyleServices.DrawElement(Canvas.Handle, Details, R);
  end
  else
  begin
    if not FListActive or not Enabled or ReadOnly then
      Flags := DFCS_SCROLLCOMBOBOX or DFCS_INACTIVE
    else
    if FPressed then // Classic Style doesn't keep the button pressed while the popup is visible
      Flags := DFCS_SCROLLCOMBOBOX or DFCS_FLAT or DFCS_PUSHED
    else
      Flags := DFCS_SCROLLCOMBOBOX;
    DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, Flags);
  end;
end;

procedure TJvDBLookupCombo.ResetField;
begin
  if FListVisible then
    CloseUp(False);
  inherited ResetField;
  UpdateCurrentImage;
  Invalidate;
end;

procedure TJvDBLookupCombo.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TJvDBLookupCombo.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
begin
  NewState := PtInRect(GetDropDownButtonRect, Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    InvalidateDropDownButton;
    Repaint;
  end;
end;

procedure TJvDBLookupCombo.UpdateDisplayEmpty(const AValue: string);
begin
  if Text = FDisplayEmpty then
    inherited Text := AValue;
end;

procedure TJvDBLookupCombo.Click;
begin
  inherited Click;
  Change;
end;

procedure TJvDBLookupCombo.CNKeyDown(var Msg: TLMKeyDown);
begin
  if not (csDesigning in ComponentState) then
  begin
    if TabSelects and IsDropDown and (Msg.Charcode = VK_TAB) then
      Msg.Charcode := VK_RETURN;

    if (Msg.CharCode in [VK_RETURN, VK_ESCAPE]) and FListVisible and
      FLookupMode and FDataLink.DataSourceFixed then
    begin
      CloseUp(Msg.CharCode = VK_RETURN);
      Msg.Result := 1;
      Exit;
    end;
  end;
  inherited;
end;

procedure TJvDBLookupCombo.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  if not (csReading in ComponentState) then
    Height := Max(Height, GetMinHeight);
end;

procedure TJvDBLookupCombo.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  {Windows XP themes use hot track states, hence we have to update the drop down button.}
  if StyleServices.Enabled and not FMouseOver then
  begin
    InvalidateFrame;
  end;
  FMouseOver := True;
  inherited MouseEnter;
end;

procedure TJvDBLookupCombo.MouseLeave;
begin
  if FMouseOver then
  begin
    SetMouseOverButton(False);
    InvalidateFrame; // border also needs a repaint
  end;
  FMouseOver := False;
  inherited MouseLeave;
end;

procedure TJvDBLookupCombo.EnabledChanged;
begin
  inherited EnabledChanged;
  Invalidate;
end;

procedure TJvDBLookupCombo.CMGetDataLink(var Msg: TLMessage);
begin
  Msg.Result := LRESULT(FDataLink);
end;

function TJvDBLookupCombo.GetDataLink: TDataLink;
begin
  Result := FDataLink;
end;

procedure TJvDBLookupCombo.WMCancelMode(var Msg: TLMessage);
begin
  StopTracking;
  inherited;
end;

procedure TJvDBLookupCombo.WMSetCursor(var Msg: TLMSetCursor);
var
  Pt: TPoint = (X:0; Y:0);
  R: TRect;
begin
  GetCursorPos(Pt);
  R := ClientRect;
  if PtInRect(Bounds(R.Right - FButtonWidth, R.Top, FButtonWidth, R.Bottom - R.Top), ScreenToClient(Pt)) then
    {Windows.SetCursor(LoadCursor(0, IDC_ARROW))}
    SetCursor(crArrow)
  else
    inherited;
end;

procedure TJvDBLookupCombo.BoundsChanged;
begin
  inherited BoundsChanged;
  if not (csReading in ComponentState) and (Height < GetMinHeight) then
    Height := GetMinHeight
  else
  begin
    if csDesigning in ComponentState then
      FDataListForm.SetBounds(0, Height + 1, 10, 10);
  end;
end;

procedure TJvDBLookupCombo.CMBiDiModeChanged(var Msg: TLMessage);
begin
  inherited;
  FDataListForm.FList.BiDiMode := BiDiMode;
end;

//=== { TJvPopupDataWindow } =================================================
(*
constructor TJvPopupDataWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditor := TWinControl(AOwner);
  Visible := False;
  Parent := FEditor;
  OnMouseUp := @PopupMouseUp;
end;

procedure TJvPopupDataWindow.InvalidateEditor;
var
  R: TRect;
begin
  {if FEditor is TJvCustomComboEdit then
    with TJvComboEdit(FEditor) do
      SetRect(R, 0, 0, ClientWidth - Button.Width - 2, ClientHeight + 1)
  else}
    R := FEditor.ClientRect;
  {Windows.}InvalidateRect(FEditor.Handle, {$IFNDEF COMPILER12_UP}@{$ENDIF ~COMPILER12_UP}R, False);
  UpdateWindow(FEditor.Handle);
end;

procedure TJvPopupDataWindow.Click;
begin
  inherited Click;
  if Value <> '' then
    with TJvDBLookupEdit(FEditor) do
      if not (FChanging or ReadOnly) then
      begin
        FChanging := True;
        try
          Text := Self.DisplayValue;
          if AutoSelect then
            SelectAll;
        finally
          FChanging := False;
        end;
      end;
  InvalidateEditor;
end;

procedure TJvPopupDataWindow.DisplayValueChanged;
begin
  if not FLockPosition then
    if FListActive then
    begin
      if LocateDisplay then
        FValue := FKeyField.AsString
      else
      begin
        FLookupLink.DataSet.First;
        FValue := EmptyValue;
      end;
    end
    else
      FValue := FEmptyValue;
end;

procedure TJvPopupDataWindow.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  InvalidateEditor;
end;

procedure TJvPopupDataWindow.PopupMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(ClientRect, Point(X, Y)));
end;

procedure TJvPopupDataWindow.CloseUp(Accept: Boolean);
begin
  if Assigned(FCloseUp) then
    FCloseUp(Self, Accept);
end;

function TJvPopupDataWindow.GetPicture(Current, Empty: Boolean;
  var TextMargin: Integer): TGraphic;
begin
  TextMargin := 0;
  Result := nil;
  if Assigned(FOnGetImage) then
    FOnGetImage(FEditor, Empty, Result, TextMargin);
end;

procedure TJvPopupDataWindow.Hide;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
end;

procedure TJvPopupDataWindow.Show(Origin: TPoint);
begin
  SetWindowPos(Handle, HWND_TOP, Origin.X, Origin.Y, 0, 0,
    SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
  Visible := True;
end;
*)
//=== { TJvDBLookupEdit } ====================================================
(*
constructor TJvDBLookupEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropDownCount := 8;
  FPopupOnlyLocate := True;
  ControlState := ControlState + [csCreating];
  try
    FPopup := TJvPopupDataWindow.Create(Self);
    TJvPopupDataWindow(FPopup).OnCloseUp := PopupCloseUp;
    GlyphKind := gkDropDown; { force update }
  finally
    ControlState := ControlState - [csCreating];
  end;
end;

destructor TJvDBLookupEdit.Destroy;
begin
  if FPopup <> nil then
    with TJvPopupDataWindow(FPopup) do
    begin
      OnCloseUp := nil;
      OnGetImage := nil;
    end;
  FPopup.Free;
  FPopup := nil;
  inherited Destroy;
end;

procedure TJvDBLookupEdit.SetDropDownCount(Value: Integer);
begin
  if Value < 1 then
    Value := 1;
  if Value > 50 then
    Value := 50;
  FDropDownCount := Value;
end;

function TJvDBLookupEdit.GetListStyle: TLookupListStyle;
begin
  Result := TJvPopupDataWindow(FPopup).ListStyle;
end;

procedure TJvDBLookupEdit.SetListStyle(Value: TLookupListStyle);
begin
  TJvPopupDataWindow(FPopup).ListStyle := Value;
end;

function TJvDBLookupEdit.GetFieldsDelimiter: Char;
begin
  Result := TJvPopupDataWindow(FPopup).FieldsDelimiter;
end;

procedure TJvDBLookupEdit.SetFieldsDelimiter(Value: Char);
begin
  TJvPopupDataWindow(FPopup).FieldsDelimiter := Value;
end;

function TJvDBLookupEdit.GetLookupDisplay: string;
begin
  Result := TJvPopupDataWindow(FPopup).LookupDisplay;
end;

procedure TJvDBLookupEdit.SetLookupDisplay(const Value: string);
begin
  TJvPopupDataWindow(FPopup).LookupDisplay := Value;
end;

function TJvDBLookupEdit.GetDisplayIndex: Integer;
begin
  Result := TJvPopupDataWindow(FPopup).LookupDisplayIndex;
end;

procedure TJvDBLookupEdit.SetDisplayIndex(Value: Integer);
begin
  TJvPopupDataWindow(FPopup).LookupDisplayIndex := Value;
end;

function TJvDBLookupEdit.GetLookupField: string;
begin
  Result := TJvPopupDataWindow(FPopup).LookupField;
end;

procedure TJvDBLookupEdit.SetLookupField(const Value: string);
begin
  TJvPopupDataWindow(FPopup).LookupField := Value;
end;

function TJvDBLookupEdit.GetLookupSource: TDataSource;
begin
  Result := TJvPopupDataWindow(FPopup).LookupSource;
end;

procedure TJvDBLookupEdit.SetLookupSource(Value: TDataSource);
begin
  TJvPopupDataWindow(FPopup).LookupSource := Value;
end;

function TJvDBLookupEdit.GetOnGetImage: TGetImageEvent;
begin
  Result := TJvPopupDataWindow(FPopup).OnGetImage;
end;

procedure TJvDBLookupEdit.SetOnGetImage(Value: TGetImageEvent);
begin
  TJvPopupDataWindow(FPopup).OnGetImage := Value;
end;

function TJvDBLookupEdit.GetLookupValue: string;
begin
  TJvPopupDataWindow(FPopup).DisplayValue := Text;
  Result := TJvPopupDataWindow(FPopup).Value;
end;

procedure TJvDBLookupEdit.SetLookupValue(const Value: string);
begin
  TJvPopupDataWindow(FPopup).Value := Value;

  if Value = EmptyStr then
    Text := EmptyStr
  else
    Text := TJvPopupDataWindow(FPopup).DisplayValue;
end;

procedure TJvDBLookupEdit.ShowPopup(Origin: TPoint);
begin
  TJvPopupDataWindow(FPopup).Show(Origin);
end;

procedure TJvDBLookupEdit.HidePopup;
begin
  TJvPopupDataWindow(FPopup).Hide;
end;

procedure TJvDBLookupEdit.PopupDropDown(DisableEdit: Boolean);
begin
  if not (ReadOnly or PopupVisible) then
  begin
    if Assigned(FOnDropDown) then
      FOnDropDown(Self);
    with TJvPopupDataWindow(FPopup) do
    begin
      Color := Self.Color;
      Font := Self.Font;

      {$IFDEF JVCLStylesEnabled}
      if StyleServices.Enabled and TStyleManager.IsCustomStyleActive then
      begin
        Color := StyleServices.GetStyleColor(scComboBox);
        Font.Color  := StyleServices.GetStyleFontColor(sfComboBoxItemNormal);
      end;
      {$ENDIF JVCLStylesEnabled}

      if FDropDownWidth > 0 then
        Width := FDropDownWidth
      else
      if FDropDownWidth < 0 then
        Width := Max(Self.Width, GetWindowWidth)
      else
        Width := Self.Width;
      ReadOnly := Self.ReadOnly;
      RowCount := FDropDownCount;
    end;
  end;
  FBeforePopupValue := GetPopupValue;
  inherited PopupDropDown(False);
end;

procedure TJvDBLookupEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN]) and PopupVisible then
  begin
    TJvPopupDataWindow(FPopup).KeyDown(Key, Shift);
    Key := 0;
  end;
  inherited KeyDown(Key, Shift);
  FIgnoreChange := (SelLength > 0) or (Key = VK_BACK);
  if not (PopupVisible or ReadOnly) and (Key in [VK_UP, VK_DOWN]) and
    (Shift = []) then
  begin
    with TJvPopupDataWindow(FPopup) do
    begin
      KeyDown(Key, Shift);
      if Value <> EmptyValue then
        Key := 0;
    end;
  end;
end;

procedure TJvDBLookupEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  FIgnoreChange := (SelLength > 0) or (Key = Backspace);
end;

procedure TJvDBLookupEdit.Change;
begin
  if PopupOnlyLocate or PopupVisible then
    inherited Change
  else
  begin
    PopupChange;
    DoChange;
  end;
end;

procedure TJvDBLookupEdit.PopupChange;
var
  S: string;
  Len: Integer;
begin
  if FChanging or FIgnoreChange or ReadOnly then
  begin
    FIgnoreChange := False;
    Exit;
  end;
  FChanging := True;
  try
    S := Text;
    if TJvPopupDataWindow(FPopup).SearchText(S) then
    begin
      Len := Length(Text);
      Text := TJvPopupDataWindow(FPopup).DisplayValue;
      SelStart := Len;
      SelLength := Length(Text) - Len;
    end
    else
      with TJvPopupDataWindow(FPopup) do
        Value := EmptyValue;
  finally
    FChanging := False;
  end;
end;

procedure TJvDBLookupEdit.SetPopupValue(const Value: Variant);
begin
  if VarIsNullEmpty(Value) then
    TJvPopupDataWindow(FPopup).Value := TJvPopupDataWindow(FPopup).EmptyValue
  else
    TJvPopupDataWindow(FPopup).DisplayValue := Value;
  FBeforePopupValue := GetPopupValue;
end;

function TJvDBLookupEdit.GetPopupValue: Variant;
begin
  with TJvPopupDataWindow(FPopup) do
    if Value <> EmptyValue then
      Result := DisplayValue
    else
      Result := Self.Text;
end;

function TJvDBLookupEdit.AcceptPopup(var Value: Variant): Boolean;
begin
  Result := Value <> FBeforePopupValue;
  if Assigned(FOnCloseUp) then
    FOnCloseUp(Self);
end;

function TJvDBLookupEdit.GetUseRecordCount: Boolean;
begin
  Result := TJvPopupDataWindow(FPopup).UseRecordCount;
end;

procedure TJvDBLookupEdit.SetUseRecordCount(const Value: Boolean);
begin
  TJvPopupDataWindow(FPopup).UseRecordCount := Value;
end;
*)

end.

