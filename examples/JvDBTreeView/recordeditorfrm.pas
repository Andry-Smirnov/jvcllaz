unit RecordEditorFrm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComboEx,
  ExtCtrls, ButtonPanel;

type

  { TRecordEditor }

  TRecordEditor = class(TForm)
    ButtonPanel1: TButtonPanel;
    cmbImageIndex: TComboBoxEx;
    edName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    rgParent: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    function GetImageIndex: Integer;
    procedure SetImageIndex(const AValue: Integer);
    function ValidData(out AControl: TWinControl; out AMsg: String): Boolean;
  public
    property ImageIndex: Integer read GetImageIndex write SetImageIndex;
  end;

var
  RecordEditor: TRecordEditor;

implementation

{$R *.lfm}

{ TRecordEditor }

procedure TRecordEditor.OKButtonClick(Sender: TObject);
var
  C: TWinControl;
  msg: String;
begin
  if not ValidData(C, msg) then
  begin
    C.SetFocus;
    MessageDlg(msg, mtError, [mbOk], 0);
    ModalResult := mrNone;
  end;
end;

procedure TRecordEditor.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  cmbImageIndex.Items.Clear;
  cmbImageIndex.Add('(none)', -1, -1, -1, -1);
  for i := 0 to cmbImageIndex.Images.Count-1 do
    cmbImageIndex.Add(IntToStr(i), 0, i, -1, i);
end;

function TRecordEditor.GetImageIndex: Integer;
begin
  if cmbImageIndex.ItemIndex = -1 then
    Result := -1
  else
    Result := cmbImageIndex.ItemsEx[cmbImageIndex.ItemIndex].ImageIndex;
end;

procedure TRecordEditor.SetImageIndex(const AValue: Integer);
var
  i: Integer;
begin
  for i := 0 to cmbImageIndex.ItemsEx.Count-1 do
    if cmbImageIndex.ItemsEx[i].ImageIndex = AValue then
    begin
      cmbImageIndex.ItemIndex := i;
      exit;
    end;
  cmbImageIndex.ItemIndex := -1;
end;

function TRecordEditor.ValidData(out AControl: TWinControl; out AMsg: String): Boolean;
begin
  Result := false;

  if edName.Text = '' then
  begin
    AMsg := 'Input required.';
    AControl := edName;
    exit;
  end;

  if rgParent.Visible and (rgParent.ItemIndex = -1) then
  begin
    AMsg := 'Relation of new node to current node not specified.';
    AControl := rgParent;
    exit;
  end;

  Result := true;
end;

end.

