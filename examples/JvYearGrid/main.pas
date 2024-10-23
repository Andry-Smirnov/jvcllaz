unit main;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}clocale,{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls, Grids,
  ExtCtrls, ComCtrls, JvYearGrid;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnFont: TButton;
    btnSaveYear: TButton;
    btnLoadYear: TButton;
    cbReadOnly: TCheckBox;
    cmbAutoSize: TCheckBox;
    cmbMonthFormat: TComboBox;
    cmbDayNamesAlignment: TComboBox;
    cmbDayFormat: TComboBox;
    cmbMonthNamesAlignment: TComboBox;
    cmbDaysAlignment: TComboBox;
    cmbFlat: TCheckBox;
    FontDialog1: TFontDialog;
    JvYearGrid1: TJvYearGrid;
    edLeftMargin: TSpinEdit;
    edRightMargin: TSpinEdit;
    edTopMargin: TSpinEdit;
    edBottomMargin: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblYear: TLabel;
    Panel1: TPanel;
    rgAutoSize: TCheckGroup;
    udYear: TUpDown;
    procedure btnFontClick(Sender: TObject);
    procedure btnLoadYearClick(Sender: TObject);
    procedure btnSaveYearClick(Sender: TObject);
    procedure cmbAutoSizeChange(Sender: TObject);
    procedure cmbDayFormatChange(Sender: TObject);
    procedure cmbDayNamesAlignmentChange(Sender: TObject);
    procedure cmbDaysAlignmentChange(Sender: TObject);
    procedure cmbFlatChange(Sender: TObject);
    procedure cmbMonthFormatChange(Sender: TObject);
    procedure cmbMonthNamesAlignmentChange(Sender: TObject);
    procedure edMarginChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgAutoSizeItemClick(Sender: TObject; Index: integer);
    procedure udYearClick(Sender: TObject; Button: TUDBtnType);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DateUtils;

{ TMainForm }

procedure TMainForm.cmbDayNamesAlignmentChange(Sender: TObject);
begin
  JvYearGrid1.DayNamesAlignment := TAlignment(cmbDayNamesAlignment.ItemIndex);
end;

procedure TMainForm.cmbDayFormatChange(Sender: TObject);
begin
  JvYearGrid1.DayFormat := TJvDayFormat(cmbDayFormat.ItemIndex);
end;

procedure TMainForm.cmbDaysAlignmentChange(Sender: TObject);
begin
  JvYearGrid1.DaysAlignment := TAlignment(cmbDaysAlignment.ItemIndex);
end;

procedure TMainForm.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(JvYearGrid1.Font);
  if FontDialog1.Execute then
    JvYearGrid1.Font.Assign(FontDialog1.Font);
end;

procedure TMainForm.btnLoadYearClick(Sender: TObject);
var
  fn: String;
begin
  fn := Application.Location + IntToStr(JvYearGrid1.Year) + '.dat';
  if FileExists(fn) then
    JvYearGrid1.LoadYear(fn);
end;

procedure TMainForm.btnSaveYearClick(Sender: TObject);
var
  fn: String;
begin
  fn := Application.Location + IntToStr(JvYearGrid1.Year) + '.dat';
  JvYearGrid1.SaveYear(fn);
end;

procedure TMainForm.cmbAutoSizeChange(Sender: TObject);
begin
  JvYearGrid1.AutoSize := cmbAutoSize.Checked;
  rgAutoSize.Enabled := JvYearGrid1.AutoSize;
end;

procedure TMainForm.cmbFlatChange(Sender: TObject);
begin
  JvYearGrid1.Flat := cmbFlat.Checked;
end;

procedure TMainForm.cmbMonthFormatChange(Sender: TObject);
begin
  JvYearGrid1.MonthFormat := TJvMonthFormat(cmbMonthFormat.ItemIndex);
end;

procedure TMainForm.cmbMonthNamesAlignmentChange(Sender: TObject);
begin
  JvYearGrid1.MonthNamesAlignment := TAlignment(cmbMonthNamesAlignment.ItemIndex);
end;

procedure TMainForm.edMarginChange(Sender: TObject);
begin
  if Sender = edLeftMargin then
    JvYearGrid1.CellMargins.Left := edLeftMargin.Value;
  if Sender = edRightMargin then
    JvYearGrid1.CellMargins.Right := edRightMargin.Value;
  if Sender = edTopMargin then
    JvYearGrid1.CellMargins.Top := edTopMargin.Value;
  if Sender = edBottomMargin then
    JvYearGrid1.CellMargins.Bottom := edBottomMargin.Value;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  // Doing this in the OnCreate event would mean that the scaled values are
  // not ready, yet.
  edLeftMargin.Value := JvYearGrid1.CellMargins.Left;
  edRightMargin.Value := JvYearGrid1.CellMargins.Right;
  edTopMargin.Value := JvYearGrid1.CellMargins.Top;
  edBottomMargin.Value := JvYearGrid1.CellMargins.Bottom;
  edLeftMargin.OnChange := @edMarginChange;
  edRightMargin.OnChange := @edMarginChange;
  edTopMargin.OnChange := @edMarginChange;
  edBottomMargin.OnChange := @edMarginChange;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  JvYearGrid1.Year := YearOf(Date);

  cmbDayNamesAlignment.ItemIndex := ord(JvYearGrid1.DayNamesAlignment);
  cmbMonthNamesAlignment.ItemIndex := ord(JvYearGrid1.MonthNamesAlignment);
  cmbDaysAlignment.ItemIndex := ord(JvYearGrid1.DaysAlignment);
  cmbDayFormat.ItemIndex := ord(JvYearGrid1.DayFormat);
  cmbMonthFormat.ItemIndex := ord(JvYearGrid1.MonthFormat);
  cmbMonthFormatChange(nil);

  udYear.Position := JvYearGrid1.Year;

  cmbFlat.Checked := JvYearGrid1.Flat;
  cmbAutoSize.Checked := JvYearGrid1.AutoSize;
  rgAutoSize.Checked[ord(aoGrid)] := aoGrid in JvYearGrid1.AutosizeOptions;
  rgAutoSize.Checked[ord(aoFirstColumn)] := aoFirstColumn in JvYearGrid1.AutosizeOptions;
  rgAutoSize.Checked[ord(aoFirstRow)] := aoFirstRow in JvYearGrid1.AutosizeOptions;
  rgAutoSize.Checked[ord(aoColumns)] := aoColumns in JvYearGrid1.AutosizeOptions;
  rgAutoSize.Checked[ord(aoRows)] := aoRows in JvYearGrid1.AutosizeOptions;
end;

procedure TMainForm.rgAutoSizeItemClick(Sender: TObject; Index: integer);
begin
  if rgAutoSize.Checked[ord(aoGrid)] then
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions + [aoGrid]
  else
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions - [aoGrid];

  if rgAutoSize.Checked[ord(aoFirstColumn)] then
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions + [aoFirstColumn]
  else
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions - [aoFirstColumn];

  if rgAutoSize.Checked[ord(aoFirstRow)] then
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions + [aoFirstRow]
  else
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions - [aoFirstRow];

  if rgAutoSize.Checked[ord(aoColumns)] then
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions + [aoColumns]
  else
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions - [aoColumns];

  if rgAutoSize.Checked[ord(aoRows)] then
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions + [aoRows]
  else
    JvYearGrid1.AutoSizeOptions := JvYearGrid1.AutoSizeOptions - [aoRows];
end;

procedure TMainForm.udYearClick(Sender: TObject; Button: TUDBtnType);
begin
  JvYearGrid1.Year := udYear.Position;
end;

end.

