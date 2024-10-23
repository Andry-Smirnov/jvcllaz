{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTabBarXPPainter.pas, released on 2007-05-07.

The Initial Developer of the Original Code is Valdir Stiebe Junior <valdir att dype dott com dott br>
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$MODE objfpc}{$H+}

unit JvTabBarXPPainter;


interface

uses
  LCLType, Types, SysUtils, Classes, Graphics, JvTabBar;

type
  TJvTabBarXPPainter = class(TJvTabBarModernPainter)
  private
    FFixedTabSize: Integer;
    procedure SetFixedTabSize(const Value: Integer);
  protected
    procedure DrawBackground(Canvas: TCanvas; TabBar: TJvCustomTabBar; R: TRect); override;
    procedure DrawTab(Canvas: TCanvas; Tab: TJvTabBarItem; R: TRect); override;
    procedure DrawDivider(Canvas: TCanvas; LeftTab: TJvTabBarItem; R: TRect); override;
    procedure DrawMoveDivider(Canvas: TCanvas; Tab: TJvTabBarItem; MoveLeft: Boolean); override;
    function GetDividerWidth(Canvas: TCanvas; LeftTab: TJvTabBarItem): Integer; override;
    function GetTabSize(Canvas: TCanvas; Tab: TJvTabBarItem): TSize; override;
    function GetCloseRect(Canvas: TCanvas; Tab: TJvTabBarItem; R: TRect): TRect; override;
  published
    property FixedTabSize: Integer read FFixedTabSize write SetFixedTabSize;
  end;


implementation

uses
  LCLVersion, Math, Themes, imgList;

{ TJvTabBarXPPainter }

procedure TJvTabBarXPPainter.DrawBackground(Canvas: TCanvas;
  TabBar: TJvCustomTabBar; R: TRect);
var
  Details: TThemedElementDetails;
begin
  if ThemeServices.ThemesEnabled then
  begin
    Details := ThemeServices.GetElementDetails(ttTabRoot);
    ThemeServices.DrawElement(Canvas.Handle, Details, R);
  end
  else
    inherited DrawBackground(Canvas, TabBar, R);
end;

procedure TJvTabBarXPPainter.DrawDivider(Canvas: TCanvas; LeftTab: TJvTabBarItem; R: TRect);
begin
  if not ThemeServices.ThemesEnabled then
    inherited DrawDivider(Canvas, LeftTab, R);
end;

procedure TJvTabBarXPPainter.DrawMoveDivider(Canvas: TCanvas; Tab: TJvTabBarItem;
  MoveLeft: Boolean);
begin
  if not ThemeServices.ThemesEnabled then
    inherited DrawMoveDivider(Canvas, Tab, MoveLeft);
end;

procedure TJvTabBarXPPainter.DrawTab(Canvas: TCanvas; Tab: TJvTabBarItem;
  R: TRect);
var
  tabBar: TJvCustomTabBar;
  tabDetails, buttonDetails: TThemedElementDetails;
  CloseRect, TextRect: TRect;
  imgsize: TSize;
  x, y: Integer;
  {$IF LCL_FullVersion >= 1090000}
   imageRes: TScaledImageListResolution;
   f: Double;
   ppi: Integer;
  {$IFEND}
begin
  tabBar := GetTabBar(Tab);

  if ThemeServices.ThemesEnabled then
  begin
    if Tab.Selected then
    begin
      buttonDetails := ThemeServices.GetElementDetails(twSmallCloseButtonNormal);
      tabDetails := ThemeServices.GetElementDetails(ttTabItemSelected);
    end
    else if Tab.Hot then
    begin
      buttonDetails := ThemeServices.GetElementDetails(twSmallCloseButtonHot);
      tabDetails := ThemeServices.GetElementDetails(ttTabItemHot);
    end
    else
    begin
      buttonDetails := ThemeServices.GetElementDetails(twSmallCloseButtonNormal);
      tabDetails := ThemeServices.GetElementDetails(ttTabItemNormal);
    end;

    if Tab.Closing then
      buttonDetails := ThemeServices.GetElementDetails(twSmallCloseButtonPushed);
    ThemeServices.DrawElement(Canvas.Handle, tabDetails, R);

    if (Tab.ImageIndex <> -1) and (Tab.GetImages <> nil) then
    begin
      imgSize := GetRealImageSize(Tab);
      x := R.Left + Scale(tabBar, 4);
      y := (R.Top + R.Bottom - imgSize.CY) div 2;
      {$IF LCL_FullVersion >= 1090000}
      f := tabBar.GetCanvasScaleFactor;
      ppi := GetPixelsPerInch;
      imageRes := Tab.GetImages.ResolutionForPPI[tabBar.ImagesWidth, ppi, f];
      imageRes.Draw(Canvas, x, y, Tab.ImageIndex, Tab.Enabled);
    {$ELSE}
      Tab.GetImages.Draw(Canvas, x, y, Tab.ImageIndex, Tab.Enabled);
    {$IFEND}
      Inc(R.Left, imgSize.CX + Scale(tabBar, 2));
    end;

    TextRect := R;
    TextRect.Left := TextRect.Left + Scale(tabBar, 4); //Tab.TabBar.Margin;
    if Tab.TabBar.CloseButton then
    begin
      CloseRect := GetCloseRect(Canvas, Tab, R);
      TextRect.Right := CloseRect.Left - Scale(tabBar, 3);
    end
    else
      Dec(TextRect.Right, Scale(tabBar, 3));
    Canvas.Brush.Style := bsClear;
    ThemeServices.DrawText(Canvas.Handle, TabDetails, Tab.Caption, TextRect, DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS, 0);

    if Tab.TabBar.CloseButton then
      ThemeServices.DrawElement(Canvas.Handle, ButtonDetails, CloseRect);
  end
  else
    inherited DrawTab(Canvas, Tab, R);
end;

function TJvTabBarXPPainter.GetCloseRect(Canvas: TCanvas; Tab: TJvTabBarItem;
  R: TRect): TRect;
var
  tabBar: TJvCustomTabBar;
  p15: Integer;
begin
  if ThemeServices.ThemesEnabled then
  begin
    tabBar := GetTabBar(Tab);
    p15 := Scale(tabBar, 15);
//    Result.Top := R.Top + R.Bottom div 2 - Scale(tabBar, 8);
    Result.Top := (R.Top + R.Bottom - p15) div 2;
    Result.Bottom := Result.Top + p15;
    Result.Right := R.Right - Scale(tabBar, 5);
    Result.Left := Result.Right - p15;
  end
  else
    Result := inherited GetCloseRect(Canvas, Tab, R);
end;

function TJvTabBarXPPainter.GetDividerWidth(Canvas: TCanvas; LeftTab: TJvTabBarItem): Integer;
begin
  if ThemeServices.ThemesEnabled then
    Result := 1
  else
    Result := inherited GetDividerWidth(Canvas, LeftTab);
end;

function TJvTabBarXPPainter.GetTabSize(Canvas: TCanvas; Tab: TJvTabBarItem): TSize;
var
  tabBar: TJvCustomTabBar;
begin
  tabBar := GetTabBar(Tab);
  if FixedTabSize > 0 then
  begin
    if ThemeServices.ThemesEnabled then
      Result.cx := FixedTabSize
    else
      Result.cx := Min(FixedTabSize + Scale(tabBar, 40), Canvas.TextWidth(Tab.Caption) + Scale(tabBar, 26));
  end
  else
  begin
    if ThemeServices.ThemesEnabled then
    begin
      Result.cx := Canvas.TextWidth(Tab.Caption) + Scale(tabBar, 16);
      if (Tab.ImageIndex <> -1) and (Tab.GetImages <> nil) then
        Inc(Result.cx, GetRealImageSize(Tab).CX + Scale(tabBar, 2));
      if Tab.TabBar.CloseButton then
        Inc(Result.cx, Scale(tabBar, 18));
    end
    else
      Result := inherited GetTabSize(Canvas, Tab);
  end;
  Result.cy := Tab.TabBar.Height - Scale(tabBar, 3);
end;

procedure TJvTabBarXPPainter.SetFixedTabSize(const Value: Integer);
begin
  if Value <> FixedTabSize then
  begin
    FFixedTabSize := Value;
    Changed;
  end;
end;

end.
