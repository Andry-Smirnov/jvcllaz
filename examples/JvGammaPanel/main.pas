unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, JvGammaPanel,
  JvTypes;

type

  { TDemoForm }

  TDemoForm = class(TForm)
    FgColorBtn: TColorButton;
    BgColorBtn: TColorButton;
    JvGammaPanel1: TJvGammaPanel;
    DemoLabel: TLabel;
    procedure BgColorBtnColorChanged(Sender: TObject);
    procedure FgColorBtnColorChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvGammaPanel1ChangeColor(Sender: TObject; FgColor, BgColor: TColor);
  private

  public

  end;

var
  DemoForm: TDemoForm;

implementation

{$R *.lfm}

{ TDemoForm }

procedure TDemoForm.BgColorBtnColorChanged(Sender: TObject);
begin
  JvGammaPanel1.BackgroundColor := BgColorBtn.ButtonColor;
end;

procedure TDemoForm.FgColorBtnColorChanged(Sender: TObject);
begin
  JvGammaPanel1.ForegroundColor := FgColorBtn.ButtonColor;
end;

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  FgColorBtn.ButtonColor := JvGammaPanel1.ForegroundColor;
  BgColorBtn.ButtonColor := JvGammaPanel1.BackgroundColor;

  DemoLabel.Color := JvGammaPanel1.BackgroundColor;
  Demolabel.Font.Color := JvGammaPanel1.ForegroundColor;
end;

procedure TDemoForm.JvGammaPanel1ChangeColor(Sender: TObject; FgColor, BgColor: TColor);
begin
  DemoLabel.Color := BgColor;
  DemoLabel.Font.Color := FgColor;
end;

end.

