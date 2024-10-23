unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, JvPicClip;

type

  { TForm1 }

  TForm1 = class(TForm)
    CombinedImage: TImage;
    Label1: TLabel;
    SplitImage: TImage;
    JvPicClip1: TJvPicClip;
    Trackbar: TTrackBar;
    procedure CombinedImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure TrackbarChange(Sender: TObject);
  private
    procedure CreateCombinedImage(ABitmap: TBitmap;
      out ANumCols, ANumRows: Integer);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
  nCols, nRows: Integer;
begin
  bmp := TBitmap.Create;
  try
    CreateCombinedImage(bmp, nCols, nRows);

    // Image for combined bitmap
    CombinedImage.Width := bmp.Width;
    CombinedImage.Height := bmp.Height;
    CombinedImage.Picture.Assign(bmp);

    // Image for separated bitmaps
    SplitImage.Width := bmp.Width div nCols;
    SplitImage.Height := bmp.Height div nRows;

    JvPicClip1.Picture := CombinedImage.Picture;
    JvPicClip1.Cols := nCols;
    JvPicClip1.Rows := nRows;

    Trackbar.Min := 0;
    Trackbar.Max := nCols * nRows - 1;
    Trackbar.Position := 0;

    TrackbarChange(nil);
  finally
    bmp.Free;
  end;
end;

procedure TForm1.CombinedImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r, c: Integer;
begin
  c := X div SplitImage.Width;
  r := Y div SplitImage.Height;
  Trackbar.Position := JvPicClip1.GetIndex(c, r);
end;

procedure TForm1.TrackbarChange(Sender: TObject);
begin
  SplitImage.Picture.Assign(JvPicClip1.GraphicCell[Trackbar.Position]);
  Label1.Caption := 'Index ' + IntToStr(Trackbar.Position);
end;

procedure TForm1.CreateCombinedImage(ABitmap: TBitmap;
  out ANumCols, ANumRows: Integer);
const
  FOLDER = '../../design/';
var
  pic: TPicture;
  c, r, i: Integer;
  L: TStrings;
  W, H: Integer;
begin
  L := TStringList.Create;
  try
    L.Add(FOLDER + 'JvMM/images/tjvbmpanimator.png');                  //0
    L.Add(FOLDER + 'JvMM/images/tjvfullcoloraxiscombo.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorcircle.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorcircledialog.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorgroup.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorlabel.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorpanel.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolorspacecombo.png');
    L.Add(FOLDER + 'JvMM/images/tjvfullcolortrackbar.png');
    L.Add(FOLDER + 'JvMM/images/tjvgradient.png');
    L.Add(FOLDER + 'JvMM/images/tjvgradientheaderpanel.png');   // 10
    L.Add(FOLDER + 'JvMM/images/tjvid3v2.png');
    L.Add(FOLDER + 'JvMM/images/tjvpicclip.png');
    L.Add(FOLDER + 'JvMM/images/tjvspecialprogress.png');
    L.Add(FOLDER + 'JvHMI/images/tjvdialbutton.bmp');
    L.Add(FOLDER + 'JvHMI/images/tjvled.bmp');
    L.Add(FOLDER + 'JvDB/images/tjvdbcalcedit.bmp');
    L.Add(FOLDER + 'JvDB/images/tjvdbhtlabel.bmp');
    L.Add(FOLDER + 'JvDB/images/tjvdbsearchcombobox.bmp');
    L.Add(FOLDER + 'JvDB/images/tjvdbsearchedit.bmp');
    L.Add(FOLDER + 'JvDB/images/tjvdbtreeview.bmp');  // 20
    L.Add(FOLDER + 'JvPageComps/images/tjvtabbar.bmp');
    L.Add(FOLDER + 'JvPageComps/images/tjvmoderntabbarpainter.bmp');
    L.Add(FOLDER + 'JvCustomControls/images/tjvownerdrawviewer.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvimagelistviewer.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvimagesviewer.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvoutlookbar.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvthumbimage.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvthumbnail.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvthumbview.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvtimeline.png');   // 30
    L.Add(FOLDER + 'JvCustomControls/images/tjvtmtimeline.png');
    L.Add(FOLDER + 'JvCustomControls/images/tjvvalidateedit.png');    // 32
    ANumCols := 8;
    ANumRows := 4;

    pic := TPicture.Create;
    try
      pic.LoadFromFile(L[0]);
      W := pic.Width;
      H := pic.Height;
    finally
      pic.Free;
    end;

    ABitmap.SetSize(ANumCols * W, ANumRows * H);
    ABitmap.Canvas.Brush.Color := clWhite;
    Abitmap.Canvas.FillRect(0, 0, ABitmap.Width, ABitmap.Height);
    c := 0;
    r := 0;
    pic := TPicture.Create;
    try
      for i:=0 to L.Count-1 do begin
        pic.LoadFromFile(L[i]);
        ABitmap.Canvas.Draw(c * W, r * H, pic.Bitmap);
        inc(c);
        if c = ANumCols then begin
          c := 0;
          inc(r);
        end;
      end;
    finally
      pic.Free;
    end;
  finally
    L.Free;
  end;
end;

end.

