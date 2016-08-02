unit CametaTypes;

interface

uses
  Vcl.Graphics,
  Classes,
  DirectShow9,
  types, Vcl.Menus,
  XSuperObject,
  System.SysUtils,
  System.Generics.Collections,
  Cameta_const;

Type
  PointerItem = ^TPlayListItem;

  TCopyrecord = packed record
    TotalFileTransferred: int64;
    TotalFileSize: int64;
    TotalBytesTransferred: int64;
    function Progress: string;
  end;

  //
  TMenuList = TList<TMenuItem>;

  // **********************************
  TCString = class(TStringBuilder)
    function ToArray: TArray<string>;
    function ifthen(value: boolean; Atrue, AFalse: string): TCString;
    function GetFormatString(const mask: string; item: PointerItem): TCString;
    function SIA(index: Integer = 0): string;
  end;

  TSkins = Packed record
    procedure LoadSkinRes(Picture: TPicture; Name: Pwidechar);
  Public
    skinsname: string;
    repeatnormal: string;
    repeathot: string;
    repeatpressed: string;
    repeattrack: string;
    playlisthot: TPicture;
    playlistnormal: TPicture;
    playlistpressed: TPicture;
    addnormal: TPicture;
    addhot: TPicture;
    addpressed: TPicture;
    backnormal: TPicture;
    backhot: TPicture;
    backpressed: TPicture;
    backenable: TPicture;
    stopnormal: TPicture;
    stophot: TPicture;
    stoppressed: TPicture;
    stopenable: TPicture;
    playnormal: TPicture;
    playhot: TPicture;
    playpressed: TPicture;
    pausenormal: TPicture;
    pausehot: TPicture;
    pausepressed: TPicture;
    nextnormal: TPicture;
    nexthot: TPicture;
    nextpressed: TPicture;
    nextenable: TPicture;
    volume1: TPicture;
    volume2: TPicture;
    volume3: TPicture;
    volume4: TPicture;
    volume5: TPicture;
    volumehot: TPicture;
    volumepressed: TPicture;
    volumeenable: TPicture;
    timeColor: TColor;
    coloritem: TColor;
    colorplay: TColor;
    skinbg_color: TColor;
    FontColore: TColor;
    // ********************************
    SelectedFont: TColor;
    SelectedFBrush: TColor;
    procedure SkindefLoad;
    procedure Creat;
    Procedure Destroy;
    procedure regColor;
    function Load(Filename: string): boolean;
  end;

  // ****************************************

  __Tips = TProc<Integer>;
  GetLamba = TProc<PointerItem, Integer>;

  _TCametaList = TList<PointerItem>;

  TPlayListItem = Packed record
  public
    image_loads: boolean;
    CoverArts: IACoverArt;
    Tags: ISuperObject;
    Onchange: TProc<string, string>;
    PList: TList;
  End;

  TPlayListItemHelper = record helper for TPlayListItem
  private
    function ReadAviInfo(const FileStream: TFileStream): boolean;
    function ExtractFilename(Name: string): string;
    function extsource_input(const Filenames: string): ext_s;
    procedure openfiles(Filenames: String);
    function GetFilename: String;
    function Getf_ex: ext_s;
    procedure setsource_in(eext: ext_s);
    function getDuration: Time_Date;
    procedure setDuration(const value: Time_Date);
    function Ext: ShortString;
    function GetTag(Name: String): String;
    procedure SetItem(Name: String; value: String);
    function getFileloads: boolean;
    function getRender: boolean;
    procedure SetRender(const value: boolean);
  public
    procedure DeleteAllCoverArts;
    procedure Destroy;
    function filesize: int64;
    property source_ext: ext_s read Getf_ex write setsource_in;
    property Filename: String read GetFilename write openfiles;
    Property Duration: Time_Date read getDuration write setDuration;
    function StrDuration: string;
    function TagValue(Name: String): String;
    property AsString[Name: string]: String read GetTag write SetItem;
    property Fileloads: boolean read getFileloads;
    property ErrorRender: boolean read getRender write SetRender;
    function AsInteger(Name: String): int64;
    function TagExists: boolean;
    // *************************
    function IndexOf: Integer;
    function Count: Integer;
    function Delete: Integer;
    function Selected: boolean;
    // ************************
    function ItemState: _ItemState;
    function DeleteFile: boolean;
    function Play: boolean;
    function GetBuffer: boolean;
    function explorer: THandle;
    // ************************
    Function GetFormatString(const mask: string): string;
  end;

function RefTimeToSingle(Milisec: int64): single;
function Timecodet(value: Time_Date): tagDVD_HMSF_TIMECODE;
function TimecodetToCardinal(HMSFTime: tagDVD_HMSF_TIMECODE): Time_Date;
function SingleToRefTime(value: single): int64;
function TimeDateToString(value: Time_Date): string;

var
  MaskArray: TStringDynArray;

implementation

uses
  Vcl.Clipbrd,
  Winapi.ShellAPI,
  DSUtils,
  playerform,
  CametaControl,
  CametaPlayList,
  Winapi.Windows,
  other,
  Vcl.Imaging.pngimage,
  System.DateUtils,
  Cameta_Utils,
  System.StrUtils,
  RegularExpressions,
  System.IniFiles,
  System.Win.Registry,
  CDAtrack,
  Math;

resourcestring
  Sq = '"["';
  SE = '"]"';

const
  qc = '%';

procedure TSkins.LoadSkinRes(Picture: TPicture; Name: Pwidechar);
var
  pngimage: TPngImage;
begin
  if FindResource(HInstance, Name, RT_BITMAP) <> 0 then
    Picture.Bitmap.LoadFromResourceName(HInstance, Name)
  else
  begin
    pngimage := TPngImage.Create;
    pngimage.LoadFromResourceName(HInstance, Name);
    Picture.Assign(pngimage);
    pngimage.Free
  end;
end;

function TSkins.Load(Filename: string): boolean;
begin
  result := true;
  if not FileExists(ApplicationFolder + '\skin\' + Filename) then
  begin
    result := false;
  end
  else
    with Tinifile.Create(ExtractFilePath(paramstr(0)) + '\skin\' + Filename) do
      try
        try
          stopnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'Stopnormal', ''));

          stoppressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'stoppressed', ''));
          stophot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'stophot', ''));
          stopenable.LoadFromFile(ApplicationFolder + ReadString('skin',
            'stopenable', ''));
          addnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'addnormal', ''));
          addpressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'addpressed', ''));
          addhot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'addhot', ''));
          backpressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'backpressed', ''));
          backhot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'backhot', ''));
          backnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'backnormal', ''));
          backenable.LoadFromFile(ApplicationFolder + ReadString('skin',
            'backenable', ''));
          nextpressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'nextpressed', ''));
          nexthot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'nexthot', ''));
          nextnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'nextnormal', ''));
          nextenable.LoadFromFile(ApplicationFolder + ReadString('skin',
            'nextenable', ''));
          playnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playnormal', ''));
          playhot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playhot', ''));
          playpressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playpressed', ''));
          pausenormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'pausenormal', ''));
          pausehot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'pausehot', ''));
          pausepressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'pausepressed', ''));
          playlisthot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playlisthot', ''));
          playlistnormal.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playlistnormal', ''));
          playlistpressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'playlistpressed', ''));
          volumepressed.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volumepressed', ''));
          volumehot.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volumehot', ''));
          volume1.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volume1', ''));
          volume2.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volume2', ''));
          volume3.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volume3', ''));
          volume4.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volume4', ''));
          volume5.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volume5', ''));
          volumeenable.LoadFromFile(ApplicationFolder + ReadString('skin',
            'volumeenable', ''));
        except
          result := false;
        end;
      finally
        Free;
      end;
end;

procedure TSkins.regColor;
begin
  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(registr, true);
      with XSuperObject.so(ReadRegistry(registr, 'skins', '{}')) do
      begin
        I['fontColor'] := FontColore;
        I['Coloritem'] := coloritem;
        I['TimeColor'] := timeColor;
        S['Name'] := skinsname;
        I['Colorplay'] := colorplay;
        I['skinbg_color'] := skinbg_color;
        I['SelectedFont'] := SelectedFont;
        I['SelectedFBrush'] := SelectedFBrush;
        WriteRegistry(registr, 'skins', AsJSON);
      end;
      CloseKey;
    finally
      Free;
    end;
end;

procedure TSkins.Creat;
begin
  skinsname := 'default.ks';
  colorplay := clblack;
  coloritem := clblack;
  FontColore := clblack;
  skinbg_color := clGradientActiveCaption;
  timeColor := clblack;
  SelectedFont := clAqua;
  SelectedFBrush := clFuchsia;
  try
    with XSuperObject.so(ReadRegistry(registr, 'skins', '{}')) do
    begin
      if Contains('fontColor') then
        FontColore := I['fontColor'];
      if Contains('Coloritem') then
        coloritem := I['Coloritem'];
      if Contains('TimeColor') then
        timeColor := I['TimeColor'];
      if Contains('Name') then
        skinsname := S['Name'];
      if Contains('Colorplay') then
        colorplay := I['Colorplay'];
      if Contains('skinbg_color') then
        skinbg_color := I['skinbg_color'];
      if Contains('SelectedFont') then
        SelectedFont := I['SelectedFont'];
      if Contains('SelectedFBrush') then
        SelectedFBrush := I['SelectedFBrush'];
      WriteRegistry(registr, 'skins', AsJSON);
    end;
  except
    WriteRegistry(registr, 'skins', '{}');
  end;
  // ***********************************************************
  volumeenable := TPicture.Create;
  volumepressed := TPicture.Create;
  volumehot := TPicture.Create;
  volume1 := TPicture.Create;
  volume3 := TPicture.Create;
  volume2 := TPicture.Create;
  volume4 := TPicture.Create;
  volume5 := TPicture.Create;
  // ***********************************************************
  addnormal := TPicture.Create;
  addhot := TPicture.Create;
  addpressed := TPicture.Create;
  // ***********************************************************
  playlisthot := TPicture.Create;
  playlistnormal := TPicture.Create;
  playlistpressed := TPicture.Create;
  // ***********************************************************
  backnormal := TPicture.Create;
  backhot := TPicture.Create;
  backpressed := TPicture.Create;
  backenable := TPicture.Create;
  // ***********************************************************
  stopnormal := TPicture.Create;
  stophot := TPicture.Create;
  stoppressed := TPicture.Create;
  stopenable := TPicture.Create;
  // ***********************************************************
  nextnormal := TPicture.Create;
  nexthot := TPicture.Create;
  nextpressed := TPicture.Create;
  nextenable := TPicture.Create;
  // ***********************************************************
  playnormal := TPicture.Create;
  playhot := TPicture.Create;
  playpressed := TPicture.Create;
  // ***********************************************************
  pausenormal := TPicture.Create;
  pausehot := TPicture.Create;
  pausepressed := TPicture.Create;
end;

Procedure TSkins.Destroy;
begin
  regColor;

  FreeAndNil(volumeenable);
  FreeAndNil(volumepressed);
  FreeAndNil(volumehot);
  FreeAndNil(volume1);
  FreeAndNil(volume3);
  FreeAndNil(volume2);
  FreeAndNil(volume4);
  FreeAndNil(volume5);
  FreeAndNil(addnormal);
  FreeAndNil(addhot);
  FreeAndNil(addpressed);
  FreeAndNil(playlisthot);
  FreeAndNil(playlistnormal);
  FreeAndNil(playlistpressed);
  FreeAndNil(backnormal);
  FreeAndNil(backhot);
  FreeAndNil(backpressed);
  FreeAndNil(backenable);
  FreeAndNil(stopnormal);
  FreeAndNil(stophot);
  FreeAndNil(stoppressed);
  FreeAndNil(stopenable);
  FreeAndNil(nextnormal);
  FreeAndNil(nexthot);
  FreeAndNil(nextpressed);
  FreeAndNil(nextenable);
  FreeAndNil(playnormal);
  FreeAndNil(playhot);
  FreeAndNil(playpressed);
  FreeAndNil(pausenormal);
  FreeAndNil(pausehot);
  FreeAndNil(pausepressed);
end;

procedure TSkins.SkindefLoad;
begin
  // **************************************************************
  // png.LoadFromResourceName(HInstance, 'smalllogo');
  // home.SmalLogo.Picture.Assign(png);
  LoadSkinRes(playnormal, 'play1normal');
  LoadSkinRes(playhot, 'play1hot');
  LoadSkinRes(playpressed, 'play1press');
  // *************************************************************
  LoadSkinRes(pausenormal, 'pausenormals');
  LoadSkinRes(pausehot, 'pausehots');
  LoadSkinRes(pausepressed, 'pausepressedsz');

  // **************************************************************
  LoadSkinRes(addnormal, 'opennormal');
  LoadSkinRes(addhot, 'openhot');
  LoadSkinRes(addpressed, 'openpresseds');

  // **************************************************************
  LoadSkinRes(backnormal, 'backn');
  LoadSkinRes(backhot, 'backh');
  LoadSkinRes(backpressed, 'backpress');
  LoadSkinRes(backenable, 'backenable');

  // **************************************************************
  LoadSkinRes(stopnormal, 'stopn');
  LoadSkinRes(stophot, 'stoph');
  LoadSkinRes(stoppressed, 'stoppress');
  LoadSkinRes(stopenable, 'stopd');
  // **************************************************************
  LoadSkinRes(playlistnormal, 'playlistn');
  LoadSkinRes(playlisthot, 'playlisth');
  LoadSkinRes(playlistpressed, 'playlistp');
  // LoadSkinRes(stopenable,'stopd');

  // **************************************************************
  LoadSkinRes(nextnormal, 'nextn');
  LoadSkinRes(nexthot, 'nexth');
  LoadSkinRes(nextpressed, 'nextp');
  LoadSkinRes(nextenable, 'nexte');

  // **************************************************************
  LoadSkinRes(volumehot, 'VolumeHot');
  LoadSkinRes(volumepressed, 'Volumepressed');
  LoadSkinRes(volumeenable, 'VolumeDisable');
  LoadSkinRes(volume1, 'Volume1');
  LoadSkinRes(volume2, 'Volume2');
  LoadSkinRes(volume3, 'Volume3');
  LoadSkinRes(volume4, 'Volume4');
  LoadSkinRes(volume5, 'Volume5');
end;

// **************************************************************************

function TPlayListItemHelper.Count: Integer;
begin
  result := 0;
  if assigned(PList) then
    result := PList.Count;
end;

function TPlayListItemHelper.Delete: Integer;
begin
  result := IndexOf;
  PList.Delete(result);
end;

procedure TPlayListItemHelper.DeleteAllCoverArts;
begin
  setlength(CoverArts, 0);
end;

function TPlayListItemHelper.DeleteFile: boolean;
begin
  result := Cameta_Utils.DeleteFile(TArray<TFileName>.Create(Filename));
end;

function TPlayListItemHelper.TagExists: boolean;
begin
  result := Tags.Contains('Tags')
end;

function TPlayListItemHelper.TagValue(Name: String): String;
begin
  result := Name + ':' + GetTag(Name);
end;

function TPlayListItemHelper.GetTag(Name: String): String;
const
  arr: packed array [0 .. 3] of string = (Type_, ExtractFileName_, Filesize_,
    Playtrack);
begin
  result := '';
  try
    case IndexText(Name, arr) of
      0:
        exit(ifthen(not(ext_s(Tags.I['source_ext']) = url),
          string(Ext).ToUpper, 'URL'));
      1:
        exit(System.SysUtils.ExtractFilename(Filename));
      2:
        exit(getSize(filesize));
      3:
        exit((IndexOf + 1).ToString);
    else
      with Tags do
        if Contains(Name.ToUpper) then
          result := Tags[Name].AsString
        else if Contains('Tags') and O['Tags'].Contains(Name) then
          result := O['Tags'][name].AsString;
    end;
  except
    result := '';
  end;
end;

function TPlayListItemHelper.Ext;
var
  _fn: String;
  I: Integer;
begin
  I := 0;
  _fn := Filename;
  _fn := System.SysUtils.ExtractFilename(Filename);
  inc(I, _fn.LastIndexOf('.') + 1);
  if I > 0 then
    exit(ShortString(_fn.Substring(I, _fn.Length - I)));
  result := '';
end;

function TPlayListItemHelper.GetFilename: String;
begin
  result := GetTag('Filename')
end;

function get_tag(const Name: string; item: PointerItem): string;
const
  Fields: packed array [0 .. 11] of string = (CountTrack, Ampli, Equalizer_,
    nChannels, nSamplesPerSec, wBitsPerSample, BitFloat, PositiP, playback_time,
    State, 'Cameta', 'Duration');
var
  ttz: string;
begin
  result := '';
  case IndexText(Name, Fields) of
    0:
      exit(PControls.Count.ToString);
    1:
      exit(ifthen((others.DynamicAmplify and (others.Amplification > 1.09)),
        format('%.1fx', [others.Amplification]), ''));
    2:
      exit(ifthen(others.Equalizer, Equalizer_, ''));
    3:
      exit(ChFormat[others.Channels]);
    4:
      exit(others.Frequency.ToString);
    5:
      exit(others.Bits.ToString);
    6:
      exit(ifthen(others.Float, 'Float', ''));
    7:
      with PControls do
      begin
        if PControls.QueryProgress(ttz) = s_ok then
          exit('Buffering ' + ttz)
        else
          exit(ifthen((GetProc > 0) or GetProc.IsInfinity,
            format('%2f', [GetProc]), ''));
      end;
    8:
      exit(TimeDateToString(home.ProgressBar1.Position));
    9:
      exit(ifthen(assigned(item), GraphStateFormat[PControls.State], ''));
    10:
      exit(Cametaname);
    12:
      if assigned(item) then
        exit(item.StrDuration);
  else
    if assigned(item) then
      exit(item.AsString[name]);
  end;
end;

function getquete(const value: Pstring; index: Integer): boolean;
begin
  result := (index = 0) or (value^.Length - 1 = index) or
    not((value^.Chars[index + 1] = '"') and (value^.Chars[index - 1] = '"'));
end;

Function StartDelimiter(const Masks: Pstring): Integer;
var
  I: Integer;
begin
  result := -1;
  for I := 1 to High(Masks^) do
    if (Masks^.Chars[I] = sc) and getquete(Masks, I) then
    begin
      result := (I + 1);
      break;
    end;
end;

function LastDelimiter(const Masks: Pstring; index: Integer): Integer;
var
  I: Integer;
begin
  result := -1;
  for I := ifthen(index = -1, high(Masks^), index) downto 0 do
    if (Masks^.Chars[I] = Cameta_const.so) and getquete(Masks, I) then
      exit(I);
end;

function Substring(const mask: string; pos: Integer): string;
var
  sd: Integer;
begin
  result := '';
  sd := -1;
  repeat
    pos := LastDelimiter(@mask, pos);
    if pos = -1 then
      exit();
    result := mask.Substring(pos, ifthen(sd = -1, mask.Length, sd) - pos);
    sd := StartDelimiter(@result);
    result := result.Substring(0, sd);
    if result.CountChar(qc) > 1 then
      exit();
    if sd = -1 then
      break;
    Dec(pos);
  until false;
end;

function Select(const PM, sp: string; item: PointerItem): string;
  //*****************************************************
  function sub(st: Pstring): string;
  var
    I: Integer;
  begin
    I := st^.IndexOf(qc) + 1;
    result := st^.Substring(I, st^.IndexOf(qc, I) - I);
  end;
 //******************************************************
  procedure _DTrim(_mask: Pstring; Dtrim: Pboolean);
  begin
    if (_mask^.Chars[0] = skob[1]) and
      (_mask^.Chars[_mask^.Length - 1] = skob[2]) then
    begin
      _mask^ := _mask^.Trim(skob);
      Dtrim^ := true;
    end
    else
      Dtrim^ := false;
  end;
 //******************************************************
var
  sts: TArray<string>;
  Dtrim: boolean;
  p: string;
begin
  p := PM;
  if sp.IsEmpty then
  begin
    _DTrim(@p, @Dtrim);
    sts := [sub(@p)];
    sts := sts + [get_tag(sts[0], item).replace(Cameta_const.so, Sq)
      .replace(sc, SE)];
    sts[0] := ifthen(sts[1].IsEmpty and Dtrim, p, sts[0].QuotedString(qc));
  end
  else
  begin
    sts := [(sp)];
    sts := sts + [Select(sts[0], '', item)];
  end;

  result := p.replace(sts[0], sts[1]);

  if result.CountChar(qc) > 1 then
    result := Select(result, Substring(result, -1), item);

end;

function TPlayListItemHelper.GetFormatString(const mask: string): string;
var
  pt: PointerItem;
begin
  pt := @(self);
  result := Select(mask, Substring(mask, -1), pt);
  result := result.replace(Sq, Cameta_const.so).replace(SE, sc);
end;

function TPlayListItemHelper.filesize: int64;
begin
  result := Tags['SIZE'.ToUpper].AsString.ToInt64
end;

function TPlayListItemHelper.GetBuffer: boolean;
begin
  result := true;
  Vcl.Clipbrd.Clipboard.SetTextBuf(Pwidechar(Filename));
end;

function TPlayListItemHelper.Getf_ex: ext_s;
begin
  result := extsource_input(Filename);
  Tags.SetData('source_ext', Integer(result));
end;

function TPlayListItemHelper.getRender: boolean;
begin
  result := false;
  with Tags do
    if Contains('ErrorRender') then
      result := B['ErrorRender'];
end;

function TPlayListItemHelper.AsInteger(Name: String): int64;
begin
  result := 0;
  with Tags do
    try
      if Contains('Tags') then
        result := O['Tags'][NAME].AsInteger;
    except
      result := 0
    end;
end;

function TPlayListItemHelper.IndexOf: Integer;
var
  pp: PointerItem;
begin
  result := -1;
  pp := @self;
  if assigned(pp) then
    if assigned(PList) then
      result := PList.IndexOf(@self);
end;

function TPlayListItemHelper.ItemState: _ItemState;
var
  pp: PointerItem;
begin
  result := INone;
  pp := @self;
  if assigned(pp) then
    if pp = PControls.PlayItem then
      exit(PControls.ItemState);
  if pp.ErrorRender then
    result := IError;
end;

procedure TPlayListItemHelper.SetItem(Name: string; value: String);
begin
  if not Tags.Contains(Name.ToUpper) or not(Tags.S[Name] = value) then
  begin
    Tags.SetData(Name.ToUpper, string(value));
    if assigned(Onchange) then
      Onchange(Name, value);
  end;
end;

procedure TPlayListItemHelper.SetRender(const value: boolean);
begin
  Tags.B['ErrorRender'] := value;;
end;

procedure TPlayListItemHelper.Destroy;
begin
  Tags := nil;
  DeleteAllCoverArts;
  Onchange := nil;
  PList := nil;
end;

function TPlayListItemHelper.explorer: THandle;
var
  p: PChar;
begin
  if Tags.Contains('URL') then
    exit(ShellExecute(0, 'open', Pwidechar(AsString['URL']), nil, '',
      SW_SHOWNORMAL));
  p := PChar(String('/select, "' + Filename + '"'));
  result := ShellExecute(0, 'open', 'explorer', p, '', SW_SHOWNORMAL);
end;

procedure TPlayListItemHelper.openfiles(Filenames: String);
begin
  // Fileloads := true;
  ErrorRender := false;
  if Filenames.Chars[0] = '{' then
  begin
    Tags := XSuperObject.so(Filenames);
  end
  else
    with GISuperObject(['Filename'], [Filenames]) do
    begin
      Tags := ReadTTag(AsObject);
    end;

  if not Fileloads then
    exit;

  if Tags.Contains('source_ext') then
  begin
    source_ext := ext_s(Tags.I['source_ext']);
  end
  else
    source_ext := source_ext;

  if not Fileloads then
    exit;
  if GetTag(C_title).IsEmpty then
    SetItem(C_title, ExtractFilename(Filename));
end;

function TPlayListItemHelper.Play: boolean;
begin
  result := IndexOf > -1;
  if result then
    PControls.SetPlayIndex(IndexOf, false);
end;

function TPlayListItemHelper.ExtractFilename(Name: string): string;
var
  D: Integer;
begin
  D := name.LastDelimiter('\') + 1;
  result := name.Substring(D, name.Length - D);
  result := result.Substring(0, result.LastDelimiter('.'));
end;

function TPlayListItemHelper.getDuration: Time_Date;
begin
  result := 0;
  try
    if Tags.Contains('Duration') then
      result := StrToFloatDef(Tags['Duration'.ToUpper].AsString, result);
  except
    result := 0;
  end;
end;

function TPlayListItemHelper.getFileloads: boolean;
begin
  if (ext_s(Tags.I['source_ext']) = url) and (filesize > -1) then
    exit(true);
  exit(FileExists(Filename))
end;

procedure TPlayListItemHelper.setDuration(const value: Time_Date);
begin
  if getDuration < 1 then
    AsString['Duration'.ToUpper] := value.ToString;
end;

procedure TPlayListItemHelper.setsource_in(eext: ext_s);
begin
  Tags.SetData('source_ext', Integer(eext));
end;

function TPlayListItemHelper.StrDuration: string;
begin
  exit(TimeDateToString(Duration))
end;

function TPlayListItemHelper.extsource_input;
var
  strem: TFileStream;
begin
  result := unkow;
  if Filenames.IsEmpty then
  begin
    Tags.S['SIZE'.ToUpper] := '-1';
    exit(unkow);
  end;

  if Filenames.Contains('//') then
  begin
    result := url;
    exit;
  end
  else
    Case Cameta_Utils.MatchesMask(Filenames, MaskArray) of
      0:
        exit(mkv);
      1 .. 3:
        exit(unkow);
      4:
        begin
          if not image_loads then
            Tags := ReadTTag(Filenames)
          else
          begin
            Tags := ReadTTag(Tags, CoverArts);
          end;
          exit(unkow);
        end;
      5:
        begin
          result := (wmv);
          if not image_loads then
            Tags := ReadTTag(Filenames)
          else
          begin
            Tags := ReadTTag(Tags, CoverArts);
          end;
        end;
      6 .. 8:
        begin
          result := (bass);
          if not image_loads then
            Tags := ReadTTag(Filenames)
          else
          begin
            Tags := ReadTTag(Tags, CoverArts);
          end;
        end;
      9:
        begin
          strem := getStream(Filenames);
          ReadAviInfo(strem);
          FreeAndNil(strem);
          exit(avi);
        end;
      10:
        exit(flv);
      11 .. 12:
        begin
          result := (bass);
          if not image_loads then
            Tags := ReadTTag(Filenames)
          else
          begin
            Tags := ReadTTag(Tags, CoverArts);
          end;
        end;
      13 .. 17:
        begin
          result := (bass);
          if not image_loads then
            Tags := ReadTTag(Filenames)
          else
          begin
            Tags := ReadTTag(Tags, CoverArts);
          end;
        end;
      18:
        with TCDAtrack.Create do
          try
            ReadFromFile(Filenames);
            if not Valid then
              exit;
            self.Duration := (Duration);
            result := (cda);
          finally
            Free;
          end;
      21:
        begin
          result := (dvd);
          SetItem('Title', 'DvD Video');
        end;
      23:
        exit(unkow);
      -1:
        begin
          exit(unkow);
        end;
    end;
end;

function TPlayListItemHelper.ReadAviInfo;
type
  ObjectID = array [1 .. 7] of ansiChar;
var
  Aviheadersize: Integer;
  Vheadersize: Integer;
  Aviheaderstart: Integer;
  Vheaderstart: Integer;
  Aheaderstart: Integer;
  Astrhsize: Integer;
  // Временные переменные
  TTempTest: ObjectID;
  TempSize: Integer;
  TempVcodec: string[5];
  TempAcodec: Integer;
  TempMicrosec: Integer;
  TempLengthInFrames: Integer;
  TempAchannels: Integer;
  TempAsamplerate: Integer;
  TempAbitrate: Integer;
  // Выходные данные
  Length: Double;
  Vcodec: string;
  // Vbitrate: Double;
  VWidth: Integer;
  VHeight: Integer;
  Fps: Double;
  _S: string;
  LengthInSec: Double;
  Acodec: string;
  // Abitrate: Integer;
  curentpos: int64;
  // Vbitrate: Extended;
begin
  result := true;
  TempAcodec := 0;
  TempAbitrate := 0;
  TempAsamplerate := 0;
  TempAchannels := 0;
  if assigned(FileStream) then
    exit;

  with FileStream do
  begin
    curentpos := Position;
    // Грубая проверка на подлинность файла
    Seek(7, 0);
    Read(TTempTest, SizeOf(TTempTest));
    _S := Trim(string(copy(TTempTest, 0, 4)));
    if pos('AVI', _S) = 0 then
      exit(false);

    // Размер файла
    Seek(4, 0);
    Read(TempSize, 4);
    // Размер хедера (needed to locate the audio part)
    Seek(28, 0);
    Read(Aviheadersize, 4);
    // старт хедера (needed to locate the video part)
    Aviheaderstart := 32;
    // Милисекунды (1000000 / TempMicrosec = fps)
    Seek(Aviheaderstart, 0);
    Read(TempMicrosec, 4);
    // Размер во фреймах
    Seek(Aviheaderstart + 16, 0);
    Read(TempLengthInFrames, 4);
    // Ширина
    Seek(Aviheaderstart + 32, 0);
    Read(VWidth, 4);
    // Высота
    Seek(Aviheaderstart + 36, 0);
    Read(VHeight, 4);
    // calculate header size
    Seek(Aviheaderstart + Aviheadersize + 4, 0);
    Read(Vheadersize, 4);
    Vheaderstart := Aviheaderstart + Aviheadersize + 20;
    // Video Codec
    Seek(Vheaderstart + 3, 0);
    Read(TempVcodec, 5);
    Aheaderstart := Vheaderstart + Vheadersize + 8;
    Seek(Aheaderstart - 4, 0);
    Read(Astrhsize, 5);
    // Audio codec
    Seek(Aheaderstart + Astrhsize + 8, 0);
    Read(TempAcodec, 2);
    // Audio каналы (1 = mono, 2 = stereo)
    Seek(Aheaderstart + Astrhsize + 10, 0);
    Read(TempAchannels, 2);
    // Audio samplerate
    Seek(Aheaderstart + Astrhsize + 12, 0);
    Read(TempAsamplerate, 4);
    // Audio bitrate
    Seek(Aheaderstart + Astrhsize + 16, 0);
    Read(TempAbitrate, 4);
    // закрываем файл
    Position := curentpos;
  end;

  // анализируем видео кодек (можно добавить больше)
  Vcodec := string(copy(TempVcodec, 0, 4));
  if Vcodec = 'div2' then
    Vcodec := 'MS MPEG4 v2'
  else if Vcodec = 'DIV2' then
    Vcodec := 'MS MPEG4 v2'
  else if Vcodec = 'div3' then
    Vcodec := 'DivX;-) MPEG4 v3'
  else if Vcodec = 'DIV3' then
    Vcodec := 'DivX;-) MPEG4 v3'
  else if Vcodec = 'div4' then
    Vcodec := 'DivX;-) MPEG4 v4'
  else if Vcodec = 'DIV4' then
    Vcodec := 'DivX;-) MPEG4 v4'
  else if Vcodec = 'div5' then
    Vcodec := 'DivX;-) MPEG4 v5'
  else if Vcodec = 'DIV5' then
    Vcodec := 'DivX;-) MPEG4 v5'
  else if Vcodec = 'divx' then
    Vcodec := 'DivX 4'
  else if Vcodec = 'mp43' then
    Vcodec := 'Microcrap MPEG4 v3';
  // тоже с аудио
  case TempAcodec of
    0:
      Acodec := 'PCM';
    1:
      Acodec := 'PCM';
    85:
      Acodec := 'MPEG Layer 3';
    353:
      Acodec := 'DivX;-) Audio';
    8192:
      Acodec := 'AC3-Digital';
  else
    Acodec := 'Unknown (' + inttostr(TempAcodec) + ')';
  end;
  // Audio bitrate
  {
    case (trunc(TempAbitrate / 1024 * 8)) of
    246 .. 260:
    Abitrate := 128;
    216 .. 228:
    Abitrate := 128;
    187 .. 196:
    Abitrate := 128;
    156 .. 164:
    Abitrate := 128;
    124 .. 132:
    Abitrate := 128;
    108 .. 116:
    Abitrate := 128;
    92 .. 100:
    Abitrate := 128;
    60 .. 68:
    Abitrate := 128;
    else
    Abitrate := Round(TempAbitrate / 1024 * 8);
    end; }
  // тут некоторые вычисления
  Fps := 1000000 / TempMicrosec; // FPS
  // Length in seconds
  LengthInSec := TempLengthInFrames / Fps;
  // length in minutes
  Length := LengthInSec;
  // Round(LengthInSec - (Int(LengthInSec / 60) * 60));
  // Vbitrate := (TempSize / LengthInSec - TempAbitrate) / 1024 * 8;

  self.SetItem(Cameta_const.VCompression, Vcodec);
  self.SetItem(Cameta_const.VHeight, VHeight.ToString);
  self.SetItem(Cameta_const.VWidth, VWidth.ToString);
  self.SetItem('Channels', (TempAchannels).ToString);
  self.SetItem('SamplesPerSec', TempAsamplerate.ToString);
  self.SetItem('Fps', trunc(Fps).ToString);
  self.Duration := Length;

  // fill up the file info structure
  // TT.Channels := TempAchannels;
  // TT.SamplesPerSec := TempAsamplerate;
  // TT.Duration := Length;
  // TT.BitRate := Abitrate;
  // RetVal.ClipLength := Length;
  // RetVal.VideoCodec := Vcodec;
  // RetVal.ClipBitrate := Vbitrate;
  // RetVal.ClipWidth := VWidth;
  // RetVal.ClipHeight := VHeight;
  // RetVal.ClipFPS := Fps;
  // RetVal.AudioCodec := Acodec;
  // RetVal.AudioBitRate := Abitrate;
  // RetVal.AudioSampleRate := ;
  // RetVal.AudioChannelCnt := TempAchannels;
end;

function TPlayListItemHelper.Selected: boolean;
begin
  result := false;
  if inRange(IndexOf, 0, home.PlayListS.Items.Count - 1) then
    exit(home.PlayListS.Items[IndexOf].Selected);
end;

{ TimeDateHelper }

function RefTimeToSingle(Milisec: int64): single;
begin
  result := RefTimeToMiliSec(Milisec) / TimerInterval
end;

function SingleToRefTime(value: single): int64;
begin
  result := Round(value * 10000) * TimerInterval;
end;

function Timecodet(value: Time_Date): tagDVD_HMSF_TIMECODE;
var
  Ivalue: smallint;
begin
  with result do
  begin
    bHours := 0;
    bMinutes := 0;
    bSeconds := 0;
  end;
  Ivalue := Round(value / 1);
  try
    with result do
    begin
      bHours := Ivalue div 3600;
      bMinutes := (Ivalue - bHours * 3600) div 60;
      bSeconds := (Ivalue - bHours * 3600) - bMinutes * 60;
    end;

  except
    exit;
  end;
end;

function TimecodetToCardinal(HMSFTime: tagDVD_HMSF_TIMECODE): Time_Date;
begin
  with HMSFTime do
    result := ((bHours * 3600) + (bMinutes * 60) + (bSeconds));
end;

function TimeDateToString(value: Time_Date): string;
var
  bHours: Integer;
  bMinutes: Integer;
  bSeconds: Integer;
  Ivalue: Integer;
begin
  Ivalue := Round(value);
  try
    bHours := (Ivalue div 3600);
    bMinutes := ((Ivalue - bHours * 3600) div 60);
    bSeconds := ((Ivalue - bHours * 3600) - bMinutes * 60);
    if bHours = 0 then
      result := (format('%2.2d:%2.2d', [bMinutes, bSeconds]))
    else
      result := (format('%2.2d:%2.2d:%2.2d', [bHours, bMinutes, bSeconds]));
  except
    exit('');
  end;
end;

{ TCopyrecord }

function TCopyrecord.Progress: string;
var
  proc: single;
begin
  if TotalFileSize = 0 then
    exit('');
  proc := ((TotalFileTransferred + TotalBytesTransferred) /
    TotalFileSize) * 100;
  result := format(copyformat, [proc]) + '%]';
end;

{ TCametaString }

function TCString.GetFormatString(const mask: string; item: PointerItem)
  : TCString;
begin
  append(item.GetFormatString(mask));
  result := self;
end;

function TCString.ifthen(value: boolean; Atrue, AFalse: string): TCString;
begin
  append(System.StrUtils.ifthen(value, Atrue, AFalse));
  result := self;
end;

function TCString.ToArray: TArray<string>;
begin
  result := self.ToString.Split([sLineBreak], TStringSplitOptions.ExcludeEmpty);
end;

function TCString.SIA(index: Integer = 0): string;
var
  mas: TArray<string>;
begin
  mas := ToArray;
  if inRange(index, 0, high(mas)) then
    result := mas[index];
end;

initialization

MaskArray := SplitString
  ('*.mkv;*.mpg;*.mpeg;*.vob;*.mp4;*.wm*;*.mp3;*.m4*;*.flac;*.avi;*.flv;*.ape;*.mpc;*.wv;*.ogg;*.wav;*.mpc;*.mp+;*.cda;.3gp;*.vob;*Video_ts.ifo;*.mov;*.webm',
  ';');

end.
