//
// ***************************************************************************//
{
  Saz SDK multimedia cameta.ucoz.com
  //IAMStreamSelect
  Windows.GetClientRect(pnlVideo.Handle, rcWnd);
  http://msdn.microsoft.com/en-us/library/windows/desktop/dd375642(v=vs.85).aspx
  CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IAMStreamSelect, IAMStreamSelect)
  on dvd icon trays?
  //
}
unit DshowU;

interface

uses Classes, DirectShow9, ActiveX, windows, sysUtils, Messages, dialogs,
  Controls, ComCtrls, forms, Direct3D9, DSUtils, EVR9, Winapi.MMSystem,
  Cameta_const;

const

  MEDIATYPE_Subtitle: tguid = '{E487EB08-6B26-4BE9-9DD3-993434D313FD}';
  { @exclude }

Procedure CoFreeUnusedLibrariesEx(dwUnloadDelay: Dword; dwReserved: Dword);
  stdcall; external 'ole32.dll';

type

  TPropertyPage = (ppDefault, ppVFWCapDisplay, ppVFWCapFormat, ppVFWCapSource,
    ppVFWCompConfig, ppVFWCompAbout);

  TOnDSEvent = procedure(sender: TComponent; Event, Param1, Param2: Integer)
    of object;
  { @exclude }
  TOnGraphBufferingData = procedure(sender: TObject; Buffering: boolean)
    of object; { @exclude }
  TOnGraphComplete = procedure(sender: TObject; Result: HRESULT;
    Renderer: IBaseFilter) of object; { @exclude }
  TOnGraphDeviceLost = procedure(sender: TObject; Device: IUnknown;
    Removed: boolean) of object; { @exclude }
  TOnGraphEndOfSegment = procedure(sender: TObject; StreamTime: TReferenceTime;
    NumSegment: Cardinal) of object; { @exclude }
  TOnDSResult = procedure(sender: TObject; Result: HRESULT) of object;
  { @exclude }
  TOnGraphFullscreenLost = procedure(sender: TObject; Renderer: IBaseFilter)
    of object; { @exclude }
  TOnGraphOleEvent = procedure(sender: TObject; String1, String2: WideString)
    of object; { @exclude }
  TOnGraphOpeningFile = procedure(sender: TObject; opening: boolean) of object;
  { @exclude }
  TOnGraphSNDDevError = procedure(sender: TObject; OccurWhen: TSndDevErr;
    ErrorCode: LongWord) of object; { @exclude }
  TOnGraphStreamControl = procedure(sender: TObject; PinSender: IPin;
    Cookie: LongWord) of object; { @exclude }
  TOnGraphStreamError = procedure(sender: TObject; Operation: HRESULT;
    Value: LongWord) of object; { @exclude }
  TOnGraphVideoSizeChanged = procedure(sender: TObject; Width, height: word)
    of object; { @exclude }
  TOnGraphTimeCodeAvailable = procedure(sender: TObject; From: IBaseFilter;
    DeviceID: LongWord) of object; { @exclude }
  TOnGraphEXTDeviceModeChange = procedure(sender: TObject;
    NewMode, DeviceID: LongWord) of object; { @exclude }
  // TOnGraphVMRRenderDevice      = procedure(sender: TObject; RenderDevice: TVMRRenderDevice) of object;
  { @exclude }
  TOnDVDAudioStreamChange = procedure(sender: TObject; stream, lcid: Integer;
    Lang: string) of object; { @exclude }
  TOnDVDCurrentTime = procedure(sender: TObject;
    Hours, minutes, seconds, frames, frate: Integer) of object; { @exclude }
  TOnDVDTitleChange = procedure(sender: TObject; title: Integer) of object;
  { @exclude }
  TOnDVDChapterStart = procedure(sender: TObject; chapter: Integer) of object;
  { @exclude }
  TOnDVDValidUOPSChange = procedure(sender: TObject; UOPS: Integer) of object;
  { @exclude }
  TOnDVDChange = procedure(sender: TObject; total, current: Integer) of object;
  { @exclude }
  TOnDVDStillOn = procedure(sender: TObject; NoButtonAvailable: boolean;
    seconds: Integer) of object; { @exclude }
  TOnDVDSubpictureStreamChange = procedure(sender: TObject;
    SubNum, lcid: Integer; Lang: string) of object; { @exclude }
  TOnDVDPlaybackRateChange = procedure(sender: TObject; rate: single) of object;
  { @exclude }
  TOnDVDParentalLevelChange = procedure(sender: TObject; level: Integer)
    of object; { @exclude }
  TOnDVDAnglesAvailable = procedure(sender: TObject; available: boolean)
    of object; { @exclude }
  TOnDVDButtonAutoActivated = procedure(sender: TObject; Button: Cardinal)
    of object; { @exclude }
  TOnDVDCMD = procedure(sender: TObject; CmdID: Cardinal) of object;
  { @exclude }
  TOnDVDCurrentHMSFTime = procedure(sender: TObject;
    HMSFTimeCode: TDVDHMSFTimeCode; TimeCode: TDVDTimeCode) of object;
  { @exclude }
  TOnDVDKaraokeMode = procedure(sender: TObject; Played: boolean) of object;
  { @exclude }
  TOnBuffer = procedure(sender: TObject; SampleTime: Double; pBuffer: Pointer;
    BufferLen: longint) of object;

  TOnSelectedFilter = function(Moniker: IMoniker; FilterName: WideString;
    ClassID: tguid): boolean of Object;
  TOnCreatedFilter = function(Filter: IBaseFilter; ClassID: tguid)
    : boolean of Object;
  TOnUnableToRender = function(Pin: IPin): boolean of Object;
  TNotifyEventA = procedure(sender: TObject; FActive: boolean) of object;

  TONdecoders = function(EnumMediaType: IEnumMediaType; var index: Integer;
    var Count: Integer): IBaseFilter;

type
  TSterampinItem = packed record
    index: Byte;
    StreamName: String;
    Guid: tguid;
    OnConnect: boolean;
  end;

  TGraphState = (gsUninitialized, gsStopped, gsPaused, gsPlaying);

  { @exclude }
  TFilterOperation = (foAdding, // Before the filter is added to graph.
    foAdded, // After the filter is added to graph.
    foRemoving, // Before the filter is removed from graph.
    foRemoved, // After the filter is removed from graph.
    foRefresh // Designer notification to Refresh the filter .
    );

  { @exclude }
  IFilter = interface
    ['{887F94DA-29E9-44C6-B48E-1FBF0FB59878}']
    { Return the IBaseFilter Interface (All DirectShow filters expose this interface). }
    function GetFilter(index: Integer): IBaseFilter;
    { Return the filter name (generally the component name). }
    function GetName: string;
    { Called by the @link(TFilterGraph) component, this method receive notifications
      on what the TFilterGraph is doing. if Operation = foGraphEvent then Param is the
      event code received by the FilterGraph. }
    procedure NotifyFilter(Operation: TFilterOperation; Param: Integer = 0);
  end;

  // ******************************************************************************
  { @exclude }
  TControlEvent = (cePlay, cePause, ceStop, ceFileRendering, ceFileRendered,
    ceDVDRendering, ceDVDRendered, ceActive);

  { @exclude }
  IEvent = interface
    ['{6C0DCD7B-1A98-44EF-A6D5-E23CBC24E620}']
    { FilterGraph events. }
    procedure GraphEvent(Event, Param1, Param2: Integer);
    { Control Events. }
    procedure ControlEvent(Event: TControlEvent; Param: Integer = 0);
  end;


  // Igraph

  IGEtEnumFilter = record
  private
    GetCurrent: IBaseFilter;
    function GetFilterInfo: TFilterInfo;
    function getLast: IBaseFilter;
  public
    EnumFilters: IEnumFilters;
    function MoveNext: boolean;
    property current: IBaseFilter read GetCurrent;
    property FilterInfo: TFilterInfo read GetFilterInfo;
    property Last: IBaseFilter read getLast;
  end;

  Igraph = class(TComponent, IAMGraphBuilderCallback, IAMFilterGraphCallback,
    IServiceProvider)
  private
    pfg: IGraphBuilder;
    FFilters: TInterfaceList;
    FGraphEvents: TInterfaceList;
    // All Events Code
    FOnDSEvent: TOnDSEvent;
    // IdGraphBuilder: Integer;
    // FDVDGraph: IDvdGraphBuilder;
    // pfg2: ICaptureGraphBuilder2;
    // FDvdGraph: IDvdGraphBuilder;
    FOnSelectedFilter: TOnSelectedFilter;
    FOnCreatedFilter: TOnCreatedFilter;
    FOnUnableToRender: TOnUnableToRender;
    FMediaEventEx: IMediaEventEx;
    FActive: boolean;
    fpos: Integer;
    fvolume: Integer;
    IBalance: Integer;
    frate: Double;
    on_change: boolean;
    FLogFileName: String;
    FLogFile: TFileStream;
    ObjectHandle: THandle;
    _GetDecoder: TONdecoders;
    EnumFilters: IEnumFilters;
    function ConnectSubtitle(Pin: IPin): boolean;
    function ConnectDecoder(Filter: IBaseFilter;
      Strems: TArray<Integer>): HRESULT;
    function Connect(Filter: IBaseFilter; Pin: IPin): HRESULT;
    function Audio_ConnectDecoder(const tmp: IPin;
      const pClock: IReferenceClock): HRESULT;
    procedure ClearOwnFilters;
    function AddOwnFilters(index: Integer): IBaseFilter;
    function GetCurrentPosition: Integer;
    procedure SetPositions(const Value: Integer);
    procedure set_soundlevel(Value: Integer);
    function GetState: TGraphState;
    procedure SetBalance(Value: Integer);
    procedure SetActive(Activate: boolean);
    procedure UpdateGraph;
    function UnableToRender(ph1, ph2: Integer; pPin: IPin): HRESULT;
    function SelectedFilter(pMon: IMoniker): HRESULT; stdcall;
    function CreatedFilter(pFil: IBaseFilter): HRESULT; stdcall;
    procedure put_Visible(Visible: boolean);
    function get_Visible: boolean;
    procedure HandleEvents;
    procedure WndProc(var Msg: TMessage);
    procedure SetLogFile(FileName: String);
    procedure DisconnectFilters;
    procedure GraphEvents(Event, Param1, Param2: Integer);
    function reconnectstream(const pin1, pin2: IPin;
      const TypeGUID: tguid): HRESULT;
    procedure DisconnectFilter(const Filter: IBaseFilter);
    procedure SetStream(index: Integer; item: TSterampinItem);
    function GetPinInfo(const pinl: IPin): TSterampinItem;
    function GetStream(index: Integer): TSterampinItem;
    function GetDuration: Cardinal; virtual;
  strict protected
    procedure DoEvent(Event, Param1, Param2: Integer); virtual;
    procedure ControlEvents(Event: TControlEvent; Param: Integer = 0); virtual;
    function QueryService(const rsid, iid: tguid; out Obj): HRESULT; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { @exclude }
    procedure InsertEventNotifier(AEvent: IEvent);
    { @exclude }
    procedure RemoveEventNotifier(AEvent: IEvent);
    { @exclude }
    procedure InsertFilter(AFilter: IFilter);
    { @exclude }
    procedure RemoveFilter(AFilter: IFilter);
    { @exclude }
    function QueryInterface(const iid: tguid; out Obj): HRESULT;
      override; stdcall;
    function GetEnumerator: IGEtEnumFilter;
    property LogFile: String read FLogFileName write SetLogFile;
    function RenderFileEx(Strems: TArray<Integer>): HRESULT;
    property GetDecoder: TONdecoders read _GetDecoder write _GetDecoder;
    property OnDSEvent: TOnDSEvent read FOnDSEvent write FOnDSEvent;
    property position: Integer read GetCurrentPosition write SetPositions;
    property video_visible: boolean read get_Visible write put_Visible;
    property Volume: Integer read fvolume write set_soundlevel;
    property State: TGraphState read GetState;
    property balance: Integer read IBalance write SetBalance;
    property active: boolean read FActive write SetActive;
    property ListStream[index: Integer]: TSterampinItem read GetStream;
    function EnableStream(index: Integer): boolean;
    function StreamCount: Integer;
    // function WaveFormatEx: sst;
    function Play: boolean;
    function Pause: boolean;
    function Stop: boolean;
    procedure ClearGraph;
    function CountFilter: Integer;
    function RemoveFilters(Filter: IBaseFilter): HRESULT; overload;
    function RemoveFilters(const Value: string): HRESULT; overload;
    function StrToFilter(const Value: string): IBaseFilter;
    function AddFilter(const pFilter: IBaseFilter;
      const pName: pwidechar): HRESULT;
    function AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: LPCWSTR;
      out ppFilter: IBaseFilter): HRESULT;
    // property hidecursor: boolean read GetHideCursor write SetHideCursor;
    // property rate: Double read getrate write SetRate;
    // function RenderStream(pCategory, pType: PGUID; pSource: IUnknown;
    // pfCompressor, pfRenderer: IBaseFilter): HRESULT;
  end;

implementation

uses Math, System.Generics.Collections;

const
  CLSID_FilterGraphCallback: tguid = '{C7CAA944-C191-4AB1-ABA7-D8B40EF4D5B2}';
  MEDIASUBTYPE_as: tguid = '{00000001-0000-0010-8000-00AA00389B71}';

  { procedure ParseLanguageOggSplitter(Filter: IBaseFilter);
    var
    iSS : IAMStreamSelect;
    cnt : Cardinal;
    //  pmt : PAMMediaType;
    //  Flags : Cardinal;
    //  LCID : Cardinal;
    //  Group : Cardinal;
    //  Obj : IUnknown;
    //  Unk : IUnknown;
    //  i : integer;
    //  Name : PWChar;
    //  Buff : array[0..MAX_PATH-1] of Char;
    //  lName : WideString;
    //  c1: integer;
    begin
    try
    if Filter.QueryInterface(IID_IAMStreamSelect,iSS) = S_OK then

    iSS.Count(cnt);

    finally
    iSS:=nil;
    end;
    end;
  }

function LEnumMediaType(Pin: IPin): IEnumMediaType;
begin
  Result := TEnumMediaType.Create(Pin);
end;

procedure Igraph.InsertEventNotifier(AEvent: IEvent);
begin
  if FGraphEvents = nil then
    FGraphEvents := TInterfaceList.Create;
  FGraphEvents.Add(AEvent);
end;

procedure Igraph.InsertFilter(AFilter: IFilter);
// var FilterName: WideString;
begin
  if FFilters = nil then
    FFilters := TInterfaceList.Create;
  FFilters.Add(AFilter);
  // if active then
  // begin
  // AFilter.NotifyFilter(foAdding,index);
  // FilterName := AFilter.GetName;
  // AddFilter(AFilter.GetFilter, PWideChar(FilterName));
  // AFilter.NotifyFilter(foAdded,index);
  // end;
end;

procedure Igraph.RemoveEventNotifier(AEvent: IEvent);
begin
  if FGraphEvents <> nil then
  begin
    FGraphEvents.Remove(AEvent);
    if FGraphEvents.Count = 0 then
      FreeAndNil(FGraphEvents);
  end;
end;

function Igraph.RemoveFilters(const Value: string): HRESULT;
begin
  Result := RemoveFilters(StrToFilter(Value))
end;

procedure Igraph.RemoveFilter(AFilter: IFilter);
begin
  FFilters.Remove(AFilter);
  // if active then
  // begin
  // AFilter.NotifyFilter(foRemoving);
  // RemoveFilters(AFilter.GetFilter);
  // AFilter.NotifyFilter(foRemoved);
  // end;
  if FFilters.Count = 0 then
    FreeAndNil(FFilters);
end;

procedure Igraph.ControlEvents(Event: TControlEvent; Param: Integer = 0);
var
  i: IInterface;
begin
  if FGraphEvents <> nil then
    for i in FGraphEvents do
      IEvent(i).ControlEvent(Event, Param);
end;

function Igraph.CountFilter: Integer;
begin
  if GetEnumerator.MoveNext then
    Result := 1
  else
    Result := 0;

end;

procedure Igraph.GraphEvents(Event, Param1, Param2: Integer);
var
  i: IInterface;
begin
  if FGraphEvents <> nil then
    for i in FGraphEvents do
      IEvent(i).GraphEvent(Event, Param1, Param2);
end;

function Igraph.RemoveFilters(Filter: IBaseFilter): HRESULT;
begin
  if (Filter = nil) and (pfg = nil) then
    exit(e_POINTER);
  Result := pfg.RemoveFilter(Filter);
end;

procedure Igraph.DisconnectFilter;
var
  Pin: IPin;
begin
  for Pin in ArrayGetPin(Filter, [PINDIR_INPUT, PINDIR_OUTPUT], false) do
    with self as IFilterGraph do
      Disconnect(Pin);
end;

function Igraph.ConnectSubtitle(Pin: IPin): boolean;
var
  INPin: IPin;
begin
  Result := false;
  for INPin in ArrayGetPin(StrToFilter(SubtitlesFilterName),
    [PINDIR_INPUT], true) do
    if Pin.Connect(INPin, nil) = s_ok then
    begin
      exit(true);
    end;
  if not Result then
    RemoveFilters(SubtitlesFilterName);
end;

function Igraph.Audio_ConnectDecoder(const tmp: IPin;
  const pClock: IReferenceClock): HRESULT;
var
  counts, i: Integer;
  tmpFilter: IBaseFilter;
begin
  i := 0;
  counts := 1;
  while i < counts do
  begin
    with LEnumMediaType(tmp) do
    begin
      tmpFilter := _GetDecoder(EnumMediaType, i, counts);
      AddFilter(tmpFilter, 'Audio Decoder');
      Result := tmp.Connect(GetInPin(tmpFilter, 0), nil);
      if Result = s_ok then
        break
      else
        RemoveFilters(tmpFilter);
    end;
  end;

  tmpFilter.SetSyncSource(pClock);
  // DisconnectFilter(StrToFilter(S_Dsp));
  // DisconnectFilter(StrToFilter(string(fSound_render.FriendlyName)));
  Result := ConnectFilter(pfg, [tmpFilter, StrToFilter(S_Dsp)]);
end;

function Igraph.reconnectstream(const pin1, pin2: IPin;
  const TypeGUID: tguid): HRESULT;
var
  tmp: IPin;
  pInfo: TPinInfo;
  pClock: IReferenceClock;
  i: Integer;
begin
  Result := s_false;
  with LEnumMediaType(pin1) do
  begin
    for i := 0 to Count - 1 do
      if IsEqualGUID(Items[i].majortype, TypeGUID) then
      begin
        pin1.ConnectedTo(tmp);
        if not Assigned(tmp) then
          exit;
        tmp.QueryPinInfo(pInfo);
        if not Assigned(pInfo.pFilter) then
          exit;
        pInfo.pFilter.GetSyncSource(pClock);
        tmp.Disconnect;
        pin1.Disconnect;
        Result := pin2.Connect(tmp, nil);
        if Result = s_ok then
          exit;
        DisconnectFilter(pInfo.pFilter);
        RemoveFilters(pInfo.pFilter);
        Result := Audio_ConnectDecoder(pin2, pClock);
      end;
  end;
end;

procedure Igraph.SetStream(index: Integer; item: TSterampinItem);
var
  pinl: TArray<IPin>;
  y: IPin;
  _Source: TFunc<IBaseFilter>;
  GetConnected: TFunc<IPin, boolean>;
  AMStreamSelect: IAMStreamSelect;
  iMS: IMediaSeeking;
  Poss: Int64;
  FState: TFilterState;
  FSource: IBaseFilter;

begin

  GetConnected := function(Pin: IPin): boolean
    var
      TPin: IPin;
    begin
      Pin.ConnectedTo(TPin);
      Result := (Pin <> nil);
    end;

  if (item.OnConnect) then
    exit();

  _Source := function: IBaseFilter
    begin
      Result := StrToFilter('Spliter');
      if not Assigned(Result) then
      begin
        with GetEnumerator do
          Result := IBaseFilter(Last);
      end;
    end;

  FSource := _Source;
  if Succeeded(FSource.QueryInterface(IID_IAMStreamSelect, AMStreamSelect)) and
    Succeeded(AMStreamSelect.Enable(Index, AMSTREAMSELECTENABLE_ENABLE)) then
    exit;

  (pfg as IMediaControl).GetState(0, FState);

  QueryInterface(IID_IMediaSeeking, iMS);
  if Assigned(iMS) then
    iMS.GetCurrentPosition(Poss);

  case FState of
    State_Paused, State_Running:
      (pfg as IMediaControl).Stop;
end;

pinl := ArrayGetPin(FSource, [PINDIR_OUTPUT], false);
for y in pinl do
  if GetConnected(y) then
    if reconnectstream(y, pinl[item.index], item.Guid) = s_ok then
      break;

if Assigned(iMS) then
begin
  iMS.SetPositions(Poss, AM_SEEKING_AbsolutePositioning, Poss,
    AM_SEEKING_NoPositioning);
  iMS := nil;
end;

case FState of
  State_Paused:
    (pfg as IMediaControl).Pause;
  State_Running:
    (pfg as IMediaControl).Run;
end;
end;

function Igraph.GetPinInfo;
begin
  with LEnumMediaType(pinl), GetEnumerator do
    while MoveNext do
      with Result, current do
      begin
        StreamName := GetMediaTypeDescriptions_(AMMediaType);
        case IndexGUID(AMMediaType.subtype, [MEDIASUBTYPE_MPEG2_VIDEO,
          MEDIASUBTYPE_DOLBY_AC3]) of
          0:
            Guid := MEDIATYPE_Video;
          1:
            Guid := MEDIATYPE_Audio;
        else
          Guid := majortype;
        end;
        break;
      end;
end;

function Igraph.GetStream(index: Integer): TSterampinItem;
var
  pinl: TPinList;
  _Source: TFunc<IBaseFilter>;
  FSource: IBaseFilter;
  tt: IAMStreamSelect;
  ppmt: PAMMediaType;
  pdwFlags: Dword;
  plcid: lcid;
  pdwGroup: Dword;
  ppszName: PWCHAR;
  ppObject: IUnknown;
  ppUnk: IUnknown;
begin

  _Source := function: IBaseFilter
    begin
      Result := StrToFilter('Spliter');
      if not Assigned(Result) then
      begin
        with GetEnumerator do
          Result := IBaseFilter(Last);
      end;
    end;
  FSource := _Source;

  if (FSource.QueryInterface(IID_IAMStreamSelect, tt) = s_ok) and
    Succeeded(tt.Info(index, ppmt, pdwFlags, plcid, pdwGroup, ppszName,
    ppObject, ppUnk)) then
  begin
    Result.index := index;
    Result.StreamName := string(ppszName);
    Result.OnConnect := pdwFlags = 3;
    case pdwGroup of
      0:
        Result.Guid := MEDIATYPE_Video;
      1:
        Result.Guid := MEDIATYPE_Audio;
      2:
        Result.Guid := MEDIATYPE_Text;
    end;
    exit;
  end;

  pinl := TPinList.Create(FSource);
  try
    Result := GetPinInfo(pinl[index]);
    Result.OnConnect := pinl.Connected[index];
    Result.StreamName := string(pinl.PinInfo[index].achName).Trim + ' ' +
      Result.StreamName;
    Result.index := index;
  finally
    FreeAndNil(pinl);
  end;

end;

{
  function Igraph.CheckMediaType(MediaType: PAMMediaType): boolean;
  begin
  if (MediaType = nil) then
  exit(false);

  if not IsEqualGUID(MediaType.majortype, MEDIATYPE_Audio) or
  (not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_PCM) and
  not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_IEEE_FLOAT) and
  not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_DOLBY_AC3_SPDIF) and
  not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_RAW_SPORT) and
  not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_SPDIF_TAG_241h) and
  not IsEqualGUID(MediaType.subtype, MEDIASUBTYPE_DRM_Audio)) or
  not IsEqualGUID(MediaType.formattype, FORMAT_WaveFormatEx) then
  exit(false);
  Result := true;
  end; }

function Igraph.Connect(Filter: IBaseFilter; Pin: IPin): HRESULT;
var
  INPin: IPin;
begin
  Result := s_false;
  if Assigned(Pin) then
    for INPin in ArrayGetPin(Filter, [PINDIR_INPUT], true) do
    begin
      Result := Pin.Connect(INPin, nil);
      if Result = s_ok then
        exit();
    end;

  if not Result = s_ok then
    RemoveFilters(Filter);
end;

function MapsTGUID(MediaType: TMediaType): tguid;
begin
  if MediaType.majortype = MEDIATYPE_DVD_ENCRYPTED_PACK then
  begin
    if MEDIASUBTYPE_MPEG2_VIDEO = MediaType.subtype then
      Result := (MEDIATYPE_Video);
    if MEDIASUBTYPE_DOLBY_AC3 = MediaType.subtype then
      Result := (MEDIATYPE_Audio);
  end
  else if MediaType.majortype = MEDIATYPE_Stream then
  begin
    if MEDIASUBTYPE_WAVE = MediaType.subtype then
      Result := (MEDIATYPE_Audio);
  end
  else if MEDIASUBTYPE_as = MediaType.subtype then
    Result := (MEDIASUBTYPE_as)
  else
    Result := MediaType.majortype;
end;

Procedure select(Filter: IBaseFilter; Strems: TArray<Integer>;
  TPin: TDictionary<tguid, IPin>);
begin
  EnumPins(Filter, Strems,
    procedure(Pin: IPin)
    begin
      with LEnumMediaType(Pin) do
      begin
        with GetEnumerator do
          while MoveNext do
          begin
            if MEDIASUBTYPE_DVD_SUBPICTURE <> current.subtype then
              if not TPin.ContainsKey(MapsTGUID(current)) then
                TPin.Add(MapsTGUID(current), Pin);
            break;
          end;
      end;
    end);
end;

function Igraph.ConnectDecoder;
const
  MEDIATYPE_Subtitle: tguid = '{E487EB08-6B26-4BE9-9DD3-993434D313FD}';
var
  TPin: TDictionary<tguid, IPin>;
  Guid: tguid;
  decordF: IBaseFilter;
  counts: Integer;
  i: Integer;
  Render: IBaseFilter;
begin
  Result := s_false;

  counts := 1;
  i := 0;
  TPin := TDictionary<tguid, IPin>.Create;
  try
    if not Assigned(Filter) then
      with GetEnumerator do
        Filter := IBaseFilter(Last);

    select(Filter, Strems, TPin);
    // ******************************************
    if TPin.ContainsKey(MEDIASUBTYPE_as) and (TPin.Count = 1) then
    begin
      Render := AddOwnFilters(2);
      if not Assigned(Render) then
        exit(s_false);
      Result := ConnectFilter(pfg, [Filter, AddOwnFilters(1), Render]);
      if Result = s_ok then
        exit(s_ok);
    end;
    // ******************************************
    if TPin.ContainsKey(MEDIATYPE_Subtitle) then
    begin
      with LEnumMediaType(TPin.Items[MEDIATYPE_Subtitle]) do
      begin
        AddFilter(_GetDecoder(EnumMediaType, i, counts), SubtitlesFilterName);
        if ConnectSubtitle(TPin.Items[MEDIATYPE_Subtitle]) then
          TPin.Remove(MEDIATYPE_Subtitle)
        else
          RemoveFilters(SubtitlesFilterName);
      end;
    end;
    // ******************************************

    for Guid in TPin.Keys do
    begin
      while i < counts do
      begin
        with LEnumMediaType(TPin.Items[Guid]) do
        begin
          decordF := _GetDecoder(EnumMediaType, i, counts);
          if not Assigned(decordF) then
            break;
        end;
        AddFilter(decordF, 'Decoder');
        Result := Connect(decordF, TPin.Items[Guid]);
        // GetErrorString(Result);
        if Result <> s_ok then
        begin
          inc(i);
          RemoveFilters(decordF);
          decordF := nil;
        end
        else
          break;
      end;

      // ******************************************
      if (Guid = MEDIATYPE_Audio) and Assigned(decordF) then
      begin
        Render := AddOwnFilters(2);
        if Assigned(Render) then
          Result := ConnectFilter(pfg, [decordF, AddOwnFilters(1), Render])
        else
          Result := s_false;
      end;

      // ******************************************
      if (Guid = MEDIATYPE_Video) and Assigned(decordF) then
      begin
        Render := AddOwnFilters(3);
        if Assigned(Render) then
          Result := ConnectFilter(pfg,
            [decordF, StrToFilter(SubtitlesFilterName), Render])
        else
          Result := s_false;
      end;

      i := 0;
      TPin.Remove(Guid);
    end;

  finally
    Render := nil;
    FreeAndNil(TPin);
  end;
end;

// function Igraph.RenderStream(pCategory, pType: PGUID; pSource: IUnknown;
// pfCompressor, pfRenderer: IBaseFilter): HRESULT;
// begin
// Result := s_false;
// if Assigned(pfg2) then
// Result := pfg2.RenderStream(pCategory, pType, pSource, pfCompressor,
// pfRenderer);
// end;

function Igraph.AddFilter;
begin
  Result := s_false;
  if Assigned(pfg) and (Assigned(pFilter)) then
    Result := pfg.AddFilter(pFilter, pName);
end;

function Igraph.StrToFilter;
begin
  Result := nil;
  if Assigned(pfg) then
    pfg.FindFilterByName(StringToOleStr(Value), Result);
end;

function Igraph.AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: LPCWSTR;
out ppFilter: IBaseFilter): HRESULT;
begin
  Result := IFilterGraph2(pfg).AddSourceFilter(lpcwstrFileName,
    lpcwstrFilterName, ppFilter);
  // GetErrorString(Result);
end;

function Igraph.RenderFileEx(Strems: TArray<Integer>): HRESULT;
var
  FSource: TFunc<IBaseFilter>;
  // PinList: TPinList;
  // i: Integer;
begin
  FSource := function: IBaseFilter
    begin
      Result := nil;
      Result := self.StrToFilter('Spliter');
      if Assigned(Result) then
        exit;
      with GetEnumerator do
        Result := IBaseFilter(Last);
    end;

  ControlEvents(ceFileRendering);
  Result := s_false;

  try

    Result := ConnectDecoder(FSource, Strems);

    { PinList := TPinList.Create(FSource);
      try
      for i := 0 to PinList.Count - 1 do
      begin
      if not PinList.Connected[i] then
      begin
      Result := IFilterGraph2(pfg).RenderEx(PinList.Items[i],
      AM_RENDEREX_RENDERTOEXISTINGRENDERERS, nil);
      if failed(Result) then
      break;
      end;
      end;
      finally
      PinList.Free;
      end; }
  finally
    UpdateGraph;
    ControlEvents(ceFileRendered, Result);
  end;
end;

function Igraph.SelectedFilter(pMon: IMoniker): HRESULT; stdcall;
var
  PropBag: IPropertyBag;
  name: OleVariant;
  vGuid: OleVariant;
  Guid: tguid;
begin
  if Assigned(FOnSelectedFilter) then
  begin
    pMon.BindToStorage(nil, nil, IID_IPropertyBag, PropBag);
    if PropBag.Read('CLSID', vGuid, nil) = s_ok then
      Guid := StringtoGUID(vGuid)
    else
      Guid := GUID_NULL;
    if PropBag.Read('FriendlyName', Name, nil) <> s_ok then
      Name := '';

    PropBag := nil;

    if FOnSelectedFilter(pMon, Name, Guid) then
      Result := s_ok
    else
      Result := E_FAIL;
  end
  else
    Result := s_ok;
end;

function Igraph.CreatedFilter(pFil: IBaseFilter): HRESULT; stdcall;
var
  Guid: tguid;
begin
  if Assigned(FOnCreatedFilter) then
  begin
    pFil.GetClassID(Guid);
    if FOnCreatedFilter(pFil, Guid) then
      Result := s_ok
    else
      Result := E_FAIL;
  end
  else
    Result := s_ok;
end;

function Igraph.UnableToRender(ph1, ph2: Integer; pPin: IPin): HRESULT;
var
  graph: Igraph;
  PinInfo: TPinInfo;
  FilterInfo: TFilterInfo;
  serviceProvider: IServiceProvider;
begin
  Result := s_false;

  if (pPin.QueryPinInfo(PinInfo) = s_ok) and (Assigned(PinInfo.pFilter)) and
    (PinInfo.pFilter.QueryFilterInfo(FilterInfo) = s_ok) and
    (Assigned(FilterInfo.pGraph)) and
    (FilterInfo.pGraph.QueryInterface(IServiceProvider, serviceProvider) = s_ok)
    and (serviceProvider.QueryService(CLSID_FilterGraphCallback,
    CLSID_FilterGraphCallback, graph) = s_ok) and
    (Assigned(graph) and Assigned(graph.FOnUnableToRender)) and
    (graph.FOnUnableToRender(pPin)) then
    Result := s_ok;

  PinInfo.pFilter := nil;
  FilterInfo.pGraph := nil;
  serviceProvider := nil;
end;

function Igraph.QueryService(const rsid, iid: tguid; out Obj): HRESULT;
begin
  if IsEqualGUID(CLSID_FilterGraphCallback, rsid) and
    IsEqualGUID(CLSID_FilterGraphCallback, iid) then
  begin
    Pointer(Obj) := Pointer(self);
    Result := s_ok;
  end
  else
    Result := E_NOINTERFACE;
end;

procedure Igraph.UpdateGraph;
begin
  // TThread.Synchronize(nil,
  // procedure
  // begin
  // UpdateVideo;
  set_soundlevel(fvolume);
  SetBalance(IBalance);
  // SetRate(frate);
  // SetVideoPosition(VideoPosition);
  // end);
end;

procedure Igraph.DisconnectFilters;
begin
  with GetEnumerator do
    while MoveNext do
      DisconnectFilter(current);
end;

procedure Igraph.ClearGraph;

begin
  if Assigned(pfg) then
  begin
    DisconnectFilters;
    ClearOwnFilters;
    with GetEnumerator do
      while MoveNext do
        CheckDSError(RemoveFilters(IBaseFilter(current)));
  end;
end;

procedure Igraph.ClearOwnFilters;
var
  i: Integer;
begin
  if active and (FFilters <> nil) then
    for i := 0 to FFilters.Count - 1 do
    begin
      IFilter(FFilters.Items[i]).NotifyFilter(foRemoving);
      RemoveFilters(IFilter(FFilters.Items[i]).GetFilter(0));
      IFilter(FFilters.Items[i]).NotifyFilter(foRemoved);
    end;

end;

function Igraph.AddOwnFilters(index: Integer): IBaseFilter;
var
  i: Integer;
  FilterName: WideString;
begin
  if active and (FFilters <> nil) then
    for i := 0 to FFilters.Count - 1 do
    begin
      IFilter(FFilters.Items[i]).NotifyFilter(foAdding, index);
      FilterName := IFilter(FFilters.Items[i]).GetName;
      Result := IFilter(FFilters.Items[i]).GetFilter(index);
      if Assigned(Result) then
      begin
        AddFilter(Result, pwidechar(FilterName));
        IFilter(FFilters.Items[i]).NotifyFilter(foAdded, index);
        exit;
      end;
    end;
end;

// *****************************************************************

procedure Igraph.SetActive(Activate: boolean);
var
  Obj: IObjectWithSite;
  fgcb: IAMFilterGraphCallback;
  gbcb: IAMGraphBuilderCallback;
const
  IID_IObjectWithSite: tguid = '{FC4801A3-2BA9-11CF-A229-00AA003D7352}';
  CLSID_FilterGraphPrivateThread
    : tguid = '{a3ecbc41-581a-4476-b693-a63340462d8b}';
begin
  if Activate = FActive then
    exit;

  case Activate of
    true:
      begin
        try
          CoInitializeEX(nil, COINIT_APARTMENTTHREADED);
          // **********************
          // CheckDSError(CoCreateInstance(CLSID_CaptureGraphBuilder2, nil,
          // CLSCTX_INPROC_SERVER, IID_ICaptureGraphBuilder2, pfg2));

          // CoCreateInstance(CLSID_DvdGraphBuilder, nil, CLSCTX_INPROC_SERVER,
          // IID_IDvdGraphBuilder, FDVDGraph);
          // CLSID_FilterGraphPrivateThread      CLSID_FilterGraph  CLSID_FilterGraphNoThread
          CheckDSError(CoCreateInstance(CLSID_FilterGraph, nil,
            CLSCTX_INPROC_SERVER, IID_IFilterGraph2, pfg));
          pfg.EnumFilters(EnumFilters);

          // else
          // FDVDGraph.GetFiltergraph(pfg);

          // CheckDSError(pfg2.SetFiltergraph(IGraphBuilder(pfg)));
          //
          // AddGraphToRot(pfg, IdGraphBuilder);
          FActive := true;

          if Succeeded(QueryInterface(IMediaEventEx, FMediaEventEx)) then
          begin
            FMediaEventEx.SetNotifyFlags(0); // enable events notification
            FMediaEventEx.SetNotifyWindow(ObjectHandle, WM_GRAPHNOTIF,
              ULONG(FMediaEventEx));

          end;
          if Succeeded(QueryInterface(IID_IObjectWithSite, Obj)) then
          begin

            QueryInterface(IID_IAMGraphBuilderCallback, gbcb);
            if Assigned(gbcb) then
            begin
              Obj.SetSite(gbcb);
              gbcb := nil;
            end;
            QueryInterface(IID_IAMFilterGraphCallback, fgcb);
            if Assigned(fgcb) then
            begin
              Obj.SetSite(fgcb);
              fgcb := nil;
            end;

            Obj := nil;
          end;
          SetLogFile(FLogFileName);

          ControlEvents(ceActive, 1);
        except
          Halt
        end;
      end;
    false:
      begin
        Stop;
        ClearOwnFilters;
        ClearGraph;
        if Assigned(FMediaEventEx) then
        begin
          FMediaEventEx.SetNotifyFlags(AM_MEDIAEVENT_NONOTIFY);
          FMediaEventEx := nil;
        end;
        // RemoveGraphFromRot(IdGraphBuilder);
        if Assigned(FLogFile) then
          pfg.SetLogFile(FLogFile.Handle);
        FreeAndNil(FLogFile);
        // FDvdGraph := nil;      // pfg._Release;
        pfg := nil;
        // FDVDGraph := nil;     // try          // pfg2._Release;          // pfg2 := nil;          // except          // end;        finally          // CoFreeUnusedLibraries;          // CoFreeAllLibraries;          // CoFreeUnusedLibrariesEx(100, 0);          CoUninitialize;
        FActive := false;
        ControlEvents(ceActive, 0);
      end;
  end;

end;
{
  function Igraph.GetHideCursor: boolean;
  var
  x: LongBool;
  fVideoWindows: IVideoWindow;
  begin

  try
  if QueryInterface(IVideoWindow, fVideoWindows) = s_ok then
  fVideoWindows.IsCursorHidden(x);
  Result := x;
  finally
  fVideoWindows := nil;
  end;
  end;

  procedure Igraph.SetHideCursor(Value: boolean);
  var
  fVideoWindows: IVideoWindow;
  begin
  try
  try
  if QueryInterface(IVideoWindow, fVideoWindows) = s_ok then
  fVideoWindows.hidecursor(Value);
  except
  exit;
  end;

  finally
  fVideoWindows := nil;
  end;
  end;

  procedure Igraph.SetRate(rate: Double);
  var
  MediaSeeking: IMediaSeeking;
  begin
  frate := rate;
  if Succeeded(QueryInterface(IMediaSeeking, MediaSeeking)) then
  begin
  CheckDSError(MediaSeeking.SetRate(rate));
  MediaSeeking := nil;
  end;
  end;

  function Igraph.getrate: Double;
  var
  MediaSeeking: IMediaSeeking;
  begin
  try
  if Succeeded(QueryInterface(IMediaSeeking, MediaSeeking)) then
  MediaSeeking.getrate(Result);
  finally
  frate := Result;
  MediaSeeking := nil;
  end;

  end;
}
// ******************************************************************************

procedure Igraph.SetBalance(Value: Integer);
var
  BasicAudio: IBasicAudio;
begin
  IBalance := EnsureRange(Value, -10000, 10000);
  try
    if (QueryInterface(IBasicAudio, BasicAudio) = s_ok) then
    begin
      // SetBasicAudioPan(value)
      BasicAudio.put_Balance(IBalance);
      IBalance := Value;
    end;
  finally
    BasicAudio := nil;
  end;
end;

procedure Igraph.SetLogFile(FileName: String);
begin
  if active then
  begin
    pfg.SetLogFile(0);
    if Assigned(FLogFile) then
      FreeAndNil(FLogFile);
    if FileName <> '' then
      try

        FLogFile := TFileStream.Create(FileName, fmCreate{$IFDEF VER140},
          fmShareDenyNone{$ENDIF});

        pfg.SetLogFile(FLogFile.Handle);
      except
        pfg.SetLogFile(0);
        if Assigned(FLogFile) then
          FreeAndNil(FLogFile);
        exit;
      end;
  end;
  FLogFileName := FileName;
end;

function Igraph.QueryInterface(const iid: tguid; out Obj): HRESULT;
begin
  Result := inherited QueryInterface(iid, Obj);
  if (not Succeeded(Result)) and active then
  begin
    // if pfg2 <> nil then
    // Result := pfg2.QueryInterface(iid, Obj);
    // if Succeeded(Result) then
    // exit;

    // if Assigned(FDVDGraph) then
    // begin
    // Result := FDVDGraph.QueryInterface(iid, Obj);
    // if Succeeded(Result) then
    // exit;
    // Result := FDVDGraph.GetDvdInterface(iid, Obj);
    // if Succeeded(Result) then
    // exit;
    // end;

    if pfg <> nil then
      Result := pfg.QueryInterface(iid, Obj);
    if Succeeded(Result) then
      exit;

      with GetEnumerator do
        while MoveNext do
        begin
          Result := IBaseFilter(current).QueryInterface(iid, Obj);
          if Succeeded(Result) then
            exit;
        end;

  end;
end;

function Igraph.Play: boolean;
var
  MediaControl: IMediaControl;
begin
  try
    Result := Succeeded(QueryInterface(IMediaControl, MediaControl));
    if Assigned(MediaControl) then
    begin
      Result := Succeeded(CheckDSError(MediaControl.Run));
      UpdateGraph;
      ControlEvents(cePlay, Integer(Result));
    end;
  finally
    MediaControl := nil;
  end;
end;

function Igraph.Pause: boolean;
var
  MediaControl: IMediaControl;
begin
  try
    Result := Succeeded(QueryInterface(IMediaControl, MediaControl));
    if Assigned(MediaControl) then
    begin
      Result := Succeeded(MediaControl.Pause);
      ControlEvents(cePause, Integer(Result));
      UpdateGraph;
    end;
  finally
    MediaControl := nil;
  end;
end;

function Igraph.EnableStream(index: Integer): boolean;
begin
  Result := true;
  SetStream(Index, ListStream[Index]);
end;

function Igraph.StreamCount: Integer;
var
  FSource: TFunc<IBaseFilter>;
  tt: IAMStreamSelect;
  Count: Cardinal;
  bas: IBaseFilter;
begin

  FSource := function: IBaseFilter
    begin
      Result := StrToFilter('Spliter');
      if not Assigned(Result) then
      begin
        with GetEnumerator do
          Result := Last;
      end;
    end;

  bas := FSource;
  if not Assigned(bas) then
    exit(0);
  if bas.QueryInterface(IID_IAMStreamSelect, tt) = s_ok then
    if tt.Count(Count) = s_ok then
      exit(Count);

  Result := length(ArrayGetPin(bas, [PINDIR_OUTPUT], false));
end;

function Igraph.Stop: boolean;
var
  MediaControl: IMediaControl;
begin
  Result := false;
  try
    Result := Succeeded(QueryInterface(IMediaControl, MediaControl));
    if Assigned(MediaControl) then
    begin
      // position := (0);
      Result := Succeeded(MediaControl.Stop);
      UpdateGraph;
    end;
  finally
    ControlEvents(ceStop, Integer(Result));
    MediaControl := nil;
  end;
end;

function Igraph.GetState: TGraphState;
var
  AState: TFilterState;
  MediaControl: IMediaControl;
begin
  Result := gsUninitialized;
  if not Assigned(pfg) then
    exit;

  if Succeeded(pfg.QueryInterface(IMediaControl, MediaControl)) then
  begin
    MediaControl.GetState(0, AState);
    case AState of
      State_Stopped:
        Result := gsStopped;
      State_Paused:
        Result := gsPaused;
      State_Running:
        Result := gsPlaying;
    end;
    MediaControl := nil;
  end;
end;

procedure Igraph.set_soundlevel(Value: Integer);
var
  audiomix: IBasicAudio;
begin
  fvolume := Value;
  if Assigned(pfg) then
    if Succeeded(QueryInterface(IBasicAudio, audiomix)) then
      audiomix.put_Volume(fvolume);
  audiomix := nil;
end;

procedure Igraph.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_GRAPHNOTIF then
      try
        HandleEvents;
      except
        Application.HandleException(self);
      end
    else
      Result := DefWindowProc(ObjectHandle, Msg, wParam, lParam);
end;

procedure Igraph.HandleEvents;
var
  hr: HRESULT;
  Event: longint;
  Param1, Param2: LONG_PTR;
  i: Integer;
begin
  i := 0;
  if Assigned(FMediaEventEx) then
  begin
    hr := FMediaEventEx.GetEvent(Event, Param1, Param2, i);
    while (hr = s_ok) do
    begin
      DoEvent(Event, Param1, Param2);
      if FMediaEventEx = nil then
        exit;
      FMediaEventEx.FreeEventParams(Event, Param1, Param2);
      if FMediaEventEx = nil then
        hr := s_false
      else
        hr := FMediaEventEx.GetEvent(Event, Param1, Param2, 0);
    end;
  end;
end;

procedure Igraph.DoEvent(Event, Param1, Param2: Integer);
// type
// TVideoSize = record
// Width: word;
// height: word;
// end;
// var
// lcid: Cardinal;
// achLang: array [0 .. MAX_PATH] of Char;
// tc: TDVDTimeCode;
// frate: Integer;
// hmsftc: TDVDHMSFTimeCode;
// DVDInfo2: IDVDInfo2;
begin
  GraphEvents(Event, Param1, Param2);
  if Assigned(FOnDSEvent) then
    FOnDSEvent(self, Event, Param1, Param2);
  { case Event of
    EC_BUFFERING_DATA:
    if Assigned(FOnGraphBufferingData) then
    FOnGraphBufferingData(self, (Param1 = 1));
    EC_CLOCK_CHANGED:
    if Assigned(FOnGraphClockChanged) then
    FOnGraphClockChanged(self);
    EC_COMPLETE:
    if Assigned(FOnGraphComplete) then
    FOnGraphComplete(self, Param1, IBaseFilter(Param2));
    EC_DEVICE_LOST:
    if Assigned(FOnGraphDeviceLost) then
    FOnGraphDeviceLost(self, IUnknown(Param1), (Param2 = 1));
    EC_END_OF_SEGMENT:
    if Assigned(FOnGraphEndOfSegment) then
    FOnGraphEndOfSegment(self, PReferenceTime(Param1)^, Param2);
    EC_ERROR_STILLPLAYING:
    if Assigned(FOnGraphErrorStillPlaying) then
    FOnGraphErrorStillPlaying(self, Param1);
    EC_ERRORABORT:
    if Assigned(FOnGraphErrorAbort) then
    FOnGraphErrorAbort(self, Param1);
    EC_FULLSCREEN_LOST:
    if Assigned(FOnGraphFullscreenLost) then
    FOnGraphFullscreenLost(self, IBaseFilter(Param2));
    EC_GRAPH_CHANGED:
    if Assigned(FOnGraphChanged) then
    FOnGraphChanged(self);
    EC_OLE_EVENT:
    if Assigned(FOnGraphOleEvent) then
    FOnGraphOleEvent(self, WideString(Param1), WideString(Param2));
    EC_OPENING_FILE:
    if Assigned(FOnGraphOpeningFile) then
    FOnGraphOpeningFile(self, (Param1 = 1));
    EC_PALETTE_CHANGED:
    if Assigned(FOnGraphPaletteChanged) then
    FOnGraphPaletteChanged(self);
    EC_PAUSED:
    if Assigned(FOnGraphPaused) then
    FOnGraphPaused(self, Param1);
    EC_QUALITY_CHANGE:
    if Assigned(FOnGraphQualityChange) then
    FOnGraphQualityChange(self);
    EC_SNDDEV_IN_ERROR:
    if Assigned(FOnGraphSNDDevInError) then
    FOnGraphSNDDevInError(self, TSndDevErr(Param1), Param2);
    EC_SNDDEV_OUT_ERROR:
    if Assigned(FOnGraphSNDDevOutError) then
    FOnGraphSNDDevOutError(self, TSndDevErr(Param1), Param2);
    EC_STEP_COMPLETE:
    if Assigned(FOnGraphStepComplete) then
    FOnGraphStepComplete(self);
    EC_STREAM_CONTROL_STARTED:
    if Assigned(FOnGraphStreamControlStarted) then
    FOnGraphStreamControlStarted(self, IPin(Param1), Param2);
    EC_STREAM_CONTROL_STOPPED:
    if Assigned(FOnGraphStreamControlStopped) then
    FOnGraphStreamControlStopped(self, IPin(Param1), Param2);
    EC_STREAM_ERROR_STILLPLAYING:
    if Assigned(FOnGraphStreamErrorStillPlaying) then
    FOnGraphStreamErrorStillPlaying(self, Param1, Param2);
    EC_STREAM_ERROR_STOPPED:
    if Assigned(FOnGraphStreamErrorStopped) then
    FOnGraphStreamErrorStopped(self, Param1, Param2);
    EC_USERABORT:
    if Assigned(FOnGraphUserAbort) then
    FOnGraphUserAbort(self);
    EC_VIDEO_SIZE_CHANGED:
    if Assigned(FOnGraphVideoSizeChanged) then
    FOnGraphVideoSizeChanged(self, TVideoSize(Param1).Width,
    TVideoSize(Param1).height);
    EC_TIMECODE_AVAILABLE:
    if Assigned(FOnGraphTimeCodeAvailable) then
    FOnGraphTimeCodeAvailable(self, IBaseFilter(Param1), Param2);
    EC_EXTDEVICE_MODE_CHANGE:
    if Assigned(FOnGraphEXTDeviceModeChange) then
    FOnGraphEXTDeviceModeChange(self, Param1, Param2);
    EC_CLOCK_UNSET:
    if Assigned(FOnGraphClockUnset) then
    FOnGraphClockUnset(self); }
  // EC_VMR_RENDERDEVICE_SET      : if assigned(FOnGraphVMRRenderDevice)         then FOnGraphVMRRenderDevice(self, TVMRRenderDevice(Param1)) ;

  { EC_DVD_ANGLE_CHANGE:
    if Assigned(FOnDVDAngleChange) then
    FOnDVDAngleChange(self, Param1, Param2);
    EC_DVD_AUDIO_STREAM_CHANGE:
    begin
    if Assigned(FOnDVDAudioStreamChange) then
    if Succeeded(QueryInterface(IDVDInfo2, DVDInfo2)) then
    begin
    CheckDSError(DVDInfo2.GetAudioLanguage(Param1, lcid));
    GetLocaleInfo(lcid, LOCALE_SENGLANGUAGE, achLang, MAX_PATH);
    FOnDVDAudioStreamChange(self, Param1, lcid, string(achLang));
    DVDInfo2 := nil;
    end;
    end;
    EC_DVD_BUTTON_CHANGE:
    if Assigned(FOnDVDButtonChange) then
    FOnDVDButtonChange(self, Param1, Param2);
    EC_DVD_CHAPTER_AUTOSTOP:
    if Assigned(FOnDVDChapterAutoStop) then
    FOnDVDChapterAutoStop(self);
    EC_DVD_CHAPTER_START:
    if Assigned(FOnDVDChapterStart) then
    FOnDVDChapterStart(self, Param1);
    EC_DVD_CURRENT_TIME:
    begin
    if Assigned(FOnDVDCurrentTime) then
    begin
    tc := IntToTimeCode(Param1);
    case tc.FrameRateCode of
    1:
    frate := 25;
    3:
    frate := 30;
    else
    frate := 0;
    end;
    FOnDVDCurrentTime(self, tc.Hours1 + tc.Hours10 * 10,
    tc.Minutes1 + tc.Minutes10 * 10, tc.Seconds1 + tc.Seconds10 * 10,
    tc.Frames1 + tc.Frames10 * 10, frate);
    end;
    end;
    EC_DVD_DOMAIN_CHANGE:
    begin
    case Param1 of
    1:
    if Assigned(FOnDVDDomainFirstPlay) then
    FOnDVDDomainFirstPlay(self);
    2:
    if Assigned(FOnDVDDomainVideoManagerMenu) then
    FOnDVDDomainVideoManagerMenu(self);
    3:
    if Assigned(FOnDVDDomainVideoTitleSetMenu) then
    FOnDVDDomainVideoTitleSetMenu(self);
    4:
    if Assigned(FOnDVDDomainTitle) then
    FOnDVDDomainTitle(self);
    5:
    if Assigned(FOnDVDDomainStop) then
    FOnDVDDomainStop(self);
    end;
    end;
    EC_DVD_ERROR:
    begin
    case Param1 of
    1:
    if Assigned(FOnDVDErrorUnexpected) then
    FOnDVDErrorUnexpected(self);
    2:
    if Assigned(FOnDVDErrorCopyProtectFail) then
    FOnDVDErrorCopyProtectFail(self);
    3:
    if Assigned(FOnDVDErrorInvalidDVD1_0Disc) then
    FOnDVDErrorInvalidDVD1_0Disc(self);
    4:
    if Assigned(FOnDVDErrorInvalidDiscRegion) then
    FOnDVDErrorInvalidDiscRegion(self);
    5:
    if Assigned(FOnDVDErrorLowParentalLevel) then
    FOnDVDErrorLowParentalLevel(self);
    6:
    if Assigned(FOnDVDErrorMacrovisionFail) then
    FOnDVDErrorMacrovisionFail(self);
    7:
    if Assigned(FOnDVDErrorIncompatibleSystemAndDecoderRegions) then
    FOnDVDErrorIncompatibleSystemAndDecoderRegions(self);
    8:
    if Assigned(FOnDVDErrorIncompatibleDiscAndDecoderRegions) then
    FOnDVDErrorIncompatibleDiscAndDecoderRegions(self);
    end;
    end;
    EC_DVD_NO_FP_PGC:
    if Assigned(FOnDVDNoFP_PGC) then
    FOnDVDNoFP_PGC(self);
    EC_DVD_STILL_OFF:
    if Assigned(FOnDVDStillOff) then
    FOnDVDStillOff(self);
    EC_DVD_STILL_ON:
    if Assigned(FOnDVDStillOn) then
    FOnDVDStillOn(self, (Param1 = 1), Param2);
    EC_DVD_SUBPICTURE_STREAM_CHANGE:
    begin
    if Assigned(FOnDVDSubpictureStreamChange) and
    Succeeded(QueryInterface(IDVDInfo2, DVDInfo2)) then
    begin
    DVDInfo2.GetSubpictureLanguage(Param1, lcid);
    GetLocaleInfo(lcid, LOCALE_SENGLANGUAGE, achLang, MAX_PATH);
    FOnDVDSubpictureStreamChange(self, Param1, lcid, string(achLang));
    DVDInfo2 := nil;
    end;
    end;
    EC_DVD_TITLE_CHANGE:
    if Assigned(FOnDVDTitleChange) then
    FOnDVDTitleChange(self, Param1);
    EC_DVD_VALID_UOPS_CHANGE:
    if Assigned(FOnDVDValidUOPSChange) then
    FOnDVDValidUOPSChange(self, Param1);
    EC_DVD_WARNING:
    begin
    case Param1 of
    1:
    if Assigned(FOnDVDWarningInvalidDVD1_0Disc) then
    FOnDVDWarningInvalidDVD1_0Disc(self);
    2:
    if Assigned(FOnDVDWarningFormatNotSupported) then
    FOnDVDWarningFormatNotSupported(self);
    3:
    if Assigned(FOnDVDWarningIllegalNavCommand) then
    FOnDVDWarningIllegalNavCommand(self);
    4:
    if Assigned(FOnDVDWarningOpen) then
    FOnDVDWarningOpen(self);
    5:
    if Assigned(FOnDVDWarningSeek) then
    FOnDVDWarningSeek(self);
    6:
    if Assigned(FOnDVDWarningRead) then
    FOnDVDWarningRead(self);
    end;
    end;
    EC_DVD_PLAYBACK_RATE_CHANGE:
    if Assigned(FOnDVDPlaybackRateChange) then
    FOnDVDPlaybackRateChange(self, Param1 / 10000);
    EC_DVD_PARENTAL_LEVEL_CHANGE:
    if Assigned(FOnDVDParentalLevelChange) then
    FOnDVDParentalLevelChange(self, Param1);
    EC_DVD_PLAYBACK_STOPPED:
    if Assigned(FOnDVDPlaybackStopped) then
    FOnDVDPlaybackStopped(self);
    EC_DVD_ANGLES_AVAILABLE:
    if Assigned(FOnDVDAnglesAvailable) then
    FOnDVDAnglesAvailable(self, (Param1 = 1));
    EC_DVD_PLAYPERIOD_AUTOSTOP:
    if Assigned(FOnDVDPlayPeriodAutoStop) then
    FOnDVDPlayPeriodAutoStop(self);
    EC_DVD_BUTTON_AUTO_ACTIVATED:
    if Assigned(FOnDVDButtonAutoActivated) then
    FOnDVDButtonAutoActivated(self, Param1);
    EC_DVD_CMD_START:
    if Assigned(FOnDVDCMDStart) then
    FOnDVDCMDStart(self, Param1);
    EC_DVD_CMD_END:
    if Assigned(FOnDVDCMDEnd) then
    FOnDVDCMDEnd(self, Param1);
    EC_DVD_DISC_EJECTED:
    if Assigned(FOnDVDDiscEjected) then
    FOnDVDDiscEjected(self);
    EC_DVD_DISC_INSERTED:
    if Assigned(FOnDVDDiscInserted) then
    FOnDVDDiscInserted(self);
    EC_DVD_CURRENT_HMSF_TIME:
    begin
    if Assigned(FOnDVDCurrentHMSFTime) then
    begin
    hmsftc := TDVDHMSFTimeCode(Param1);
    tc := IntToTimeCode(Param2);
    FOnDVDCurrentHMSFTime(self, hmsftc, tc);
    end;
    end;
    EC_DVD_KARAOKE_MODE:
    if Assigned(FOnDVDKaraokeMode) then
    FOnDVDKaraokeMode(self, BOOL(Param1));
    end; }
end;

constructor Igraph.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  // CoInitialize(nil);
  // OleInitialize(nil);
  // CoInitializeEX(nil, COINIT_APARTMENTTHREADED);
  ObjectHandle := AllocateHWnd(WndProc);
  fpos := 0;
  IBalance := 0;
  frate := 1.0;
  on_change := false;
end;

destructor Igraph.Destroy;
begin
  SetActive(false);
  DeallocateHWnd(ObjectHandle);
  FreeAndNil(FGraphEvents);
  // OleUninitialize;
  // CoUninitialize;
  inherited Destroy;
end;

function Igraph.GetCurrentPosition: Integer;
var
  CurrentPos: Int64;
  positionmix: IMediaSeeking;
begin
  Result := 0;
  if on_change then
    exit;
  IF Succeeded(QueryInterface(IMediaSeeking, positionmix)) and
    Succeeded(positionmix.GetCurrentPosition(CurrentPos)) then
    Result := RefTimeToMiliSec(CurrentPos);
  positionmix := nil;
end;

function Igraph.GetDuration: Cardinal;
var
  positionmix: IMediaSeeking;
  CurrentPos: Int64;
begin
  Result := 0;
  IF Succeeded(QueryInterface(IMediaSeeking, positionmix)) and
    Succeeded(positionmix.GetDuration(CurrentPos)) then
    Result := RefTimeToMiliSec(CurrentPos);
  positionmix := nil;
end;

function Igraph.GetEnumerator: IGEtEnumFilter;
begin
  Result.EnumFilters := EnumFilters;
  if Assigned(EnumFilters) then
    Result.EnumFilters.Reset;
end;

procedure Igraph.SetPositions;
var
  StopPosition, CurrentPosition: Int64;
  positionmix: IMediaSeeking;
begin
  on_change := true;
  CurrentPosition := 0;
  IF Succeeded(QueryInterface(IMediaSeeking, positionmix)) and
    Succeeded(positionmix.GetStopPosition(StopPosition)) and (GetDuration > 0)
  then
  begin
    CurrentPosition := (StopPosition * Value) div GetDuration;
    positionmix.SetPositions(CurrentPosition, AM_SEEKING_AbsolutePositioning,
      StopPosition, AM_SEEKING_NoPositioning);
  end;
  positionmix := nil;
  on_change := false;
end;

procedure Igraph.put_Visible(Visible: boolean);
var
  fVideoWindows: IVideoWindow;
begin

  IF Succeeded(QueryInterface(IVideoWindow, fVideoWindows)) THEN
  BEGIN
    fVideoWindows.put_Visible(Visible);
  END;
  fVideoWindows := nil;
end;

function Igraph.get_Visible: boolean;
var
  fVideoWindows: IVideoWindow;
  x: LongBool;
begin
  Result := false;

  IF Succeeded(QueryInterface(IVideoWindow, fVideoWindows)) THEN
  BEGIN
    fVideoWindows.get_Visible(x);
    Result := x;
  END;
  fVideoWindows := nil;
end;

{ IGEtEnumFilter }

function IGEtEnumFilter.GetFilterInfo: TFilterInfo;
begin
  if Assigned(GetCurrent) then
    GetCurrent.QueryFilterInfo(Result);
end;

function IGEtEnumFilter.getLast: IBaseFilter;
begin
  while MoveNext do
    Result := GetCurrent;
end;

function IGEtEnumFilter.MoveNext: boolean;
begin
  if not Assigned(EnumFilters) then
    exit(false);
  exit((EnumFilters.Next(1, GetCurrent, nil) = s_ok));
end;

initialization

Set8087CW($133F)
// CW := Get8087CW;
// CoInitFlags := COINIT_APARTMENTTHREADED or COINIT_SPEED_OVER_MEMORY;
  finalization

end.
