unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, db, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, StdCtrls, ExtCtrls, ComCtrls,
  JvDBTreeView;

type

  { TMainForm }

  TMainForm = class(TForm)
    Bevel1: TBevel;
    BufDataset1: TBufDataset;
    btnExpandAll: TButton;
    btnCollapseAll: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ImageList1: TImageList;
    JvDBTreeView1: TJvDBTreeView;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    procedure btnEditClick(Sender: TObject);
    procedure btnExpandAllClick(Sender: TObject);
    procedure btnCollapseAllClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvDBTreeView1CustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure JvDBTreeView1Edited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure JvDBTreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  RecordEditorFrm;

const
  ICON_MALE = 0;
  ICON_FEMALE = 1;
  ICON_DE = 2;
  ICON_UK = 3;
  ICON_ES = 4;
  ICON_FR = 5;
  ICON_IT = 6;
  ICON_LANDSCAPE = 7;
  ICON_CITY = 8;
  ICON_PEOPLE = 9;

function UniqueID(ADataset: TDataset; IDFieldName: String): Integer;
begin
  repeat
    Result := Random(MaxInt);
  until not ADataset.Locate(IDFieldName, Result, []);
end;


{ TMainForm }

procedure TMainForm.btnAddClick(Sender: TObject);
var
  F: TRecordEditor;
  newid: Integer;
  parentid: Integer;
  dataset: TDataset;
begin
  dataset := JvDBTreeView1.Datasource.Dataset;

  F := TRecordEditor.Create(nil);
  try
    F.Caption := 'New record';
    F.Position := poMainFormCenter;
    if F.ShowModal = mrOK then
    begin
      // Determine unique key field value
      newID := UniqueID(dataset, JvDBTreeView1.MasterField);

      // Determine parent id of new record
      case F.rgParent.ItemIndex of
        0: parentID := dataset.FieldByName(JvDBTreeView1.MasterField).AsInteger;  // new node is child
        1: parentID := dataset.FieldByName(JvDBTreeView1.DetailField).AsInteger;  // new node is sibling
      end;

      with dataset do
      begin
        Insert;
        FieldByName(JvDBTreeView1.MasterField).AsInteger := newID;
        FieldByName(JvDBTreeView1.DetailField).AsInteger := parentID;
        FieldByName(JvDBTreeView1.ItemField).AsString := F.edName.Text;
        FieldByName(JvDBTreeView1.IconField).AsInteger := F.ImageIndex;
        Post;
      end;
    end;
  finally
    F.Free;
  end;
end;

procedure TMainForm.btnCollapseAllClick(Sender: TObject);
begin
  JvDBTreeView1.FullCollapse;
end;

procedure TMainForm.btnDeleteClick(Sender: TObject);
begin
  if JvDBTreeView1.Selected.HasChildren then
  begin
    MessageDlg('It is not allowed to delete a node with children.', mtError, [mbOK], 0);
    exit;
  end;
  if MessageDlg('Do you really want to delete the current record?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    JvDBTreeView1.Datasource.Dataset.Delete;
end;

procedure TMainForm.btnExpandAllClick(Sender: TObject);
begin
  JvDBTreeView1.FullExpand;
end;

procedure TMainForm.btnEditClick(Sender: TObject);
var
  F: TRecordEditor;
  dataset: TDataset;
begin
  dataset := JvDBTreeView1.Datasource.Dataset;

  F := TRecordEditor.Create(nil);
  try
    F.Caption := 'Edit record';
    F.Position := poMainFormCenter;
    F.edName.Text := dataset.FieldByName(JvDBTreeView1.ItemField).AsString;
    F.ImageIndex := dataset.FieldByName(JvDBTreeView1.IconField).AsInteger;
    F.rgParent.Hide;
    if F.ShowModal = mrOK then
    begin
      with dataset do
      begin
        Edit;
        FieldByName(JvDBTreeView1.ItemField).AsString := F.edName.Text;
        FieldByName(JvDBTreeView1.IconField).AsInteger := F.ImageIndex;
        Post;
      end;
    end;
  finally
    F.Free;
  end;
end;

{ Assignment of table fields to tree

   Table                 Tree
   ID         -->    Tree.MasterField
   ParentID   -->    Tree.DetailField
   Name       -->    Tree.itemField
   Icon       -->    Tree.IconField
}
procedure TMainForm.FormCreate(Sender: TObject);

  procedure AddRecord(ID, ParentID: Integer; AName: String; AIcon: Integer = -1);
  begin
    //with Dbf1 do begin
    with BufDataset1 do begin
      Insert;
      Fields[0].AsInteger := ID;
      Fields[1].AsInteger := ParentID;
      Fields[2].AsString := AName;
      Fields[3].AsInteger := AIcon;
      Post;
    end;
  end;

begin
  BufDataset1.Filename := Application.Location + 'JvDBGridDemoData.dat';

  if not FileExists(BufDataset1.FileName) then begin
    if BufDataset1.FieldDefs.IndexOf('ID') = -1 then;
      BufDataset1.FieldDefs.Add('ID', ftInteger);
    if BufDataset1.FieldDefs.IndexOf('ParentID') = -1 then
      BufDataset1.FieldDefs.Add('ParentID', ftInteger);
    if BufDataset1.FieldDefs.IndexOf('Name') = -1 then
      BufDataset1.FieldDefs.Add('Name', ftString, 20);
    if BufDataset1.FieldDefs.IndexOf('Icon') = -1 then
      BufDataset1.FieldDefs.Add('Icon', ftInteger);
    BufDataset1.CreateDataset;

    BufDataset1.Open;

    AddRecord( 1, 0, 'Politicians', ICON_PEOPLE);
    AddRecord( 2, 0, 'Cities', ICON_CITY);
    AddRecord( 3, 0, 'Rivers', ICON_LANDSCAPE);
    AddRecord( 4, 1, 'France', ICON_FR);
    AddRecord( 5, 1, 'Germany', ICON_DE);
    AddRecord( 6, 1, 'Great Britain', ICON_UK);
    AddRecord( 7, 1, 'Italy', ICON_IT);
    AddRecord( 8, 4, 'Charles de Gaulles', ICON_MALE);
    AddRecord( 9, 4, 'Emmanuel Macron', ICON_MALE);
    AddRecord(10, 4, 'François Mitterrand', ICON_MALE);
    AddRecord(11, 5, 'Angela Merkel', ICON_FEMALE);
    AddRecord(12, 6, 'Tony Blair', ICON_MALE);
    AddRecord(13, 6, 'Theresa May', ICON_FEMALE);
    AddRecord(14, 5, 'Konrad Adenauer', ICON_MALE);
    AddRecord(15, 5, 'Willy Brandt', ICON_MALE);
    AddRecord(16, 7, 'Matteo Renzi', ICON_MALE);
    AddRecord(20, 3, 'France');
    AddRecord(21, 20, 'Seine');
    AddRecord(22, 20, 'Rhône');
    AddRecord(23, 3, 'England');
    AddRecord(24, 23, 'Thames');
//    AddRecord(25, 2, 'France');
    AddRecord(26, 2, 'Paris', ICON_FR);
    AddRecord(27, 2, 'Marseilles', ICON_FR);
    AddRecord(29, 2, 'London', ICON_UK);
    AddRecord(30, 2, 'Oxford', ICON_UK);
    AddRecord(31, 2, 'Lyon', ICON_FR);
    AddRecord(33, 2, 'Berlin', ICON_DE);
    AddRecord(34, 2, 'Hamburg', ICON_DE);
    AddRecord(35, 2, 'Munich', ICON_DE);
    AddRecord(36, 2, 'Frankfurt', ICON_DE);
    AddRecord(38, 2, 'Rome', ICON_IT);
    AddRecord(39, 2, 'Venice', ICON_IT);
    AddRecord(40, 2, 'Madrid', ICON_ES);
    AddRecord(41, 2, 'Barcelona', ICON_ES);

    BufDataset1.SaveToFile;
    BufDataset1.Close;
  end;

  BufDataset1.Open;
  BufDataset1.IndexFieldNames := 'ParentID;Name';
end;

procedure TMainForm.JvDBTreeView1CustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Level = 0 then
    Sender.Canvas.Font.Style := [fsBold]
  else
    Sender.Canvas.Font.Style := [];
end;

procedure TMainForm.JvDBTreeView1Edited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  with JvDBTreeView1.Datasource.Dataset do
  begin
    Edit;
    FieldByName(JvDBTreeView1.ItemField).AsString := S;
    Post;
  end;
end;

procedure TMainForm.JvDBTreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode
  );
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

end.


