{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvProfilerForm.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Certified Software Corp. [certsoft att quest-net dott com]
Portions created by Peter Thörnqvist are Copyright (C) 1996 Certified Software Corp.
All Rights Reserved.

Contributor(s): Peter Thörnqvist [peter3 at sourceforge dot net]

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
 Use QueryPerformanceCounter / Frequency instead of GetTickCount (the high resolution timer)
-----------------------------------------------------------------------------}
// $Id$

unit JvProfilerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, Dialogs, ComCtrls, StdCtrls, Controls, ExtCtrls, Forms;

const
  MaxProfEntries = 1024; { maximum number of "blocks" to profile }
  MaxStackSize = 1024;   { maximum nesting of blocks at any one time }

var
  OddClick: Boolean = True;

type
  TJvProfileInfo = array [0..MaxProfEntries - 1] of record
    InOutTime: Longint;
    TimeSpent: Longint;
    Calls: Longint;
    StringID: string;
  end;

  TProcStack = array [1..MaxStackSize] of record
    CallerID: Integer;
    EntryTime: Longint;
  end;

  TProfReport = class(TForm)
    Panel1: TPanel;
    SaveBtn: TButton;
    lvReport: TListView;
    OKBtn: TButton;
    TrimBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure lvReportColumnClick(Sender: TObject; Column: TListColumn);
    procedure SaveBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TrimBtnClick(Sender: TObject);
  public
    StartTime: Integer;
    EndTime: Integer;
    LastProc: Integer;
    ProfileInfo: TJvProfileInfo;
  end;

  TJvProfiler = class(TComponent)
  private
    FProfileInfo: TJvProfileInfo;
    FNames: TStringList;
    FStack: TProcStack;
    FStartTime: Longint;
    FEndTime: Longint;
    FLastProc: Integer;
    FStackSize: Integer;
    FEnabled: Boolean;
    FStarted: Boolean;
    FSorted: Boolean;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    function GetNames: TStrings;
    procedure SetNames(Value: TStrings);
    procedure SetEnabled(Value: Boolean);
    procedure SetSorted(Value: Boolean);
  protected
    procedure DoStart; virtual;
    procedure DoStop; virtual;
    procedure Initialize; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure EnterID(ID: Integer);
    procedure EnterName(const AName: string);
    procedure ExitName(const AName: string);
    procedure ExitID(ID: Integer);
    procedure Stop;
    procedure ShowReport;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Names: TStrings read GetNames write SetNames;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
  end;


implementation

uses
  LCLVersion,
  {$IFDEF UNIX}  // RPH 16Apr2020 - Fix for Darwin
    baseunix, unix,
   {$IFDEF LINUX}
    linux, users,
   {$ENDIF}
 {$ELSE}
  Windows,
 {$ENDIF}
  SysUtils, LazUTF8,
  JvConsts, JvTypes, JvResources;

{$R *.lfm}

const
  EmptyLine = '0.00';
  DefHeader2 =
    'Profiler 32 - (C) 1996 Certified Software Corp, portions Copyright (C) 1997 by Peter Thörnqvist; all rights reserved.';

{
type
  PProfType = ^TProfType;
  TProfType = record
    InOutTime: Integer;
    TimeSpent: Integer;
    Calls: Integer;
    StringID: string;
  end;

  PStackType = ^TStackType;
  TStackType = record
    CallerID: Integer;
    EntryTime: Integer;
  end;
}

function GetUserName: String;
// http://forum.lazarus.freepascal.org/index.php/topic,23171.msg138057.html#msg138057
{$IFDEF WINDOWS}
const
  MaxLen = 256;
var
  Len: DWORD;
  WS: WideString = '';
  Res: windows.BOOL;
{$ENDIF}
begin
  Result := '';
 {$IFDEF UNIX}
  {$IF (DEFINED(LINUX)) OR (DEFINED(FREEBSD))}
  Result := SysToUtf8(users.GetUserName(fpgetuid));   //GetUsername in unit Users, fpgetuid in unit BaseUnix
  {$ELSE Linux/BSD}
  Result := GetEnvironmentVariableUtf8('USER');
  {$ENDIF UNIX}
 {$ELSE}
 {$IFDEF WINDOWS}
  Len := MaxLen;
  {$IFnDEF WINCE}
  if Win32MajorVersion <= 4 then begin
    SetLength(Result,MaxLen);
    Res := Windows.GetUserName(@Result[1], Len);
    //writeln('GetUserNameA = ',Res);
    if Res then begin
      SetLength(Result,Len-1);
      Result := WinCPToUtf8(Result);
    end else
      SetLength(Result,0);
  end
  else
  {$ENDIF NOT WINCE}
  begin
    SetLength(WS, MaxLen-1);
    Res := Windows.GetUserNameW(@WS[1], Len);
    //writeln('GetUserNameW = ',Res);
    if Res then begin
      SetLength(WS, Len - 1);
      Result := Utf16ToUtf8(WS);
    end else
      SetLength(Result,0);
  end;
  {$ENDIF WINDOWS}
  {$ENDIF UNIX}
end;

function GetComputerName : string;
{$IFDEF WINDOWS}
var
  len : cardinal;
begin
  Result := '';
  len := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(result, len);
  if Windows.GetComputerName(PChar(result), len) then begin
    SetLength(Result, len);
    Result := WinCPToUTF8(Result);
  end
  else
    RaiseLastWin32Error;
end;
{$ELSE}
begin
  Result := GetHostName;
end;
{$ENDIF}


//=== { TJvProfiler } ========================================================

constructor TJvProfiler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNames := TStringList.Create;
end;

destructor TJvProfiler.Destroy;
begin
  Stop;
  FNames.Free;
  inherited Destroy;
end;

procedure TJvProfiler.Initialize;
var
  I: Integer;
begin
  FEnabled := False;
  FStarted := False;
  FStartTime := 0;
  FEndTime := 0;
  FStackSize := 0;
  FLastProc := -1;
  { build ID list }
  for I := 0 to FNames.Count - 1 do
  begin
    if Length(Trim(FNames[I])) < 1 then
      Continue;                         { skip empty ID's }
    if FLastProc > MaxProfEntries then
      raise EJVCLException.CreateResFmt(@RsEMaxNumberOfIDsExceededd, [MaxProfEntries - 1]);
    Inc(FLastProc);
    with FProfileInfo[FLastProc] do
    begin
      TimeSpent := 0;
      Calls := 0;
      StringID := FNames[I];
    end;
  end;
end;

procedure TJvProfiler.EnterID(ID: Integer);
var
  Snap: Integer;
begin
  if FEnabled then
  begin
    Snap := GetTickCount64;
    if FStackSize > MaxStackSize then
      raise EJVCLException.CreateResFmt(@RsEMaxStackSizeExceededd, [MaxStackSize]);
    Inc(FStackSize);

    with FStack[FStackSize] do
    begin
      EntryTime := Snap;
      CallerID := ID
    end;

    with FProfileInfo[ID] do
    begin
      Inc(Calls);
      InOutTime := Snap;
    end;
  end;
end;

procedure TJvProfiler.EnterName(const AName: string);
begin
  EnterID(FNames.IndexOf(AName));
end;

procedure TJvProfiler.ExitName(const AName: string);
begin
  ExitID(FNames.IndexOf(AName));
end;

procedure TJvProfiler.ExitID(ID: Integer);
var
  Snap, Elapsed: Integer;
begin
  if Enabled then
  begin
    Snap := GetTickCount64;
    with FProfileInfo[ID] do
    begin
      Elapsed := Snap - InOutTime;
      TimeSpent := TimeSpent + Elapsed;
    end;
    if FStackSize > 0 then
      Dec(FStackSize);
    if FStackSize > 0 then
      with FProfileInfo[FStack[FStackSize].CallerID] do
        TimeSpent := TimeSpent - Elapsed;
  end;
end;

procedure TJvProfiler.DoStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TJvProfiler.DoStop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

procedure TJvProfiler.Start;
begin
  if FEnabled and not FStarted then
  begin
    //    Initialize;
    DoStart;
    FStartTime := GetTickCount64;
    FStarted := True;
  end;
end;

procedure TJvProfiler.Stop;
begin
  if FEnabled and FStarted then
  begin
    FEndTime := GetTickCount64;
    DoStop;
    FStarted := False;
  end;
end;

function TJvProfiler.GetNames: TStrings;
begin
  Result := FNames;
end;

procedure TJvProfiler.SetNames(Value: TStrings);
begin
  FNames.Assign(Value);
  Initialize;
end;

procedure TJvProfiler.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
    FEnabled := Value;
end;

procedure TJvProfiler.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    FNames.Sorted := FSorted;
    Initialize;
  end;
end;

procedure TJvProfiler.ShowReport;
begin
  if FEnabled then
  begin
    if FStarted then
      Stop;
    with TProfReport.Create(nil) do
    begin
      EndTime := FEndTime;
      StartTime := FStartTime;
      LastProc := FLastProc;
      ProfileInfo := FProfileInfo;
      ShowModal;
      Free;
    end;
  end;
end;

//=== { TProfReport } ========================================================

procedure TProfReport.FormShow(Sender: TObject);
const
  NumberFormat = '%4.2f';
var
  ThisProc: Integer;
  TotalSum: Integer;
  LItem: TListItem;
begin
  OddClick := True;
  TotalSum := (EndTime - StartTime);
  if TotalSum = 0 then
    Exit;
  lvReport.Items.BeginUpdate;
  lvReport.Items.Clear;
  for ThisProc := 0 to LastProc do
    with ProfileInfo[ThisProc] do
    begin
      LItem := lvReport.Items.Add;
      LItem.Caption := StringID;        { function ID }
      if Calls <> 0 then
      begin
        LItem.SubItems.Add(Format(NumberFormat, [TimeSpent * 1.0]));  { Total time spent here }
        LItem.SubItems.Add(IntToStr(Calls)); { Total number of calls }
        LItem.SubItems.Add(Format(NumberFormat, [TimeSpent / Calls]));  { average time }
        LItem.SubItems.Add(Format(NumberFormat, [TimeSpent / TotalSum * 100.0]));  { percentage }
      end
      else
      begin
        LItem.SubItems.Add(EmptyLine);
        LItem.SubItems.Add('0');
        LItem.SubItems.Add(EmptyLine);
        LItem.SubItems.Add(EmptyLine);
      end;
    end;
  Caption := Format(RsTotalElapsedTimedms, [RsDefCaption, TotalSum]);
  lvReport.Items.EndUpdate;
end;

function IsFloat(S: string): Boolean;
var
  x: Double;
begin
  Result := TryStrToFloat(S, x);
end;

function DefSort(lParam1, lParam2: TListItem; lParamSort: Integer): Integer; stdcall;
var
  l1, l2: Extended;
begin
  if lParamSort = 0 then
    Result := AnsiCompareText(lParam1.Caption, lParam2.Caption)
  else
  begin
    if not IsFloat(lParam1.SubItems[lParamSort - 1]) then
      l1 := -1.0
    else
      l1 := StrToFloat(lParam1.SubItems[lParamSort - 1]);
    if not IsFloat(lParam2.SubItems[lParamSort - 1]) then
      l2 := -1.0
    else
      l2 := StrToFloat(lParam2.SubItems[lParamSort - 1]);
    Result := Round((l1 * 1000) - (l2 * 1000));
  end;
  if OddClick then
    Result := -Result;
end;

procedure TProfReport.lvReportColumnClick(Sender: TObject; Column: TListColumn);
begin
  {$IF LCL_FullVersion >= 2000000}
  //  lvReport.Items.BeginUpdate;
  lvReport.CustomSort(TLVCompare(@DefSort), Column.Index);
  OddClick := not OddClick;
  //  lvReport.Items.EndUpdate;
  {$IFEND}
end;

procedure TProfReport.SaveBtnClick(Sender: TObject);
var
  OutList: TStringList;
  S: string;
  I, J: Integer;
begin
  with TSaveDialog.Create(nil) do
  begin
    Filter := RsTextFormatsasctxtinfdocAllFiles;
    if Execute then
    begin
      OutList := TStringList.Create;
      OutList.Add(Format(RsDefHeader, [DateToStr(Now), GetUserName,
        GetComputerName]));
      OutList.Add(DefHeader2);
      S := '';
      for I := 0 to lvReport.Columns.Count - 1 do
        S := S + lvReport.Columns[I].Caption + Tab;
      OutList.Add(S);
      S := '';
      with lvReport do
        for I := 0 to Items.Count - 1 do
        begin
          with Items[I] do
          begin
            S := S + Caption + Tab;
            for J := 0 to SubItems.Count - 1 do
              S := S + SubItems[J] + Tab;
            OutList.Add(S);
          end;
          S := '';
        end;
      OutList.SaveToFile(Filename);
      OutList.Free;
    end;
    Free;
  end;
end;

procedure TProfReport.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TProfReport.TrimBtnClick(Sender: TObject);
var
  I: Integer;
begin
  lvReport.Items.BeginUpdate;
  for I := lvReport.Items.Count - 1 downto 0 do
    { no calls = not used }
    if lvReport.Items[I].SubItems[1] = '0' then
      lvReport.Items.Delete(I);
  lvReport.Items.EndUpdate;
end;

end.
