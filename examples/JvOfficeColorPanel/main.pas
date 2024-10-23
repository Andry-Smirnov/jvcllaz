unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, JvOfficeColorPanel;

type

  { TForm1 }

  TForm1 = class(TForm)
    cbFlatBorder: TCheckBox;
    cbDefaultColorColor: TColorButton;
    cbShowCustomColor: TCheckBox;
    cbShowDefaultColor: TCheckBox;
    cbShowNoneColor: TCheckBox;
    cbShowSystemColors: TCheckBox;
    cbShowUserColor: TCheckBox;
    cbBackColor: TColorButton;
    gbColorView: TGroupBox;
    JvOfficeColorPanel1: TJvOfficeColorPanel;
    Label1: TLabel;
    lblColorSize: TLabel;
    lblColorSpace: TLabel;
    lblColorSpaceBottom1: TLabel;
    lblColorSpaceTop: TLabel;
    lblColorSpaceBottom: TLabel;
    lblTopMargin: TLabel;
    lblBottomMargin: TLabel;
    Panel1: TPanel;
    seColorSize: TSpinEdit;
    seColorSpace: TSpinEdit;
    seHorizontalMargin: TSpinEdit;
    seColorSpaceTop: TSpinEdit;
    seColorSpaceBottom: TSpinEdit;
    seTopMargin: TSpinEdit;
    seBottomMargin: TSpinEdit;
    shColorView: TShape;
    seButtonHeight: TSpinEdit;
    procedure cbFlatBorderChange(Sender: TObject);
    procedure cbDefaultColorColorColorChanged(Sender: TObject);
    procedure cbShowCustomColorChange(Sender: TObject);
    procedure cbShowDefaultColorChange(Sender: TObject);
    procedure cbShowNoneColorChange(Sender: TObject);
    procedure cbShowSystemColorsChange(Sender: TObject);
    procedure cbShowUserColorChange(Sender: TObject);
    procedure cbBackColorColorChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvOfficeColorPanel1ColorChange(Sender: TObject);
    procedure seButtonHeightChange(Sender: TObject);
    procedure seColorSizeChange(Sender: TObject);
    procedure seColorSpaceBottomChange(Sender: TObject);
    procedure seColorSpaceChange(Sender: TObject);
    procedure seColorSpaceTopChange(Sender: TObject);
    procedure seBottomMarginChange(Sender: TObject);
    procedure seHorizontalMarginChange(Sender: TObject);
    procedure seTopMarginChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  LCLIntf, JvJCLUtils;

{$R *.lfm}

{ TForm1 }

procedure TForm1.cbFlatBorderChange(Sender: TObject);
begin
  JvOfficeColorPanel1.FlatBorder := cbFlatBorder.Checked;
end;

procedure TForm1.cbShowCustomColorChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ShowCustomColor := cbShowCustomColor.Checked;
end;

procedure TForm1.cbShowDefaultColorChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ShowDefaultColor := cbShowDefaultColor.Checked;
end;

procedure TForm1.cbShowNoneColorChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ShowNoneColor := cbShowNoneColor.Checked;
end;

procedure TForm1.cbShowSystemColorsChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ShowSystemColors := cbShowSystemColors.Checked;
end;

procedure TForm1.cbShowUserColorChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ShowUserColors := cbShowUserColor.Checked;
end;

procedure TForm1.cbBackColorColorChanged(Sender: TObject);
begin
  JvOfficeColorPanel1.BackColor := cbBackColor.ButtonColor;
end;

procedure TForm1.cbDefaultColorColorColorChanged(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.DefaultColorColor := cbDefaultColorColor.ButtonColor;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  c: TColor;
begin
  JvOfficeColorPanel1.UserColors.BeginUpdate;
  try
    for i:=0 to 15 do begin
      c := RGB(Random(256), Random(256), Random(256));
      JvOfficeColorPanel1.UserColors.Add(Format('$%.6x=($)', [c]));
    end;
  finally
    JvOfficeColorPanel1.UserColors.EndUpdate;
  end;

  cbBackColor.ButtonColor := JvOfficeColorPanel1.BackColor;
  cbDefaultColorColor.ButtonColor := JvOfficeColorPanel1.Properties.DefaultColorColor;
  seButtonHeight.Value := JvOfficeColorPanel1.Properties.ButtonHeight;
  seColorSize.Value := JvOfficeColorPanel1.Properties.ColorSize;
  seColorSpace.Value := JvOfficeColorPanel1.Properties.ColorSpace;
  seColorSpaceTop.Value := JvOfficeColorPanel1.Properties.ColorSpaceTop;
  seColorSpaceBottom.Value := JvOfficeColorPanel1.Properties.ColorSpaceBottom;
  seHorizontalMargin.Value := JvOfficeColorPanel1.Properties.HorizontalMargin;
  seTopMargin.Value := JvOfficeColorPanel1.Properties.TopMargin;
  seBottomMargin.Value := JvOfficeColorPanel1.Properties.BottomMargin;
end;

procedure TForm1.JvOfficeColorPanel1ColorChange(Sender: TObject);
begin
  shColorView.Brush.Color := JvOfficeColorPanel1.SelectedColor;
  if JvOfficeColorPanel1.SelectedColor = clNone then
    shColorView.Brush.Style := bsClear
  else
    shColorView.Brush.Style := bsSolid;
  gbColorView.Caption := 'Selected: ' + ColorToPrettyName(JvOfficeColorPanel1.SelectedColor);
end;

procedure TForm1.seButtonHeightChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ButtonHeight := seButtonHeight.Value;
end;

procedure TForm1.seColorSizeChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ColorSize := seColorSize.Value;
end;

procedure TForm1.seColorSpaceBottomChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ColorSpaceBottom := seColorSpaceBottom.Value;
end;

procedure TForm1.seColorSpaceChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ColorSpace := seColorSpace.Value;
end;

procedure TForm1.seColorSpaceTopChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.ColorSpaceTop := seColorSpaceTop.Value;
end;

procedure TForm1.seHorizontalMarginChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.HorizontalMargin := seHorizontalMargin.Value;
end;

procedure TForm1.seBottomMarginChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.BottomMargin := seBottomMargin.Value;
end;

procedure TForm1.seTopMarginChange(Sender: TObject);
begin
  JvOfficeColorPanel1.Properties.TopMargin := seTopMargin.Value;
end;

end.

