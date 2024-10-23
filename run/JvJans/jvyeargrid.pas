{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvYearGrid.PAS, released on 2002-06-15.

The Initial Developer of the Original Code is Jan Verhoeven [jan1 dott verhoeven att wxs dott nl]
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s):
  Robert Love [rlove at slcdug dot org].
  Olivier Sannier [obones at users dot sourceforge dot net]

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvYearGrid;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, Types,
  Graphics, Controls, Forms, Dialogs, Grids, Menus, Clipbrd,
  SysUtils, StdCtrls, Classes,
  JvJVCLUtils, JvTypes;

const
  JvDefaultBorderColor = TColor($EEF5FF);
  JvDefaultBookmarkColor = clYellow;
  JvDefaultWeekendColor = TColor($DFDFDF);

type
  TYearData = record
    DisplayText: string;
    InfoText: string;
    DayInMonth: Integer;
    DefaultColor: TColor;
    CustomColor: TColor;
    Custom: Boolean;
    BookMark: Boolean; // this is not saved
  end;

  TJvYearGridOrientation = (yoHorizontal, yoVertical);
  TJvWeekDay = (wdMonday, wdTuesday, wdWednesday, wdThursday, wdFriday, wdSaturday, wdSunday);
  TJvWeekDaySet = set of TJvWeekDay;
  TJvMonthFormat = (mfShort, mfLong);
  TJvDayFormat = (dfInitial, dfShort, dfLong);
  TJvAutoSizeOptions = set of (aoGrid, aoFirstColumn, aoFirstRow, aoColumns, aoRows);

  TOnYearChanged = procedure(Sender: TObject; AYear: Integer) of object;
  TOnSelectDate = procedure(Sender: TObject; ADate: TDate; InfoText: string; InfoColor: TColor) of object;
  TOnInfoChanging = procedure(Sender: TObject; var InfoText: string; var CanChange: Boolean) of object;

  TDays = array [1..12] of Integer;
  TYearDataMatrix = array [0..37, 0..12] of TYearData;

  TJvYearGrid = class(TCustomDrawGrid)
  private
    FGridPop: TPopupMenu;
    FCurrentYear: Word;
    FCurrentMonth: Word;
    FCurrentDay: Word;
    FHTMLBorder: Boolean;
    FHTMLFontName: string;
    FBorderColor: TColor;
    FBookMarkColor: TColor;
    FWeekendColor: TColor;
    FAutoSize: Boolean;
    FDayFormat: TJvDayFormat;
    FMonthFormat: TJvMonthFormat;
    FReadOnly: Boolean;
    FOnInfoChanging: TOnInfoChanging;
    FOnSelectDate: TOnSelectDate;
    FOnYearChanged: TOnYearChanged;

    DaysInMonth: TDays;
    StartDays: TDays;

    FYearData: TYearDataMatrix;
    FYearFile: string;
    FOrientation: TJvYearGridOrientation;
    FSavedScrollBars: TScrollStyle;
    FFirstDayOfWeek: TJvWeekDay;
    FWeekendDays: TJvWeekDaySet;
    FAutoSizeOptions: TJvAutoSizeOptions;
    FCellMargins: TJvRect;
    FDaysAlignment: TAlignment;
    FDayNamesAlignment: TAlignment;
    FMonthNamesAlignment: TAlignment;
    FYearAlignment: TAlignment;
    FYear: Integer;

    // Getters, setters
    function GetFlat: Boolean;
    function IsHtmlFontNameStored: Boolean;
    procedure SetAutoSizeOptions(const Value: TJvAutoSizeOptions);
    procedure SetBookMarkColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetCellMargins(const Value: TJvRect);
    procedure SetDayFormat(const AValue: TJvDayFormat);
    procedure SetDayNamesAlignment(const Value: TAlignment);
    procedure SetDaysAlignment(const Value: TAlignment);
    procedure SetFirstDayOfWeek(const Value: TJvWeekDay);
    procedure SetFlat(AValue: Boolean);
    procedure SetHTMLBorder(const Value: Boolean);
    procedure SetHTMLFontName(const Value: string);
    procedure SetMonthFormat(const AValue: TJvMonthFormat);
    procedure SetMonthNamesAlignment(const Value: TAlignment);
    procedure SetOrientation(const Value: TJvYearGridOrientation);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetWeekendColor(const AValue: TColor);
    procedure SetWeekendDays(const Value: TJvWeekDaySet);
    procedure SetYear(const Value: Integer);
    procedure SetYearAlignment(const Value: TAlignment);
    
    // Event handlers
    procedure DoShowHint(var HintStr: THintString; var CanShow: Boolean;
      var HintInfo: THintInfo);
    procedure mnuBookMarkColorClick(Sender: TObject);
    procedure mnuBorderColorClick(Sender: TObject);
    procedure mnuClearFindClick(Sender: TObject);
    procedure mnuColorClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuNoColorClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSaveAsHTML(Sender: TObject);
    procedure mnuSaveFound(Sender: TObject);
    procedure mnuYearClick(Sender: TObject);
    procedure SetupGridPop(Sender: TObject);
    procedure SetYearChanged(const Value: TOnYearChanged);

    // Utilities
    procedure MakeHTML(AList: TStringList; Border, Filter: Boolean);

    procedure SetupYearData;
    procedure SetupMonths;
    function GetCellData(var S: string): Boolean;
    function SetCellData(S: string): Boolean;
    procedure CreatePopup;
    procedure Launch(AFile: string);
    procedure SetSelectDate(const Value: TOnSelectDate);
    procedure SetInfoChanging(const Value: TOnInfoChanging);
    procedure ClearBookMarks;
    function IsCurrentYear: Boolean;

    procedure CellMarginsChange(Sender: TObject);
    function GetDefaultColWidth: Integer;
    procedure SetDefaultColWidth(const Value: Integer);
    procedure SetDefaultRowHeihgt(const Value: Integer);
    procedure SetFirstColWidth(const Value: Integer);
    procedure SetFirstRowHeight(const Value: Integer);
    function GetFirstColWidth: Integer;
    function GetFirstRowHeight: Integer;
    procedure ColRowToDayMonthIndex(ACol, ARow: Integer; out DayIndex, MonthIndex: Integer);
    procedure DayMonthIndexToColRow(DayIndex: Integer; MonthIndex: Integer; out ACol, ARow: Integer);

  protected
    procedure DrawColumnText(aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState); override;
    procedure DrawTextInCell(aCol, aRow: Integer; aRect: TRect; {%H-}aState: TGridDrawState); override;
    function SelectCell(ACol, ARow: Integer): Boolean; override;
    procedure DblClick; override;
    procedure FontChanged(Sender: TObject); override;
    procedure DoPrepareCanvas(aCol,aRow:Integer; {%H-}aState: TGridDrawState); override;
    procedure SetAutoSize(Value: Boolean); override;
    procedure UpdateAllSizes;
    procedure AdjustBounds;
    procedure Loaded; override;
    procedure SetParent( AParent: TWinControl); override;
//    function GetDefaultRowHeight: Integer; override;

    // Those three methods are used to provide support for reading
    // the GridYear property from DFM files that were using
    // this component before its rewrite. The writer does nothing
    // because the value is now stored as Year.
    procedure ReadGridYear(Reader: TReader);
    procedure WriteGridYear({%H-}Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;

    { LCL scaling }
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadYear(FileName: string = '');
    procedure SaveYear(FileName: string = '');

    function GetSelDateText: string;
    procedure SetSelDateText(AText: string);

    function GetDateInfo(ADate: TDate; var AText: string): Boolean;
    function SetDateInfo(ADate: TDate; AText: string): Boolean;

    function CellToDate(ACol, ARow: Integer): TDate;
    function DateToCell(ADate: TDate; out ACol, ARow: Integer): Boolean;

    // This procedure does the default drawing for a given cell
    // It is made public so that you can call it in your OnDrawCell event
//    procedure DefaultDrawCell(ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

    // Converts a (col, row) pair to a (day, month) couple taking
    // into account the orientation. If no day is in the indicated cell
    // then the value of ADay is 0 on exit.
    procedure ColRowToDayMonth(ACol, ARow: Integer; var ADay, AMonth: Integer);

    // Converts a (day, month) couple to a (col, row) couple taking
    // into account the orientation. If the day doesn't exist in the month
    // the indicated cell may be outside the grid
    procedure DayMonthToColRow(ADay, AMonth: Integer; var ACol, ARow: Integer);

    procedure Find;
  published
    property HTMLBorder: Boolean read FHTMLBorder write SetHTMLBorder default false;
    property HTMLFontName: string read FHTMLFontName write SetHTMLFontName stored IsHtmlFontNameStored;
    property BorderColor: TColor read FBorderColor write SetBorderColor default JvDefaultBorderColor;
    property BookMarkColor: TColor read FBookMarkColor write SetBookMarkColor default JvDefaultBookmarkColor;
    property WeekendColor: TColor read FWeekendColor write SetWeekendColor default JvDefaultWeekendColor;
    property Orientation: TJvYearGridOrientation read FOrientation write SetOrientation default yoHorizontal;
    property FirstDayOfWeek: TJvWeekDay read FFirstDayOfWeek write SetFirstDayOfWeek default wdMonday;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default false;

    property Year: Integer read FYear write SetYear;
    property YearFile: string read FYearFile write FYearFile;

    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property AutoSizeOptions: TJvAutoSizeOptions read FAutoSizeOptions write SetAutoSizeOptions 
      default [aoGrid, aoFirstColumn, aoFirstRow, aoColumns, aoRows];

    property FirstColWidth: Integer read GetFirstColWidth write SetFirstColWidth;
    property FirstRowHeight: Integer read GetFirstRowHeight write SetFirstRowHeight;
    property CellMargins: TJvRect read FCellMargins write SetCellMargins;

    property DayFormat: TJvDayFormat read FDayFormat write SetDayFormat default dfInitial;
    property MonthFormat: TJvMonthFormat read FMonthFormat write SetMonthFormat default mfLong;
    property WeekendDays: TJvWeekDaySet read FWeekendDays write SetWeekendDays default [wdSaturday, wdSunday];

    property MonthNamesAlignment: TAlignment read FMonthNamesAlignment write SetMonthNamesAlignment default taLeftJustify;
    property DayNamesAlignment: TAlignment read FDayNamesAlignment write SetDayNamesAlignment default taCenter;
    property DaysAlignment: TAlignment read FDaysAlignment write SetDaysAlignment default taCenter;
    property YearAlignment: TAlignment read FYearAlignment write SetYearAlignment default taLeftJustify;

    property OnSelectCell;
    property OnDrawCell;
    property OnYearChanged: TOnYearChanged read FOnYearChanged  write SetYearChanged;
    property OnSelectDate: TOnSelectDate read FOnSelectDate write SetSelectDate;
    property OnInfoChanging: TOnInfoChanging read FOnInfoChanging write SetInfoChanging;
    property OnDblClick;
    property OnClick;

    property DefaultColWidth: Integer read GetDefaultColWidth write SetDefaultColWidth default 18;
    property DefaultRowHeight default 18;

    property Align;
    property Anchors;
    property BorderSpacing;
    property BorderStyle;
    property Flat read GetFlat write SetFlat default true;
    property Font;
    property ScrollBars default ssNone;
    property TitleStyle;
  end;


implementation

uses
  JvConsts, JvResources, JvYearGridEditForm;

const
  TodayFontColor = clWhite;
  TodayBrushColor = clRed;
  READONLY_TAG = 2;

constructor TJvYearGrid.Create(AOwner: TComponent);
var
  AYear, AMonth, ADay: Word;
begin
  inherited Create(AOwner);
  
  FCellMargins := TJvRect.Create;
  FCellMargins.Top := 2;
  FCellMargins.Left := 2;
  FCellMargins.Bottom := 2;
  FCellMargins.Right := 2;
  FCellMargins.OnChange := @CellMarginsChange; // Must be set last

  FOrientation := yoHorizontal;
  FDaysAlignment := taCenter;
  FDayNamesAlignment := taCenter;
  FMonthNamesAlignment := taLeftJustify;

  FDayFormat := dfInitial;
  FMonthFormat := mfLong;

  FFirstDayOfWeek := wdMonday;
  FWeekendDays := [wdSaturday, wdSunday];

  FAutoSizeOptions := [aoGrid, aoFirstColumn, aoFirstRow, aoColumns, aoRows];

  FBorderColor := JvDefaultBorderColor;
  FBookMarkColor := JvDefaultBookmarkColor;
  FWeekendColor := JvDefaultWeekendcolor;
  ShowHint := True;
  CreatePopup;
  PopupMenu := FGridPop;
  FGridPop.OnPopup := @SetupGridPop;

  // Those two must be set before setting DefaultColWidth and DefaultRowHeight
  FirstRowHeight := 18;
  FirstColWidth := 70;

  DefaultColWidth := 18;
  DefaultRowHeight := 18;

  ColCount := 38;
  RowCount := 13;
  FixedCols := 1;
  FixedRows := 1;
  Width := 512;
  Height := 213;
  Flat := true;

  DecodeDate(Now, FCurrentYear, FCurrentMonth, FCurrentDay);
  HTMLFontName := 'default';

  DecodeDate(Now, AYear, AMonth, ADay);
  FYear := AYear;
  SetupYearData;

  FAutoSize := True;
  FSavedScrollBars := ScrollBars;
  Invalidate;
end;

destructor TJvYearGrid.Destroy;
begin
//  SaveYear;
  FGridPop.Free;
  FCellMargins.Free;
  inherited Destroy;
end;

procedure TJvYearGrid.DoShowHint(var HintStr: THintString; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  ACol, ARow, X, Y: Integer;
  S, DS: string;
begin
  if HintInfo.HintControl = Self then
  begin
    X := HintInfo.CursorPos.X;
    Y := HintInfo.CursorPos.Y;
    MouseToCell(X, Y, ACol{%H-}, ARow{%H-});
    if (ACol < 0) or (ARow < 0) then
      Exit;
    DS := FYearData[ACol, ARow].DisplayText;
    if IsCurrentYear and (ARow = FCurrentMonth) and (DS = IntToStr(FCurrentDay)) then
      S := RsToday;
    CanShow := False;
    if (ACol >= 0) and (ARow >= 0) then
    begin
      S := S + FYearData[ACol, ARow].InfoText;
      if S <> '' then
      begin
        HintInfo.CursorRect := CellRect(ACol, ARow);
        HintStr := S;
        CanShow := True;
      end;
    end;
  end;
end;

procedure TJvYearGrid.MakeHTML(AList: TStringList; Border, Filter: Boolean);
var
  ACol, ARow: Integer;
  DS, Tbs, Infs: string;
  Month, Day: Word;
  ADate: TDate;
  CanAdd: Boolean;
  fontName: String;
begin
  if SameText(HTMLFontName, 'default') then
    fontName := GetFontData(Font.Handle).Name
  else
    fontName := HTMLFontName;
  
  AList.Clear;
  if Border then
    Tbs := '1'
  else
    Tbs := '0';
  AList.Append('<html><head><title>Year ' + IntToStr(Year) + '</title></head>');
  AList.Append('<body>');
  AList.Append('<font size=2 face="' + fontName + '">');
  AList.Append('<center><h3>Year ' + IntToStr(Year) + '</h3></center>');
  AList.Append('<Table width=100% border=' + Tbs + '>');
  for ARow := 1 to 12 do
    for ACol := 1 to 37 do
    begin
      CanAdd := FYearData[ACol, ARow].DisplayText <> '';
      if CanAdd then
        CanAdd := FYearData[ACol, ARow].InfoText <> '';
      if CanAdd and Filter then
        CanAdd := FYearData[ACol, ARow].BookMark;
      if CanAdd then
      begin
        Month := ARow;
        Day := StrToInt(FYearData[ACol, ARow].DisplayText);
        ADate := EncodeDate(Year, Month, Day);
        DS := FormatDateTime('ddd, ddddd', ADate);
        AList.Append('<tr>');
        AList.Append('<td width=20%>' + DS + '</td>');
        Infs := FYearData[ACol, ARow].InfoText;
        Infs := StringReplace(Infs, LineEnding, '<br>', [rfReplaceAll]);
        AList.Append('<td>' + Infs + '</td>');
        AList.Append('</tr>');
      end;
    end;
  AList.Append('</table>');
  AList.Append('</font></body></html>');
end;

procedure TJvYearGrid.mnuSaveAsHTML(Sender: TObject);
var
  List: TStringList;
  FileName: string;
begin
  List := TStringList.Create;
  MakeHTML(List, HTMLBorder, False);
  FileName := ChangeFileExt(FYearFile, '.htm');
  List.SaveToFile(FileName);
  List.Free;
  Launch(FileName);
end;

procedure TJvYearGrid.SetHTMLBorder(const Value: Boolean);
begin
  FHTMLBorder := Value;
end;

procedure TJvYearGrid.SetYearChanged(const Value: TOnYearChanged);
begin
  FOnYearChanged := Value;
end;

procedure TJvYearGrid.SetYear(const Value: Integer);
var
  AYear, AMonth, ADay: Word;
begin
  if Value <> FYear then
  begin
    FYear := Value;
    if Value = 0 then
    begin
      DecodeDate(Now, AYear, AMonth, ADay);
      FYear := AYear;
    end
    else
      FYear := Value;
    SetupYearData;

    if Assigned(FOnYearChanged) then
      FOnYearChanged(Self, FYear);
  end;
end;

procedure TJvYearGrid.SaveYear(FileName: string);
var
  MonthIndex, DayIndex: Integer;
  YList, DList: TStringList;
  S: string;
begin
  YList := TStringList.Create;
  DList := TStringList.Create;
  try
    for MonthIndex := 0 to 12 do
    begin
      for DayIndex := 0 to 37 do
      begin
        DList.Clear;
        DList.Append(FYearData[DayIndex, MonthIndex].DisplayText);
        S := FYearData[DayIndex, MonthIndex].InfoText;
        S := StringReplace(S, LineEnding, '||', [rfReplaceAll]);
        DList.Append(S);
        DList.Append(ColorToString(FYearData[DayIndex, MonthIndex].DefaultColor));
        DList.Append(ColorToString(FYearData[DayIndex, MonthIndex].CustomColor));
        if FYearData[DayIndex, MonthIndex].Custom then
          S := 'true'
        else
          S := 'false';
        DList.Append(S);
        YList.Append(DList.CommaText);
      end;
    end;
    if FileName = '' then
      YList.SaveToFile(FYearFile)
    else
      YList.SaveToFile(FileName);
  finally
    DList.Free;
    YList.Free;
  end;
end;

procedure TJvYearGrid.LoadYear(FileName: string);
var
  MonthIndex, DayIndex, Index: Integer;
  YList, DList: TStringList;
  S: string;
begin
  YList := TStringList.Create;
  DList := TStringList.Create;
  try
    if FileName = '' then
      YList.LoadFromFile(FYearFile)
    else
      YList.LoadFromFile(FileName);

    Index := 0;
    for MonthIndex := 0 to 12 do
    begin
      for DayIndex := 0 to 37 do
      begin
        DList.CommaText := YList[Index];
        Inc(Index);
        FYearData[DayIndex, MonthIndex].DisplayText := DList[0];
        S := DList[1];
        S := StringReplace(S, '||', LineEnding, [rfReplaceAll]);
        FYearData[DayIndex, MonthIndex].InfoText := S;
        FYearData[DayIndex, MonthIndex].DefaultColor := StringToColor(DList[2]);
        FYearData[DayIndex, MonthIndex].CustomColor := StringToColor(DList[3]);
        FYearData[DayIndex, MonthIndex].Custom := (DList[4] = 'true');
      end;
    end;
  finally
    DList.Free;
    YList.Free;
  end;
  Invalidate;
end;

procedure TJvYearGrid.SetupYearData;
var
  S, D: string;
  DayOfWeekIndex, DayIndex, MonthIndex: Integer;
  AColor: TColor;
begin
  SetupMonths;
  for MonthIndex := 0 to 12 do
    for DayIndex := 0 to 37 do
    begin
      S := '';
      if DayIndex > 0 then
      begin
        // This gives a value from 1 to 7, with 1 being the first day
        // of the week.
        DayOfWeekIndex := ((DayIndex - 1) mod 7) + 1;

        // As ShortDayNames considers the first day to be a Sunday,
        // we have to offset the value of DayOfTheWeekIndex to match the
        // desired first day of the week
        Inc(DayOfWeekIndex, Integer(FFirstDayOfWeek)+1);
        If DayOfWeekIndex > 7 then
          DayOfWeekIndex := DayOfWeekIndex - 7;
        case FDayFormat of
          dfInitial: D := FormatSettings.ShortDayNames[DayOfWeekIndex][1];
          dfShort  : D := FormatSettings.ShortDayNames[DayOfWeekIndex];
          dfLong   : D := FormatSettings.LongDayNames[DayOfWeekIndex];
        end;
      end;

      // By default, there is no day in the current cell
      FYearData[DayIndex, MonthIndex].DayInMonth := 0;

      if (MonthIndex = 0) and (DayIndex = 0) then
        S := IntToStr(Year);
      if (MonthIndex = 0) and (DayIndex > 0) then
        S := D;
      if (MonthIndex <> 0) and (DayIndex = 0) then
        case FMonthFormat of
          mfShort: S := FormatSettings.ShortMonthNames[MonthIndex];
          mfLong : S := FormatSettings.LongMonthNames[MonthIndex];
        end;
      if (MonthIndex <> 0) and (DayIndex > 0) then
      begin
        if (DayIndex >= StartDays[MonthIndex]) and (DayIndex < StartDays[MonthIndex] + DaysInMonth[MonthIndex]) then
        begin
          FYearData[DayIndex, MonthIndex].DayInMonth := DayIndex - StartDays[MonthIndex] + 1;
          S := IntToStr(FYearData[DayIndex, MonthIndex].DayInMonth);
        end;
      end;

      // AColor might have not been initialized with the following code.
      //if ((ACol>0)and (D='S')) then
      //  AColor:=clsilver;
      //if ((ACol>0)and (D<>'S')) then
      //  AColor:=clwhite;
      //  Change to:
      if (DayIndex > 0) and (DayOfWeekIndex in [1, 7]) then //(D = 'S') then
        AColor := FWeekendColor
      else
        AColor := clWhite;
      FYearData[DayIndex, MonthIndex].DisplayText := S;
      FYearData[DayIndex, MonthIndex].InfoText := '';
      FYearData[DayIndex, MonthIndex].DefaultColor := AColor;
      FYearData[DayIndex, MonthIndex].CustomColor := AColor;
      FYearData[DayIndex, MonthIndex].Custom := False;
      FYearData[DayIndex, MonthIndex].BookMark := False;
    end;
  AdjustBounds;
  Invalidate;
end;

procedure TJvYearGrid.ClearBookMarks;
var
  ACol, ARow: Integer;
  Cleared: Boolean;
begin
  Cleared := False;
  for ARow := 0 to 12 do
    for ACol := 0 to 37 do
    begin
      Cleared := Cleared or FYearData[ACol, ARow].BookMark;
      FYearData[ACol, ARow].BookMark := False;
    end;
  if Cleared then
    Invalidate;
end;

procedure TJvYearGrid.SetupMonths;
var
  AYear, AMonth, ADay: Word;
  ADate: TDate;
  I: Integer;
begin
  for I := 1 to 12 do
  begin
    AYear := Self.Year;
    AMonth := I + 1;
    if AMonth = 13 then
    begin
      AYear := AYear + 1;
      AMonth := 1;
    end;
    ADay := 1;
    ADate := EncodeDate(AYear, AMonth, ADay);
    ADate := ADate - 1;
    DecodeDate(ADate, AYear, AMonth, ADay);
    DaysInMonth[I] := ADay;
    AYear := Self.Year;
    AMonth := I;
    ADay := 1;
    ADate := EncodeDate(AYear, AMonth, ADay);
    StartDays[I] := DayOfWeek(ADate);
    Dec(StartDays[I], Integer(FFirstDayOfWeek)+1);
    If StartDays[I] < 1 then
      StartDays[I] := StartDays[I] + 7;
  end;
end;

function TJvYearGrid.GetCellData(var S: string): Boolean;
var
  ACol, ARow: Integer;
begin
  ACol := Col;
  ARow := Row;
  Result := False;
  if (ACol > 0) and (ARow > 0) then
    if FYearData[ACol, ARow].DisplayText <> '' then
    begin
      S := FYearData[ACol, ARow].InfoText;
      Result := True;
    end;
end;

function TJvYearGrid.SetCellData(S: string): Boolean;
var
  ACol, ARow: Integer;
begin
  ACol := Col;
  ARow := Row;
  Result := False;
  if (ACol > 0) and (ARow > 0) then
    if FYearData[ACol, ARow].DisplayText <> '' then
    begin
      FYearData[ACol, ARow].InfoText := S;
      Result := True;
    end;
end;

procedure TJvYearGrid.mnuCopyClick(Sender: TObject);
var
  S: string = '';
begin
  if GetCellData(S) then
    Clipboard.AsText := S;
end;

procedure TJvYearGrid.mnuCutClick(Sender: TObject);
var
  S: string = '';
begin
  if GetCellData(S) then
  begin
    Clipboard.AsText := S;
    SetCellData('');
  end;
end;

procedure TJvYearGrid.mnuYearClick(Sender: TObject);
var
  S: string;
  AYear: Word;
  n: Integer;
begin
  n := cInputQueryEditSizePercents;
  cInputQueryEditSizePercents := 0;
  S := InputBox(RsYearGrid, RsEnterYear, IntToStr(Self.Year));
  cInputQueryEditSizePercents := n;
  try
    if S = '' then
      Exit;
    AYear := StrToInt(S);
    if (AYear < 1999) or (AYear > 2050) then
      Exit;
    Self.Year := AYear;
  except
    ShowMessage(RsInvalidYear);
  end;
end;

procedure TJvYearGrid.mnuPasteClick(Sender: TObject);
var
  S: string = '';
begin
  if FReadOnly then
    exit;
  if GetCellData(S) then
    if Clipboard.HasFormat(CF_TEXT) then
      SetCellData(Clipboard.AsText);
end;

procedure TJvYearGrid.mnuDeleteClick(Sender: TObject);
var
  S: string = '';
begin
  if FReadOnly then
    exit;
  if GetCellData(S) then
    SetCellData('');
end;

procedure TJvYearGrid.CreatePopup;
const
  cMenuBreakCaption = '-';
var
  G: TPopupMenu;
  M: TMenuItem;
begin
  FGridPop := TPopupMenu.Create(Self);
  G := FGridPop;
  M := TMenuItem.Create(G);
  M.Caption := RsYear;
  M.OnClick := @mnuYearClick;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := cMenuBreakCaption;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsEdit;
  M.OnClick := @mnuEditClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsColor;
  M.OnClick := @mnuColorClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsNoColor;
  M.OnClick := @mnuNoColorClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := cMenuBreakCaption;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsCopyItem;
  M.OnClick := @mnuCopyClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsCutItem;
  M.OnClick := @mnuCutClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsPasteItem;
  M.OnClick := @mnuPasteClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsDeleteItem;
  M.OnClick := @mnuDeleteClick;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := cMenuBreakCaption;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsSaveAllInfo;
  M.OnClick := @mnuSaveAsHTML;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsSaveFoundInfo;
  M.OnClick := @mnuSaveFound;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := cMenuBreakCaption;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsBorderColor;
  M.OnClick := @mnuBorderColorClick;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsBookMarkColor;
  M.OnClick := @mnuBookMarkColorClick;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := cMenuBreakCaption;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsFindItem;
  M.OnClick := @mnuFindClick;
  M.Tag := 1;
  G.Items.Add(M);
  M := TMenuItem.Create(G);
  M.Caption := RsClearFind;
  M.OnClick := @mnuClearFindClick;
  M.Tag := 1;
  G.Items.Add(M);
end;

procedure TJvYearGrid.mnuEditClick(Sender: TObject);
var
  DS: string;
  lCol, lRow: Integer;
  F: TYearGridEditForm;
  CanChange: Boolean;
  InfoText: string;
begin
  if FReadOnly then
    exit;
  
  lCol := Col;
  lRow := Row;
  if (lCol < 1) or (lRow < 1) then
    Exit;
  DS := FYearData[lCol, lRow].DisplayText;
  if DS = '' then
    Exit;
  F := TYearGridEditForm.Create(Application);
  try
    InfoText := FYearData[lCol, lRow].InfoText;
    F.MemoText.Text := InfoText;
    F.Caption := 'Edit ' + DateToStr(CellToDate(lCol, lRow));
    F.ColorBox.Selected := FYearData[lCol, lRow].CustomColor;
    if F.ShowModal = mrOk then
    begin
      InfoText := F.MemoText.Text;
      CanChange := True;
      if Assigned(FOnInfoChanging) then
        FOnInfoChanging(Self, InfoText, CanChange);
      if CanChange then
      begin
        FYearData[lCol, lRow].InfoText := InfoText;
        if InfoText = '' then
          FYearData[lCol, lRow].Custom := False
        else
       // if not FYearData[lCol, lRow].Custom then
        begin
          FYearData[lCol, lRow].Custom := True;
          FYearData[lCol, lRow].CustomColor := F.ColorBox.Selected;
        end;
      end;
    end;
  finally
    F.Free;
  end;
end;

procedure TJvYearGrid.mnuColorClick(Sender: TObject);
var
  CD: TColorDialog;
begin
  if (Col < 1) or (Row < 1) or (FYearData[Col, Row].DisplayText = '') or FReadOnly then
    Exit;
  CD := TColorDialog.Create(Application);
  { -- not available in LCL:
  CD.Options := [cdFullOpen, cdAnyColor];
  }
  if CD.Execute then
  begin
    FYearData[Col, Row].CustomColor := CD.Color;
    FYearData[Col, Row].Custom := True;
    Invalidate;
  end;
  CD.Free;
end;

procedure TJvYearGrid.mnuNoColorClick(Sender: TObject);
begin
  if (Col < 1) or (Row < 1) or (FYearData[Col, Row].DisplayText = '') or FReadOnly then
    Exit;
  FYearData[Col, Row].Custom := False;
  Invalidate;
end;

procedure TJvYearGrid.SetupGridPop(Sender: TObject);
var
  I: Integer;
begin
  if (Col > 0) and (Row > 0) and (FYearData[Col, Row].DisplayText <> '') then
    for I := 0 to FGridPop.Items.Count - 1 do
    begin
      FGridPop.Items[I].Enabled := True;
      if (FGridPop.Items[I].Tag AND READONLY_TAG <> 0) and FReadOnly then
        FGridPop.Items[I].Enabled := False;
    end
  else
    for I := 0 to FGridPop.Items.Count - 1 do
    begin
      FGridPop.Items[I].Enabled := (FGridPop.Items[I].Tag = 1);
      if (FGridPop.Items[I].Tag AND READONLY_TAG <> 0) and FReadOnly then
        FGridPop.Items[I].Enabled := False;
    end;
end;

procedure TJvYearGrid.Launch(AFile: string);
begin
  OpenDocument(AFile);
end;

procedure TJvYearGrid.SetHTMLFontName(const Value: string);
begin
  FHTMLFontName := Value;
end;

function TJvYearGrid.GetSelDateText: string;
var
  DS: string;
begin
  if (Col < 1) or (Row < 1) then
    Exit;
  DS := FYearData[Col, Row].DisplayText;
  if DS = '' then
    Exit;
  Result := FYearData[Col, Row].InfoText;
end;

procedure TJvYearGrid.SetSelDateText(AText: string);
var
  DS: string;
begin
  if (Col < 1) or (Row < 1) then
    Exit;
  DS := FYearData[Col, Row].DisplayText;
  if DS = '' then
    Exit;
  FYearData[Col, Row].InfoText := AText;
end;

procedure TJvYearGrid.SetSelectDate(const Value: TOnSelectDate);
begin
  FOnSelectDate := Value;
end;

function TJvYearGrid.SelectCell(ACol, ARow: Longint): Boolean;
var
  DS: string;
  ADate: TDate;
  InfoText: string;
  InfoColor: TColor;
  MonthIndex, DayIndex: Integer;
  CanSelect: Boolean;
begin
  Result := False;

  CanSelect := True;
  if Assigned(OnSelectCell) then
    OnSelectCell(Self, ACol, ARow, CanSelect);
  if (not CanSelect) or (ACol < 1) or (ARow < 1) then
    Exit;

  ColRowToDayMonthIndex(ACol, ARow, DayIndex, MonthIndex);

  DS := FYearData[DayIndex, MonthIndex].DisplayText;
  if DS = '' then
    Exit;
  
  ADate := EncodeDate(Year, MonthIndex, FYearData[DayIndex, MonthIndex].DayInMonth);
  
  InfoText := FYearData[DayIndex, MonthIndex].InfoText;
  if FYearData[DayIndex, MonthIndex].Custom then
    InfoColor := FYearData[DayIndex, MonthIndex].CustomColor
  else
    InfoColor := FYearData[DayIndex, MonthIndex].DefaultColor;

  if Assigned(FOnSelectDate) then
    FOnSelectDate(Self, ADate, InfoText, InfoColor);
  
  Result := True;
end;

procedure TJvYearGrid.DblClick;
begin
  if Assigned(OnDblClick) then
    OnDblClick(Self)
  else
    if (Col > 0) and (Row > 0) and (FYearData[Col, Row].DisplayText <> '') then
      mnuEditClick(nil);
end;

procedure TJvYearGrid.FontChanged(Sender: TObject);
begin
  UpdateAllSizes;
  AdjustBounds;
  Invalidate;
end;

procedure TJvYearGrid.SetBorderColor(const Value: TColor);
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TJvYearGrid.mnuBorderColorClick(Sender: TObject);
var
  CD: TColorDialog;
begin
  CD := TColorDialog.Create(Application);
  { --- not available in LCL
  CD.Options := [cdFullOpen, cdAnyColor];
  }
  if CD.Execute then
    BorderColor := CD.Color;
  CD.Free;
end;

procedure TJvYearGrid.mnuBookMarkColorClick(Sender: TObject);
var
  CD: TColorDialog;
begin
  CD := TColorDialog.Create(Application);
  { --- not available in LCL
  CD.Options := [cdFullOpen, cdAnyColor];
  }
  if CD.Execute then
    BookMarkColor := CD.Color;
  CD.Free;
end;

procedure TJvYearGrid.SetInfoChanging(const Value: TOnInfoChanging);
begin
  FOnInfoChanging := Value;
end;

function TJvYearGrid.DateToCell(ADate: TDate; out ACol, ARow: Integer): Boolean;
var
  AYear, AMonth, ADay: Word;
  WD: Integer;
begin
  Result := False;
  DecodeDate(ADate, AYear, AMonth, ADay);
  if AYear <> Self.Year then
    Exit;
  WD := DayOfWeek(EncodeDate(AYear, AMonth, 1));
  Inc(WD, Integer(FirstDayOfWeek));
  if WD > 7 then
    Dec(WD, 7);
  DayMonthIndexToColRow(WD + ADay - 1, AMonth, ACol, ARow);
  Result := True;
end;

function TJvYearGrid.CellToDate(ACol, ARow: Integer): TDate;
var
  WD: Integer;
  lMonth, lDay: Integer;
begin
  lMonth := ARow;
  ColRowToDayMonthIndex(ACol, ARow, lDay, lMonth);
  WD := DayOfWeek(EncodeDate(FYear, lMonth, 1));
  Inc(WD, Integer(FirstDayOfWeek));
  if WD > 7 then
    Dec(WD, 7);
  lDay := lDay - WD + 2;
  if lDay < 1 then lDay := 1;
  if lDay > DaysInMonth[lMonth] then lDay := DaysInMonth[lMonth];
  Result := EncodeDate(FYear, lMonth, lDay);
end;

function TJvYearGrid.GetDateInfo(ADate: TDate; var AText: string): Boolean;
var
  lCol, lRow: Integer;
begin
  Result := DateToCell(ADate, lCol, lRow);
  if Result then
    AText := FYearData[lCol, lRow].InfoText;
end;

function TJvYearGrid.SetDateInfo(ADate: TDate; AText: string): Boolean;
var
  lCol, lRow: Integer;
begin
  Result := DateToCell(ADate, lCol, lRow);
  if Result then
    FYearData[lCol, lRow].InfoText := AText;
end;

procedure TJvYearGrid.SetBookMarkColor(const Value: TColor);
begin
  if Value <> FBookMarkColor then
  begin
    FBookMarkColor := Value;
    Invalidate;
  end;
end;

procedure TJvYearGrid.mnuFindClick(Sender: TObject);
var
  S: string;
  lCol, lRow: Integer;
begin
  ClearBookMarks;
  S := InputBox(RsYearGridFind, RsEnterSeachText, '');
  if S = '' then
    Exit;
  S := LowerCase(S);
  for lRow := 0 to 12 do
    for lCol := 0 to 37 do
      if Pos(S, LowerCase(FYearData[lCol, lRow].InfoText)) > 0 then
        FYearData[lCol, lRow].BookMark := True;
  Invalidate;
end;

procedure TJvYearGrid.mnuClearFindClick(Sender: TObject);
begin
  ClearBookMarks;
end;

procedure TJvYearGrid.Find;
begin
  mnuFindClick(nil);
end;

procedure TJvYearGrid.mnuSaveFound(Sender: TObject);
var
  List: TStringList;
  FileName: string;
begin
  List := TStringList.Create;
  MakeHTML(List, HTMLBorder, True);
  FileName := Format(RsFounds, [ChangeFileExt(FYearFile, '.htm')]);
  List.SaveToFile(FileName);
  List.Free;
  Launch(FileName);
end;

procedure TJvYearGrid.SetOrientation(const Value: TJvYearGridOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if FOrientation = yoHorizontal then
    begin
      ColCount := 38;
      RowCount := 13;
    end
    else
    begin
      ColCount := 13;
      RowCount := 38;
    end;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetFirstDayOfWeek(const Value: TJvWeekDay);
begin
  if FFirstDayOfWeek <> Value then
  begin
    FFirstDayOfWeek := Value;
    SetupYearData;
  end;
end;

procedure TJvYearGrid.SetAutoSize(Value: Boolean);
begin
  if Value then
  begin
    if (aoGrid in AutoSizeOptions) then
    begin
      FSavedScrollBars := ScrollBars;
      ScrollBars := ssNone;
    end;
  end
  else
    ScrollBars := FSavedScrollBars;

  FAutoSize := Value;
  AdjustBounds;
end;

function TJvYearGrid.GetDefaultColWidth: Integer;
begin
  Result := inherited DefaultColWidth;
end;
  {
function TJvYearGrid.GetDefaultRowHeight: Integer;
begin
  Result := inherited DefaultRowHeight;
end;
   }
procedure TJvYearGrid.SetDefaultColWidth(const Value: Integer);
var
  SavedFirstColWidth: Integer;
begin
  SavedFirstColWidth := ColWidths[0];
  inherited DefaultColWidth := Value;
  ColWidths[0] := SavedFirstColWidth;
end;

procedure TJvYearGrid.SetDefaultRowHeihgt(const Value: Integer);
var
  SavedFirstRowHeight: Integer;
begin
  SavedFirstRowHeight := RowHeights[0];
  inherited DefaultRowHeight := Value;
  RowHeights[0] := SavedFirstRowHeight;
end;

procedure TJvYearGrid.SetFirstColWidth(const Value: Integer);
begin
  ColWidths[0] := Value;
end;

procedure TJvYearGrid.SetFirstRowHeight(const Value: Integer);
begin
  RowHeights[0] := Value;
end;

procedure TJvYearGrid.SetWeekendColor(const AValue: TColor);
begin
  if FWeekendColor <> AValue then begin
    FWeekendColor := AValue;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetWeekendDays(const Value: TJvWeekDaySet);
begin
  FWeekendDays := Value;
end;

procedure TJvYearGrid.SetAutoSizeOptions(const Value: TJvAutoSizeOptions);
begin
  FAutoSizeOptions := Value;
end;

procedure TJvYearGrid.UpdateAllSizes;
var
  I: Integer;
  CurValue: Integer;
  MaxValue: Integer;

  function GetHighestTextInRow(Row: Integer): Integer;
  var
    I: Integer;
    CurValue: Integer;
  begin
    // find the highest text in the row.
    Result := 0;
    for I := 0 to ColCount-1 do
    begin
      if Orientation = yoHorizontal then
        CurValue := Canvas.TextHeight(FYearData[I,Row].DisplayText)
      else
        CurValue := Canvas.TextHeight(FYearData[Row,I].DisplayText);
      if CurValue > Result then
        Result := CurValue;
    end;
  end;

  function GetWidestTextInColumn(Column: Integer): Integer;
  var
    I: Integer;
    CurValue: Integer;
  begin
    // find the largest text in the column
    Result := 0;
    for I := 0 to RowCount-1 do
    begin
      if Orientation = yoHorizontal then
        CurValue := Canvas.TextWidth(FYearData[Column,I].DisplayText)
      else
        CurValue := Canvas.TextWidth(FYearData[I,Column].DisplayText);
      if CurValue > Result then
        Result := CurValue;
    end;
  end;

begin
  if AutoSize and HandleAllocated then
  begin
    Canvas.Font.Assign(Font);
    Canvas.Font.Style := [fsBold];
    if aoFirstRow in AutoSizeOptions then
      RowHeights[0] := GetHighestTextInRow(0) + CellMargins.Top + CellMargins.Bottom;

    if aoFirstColumn in AutoSizeOptions then
      ColWidths[0] := GetWidestTextInColumn(0) + CellMargins.Left + CellMargins.Right;

    if aoRows in AutoSizeOptions then
    begin
      // find the highest text in each row and only use the
      // highest value among those found
      MaxValue := 0;
      for I := 1 to RowCount-1 do
      begin
        CurValue := GetHighestTextInRow(I);
        if CurValue > MaxValue then
          MaxValue := CurValue;
      end;

      for I := 1 to RowCount-1 do
        RowHeights[I] := MaxValue + CellMargins.Top + CellMargins.Bottom;
    end;

    if aoColumns in AutoSizeOptions then
    begin
      // find the widest text in each column and only use
      // the highest value among those found
      MaxValue := 0;
      for I := 1 to ColCount-1 do
      begin
        CurValue := GetWidestTextInColumn(I);
        if CurValue > MaxValue then
          MaxValue := CurValue;
      end;
      for I := 1 to ColCount-1 do
        ColWidths[I] := MaxValue + CellMargins.Left + CellMargins.Right;
    end;
  end;
end;

procedure TJvYearGrid.SetCellMargins(const Value: TJvRect);
begin
  FCellMargins.Assign(Value);
  AdjustBounds;
end;

procedure TJvYearGrid.AdjustBounds;
var
  NewWidth, NewHeight: Integer;
  tmp: Integer;
begin
  if not (csLoading in ComponentState) and FAutoSize then
  begin
    UpdateAllSizes;
    if aoGrid in AutoSizeOptions then
    begin
      Scrollbars := ssNone;
      ColRowToOffset(true, false, ColCount-1, tmp, NewWidth);
      ColRowToOffset(false, false, RowCount-1, tmp, NewHeight);
      SetBounds(Left, Top, NewWidth, NewHeight);
    end;
  end;
end;

procedure TJvYearGrid.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TJvYearGrid.SetParent( AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Parent <> nil then
    AdjustBounds;
end;

procedure TJvYearGrid.CellMarginsChange(Sender: TObject);
begin
  AdjustBounds;
  Invalidate;
end;

procedure TJvYearGrid.SetDayFormat(const AValue: TJvDayFormat);
begin
  if FDayFormat <> AValue then
  begin
    FDayFormat := AValue;
    SetupYearData;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetDayNamesAlignment(const Value: TAlignment);
begin
  if FDayNamesAlignment <> Value then
  begin
    FDayNamesAlignment := Value;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetDaysAlignment(const Value: TAlignment);
begin
  if FDaysAlignment <> Value then
  begin
    FDaysAlignment := Value;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetMonthFormat(const AValue: TJvMonthFormat);
begin
  if FMonthFormat <> AValue then
  begin
    FMonthFormat := AValue;
    SetupYearData;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetMonthNamesAlignment(const Value: TAlignment);
begin
  if FMonthNamesAlignment <> Value then
  begin
    FMonthNamesAlignment := Value;
    Invalidate;
  end;
end;

procedure TJvYearGrid.SetYearAlignment(const Value: TAlignment);
begin
  if FYearAlignment <> Value then
  begin
    FYearAlignment := Value;
    Invalidate;
  end;
end;

function TJvYearGrid.GetFirstColWidth: Integer;
begin
  Result := ColWidths[0];
end;

function TJvYearGrid.GetFirstRowHeight: Integer;
begin
  Result := RowHeights[0];
end;

function TJvYearGrid.GetFlat: Boolean;
begin
  Result := inherited Flat;
end;

function TJvYearGrid.IsHtmlFontNameStored: Boolean;
begin
  Result := not SameText(FHtmlFontName, 'default');
end;

procedure TJvYearGrid.SetFlat(AValue: Boolean);
begin
  inherited Flat := AValue;
  AdjustBounds;
end;

procedure TJvYearGrid.SetReadOnly(const Value: Boolean);
begin
  if Value <> FReadOnly then
  begin
    FReadOnly := Value;
    SetupGridPop(self);
  end;
end;

function TJvYearGrid.IsCurrentYear: Boolean;
begin
  Result := Year = FCurrentYear;
end;

procedure TJvYearGrid.ReadGridYear(Reader: TReader);
begin
  Year := Reader.ReadInteger;
end;

procedure TJvYearGrid.WriteGridYear(Writer: TWriter);
begin
  // Do nothing, we only provide read support for legacy reasons
end;

procedure TJvYearGrid.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('GridYear', @ReadGridYear, @WriteGridYear, False);
end;

procedure TJvYearGrid.ColRowToDayMonthIndex(ACol, ARow: Integer;
  out DayIndex, MonthIndex: Integer);
begin
  if Orientation = yoHorizontal then
  begin
    DayIndex := ACol;
    MonthIndex := ARow;
  end
  else
  begin
    DayIndex := ARow;
    MonthIndex := ACol;
  end;
end;

procedure TJvYearGrid.DayMonthIndexToColRow(DayIndex, MonthIndex: Integer;
  out ACol, ARow: Integer);
begin
  if Orientation = yoHorizontal then
  begin
    ACol := DayIndex;
    ARow := MonthIndex;
  end
  else
  begin
    ARow := DayIndex;
    ACol := MonthIndex;
  end;
end;

procedure TJvYearGrid.ColRowToDayMonth(ACol, ARow: Integer; var ADay,
  AMonth: Integer);
var
  DayIndex, MonthIndex: Integer;
begin
  ColRowToDayMonthIndex(ACol, ARow, DayIndex, MonthIndex);
  AMonth := MonthIndex;
  ADay := FYearData[MonthIndex, DayIndex].DayInMonth;
end;

procedure TJvYearGrid.DayMonthToColRow(ADay, AMonth: Integer; var ACol,
  ARow: Integer);
begin
  DayMonthIndexToColRow(ADay, AMonth, ACol, ARow);
end;

procedure TJvYearGrid.DoPrepareCanvas(ACol, ARow:Integer; AState: TGridDrawState);
var
  DayIndex, MonthIndex: Integer;
  S: String;
begin
  ColRowToDayMonthIndex(ACol, ARow, DayIndex, MonthIndex);
  S := FYearData[DayIndex, MonthIndex].DisplayText;

  with Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Color := clBlack;
    if (ACol = 0) and (ARow = 0) then
      Font.Style := Font.Style + [fsBold]
    else
      Font.Style := Font.Style - [fsBold];

    if (DayIndex = 0) or (MonthIndex = 0) then
      Brush.Color := BorderColor;

    if (DayIndex > 0) and (MonthIndex > 0) then
    begin
      if IsCurrentYear and (MonthIndex = FCurrentMonth) and (S = IntToStr(FCurrentDay)) then
      begin
        Font.Color := TodayFontColor;
        Brush.Color := TodayBrushColor;
        Font.Style := Font.Style + [fsBold];
      end
      else
      if FYearData[DayIndex, MonthIndex].Custom then
        Brush.Color := FYearData[DayIndex, MonthIndex].CustomColor
      else
        Brush.Color := FYearData[DayIndex, MonthIndex].DefaultColor;
    end;
    if FYearData[DayIndex, MonthIndex].BookMark then
      Brush.Color := BookMarkColor;
  end;
end;

procedure TJvYearGrid.DrawColumnText(ACol,ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin
  DrawTextInCell(ACol, ARow, ARect, AState);
end;

procedure TJvYearGrid.DrawTextInCell(ACol,ARow: Integer;
  ARect: TRect; AState: TGridDrawState);
var
  DayIndex, MonthIndex: Integer;
  S: String;
  SExt: TSize;
  textLeft: Integer;
  ts: TTextStyle;

  function GetTextLeft(Alignment: TAlignment; AWidth: Integer): Integer;
  begin
    case Alignment of
      taRightJustify:
        Result := ARect.Right - AWidth - CellMargins.Right;
      taCenter:
        Result := (ARect.Left + ARect.Right - AWidth) div 2;
    else
      Result := ARect.Left + CellMargins.Left;
    end;
  end;

begin
  ColRowToDayMonthIndex(ACol, ARow, DayIndex, MonthIndex);
  S := FYearData[DayIndex, MonthIndex].DisplayText;
  textLeft := ARect.Left;

  with Canvas do
  begin
    SExt := TextExtent(S);

    if (DayIndex = 0) then
      textLeft := GetTextLeft(MonthNamesAlignment, SExt.CX);

    if (MonthIndex = 0) then
    begin
      if DayIndex = 0 then
        textLeft := GetTextLeft(YearAlignment, SExt.CX)
      else
        textLeft := GetTextLeft(DayNamesAlignment, SExt.CX);
    end;

    if (DayIndex > 0) and (MonthIndex > 0) then
      textLeft := GetTextLeft(DaysAlignment, SExt.CX);

    ts := TextStyle;
    ts.Layout := tlCenter;
    TextRect(ARect, textLeft, (ARect.Top + ARect.Bottom - SExt.CY) div 2, S, ts);
  end;
end;

procedure TJvYearGrid.DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
  const AXProportion, AYProportion: Double);
begin
  inherited;
  if AMode in [lapAutoAdjustWithoutHorizontalScrolling, lapAutoAdjustForDPI] then
  begin
    FCellMargins.Left := round(FCellMargins.Left * AXProportion);
    FCellMargins.Right := round(FCellMargins.Right * AXProportion);
    FCellMargins.Top := round(FCellMargins.Top * AYProportion);
    FCellMargins.Bottom := round(FCellMargins.Bottom * AYProportion);
  end;
end;

end.
