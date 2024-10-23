unit JvSpecialImageDemoForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin, JvSpecialImage;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnFadeIn: TButton;
    btnFadeOut: TButton;
    cbFlipped: TCheckBox;
    cbMirrored: TCheckBox;
    cbInverted: TCheckBox;
    JvSpecialImage1: TJvSpecialImage;
    lblFadingSpeed: TLabel;
    lblBrightness: TLabel;
    Panel1: TPanel;
    rbFadeBlack: TRadioButton;
    rbFadeWhite: TRadioButton;
    sbBrightness: TScrollBar;
    seFadingSpeed: TSpinEdit;
    procedure btnFadeInClick(Sender: TObject);
    procedure btnFadeOutClick(Sender: TObject);
    procedure cbFlippedChange(Sender: TObject);
    procedure cbInvertedChange(Sender: TObject);
    procedure cbMirroredChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvSpecialImage1FadingComplete(Sender: TObject);
    procedure rbFadeBlackChange(Sender: TObject);
    procedure rbFadeWhiteChange(Sender: TObject);
    procedure sbBrightnessChange(Sender: TObject);
    procedure seFadingSpeedChange(Sender: TObject);
  private
    FStartTime: TDateTime;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnFadeInClick(Sender: TObject);
begin
  Caption := 'Fading in...';
  (*
  sbBrightness.OnChange := nil;
  sbBrightness.Position := 0;
  lblBrightness.Caption := 'Brightness ' + IntToStr(sbBrightness.Position);
  sbBrightness.OnChange := @sbBrightnessChange;
   *)
  FStartTime := Now;
  JvSpecialImage1.FadeIn;

  btnFadeOut.Enabled := true;
  btnFadeIn.Enabled := false;
  sbBrightness.Enabled := btnFadeOut.Enabled;
end;

procedure TForm1.btnFadeOutClick(Sender: TObject);
begin
  Caption := 'Fading out...';
  FStartTime := Now;
  JvSpecialImage1.FadeOut;

  btnFadeOut.Enabled := false;
  btnFadeIn.Enabled := true;
  sbBrightness.Enabled := btnFadeOut.Enabled;
end;

procedure TForm1.cbFlippedChange(Sender: TObject);
begin
  JvSpecialImage1.Flipped := cbFlipped.Checked;
end;

procedure TForm1.cbInvertedChange(Sender: TObject);
begin
  JvSpecialImage1.Inverted := cbInverted.Checked;
end;

procedure TForm1.cbMirroredChange(Sender: TObject);
begin
  JvSpecialImage1.Mirrored := cbMirrored.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sbBrightness.Position := JvSpecialImage1.Brightness;
end;

procedure TForm1.JvSpecialImage1FadingComplete(Sender: TObject);
begin
  Caption := 'Time for fading: ' + IntToStr(Round((Now - FStartTime)*24*60*60*1000)) + 'ms';
end;

procedure TForm1.rbFadeBlackChange(Sender: TObject);
begin
  if rbFadeBlack.Checked then JvSpecialImage1.FadingEnd := feBlack;
end;

procedure TForm1.rbFadeWhiteChange(Sender: TObject);
begin
  if rbFadeWhite.Checked then JvSpecialImage1.FadingEnd := feWhite;
end;

procedure TForm1.sbBrightnessChange(Sender: TObject);
begin
  JvSpecialImage1.Brightness := sbBrightness.Position;
  lblBrightness.caption := Format('Brightness: %d', [JvSpecialImage1.Brightness]);
end;

procedure TForm1.seFadingSpeedChange(Sender: TObject);
begin
  JvSpecialImage1.FadingSpeed := seFadingSpeed.Value;
end;

end.

