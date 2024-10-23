{******************************************************************

                       JEDI-VCL Demo

 Copyright (C) 2002 Project JEDI

 Original author:

 Contributor(s):

 You may retrieve the latest version of this file at the JEDI-JVCL
 home page, located at http://jvcl.delphi-jedi.org

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may
 not use this file except in compliance with the License. You may
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit tfMain;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  db, sqldb, sqlite3conn,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, DateTimePicker, PrintersDlgs,
  JvTFManager, JvTFDays, JvTFGlance, JvTFGlanceTextViewer, JvTFMonths,
  JvTFWeeks, JvTFAlarm;

type

  { TMainForm }

  TMainForm = class(TForm)
    JvTFAlarm1: TJvTFAlarm;
    NewSchedButton: TBitBtn;
    TodayButton: TSpeedButton;
    WeeksCombo: TComboBox;
    StrokeImages: TImageList;
    JvTFDaysPrinter1: TJvTFDaysPrinter;
    IconsProvidedLabel: TLabel;
    IconsLink: TLabel;
    Panel2: TPanel;
    SettingsButton: TBitBtn;
    PrintDialog: TPrintDialog;
    utfScheduleManager1: TJvTFScheduleManager;
    ColoredImages: TImageList;
    NeedApptsQuery: TSQLQuery;
    ApptSchedulesQuery: TSQLQuery;
    GetApptQuery: TSQLQuery;
    DeleteApptLinkQuery: TSQLQuery;
    DeleteApptQuery: TSQLQuery;
    SchedulesQuery: TSQLQuery;
    PageControl1: TPageControl;
    pgDays: TTabSheet;
    pgWeeks: TTabSheet;
    pgMonths: TTabSheet;
    JvTFDays1: TJvTFDays;
    JvTFWeeks1: TJvTFWeeks;
    JvTFMonths1: TJvTFMonths;
    GlanceTextViewer1: TJvTFGlanceTextViewer;
    GlanceTextViewer2: TJvTFGlanceTextViewer;
    Panel1: TPanel;
    ResourceCombo: TComboBox;
    PrevDateButton: TBitBtn;
    NextDateButton: TBitBtn;
    NewApptButton: TBitBtn;
    EditApptButton: TBitBtn;
    DeleteApptButton: TBitBtn;
    ViewSchedsButton: TBitBtn;
    HideSchedButton: TBitBtn;
    ShareButton: TBitBtn;
    TimeIncCombo: TComboBox;
    GotoDatePicker: TDateTimePicker;
    ModeCombo: TComboBox;
    DaysCombo: TComboBox;
    PrintButton: TBitBtn;
    dbUTF: TSQLite3Connection;
    SQLTransaction: TSQLTransaction;

    procedure IconsLinkClick(Sender: TObject);
    procedure IconsLinkMouseEnter(Sender: TObject);
    procedure IconsLinkMouseLeave(Sender: TObject);
    procedure JvTFAlarm1Alarm(Sender: TObject; AAppt: TJvTFAppt;
      var SnoozeMins: Integer; var Dismiss: Boolean);

    procedure ModeComboChange(Sender: TObject);
    procedure NewSchedButtonClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure TodayButtonClick(Sender: TObject);
    procedure ViewSchedsButtonClick(Sender: TObject);
    procedure HideSchedButtonClick(Sender: TObject);
    procedure ResourceComboChange(Sender: TObject);
    procedure DaysComboChange(Sender: TObject);
    procedure ShareButtonClick(Sender: TObject);
    procedure PrevDateButtonClick(Sender: TObject);
    procedure NextDateButtonClick(Sender: TObject);
    procedure GotoDatePickerChange(Sender: TObject);
    procedure GotoDatePickerUserInput(Sender: TObject;
      const UserString: String; var DateAndTime: TDateTime;
      var AllowChange: Boolean);
    procedure TimeIncComboChange(Sender: TObject);
    procedure NewApptButtonClick(Sender: TObject);
    procedure EditApptButtonClick(Sender: TObject);
    procedure DeleteApptButtonClick(Sender: TObject);

    procedure JvTFDays1DateChanging(Sender: TObject; var NewDate: TDate);
    procedure JvTFDays1DateChanged(Sender: TObject);
    procedure JvTFDays1GranularityChanged(Sender: TObject);
    procedure JvTFDays1DblClick(Sender: TObject);

    procedure JvTFDaysPrinter1ApptProgress(Sender: TObject; Current,
      Total: Integer);
    procedure JvTFDaysPrinter1AssembleProgress(Sender: TObject; Current,
      Total: Integer);
    procedure JvTFDaysPrinter1PrintProgress(Sender: TObject; Current,
      Total: Integer);

    procedure utfScheduleManager1LoadBatch(Sender: TObject; BatchName: String;
      BatchStartDate, BatchEndDate: TDate);
    procedure utfScheduleManager1DeleteAppt(Sender: TObject; Appt: TJvTFAppt);
    procedure utfScheduleManager1PostAppt(Sender: TObject; Appt: TJvTFAppt);
    procedure utfScheduleManager1RefreshAppt(Sender: TObject; Appt: TJvTFAppt);

    procedure CreateDatabase(const AFileName: String);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure PrintButtonClick(Sender: TObject);
    procedure WeeksComboChange(Sender: TObject);

  private
    FNewDatabase: Boolean;

    { Private declarations }
    procedure ApplySettings;
    procedure ReadIni;
    procedure WriteIni;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  IniFiles,
  tfVisibleResources, tfShare, tfApptEdit, tfPrintProgress, tfSettings, tfAlarm;

{$R *.lfm}

procedure TMainForm.ApplySettings;
var
  images: Array[0..1] of TImageList;
begin
  with GlobalSettings do begin
    JvTFDays1.FancyRowHdrAttr.Hr2400 := Hr2400;
    JvTFDays1.SelFancyRowHdrAttr.Hr2400 := Hr2400;
    JvTFDaysPrinter1.FancyRowHdrAttr.Hr2400 := Hr2400;

    JvTFWeeks1.StartOfWeek := FirstDayOfWeek;
    JvTFMonths1.StartOfWeek := FirstDayOfWeek;

    JvTFDays1.PrimeTime.StartTime := PrimeTimeStart;
    JvTFDays1.PrimeTime.EndTime := PrimeTimeEnd;
    JvTFDays1.PrimeTime.Color := PrimeTimeColor;

    images[0] := ColoredImages;
    images[1] := StrokeImages;
    PrevDateButton.Images := images[IconSet];
    NextDateButton.Images := images[IconSet];
    TodayButton.Images := images[IconSet];
    NewApptButton.Images := images[IconSet];
    EditApptButton.Images := images[IconSet];
    DeleteApptButton.Images := images[IconSet];
    PrintButton.Images := images[IconSet];
    SettingsButton.Images := images[IconSet];
    ViewSchedsButton.Images := images[IconSet];
    HideSchedButton.Images := images[IconSet];
    ShareButton.Images := images[IconSet];
    NewSchedButton.Images := images[IconSet];
    utfScheduleManager1.StateImages := images[IconSet];

    if StartToday then
      GotoDatePicker.Date := Date()
    else
      GotoDatePicker.Date := StartDate;
    GotoDatePickerChange(nil);
  end;
end;

procedure TMainForm.utfScheduleManager1PostAppt(Sender: TObject;
  Appt: TJvTFAppt);
var
  I : Integer;
begin
  With GetApptQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      Open;

      If RecordCount > 0 Then // SQL RecordCount not reliable except on local tables
        Edit
      Else
        Begin
          Insert;
          FieldByName('ApptID').AsString := Appt.ID;
        End;

      FieldByName('StartDate').AsDateTime := Appt.StartDate;
      FieldByName('StartTime').AsDateTime := Appt.StartTime;
      FieldByName('EndDate').AsDateTime := Appt.EndDate;
      FieldByName('EndTime').AsDateTime := Appt.EndTime;
      FieldByName('Description').AsString := Appt.Description;
      FieldByName('AlarmEnabled').AsBoolean := Appt.AlarmEnabled;
      FieldByName('AlarmAdvance').AsInteger := Appt.AlarmAdvance;
      Post;
      Close;
    End;

  // Now update the Appt --> Schedule relationship
  // First delete all entries in the Link table
  With DeleteApptLinkQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      ExecSQL;
    End;

  // Now "refresh" the link table by adding a record for each of the names
  // in Appt.Schedules.  We will use the ApptSchedulesQuery to update the table.
  With ApptSchedulesQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      Open;
      For I := 0 to Appt.ScheduleCount - 1 do
        Begin
          Insert;
          FieldByName('ApptID').AsString := Appt.ID;
          FieldByName('SchedName').AsString := Appt.Schedules[I];
          Post;
        End;
      Close;
    End;
end;

procedure TMainForm.utfScheduleManager1DeleteAppt(Sender: TObject;
  Appt: TJvTFAppt);
begin
  // First delete the appointment from the appointment table
  With DeleteApptQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      ExecSQL;
    End;

  // Next, delete the related records from the link table
  With DeleteApptLinkQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      ExecSQL;
    End;
end;

procedure TMainForm.utfScheduleManager1RefreshAppt(Sender: TObject;
  Appt: TJvTFAppt);
begin
  With GetApptQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      Open;
      If RecordCount = 1 Then
        Begin
          Appt.SetStartEnd(FieldByName('StartDate').AsDateTime,
                           FieldByName('StartTime').AsDateTime,
                           FieldByName('EndDate').AsDateTime,
                           FieldByName('EndTime').AsDateTime);
          Appt.Description := FieldByName('Description').AsString;
          Appt.AlarmEnabled := FieldByName('AlarmEnabled').AsBoolean;
          Appt.AlarmAdvance := FieldByName('AlarmAdvance').AsInteger;
        End;
      Close;
    End;

  // Now update the Appt --> Schedule(s) relationship
  Appt.ClearSchedules;
  With ApptSchedulesQuery do
    Begin
      ParamByName('ApptID').AsString := Appt.ID;
      Open;
      First;
      While not EOF do
        Begin
          Appt.AddSchedule(FieldByName('SchedName').AsString);
          Next;
        End;
      Close; // ApptSchedulesQuery
    End;
end;

procedure TMainForm.ModeComboChange(Sender: TObject);
begin
  ResourceCombo.Visible := ModeCombo.ItemIndex = 0;
  DaysCombo.Visible := (ModeCombo.ItemIndex = 0) and (PageControl1.ActivePage = pgDays);
  WeeksCombo.Visible := (ModeCombo.ItemIndex = 0) and (PageControl1.ActivePage = pgWeeks);

  NewSchedButton.Visible := ModeCombo.ItemIndex = 1;
  ViewSchedsButton.Visible := ModeCombo.ItemIndex = 1;
  HideSchedButton.Visible := ModeCombo.ItemIndex = 1;
  ShareButton.Visible := ModeCombo.ItemIndex = 1;

  If ModeCombo.ItemIndex = 0 Then
    // Single mode
    Begin
      // synchronize the date
      JvTFDays1.Template.LinearStartDate := GotoDatePicker.Date;
      // "activate" the Linear template
      JvTFDays1.Template.ActiveTemplate := agtLinear;
      // set the column grouping
      JvTFDays1.Grouping := grResource;
    End
  Else
    // Group mode
    Begin
      // synchronize the date
      JvTFDays1.Template.CompDate := GotoDatePicker.Date;
      // "activate" the Comparative template
      JvTFDays1.Template.ActiveTemplate := agtComparative;
      // set the column grouping
      JvTFDays1.Grouping := grDate;
    End;
end;

procedure TMainForm.ViewSchedsButtonClick(Sender: TObject);
begin
  VisibleResources.ShowModal;
end;

procedure TMainForm.WeeksComboChange(Sender: TObject);
begin
  JvTFWeeks1.WeekCount := WeeksCombo.ItemIndex + 1;
end;

procedure TMainForm.HideSchedButtonClick(Sender: TObject);
var
  I,
  NameIndex : Integer;
  NameList : TStringList;
begin
  NameList := TStringList.Create;

  Try
    With JvTFDays1 do
      Begin
        If ValidSelection Then
          Begin
            For I := SelStart.X to SelEnd.X do
              NameList.Add(Cols[I].SchedName);

            For I := 0 to NameList.Count - 1 do
              Begin
                NameIndex := Template.CompNames.IndexOf(NameList[I]);
                If NameIndex > -1 Then
                  Template.CompNames.Delete(NameIndex);
              End;
          End
        Else
          MessageDlg('Please select a schedule to hide.', mtInformation, [mbOK], 0);
      End;
  Finally
    NameList.Free;
  End;
end;

procedure TMainForm.ResourceComboChange(Sender: TObject);
begin
  JvTFDays1.Template.LinearName := ResourceCombo.Text;
  JvTFWeeks1.SchedNames.Clear;
  JvTFWeeks1.SchedNames.Add(ResourceCombo.Text);
  JvTFWeeks1.Refresh;
  JvTFMonths1.SchedNames.Clear;
  JvTFMonths1.SchedNames.Add(ResourceCombo.Text);
  JvTFMonths1.Refresh;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  if SettingsForm.ShowModal = mrOK then
    ApplySettings;
end;

procedure TMainForm.DaysComboChange(Sender: TObject);
var
  s: String;
begin
  Case DaysCombo.ItemIndex of
    0 : JvTFDays1.Template.LinearDayCount := 1;
    1 : JvTFDays1.Template.LinearDayCount := 2;
    2 : JvTFDays1.Template.LinearDayCount := 3;
    3 : JvTFDays1.Template.LinearDayCount := 5;
    4 : JvTFDays1.Template.LinearDayCount := 7;
    5 : JvTFDays1.Template.LinearDayCount := 14;
    6 : JvTFDays1.Template.LinearDayCount := 31;
  End;
  if JvTFDays1.Template.LinearDayCount <= 2 then
    JvTFDays1.DateFormat := DefaultFormatSettings.LongDateFormat
  else
  if JvTFDays1.Template.LinearDayCount <= 5 then
    JvTFDays1.DateFormat := DefaultFormatSettings.ShortDateFormat
  else begin
    s := StringReplace(DefaultFormatSettings.ShortDateFormat, 'yyyy', 'yy', [rfIgnoreCase]);
    JvTFDays1.DateFormat := s;
  end;
end;

procedure TMainForm.ShareButtonClick(Sender: TObject);
begin
  If JvTFDays1.SelAppt <> nil Then
    Share.ShowModal
  Else
    MessageDlg('Please select an appointment.', mtInformation, [mbOK], 0);
end;

procedure TMainForm.PrevDateButtonClick(Sender: TObject);
begin
  JvTFDays1.PrevDate;
  JvTFMonths1.DisplayDate := JvTFDays1.CurrentDate;
  JvTFWeeks1.DisplayDate := JvTFDays1.CurrentDate;
end;

procedure TMainForm.NextDateButtonClick(Sender: TObject);
begin
  JvTFDays1.NextDate;
  JvTFMonths1.DisplayDate := JvTFDays1.CurrentDate;
  JvTFWeeks1.DisplayDate := JvTFDays1.CurrentDate;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
  WeeksCombo.BoundsRect := DaysCombo.BoundsRect;
  WeeksCombo.Visible := PageControl1.ActivePage = pgWeeks;
  DaysCombo.Visible := PageControl1.ActivePage = pgDays;
end;

procedure TMainForm.GotoDatePickerChange(Sender: TObject);
begin
  // GotoDatePicker.OnCloseUp should also point to this handler
  JvTFDays1.GotoDate(GotoDatePicker.Date);
  JvTFWeeks1.DisplayDate := GotoDatePicker.Date;
  JvTFMonths1.DisplayDate := GotoDatePicker.Date;
end;

procedure TMainForm.GotoDatePickerUserInput(Sender: TObject;
  const UserString: String; var DateAndTime: TDateTime;
  var AllowChange: Boolean);
begin
  AllowChange := True;
  GotoDatePicker.OnChange(nil);
end;

procedure TMainForm.TimeIncComboChange(Sender: TObject);
begin
  Case TimeIncCombo.ItemIndex of
     0 : JvTFDays1.Granularity := 60;
     1 : JvTFDays1.Granularity := 30;
     2 : JvTFDays1.Granularity := 20;
     3 : JvTFDays1.Granularity := 15;
     4 : JvTFDays1.Granularity := 12;
     5 : JvTFDays1.Granularity := 10;
     6 : JvTFDays1.Granularity := 6;
     7 : JvTFDays1.Granularity := 5;
     8 : JvTFDays1.Granularity := 4;
     9 : JvTFDays1.Granularity := 3;
    10 : JvTFDays1.Granularity := 2;
    11 : JvTFDays1.Granularity := 1;
  End;
end;

procedure TMainForm.TodayButtonClick(Sender: TObject);
begin
  JvTFDays1.GotoDate(Date());
  JvTFMonths1.DisplayDate := JvTFDays1.CurrentDate;
  JvTFWeeks1.DisplayDate := JvTFDays1.CurrentDate;
end;

procedure TMainForm.NewApptButtonClick(Sender: TObject);
begin
  // Simply open the EditAppt window.  The Appt var of the
  // EditAppt form will already be nil (which indicates
  // that the appoinment is being created).
  ApptEdit.ShowModal;
end;

procedure TMainForm.NewSchedButtonClick(Sender: TObject);
var
  s: String;
  n: Integer;
begin
  s := InputBox('Add User', 'User name', '');
  if s <> '' then begin
    ResourceCombo.Items.Add(s);
    n := VisibleResources.ResourcesCheckList.Items.Add(s);
    Share.ResourcesCheckList.Items.Add(s);
    VisibleResources.ResourcesCheckList.Checked[n] := True;
  end;
end;

procedure TMainForm.EditApptButtonClick(Sender: TObject);
begin
  If Assigned(JvTFDays1.SelAppt) Then
    Begin
      // Set EditAppt's Appt var to the selected appointment to
      // indicate that the appointment should be edited.
      ApptEdit.Appt := JvTFDays1.SelAppt;
      ApptEdit.ShowModal;
    End
  else
    MessageDlg('Please select an appointment to edit.', mtInformation, [mbOK], 0);
end;

procedure TMainForm.DeleteApptButtonClick(Sender: TObject);
var
  Appt : TJvTFAppt;
  dbDel : Boolean;
  SelSchedName : String;
begin
  // This routine employs a simple business that asks the user what to
  // do in the case where the user is attempting to delete a shared appt.
  // NOTE:  This is NOT required.  You are completely free to implement
  // any business rules you see fit.

  // Another shortcut to save typing
  Appt := JvTFDays1.SelAppt;

  If Assigned(Appt) Then
    Begin
      dbDel := True;
      If Appt.Shared Then
        If MessageDlg('This appointment is shared with other schedules.' + #13#10 +
                      'Do you want to delete the appointment from ' +
                      'all schedules?' + #13#10#13#10 +
                      'Choose ''No'' to delete the appointment from the ' +
                      'selected schedule only.' + #13#10 +
                      'Choose ''All'' to delete the appointment from all schedules.',
                      mtConfirmation, [mbNo, mbAll], 0) = mrNo Then
          Begin
            // Don't delete the appointment, but remove it from the schedule
            // of the selected resource.
            dbDel := False;

            With JvTFDays1 do
              Begin
                SelSchedName := '';
                If ValidSelection and Cols[SelStart.X].Connected Then
                  SelSchedName := Cols[SelStart.X].Schedule.SchedName;
              End;

            If SelSchedName <> '' Then
              Appt.RemoveSchedule(SelSchedName)
            Else
              MessageDlg('No schedule is selected.' + #13#10 +
                         'Could not remove appointment from schedule.',
                         mtInformation, [mbOK], 0);
          End;

      If dbDel Then
        If MessageDlg('Are you sure you want to delete the selected appointment?',
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
          // Delete the appointment (removes it from the db)
          // Note: Could substitute Appt.Delete; for the line below
          JvTFDays1.ScheduleManager.dbDeleteAppt(JvTFDays1.SelAppt);
    End
  Else
    MessageDlg('Please select an appointment to delete.',
               mtInformation, [mbOK], 0);
end;

procedure TMainForm.JvTFDays1DateChanging(Sender: TObject;
  var NewDate: TDate);
begin
  // Make sure all appts are posted before moving on.
  JvTFDays1.ScheduleManager.PostAppts;
end;

procedure TMainForm.JvTFDays1DateChanged(Sender: TObject);
begin
  // Synchronize the tool bar
  With JvTFDays1.Template do
    If ActiveTemplate = agtLinear Then
      GotoDatePicker.Date := LinearStartDate
    Else
      GotoDatePicker.Date := CompDate;
end;

procedure TMainForm.JvTFDays1GranularityChanged(Sender: TObject);
begin
  // Update the TimeIncCombo when the granularity is changed.
  //  (This can be done by <Ctrl> + <Insert> and <Ctrl> + <Delete>)
  Case JvTFDays1.Granularity of
    60 : TimeIncCombo.ItemIndex := 0;
    30 : TimeIncCombo.ItemIndex := 1;
    20 : TimeIncCombo.ItemIndex := 2;
    15 : TimeIncCombo.ItemIndex := 3;
    12 : TimeIncCombo.ItemIndex := 4;
    10 : TimeIncCombo.ItemIndex := 5;
     6 : TimeIncCombo.ItemIndex := 6;
     5 : TimeIncCombo.ItemIndex := 7;
     4 : TimeIncCombo.ItemIndex := 8;
     3 : TimeIncCombo.ItemIndex := 9;
     2 : TimeIncCombo.ItemIndex := 10;
  Else
    TimeIncCombo.ItemIndex := 11;
  End;
end;

procedure TMainForm.JvTFDays1DblClick(Sender: TObject);
begin
  With JvTFDays1 do
    If ValidSelection Then
      If Assigned(SelAppt) Then
        EditApptButtonClick(nil)
      Else
        NewApptButtonClick(nil);
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  ResName : String;
begin
  // Initialize the date
  ReadIni;

//  GotoDatePicker.Date := EncodeDate(2002, 1, 1);

  if FNewDatabase then
    NewSchedButtonClick(nil);

  // Populate the resource related controls
  With SchedulesQuery do
    try
      Open;
      First;
      While not EOF do
        Begin
          ResName := SchedulesQuery.FieldByName('SchedName').AsString;
          ResourceCombo.Items.Add(ResName);
          VisibleResources.ResourcesCheckList.Items.Add(ResName);
          Share.ResourcesCheckList.Items.Add(ResName);
          Next;
        End;
      Close;
    except
      //on E:EDBEngineError do
      on E: EDatabaseError do
      begin
        ShowMessageFmt('%s:'#13#10'Try moving the database to a shorter path.',[E.Message]);
        Application.Terminate;
        Exit;
      end;
    end;

  // Initialize the resource related controls
  ResourceCombo.ItemIndex := 0;
  if VisibleResources.ResourcesCheckList.Items.Count > 0 then begin
    VisibleResources.ResourcesCheckList.Checked[0] := True;

    // Initialize the comparative template
    JvTFDays1.Template.CompNames.Add(VisibleResources.ResourcesCheckList.Items[0]);
  end;

  // Now run the events to synchronize JvTFDays, etc.
  ResourceComboChange(nil);
  DaysComboChange(nil);
  ModeComboChange(nil);

  if GlobalSettings.StartToday then
    GotoDatePicker.Date := Date()
  else
    GotoDatePicker.Date := GlobalSettings.StartDate;
  GotoDatePickerChange(nil);
  TimeIncComboChange(nil);
end;

procedure TMainForm.PrintButtonClick(Sender: TObject);
begin
  if not PrintDialog.Execute then
    exit;

  with JvTFDaysPrinter1 do
  begin
    // "Copy" the display properties from the JvTFDays control
    SetProperties(JvTFDays1);
    // Set gridline color to black for sharp display on printed page
    GridLineColor := clBlack;
    // print 48 rows on each page
    PageLayout.RowsPerPage := 48;
    // fit all the columns onto one page wide
    PageLayout.ColsPerPage := 0;
    // "Copy" the schedules from the JvTFDays control
    Cols.Assign(JvTFDays1.Cols);
    PrintProgress.Show;
    Application.ProcessMessages;
    // print the document
    PrintDirect;
    PrintProgress.Close;
  end;
end;

procedure TMainForm.JvTFDaysPrinter1ApptProgress(Sender: TObject;
  Current, Total: Integer);
begin
  If Current > Total Then
    Total := Current;
  PrintProgress.Label2.Caption := 'Processing appointment ' + IntToStr(Current) +
                                  ' of ' + IntToStr(Total) + ' (estimated)';
  PrintProgress.ProgressBar1.Max := Total;
  PrintProgress.ProgressBar1.Position := Current;
end;

procedure TMainForm.JvTFDaysPrinter1AssembleProgress(Sender: TObject;
  Current, Total: Integer);
begin
  PrintProgress.Label2.Caption := 'Assembling page ' + IntToStr(Current) +
                                  ' of ' + IntToStr(Total); 
  PrintProgress.ProgressBar1.Max := Total;
  PrintProgress.ProgressBar1.Position := Current;
end;

procedure TMainForm.JvTFDaysPrinter1PrintProgress(Sender: TObject;
  Current, Total: Integer);
begin
  PrintProgress.Label2.Caption := 'Printing page ' + IntToStr(Current) +
                                  ' of ' + IntToStr(Total);
  PrintProgress.ProgressBar1.Max := Total;
  PrintProgress.ProgressBar1.Position := Current;
end;

procedure TMainForm.IconsLinkClick(Sender: TObject);
begin
  OpenURL('https://icons8.com');
end;

procedure TMainForm.IconsLinkMouseEnter(Sender: TObject);
begin
  IconsLink.Font.Style := IconsLink.Font.Style + [fsUnderline];
  Screen.Cursor := crHandPoint;
end;

procedure TMainForm.IconsLinkMouseLeave(Sender: TObject);
begin
  IconsLink.Font.Style := IconsLink.Font.Style - [fsUnderline];
  Screen.Cursor := crDefault;
end;

procedure TMainForm.JvTFAlarm1Alarm(Sender: TObject; AAppt: TJvTFAppt;
  var SnoozeMins: Integer; var Dismiss: Boolean);
var
  F: TAlarmForm;
begin
  F := TAlarmForm.Create(nil);
  try
    F.SetAppt(AAppt);
    F.SnoozeMins := SnoozeMins;
    F.ShowModal;
    Dismiss := not F.Snooze;
    SnoozeMins := F.SnoozeMins;
  finally
    F.Free;
  end;
end;

{
var
  msg: String;
  res: Integer;
  s: String;
begin
  msg := Format('The event "%s" is due', [AAppt.Description]);
  if AAppt.StartDate = Date then
    msg := msg + ' at ' + TimeToStr(AAppt.StartTime)
  else
    msg := msg + ' on ' + FormatDateTime('dddddd', AAppt.StartTime);
  msg := msg + LineEnding + 'Remind in ' + IntToStr(SnoozeMins) + ' minutes?';
  res := MessageDlg(msg, mtInformation, [mbYes, mbNo], 0);
  Dismiss := res = mrYes;
end;
 }

procedure TMainForm.utfScheduleManager1LoadBatch(Sender: TObject;
  BatchName: String; BatchStartDate, BatchEndDate: TDate);
var
  Appt : TJvTFAppt;
  NewAppt : Boolean;
begin
  With NeedApptsQuery do
    Begin
      // Set the query parameters so the query will return
      // all appointments for the given resource that fall
      // on the given date.
      ParamByName('D1').AsDate := BatchStartDate;
      ParamByName('D2').AsDate := BatchEndDate;
      ParamByName('SchedName').AsString := BatchName;

      // Next, loop through the returned records to add the data
      Open;
      First;
      While not EOF do
        Begin
          // Request an appointment object from the server
          utfScheduleManager1.RequestAppt(FieldByName('ApptID').AsString,
            Appt, NewAppt);

          // If it is a newly loaded appt we want to set its properties
          If NewAppt Then
            Begin
              Appt.SetStartEnd(FieldByName('StartDate').AsDateTime,
                               FieldByName('StartTime').AsDateTime,
                               FieldByName('EndDate').AsDateTime,
                               FieldByName('EndTime').AsDateTime);
              Appt.Description := FieldByName('Description').AsString;
              Appt.AlarmEnabled := FieldByName('AlarmEnabled').AsBoolean;
              Appt.AlarmAdvance := FieldByName('AlarmAdvance').AsInteger;

              // Now manage the Appt --> Schedule(s) relationship
              With ApptSchedulesQuery do
                Begin
                  ParamByName('ApptID').AsString := Appt.ID;
                  Open;
                  First;
                  While not EOF do
                    Begin
                      Appt.AddSchedule(FieldByName('SchedName').AsString);
                      Next;
                    End;
                  Close; // ApptSchedulesQuery
                End;
            End;
          Next; // NeedApptsQuery record
        End;
      Close;  // NeedApptsQuery
    End;
end;

procedure TMainForm.CreateDatabase(const AFileName: String);
var
  sql: String;
begin
  dbUTF.Open;
  SQLTransaction.Active := true;

  sql := 'CREATE TABLE "GroupAppt" (' +
    '"ApptID" STRING PRIMARY KEY,'+
    '"StartDate" DATE,'+
    '"StartTime" TIME,'+
    '"EndDate" DATE,'+
    '"EndTime" TIME,'+
    '"Description" TEXT,'+
    '"AlarmEnabled" BOOL,'+
    '"AlarmAdvance" REAL);';
  dbUTF.ExecuteDirect(sql);
  SQLTransaction.Commit;

  sql := 'CREATE TABLE "GroupLink" ('+
    '"SchedName" String,'+
    '"ApptID" String);';
  dbUTF.ExecuteDirect(sql);
  SQLTransaction.Commit;

  FNewDatabase := true;
end;


procedure TMainForm.FormCreate(Sender: TObject);
var
  fn: String;
begin
  with FormatSettings do begin
    ThousandSeparator := ',';
    DecimalSeparator := '.';
    DateSeparator := '/';
    TimeSeparator := ':';
    ShortDateFormat := 'd/mm/yyyy';
    LongDateFormat := 'dd" "mmmm" "yyyy';
    TimeAMString := 'AM';
    TimePMString := 'PM';
    ShortTimeFormat := 'hh:nn';
    LongTimeFormat := 'hh:nn:ss';
    ShortMonthNames[1] := 'Jan';
    ShortMonthNames[2] := 'Feb';
    ShortMonthNames[3] := 'Mar';
    ShortMonthNames[4] := 'Apr';
    ShortMonthNames[5] := 'May';
    ShortMonthNames[6] := 'Jun';
    ShortMonthNames[7] := 'Jul';
    ShortMonthNames[8] := 'Aug';
    ShortMonthNames[9] := 'Sep';
    ShortMonthNames[10] := 'Oct';
    ShortMonthNames[11] := 'Nov';
    ShortMonthNames[12] := 'Dec';
    LongMonthNames[1] := 'January';
    LongMonthNames[2] := 'February';
    LongMonthNames[3] := 'March';
    LongMonthNames[4] := 'April';
    LongMonthNames[5] := 'May';
    LongMonthNames[6] := 'June';
    LongMonthNames[7] := 'July';
    LongMonthNames[8] := 'August';
    LongMonthNames[9] := 'September';
    LongMonthNames[10] := 'October';
    LongMonthNames[11] := 'November';
    LongMonthNames[12] := 'December';
    ShortDayNames[1] := 'Sun';
    ShortDayNames[2] := 'Mon';
    ShortDayNames[3] := 'Tue';
    ShortDayNames[4] := 'Wed';
    ShortDayNames[5] := 'Thu';
    ShortDayNames[6] := 'Fri';
    ShortDayNames[7] := 'Sat';
    LongDayNames[1] := 'Sunday';
    LongDayNames[2] := 'Monday';
    LongDayNames[3] := 'Tuesday';
    LongDayNames[4] := 'Wednesday';
    LongDayNames[5] := 'Thursday';
    LongDayNames[6] := 'Friday';
    LongDayNames[7] := 'Saturday';
  end;

  fn := Application.Location + 'data.sqlite';
  dbUTF.DatabaseName := fn;
  if FileExists(fn) then begin
    dbUTF.Open;
    SQLTransaction.Active := true;
  end else
    CreateDatabase(fn);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteIni;
end;

procedure TMainForm.ReadIni;
var
  ini: TCustomIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ModeCombo.ItemIndex := ini.ReadInteger('MainForm', 'ModeCombo', 0);
    TimeIncCombo.ItemIndex := ini.ReadInteger('MainForm', 'TimeIncCombo', 1);
    DaysCombo.ItemIndex := ini.ReadInteger('MainForm', 'DaysCombo', 0);
    WeeksCombo.ItemIndex := ini.ReadInteger('MainForm', 'WeeksCombo', 0);

    PageControl1.ActivePageIndex := ini.ReadInteger('MainForm', 'PageIndex', 0);
    PageControl1Change(nil);

    GlobalSettings.StartToday := ini.ReadBool('Settings', 'StartToday', GlobalSettings.StartToday);
    GlobalSettings.StartDate := ini.ReadDate('Settings', 'StartDate', GlobalSettings.StartDate);
    GlobalSettings.Hr2400 := ini.ReadBool('Settings', 'Hr2400', GlobalSettings.Hr2400);
    GlobalSettings.FirstDayOfWeek := TTFDayofWeek(ini.ReadInteger('Settings', 'FirstDayOfWeek', ord(GlobalSettings.FirstDayOfWeek)));
    GlobalSettings.PrimeTimeStart := ini.ReadTime('Settings', 'PrimeTimeStart', GlobalSettings.PrimeTimeStart);
    GlobalSettings.PrimeTimeEnd := ini.ReadTime('Settings', 'PrimeTimeEnd', GlobalSettings.PrimeTimeEnd);
    GlobalSettings.PrimeTimeColor := TColor(ini.ReadInteger('Settings', 'PrimeTimeColor', Integer(GlobalSettings.PrimeTimeColor)));
    GlobalSettings.IconSet := ini.ReadInteger('Settings', 'IconSet', GlobalSettings.IconSet);
    ApplySettings;
  finally
    ini.Free;
  end;
end;

procedure TMainForm.WriteIni;
var
  ini: TCustomIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ini.WriteInteger('MainForm', 'PageIndex', PageControl1.ActivePageIndex);

    ini.WriteInteger('MainForm', 'ModeCombo', ModeCombo.ItemIndex);
    ini.WriteInteger('MainForm', 'TimeIncCombo', TimeIncCombo.ItemIndex);
    ini.WriteInteger('MainForm', 'DaysCombo', DaysCombo.ItemIndex);
    ini.WriteInteger('MainForm', 'WeeksCombo', WeeksCombo.ItemIndex);

    ini.WriteBool('Settings', 'StartToday', GlobalSettings.StartToday);
    ini.WriteDate('Settings', 'StartDate', GlobalSettings.StartDate);
    ini.WriteBool('Settings', 'Hr2400', GlobalSettings.Hr2400);
    ini.WriteInteger('Settings', 'FirstDayOfWeek', ord(GlobalSettings.FirstDayOfWeek));
    ini.WriteTime('Settings', 'PrimeTimeStart', GlobalSettings.PrimeTimeStart);
    ini.WriteTime('Settings', 'PrimeTimeEnd', GlobalSettings.PrimeTimeEnd);
    ini.WriteInteger('Settings', 'PrimeTimeColor', GlobalSettings.PrimeTimeColor);
    ini.WriteInteger('Settings', 'IconSet', GlobalSettings.IconSet);
  finally
    ini.Free;
  end;
end;

end.

