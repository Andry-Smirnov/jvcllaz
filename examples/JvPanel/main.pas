unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  CheckLst, ExtCtrls, JvPanel;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnAddButton: TButton;
    btnClear: TButton;
    btnHotTrackFont: TButton;
    btnFont: TButton;
    cbAutoArrange: TCheckBox;
    cbSizeable: TCheckBox;
    cbWrapControls: TCheckBox;
    cbFlatBorder: TCheckBox;
    cbMovable: TCheckBox;
    cbHorAlignLines: TCheckBox;
    cbHotTrack: TCheckBox;
    cbHotTrackOptionsEnabled: TCheckBox;
    cbHotTrackoptionsFrameVisible: TCheckBox;
    cbMultiLine: TCheckBox;
    CheckListBox1: TCheckListBox;
    cmbAlignment: TComboBox;
    cmbArrangeSettingsAutoSize: TComboBox;
    cmbHorAlignment: TComboBox;
    cmbBevelOuter: TComboBox;
    cmbBorderStyle: TComboBox;
    cmbBevelInner: TComboBox;
    cmbVertAlignment: TComboBox;
    cmbLayout: TComboBox;
    cbFlatBorderColor: TColorButton;
    cbHotTrackOptionsColor: TColorButton;
    cbHotTrackOptionsFrameColor: TColorButton;
    cbColor: TColorButton;
    cbHintColor: TColorButton;
    edCaption: TEdit;
    FontDialog: TFontDialog;
    gbArrangeSettings: TGroupBox;
    gbBevel: TGroupBox;
    gbCaption: TGroupBox;
    gbBorder: TGroupBox;
    gbMisc: TGroupBox;
    gbHotTrack: TGroupBox;
    gbHotTrackOptions: TGroupBox;
    JvPanel1: TJvPanel;
    lblArrangeSettingsAutoSize: TLabel;
    lblHorAlignment: TLabel;
    lblBevelOuter: TLabel;
    lblBorderStyle: TLabel;
    lblBevelInner: TLabel;
    lblVertAlignment: TLabel;
    lblMaxCtrlsPerLine: TLabel;
    lblBorderWidth: TLabel;
    lblBevelWidth: TLabel;
    lblLayout: TLabel;
    lblAlignment: TLabel;
    lblBorderLeft: TLabel;
    lblBorderTop: TLabel;
    lblVertDistance: TLabel;
    lblHorDistance: TLabel;
    Panel1: TPanel;
    seBorderTop: TSpinEdit;
    seBevelWidth: TSpinEdit;
    seMaxCtrlsPerLine: TSpinEdit;
    seHorDistance: TSpinEdit;
    seBorderLeft: TSpinEdit;
    seBorderWidth: TSpinEdit;
    seVertDistance: TSpinEdit;
    procedure btnAddButtonClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnHotTrackFontClick(Sender: TObject);
    procedure cbAutoArrangeChange(Sender: TObject);
    procedure cbFlatBorderChange(Sender: TObject);
    procedure cbFlatBorderColorColorChanged(Sender: TObject);
    procedure cbHintColorColorChanged(Sender: TObject);
    procedure cbHorAlignLinesChange(Sender: TObject);
    procedure cbHotTrackChange(Sender: TObject);
    procedure cbHotTrackOptionsEnabledChange(Sender: TObject);
    procedure cbMovableChange(Sender: TObject);
    procedure cbMultiLineChange(Sender: TObject);
    procedure cbSizeableChange(Sender: TObject);
    procedure cbWrapControlsChange(Sender: TObject);
    procedure cbHotTrackoptionsFrameVisibleChange(Sender: TObject);
    procedure cmbArrangeSettingsAutoSizeChange(Sender: TObject);
    procedure cmbBevelInnerChange(Sender: TObject);
    procedure cmbBorderStyleChange(Sender: TObject);
    procedure cmbHorAlignmentChange(Sender: TObject);
    procedure cmbLayoutChange(Sender: TObject);
    procedure cmbAlignmentChange(Sender: TObject);
    procedure cmbVertAlignmentChange(Sender: TObject);
    procedure cbHotTrackOptionsColorColorChanged(Sender: TObject);
    procedure cbHotTrackOptionsFrameColorColorChanged(Sender: TObject);
    procedure cbColorColorChanged(Sender: TObject);
    procedure edCaptionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seBevelWidthChange(Sender: TObject);
    procedure seBorderLeftChange(Sender: TObject);
    procedure seBorderTopChange(Sender: TObject);
    procedure seBorderWidthChange(Sender: TObject);
    procedure seHorDistanceChange(Sender: TObject);
    procedure seMaxCtrlsPerLineChange(Sender: TObject);
    procedure seVertDistanceChange(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.btnAddButtonClick(Sender: TObject);
begin
  with TButton.Create(self) do begin
    Parent := JvPanel1;
    Left := Random(JvPanel1.Width - Width);
    Top := Random(JvPanel1.Height - Height);
    Caption := 'Button' + IntToStr(JvPanel1.ControlCount);
  end;
end;

procedure TMainForm.btnClearClick(Sender: TObject);
begin
  while JvPanel1.ControlCount > 0 do
    JvPanel1.Controls[0].Free;
end;

procedure TMainForm.btnFontClick(Sender: TObject);
begin
  FontDialog.Font := JvPanel1.Font;
  if FontDialog.Execute then begin
    JvPanel1.Font := FontDialog.Font;
    btnFont.Font.Assign(FontDialog.Font);
  end;
end;

procedure TMainForm.btnHotTrackFontClick(Sender: TObject);
begin
  FontDialog.Font := JvPanel1.HotTrackFont;
  if FontDialog.Execute then begin
    JvPanel1.HotTrackfont := FontDialog.Font;
    btnHotTrackFont.Font.Assign(FontDialog.Font);
  end;
end;

procedure TMainForm.cbAutoArrangeChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.AutoArrange := cbAutoArrange.Checked;
end;

procedure TMainForm.cbFlatBorderChange(Sender: TObject);
begin
  JvPanel1.FlatBorder := cbFlatBorder.Checked;
end;

procedure TMainForm.cbFlatBorderColorColorChanged(Sender: TObject);
begin
  JvPanel1.FlatBorderColor := cbFlatBorderColor.ButtonColor;
end;

procedure TMainForm.cbHintColorColorChanged(Sender: TObject);
begin
  JvPanel1.HintColor := cbHintColor.ButtonColor;
end;

procedure TMainForm.cbHorAlignLinesChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.HorizontalAlignLines := CbHorAlignLines.Checked;
end;

procedure TMainForm.cbHotTrackChange(Sender: TObject);
begin
  JvPanel1.HotTrack := cbhotTrack.Checked;
end;

procedure TMainForm.cbHotTrackOptionsEnabledChange(Sender: TObject);
begin
  JvPanel1.HotTrackOptions.Enabled := cbHotTrackOptionsEnabled.Checked;
end;

procedure TMainForm.cbMovableChange(Sender: TObject);
begin
  JvPanel1.Movable := cbMovable.Checked;
end;

procedure TMainForm.cbMultiLineChange(Sender: TObject);
begin
  JvPanel1.MultiLine := cbMultiLine.Checked;
end;

procedure TMainForm.cbSizeableChange(Sender: TObject);
begin
  JvPanel1.Sizeable := cbSizeable.Checked;
end;

procedure TMainForm.cbWrapControlsChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.WrapControls := cbWrapControls.Checked;
end;

procedure TMainForm.cbHotTrackoptionsFrameVisibleChange(Sender: TObject);
begin
  JvPanel1.HotTrackOptions.FrameVisible := cbHotTrackoptionsFrameVisible.Checked;
end;

procedure TMainForm.cmbAlignmentChange(Sender: TObject);
begin
  JvPanel1.Alignment := TAlignment(cmbAlignment.ItemIndex);
end;

procedure TMainForm.cmbArrangeSettingsAutoSizeChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.AutoSize := TJvAutoSizePanel(cmbArrangeSettingsAutoSize.ItemIndex);
end;

procedure TMainForm.cmbBevelInnerChange(Sender: TObject);
begin
  if Sender = cmbBevelInner then
    JvPanel1.BevelInner := TBevelCut(cmbBevelInner.ItemIndex)
  else if Sender = cmbBevelOuter then
    JvPanel1.BevelOuter := TBevelCut(cmbBevelOuter.ItemIndex);
end;

procedure TMainForm.cmbBorderStyleChange(Sender: TObject);
begin
  JvPanel1.BorderStyle := TBorderStyle(cmbBorderStyle.ItemIndex);
end;

procedure TMainForm.cmbHorAlignmentChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.HorizontalAlignment := TJvArrangeSettingsHAlignment(cmbHorAlignment.ItemIndex);
end;

procedure TMainForm.cmbLayoutChange(Sender: TObject);
begin
  JvPanel1.Layout := TTextLayout(cmbLayout.ItemIndex);
end;

procedure TMainForm.cmbVertAlignmentChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.VerticalAlignment := TJvArrangeSettingsVAlignment(cmbVertAlignment.ItemIndex);
end;

procedure TMainForm.cbColorColorChanged(Sender: TObject);
begin
  JvPanel1.Color := cbColor.ButtonColor;
end;

procedure TMainForm.cbHotTrackOptionsColorColorChanged(Sender: TObject);
begin
  JvPanel1.HotTrackOptions.Color := cbHotTrackOptionsColor.ButtonColor;
end;

procedure TMainForm.cbHotTrackOptionsFrameColorColorChanged(Sender: TObject);
begin
  JvPanel1.HotTrackOptions.FrameColor := cbHotTrackOptionsFrameColor.ButtonColor;
end;

procedure TMainForm.edCaptionChange(Sender: TObject);
begin
  JvPanel1.Caption := edCaption.Text;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  cbFlatBorderColor.ButtonColor := JvPanel1.FlatBorderColor;
  cbHotTrackOptionsColor.ButtonColor := JvPanel1.HotTrackOptions.Color;
  cbHotTrackOptionsFrameColor.ButtonColor := JvPanel1.HotTrackOptions.FrameColor;
  cbColor.ButtonColor := JvPanel1.Color;
  cbHintColor.ButtonColor := JvPanel1.HintColor;
  edCaption.Text := JvPanel1.Caption;
end;

procedure TMainForm.seBevelWidthChange(Sender: TObject);
begin
  JvPanel1.BevelWidth := seBevelWidth.Value;
end;

procedure TMainForm.seBorderLeftChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.BorderLeft := seBorderLeft.Value;
end;

procedure TMainForm.seBorderTopChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.BorderTop := seBorderTop.Value;
end;

procedure TMainForm.seBorderWidthChange(Sender: TObject);
begin
  JvPanel1.BorderWidth := seBorderWidth.Value;
end;

procedure TMainForm.seHorDistanceChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.DistanceHorizontal := seHorDistance.Value;
end;

procedure TMainForm.seMaxCtrlsPerLineChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.MaxControlsPerLine := seMaxCtrlsPerLine.Value;
end;

procedure TMainForm.seVertDistanceChange(Sender: TObject);
begin
  JvPanel1.ArrangeSettings.DistanceVertical := seVertDistance.Value;
end;

end.

