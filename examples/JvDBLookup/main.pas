unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  DBGrids, JvDBLookup, ExtCtrls, DBCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Cities: TBufDataset;
    DBEdit1: TDBEdit;
    DBGrid1: TDBGrid;
    DSCities: TDataSource;
    DSSomeData: TDataSource;
    ImageList1: TImageList;
    JvDBLookupCombo1: TJvDBLookupCombo;
    JvDBLookupList1: TJvDBLookupList;
    Panel1: TPanel;
    SomeData: TBufDataset;
    Splitter1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure JvDBLookupList1GetImageIndex(Sender: TObject; IsEmpty: Boolean;
      var ImageIndex: Integer; var TextMargin: Integer);
  private

  public
    Image: TImage;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  ICON_DE = 0;
  ICON_UK = 1;
  ICON_ES = 2;
  ICON_FR = 3;
  ICON_IT = 4;

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  SomeData.CreateDataset;
  SomeData.Open;
  Cities.CreateDataset;
  Cities.Open;
  Cities.AppendRecord([ 1, 'Paris',      'France',         ICON_FR]);
  Cities.AppendRecord([ 2, 'Marseilles', 'France',         ICON_FR]);
  Cities.AppendRecord([ 3, 'London',     'United Kingdom', ICON_UK]);
  Cities.AppendRecord([ 4, 'Oxford',     'United Kingdom', ICON_UK]);
  Cities.AppendRecord([ 5, 'Lyon',       'France',         ICON_FR]);
  Cities.AppendRecord([ 6, 'Berlin',     'Germany',        ICON_DE]);
  Cities.AppendRecord([ 7, 'Hamburg',    'Germany',        ICON_DE]);
  Cities.AppendRecord([ 8, 'Munich',     'Germany',        ICON_DE]);
  Cities.AppendRecord([ 9, 'Frankfurt',  'Germany',        ICON_DE]);
  Cities.AppendRecord([10, 'Rome',       'Italy',          ICON_IT]);
  Cities.AppendRecord([11, 'Venice',     'Italy',          ICON_IT]);
  Cities.AppendRecord([12, 'Madrid',     'Spain',          ICON_ES]);
  Cities.AppendRecord([13, 'Barcelona',  'Spain',          ICON_ES]);
  Cities.FieldByName('NAME').DisplayWidth := 10;
  Cities.FieldByName('COUNTRY').DisplayWidth := 10;
  SomeData.Append;
end;

procedure TForm1.JvDBLookupList1GetImageIndex(Sender: TObject;
  IsEmpty: Boolean; var ImageIndex: Integer; var TextMargin: Integer);
begin
  if IsEmpty then
    ImageIndex := 5
  else
    ImageIndex := Cities.FieldByName('FLAG').AsInteger;
  TextMargin := ImageList1.Width + 2;
end;

end.

