unit tfSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, StdCtrls,
  ExtCtrls, EditBtn, JvTFUtils, JvTFDays;

type
  TGlobalSettings = record
    StartToday: Boolean;
    StartDate: TDate;
    Hr2400: Boolean;               // 24 hour or 12 hour AM/PM format
    FirstDayOfWeek: TTFDayOfWeek;
    PrimeTimeStart: TTime;
    PrimeTimeEnd: TTime;
    PrimeTimeColor: TColor;
    IconSet: Integer;
  end;

var
  GlobalSettings: TGlobalSettings = (
    StartToday: true;
    StartDate: 0;
    Hr2400: false;
    FirstDayOfWeek: dowSunday;
    PrimeTimeStart: 8 * ONE_HOUR;
    PrimeTimeEnd: 17 * ONE_HOUR;
    PrimeTimeColor: $00C4FFFF;
    IconSet: 0
  );

type
  { TSettingsForm }

  TSettingsForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    ButtonPanel1: TButtonPanel;
    cbTimeFormat: TComboBox;
    cbFirstDayOfWeek: TComboBox;
    clbPrimeTimeColor: TColorButton;
    cbIconSet: TComboBox;
    deStartDate: TDateEdit;
    Label1: TLabel;
    lblIconSet: TLabel;
    lblPrimeTimeStart: TLabel;
    lblPrimeTimeEnd: TLabel;
    lblFirstDayOfWeek: TLabel;
    lblTimeFormat: TLabel;
    Panel1: TPanel;
    edPrimeTimeStart: TTimeEdit;
    edPrimeTimeEnd: TTimeEdit;
    StartDatePanel: TPanel;
    rbStartDate: TRadioButton;
    rbStartToday: TRadioButton;
    procedure deStartDateAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    FOKPressed: Boolean;
    procedure ControlsToSettings;
    procedure SettingsToControls;

  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.lfm}

procedure TSettingsForm.ControlsToSettings;
begin
  GlobalSettings.StartToday := rbStartToday.Checked;
  if not GlobalSettings.StartToday and (GlobalSettings.StartDate = Date) then
    GlobalSettings.StartDate := 0
  else
    GlobalSettings.StartDate := deStartDate.Date;

  GlobalSettings.Hr2400 := cbTimeFormat.ItemIndex = 0;
  GlobalSettings.FirstDayOfWeek := TTFDayOfWeek(cbFirstDayOfWeek.ItemIndex);
  GlobalSettings.PrimeTimeStart := frac(edPrimeTimeStart.Time);
  GlobalSettings.PrimeTimeEnd := frac(edPrimeTimeEnd.Time);
  GlobalSettings.PrimeTimeColor := clbPrimeTimeColor.ButtonColor;

  GlobalSettings.IconSet := cbIconSet.ItemIndex;
end;

procedure TSettingsForm.deStartDateAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  rbStartDate.Checked := true;
end;

procedure TSettingsForm.SettingsToControls;
begin
  if GlobalSettings.StartToday then
    rbStartToday.Checked := true
  else
    rbStartDate.Checked := true;
  if GlobalSettings.StartDate = 0 then
    deStartDate.Date := Date()
  else
    deStartDate.Date := GlobalSettings.StartDate;

  cbTimeFormat.ItemIndex := ord(not GlobalSettings.Hr2400);
  cbFirstDayOfWeek.ItemIndex := ord(GlobalSettings.FirstDayOfWeek);
  edPrimeTimeStart.Time := GlobalSettings.PrimeTimeStart;
  edPrimeTimeEnd.Time := GlobalSettings.PrimeTimeEnd;
  clbPrimeTimeColor.ButtonColor := GlobalSettings.PrimeTimeColor;

  cbIconSet.ItemIndex := GlobalSettings.IconSet;
end;

procedure TSettingsForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if FOKPressed then
    ControlsToSettings;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  cbFirstDayOfWeek.Items.BeginUpdate;
  try
    cbFirstDayOfWeek.Clear;
    for i:=1 to 7 do
      cbFirstDayOfWeek.Items.Add(FormatSettings.LongDayNames[i]);
  finally
    cbFirstDayOfWeek.Items.EndUpdate;
  end;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  FOKPressed := false;
  SettingsToControls;
end;

procedure TSettingsForm.OKButtonClick(Sender: TObject);
begin
  FOKPressed := true;
end;


end.

