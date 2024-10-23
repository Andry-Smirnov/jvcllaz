unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ShellCtrls, ListViewFilterEdit, JvTabBar, JvPageList,
  JvTabBarXPPainter;

type

  { TMainForm }

  TMainForm = class(TForm)
    cbCloseButton: TCheckBox;
    cbAllowTabMoving: TCheckBox;
    cbTabHotTracking: TCheckBox;
    cmbPainter: TComboBox;
    cmbOrientation: TComboBox;
    Image1: TImage;
    ImageList1: TImageList;
    JvModernTabBarPainter1: TJvModernTabBarPainter;
    JvPageList1: TJvPageList;
    JvStandardPage1: TJvStandardPage;
    JvStandardPage2: TJvStandardPage;
    JvStandardPage3: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    JvTabBar1: TJvTabBar;
    JvTabBarXPPainter1: TJvTabBarXPPainter;
    lblPainter: TLabel;
    lblOrientation: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    Splitter1: TSplitter;
    StringGrid1: TStringGrid;
    procedure cbCloseButtonChange(Sender: TObject);
    procedure cbAllowTabMovingChange(Sender: TObject);
    procedure cbTabHotTrackingChange(Sender: TObject);
    procedure cmbPainterChange(Sender: TObject);
    procedure cmbOrientationChange(Sender: TObject);
    procedure JvTabBar1TabCloseQuery(Sender: TObject; Item: TJvTabBarItem;
      var CanClose: Boolean);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.cbCloseButtonChange(Sender: TObject);
begin
  JvTabBar1.CloseButton := cbCloseButton.Checked;
end;

procedure TMainForm.cbTabHotTrackingChange(Sender: TObject);
begin
  JvTabBar1.HotTracking := cbTabHotTracking.Checked;
end;

procedure TMainForm.cbAllowTabMovingChange(Sender: TObject);
begin
  JvTabBar1.AllowTabMoving := cbAllowTabMoving.Checked;
end;

procedure TMainForm.cmbPainterChange(Sender: TObject);
begin
  case cmbPainter.ItemIndex of
    0: JvTabBar1.Painter := JvModernTabBarPainter1;
    1: JvTabBar1.Painter := JvTabBarXPPainter1;
  end;
end;

procedure TMainForm.JvTabBar1TabCloseQuery(Sender: TObject;
  Item: TJvTabBarItem; var CanClose: Boolean);
begin
  CanClose := MessageDlg('Do you really want to close tab ' + Item.Caption + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TMainForm.cmbOrientationChange(Sender: TObject);
begin
  case cmbOrientation.ItemIndex of
    0: begin
         JvTabBar1.Orientation := toTop;
         JvTabBar1.Align := alTop;
       end;
    1: begin
         JvTabBar1.Orientation := toBottom;
         JvTabBar1.Align := alBottom;
       end;
  end;
end;

end.

