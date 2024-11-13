{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvRgbToHtml.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sйbastien Buysse [sbuysse att buypin dott com]
Portions created by Sйbastien Buysse are Copyright (C) 2001 Sйbastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvRgbToHtml;

interface

uses
  LCLIntf, SysUtils, Classes, Graphics;

type
  TJvRGBToHTML = class(TComponent)
  private
    FHTMLColor: string;
    FRGBColor: TColor;
    procedure SetRGBColor(const Value: TColor);
    procedure SetHTMLColor(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RGBColor: TColor read FRGBColor write SetRGBColor default clBlack;
    property HTMLColor: string read FHTMLColor write SetHTMLColor;
  end;

function RgbToHtml(Value: TColor): string;
function HtmlToRgb(const Value: string): TColor;

implementation

function RgbToHtml(Value: TColor): string;
begin
  with TJvRGBToHTML.Create(nil) do
    try
      RGBColor := Value;
      Result := HTMLColor;
    finally
      Free;
    end;
end;

function HtmlToRgb(const Value: string): TColor;
begin
  with TJvRGBToHTML.Create(nil) do
    try
      HTMLColor := Value;
      Result := RGBColor;
    finally
      Free;
    end;
end;

constructor TJvRGBToHTML.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RGBColor := clBlack;
end;

procedure TJvRGBToHTML.SetRGBColor(const Value: TColor);
var
  Clr: TColor;
begin
  FRGBColor := Value;
  Clr := ColorToRGB(Value);
  FHTMLColor := IntToHex(GetRValue(Clr), 2) + IntToHex(GetGValue(Clr), 2) + IntToHex(GetBValue(Clr), 2);
end;

procedure TJvRGBToHTML.SetHTMLColor(const Value: string);
var
  C: TColor;
  R, G, B: Byte;
begin
  try
    if Length(Value) = 6 then
    begin
      R := StrToInt('$' + Copy(Value, 1, 2));
      G := StrToInt('$' + Copy(Value, 3, 2));
      B := StrToInt('$' + Copy(Value, 5, 2));
      C := RGB(R, G, B);
      FRGBColor := C;
      FHTMLColor := Value;
    end;
  except
  end;
end;

end.
