unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, JvHtControls, JvHint, JvDBHTLabel,
  memds, db;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ButtonPanel1: TButtonPanel;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    JvDBHTLabel1: TJvDBHTLabel;
    JvHTComboBox1: TJvHTComboBox;
    JvHTLabel1: TJvHTLabel;
    JvHTListBox1: TJvHTListBox;
    MemDataset1: TMemDataset;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    PageControl1: TPageControl;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JvDBHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
    procedure JvHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
    procedure JvHTListBox1HyperLinkClick(Sender: TObject; LinkName: string);
    procedure Memo1Change(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Memo1Change(Sender: TObject);
begin
  JvHTLabel1.Caption := Memo1.Text;
  JvHTLabel1.Hint := Memo1.Text;
end;

procedure TMainForm.Memo3Change(Sender: TObject);
begin
  JvDBHTLabel1.Mask := Memo3.Text;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  RegisterHtHints;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MemDataset1.AppendRecord([1, 'asdfxc', 'wertfx']);
  MemDataset1.AppendRecord([2, 'brdrgrsdgx', 'sdfwetrcx']);
  MemDataset1.AppendRecord([3, 'bhtesdxcv', 'wytsfsv']);
  MemDataset1.AppendRecord([4, 'sdgrdthc', 'klvbsdfwe85']);
  MemDataset1.AppendRecord([5, 'trcbxg', 'her4fekg']);
end;

procedure TMainForm.JvDBHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
begin
  MessageDlg('TJvDBHTLabel', 'Hyperlink: ' + LinkName, mtInformation, [mbOK], 0);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  JvHTListBox1.Items.Add(Memo2.Text);
  JvHTComboBox1.Items.Add(Memo2.Text);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  JvHTComboBox1.Items.Clear;
  JvHTListBox1.Items.Clear;
end;

procedure TMainForm.JvHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
begin
  MessageDlg('TJvHTLabel', 'Hyperlink: ' + LinkName, mtInformation, [mbOK], 0);
end;

procedure TMainForm.JvHTListBox1HyperLinkClick(Sender: TObject; LinkName: string);
begin
  MessageDlg('JvHTListBox', 'Hyperlink: ' + LinkName, mtInformation, [mbOK], 0);
end;

end.


// Text on tab 3:
//Numeric field: <b><field="Num"></b><br>Field 1: <b><font color="clRed"><field="fld1"></font></b><br><i>Field 2:</i> <b><font color="clGreen"><field="fld2"></font></b><br>And some link: <a href="url"><field="Fld1"></a><br><a href="qwe">#<field="num"></a> - <b><field="fld1"> <field="fld2"></b>
