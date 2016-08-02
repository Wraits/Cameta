unit other;

interface

uses
  Classes, dspConst, DSPackTDCDSPFilter, SyncObjs, dspFastFourier, DshowU, EVR9,
  DirectShow9, Winapi.Windows, Vcl.Graphics, visSpectrum, dspAmplify,
  dspDynamicAmplify, dspEqualizer, CametaControl,
  Cameta_const, Vcl.Controls, Vcl.ExtCtrls, Messages, Vcl.ComCtrls, DSUtils;

type
  TVMRBitmapOption = (vmrbDisable, vmrbSrcColorKey, vmrbSrcRect);
  TVMRBitmapOptions = set of TVMRBitmapOption;

  TVMRBitmap = class;

  TVideoPanel = class(TPanel, IEvent, IFilter)
  private
    FOnPaint: TNotifyEvent;
    FVisible: boolean;
    TBaseFilter: IBaseFilter;
    DisplayControl: IMFVideoDisplayControl;
    VMRBitmap: TVMRBitmap;
    PVMRWindowlessControl9: IVMRWindowlessControl9;
    Stream: Integer;
    Brightness: Single;
    Contrast: Single;
    Hue: Single;
    Saturation: Single;
    Tgraph: Ocontrols;
    procedure SetVisible(Value: boolean);
    function InitializeEVR: HRESULT;
    function InitWindowlessVMR9: HRESULT;
    function vmr9: HRESULT;
    procedure ClearBack;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure NotifyFilter(operation: TFilterOperation; Param: Integer = 0);
    function GetName: string;
    procedure GraphEvent(Event, Param1, Param2: Integer);
    procedure ControlEvent(Event: TControlEvent; Param: Integer = 0);
  public
    function QueryInterface(const IID: TGUID; out Obj): HRESULT;
      override; stdcall;
    function GetFilter(index: Integer = 0): IBaseFilter;
    function VideoEnable: boolean;
    procedure DrawTo(txt: string);
    procedure Configure(TrackBar: TTrackBar; Prop: Dword);
    procedure ShowMenu(MenuID: TDVDMenuID);
    procedure PlayNextChapter;
    procedure PlayPrevChapter;
    function SetProcAmpControl(Value: Single; dwFlag: Dword): boolean;
    function GetProcAmpControl(dwFlag: Dword): Single;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Resize; override;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth,
      MaxHeight: Integer); override;
    constructor Create(Graph: Ocontrols); reintroduce;
    destructor Destroy; override;
    procedure Paint; override;
    property Canvas;
    property Onpaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Visible: boolean read FVisible write SetVisible default True;
  end;

  Tother = class(TDCEqualizer,IDSPackDCDSPFilterCallBack, IEvent, IFilter)
  private
    DCSpectrum: TDCSpectrum;
     { @exclude }
    FVisualEnable: boolean;
    { @exclude }
    fCriticalSection: TCriticalSection;
    { @exclude }
    Tgraph: Ocontrols;
     { @exclude }
    DspFilter: TDSAudioFilter;
     { @exclude }
    TBits, TChannels:byte;
    TFrequency: Integer;
    TFloat, State: boolean;
     { @exclude }
    function GetName: string;
     { @exclude }
    procedure NotifyFilter(operation: TFilterOperation; Param: Integer = 0);
     { @exclude }
    function GetFilter(index: Integer): IBaseFilter;
    // *******************************
    procedure SetAimEnable(aEnabled: boolean);
    { @exclude }
    procedure SetVisualEnable(aEnabled: boolean);
    { @exclude }
    function PCMDataCB(Buffer: Pointer; Length: Integer; out NewSize: Integer; Stream: PDSStream): HRESULT; stdcall;
    { @exclude }
    function MediaTypeChanged(Stream: PDSStream): HRESULT; stdcall;
    { @exclude }
    function Flush: HRESULT; stdcall;
    { @exclude }
    function get_CurrentAmplification: Single;
     { @exclude }
    function GetVolume(Channel: Byte): Integer;
    procedure SetVolume(Channel: Byte; Volume: Integer);
     { @exclude }
    procedure setDynEnabled(const Value: boolean);
    procedure SetMaxAmplification(const Value: Cardinal);
    procedure SetReleaseTime(const Value: Cardinal);
    procedure setAttackTime(const Value: Cardinal);
    function GetMaxAmplification: Cardinal;
    function GetReleaseTime: Cardinal;
    function getAttackTime: Cardinal;
    function GetDynEnabled: boolean;
     { @exclude }
    function ReadPresets(name: string): TEQBandsVolume;
     { @exclude }
    function getAimEnabled: boolean;
     { @exclude }
    procedure GraphEvent(Event, Param1, Param2: Integer);
    procedure ControlEvent(Event: TControlEvent; Param: Integer = 0);
     { @exclude }
    procedure writePresentsEQ(name: string; const Value: TEQBandsVolume);
     { @exclude }
    function getEqualizer: boolean;
    procedure SetEqualizer(const Value: boolean);
     { @exclude }
    function getBand(Channel: Byte; index: Word): ShortInt;
    procedure SetBand(Channel: Byte; index: Word; const Value: ShortInt);
     { @exclude }
    function getPresets: string;
    procedure SetPresets(const Value: string);
     { @exclude }
    function getMaxDB: Integer;
    procedure SetMaxDB(const Value: Integer);
     { @exclude }
    function GetEQPresets: TArray<string>;
     { @exclude }
    function GetEnableDelay: boolean;
    procedure SetEnableDelay(Enable: boolean);
     { @exclude }
    function GetDelay: Integer;
    procedure SetDelay(Delay: Integer);
  public
    function OnVisual: PVisualBuffer;
    constructor Create(Controls: Ocontrols); reintroduce;
    destructor Destroy; override;
    property VisualEnable: boolean read FVisualEnable write SetVisualEnable;
    // *************************************************************************
    property DynamicAmplify: boolean read GetDynEnabled write setDynEnabled;
    property AttackTime: Cardinal read getAttackTime write setAttackTime;
    property ReleaseTime: Cardinal read GetReleaseTime write SetReleaseTime;
    property MaxAmplification: Cardinal read GetMaxAmplification write SetMaxAmplification;
    property Amplification: Single read get_CurrentAmplification;
    // *************************************************************************
    property AmplifyVolume[Channel: Byte]: Integer read GetVolume write SetVolume;
    property Amplify: boolean read getAimEnabled write SetAimEnable;
    // *************************************************************************
    property Equalizer: boolean read getEqualizer write SetEqualizer;
    property PresetsEQ[name: string]: TEQBandsVolume read ReadPresets write writePresentsEQ;
    Property QBand[Channel: Byte; Index: Word]: ShortInt read getBand write SetBand;
    Property EQPresetName: string read getPresets write SetPresets;
    Property MaxDB: Integer read getMaxDB write SetMaxDB;
    property EQPresets: TArray<string> read GetEQPresets;
    Procedure DeleteEqalizerPresets(name: string);
    procedure WritePresetsDefault;
    // *************************************************************************
    property Channels: byte read TChannels;
    property Frequency: Integer read TFrequency;
    property Bits: byte read TBits;
    property Float: boolean read TFloat;
    // **************************************************************************
    property EnableAudioDelay: boolean read GetEnableDelay write SetEnableDelay;
    property AudioDelay: Integer read GetDelay write SetDelay;
    // AudioDelay   EnableAudioDelay
  end;

  GTHotKey = CLass
  private
    _Handle: Thandle;
    procedure reg_hotkey;
    Procedure UnReg_HotKey;
  public
    iVK_MEDIA_STOP: Word;
    iVK_MEDIA_NEXT_TRACK: Word;
    iVK_MEDIA_PREV_TRACK: Word;
    iVK_VOLUME_DOWN: Word;
    iVK_VOLUME_UP: Word;
    iVK_VOLUME_MUTE: Word;
    IVK_MEDIA_PLAY_PAUSE: Word;
    constructor Create(Handle: Thandle); reintroduce;
    destructor Destroy; override;
  end;

  TVMRBitmap = class
  private
    SHandle: Thandle;
    FCanvas: TCanvas;
    FVMRALPHABITMAP: TVMR9ALPHABITMAP;
    FOptions: TVMRBitmapOptions;
    FBMPOld: HBITMAP;
    EpBmpParms: TMFVideoAlphaBitmap;
    AVMRBitmap: TVMRAlphaBitmap;
    procedure SetOptions(Options: TVMRBitmapOptions);
    procedure ResetBitmap;
    procedure SetAlpha(const Value: Single);
    procedure SetColorKey(const Value: COLORREF);
    procedure SetDest(const Value: TVMR9NormalizedRect);
    procedure SetDestBottom(const Value: Single);
    procedure SetDestLeft(const Value: Single);
    procedure SetDestRight(const Value: Single);
    procedure SetDestTop(const Value: Single);
    procedure SetSource(const Value: TRect);
    function GetAlpha: Single;
    function GetColorKey: COLORREF;
    function GetDest: TVMR9NormalizedRect;
    function GetDestBottom: Single;
    function GetDestLeft: Single;
    function GetDestRight: Single;
    function GetDestTop: Single;
    function GetSource: TRect;
    function Gethandle: Thandle;
    procedure SetHandle(const Value: Thandle);
    function getCanvas: TCanvas;
    procedure SetCanvas(const Value: TCanvas);
    function getOptions: TVMRBitmapOptions;
  public
    // Contructor, set the video Window where the bitmat must be paint.
    constructor Create(FBaseFilter: IBaseFilter);
    // Cleanup
    destructor Destroy; override;
    // Load a Bitmap from a TBitmap class.
    procedure LoadBitmap(Bitmap: TBitmap);
    // Initialize with an empty bitmap.
    procedure LoadEmptyBitmap(Width, Height: Integer; PixelFormat: TPixelFormat;
      Color: TColor);
    // Draw the bitmap to the Video Window.
    procedure Draw(FBaseFilter: IBaseFilter);
    // Draw the bitmap on a particular position.
    procedure DrawTo(FBaseFilter: IBaseFilter;
      Left, Top, Right, Bottom, Alpha: Single; doUpdate: boolean = false);
    // update the video window with the current bitmap
    procedure Update(FBaseFilter: IBaseFilter);
    // Uses this property to draw on the internal bitmap.
    property Canvas: TCanvas read getCanvas write SetCanvas;
    // Change Alpha Blending
    property Alpha: Single read GetAlpha write SetAlpha;
    // set the source rectangle
    property Source: TRect read GetSource write SetSource;
    // Destination Left
    property DestLeft: Single read GetDestLeft write SetDestLeft;
    // Destination Top
    property DestTop: Single read GetDestTop write SetDestTop;
    // Destination Right
    property DestRight: Single read GetDestRight write SetDestRight;
    // Destination Bottom
    property DestBottom: Single read GetDestBottom write SetDestBottom;
    // Destination
    property Dest: TVMR9NormalizedRect read GetDest write SetDest;
    // Set the color key for transparency.
    property ColorKey: COLORREF read GetColorKey write SetColorKey;
    // VMR Bitmap Options.
    property Options: TVMRBitmapOptions read getOptions write SetOptions;
    property Handle: Thandle read Gethandle write SetHandle;
  end;

  TAudioRender = class(TComponent, IFilter)
  private
  var
    AControls: Ocontrols;
  public
    function GetName: string;
    function GetFilter(index: Integer): IBaseFilter;
    procedure NotifyFilter(operation: TFilterOperation; Param: Integer = 0);
    destructor Destroy; override;
    constructor Create(Controls: Ocontrols); reintroduce;
  end;

var
  others: Tother;

implementation

uses
  math, XSuperObject, dspUtils, Cameta_Utils,
  controlpanel, SysUtils, System.StrUtils;

// playerform
resourcestring

  StrDCEqualizer = 'DCEqualizer';
  StrMaxDB = 'MaxDB';
  StrMaxAmplification = 'MaxAmplification';
  StrAttackTime = 'AttackTime';
  StrAmplify = 'AmplifyLevel';
  StrVisStopped = 'VisStopped';
  StrReleaseTime = 'ReleaseTime';
  StrDynamicAmplify = 'Dynamic Amplify';
  StrAimEnabled = 'AimEnabled';
  StrEnableDelay = 'EnableAudioDelay';
  StrDelay = 'AudioDelay';

const
  EQPresetCount = 19;

  EQPresetNames: array [0 .. EQPresetCount - 1] of String = ('(Default)',
    'Classical', 'Club', 'Dance', 'Full Bass', 'Full Bass & Treble',
    'Full Treble', 'Labtop', 'Large Hall', 'Live', 'Loudness', 'Party', 'Pop',
    'Reggae', 'Rock', 'Ska', 'Soft', 'Soft Rock', 'Techno');

  EQPreset: array [0 .. EQPresetCount - 1] of array [0 .. 9] of ShortInt =
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), // (Default)
    (0, 0, 0, 0, 0, -10, 40, 40, 40, 50), // Classical
    (0, 0, -10, -20, -20, -20, -10, 0, 0, 0), // Club
    (-50, -40, -20, 5, 0, 20, 30, 20, 0, 0), // Dance
    (-50, -50, -50, -30, -10, 10, 30, 50, 50, 50), // Full Bass
    (-30, -20, 0, 30, 20, -10, -40, -50, -50, -50), // Full Bass & Treble
    (50, 50, 50, 20, -10, -50, -80, -80, -80, -90), // Full Treble
    (-15, -50, -25, 20, 10, -5, -15, -30, -50, -60), // Labtop
    (-50, -50, -30, -20, 0, 20, 30, 30, 0, 0), // Large Hall
    (30, 0, -10, -15, -20, -20, -10, -5, -5, 0), // Live
    (-90, -70, -50, -20, 0, -10, -20, -50, -70, -90), // Loudness
    (-30, -30, 0, 0, 0, 0, 0, 0, -30, -30), // Party
    (10, -15, -25, -25, -15, 10, 20, 20, 10, 10), // Pop
    (0, 0, 5, 30, 0, -30, -30, 0, 0, 0), // Reggae
    (-40, -30, 30, 40, 20, -20, -40, -40, -40, -40), // Rock
    (10, 20, 10, 0, -10, -20, -30, -35, -30, -25),
    // Ska (whatever that means ...)
    (-15, -5, 5, 15, 5, -15, -30, -40, -45, -50), // Soft
    (-15, -15, -10, 5, 15, 25, 15, 5, -10, -30), // Soft Rock
    (-30, -30, 0, 30, 20, 0, -20, -30, -30, -20) // Techno
    );

  // **************************************************************************
  { load resurce   var    rs: TResourceStream;    begin    rs := TResourceStream.Create(hinstance, 'TESTDOC', RT_RCDATA);    try    Richedit1.PlainText := False;    TempStream.Position := 0;    Richedit1.Lines.LoadFromStream(rs);    finally    rs.Free;    end; }

procedure TVideoPanel.Configure(TrackBar: TTrackBar; Prop: Dword);
var
  ProcAmpControlRange: TVMR9ProcAmpControlRange;
  ivmrmc: IVMRMixerControl9;
  MFVideoProcessor: IMFVideoProcessor;
  pPropRange: TDXVA2_ValueRange;
  trackchang: TNotifyEvent;
begin
  TrackBar.Enabled := false;
  if Assigned(PVMRWindowlessControl9) then
    if QueryInterface(iid_IVMRMixerControl9, ivmrmc) = s_ok then
      with ivmrmc do
      begin
        ZeroMemory(@ProcAmpControlRange, SizeOf(ProcAmpControlRange));
        ProcAmpControlRange.dwSize := SizeOf(ProcAmpControlRange);
        ProcAmpControlRange.dwProperty := Prop;
        if Succeeded(GetProcAmpControlRange(0, @ProcAmpControlRange)) then
        begin
          TrackBar.Min := Trunc(ProcAmpControlRange.MinValue * tep);
          TrackBar.Max := Trunc(ProcAmpControlRange.MaxValue * tep);
          TrackBar.Tag := Prop;
          if TrackBar.Min = TrackBar.Max then
            TrackBar.Enabled := false
          else
          begin
            TrackBar.SelEnd := Trunc(ProcAmpControlRange.DefaultValue * tep);
            trackchang := TrackBar.OnChange;
            TrackBar.OnChange := nil;
            TrackBar.Position := Trunc(self.GetProcAmpControl(Prop) * tep);
            TrackBar.OnChange := trackchang;
            TrackBar.Frequency := Trunc(TrackBar.Max / 10);
            TrackBar.Enabled := True;
          end;
        end
        else
        begin
          TrackBar.Min := 0;
          TrackBar.Max := 0;
          TrackBar.Position := 0;
          TrackBar.Frequency := 0;
          TrackBar.Enabled := false;
        end;
        exit;
      end;
  if QueryInterface(IMFVideoProcessor, MFVideoProcessor) = s_ok then
    with MFVideoProcessor do
    begin
      ZeroMemory(@pPropRange, SizeOf(pPropRange));
      if Succeeded(GetProcAmpRange(Prop, pPropRange)) then
      begin
        TrackBar.Min := Trunc(double(pPropRange.MinValue) * tep);
        TrackBar.Max := Trunc(double(pPropRange.MaxValue) * tep);
        TrackBar.Tag := Prop;
        if TrackBar.Min = TrackBar.Max then
          TrackBar.Enabled := false
        else
        begin
          TrackBar.SelEnd := Trunc(double(pPropRange.DefaultValue) * tep);
          trackchang := TrackBar.OnChange;
          TrackBar.OnChange := nil;
          TrackBar.Position := Trunc(self.GetProcAmpControl(Prop) * tep);
          TrackBar.OnChange := trackchang;
          TrackBar.Frequency := Trunc(TrackBar.Max / 10);
          TrackBar.Enabled := True;
        end;
      end
      else
      begin
        TrackBar.Min := 0;
        TrackBar.Max := 0;
        TrackBar.Position := 0;
        TrackBar.Frequency := 0;
        TrackBar.Enabled := false;
      end;
      exit;
    end;
end;

procedure TVideoPanel.ConstrainedResize(var MinWidth, MinHeight, MaxWidth,
  MaxHeight: Integer);
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
  Resize;
end;

procedure TVideoPanel.ControlEvent(Event: TControlEvent; Param: Integer);
var
  size: TRect;
begin
  if Event in [cePlay, cePause] then
  begin
    size := ClientRect;
    if Assigned(DisplayControl) then
      DisplayControl.SetVideoPosition(nil, @size)
    else IF Assigned(PVMRWindowlessControl9) then
      PVMRWindowlessControl9.SetVideoPosition(nil, @size);
    if Assigned(DisplayControl) then
      DisplayControl.RepaintVideo;
    IF Assigned(PVMRWindowlessControl9) then
      PVMRWindowlessControl9.RepaintVideo(Handle, Canvas.Handle);
    SetProcAmpControl(Brightness, ProcAmpControl9_Brightness);
    SetProcAmpControl(Contrast, ProcAmpControl9_Contrast);
    SetProcAmpControl(Hue, ProcAmpControl9_hue);
    SetProcAmpControl(Saturation, ProcAmpControl9_Saturation);
  end;
end;

constructor TVideoPanel.Create(Graph: Ocontrols);
begin
  inherited Create(nil);
  // ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks, csReflector];
  Stream := 1;
  TabStop := false;
  Height := 120;
  Width := 160;
  Color := $000000;
  DoubleBuffered := True;
  Align := alClient;
  // BorderStyle := bsNone;
  Brightness := 0;
  Contrast := 1;
  Hue := 0;
  Saturation := 1;
  Tgraph := Graph;
  Tgraph.InsertFilter(self);
  Tgraph.InsertEventNotifier(self);
end;

destructor TVideoPanel.Destroy;
begin
  if Assigned(Tgraph) then
  begin
    Tgraph.RemoveFilter(self);
    Tgraph.RemoveEventNotifier(self);
  end;
  inherited Destroy;
end;

procedure TVideoPanel.DrawTo(txt: string);
begin

  if not VideoEnable then
    exit;
  TThread.Synchronize(nil,
    procedure
    begin
        with VMRBitmap, VMRBitmap.Canvas do
        begin
          LoadEmptyBitmap(Width, Height, pf32bit, clGray);
          Source := VMRBitmap.Canvas.ClipRect;
          Options := VMRBitmap.Options + [vmrbSrcColorKey];
          ColorKey := clGray;
          Brush.Color := clGray;
          Font.Color := clgreen;
          Font.Style := [fsBold];
          Font.size := 16;
          Font.name := 'Arial';
          TextOut(10, 10, txt);
          DrawTo(TBaseFilter, 0, 0, 1, 1, 1);
        end;
    end);
  if Tgraph.State = gsPaused then
  begin
    if Assigned(DisplayControl) then
      DisplayControl.RepaintVideo;
    IF Assigned(PVMRWindowlessControl9) then
      PVMRWindowlessControl9.RepaintVideo(Handle, Canvas.Handle);
  end;
end;

procedure TVideoPanel.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SIZE:
      BEGIN

      END;
    wm_paint:
      ;
    WM_DISPLAYCHANGE:
      begin
        IF Assigned(PVMRWindowlessControl9) then
          PVMRWindowlessControl9.DisplayModeChanged;
      end;
  end;
  inherited WndProc(Message);
end;

function getWrite(Value: Single; out wvalue: Single): Single;
begin
  result := Value;
  wvalue := Value;
end;

function TVideoPanel.SetProcAmpControl(Value: Single; dwFlag: Dword): boolean;
var
  ProcAmpControl: TVMR9ProcAmpControl;
  ivmrmc: IVMRMixerControl9;
  MFVideoProcessor: IMFVideoProcessor;
  pValues: TDXVA2_ProcAmpValues;
  size: TRect;
begin
  result := false;
  if Assigned(DisplayControl) then
    if QueryInterface(IMFVideoProcessor, MFVideoProcessor) = s_ok then
    begin
      ZeroMemory(@pValues, SizeOf(pValues));
      case dwFlag of
        ProcAmpControl9_Brightness:
          pValues.Brightness := getWrite(Value, Brightness);
        ProcAmpControl9_Contrast:
          pValues.Contrast := getWrite(Value, Contrast);
        ProcAmpControl9_hue:
          pValues.Hue := getWrite(Value, Hue);
        ProcAmpControl9_Saturation:
          pValues.Saturation := getWrite(Value, Saturation);
      end;
      result := MFVideoProcessor.SetProcAmpValues(dwFlag, pValues) = s_ok;
      if (Tgraph.State = gsPaused) and Assigned(DisplayControl) then
        DisplayControl.RepaintVideo;
      exit;
    end;

  if Assigned(PVMRWindowlessControl9) then
    if QueryInterface(iid_IVMRMixerControl9, ivmrmc) = s_ok then
    begin
      ZeroMemory(@ProcAmpControl, SizeOf(ProcAmpControl));
      ProcAmpControl.dwSize := SizeOf(ProcAmpControl);
      ProcAmpControl.dwFlags := dwFlag;
      case dwFlag of
        ProcAmpControl9_Brightness:
          ProcAmpControl.Brightness := getWrite(Value, Brightness);
        ProcAmpControl9_Contrast:
          ProcAmpControl.Contrast := getWrite(Value, Contrast);
        ProcAmpControl9_hue:
          ProcAmpControl.Hue := getWrite(Value, Hue);
        ProcAmpControl9_Saturation:
          ProcAmpControl.Saturation := getWrite(Value, Saturation);
      end;
      result := (ivmrmc.SetProcAmpControl(0, @ProcAmpControl)) = s_ok;
      if (Tgraph.State = gsPaused) and Assigned(PVMRWindowlessControl9) then
      begin
        size := ClientRect;
        PVMRWindowlessControl9.SetVideoPosition(nil, @size);
      end;
    end;
end;

procedure TVideoPanel.SetVisible(Value: boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    inherited Visible := Value;
    // graph.VideoPosition := Rect(0, 0, width, height);
  end;
end;

procedure TVideoPanel.ShowMenu(MenuID: TDVDMenuID);
var
  DvdCmd: IDvdCmd;
begin
  if Tgraph.active then
    with Tgraph as IDVDControl2 do
      ShowMenu(MenuID, DVD_CMD_FLAG_None, DvdCmd);
end;

function TVideoPanel.VideoEnable: boolean;
begin
  if (Tgraph.State = gsStopped) then
    exit(false);
  exit(Assigned(TBaseFilter)and (length(ArrayGetPin(TBaseFilter,[PINDIR_INPUT],true))=0));
end;

function TVideoPanel.vmr9: HRESULT;
var
  Deinterlace9: IVMRDeinterlaceControl9;
  ups: TGUID;
begin
  try
    result := QueryInterface(IVMRDeinterlaceControl9, Deinterlace9);
    if not failed(result) then
    begin
      result := (Deinterlace9.SetDeinterlacePrefs(DeinterlacePref9_NextBest));
      if Succeeded(result) then
      begin
        result := Deinterlace9.GetActualDeinterlaceMode(Stream, ups);
        if Succeeded(result) then
          result := (Deinterlace9.SetDeinterlaceMode(Stream, ups));
        exit;
      end;
    end;
  finally
    Deinterlace9 := nil;
  end;
end;

procedure TVideoPanel.ClearBack;
// var
// DC, MemDC: HDC;
// MemBitmap, OldBitmap: HBITMAP;
// BackBrush, OverlayBrush: HBrush;
begin
  exit;
  { BackBrush := 0;
    OverlayBrush := 0;
    if (csDestroying in componentstate) then
    exit;
    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    ReleaseDC(0, DC);
    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, MemBitmap);
    try
    DC := GetDC(Handle);
    BackBrush := CreateSolidBrush(Color);
    FillRect(MemDC, Rect(0, 0, ClientRect.Right, ClientRect.Bottom), BackBrush);
    if not(csDesigning in componentstate) then
    begin
    OverlayBrush := HBrush(CreateSolidBrush(Canvas.Brush.Color));
    FillRect(MemDC, self.ClientRect, OverlayBrush);
    end;
    BitBlt(DC, 0, 0, self.ClientRect.Right, self.ClientRect.Bottom, MemDC, 0,
    0, SRCCOPY);
    finally
    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    DeleteObject(MemBitmap);
    DeleteObject(BackBrush);
    DeleteObject(OverlayBrush);
    ReleaseDC(Handle, DC);
    end;
    if Assigned(FOnPaint) then
    FOnPaint(self); }
end;

function TVideoPanel.GetFilter(index: Integer): IBaseFilter;
begin
  result := nil;
  if (index = 0) or (index = 3) then
    result := TBaseFilter;
end;

function TVideoPanel.GetName: string;
begin
  result := string(Tgraph.VideoRender.FriendlyName);
end;

function TVideoPanel.GetProcAmpControl(dwFlag: Dword): Single;
var
  ProcAmpControl: TVMR9ProcAmpControl;
  ivmrmc: IVMRMixerControl9;
  MFVideoProcessor: IMFVideoProcessor;
  pValues: TDXVA2_ProcAmpValues;
begin
  result := 0;
  ProcAmpControl.dwSize := SizeOf(ProcAmpControl);
  ProcAmpControl.dwFlags := dwFlag;

  if not VideoEnable then
    exit;
  if QueryInterface(IMFVideoProcessor, MFVideoProcessor) = s_ok then
    if Succeeded(MFVideoProcessor.GetProcAmpValues(dwFlag, pValues)) then
      case dwFlag of
        ProcAmpControl9_Brightness:
          result := pValues.Brightness;
        ProcAmpControl9_Contrast:
          result := pValues.Contrast;
        ProcAmpControl9_hue:
          result := pValues.Hue;
        ProcAmpControl9_Saturation:
          result := pValues.Saturation;
      end
    else if QueryInterface(iid_IVMRMixerControl9, ivmrmc) = s_ok then
      if Succeeded((ivmrmc.GetProcAmpControl(0, @ProcAmpControl))) then
        case dwFlag of
          ProcAmpControl9_Brightness:
            result := ProcAmpControl.Brightness;
          ProcAmpControl9_Contrast:
            result := ProcAmpControl.Contrast;
          ProcAmpControl9_hue:
            result := ProcAmpControl.Hue;
          ProcAmpControl9_Saturation:
            result := ProcAmpControl.Saturation;
        end;
end;

procedure TVideoPanel.GraphEvent(Event, Param1, Param2: Integer);
begin

end;

function TVideoPanel.InitializeEVR: HRESULT;
var
  GetService: IMFGetService;
begin

  result := TBaseFilter.QueryInterface(IMFGetService, GetService);
  if Assigned(GetService) then
    GetService.GetService(MR_VIDEO_RENDER_SERVICE, IMFVideoDisplayControl,
      DisplayControl);
  if Assigned(DisplayControl) then
  begin
    result := DisplayControl.SetVideoWindow(self.Handle);
    DisplayControl.SetAspectRatioMode(MFVideoARMode_PreservePicture);
    DisplayControl.SetBorderColor(MFVideoRenderPrefs_DoNotClipToDevice);
  end;
end;

function TVideoPanel.InitWindowlessVMR9: HRESULT;
var
  VMRFilterConfig9: IVMRFilterConfig9;
begin
  result := TBaseFilter.QueryInterface(IVMRFilterConfig9, VMRFilterConfig9);
  if Assigned(VMRFilterConfig9) then
    try
      result := (((VMRFilterConfig9.SetRenderingMode(VMR9Mode_Windowless))));
      if Succeeded(result) then
        result := (VMRFilterConfig9.SetNumberOfStreams(Stream));
      if Succeeded(result) then
        if (TBaseFilter.QueryInterface(IVMRWindowlessControl9,
          PVMRWindowlessControl9)) = s_ok then
        begin
          PVMRWindowlessControl9.SetVideoClippingWindow(self.Handle);
          PVMRWindowlessControl9.SetAspectRatioMode(VMR9ARMode_LetterBox);
        end;
      vmr9;
    finally
      VMRFilterConfig9 := nil;
    end;
end;

procedure TVideoPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
X, Y: Integer);
var
  tmpp: TPoint;
  DVDControl2: IDVDControl2;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    if Tgraph.QueryInterface(IDVDControl2, DVDControl2) = s_ok then
      with DVDControl2 do
      begin
        tmpp.X := X;
        tmpp.Y := Y;
        ActivateAtPosition(tmpp);
      end;
end;

procedure TVideoPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  tmpp: TPoint;
  DVDControl2: IDVDControl2;
begin
  inherited MouseMove(Shift, X, Y);
  if Tgraph.QueryInterface(IDVDControl2, DVDControl2) = s_ok then
    with DVDControl2 do
    begin
      tmpp.X := X;
      tmpp.Y := Y;
      if SelectAtPosition(tmpp) = s_ok then
        Cursor := crHandPoint
      else
        Cursor := crDefault;
    end
  else
    Cursor := crDefault;
end;

procedure TVideoPanel.NotifyFilter(operation: TFilterOperation; Param: Integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      case operation of
        foAdding:
          TBaseFilter := LoadFilter(Tgraph.VideoRender.clsid);
        foAdded:
          begin
            InitializeEVR;
            InitWindowlessVMR9;
            VMRBitmap := TVMRBitmap.Create(nil);
            VMRBitmap.Handle := self.Handle;
          end;
        foRemoving:
          begin
           FreeAndNil(VMRBitmap);
            PVMRWindowlessControl9 := nil;
            DisplayControl := nil;
          end;
        foRemoved:
          begin
            TBaseFilter := nil;
          end;
      end;
    end);
end;

procedure TVideoPanel.Paint;
begin
  inherited Paint;
  if  (Tgraph.State in [gsUninitialized,gsStopped]) then
   exit;
  if  VideoEnable then
    VMRBitmap.Update(TBaseFilter);
  if  VideoEnable  then
  begin
    if Assigned(DisplayControl) then
      DisplayControl.RepaintVideo;
    IF Assigned(PVMRWindowlessControl9) then
      PVMRWindowlessControl9.RepaintVideo(self.Handle, self.Canvas.Handle);
  end;
  ClearBack;
end;

procedure TVideoPanel.PlayNextChapter;
var
  DvdCmd: IDvdCmd;
begin
  if Tgraph.active then
    with Tgraph as IDVDControl2 do
      PlayNextChapter(DVD_CMD_FLAG_None, DvdCmd);
end;

procedure TVideoPanel.PlayPrevChapter;
var
  DvdCmd: IDvdCmd;
begin
  if Tgraph.active then
    with Tgraph as IDVDControl2 do
      PlayPrevChapter(DVD_CMD_FLAG_None, DvdCmd);
end;

function TVideoPanel.QueryInterface(const IID: TGUID; out Obj): HRESULT;
var
  GetService: IMFGetService;
begin
  if IsEqualGUID(IID_IVMRWindowlessControl9, IID) and
    (PVMRWindowlessControl9 <> nil) then
  begin
    result := s_ok;
    IunKnown(Obj) := PVMRWindowlessControl9;
    exit;
  end;
  result := inherited QueryInterface(IID, Obj);
  if failed(result) and VideoEnable then
  begin
    result := TBaseFilter.QueryInterface(IID, Obj);
    if Succeeded(result) then
      exit;
    result := TBaseFilter.QueryInterface(IMFGetService, GetService);
    if Succeeded(result) then
      GetService.GetService(MR_VIDEO_MIXER_SERVICE, IID, Obj);
  end;
end;

procedure TVideoPanel.Resize;
var
  size: TRect;
  NormalizedRect: TNormalizedRect;
begin
  inherited Resize;

  NormalizedRect.Left := 0;
  NormalizedRect.Top := 0;
  NormalizedRect.Right := 1;
  NormalizedRect.Bottom := 1;
  size := ClientRect;
  if Assigned(DisplayControl) then
    DisplayControl.SetVideoPosition(@NormalizedRect, @size)
  else IF Assigned(PVMRWindowlessControl9) then
    PVMRWindowlessControl9.SetVideoPosition(@NormalizedRect, @size);
  // Application.ProcessMessages;
end;

// *****************************************************************************

{ TVMRBitmap }

constructor TVMRBitmap.Create(FBaseFilter: IBaseFilter);
begin
  FCanvas := TCanvas.Create;
  FillChar(FVMRALPHABITMAP, SizeOf(FVMRALPHABITMAP), 0);
  Options := [];
  FVMRALPHABITMAP.HDC := 0;
  FVMRALPHABITMAP.fAlpha := 1;
end;

destructor TVMRBitmap.Destroy;
begin
  ResetBitmap;
  FCanvas.Free;
end;

procedure TVMRBitmap.Draw(FBaseFilter: IBaseFilter);
var
  GetService: IMFGetService;
  VMRMixerBitmap: IVMRMixerBitmap9;
  FBitmap: IVMRMixerBitmap;
  MFVideoMixerBitmap: IMFVideoMixerBitmap;
begin
  if not Assigned(FBaseFilter) then
    exit;

  if Succeeded(FBaseFilter.QueryInterface(IVMRMixerBitmap9, VMRMixerBitmap))
  then
    VMRMixerBitmap.SetAlphaBitmap(@FVMRALPHABITMAP)
  else if FBaseFilter.QueryInterface(IVMRMixerBitmap, FBitmap) = s_ok then
  begin
    ZeroMemory(@AVMRBitmap, SizeOf(TVMRAlphaBitmap));
    AVMRBitmap.dwFlags := VMRBITMAP_HDC or VMRBITMAP_SRCCOLORKEY;
    AVMRBitmap.clrSrcKey := FVMRALPHABITMAP.clrSrcKey;
    AVMRBitmap.HDC := FVMRALPHABITMAP.HDC;
    AVMRBitmap.rSrc := FVMRALPHABITMAP.rSrc;
    AVMRBitmap.rDest.Left := 0;
    AVMRBitmap.rDest.Right := 1;
    AVMRBitmap.rDest.Top := 0;
    AVMRBitmap.rDest.Bottom := 1;
    AVMRBitmap.fAlpha := 1;
    FBitmap.SetAlphaBitmap(AVMRBitmap);
  end
  else if FBaseFilter.QueryInterface(IMFGetService, GetService) = s_ok then
    if GetService.GetService(MR_VIDEO_MIXER_SERVICE, IMFVideoMixerBitmap,
      MFVideoMixerBitmap) = s_ok then
    begin
      MFVideoMixerBitmap.ClearAlphaBitmap;
      ZeroMemory(@EpBmpParms, SizeOf(TMFVideoAlphaBitmap));
      EpBmpParms.GetBitmapFromDC := True;
      EpBmpParms.HDC := FVMRALPHABITMAP.HDC;
      with EpBmpParms.params do
      begin
        dwFlags := MFVideoAlphaBitmap_Alpha or MFVideoAlphaBitmap_SrcColorKey;
        clrSrcKey := FVMRALPHABITMAP.clrSrcKey;
        rcSrc := FVMRALPHABITMAP.rSrc;
        nrcDest.Left := 0;
        nrcDest.Top := 1.0;
        nrcDest.Right := 0;
        nrcDest.Bottom := 1.0;
        fAlpha := 1;
        dwFilterMode := 0;
      end;
      CheckDSError(MFVideoMixerBitmap.SetAlphaBitmap(EpBmpParms));
    end;
end;

procedure TVMRBitmap.DrawTo(FBaseFilter: IBaseFilter;
Left, Top, Right, Bottom, Alpha: Single; doUpdate: boolean = false);
begin
  with FVMRALPHABITMAP do
  begin
    rDest.Left := Left;
    rDest.Top := Top;
    rDest.Right := Right;
    rDest.Bottom := Bottom;
    fAlpha := Alpha;
  end;
  if doUpdate then
    Update(FBaseFilter)
  else
    Draw(FBaseFilter);
end;

function TVMRBitmap.GetAlpha: Single;
begin
  result := FVMRALPHABITMAP.fAlpha;
end;

function TVMRBitmap.getCanvas: TCanvas;
begin
  exit(FCanvas)
end;

function TVMRBitmap.GetColorKey: COLORREF;
begin
  result := FVMRALPHABITMAP.clrSrcKey;
end;

function TVMRBitmap.GetDest: TVMR9NormalizedRect;
begin
  result := FVMRALPHABITMAP.rDest;
end;

function TVMRBitmap.GetDestBottom: Single;
begin
  result := FVMRALPHABITMAP.rDest.Bottom;
end;

function TVMRBitmap.GetDestLeft: Single;
begin
  result := FVMRALPHABITMAP.rDest.Left;
end;

function TVMRBitmap.GetDestRight: Single;
begin
  result := FVMRALPHABITMAP.rDest.Right
end;

function TVMRBitmap.GetDestTop: Single;
begin
  result := FVMRALPHABITMAP.rDest.Top;
end;

function TVMRBitmap.Gethandle: Thandle;
begin
  exit(SHandle)
end;

function TVMRBitmap.getOptions: TVMRBitmapOptions;
begin
  exit(FOptions)
end;

function TVMRBitmap.GetSource: TRect;
begin
  result := FVMRALPHABITMAP.rSrc;
end;

procedure TVMRBitmap.LoadBitmap(Bitmap: TBitmap);
var
  TmpHDC, HdcBMP: HDC;
  // BMP:TBITMAP;
begin
  Assert(Assigned(Bitmap), 'Invalid Bitmap.');
  ResetBitmap;
  TmpHDC := GetDC(Handle);
  if (TmpHDC = 0) then
    exit;
  HdcBMP := CreateCompatibleDC(TmpHDC);
  ReleaseDC(Handle, TmpHDC);
  if (HdcBMP = 0) then
    exit;
  // if (0 = GetObject(Bitmap.Handle, sizeof(BMP), @BMP)) then exit;
  FBMPOld := SelectObject(HdcBMP, Bitmap.Handle);
  if (FBMPOld = 0) then
    exit;
  FVMRALPHABITMAP.HDC := HdcBMP;
  FCanvas.Handle := HdcBMP;
end;

procedure TVMRBitmap.LoadEmptyBitmap(Width, Height: Integer;
PixelFormat: TPixelFormat; Color: TColor);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Width;
    Bitmap.Height := Height;
    Bitmap.PixelFormat := PixelFormat;
    Bitmap.Canvas.Brush.Color := Color;
    Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
    LoadBitmap(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TVMRBitmap.ResetBitmap;
begin
  FCanvas.Handle := 0;
  if FVMRALPHABITMAP.HDC <> 0 then
  begin
    DeleteObject(SelectObject(FVMRALPHABITMAP.HDC, FBMPOld));
    DeleteDC(FVMRALPHABITMAP.HDC);
    FVMRALPHABITMAP.HDC := 0;
  end;
end;

procedure TVMRBitmap.SetAlpha(const Value: Single);
begin
  FVMRALPHABITMAP.fAlpha := Value;
end;

procedure TVMRBitmap.SetCanvas(const Value: TCanvas);
begin
  FCanvas := Value
end;

procedure TVMRBitmap.SetColorKey(const Value: COLORREF);
begin
  FVMRALPHABITMAP.clrSrcKey := Value;
end;

procedure TVMRBitmap.SetDest(const Value: TVMR9NormalizedRect);
begin
  FVMRALPHABITMAP.rDest := Value;
end;

procedure TVMRBitmap.SetDestBottom(const Value: Single);
begin
  FVMRALPHABITMAP.rDest.Bottom := Value;
end;

procedure TVMRBitmap.SetDestLeft(const Value: Single);
begin
  FVMRALPHABITMAP.rDest.Left := Value;
end;

procedure TVMRBitmap.SetDestRight(const Value: Single);
begin
  FVMRALPHABITMAP.rDest.Right := Value;
end;

procedure TVMRBitmap.SetDestTop(const Value: Single);
begin
  FVMRALPHABITMAP.rDest.Top := Value;
end;

procedure TVMRBitmap.SetHandle(const Value: Thandle);
begin
  SHandle := Value
end;

procedure TVMRBitmap.SetOptions(Options: TVMRBitmapOptions);
begin
  FOptions := Options;
  FVMRALPHABITMAP.dwFlags := VMR9AlphaBitmap_hDC;
  if vmrbDisable in Options then
    FVMRALPHABITMAP.dwFlags := FVMRALPHABITMAP.dwFlags or
      VMR9AlphaBitmap_Disable;
  if vmrbSrcColorKey in Options then
    FVMRALPHABITMAP.dwFlags := FVMRALPHABITMAP.dwFlags or
      VMR9AlphaBitmap_SrcColorKey;
  if vmrbSrcRect in Options then
    FVMRALPHABITMAP.dwFlags := FVMRALPHABITMAP.dwFlags or
      VMR9AlphaBitmap_SrcRect;
end;

procedure TVMRBitmap.SetSource(const Value: TRect);
begin
  FVMRALPHABITMAP.rSrc := Value;
end;

procedure TVMRBitmap.Update;
var
  VMRMixerBitmap: IVMRMixerBitmap9;
  GetService: IMFGetService;
  MFVideoMixerBitmap: IMFVideoMixerBitmap;
  pBmpParms: TMFVideoAlphaBitmapParams;
begin
  if not Assigned(FBaseFilter) then
    exit;
  if (FBaseFilter.QueryInterface(IMFGetService, GetService) = s_ok) and
    (GetService.GetService(MR_VIDEO_MIXER_SERVICE, IMFVideoMixerBitmap,
    MFVideoMixerBitmap) = s_ok) then
  begin
    pBmpParms := EpBmpParms.params;
    MFVideoMixerBitmap.UpdateAlphaBitmapParameters(pBmpParms);
  end
  else if Succeeded(FBaseFilter.QueryInterface(IVMRMixerBitmap9, VMRMixerBitmap))
  then
    VMRMixerBitmap.UpdateAlphaBitmapParameters(@FVMRALPHABITMAP);
end;


// ****************************************************************************

constructor GTHotKey.Create;
begin
  _Handle := Handle;
  reg_hotkey;
end;

destructor GTHotKey.Destroy;
begin
  UnReg_HotKey;
  inherited;
end;

procedure GTHotKey.reg_hotkey;
const
  MOD_CONTROL = 2;
begin
  // Register Hotkey Ctrl + A
  IVK_MEDIA_PLAY_PAUSE := GlobalAddAtom('VK_MEDIA_PLAY_PAUSE');
  RegisterHotKey(_Handle, IVK_MEDIA_PLAY_PAUSE, 0, VK_MEDIA_PLAY_PAUSE);

  iVK_MEDIA_STOP := GlobalAddAtom('VK_MEDIA_STOP');
  RegisterHotKey(_Handle, iVK_MEDIA_STOP, 0, VK_MEDIA_STOP);

  iVK_MEDIA_NEXT_TRACK := GlobalAddAtom('VK_MEDIA_NEXT_TRACK');
  RegisterHotKey(_Handle, iVK_MEDIA_NEXT_TRACK, 0, VK_MEDIA_NEXT_TRACK);

  iVK_MEDIA_PREV_TRACK := GlobalAddAtom('VK_MEDIA_PREV_TRACK');
  RegisterHotKey(_Handle, iVK_MEDIA_PREV_TRACK, 0, VK_MEDIA_PREV_TRACK);

  iVK_VOLUME_DOWN := GlobalAddAtom('VK_VOLUME_DOWN');
  RegisterHotKey(_Handle, iVK_VOLUME_DOWN, 0, VK_VOLUME_DOWN);

  iVK_VOLUME_UP := GlobalAddAtom('VK_VOLUME_UP');
  RegisterHotKey(_Handle, iVK_VOLUME_UP, 0, VK_VOLUME_UP);

  iVK_VOLUME_MUTE := GlobalAddAtom('VK_VOLUME_MUTE');
  RegisterHotKey(_Handle, iVK_VOLUME_MUTE, 0, VK_VOLUME_MUTE);
end;

Procedure GTHotKey.UnReg_HotKey;
begin
  UnRegisterHotKey(_Handle, IVK_MEDIA_PLAY_PAUSE);
  GlobalDeleteAtom(IVK_MEDIA_PLAY_PAUSE);

  UnRegisterHotKey(_Handle, iVK_MEDIA_STOP);
  GlobalDeleteAtom(iVK_MEDIA_STOP);

  UnRegisterHotKey(_Handle, iVK_MEDIA_PREV_TRACK);
  GlobalDeleteAtom(iVK_MEDIA_PREV_TRACK);

  UnRegisterHotKey(_Handle, iVK_MEDIA_NEXT_TRACK);
  GlobalDeleteAtom(iVK_MEDIA_NEXT_TRACK);

  UnRegisterHotKey(_Handle, iVK_VOLUME_UP);
  GlobalDeleteAtom(iVK_VOLUME_UP);

  UnRegisterHotKey(_Handle, iVK_VOLUME_DOWN);
  GlobalDeleteAtom(iVK_VOLUME_DOWN);

  UnRegisterHotKey(_Handle, iVK_VOLUME_MUTE);
  GlobalDeleteAtom(iVK_VOLUME_MUTE);
end;

// ******//////////////////////

function Tother.getAttackTime: Cardinal;
begin
  result := Integer(1000);
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    if Contains(StrAttackTime) then
      result := i[StrAttackTime];
  end;
  DCAttackTime := result
  // ReadRegistry(DspRegistr, StrAttackTime,Integer(1000));  result := DCDynamicAmplify.AttackTime;
end;

procedure Tother.setAttackTime(const Value: Cardinal);
begin
  DCAttackTime := Value;
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    i[StrAttackTime] := Value;
    WriteRegistry(DspRegistr, 'DynamicAmplify', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrAttackTime, Integer(DCDynamicAmplify.AttackTime));
end;

function Tother.getBand(Channel: Byte; index: Word): ShortInt;
begin
  if not InRange(Channel, 0, MaxChannels - 1) or not InRange(Index, 0, 8191)
  then
    exit(0);
  result := Round(100.0 * log10( inherited QBand[Channel, Index] / 2));
end;

procedure Tother.SetBand(Channel: Byte; index: Word; const Value: ShortInt);
begin
  inherited QBand[Channel, Index] := Value;
end;

procedure Tother.SetDelay(Delay: Integer);
begin
  with so(ReadRegistry(DspRegistr, 'Delay', '{}')) do
  begin
    i[StrDelay] := Delay;
    WriteRegistry(DspRegistr, 'Delay', AsJSON);
  end;
  // WriteRegistry(DspRegistr, StrDelay, Delay);
  if not Assigned(DspFilter) then
    exit;
  DspFilter.set_Delay(Delay);
end;

procedure Tother.setDynEnabled(const Value: boolean);
begin
  DCEnabled := Value;
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    B[StrDynamicAmplify] := Value;
    WriteRegistry(DspRegistr, 'DynamicAmplify', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrDynamicAmplify,Integer(DCDynamicAmplify.Enabled));
end;

function Tother.GetDelay: Integer;
begin
  result := 0;
  with so(ReadRegistry(DspRegistr, 'Delay', '{}')) do
  begin
    if Contains(StrDelay) then
      result := i[StrDelay];
  end;
  // result:=ReadRegistry(DspRegistr, StrDelay, 0)
end;

function Tother.GetDynEnabled: boolean;
begin
  result := True;
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    if Contains(StrDynamicAmplify) then
      result := B[StrDynamicAmplify];
  end;
  DCEnabled := result;
end;
// **************************************************************************

function Tother.OnVisual: PVisualBuffer;
var
  PBuffer: Pointer;
  size: Integer;
  Stream: PDSStream;
begin
  DCSpectrum.Flush;
  if FVisualEnable and (State) and Assigned(DspFilter) and
    Succeeded(DspFilter.get_VisualData(PBuffer, size, Stream)) then
  begin
    DCSpectrum.Process(PBuffer, size, Stream.Bits, Stream.Channels,
      Stream.Float);
    Tspanel.GetSoundLevel(PBuffer, size, Stream.Bits, Stream.Channels,
      Stream.Float);
  end;
  result := @DCSpectrum.Buffer;
end;

procedure Tother.SetEnableDelay(Enable: boolean);
var
  tmp: bool;
begin
  with so(ReadRegistry(DspRegistr, 'Delay', '{}')) do
  begin
    B[StrEnableDelay] := Enable;
    WriteRegistry(DspRegistr, 'Delay', AsJSON);
  end;
  // WriteRegistry(DspRegistr, StrEnableDelay,Enable);
  if not Assigned(DspFilter) then
    exit;
  tmp := Enable;

  DspFilter.get_EnableDelay(tmp);
end;

procedure Tother.SetEqualizer(const Value: boolean);
begin
  QEnabled := Value;
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    B[StrDCEqualizer] := Value;
    WriteRegistry(DspRegistr, 'Equalizer', AsJSON);
  end;
  // WriteRegistry(DspRegistr, StrDCEqualizer, DCEqualizer.Enabled);
end;

function Tother.getEqualizer: boolean;
begin
  result := True;
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    if Contains(StrDCEqualizer) then
      result := B[StrDCEqualizer];
  end;
  QEnabled := result;
  // result := DCEqualizer.Enabled
end;

procedure Tother.SetMaxAmplification(const Value: Cardinal);
begin
  DCMaxAmplification := Value;
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    i[StrMaxAmplification] := Value;
    WriteRegistry(DspRegistr, 'DynamicAmplify', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrMaxAmplification, Integer(DCDynamicAmplify.MaxAmplification));
end;

function Tother.GetFilter(index: Integer): IBaseFilter;
begin
  result := nil;
  if (index = 0) or (index = 1) then
    exit(IBaseFilter(DspFilter));
end;

function Tother.GetMaxAmplification: Cardinal;
begin
  result := Integer(20000);
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    if Contains(StrMaxAmplification) then
      result := i[StrMaxAmplification];
  end;
  DCMaxAmplification := result;
  // result := DCDynamicAmplify.MaxAmplification;
end;

procedure Tother.SetMaxDB(const Value: Integer);
begin
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    i[StrMaxDB] := Value;
    WriteRegistry(DspRegistr, 'Equalizer', AsJSON);
  end;
  // WriteRegistry(DspRegistr, StrMaxDB, Integer(Value));
end;

function Tother.getMaxDB: Integer;
begin
  result := Integer(12);
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    if Contains(StrMaxDB) then
      result := i[StrMaxDB];
  end;
  // result := ReadRegistry(DspRegistr, StrMaxDB, Integer(12));
end;

function Tother.GetName: string;
begin
  exit(S_Dsp);
end;

function Tother.getPresets: string;
begin
  result := EQPresetNames[0];
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    if Contains(StrEQPresetName) then
      result := s[StrEQPresetName];
  end;
  // result := ReadRegistry(DspRegistr, StrEQPresetName, EQPresetNames[0]);
  if IndexStr(result, EQPresets) = -1 then
    result := EQPresets[0];
end;

procedure Tother.SetPresets(const Value: string);
begin
  with so(ReadRegistry(DspRegistr, 'Equalizer', '{}')) do
  begin
    s[StrEQPresetName] := Value;
    WriteRegistry(DspRegistr, 'Equalizer', AsJSON);
  end;
  // WriteRegistry(DspRegistr, StrEQPresetName, Value);
end;

procedure Tother.SetReleaseTime(const Value: Cardinal);
begin
  DCReleaseTime := Value;
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    i[StrReleaseTime] := Value;
    WriteRegistry(DspRegistr, 'DynamicAmplify', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrReleaseTime,Integer(DCDynamicAmplify.ReleaseTime));
end;

function Tother.GetReleaseTime: Cardinal;
begin
  result := Integer(3);
  with so(ReadRegistry(DspRegistr, 'DynamicAmplify', '{}')) do
  begin
    if Contains(StrReleaseTime) then
      result := i[StrReleaseTime];
  end;
  DCReleaseTime := result
  // ReadRegistry(DspRegistr, StrReleaseTime,  Integer(3));  result := DCDynamicAmplify.ReleaseTime;
end;

procedure Tother.SetAimEnable(aEnabled: boolean);
begin
  AEnabled := aEnabled;
  with XSuperObject.so(ReadRegistry(DspRegistr, 'Amplify', '{}')) do
  begin
    B[StrAimEnabled] := aEnabled;
    WriteRegistry(DspRegistr, 'Amplify', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrAimEnabled, DCAmplify.Enabled);
end;

function Tother.getAimEnabled: boolean;
begin
  result := True;
  with so(ReadRegistry(DspRegistr, 'Amplify', '{}')) do
  begin
    if Contains(StrAimEnabled) then
      result := B[StrAimEnabled];
    AEnabled := result;
  end
end;

procedure Tother.SetVolume(Channel: Byte; Volume: Integer);
begin
  if not InRange(Channel, 0, MaxChannels - 1) then
    exit;
  AVolume[Channel] := Volume;
  WriteRegistry(DspRegistr, StrAmplify, fVolume, SizeOf(fVolume));
end;

function Tother.GetVolume(Channel: Byte): Integer;
begin
  result := 0;
  if not InRange(Channel, 0, MaxChannels - 1) then
    exit;
  if ReadRegistry(DspRegistr, StrAmplify, fVolume, SizeOf(fVolume)) > 0 then
     result := AVolume[Channel]
  else
    result := 10000;
end;

procedure Tother.writePresentsEQ(name: string; const Value: TEQBandsVolume);
var
  fEQPreset: TEQBandsVolume;
  i: Byte;
begin
  fEQPreset := Value;
  for i := 0 to 9 do
    QBand[0, i] := Tspanel.MakeNdbEQ(0 - fEQPreset[i], MaxDB);
  WriteRegistry(DspRegistr + StrEQPresets, name, fEQPreset,
    SizeOf(TEQBandsVolume));
  EQPresetName := name;
end;

procedure Tother.WritePresetsDefault;
var
  i: Integer;
  fEQPreset: TEQBandsVolume;
  c: Integer;
begin
  for c := 0 to EQPresetCount - 1 do
  begin
    for i := 0 to 9 do
      fEQPreset[i] := EQPreset[c][i];
    WriteRegistry(DspRegistr + StrEQPresets, EQPresetNames[c], fEQPreset,
      SizeOf(fEQPreset));
  end;
end;

function Tother.GetEnableDelay: boolean;
begin
  result := false;
  with so(ReadRegistry(DspRegistr, 'Delay', '{}')) do
  begin
    if Contains(StrEnableDelay) then
      result := B[StrEnableDelay];
  end;
  // result:=ReadRegistry(DspRegistr, StrEnableDelay, false);
end;

function Tother.GetEQPresets: TArray<string>;
begin
  result := GetValueNames(DspRegistr + StrEQPresets);
  if Length(result) < 2 then
  begin
    WritePresetsDefault;
    result := GetValueNames(DspRegistr + StrEQPresets);
  end;
end;

function Tother.get_CurrentAmplification: Single;
begin
  result:=DCCurrentAmplification
end;

procedure Tother.GraphEvent(Event, Param1, Param2: Integer);
begin
  case Event of
    EC_COMPLETE:
      State := false;
  end;
end;

procedure Tother.ControlEvent(Event: TControlEvent; Param: Integer);
begin
  if Event = cePlay then
  begin
    State := True;
    exit;
  end;

  if (Event = ceActive) then
    if (Param = 0) then
    begin
      TChannels := 0;
      TFrequency := 0;
      TBits := 0;
      TFloat := false;
    end;
  State := false;
end;

procedure Tother.SetVisualEnable(aEnabled: boolean);
begin
  FVisualEnable := aEnabled;
  WriteRegistry(DspRegistr, StrVisStopped, VisualEnable);
end;

constructor Tother.Create(Controls: Ocontrols);
var
  i: Byte;
  // var
  // Registrs: TRegistry;
begin
  inherited Create;
  State := false;
  Tgraph := Controls;
  Tgraph.InsertFilter(self);
  Tgraph.InsertEventNotifier(self);
  fCriticalSection := TCriticalSection.Create;
  Flush;
  DCSpectrum := TDCSpectrum.Create;
  DCEnabled := True;
  DCSpectrum.Logarithmic := false;
  DCSpectrum.WindowMode := wmHanning;
  GetMaxAmplification;
  GetReleaseTime;
  getAttackTime;
  GetDynEnabled;
  getAimEnabled;
  Equalizer := Equalizer;

  FVisualEnable := ReadRegistry(DspRegistr, StrVisStopped, True);

  EnableAudioDelay := ReadRegistry(DspRegistr, StrEnableDelay, false);
  AudioDelay := ReadRegistry(DspRegistr, StrDelay, 0);

  for i := 0 to MaxChannels - 1 do
    AmplifyVolume[i] := AmplifyVolume[i];

  // EqualizerBand[0, I] := Tspanel.MakeNdbEQ(0 - ReadPresets(EQPresetName)
  // [I], MaxDB);
end;

procedure Tother.DeleteEqalizerPresets(name: string);
begin
  DeleteValue(DspRegistr + StrEQPresets, Name);
end;

destructor Tother.Destroy;
begin
  FreeandNil(fCriticalSection);
  FreeandNil(DCSpectrum);
  if Assigned(Tgraph) then
  begin
    Tgraph.RemoveFilter(self);
    Tgraph.RemoveEventNotifier(self);
  end;
  inherited Destroy;
end;

function Tother.PCMDataCB(Buffer: Pointer; Length: Integer;
out NewSize: Integer; Stream: PDSStream): HRESULT; stdcall;
begin
  fCriticalSection.Enter;
  try
    Flush;
    TChannels := Stream.Channels;
    TFrequency := Stream.Frequency;
    TBits := Stream.Bits;
    TFloat := Stream.Float;
    Process(Buffer, Length,Stream.Frequency,  Stream.Bits, Stream.Channels, Stream.Float);
    NewSize := Length;
  finally
    fCriticalSection.Leave;
  end;


  result := s_ok;
end;

function Tother.ReadPresets(name: string): TEQBandsVolume;
begin
  if ReadRegistry(DspRegistr + StrEQPresets, name, result,
    SizeOf(TEQBandsVolume)) <> SizeOf(TEQBandsVolume) then
    FillChar(result, SizeOf(TEQBandsVolume), 0);

  if IndexStr(name, EQPresets) = -1 then
    EQPresetName := EQPresets[0];
end;

function Tother.MediaTypeChanged(Stream: PDSStream): HRESULT; stdcall;
begin
  result := s_ok;
end;

procedure Tother.NotifyFilter(operation: TFilterOperation; Param: Integer);
var
  HR: HRESULT;
begin
  case operation of
    foAdding:
      if Param = 1 then
      begin
        DspFilter := TDSAudioFilter.Create('DSP', nil, HR);
        DspFilter.set_Delay(AudioDelay);
        DspFilter.set_EnableDelay(EnableAudioDelay);
      end;
    foAdded:
      if Param = 1 then
        if Assigned(DspFilter) then
          (IBaseFilter(DspFilter) as IDSPackDCDSPFilterInterface)
            .set_CallBackPCM(self);
    foRemoving:
      if Assigned(DspFilter) then
        (IBaseFilter(DspFilter) as IDSPackDCDSPFilterInterface)
          .set_CallBackPCM(nil);
    foRemoved:
      DspFilter := nil;
  end;
end;

function Tother.Flush: HRESULT; stdcall;
begin
  result := s_ok;
end;

{ TAudioRender }

constructor TAudioRender.Create(Controls: Ocontrols);
begin
  AControls := Controls;
  AControls.InsertFilter(self);
end;

destructor TAudioRender.Destroy;
begin
  AControls.RemoveFilter(self);
  inherited;
end;

function TAudioRender.GetFilter(index: Integer): IBaseFilter;
begin
  if (index = 0) or (index = 2) then
  begin
    result := AControls.StrToFilter(string(AControls.AudioRender.FriendlyName));
    if Assigned(result) then
      exit(result)
    else
      exit(LoadFilter(AControls.AudioRender.clsid));
  end;
end;

function TAudioRender.GetName: string;
begin
  result := string(AControls.AudioRender.FriendlyName);
end;

procedure TAudioRender.NotifyFilter(operation: TFilterOperation;
Param: Integer);
begin

end;

initialization

finalization

end.
