unit JvImageTransformForm;

{ The images of this demo are taken from the Lazarus mushroom database example
  in folder (lazarus)/examples/database/image_mushrooms
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  JvImageTransform;

type

  { TMainForm }

  TMainForm = class(TForm)
    Bevel1: TBevel;
    btnTransform: TButton;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    JvImageTransform1: TJvImageTransform;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnTransformClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCurrImage: Integer;

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.btnTransformClick(Sender: TObject);
var
  pic: TPicture;
begin
  // Execute the transformation
  JvImageTransform1.Transform;

  // Load next image
  FCurrImage := (FCurrImage + 1) mod 3;
  case FCurrImage of
    0: pic := Image1.Picture;
    1: pic := Image2.Picture;
    2: pic := Image3.Picture;
  end;
  if JvImageTransform1.ImageShown = 1 then
    JvImageTransform1.Picture2.Assign(pic)
  else
    JvImageTransform1.Picture1.Assign(pic);
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  JvImageTransform1.TransformType := TJvTransformationKind(ComboBox1.ItemIndex);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  JvImageTransform1.Picture1.Assign(Image1.Picture);
  JvImageTransform1.Picture2.Assign(Image2.Picture);
end;

end.

