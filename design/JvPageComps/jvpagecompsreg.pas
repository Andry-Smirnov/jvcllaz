unit JvPageCompsReg; 

{$mode objfpc}{$H+}

interface

uses
  Classes, LResources, SysUtils;

procedure Register;

implementation

{$R ..\..\resource\jvpagecompsreg.res}

uses
  ImgList,
  PropEdits, ComponentEditors, TreeViewPropEdit,
  JvDsgnConsts, JvPageList,
  JvNavigationPane, JvNavPaneEditors,
  JvTabBar, JvTabBarXPPainter,
  JvNotebookPageList,
  JvPageListEditors, JvPageLinkEditorForm,
  JvPageListTreeView;

procedure Register;
const
  cImageIndex = 'ImageIndex';
  cActivePage = 'ActivePage';
begin
  // JvNavigationPanel
  RegisterComponents(RsPaletteJvclVisual, [  // was: RsPaletteNavPane
    TJvNavigationPane,
    TJvNavIconButton,
    TJvNavPanelButton, TJvNavPanelHeader, TJvNavPanelDivider,
    TJvTabBar, TJvModernTabBarPainter, TJvTabBarXPPainter,
    TJvOutlookSplitter,
    TJvNavPaneStyleManager, TJvNavPaneToolPanel
  ]);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelPage, cImageIndex,
    TJvNavPanePageImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelHeader, cImageIndex,
    TJvNavPanelHeaderImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelButton, cImageIndex,
    TJvNavPanelButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavIconButton, cImageIndex,
    TJvNavIconButtonImageIndexProperty);

  // JvPageList
  RegisterComponents(RsPaletteJvclVisual, [        // was: RsPaletteListComboTree
    TJvNotebookPageList,
    TJvPageList]);

  RegisterClasses([TJvPageList, TJvStandardPage]);
  RegisterNoIcon([TJvStandardPage]);
  RegisterComponentEditor(TJvCustomPageList, TJvCustomPageEditor);  // was: TJvCustomPageEditor
  RegisterComponentEditor(TJvCustomPage, TJvCustomPageEditor);
  RegisterPropertyEditor(TypeInfo(TJvShowDesignCaption), nil, '',
    TJvShowDesignCaptionProperty);

  RegisterPropertyEditor(TypeInfo(TJvCustomPage),
    TJvCustomPageList, cActivePage, TJvActivePageProperty);

  // JvPageTree
  RegisterComponents(RsPaletteJvclVisual, [  // was: TsPaletteListComboTree
    TJvPageListTreeView,
    TJvSettingsTreeView
  ]);
  RegisterClasses([TJvSettingsTreeView, TJvPageListTreeView]);
  RegisterComponentEditor(TJvCustomPageListTreeView, TTreeViewComponentEditor);

  RegisterPropertyEditor(TypeInfo(TJvPageLinks),
    TJvCustomPageListTreeView, '', TJvPageLinksProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvSettingsTreeImages, '',
    TJvSettingsTreeImagesProperty);

end;

end.

