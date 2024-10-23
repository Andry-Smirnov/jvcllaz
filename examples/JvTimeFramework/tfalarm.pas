unit tfAlarm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, StdCtrls,
  Spin, ExtCtrls,
  JvTFManager;

type

  { TAlarmForm }

  TAlarmForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    cmbTimeUnits: TComboBox;
    Label1: TLabel;
    EventLabel: TLabel;
    IsDueLabel: TLabel;
    Panel1: TPanel;
    TimeLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    seSnoozeTime: TSpinEdit;
    procedure OKButtonClick(Sender: TObject);
  private
    FSnooze: Boolean;
    FSnoozeMins: Integer;
    function GetSnoozeMins: Integer;
    procedure SetSnoozeMins(const AValue: Integer);

  public
    procedure SetAppt(AAppt: TJvTFAppt);
    property SnoozeMins: Integer read GetSnoozeMins write SetSnoozeMins;
    property Snooze: Boolean read FSnooze;

  end;

var
  AlarmForm: TAlarmForm;

implementation

{$R *.lfm}

{ TAlarmForm }

function TAlarmForm.GetSnoozeMins: Integer;
begin
  case cmbTimeUnits.ItemIndex of
    0: Result := seSnoozeTime.Value;
    1: Result := seSnoozeTime.Value * 60;
    2: Result := seSnoozeTime.Value * 60 * 24;
  end;
end;

procedure TAlarmForm.OKButtonClick(Sender: TObject);
begin
  FSnooze := true;
end;

procedure TAlarmForm.SetAppt(AAppt: TJvTFAppt);
var
  deltaMins: Integer;
begin
  EventLabel.Caption := AAppt.Description;
  if AAppt.StartDate < Now() then begin
    IsDueLabel.Caption := 'is OVERDUE: ';
    TimeLabel.Caption := FormatDateTime('t', AAppt.StartTime);  // 't' = ShortTimeFormat
  end else
  if AAppt.StartDate = Date() then begin
    IsDueLabel.caption := 'is due at ';
    TimeLabel.Caption := FormatDateTime('t', AAppt.StartTime);
  end else begin
    IsDueLabel.Caption := 'is due on ';
    TimeLabel.Caption := FormatDateTime('dddddd', AAppt.StartDateTime);  // LongDateFormat
  end;
end;

procedure TAlarmForm.SetSnoozeMins(const AValue: Integer);
begin
  FSnoozeMins := AValue;
  if FSnoozeMins <= 60 then begin
    cmbTimeUnits.ItemIndex := 0;  // minutes
    seSnoozeTime.Value := FSnoozeMins;
  end else
  if FSnoozeMins <= 24*60 then begin
    cmbTimeUnits.ItemIndex := 1;  // hours;
    seSnoozeTime.Value := FSnoozeMins div 24;
  end else begin
    cmbTimeUnits.ItemIndex := 2;  // days
    seSnoozeTime.Value := FSnoozeMins div (24*60);
  end;
end;

end.

