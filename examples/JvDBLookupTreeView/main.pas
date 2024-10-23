unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, DB, DBGrids, DBCtrls,
  JvDBLookupTreeView;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    JvDBLookupTreeView1: TJvDBLookupTreeView;
    Persons: TBufDataset;
    Relationships: TBufDataset;
    DSPersons: TDataSource;
    DSRelationships: TDataSource;
    procedure DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private

  public
    Image: TImage;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

{ Assignment of table fields to lookup tree

   Table "Persons" --> Master table
   Table "Relationships" --> Lookup table

   Establish the tree for lookup table:
      DSRelationships      --> LookupTreeView.ListSource
      Field "RelID"        --> LookuptreeView.MasterField
      Field "RelParentID"  --> LookupTreeView.DetailField
      Field "RelName"      --> LookupTreeView.ListField         // Node text

  Establish lookup connection:
      DSPersons           --> LookupTreeView.Datasource
      Field "ID"          --> LookupTreeView.DataField
      Field "RelID"       --> LookupTreeView.KeyField
}
procedure TForm1.FormShow(Sender: TObject);
begin
  Relationships.CreateDataset;
  Relationships.Open;
  Relationships.AppendRecord([ 1, 'Grandparents',    0]);
  Relationships.AppendRecord([10, 'Parents',         1]);
  Relationships.AppendRecord([11, 'Uncle',           1]);
  Relationships.AppendRecord([12, 'Aunt',            1]);
  Relationships.AppendRecord([20, 'Protagonist',    10]);
  Relationships.AppendRecord([21, 'Brother',        10]);
  Relationships.AppendRecord([22, 'Sister',         10]);
  Relationships.AppendRecord([23, 'Brother-in-law', 21]);
  Relationships.AppendRecord([24, 'Brother-in-law', 22]);
  Relationships.AppendRecord([25, 'Sister-in-law',  21]);
  Relationships.AppendRecord([26, 'Sister-in-law',  22]);
  Relationships.AppendRecord([30, 'Son',            20]);
  Relationships.AppendRecord([31, 'Daughter',       20]);
  Relationships.AppendRecord([90, 'Friend',          0]);
  Relationships.AppendRecord([91, 'Neighbor',        0]);

  // data from: https://en.wikipedia.org/wiki/The_Grapes_of_Wrath
  Persons.CreateDataset;
  Persons.Open;
  Persons.AppendRecord([20, 'Tom Joad']);         // Protagonist
  Persons.AppendRecord([11, 'Uncle John Joad']);
  Persons.Appendrecord([10, 'Ma Joad']);          // name not mentioned
  Persons.AppendRecord([10, 'Tom Joad']);         // Pa Joad
  Persons.AppendRecord([21, 'Al Joad']);
  Persons.AppendRecord([21, 'Noah Joad']);
  Persons.AppendRecord([22, 'Ruthie Joad']);
  Persons.AppendRecord([22, 'Winfield Joad']);
  Persons.AppendRecord([22, 'Rose of Sharon Joad Rivers']);
  Persons.AppendRecord([ 1, 'William James Joad']);
  Persons.AppendRecord([ 1, 'Granma Joad']);      // name not mentioned
  Persons.AppendRecord([90, 'Jim Casy']);
  Persons.AppendRecord([91, 'Muley Graves']);
  Persons.AppendRecord([24, 'Connie Rivers']);
  Persons.IndexFieldNames := 'Name';
  Persons.First;
end;

procedure TForm1.DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  if Persons.FieldByName('ID').AsInteger = 20 then    // Protagonist
    DBGrid1.Canvas.Font.Style := [fsBold];
end;

end.

