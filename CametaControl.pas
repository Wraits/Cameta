unit CametaControl;

interface

uses
  Cameta_const,
  DshowU,
  XSuperObject,
  DirectShow9,
  DSUtils,
  CametaTypes,
  System.Classes,
  System.SyncObjs,
  CametaPlayList,
  PTrackBar,
  System.SysUtils;

const
  RepeatStateFormat: Packed array [_RepeatState] of string = ('Repeat:Playlist',
    'Repeat:Track', 'Repeat:Off', 'Random Play');

  RepeatStateImage: Packed array [_RepeatState] of integer = (4, 5, 6, 0);

  CametaStateFormat: Packed array [CametaState] of string = ('Resume Playback',
    'Restart Playback', 'Start Playback', 'Pause Playback', 'Stop Playback',
    'Close Files', 'Rendering', Cametaname);
  // TGraphState = (gsUninitialized, gsStopped, gsPaused, gsPlaying);
  CametaStateImage: Packed array [_ItemState] of integer = (99, 3, 2, 1,
    -1, 10, -1);

  GraphStateFormat: Packed array [TGraphState] of string = ('', Tstop,
    TPause, TPlay);

  GraphStateIcon: Packed array [TGraphState] of string = ('ApplicationIcon',
    'Stop', 'Pause', 'Play');

  NametypeStream: Packed array [TStreamType] of string = ('Subtitle',
    'AudioStream', 'VideoStream');

type
  TStreamType = (Videos, AudioS, Subtitle);

  _StreamAS = packed record
    indexstream: integer;
    Filename: Shortstring;
    StreamName: Shortstring;
    StreamType: TStreamType;
  end;

Type
  TCametaListEnumerator = record
  private
    FIndex: integer;
  public
    function GetCurrent: PointerItem;
    function MoveNext: Boolean;
    property Current: PointerItem read GetCurrent;
    property Index: integer read FIndex write FIndex;
  end;

type
  TGraphrenders = TProc<Boolean, TGraphState, hresult>;

  Ocontrols = class(Igraph)
  strict private
    Bdestroy: Boolean;
    fCriticalSection: TCriticalSection;
    FStopThisTrack: PointerItem;
    TRender_result: hresult;
    RandomIndex: Tarray<integer>;
    TPlayItem: PointerItem;
    TCloseItem: Tarray<PointerItem>;
    FDvDChecked, FMuteEnable: Boolean;
    pLocation: ISuperObject;

    function Unitialize: Boolean;
    procedure Setrevers(Frevers: RepeatStates);
    function getrevers: RepeatStates;
    function getRandomPlay: integer;
    function GetPlayIndex: integer;
    function norestarterror(Index: integer): integer;
  private
    onchange: Boolean;
    onRender: Boolean;
    EnumFilters: IEnumFilters;
    function SetGraphPosition(Value: Time_Date = 0): hresult;
    function GetGraphPosition(out Value: Time_Date): hresult;
    function GetDuration(out sTotalTime: Time_Date): hresult; overload;
    function GetDuration(out pDuration: int64): hresult; overload;
    function GetTotalTitleTime(out sTotalTime: Time_Date): hresult;
    function PlayAtTime(const tmp: Time_Date): hresult;
    procedure SetPosition(const Value: Time_Date);
    function GetPosition: Time_Date;
    procedure SetSoundLevel(Value: integer);
    function getSoundLevel: integer;
    function GetPlayString: string;
    procedure SetTimeRever(FTimeRevers: Boolean);
    function gLPNFFolder: Boolean;
    procedure SLPNFFolder(const Value: Boolean);
    function getTimeRever: Boolean;
    procedure setMuteEnable(const Value: Boolean);
    procedure GraphEvent(Event, Param1, Param2: integer);
    // tread render
    procedure OnStartPlay(onA: Boolean; _GraphState: TGraphState;
      Result: hresult);
    function PutRenderItem(const playpoint: PointerItem; Proc: TGraphrenders;
      GraphState: TGraphState = gsPlaying; Asms: Boolean = true): Boolean;
    //
    function getFhint: Boolean;
    procedure setFhint(const Value: Boolean);

    procedure setBRPlay(const Value: Boolean);
    function getBRPlay: Boolean;

    function getStartTrack: integer;
    procedure SetStartTrack(const Value: integer);

    function getStartTitle: string;
    procedure setStartTitle(const Value: string);

    function getState: TGraphState;
    procedure setState(const Value: TGraphState);

    function getStreamAS(Value: TStreamType): String;
    procedure setStreamAS(TypeS: TStreamType; Stream: String);

    function getLVolume: Boolean;
    procedure SetLVolume(const Value: Boolean);
    procedure setAudioRender(Value: TFilCatNode);
    procedure setVideoRender(Value: TFilCatNode);

    function get_AudioRender: TFilCatNode;
    function get_VideoRender: TFilCatNode;

    function ReadStream: Tarray<integer>;
    function GetItem(Index: integer): PointerItem;
    procedure SetItem(Index: integer; const Value: PointerItem);
    function PlayChapterInTitle(JSON: ISuperObject): Boolean;
    procedure _DVDChecked;
  strict protected
    procedure DoEvent(Event, Param1, Param2: integer); override;
    procedure ControlEvents(Event: TControlEvent; Param: integer = 0); override;
  public
    CametaList: TCametaList;
    ItemState: _ItemState;
    PlayStat: CametaState;
    function QueryInterface(const iid: tguid; out Obj): hresult; override;
    constructor Create; reintroduce;
    destructor Destroy; override;
    // ************************************************************************
    property AudioRender: TFilCatNode read get_AudioRender write setAudioRender;
    property VideoRender: TFilCatNode read get_VideoRender write setVideoRender;
    // ************************************************************************
    property Revers: RepeatStates read getrevers write Setrevers;
    property Render_result: hresult read TRender_result write TRender_result;
    function GetRever: _RepeatState;
    property Position: single read GetPosition write SetPosition;
    property PlayItem: PointerItem read TPlayItem;
    property PlayText: string read GetPlayString;
    // ************************************************************************
    property Volume: integer read getSoundLevel write SetSoundLevel;
    property MuteEnable: Boolean read FMuteEnable write setMuteEnable;
    // ************************************************************************
    property Timerever: Boolean read getTimeRever write SetTimeRever;
    property LPNFFolder: Boolean read gLPNFFolder write SLPNFFolder;
    property DvDChecked: Boolean read FDvDChecked;
    property LinearVolume: Boolean read getLVolume write SetLVolume;
    // ************************************************************************
    property StreamAS[TypeS: TStreamType]: String read getStreamAS
      write setStreamAS;
    property PlayIndex: integer read getStartTrack write SetStartTrack;
    property PlayFileName: string read getStartTitle write setStartTitle;
    property ActiveState: TGraphState read getState write setState;
    // ************************************************************************
    property ShowHint: Boolean read getFhint write setFhint;
    property Destroys: Boolean read Bdestroy write Bdestroy;
    // ************************************************************************
    function StopThisTrack(TSp: PointerItem): string; overload;
    function StopThisTrack: PointerItem; overload;
    // ************************************************************************
    property RestorePlayback: Boolean read getBRPlay write setBRPlay;
    function Stop(close: Boolean = false): Boolean;
    function CloseItem: Tarray<integer>;
    function Pause: Boolean;
    function Play: Boolean;
    function PlayPause: Boolean;
    function RenderExis: Boolean;
    function CountFilter(out FF: Tarray<IbaseFilter>): integer; overload;
    function CountFilter: integer; overload;
    // *****************************************************************
    function First: PointerItem;
    function Count: integer;
    function BreakOperations: Boolean;
    property Item[Index: integer]: PointerItem read GetItem write SetItem;
    function GetEnumerator: TCametaListEnumerator;
    // *****************************************************************
    procedure SetPlayIndex(Value: integer = 0; Asms: Boolean = true);
    procedure StartPlayback;
    function Duration(ProgressBar: TPTrackBar = nil): single;
    function GetProc: double;
    function GetTimeToString(ProgressBar: TPTrackBar): Shortstring;
    function get_hinttime(PC: Time_Date): string;
    function GetDb: single;
    // ****************************************************************
    procedure EnumeratorFilter(Select: TProc<string, Boolean>);
    procedure EnableStreamSelect(Index: integer; Filtername: string);
    function getSubtitleMenu(Out Items: ISuperArray): Boolean;
    function ActiveStream(Filename: string; StreamType: Byte): string;
    procedure EnumeratorStream(Filename: string; TypeArr: Tarray<tguid>;
      getStream: TProc<string, integer, integer, Boolean>);
    // Codec ****************************************************************
    function QueryProgress(out pllCurrent: string): hresult;
    function AbortOperation: hresult;
    // Codec ****************************************************************
    function source_decoder(playexts: ext_s; Fn, Ft: String): hresult;
  end;

implementation

uses
  playerform,
  BassFilter,
  Winapi.ActiveX,
  Windows,
  Cameta_Utils,
  other,
  Vcl.Forms,
  System.StrUtils,
  System.Math;

var
  OAudioRender: TAudioRender;

function Ocontrols.norestarterror(Index: integer): integer;
begin
  if InRange(index, 0, CametaList.Count - 1) then
  begin
    if Item[index].ErrorRender then
      Result := norestarterror(index + 1)
    else
      Result := (index);
  end
  else
    Result := -1;
  if Result > -1 then
    SetPlayIndex(Result);
end;

procedure Ocontrols.GraphEvent(Event, Param1, Param2: integer);
var
  Location: ISuperObject;
begin
  case Event of
    EC_COMPLETE:
      begin
        if FStopThisTrack = TPlayItem then
        begin
          Stop;
          exit;
        end;
        Stop;
        if _RepeatState.repeatt in Revers then
        begin
          Position := single.MinValue;
          Play;
          exit;
        end;

        if _RepeatState.randomplay in Revers then
        begin
          if (length(RandomIndex) = 1) and (_RepeatState.Norepeat in Revers)
          then
            exit();
          SetPlayIndex(-1);
          exit();
        end;

        if _RepeatState.repeatall in Revers then
        begin
          SetPlayIndex(ifthen(Count = GetPlayIndex + 1, 0, GetPlayIndex + 1));
          exit();
        end;

        if _RepeatState.Norepeat in Revers then
        begin
          norestarterror(GetPlayIndex + 1);
          exit();
        end;
        // *************************************
      end;
    EC_VIDEO_SIZE_CHANGED:
      ;
    EC_CLOCK_CHANGED:
      begin
        if assigned(pLocation) then
        begin
          Location := pLocation.Clone;
          pLocation := nil;
          if Location.Contains('Position') then
            Position := Location.F['Position']
          else
            PlayChapterInTitle(Location);
        end;
      end;
    EC_BUFFERING_DATA:
      begin
        Position;
        //
      end;
    EC_DVD_CURRENT_HMSF_TIME:
      begin

      end;
  end;
end;

function Ocontrols.AbortOperation: hresult;
var
  opens: IAMOpenProgress;
begin
  Result := s_false;
  try
    if succeeded(QueryInterface(IAMOpenProgress, opens)) then
      exit(opens.AbortOperation);
  except
  end;
end;

function Ocontrols.ActiveStream(Filename: string; StreamType: Byte): string;
var
  i: integer;
  Stream: _StreamAS;
  clsid: tguid;
begin
  Result := '{}';
  if StreamCount <= 2 then
    exit('{}');

  case StreamType of
    0:
      clsid := MEDIATYPE_Video;
    1:
      clsid := MEDIATYPE_Audio;
  else
    clsid := MEDIATYPE_Subtitle;
  end;

  for i := 0 to StreamCount - 1 do
    with ListStream[i] do
      if (Guid = clsid) then
        if onconnect then
        begin
          Stream.indexstream := i;
          Stream.Filename := Shortstring(Filename);
          Stream.StreamName := Shortstring(StreamName);
          Stream.StreamType := TStreamType(StreamType);
          exit(TSuperRecord<_StreamAS>.AsJSON(Stream));
        end;
end;

function Ocontrols.BreakOperations: Boolean;
begin
  Result := true;
  self.CametaList.BreakOperations;
end;

function Ocontrols.CloseItem: Tarray<integer>;
var
  Item: PointerItem;
begin
  for Item in TCloseItem do
  begin
    if Item.IndexOf > -1 then
      Result := Result + [Item.IndexOf];
  end;
  setlength(TCloseItem, 0)
end;

procedure Ocontrols.ControlEvents(Event: TControlEvent; Param: integer);
begin
  if Event = ceActive then
    exit;
  if not assigned(CametaList) then
    exit;
  try
    case Event of
      cePause:
        begin
          PlayStat := CametaState.Pause;
          ItemState := IPause;
        end;
      ceStop:
        begin
          PlayStat := CametaState.Stop;
          // SetGraphPosition(0);
          FStopThisTrack := nil;
          ItemState := IStop;
        end;
      ceFileRendering .. ceFileRendered:
        begin
          ItemState := IProgress;
          PlayStat := Rendering;
          exit
        end;
      cePlay:
        begin
          if PlayIndex = GetPlayIndex then
            PlayStat := resump
          else
            PlayStat := star;
          ItemState := IPlay;
        end;
    end;
    ActiveState := State;
    PlayIndex := GetPlayIndex;
    if assigned(TPlayItem) then
      PlayFileName := TPlayItem^.Filename
    else
      PlayFileName := '';
  finally
    inherited ControlEvents(Event, Param);
  end;
end;

function Ocontrols.Count: integer;
begin
  Result := self.CametaList.Count
end;

function Ocontrols.CountFilter: integer;
var
  FF: Tarray<IbaseFilter>;
begin
  exit(CountFilter(FF))
end;

function Ocontrols.CountFilter(out FF: Tarray<IbaseFilter>): integer;
var
  Filter: IbaseFilter;
begin
  Result := 0;
  EnumFilters.Reset;
  while (EnumFilters.Next(1, Filter, nil) = S_OK) do
  begin
    FF := FF + [Filter];
    inc(Result);
  end;
end;

procedure Ocontrols.SetLVolume(const Value: Boolean);
begin
  with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
  begin
    B[StrLinearVolume] := Value;
    WriteRegistry(DspRegistr, 'Sound', AsJSON);
  end
  // WriteRegistry(DspRegistr, StrLinearVolume, Value);
end;

procedure Ocontrols.SLPNFFolder(const Value: Boolean);
begin
  with so(ReadRegistry(Registr, 'PlaySettings', '{}')) do
  begin
    B[StrLoadPrevNextFileinFo] := Value;
    WriteRegistry(Registr, 'PlaySettings', AsJSON);
  end;
  // WriteRegistry(Registr, StrLoadPrevNextFileinFo, Value);
end;

function Ocontrols.source_decoder(playexts: ext_s; Fn, Ft: String): hresult;
const
  URlSource: tguid = '{B98D13E7-55DB-4385-A33D-09FD1BA26338}';
  AviSplitter: tguid = '{CEA8DEFF-0AF7-4DB9-9A38-FB3C3AEFC0DE}';
  sourceT: tguid = '{E436EBB5-524F-11CE-9F53-0020AF0BA770}';
var
  HR: hresult;
  Filter: IbaseFilter;
  SourceFilter: TFunc<IbaseFilter, Boolean>;
  SpliterCon: TFunc<IbaseFilter, Boolean>;
  Fhandle: HMODULE;
  CLISID: tguid;
  arr: Tarray<string>;
  Source: IbaseFilter;
  sourceint: IFileSourceFilter;
  txt: string;
begin
  Result := VFW_E_UNSUPPORTED_STREAM;

  SourceFilter := function(FSource: IbaseFilter): Boolean
    begin
      Result := (assigned(FSource) and
        succeeded(FSource.QueryInterface(IID_IFileSourceFilter, sourceint)));
      if not(Result) then
        exit(false);
      Result := (assigned(sourceint) and succeeded(AddFilter(FSource,
        PWidechar(Ft))) and succeeded(sourceint.Load(PWidechar(Fn), nil)));
      if not Result then
        RemoveFilters(FSource);
    end;

  case playexts of
    avi:
      ;
    dvd:
      for CLISID in GetClisidsFiles(Dslibdvdnav, Fhandle) do
        if SourceFilter(LoadFilter(Fhandle, CLISID)) then
          exit(S_OK);
    bass:
      begin
        Filter := IbaseFilter(TBassSource.Create('Bass', nil,
          CLSID_DCBassSource, HR));
        if succeeded(HR) then
          if SourceFilter(Filter) then
            exit(S_OK);
      end;
    cda:
      for CLISID in GetClisidsFiles(cddreader, Fhandle) do
        if SourceFilter((LoadFilter(cddreader, CLISID))) then
          exit(S_OK);
    wmv:
      if SourceFilter(LoadFilter(CLSID_WMAsfReader)) then
        exit(S_OK);
    flv:
      for CLISID in GetClisidsFiles(FLVSplitter, Fhandle) do
        if SourceFilter((LoadFilter(Fhandle, CLISID))) then
          exit(S_OK);
    mkv:
      for CLISID in GetClisidsFiles(MatroskaSplitter, Fhandle) do
        if SourceFilter((LoadFilter(Fhandle, CLISID))) then
          exit(S_OK);
    Url:
      begin // URlSource      CLSID_URLReader
        Source := LoadFilter(URlSource);
        if SourceFilter(Source) then
          exit(S_OK)
        else if SourceFilter(LoadFilter(CLSID_WMAsfReader)) then
          exit(S_OK);
        Source := nil;
        // AddSourceFilter(Filename, Filtername, Source);
      end;
  end;

  SpliterCon := function(spliter: IbaseFilter): Boolean
    begin
      Result := false;
      succeeded(AddFilter(spliter, 'Spliter'));
      if succeeded(ConnectFilter(self as IFilterGraph, Source, spliter)) then
        exit(true)
      else
        RemoveFilters(spliter);
    end;

  if Source = nil then
  begin
    Source := LoadFilter(CLSID_URLReader);
    SourceFilter(Source);
    { AddSourceFilter(FileName, FilterName, Source);
      if assigned(Source) and (not Source.QueryInterface(IID_IFileSourceFilter,sourceint) = s_ok) then
      exit; }
  end;

  if assigned(Source) then
  begin
    arr := [rMP4Splitter, CLSID_lavsplite.tostring, MpegSplitter,
      CLSID_MPEG1Splitter.tostring, CAviSplitter, CLSID_AviSplitter.tostring,
      CLSID_MatroskaSplitter.tostring, MpaSplitter];

    for txt in arr do
      if succeeded(CLSIDFromString(PWidechar(txt), CLISID)) and
        SpliterCon(LoadFilter(CLISID)) then
        exit(S_OK)
      else
        for CLISID in GetClisidsFiles(txt, Fhandle) do
          if SpliterCon(LoadFilter(Fhandle, CLISID)) then
            exit(S_OK);
  end;

  if SourceFilter(LoadFilter(CLSID_WMAsfReader)) then
    exit;
  if SourceFilter(LoadFilter(CLSID_WMAsfReader)) then
    exit;
  if SourceFilter(LoadFilter(FLVSplitter, CLSID_flvspliter)) then
    exit;
  if SourceFilter(LoadFilter(MatroskaSplitter, CLSID_MkSource)) then
    exit;
  if succeeded(QueryInterface(IID_IFileSourceFilter, sourceint)) then
    exit(S_OK);
  Result := VFW_E_UNSUPPORTED_STREAM;
end;

procedure Ocontrols._DVDChecked;
var
  DVDControl2: IDvdControl2;
begin
  FDvDChecked := succeeded(QueryInterface(IDvdControl2, DVDControl2));
  if DvDChecked then
    with DVDControl2 do
    begin
      SetOption(DVD_NotifyParentalLevelChange, false);
      // SetOption(DVD_HMSF_TimeCodeEvents, true);
      DVDControl2 := nil;
    end;
end;

procedure Ocontrols.setMuteEnable(const Value: Boolean);
begin
  FMuteEnable := Value;
  Volume := Volume;
end;

function Ocontrols.GetDb: single;
begin
  Result := Volume * 0.01
end;

function Ocontrols.GetDuration(out pDuration: int64): hresult;
var
  _pointer: pointer;
begin
  Result := E_FAIL;
  pDuration := 0;
  if succeeded(QueryInterface(IMediaSeeking, _pointer)) then
    if succeeded(IMediaSeeking(_pointer).GetDuration(pDuration)) and
      (pDuration > 0) then
    begin
      exit(S_OK);
    end;
end;

function Ocontrols.GetEnumerator: TCametaListEnumerator;
var
  t: TCametaListEnumerator;
begin
  t.Index := -1;
  Result := t;
end;

function Ocontrols.GetDuration(out sTotalTime: Time_Date): hresult;
var
  CurrentPos: int64;
begin
  Result := E_FAIL;
  sTotalTime := 0;
  if succeeded(GetDuration(CurrentPos)) then
  begin
    sTotalTime := RefTimeToSingle(CurrentPos);
    exit(S_OK);
  end;
end;

function Ocontrols.getFhint: Boolean;
begin
  Result := ReadRegistry(Registr, StrShowBalloonHint, false);
end;

function Ocontrols.GetGraphPosition(out Value: Time_Date): hresult;
var
  CurrentPos: int64;
begin
  Value := 0;
  Result := s_false;
  try
    with self as IMediaSeeking do
    begin
      Result := GetCurrentPosition(CurrentPos);
      // IMediaSeeking(_pointer).GetAvailable(pEarliest,pLatest);   // pEarliest.ToString;    // pLatest.ToString;    // IMediaSeeking(_pointer).GetPreroll(pLatest);    // pLatest.ToString;  end;
      if succeeded(Result) then
        Value := RefTimeToSingle(CurrentPos);
    end;
  except
    exit;
  end;
end;

function Ocontrols.GetItem(Index: integer): PointerItem;
begin
  if Cardinal(Index) >= Cardinal(Count) then
    exit(nil)
  else
    Result := CametaList.Items[index];
end;

function Ocontrols.getLVolume: Boolean;
begin
  Result := false;
  with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
  begin
    if Contains(StrLinearVolume) then
      Result := B[StrLinearVolume];
  end
  // Result := ReadRegistry(DspRegistr, StrLinearVolume, Result);
end;

function Ocontrols.gLPNFFolder: Boolean;
begin
  Result := false;
  with so(ReadRegistry(Registr, 'PlaySettings', '{}')) do
  begin
    if Contains(StrLoadPrevNextFileinFo) then
      Result := B[StrLoadPrevNextFileinFo];
  end;
  // Result := ReadRegistry(Registr, StrLoadPrevNextFileinFo, false);
end;

procedure Ocontrols.SetStartTrack(const Value: integer);
begin
  if Bdestroy and RestorePlayback then
    exit;

  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    i[StrStartPlayTrack] := Value;
    WriteRegistry(Registr, 'StartPlay', AsJSON);
  end;
end;

procedure Ocontrols.setState(const Value: TGraphState);
begin
  if Bdestroy and RestorePlayback then
    exit;
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    i[StrStartPlayStat] := integer(Value);
    WriteRegistry(Registr, 'StartPlay', AsJSON);
  end;
  // WriteRegistry(Registr, StrStartPlayStat, tmp, SizeOf(TGraphState));
end;

function Ocontrols.StopThisTrack(TSp: PointerItem): string;
var
  sb: TCString;
begin
  sb := TCString.Create;
  try
    sb.Append(Stopafterthistrack);
    if FStopThisTrack = TSp then
    begin
      FStopThisTrack := nil;
    end
    else
    begin
      FStopThisTrack := nil;
      FStopThisTrack := TSp;
    end;
    sb.Append(': ');
    sb.ifthen(assigned(FStopThisTrack),
      TSp.GetFormatString(StrMaskTitle), 'Clear');

    Result := sb.tostring;
  finally
    sb.Free;
  end;
end;

function Ocontrols.StopThisTrack: PointerItem;
begin
  Result := FStopThisTrack;
end;

procedure Ocontrols.SetTimeRever(FTimeRevers: Boolean);
begin
  WriteRegistry(Registr, StrTimerevers, FTimeRevers);
end;

procedure Ocontrols.StartPlayback();
var
  pt: PointerItem;
begin
  sleep(250);
  if not RestorePlayback then
    exit;
  while CametaList.ListChanges do
    application.ProcessMessages;
  if CametaList.GetTPlayItem(PlayIndex, pt) and
    PlayFileName.Contains(pt^.Filename) then
    PutRenderItem(pt, OnStartPlay, ActiveState);
end;

function Ocontrols.GetPlayIndex: integer;
begin
  Result := -1;
  if assigned(TPlayItem) then
    Result := TPlayItem.IndexOf;
end;

procedure Ocontrols.SetPlayIndex(Value: integer = 0; Asms: Boolean = true);
begin
  if CametaList.IsZero then
    exit;

  if (Value = -1) and (_RepeatState.randomplay in Revers) then
    Value := getRandomPlay;

  if InRange(Value, 0, CametaList.Count - 1) then
  begin
    PutRenderItem(CametaList[Value], OnStartPlay, gsPlaying, Asms);
    exit
  end;
end;

Function Ocontrols.GetPlayString: string;
begin
  Result := Cametaname;
  if not assigned(PlayItem) then
    exit;
  Result := PlayItem.GetFormatString(StrMaskTitle);
end;

function Ocontrols.ReadStream: Tarray<integer>;
var
  i: Byte;
begin
  Result := [];
  for i := 0 to 2 do
    if i = 0 then
      Result := [0]
    else
      with so(StreamAS[TStreamType(i)]) do
      begin
        if PlayItem.Filename.Contains(S['Filename']) then
          Result := Result + [i['indexstream']]
        else
          exit();
      end;
end;

procedure Ocontrols.OnStartPlay(onA: Boolean; _GraphState: TGraphState;
  Result: hresult);
var
  i: integer;
  pt: PointerItem;
begin
  // ^^^--------------------------------
  if not CheckDSErrors(Result) then
  begin
    ItemState := IClose;
    TPlayItem.ErrorRender := true;
    TPlayItem.AsString['ErorString'] := GetErrorString(Result);
    TCloseItem := TCloseItem + [TPlayItem];
    WriteRegistry(Registr, 'StartPlay', '{}');
    if onA then
    begin
      GraphEvent(EC_COMPLETE, 0, 0);
      exit;
    end;
    Stop(true);
    TRender_result := Result;
    exit;
  end;

  TRender_result := Result;
  PlayItem^.ErrorRender := false;

  Position := 0;

  _DVDChecked;

  TPlayItem^.Duration := Duration;

  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
    if RestorePlayback and CametaList.GetTPlayItem(PlayIndex, pt) and
      PlayFileName.Contains(pt^.Filename) then
    begin
      if (GetType(StrStartPosiion) = varObject) and o[StrStartPosiion]
        .Contains('TitleNum') then
        pLocation := o[StrStartPosiion].Clone
      else
      begin
        pLocation := so;
        pLocation.F['Position'] := F[StrStartPosiion];
      end;
    end;
  // ******

  case _GraphState of
    gsPaused:
      Pause;
    gsPlaying:
      Play;
    gsStopped:
      Stop(false);
    gsUninitialized:
      Stop(true);
  end;

  for i := 0 to 2 do
    StreamAS[TStreamType(i)] := ActiveStream(PlayItem.Filename, i);

end;

procedure Ocontrols.setBRPlay(const Value: Boolean);
begin
  with so(ReadRegistry(Registr, StrRestorePlayback, '{}')) do
  begin
    B[StrRestorePlayback] := Value;
    WriteRegistry(Registr, StrRestorePlayback, AsJSON);
  end;
end;

procedure Ocontrols.setFhint(const Value: Boolean);
begin
  WriteRegistry(Registr, StrShowBalloonHint, Value);
end;

function Ocontrols.PlayAtTime(const tmp: Time_Date): hresult;
var
  ppCmd: IDvdCmd;
  pTime: tagDVD_HMSF_TIMECODE;
begin
  Result := s_false;
  if State <> gsUninitialized then
    with self as IDvdControl2 do
    begin
      pTime := Timecodet(tmp);
      Result := (PlayAtTime(@pTime, DVD_CMD_FLAG_None, ppCmd));
      ppCmd := nil;
    end
end;

function Ocontrols.PlayChapterInTitle(JSON: ISuperObject): Boolean;
var
  pLocation: TDVDPlaybackLocation2;
  ppCmd: IDvdCmd;
begin
  try
    pLocation := TSuperRecord<TDVDPlaybackLocation2>.FromJSON(JSON);
    with self as IDvdControl2 do
    begin
      CheckDSError(PlayChapterInTitle(pLocation.TitleNum, pLocation.ChapterNum,
        DVD_CMD_FLAG_None, ppCmd));
      // CheckDSError(PlayTitle(pLocation.TitleNum, DVD_CMD_FLAG_Block or DVD_CMD_FLAG_Flush, ppCmd)); CheckDSError(PlayChapterInTitle(pLocation.TitleNum,  pLocation.ChapterNum, DVD_CMD_FLAG_Block or   DVD_CMD_FLAG_Flush, ppCmd));
      CheckDSError(PlayAtTime(@pLocation.TimeCode, DVD_CMD_FLAG_None, ppCmd));
      Result := true;
    end;
  except
    exit(false);
  end;
end;

function Ocontrols.GetTotalTitleTime;
var
  pTotalTime: TDVDHMSFTimeCode;
  ulTimeCodeFlags: Cardinal;
begin
  Result := s_false;
  sTotalTime := 0;
  if State <> gsUninitialized then
    with self as IDvdInfo2 do
    begin
      if succeeded(GetTotalTitleTime(pTotalTime, ulTimeCodeFlags)) then
        sTotalTime := TimecodetToCardinal(pTotalTime);
      Result := S_OK;
    end;
end;

function Ocontrols.getBRPlay: Boolean;
begin
  Result := false;
  with so(ReadRegistry(Registr, StrRestorePlayback, '{}')) do
  begin
    if Contains(StrRestorePlayback) then
      Result := B[StrRestorePlayback];
  end;
end;

destructor Ocontrols.Destroy;
begin
  freeandnil(CametaList);
  freeandnil(fCriticalSection);
  freeandnil(OAudioRender);
  active := false;
  inherited Destroy;
end;

procedure Ocontrols.DoEvent(Event, Param1, Param2: integer);
begin
  GraphEvent(Event, Param1, Param2);
  inherited;
end;

constructor Ocontrols.Create;
begin
  inherited Create(nil);
  active := true;
  (self as IGraphBuilder).EnumFilters(EnumFilters);
  Bdestroy := false;
  onchange := false;
  onRender := false;
  OAudioRender := TAudioRender.Create(self);
  ItemState := INone;
  PlayStat := Icameta;
  fCriticalSection := TCriticalSection.Create;
  CametaList := TCametaList.Create;
  TPlayItem := nil;
  if LinearVolume then
    with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
    begin
      if Contains(StrBalance) then
        balance := i[StrBalance]
      else
        balance := 0;
    end
  else
  begin
    with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
    begin
      if Contains(StrBalance) then
        balance := DSUtils.GetBasicAudioPan(i[StrBalance])
      else
        balance := 0;
    end;
  end;
end;

function Ocontrols.GetTimeToString;
var
  fls: Time_Date;
  maxf_: single;
begin
  if (State in [gsUninitialized, gsStopped]) then
  begin
    ProgressBar.Position := 0;
    exit(Shortstring(timetostr(time)));
  end;

  if assigned(ProgressBar) then
  begin
    maxf_ := Duration(ProgressBar);
    fls := Position;
    ProgressBar.Position := round(fls);
    if (ProgressBar.Max > 0) then
    begin
      fls := ifthen(Timerever, fls, maxf_ - fls);
      Result := Shortstring(ifthen(Timerever, '', '-'));
      AppendStr(Result, Shortstring(TimeDateToString(fls) + '/' +
        TimeDateToString(maxf_)));
    end
    else
    begin
      Result := Shortstring(TimeDateToString(fls) + '/~');
    end;
  end;
end;

procedure Ocontrols.SetSoundLevel;
begin
  if Value <> 0 then
    FMuteEnable := false;
  Value := EnsureRange(Value, 0, 10000);
  if LinearVolume then
    inherited Volume := Value - 10000
  else
    inherited Volume := SetBasicAudioVolume(Value);
  if FMuteEnable then
    exit;
  with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
  begin
    i[StrSoundLevel] := Value;
    WriteRegistry(DspRegistr, 'Sound', AsJSON);
  end;
end;

procedure Ocontrols.setStartTitle(const Value: string);
begin
  if Bdestroy and RestorePlayback then
    exit;
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    S[StrStartPlayTitle] := Value;
    WriteRegistry(Registr, 'StartPlay', AsJSON);
  end;
end;

function Ocontrols.GetProc;
var
  maxf_: single;
begin
  if (State in [gsPaused, gsPlaying]) then
  begin
    maxf_ := Duration;
    if (maxf_ > 0) then
      Result := Position / (maxf_ / 100)
    else
      Result := 0
  end
  else
    Result := 0;
end;

function Ocontrols.getRandomPlay: integer;
var
  i: integer;
begin
  if Count = 1 then
    exit(0);
  if (length(RandomIndex) < 2) or (Count <> RandomIndex[high(RandomIndex)]) then
  begin
    RandomIndex := [];
    with GetEnumerator do
      while MoveNext do
        if (not Current.ErrorRender) and (PlayIndex <> Index) then
          RandomIndex := RandomIndex + [Index];

    RandomIndex := RandomIndex + [Count];
  end;

  i := random(high(RandomIndex) - 1);
  Result := RandomIndex[i];
  Delete(RandomIndex, i, 1);
end;

function Ocontrols.GetRever: _RepeatState;
begin
  Result := _RepeatState.randomplay;
  if repeatall in Revers then
    exit(_RepeatState.repeatall);
  if repeatt in Revers then
    exit(_RepeatState.repeatt);
  if Norepeat in Revers then
    exit(_RepeatState.Norepeat);
end;

function Ocontrols.getrevers: RepeatStates;
begin
  if ReadRegistry(Registr, StrRevers, Result, SizeOf(_RepeatState)) <>
    SizeOf(_RepeatState) then
    Result := [repeatall];
end;

function Ocontrols.getSoundLevel: integer;
begin
  if MuteEnable then
    exit(0);
  Result := integer(10000);
  with so(ReadRegistry(DspRegistr, 'Sound', '{}')) do
  begin
    if Contains(StrSoundLevel) then
      Result := i[StrSoundLevel];
  end
  // Result := ReadRegistry(DspRegistr, StrSoundLevel, integer(10000));
end;

function Ocontrols.getStartTitle: string;
begin
  Result := '';
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    if Contains(StrStartPlayTitle) then
      Result := S[StrStartPlayTitle];
  end;
end;

function Ocontrols.getStartTrack: integer;
begin
  Result := -1;
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    if Contains(StrStartPlayTrack) then
      Result := i[StrStartPlayTrack];
  end;
end;

function Ocontrols.getState: TGraphState;
begin
  Result := gsUninitialized;
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    if Contains(StrStartPlayStat) then
      Result := TGraphState(i[StrStartPlayStat]);
  end;
  // if ReadRegistry(Registr, StrStartPlayStat, Result, SizeOf(TGraphState))<>SizeOf(TGraphState) then
  // Result := gsUninitialized;
end;

function Ocontrols.getStreamAS(Value: TStreamType): String;
begin
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
    Result := A['Stream'].o[integer(Value)].AsJSON;
end;

function Ocontrols.getSubtitleMenu(out Items: ISuperArray): Boolean;
var
  AMS: IAMStreamSelect;
  bas: IbaseFilter;
  Index, Count: Cardinal;
  ppmt: PAMMediaType;
  pdwFlags: DWORD;
  plcid: lcid;
  pdwGroup: Cardinal;
  ppszName: PWCHAR;
  ppObject: IUnknown;
  ppUnk: IUnknown;
begin
  Result := false;
  bas := StrToFilter(SubtitlesFilterName);

  if assigned(bas) and succeeded(bas.QueryInterface(IID_IAMStreamSelect, AMS))
    and succeeded(AMS.Count(Count)) then
    try
      begin
        Items := sa;
        for index := 0 to Count - 1 do
          if succeeded(AMS.info(index, ppmt, pdwFlags, plcid, pdwGroup,
            ppszName, ppObject, ppUnk)) then
          begin
            with XSuperObject.so do
            begin
              B['Flags'] := Boolean(pdwFlags = 1);
              i['Group'] := pdwGroup.tostring.Substring(pdwGroup.tostring.length
                - 1).ToInteger;
              S['Name'] := string(ppszName);
              i['Index'] := index;
              Items.Add(AsObject.AsJSON());
            end;
            Result := true;
          end;
      end;
    except
      exit(false)
    end;
end;

procedure Ocontrols.setStreamAS(TypeS: TStreamType; Stream: String);
begin
  if Bdestroy and RestorePlayback then
    exit;
  with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
  begin
    A['Stream'].o[integer(TypeS)] := so(Stream);
    WriteRegistry(Registr, 'StartPlay', AsJSON);
  end;
end;

function Ocontrols.Duration;
// var
// HR: hresult;
begin
  Result := 0;
  // HR := s_false;

  try
    if DvDChecked then
      GetTotalTitleTime(Result)
    else
      GetDuration(Result);
  finally
    if assigned(ProgressBar) then
    begin
      // ProgressBar.Enabled := succeeded(HR);
      ProgressBar.Max := round(Result);
    end;
  end;
end;

// SubtitlesFilterName
procedure Ocontrols.EnableStreamSelect(Index: integer; Filtername: string);
var
  AMS: IAMStreamSelect;
  bas: IbaseFilter;
  i: Byte;
begin
  bas := StrToFilter(Filtername);
  if assigned(bas) and succeeded(bas.QueryInterface(IID_IAMStreamSelect, AMS))
  then
    AMS.Enable(index, AMSTREAMSELECTENABLE_ENABLE)
  else
  begin
    self.EnableStream(index);
  end;
  for i := 1 to 3 do
    StreamAS[TStreamType(i)] := ActiveStream(PlayItem.Filename, i);
end;

procedure Ocontrols.EnumeratorFilter(Select: TProc<string, Boolean>);
begin
  with IFList(TFList.Create(self as IGraphBuilder)), GetEnumerator do
    while MoveNext do
      with FilterInfo do
        if S_Dsp <> (achName) then
          Select(achName, HaveFilterPropertyPage(IbaseFilter(Current)));
end;

procedure Ocontrols.EnumeratorStream(Filename: string; TypeArr: Tarray<tguid>;
  getStream: TProc<string, integer, integer, Boolean>);
const
  audarr = 2019668720;
  vidarr = 405779185;
var
  y, ind: Byte;
  getHash: TFunc<tguid, integer>;
  breaks: Boolean;
begin

  if StreamCount = 0 then
    exit;
  // Subtitle, AudioS,Videos
  getHash := function(Guid: tguid): integer
    begin
      case Guid.tostring.GetHashCode of
        vidarr:
          Result := 0;
        audarr:
          Result := 1;
      else
        Result := 2;
      end;
    end;

  for ind := 0 to StreamCount - 1 do
    with ListStream[ind] do
    begin
      if length(TypeArr) > 0 then
      begin
        breaks := false;
        for y := Low(TypeArr) to High(TypeArr) do
          if Guid = TypeArr[y] then
          begin
            breaks := true;
            break
          end;
        if not breaks then
          continue;
      end;
      getStream(StreamName.Trim, getHash(Guid), ind, onconnect);
    end;

end;

function Ocontrols.First: PointerItem;
begin
  Result := PointerItem(self.CametaList.First)
end;

function Ocontrols.GetPosition;
var
  pLocation: TDVDPlaybackLocation2;
begin
  if onchange then
    exit;
  if DvDChecked then
    with self as IDvdInfo2 do
    begin
      GetCurrentLocation(pLocation);
      Result := TimecodetToCardinal(pLocation.TimeCode);
      if Bdestroy and RestorePlayback then
        exit;
      with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
      begin
        o[StrStartPosiion] := TSuperRecord<TDVDPlaybackLocation2>.AsJSONObject
          (pLocation);
        WriteRegistry(Registr, 'StartPlay', AsJSON);
      end;
    end
  else
  begin
    GetGraphPosition(Result);
    if Bdestroy and RestorePlayback then
      exit;
    if (State in [gsPlaying, gsPaused]) then
      with so(ReadRegistry(Registr, 'StartPlay', '{}')) do
      begin
        F[StrStartPosiion] := Result;
        WriteRegistry(Registr, 'StartPlay', AsJSON);
      end;
  end;
end;

procedure Ocontrols.setAudioRender(Value: TFilCatNode);
begin
  WriteRegistry(DspRegistr, StrAudioRender, Value, SizeOf(TFilCatNode));
end;

function Ocontrols.get_AudioRender: TFilCatNode;
begin
  if ReadRegistry(DspRegistr, StrAudioRender, Result, SizeOf(TFilCatNode)) <>
    SizeOf(TFilCatNode) then
  begin
    Result.clsid := CLSID_DSoundRender;
    Result.FriendlyName := 'DSound Render';
  end;
end;

function Ocontrols.get_hinttime(PC: Time_Date): string;
var
  pos, pD, Pr: Time_Date;
begin
  pD := Duration;

  Pr := ifthen(pD > 0, PC / (pD / 100), 0);
  pos := (pD - PC);
  Result := format(SeekFormat, [TimeDateToString(PC), TimeDateToString(pos),
    TimeDateToString(pD), Pr]) + '%';
end;

procedure Ocontrols.setVideoRender(Value: TFilCatNode);
begin
  WriteRegistry(DspRegistr, StrVideoRender, Value, SizeOf(TFilCatNode));
end;

function Ocontrols.get_VideoRender: TFilCatNode;
begin
  if ReadRegistry(DspRegistr, StrVideoRender, Result, SizeOf(TFilCatNode)) <>
    SizeOf(TFilCatNode) then
  begin
    Result.clsid := CLSID_VideoMixingRenderer9;
    Result.FriendlyName := 'Video Mixing Renderer 9';
  end;
end;

function Ocontrols.SetGraphPosition(Value: Time_Date = 0): hresult;
var
  Ms: IMediaSeeking;
  c, S: int64;
  D: int64;
begin
  Result := s_false;
  S := 0;
  D := 0;
  if succeeded(QueryInterface(IMediaSeeking, Ms)) and
    succeeded(Ms.GetDuration(D)) and (D > 0) then
  begin
    c := EnsureRange(SingleToRefTime(Value), 0, D);
    Result := Ms.SetPositions(c, AM_SEEKING_AbsolutePositioning, S,
      AM_SEEKING_NoPositioning);
  end;
end;

procedure Ocontrols.SetItem(Index: integer; const Value: PointerItem);
begin
  if Cardinal(Index) >= Cardinal(Count) then
    exit()
  else
    self.CametaList.Items[index] := Value;
end;

procedure Ocontrols.SetPosition;
var
  audiomix: IBasicAudio;
  fvolume: integer;
begin
  if (State = gsUninitialized) or onchange then
    exit;
  if succeeded(QueryInterface(IBasicAudio, audiomix)) then
    audiomix.get_Volume(fvolume);
  audiomix.put_Volume(-10000);
  onchange := true;
  if DvDChecked then
    PlayAtTime(EnsureRange(Value, 0, Duration))
  else
    SetGraphPosition(Value);
  sleep(50);
  audiomix.put_Volume(fvolume);
  onchange := false;
end;

function Ocontrols.getTimeRever: Boolean;
begin
  Result := ReadRegistry(Registr, StrTimerevers, true);
end;

procedure Ocontrols.Setrevers(Frevers: RepeatStates);
begin
  WriteRegistry(Registr, StrRevers, Frevers, SizeOf(_RepeatState));
end;

function Ocontrols.Play: Boolean;
begin
  if not assigned(TPlayItem) then
    exit(false);
  if State in [gsPlaying, gsStopped] then
  begin
    PlayStat := rest;
  end;
  Result := inherited Play;
  if Result then
    ActiveState := State;
end;

function Ocontrols.RenderExis: Boolean;
begin
  Result := not(WaitForSingleObject(Tread[0], 50) <> STATUS_TIMEOUT);
end;

function Ocontrols.PlayPause;
begin
  if RenderExis then
    exit(false);

  case State of
    gsPlaying:
      exit(Pause);
    gsPaused:
      begin
        PlayStat := resump;
        Result := Play;
        exit;
      end;
    gsStopped:
      begin
        Position := 0;
        PlayStat := rest;
        Result := Play;
        exit;
      end;
    gsUninitialized:
      begin
        PlayStat := star;
        exit(PutRenderItem(TPlayItem, OnStartPlay));
      end;
  end;

  PlayStat := rest;
  Result := Play;
end;

function Ocontrols.PutRenderItem(const playpoint: PointerItem;
  Proc: TGraphrenders; GraphState: TGraphState = gsPlaying;
  Asms: Boolean = true): Boolean;
begin
  if (playpoint = nil) or onRender then
    exit(false);

  if not Asms then
    if RenderExis then
      exit(false);
  onRender := true;
  fCriticalSection.Acquire;
  Try
    if CountFilter > 0 then
    begin
      Stop(true);
    end;
    // EnumFilters;
    ItemState := IProgress;
    TPlayItem := playpoint;
    Result := true;
    Tread[0] := AnonymousThread(
      procedure
      var
        GS: TGraphState;
        RR: hresult;
        arr: Tarray<integer>;
      begin
        RR := s_false;
        GS := GraphState;
        fCriticalSection.Enter;
        try
          with playpoint^ do
          begin
            image_loads := true;
            RR := source_decoder(source_ext, Filename,
              ifthen(Tags.i['source_ext'] = 8, AsString['Title'],
              ExtractFileName(Filename)));
            GetDecoder := GetDecoders;
            arr := ReadStream;
            if succeeded(RR) then
              RR := RenderFileEx(arr);
          end;
        finally
          if assigned(Proc) then
            Proc(Asms, GS, RR);
          fCriticalSection.Leave;
          onRender := false;
        end;
      end, 'Start_render');
  finally
    fCriticalSection.Release;
  end;

end;

function Ocontrols.QueryInterface(const iid: tguid; out Obj): hresult;
begin
  Result := inherited QueryInterface(iid, Obj);
end;

function Ocontrols.QueryProgress(out pllCurrent: string): hresult;
var
  AMO: IAMOpenProgress;
  AMN: IAMNetworkStatus;
  BuffProg: longint;
  c, t: int64;
begin
  BuffProg := 0;
  pllCurrent := '';
  Result := s_false;
  if (succeeded(QueryInterface(IAMNetworkStatus, AMN)) and
    succeeded(AMN.get_BufferingProgress(BuffProg)) and (BuffProg > 0)) then
  begin
    pllCurrent := BuffProg.tostring;
    exit(S_OK);
  end
  else if succeeded(QueryInterface(IAMOpenProgress, AMO)) and
    succeeded(AMO.QueryProgress(t, c)) and (t > 0) and (c < t) then
  begin
    pllCurrent := format('%2f', [c * 100 / t]);
    exit(S_OK);
  end;
end;

function Ocontrols.Stop(close: Boolean): Boolean;
begin
  Result := true;
  if close then
  begin
    ItemState := IClose;
    if assigned(TPlayItem) then
      if not(TPlayItem.Tags.i['source_ext'] = 8) then
        TPlayItem.DeleteAllCoverArts;
    TCloseItem := TCloseItem + [TPlayItem];
    TPlayItem := nil;
    if not Bdestroy then
      WriteRegistry(Registr, 'StartPlay', '{}');
    inherited Stop;
    AbortOperation;
    FDvDChecked := false;
    Unitialize;
  end
  else
    inherited Stop;
end;

function Ocontrols.Pause: Boolean;
begin
  PlayStat := CametaState.Pause;
  Result := inherited Pause;
end;

function Ocontrols.Unitialize: Boolean;
var
  FF: Tarray<IbaseFilter>;
  F: IbaseFilter;
begin
  Result := true;
  with self as IGraphBuilder do
  begin
    ShouldOperationContinue;
    Abort;
  end;

  if CountFilter(FF) > 0 then
  begin
    ClearGraph;
    for F in FF do
      self.RemoveFilters(F)
  end;
end;

// CLSID_VideoRendererDefault

{ TListEnumerator }

function TCametaListEnumerator.GetCurrent: PointerItem;
begin
  Result := pcontrols.Item[FIndex];
end;

function TCametaListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < pcontrols.Count - 1;
  if Result then
    inc(FIndex);
end;

initialization

end.
