unit HTMLTestForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, SynEdit, SynHighlighterHTML, JvStringListToHtml, JvStrToHtml,
  JvFormToHtml;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    cbIncludeHeader: TCheckBox;
    edHTMLTitle: TEdit;
    edTextOut: TEdit;
    edTextIn: TEdit;
    edHTML: TEdit;
    JvFormToHtml1: TJvFormToHtml;
    JvStringListToHtml1: TJvStringListToHtml;
    lblHTMLTitle: TLabel;
    lblTextIn: TLabel;
    lblTextAsHTML: TLabel;
    lblTextOut: TLabel;
    Memo: TMemo;
    PageControl: TPageControl;
    Splitter1: TSplitter;
    FormSynEdit: TSynEdit;
    StringsSynEdit: TSynEdit;
    SynHTMLSyn: TSynHTMLSyn;
    pgFormToHTML: TTabSheet;
    pgStringToHTML: TTabSheet;
    pgStringsToHTML: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure cbIncludeHeaderChange(Sender: TObject);
    procedure edHTMLTitleChange(Sender: TObject);
    procedure edTextInChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DemoForm;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
var
  F: TForm2;
begin
  F := TForm2.Create(nil);
  try
    JvFormToHtml1.FormToHtml(F, FormSynEdit.Lines);
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TMainForm.cbIncludeHeaderChange(Sender: TObject);
begin
  JvStringListToHTML1.IncludeHeader := cbIncludeHeader.Checked;
  MemoChange(nil);
end;

procedure TMainForm.edHTMLTitleChange(Sender: TObject);
begin
  JvStringListToHTML1.HTMLTitle := edHTMLTitle.Text;
  MemoChange(nil);
end;

procedure TMainForm.edTextInChange(Sender: TObject);
begin
  edHTML.Text := StringToHTML(edTextIn.Text);
  edTextOut.Text := HTMLToString(edHTML.Text);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  edTextInChange(nil);
  MemoChange(nil);
end;

procedure TMainForm.MemoChange(Sender: TObject);
begin
  StringsSynEdit.Lines.Clear;
  JvStringListToHTML1.ConvertToHTMLStrings(Memo.Lines, StringsSynEdit.Lines);
end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  MemoChange(nil);
end;

end.

