{$I x3dnodes_encoding_xml.inc}
{ Game initialization.
  This unit is cross-platform.
  It will be used by the platform-specific program or library file.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameInitialize;

interface

implementation

uses SysUtils,
  CastleWindow, CastleLog, CastleUIControls, Classes,
  X3DNodes, X3DLoad, CastleScene, CastleViewport, CastleUriUtils,
  CastleCameras
  {$region 'Castle Initialization Uses'}
  // The content here may be automatically updated by CGE editor.
  , GameViewMain
  {$endregion 'Castle Initialization Uses'};

var
  Window: TCastleWindow;
  Scene: TCastleScene;
  Viewport: TCastleViewport;
  RootNode: TX3DRootNode;
  I: Integer;
  Url: string;

procedure AppDropFiles(Sender: TCastleContainer; const FileNames: array of string);
begin
  //SceneTmp := Scene.Clone(Application);
  //RegisterVrmlX3dModelFormat;
  for I := 0 to Length(FileNames) - 1 do
  begin
    Url := 'file:/'+FileNames[I];
    RootNode := LoadX3DXml(Url, false);
    //RootNode := LoadNode(Url)
    Scene.Load(RootNode, true);
  end;
end;

{ One-time initialization of resources. }
procedure ApplicationInitialize;
begin
  { Adjust container settings for a scalable UI (adjusts to any window size in a smart way). }
  Window.Container.LoadSettings('castle-data:/CastleSettings.xml');

  { Create views (see https://castle-engine.io/views ). }
  {$region 'Castle View Creation'}
  // The content here may be automatically updated by CGE editor.
  ViewMain := TViewMain.Create(Application);
  {$endregion 'Castle View Creation'}

  Window.Container.View := ViewMain;
{$ifndef CASTLE_WINDOW_WINAPI}
  Window.RegisterDropTarget;
{$endif}
  Window.OnDropFiles := {$ifdef FPC}@{$endif}AppDropFiles;
  Viewport := TCastleViewport.Create(Application);
  Viewport.FullSize := true;
  Viewport.autoCamera := true;
  Window.Controls.InsertFront(Viewport);
  Scene := TCastleScene.Create(Application);
  Viewport.Items.Add(Scene);

end;

initialization
  { This initialization section configures:
    - Application.OnInitialize
    - Application.MainWindow
    - determines initial window size

    You should not need to do anything more in this initialization section.
    Most of your actual application initialization (in particular, any file reading)
    should happen inside ApplicationInitialize. }

  Application.OnInitialize := {$ifdef FPC}@{$endif}ApplicationInitialize;

  Window := TCastleWindow.Create(Application);
  Application.MainWindow := Window;

  { Optionally, adjust window fullscreen state and size at this point.
    Examples:

    Run fullscreen:

      Window.FullScreen := true;

    Run in a 600x400 window:

      Window.FullScreen := false; // default
      Window.Width := 600;
      Window.Height := 400;

    Run in a window taking 2/3 of screen (width and height):

      Window.FullScreen := false; // default
      Window.Width := Application.ScreenWidth * 2 div 3;
      Window.Height := Application.ScreenHeight * 2 div 3;

    Note that some platforms (like mobile) ignore these window sizes.
  }

  { Handle command-line parameters like --fullscreen and --window.
    By doing this last, you let user to override your fullscreen / mode setup. }
  Window.ParseParameters;
end.
