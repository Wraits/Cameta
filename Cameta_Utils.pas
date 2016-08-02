unit Cameta_Utils;

interface

uses DirectShow9, XSuperObject, TagsLibrary, System.Win.Registry,
  System.Classes, CametaTypes, types, DSUtils, System.SysUtils, Vcl.Controls,
  Winapi.Windows, Vcl.Graphics, Vcl.Menus, Cameta_const;

procedure SetFontByComponent(comp: TComponent; Bcolor, Fcolor: TColor);
// ****************************************************************************
Function GISuperObject(title: Tarray<String>; Args: Tarray<String>):ISuperObject;
// ****************************************************************************
function AMatchText(const AText: string; const AValues: array of string): Boolean;
function VkVideoUrl(Url: string; func: tfunc<string, Tstream, Boolean>; out sobj: ISuperObject): Boolean;
function GetSourceCode(Url: String; Stream: Tstream): Boolean;

function ReadTTag(const sobj: ISuperObject; out list: IACoverArt):ISuperObject; overload;
function ReadTTag(const sobj: ISuperObject): ISuperObject; overload;
function ReadTTag(const Filenames: string): ISuperObject; overload;

function FileSize(const aFilename: String): int64;
function GetIext(Filenames: string; MaskArray: TStringDynArray): ext_s;
function URLParserYouTube(address: string; out strs: string): Boolean;
procedure ParserYoutube(adress: string; out sss: ISuperObject);
function GetReadBuffUrl(const fileURL: String; read: tproc<pointer>): int64;
// ****************************************************************************
function ParamCounts(param: pwidechar): Integer;
procedure readDefParam(param: pwidechar; var cmd: Tarray<string>);
function FindCmdLineSwitch(const Switch: string; Cparam: pwidechar;
  var value: Tarray<string>): Boolean; overload;
function ReadStringFromMailslot(out str: String): Boolean;
// ****************************************************************************
function CheckDSErrors(HR: HRESULT): Boolean;
function CheckDSErrorss(HR: HRESULT): Boolean;
function Succeeded(Status: HRESULT): Boolean; overload;
// **********************************************************************
function NewItem(const ACaption: string; AChecked, AEnabled: Boolean;
  ShortCut: string; AOnClick: TNotifyEvent; GroupIndex: Byte = 0;
  Tag: nativeint = 0; iconIndex: Integer = -1): TMenuItem;
// **********************************************************************
procedure EnumeratorRender(const Group: TGUID; const arr: array of string;
  Select: tproc<TFilCatNode>);
// **********************************************************************
// Function IndexRender(GUID: TGUID; index: Integer): TFilCatNode;
// ****************************************************************************
function GetDecoders(EnumMediaType: IEnumMediaType; var index: Integer;
  var Count: Integer): IBaseFilter;
function InitDMO(const clsidDMO, catDMO: TGUID): IBaseFilter;
function GetClisidsFiles(name: string; var LibHandle: HMODULE): Tarray<TGUID>;

Function LoadFilter(name: string; Var filter: IBaseFilter): HRESULT; overload;
Function LoadFilter(name: string; clsid: TGUID; Var filter: IBaseFilter)
  : HRESULT; overload;
function LoadFilter(const Fhandle: HMODULE; clis: TGUID): IBaseFilter; overload;
function LoadFilter(const Filename: string; clis: TGUID): IBaseFilter; overload;
function LoadFilter(const Filename: string): IBaseFilter; overload;
function LoadFilter(clis: TGUID): IBaseFilter; overload;
function ExistsModule(Filename: string; out filepath: string): Boolean;
// ****************************************************************************
procedure prioreter(prioretet: Cardinal);
function GetSpecialPath(CSIDL: Word): string;
// **********************************************************************
function MatchesMask(const Filenames: string; const MaskArray: TStringDynArray)
  : Integer; overload;
function MatchesMask(const Filenames: string; const CaseList: AnsiString)
  : Integer; overload;
// **********************************************************************
procedure LoadSkinS(Picture: TPicture; name: pwidechar);
procedure DefaulLogo;
function DialogsDelete(item: PointerItem): Boolean;
function DeleteFile(filieNames: Tarray<Tfilename>): Boolean; overload;
Procedure CopieFiles(SuperObject: ISuperObject);

function getStream(const Filenames: string): TFileStream;

function EnumeratorLogicalDrivesMenu(DriveType: UINT; out Drives:TArray<String>):integer;

function FolderExecute(TitleName: string; out Folderpath: string): Boolean;
function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string): Boolean;
function GetVolumeLabel(const Drive: string; out VolumeName: string): Boolean;
function FindScanSubFolders(StartFolder: string): Boolean;
// *//////////////////////////////////////////////////////////////////
function ReadRegistry(const Key: string; name: string; def: Double)
  : Double; overload;
function ReadRegistry(const Key: string; name: string; def: string)
  : string; overload;
function ReadRegistry(const Key: string; name: string; def: Boolean)
  : Boolean; overload;
function ReadRegistry(const Key: string; const name: string; var Buffer;
  BufSize: Integer): Integer; overload;
function ReadRegistry(const Key: string; name: string; def: Integer)
  : Integer; overload;
// ************************************************************************
procedure WriteRegistry(const Key: string; name: string;
  const value: string); overload;
procedure WriteRegistry(const Key: string; name: string;
  const value: Boolean); overload;
procedure WriteRegistry(const Key: string; name: string;
  const value: Integer); overload;
procedure WriteRegistry(const Key: string; name: string;
  const value: Double); overload;
procedure WriteRegistry(const Key: string; const name: string; var Buffer;
  BufSize: Integer); overload;
function DeleteValue(const Key: string; const name: string): Boolean;
function GetValueNames(const Key: string): Tarray<string>;
Procedure Regestration;
function GetAssociation: Boolean;
// ************************************************************************
function FileVersion: String;
function AnonymousThread(const ThreadProc: tproc;
  const AThreadName: String): Thandle;
function getSize(siz: int64): string;
function Resize_Bitmap(ImageListThumbs: TImageList; Background: TColor;
  const Source: Vcl.Graphics.TBitmap): Integer;
function ConvertToBmp(PictureFormat: Byte; const Stream: Tstream): TGraphic;
// ***************************************************************************
function applicationCheck: Boolean;
procedure AppendStr(var Dest:String; const S: String);overload;
procedure AppendStr(var Dest:Shortstring; const S: Shortstring);overload;
function StrSplit(const str: String): String;

implementation

uses Forms, ShellApi, wininet, ActiveX, System.Masks, DshowU, ComObj, IdHTTP,
  YoutubeURLParserU, YoutubeU, playerform, DSPackTDCDSPFilter, Winapi.ShlObj,
  other, System.StrUtils, IOUtils, Vcl.Dialogs, math, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, IdSSLOpenSSL, Vcl.Imaging.GIFImg, CametaPlayList,
  CametaControl, System.UITypes;

resourcestring
  StrTaTItle = '"Tags".TITLE';
  StrHttpwwwyoutubec = 'http://www.youtube.com/watch?v=';

const
  qc = '%';

type
  TMyControl = class(TControl)
  public
    property Font;
    property color;
  end;

var
  starttime: Cardinal = 0;

  { procedure TForm1.FormCreate(Sender: TObject);
    begin
    //Ó·˙ˇ‚ÎˇÂÏ Ò‚ÓÈ ¯ËÙÚ
    AddFontResource(ëIZHITSA.TTFí) ;
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0) ;
    //ÔËÏÂÌˇÂÏ Â„Ó
    Button1.f
    ont.name := ëIZHITSAí;
    //Button1.font.size := 10;
    end;
    procedure TForm1.FormDestroy(Sender: TObject);
    begin
    //ÎËÍ‚Ë‰ËÛÂÏ
    RemoveFontResource(ëIZHITSA.TTFí) ;
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0) ;
    end; }
  { function getinf(s: string): string;   var    txt: string;    begin    result := '';    for txt in home.PControls.AudioInfo do    if txt.IndexOf(s)>-1 then    exit(txt.Replace(s+':',''));    end; }

procedure AppendStr(var Dest:String; const S: String);
begin
  Dest := Dest + S;
end;
procedure AppendStr(var Dest:Shortstring; const S: Shortstring);
begin
  Dest := Dest + S;
end;

procedure SetFontByComponent(comp: TComponent; Bcolor, Fcolor: TColor);
var
  i: Integer;
begin
  for i := 0 to comp.ComponentCount - 1 do
    if comp.Components[i] is TControl then
    begin
      TMyControl(comp.Components[i]).Font.color := Fcolor;
      TMyControl(comp.Components[i]).color := Bcolor;
    end;
end;

function StrSplit(const str: String): String;
var
  p: Integer;
begin
  result := '';
  p := 1;
  while str[p] <> ';' do
  begin
    AppendStr(result,str[p]);
    inc(p);
  end;
end;

Function GISuperObject(title: Tarray<String>; Args: Tarray<String>)
  : ISuperObject;
var
  i: Integer;
begin
  result := nil;
  if length(title) <> length(Args) then
    exit();
  result := XSuperObject.so;
  for i := 0 to length(title) - 1 do
    result.SetData(title[i], Args[i]);
end;

function AMatchText(const AText: string;
  const AValues: array of string): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := Low(AValues) to High(AValues) do
    if AText.Contains(AValues[i]) then
      exit(true)
end;

// ******************************************************************************

function URLParserYouTube(address: string; out strs: string): Boolean;
begin
  with TYoutubeURLParser.Create(address) do
    try
      if YoutubeID.length < 5 then
        exit(false);
      strs := StrHttpwwwyoutubec + YoutubeID;
      result := IsValid;
    finally
      Free;
    end;
end;

procedure ParserYoutube(adress: string; out sss: ISuperObject);
var
  FYoutube: TYoutube;
begin
  try
    FYoutube := TYoutube.Create(adress, false);
    sss := XSuperObject.so;
    with sss do
      try
        FYoutube.GetSourceCode := GetSourceCode;
        FYoutube.Parse;
        SetData('Title', FYoutube.title);
        SetData('DURATION', FYoutube.length);
        FYoutube.Informations.Capacity := FYoutube.Informations.Count;
        A['Informations'] := FYoutube.Informations.AsJSONObject['List'].AsArray;
      except
        sss := XSuperObject.so;
      end;
  finally
    FreeAndNil(FYoutube);
  end;
end;

function GetQueryInfo(hRequest: pointer; Flag: Integer;
  var QueryInfo: string): Boolean;
var
  Size, index: Cardinal;
  StringStream: TStringStream;
begin
  result := true;
  Size := 8;
  index := 0;
  StringStream := TStringStream.Create('', TEncoding.Unicode);
  try
    StringStream.SetSize(8);
    if HttpQueryInfo(hRequest, Flag, StringStream.Memory, Size, index) then
      QueryInfo := StringStream.DataString
    else if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      index := 0;
      StringStream.SetSize(Size);
      if HttpQueryInfo(hRequest, Flag, StringStream.Memory, Size, index) then
      begin
        StringStream.SetSize(Size);
        QueryInfo := StringStream.DataString;
        // StringStream.SaveToFile(Flag.tostring + '.txt');
      end;
    end
    else
      exit(false);
  finally
    FreeAndNil(StringStream);
  end;
end;

function GetReadBuffUrl(const fileURL: String; read: tproc<hInternet>): int64;
var
  hSession, hURL: hInternet;
  dwBuffer: string;
  dwTimeOut: Integer;
begin
  result := 0;
  dwTimeOut := 250;

  if fileURL.IsEmpty then
    exit(-1);

  hSession := InternetOpen(PChar('Cameta Media Player'),
    INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    InternetSetOption(hSession, INTERNET_OPTION_RECEIVE_TIMEOUT, @dwTimeOut,
      SizeOf(dwTimeOut));
    InternetSetOption(hSession, INTERNET_OPTION_CONNECT_TIMEOUT, @dwTimeOut,
      SizeOf(dwTimeOut));
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, 0, 0);
    try
      if GetQueryInfo(hURL, HTTP_QUERY_CONTENT_LENGTH, dwBuffer) then
        result := dwBuffer.ToInt64;
      GetQueryInfo(hURL, HTTP_QUERY_CONTENT_TYPE, dwBuffer);
      if dwBuffer.Contains('text') then
        exit(-1);
      if assigned(read) then
        read(hURL);
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession);
  end;
end;

function FileSize(const aFilename: String): int64;
var
  info: TWin32FileAttributeData;
begin
  result := -1;
  if GetFileAttributesEx(pwidechar(aFilename), GetFileExInfoStandard, @info)
  then
    result := int64(info.nFileSizeLow) or int64(info.nFileSizeHigh shl 32);
end;

function ReadTTag(const sobj: ISuperObject; out list: IACoverArt)
  : ISuperObject; overload;
var
  readtag: ITTags;
begin
  result := XSuperObject.so;
  if not assigned(sobj) then
    exit();

  if sobj.S['Filename'].IsEmpty then
    exit();

  readtag := TTags.Create;
  with sobj do
  begin
    if S['Filename'].Contains('//') then
    begin
      i['source_ext'] := 8;
      S['Size'.toupper] := GetReadBuffUrl(S['Filename'],
        procedure(hURL: pointer)
        var
          Stream: TMemoryStream;
          BufferLen: Cardinal;
          fBuf: array [1 .. 1024] of Byte;
          posi: int64;
        begin
          Stream := TMemoryStream.Create;
          try
            repeat
              if not InternetReadFile(hURL, @fBuf, SizeOf(fBuf), BufferLen) then
                exit;
              Stream.Write(fBuf, BufferLen);
              if Stream.Size > readtag.Size then
              begin
                posi := Stream.Position;
                Stream.Position := 0;
                readtag.LoadFromStream(Stream);
                if readtag.Size = 0 then
                  exit;
                Stream.Position := posi;
              end;
            until Stream.Size > readtag.Size;
          finally
            FreeAndNil(Stream);
          end;
        end).ToString;

      if S['Size'] = '-1' then
        exit(sobj);
    end
    else
      try
        if not Contains('Size') then
          S['Size'] := FileSize(S['Filename']).ToString;
        if S['Size'] = '-1' then
          exit(sobj);
        readtag.LoadFromFile(S['Filename']);
      except
        S['Size'] := '-1';
        exit(sobj);
      end;

    if readtag.Loaded then
      with readtag.Tags do
      begin
        if PlayTime > 0 then
          S['Duration'.toupper] := PlayTime.ToString;
        if Channels > 0 then
          S['Channels'] := ChFormat[Channels];
        if SamplesPerSec > 0 then
          i['SamplesPerSec'] := SamplesPerSec;
        if BitsPerSample > 0 then
          i['BitsPerSample'] := BitsPerSample;
        if SampleCount > 0 then
          i['SampleCount'] := SampleCount;
        if BitRate > 0 then
          i['BitRate'] := BitRate;

        list := TTags(readtag).ToarrayCovert;

        O['Tags'] := TTags(readtag).AsTags;

        if sobj[StrTaTItle].AsString.IsEmpty then
          S[C_title] := tpath.GetFileNameWithoutExtension(sobj.S['Filename']);
      end;

    if sobj[StrTaTItle].AsString.IsEmpty and sobj[C_title].AsString.IsEmpty then
      S[C_title] := tpath.GetFileNameWithoutExtension(S['Filename']);

    if not sobj['"Tags".TITLE'].AsString.IsEmpty then
      Remove(C_title);
    exit(sobj);
  end;
end;

function ReadTTag(const sobj: ISuperObject): ISuperObject;overload;
var
  list: IACoverArt;
begin
  exit(ReadTTag(sobj, list))
end;

function ReadTTag(const Filenames: string): ISuperObject;
begin
  result := XSuperObject.so;

  if Filenames.IsEmpty then
    exit();
  if Filenames.Chars[0] = '{' then
    try
      exit(ReadTTag(Filenames))
    except
      exit;
    end;

  if not result.Contains('Filename') then
    result.SetData('Filename', Filenames);

  exit(ReadTTag(result));
end;

function GetSourceCode(Url: String; Stream: Tstream): Boolean;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  result := true;
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nIL);
  HTTP.IOHandler := SSL;
  HTTP.Request.Accept := '*/*';
  HTTP.Request.UserAgent :=
    'Mozilla/5.0 (Windows NT 6.1) Gecko/20130101 Firefox/21.0';
  // HTTP.Request.Host := 'www.vk.com';
  HTTP.HandleRedirects := true;
  HTTP.Request.Referer := Url;
  try
    try
      HTTP.Get(Url, Stream);
    except
      exit(false);
    end;
  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
  end;
end;

function VkVideoUrl(Url: string; func: tfunc<string, Tstream, Boolean>;
Out sobj: ISuperObject): Boolean;
var
  value: string;
  Stream: TStringStream;
  RemoveStr: tfunc<string, string, string>;
  ssst: ISuperObject;

begin
  Stream := TStringStream.Create;
  with Stream do
    try
      if not func(Url, Stream) then
        exit(false);
      RemoveStr := function(text: string; Word: string): string
        begin
          result := text.Remove(0, text.IndexOf(Word) + Word.length).Trim;
        end;

      value := RemoveStr(DataString, 'nvar vars = ');
      value := value.Substring(0, value.IndexOf('};') + 1).replace('\', '');
      ssst := XSuperObject.so(value);
      sobj := XSuperObject.so;
      sobj.S['Title'] := ssst.S['md_title'];
      sobj.F['DURATION'] := ssst.F['duration'];
      with ssst do
        while not EoF do
        begin
          if not CurrentKey.Contains('video_get_current_url') then
            if CurrentKey.Contains('url') then
              sobj.A['Informations']
                .Add(GISuperObject(['Quality', 'VideoLink'],
                [CurrentKey, ssst[CurrentKey].AsString]));
          Next;
        end;
      result := true;
    finally
      Stream.Free;
    end;
end;

// ******************************************************************************
function ExistsModule(Filename: string; out filepath: string): Boolean;
var
  appfolser: string;
begin
  result := false;
  appfolser := ExtractFilePath(application.ExeName);
  if appfolser = '' then
    exit(false);

  if FileExists((appfolser + 'system\' + Filename)) then
  begin
    filepath := (appfolser + 'system\' + Filename);
    exit(true);
  end;

  if FileExists(appfolser + Filename) then
  begin
    filepath := (appfolser + Filename);
    exit(true);
  end;

  if FileExists(Filename) then
  begin
    filepath := (Filename);
    exit(true);
  end;
end;

function EnumSubKeys(const Key: string): Tarray<String>;
var
  Registry: TRegistry;
  stts: TStringList;
  txt: string;
begin
  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CLASSES_ROOT;
    if Registry.OpenKeyReadOnly(Key) then
    begin
      stts := TStringList.Create;
      Registry.GetKeyNames(stts);
      Registry.CloseKey;
      for txt in stts.ToStringArray do
        if Registry.OpenKey(Key + '\\' + txt + '\\InprocServer32', false) then
        begin
          result := result + [txt];
          Registry.CloseKey;
        end;
    end;
  Finally
    FreeAndNil(stts);
    Registry.Free;
  End;
end;

function GetClisidsFiles(name: string; var LibHandle: HMODULE): Tarray<TGUID>;
Var
  DllRegisterServerProc: Function: HRESULT; STDCALL;
  DllUnregisterServer: Function: HRESULT; STDCALL; // DllUnregisterServer
  strKeyLMUser, strKeyUser, strKeyClass: string;
  hKeyFakeLOCALUser, hKeyFakeUser, hKeyFakeClass: HKEY;
  tmpname: string;
  clsid: TGUID;
  stst: Tarray<String>;
  txt: string;
Begin

  if not ExistsModule(name, tmpname) then
    exit;
  try
    LibHandle := safeLoadLibrary(pwidechar(tmpname));
    If LibHandle = 0 Then
      exit();
    DllRegisterServerProc := GetProcAddress(LibHandle, 'DllRegisterServer');
    DllUnregisterServer := GetProcAddress(LibHandle, 'DllUnregisterServer');

    strKeyClass := registr + '\HKEY_CLASSES_ROOT';
    if RegCreateKey(HKEY_CURRENT_USER, pwidechar(strKeyClass), hKeyFakeClass) = ERROR_SUCCESS
    then
      OleCheck(RegOverridePredefKey(HKEY_CLASSES_ROOT, hKeyFakeClass));

    strKeyLMUser := registr + '\HKEY_LOCAL_MACHINE';
    if RegCreateKey(HKEY_CURRENT_USER, pwidechar(strKeyLMUser),
      hKeyFakeLOCALUser) = ERROR_SUCCESS then
      OleCheck(RegOverridePredefKey(HKEY_LOCAL_MACHINE, hKeyFakeLOCALUser));

    strKeyUser := registr + '\HKEY_CURRENT_USER';
    if RegCreateKey(HKEY_CURRENT_USER, pwidechar(strKeyUser), hKeyFakeUser) = ERROR_SUCCESS
    then
      OleCheck(RegOverridePredefKey(HKEY_CURRENT_USER, hKeyFakeUser));

    OleCheck(DllRegisterServerProc);
    // GetClsidsFromRegistry(hKeyFakeClass, stst);
    stst := EnumSubKeys('CLSID');
    OleCheck(DllUnregisterServer);
    OleCheck(RegOverridePredefKey(HKEY_CURRENT_USER, 0));
    OleCheck(RegOverridePredefKey(HKEY_CLASSES_ROOT, 0));
    OleCheck(RegOverridePredefKey(HKEY_LOCAL_MACHINE, 0));
    RegCloseKey(hKeyFakeUser);
    RegCloseKey(hKeyFakeClass);
    RegCloseKey(hKeyFakeLOCALUser);
    OleCheck(RegDeleteKey(HKEY_CURRENT_USER, pwidechar(strKeyUser)));
    OleCheck(RegDeleteKey(HKEY_CURRENT_USER, pwidechar(strKeyClass)));
    OleCheck(RegDeleteKey(HKEY_CURRENT_USER, pwidechar(strKeyLMUser)));
    with TRegistry.Create do
      Try
        RootKey := HKEY_CURRENT_USER;
        DeleteKey(strKeyUser);
        DeleteKey(strKeyClass);
      Finally
        Free;
      End;
    for txt in stst do
      if Succeeded(CLSIDFromString(pwidechar(txt), clsid)) then
        result := result + [clsid];
  except
    exit();
  end;
end;
// ******************************************************************************

function Resize_Bitmap(ImageListThumbs: TImageList; Background: TColor;
const Source: Vcl.Graphics.TBitmap): Integer;
var
  R: TRect;
  Dest: Vcl.Graphics.TBitmap;
begin
  result := -1;
  if not assigned(Source) then
    exit;
  Dest := Vcl.Graphics.TBitmap.Create;
  try
    if Source.Width > Source.Height then
    begin
      R.Right := ImageListThumbs.Width;
      R.Bottom := ((ImageListThumbs.Width * Source.Height) div Source.Width);
    end
    else
    begin
      R.Right := ((ImageListThumbs.Height * Source.Width) div Source.Height);
      R.Bottom := ImageListThumbs.Height;
    end;
    R.Left := 0;
    R.Top := 0;
    Dest.PixelFormat := Source.PixelFormat;
    Dest.Width := ImageListThumbs.Width;
    Dest.Height := ImageListThumbs.Height;
    Dest.Canvas.Brush.color := Background;
    Dest.Canvas.FillRect(Dest.Canvas.ClipRect);
    Dest.Canvas.StretchDraw(R, Source);
    result := ImageListThumbs.Add(Dest, nil);
  finally
    FreeAndNil(Dest);
  end;
end;

function ConvertToBmp(PictureFormat: Byte; const Stream: Tstream): TGraphic;
begin
  case TTagPictureFormat(PictureFormat) of
    tpfJPEG:
      result := TGraphic(TJPEGImage.Create);
    tpfPNG:
      result := TGraphic(TPNGImage.Create);
    tpfGIF:
      result := TGraphic(TGIFImage.Create);
    tpfBMP:
      result := TGraphic(TBitmap.Create);
  end;
  Stream.Seek(0, soBeginning);
  try
    result.LoadFromStream(Stream);
  except
    FreeAndNil(result);
  end;
end;

// ******************************************************************************

function applicationCheck: Boolean;
var
  HM: Thandle;
begin
  HM := OpenMutex(MUTEX_ALL_ACCESS, false, pwidechar(Cametaname));
  result := (HM <> 0);
  if HM = 0 then
    CreateMutex(nil, false, pwidechar(Cametaname));
end;

// ***************************************************************************
procedure LoadSkinS(Picture: TPicture; name: pwidechar);
var
  pngimage: TPNGImage;
begin
  if FindResource(HInstance, Name, RT_BITMAP) <> 0 then
    Picture.Bitmap.LoadFromResourceName(HInstance, Name)
  else
  begin
    pngimage := TPNGImage.Create;
    pngimage.LoadFromResourceName(HInstance, Name);
    Picture.Assign(pngimage);
    pngimage.Free
  end;
end;

procedure DefaulLogo;
var
  png: TPNGImage;
begin
  png := TPNGImage.Create;
  png.LoadFromResourceName(HInstance, 'cametalogos');
  home.logoImages.Picture.Assign(png);
  FreeAndNil(png);
end;

function DialogsDelete(item: PointerItem): Boolean;
begin
  result := (MessageDlg('Delete Files: ' + ExtractFilename(item.Filename),
    mtWarning, mbYesNo, 0) = mrYes);
end;

function DeleteFile(filieNames: Tarray<Tfilename>): Boolean; overload;
begin
  result := true;
  AnonymousThread(
    procedure
    var
      Filename: string;
    begin
      for Filename in filieNames do
      begin
{$WARN SYMBOL_PLATFORM OFF}
        Tfile.SetAttributes(Filename, [TFileAttribute.faNormal]);
{$WARN SYMBOL_PLATFORM ON}
        if not System.SysUtils.DeleteFile(Filename) then
          ShowMessage(format('‘‡ÈÎ ÌÂ Û‰‡ÎÂÌ %s ,=%s',
            [ExtractFilename(Filename),
            System.SysUtils.SysErrorMessage(GetLastError)]));
      end;
    end, 'Delete Files');
end;

function getSize(siz: int64): string;
const
  ezt: Packed array [1 .. 4] of string = ('Byte', 'KB', 'MB', 'GB');
var
  S: string;
  x: Extended;
begin
  x := siz / 1;

  for S in ezt do
  begin
    if x / 1024 < 1 then
      exit(FloatToStrF(x, ffFixed, 4, 2) + ' ' + S)
    else
      x := x / 1024;
  end;
end;

function getStream;
begin
  try
    result := TFileStream.Create(Filenames, fmOpenRead OR fmShareDenyNone);
  except
    result := nil;
    exit;
  end;
end;

function FileVersion: String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: pointer;
  PVerValue: PVSFixedFileInfo;
  iLastError: DWORD;
begin
  result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(application.ExeName), Dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(PVerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(application.ExeName), 0, VerInfoSize, PVerInfo)
      then
      begin
        if VerQueryValue(PVerInfo, '\', pointer(PVerValue), VerValueSize) then
          with PVerValue^ do
            result := format('%d.%d.%d build %d', [HiWord(dwFileVersionMS),
            // Major
            LoWord(dwFileVersionMS), // Minor
            HiWord(dwFileVersionLS), // Release
            LoWord(dwFileVersionLS)]); // Build
      end
      else
      begin
        iLastError := GetLastError;
        result := format('GetFileVersionInfo failed: (%d) %s',
          [iLastError, SysErrorMessage(iLastError)]);
      end;
    finally
      FreeMem(PVerInfo, VerInfoSize);
    end;
  end;
end;

function CheckDSErrors(HR: HRESULT): Boolean;
begin
  result := false;
  case HR of
    s_ok:
      exit(true);
    VFW_S_PARTIAL_RENDER:
      begin
        exit(true);
      end;
    VFW_S_AUDIO_NOT_RENDERED:
      begin
        exit(true);
      end;
    VFW_S_VIDEO_NOT_RENDERED:
      begin
        exit(true);
      end
  end;
end;

function CheckDSErrorss(HR: HRESULT): Boolean;
var
  Excep: EDirectShowException;
  // var  Excep :DSUtils.EDirectShowException;
begin
  // BarAction := false;
  case HR of

    s_ok:
      exit(true);

    VFW_S_PARTIAL_RENDER:
      begin
        application.MessageBox(pwidechar(GetErrorString(HR) + ' (Error Code : '
          + inttohex(HR, 8) + ')'), pwidechar(Cametaname), MB_OK);
        exit(true);
      end;

    VFW_S_AUDIO_NOT_RENDERED:
      begin
        application.MessageBox(pwidechar(GetErrorString(HR) + ' (Error Code : '
          + inttohex(HR, 8) + ')'), pwidechar(Cametaname), MB_OK);
        exit(true);
      end;

    VFW_S_VIDEO_NOT_RENDERED:
      begin
        application.MessageBox(pwidechar(GetErrorString(HR) + ' (Error Code : '
          + inttohex(HR, 8) + ')'), pwidechar(Cametaname), MB_OK);
        exit(true);
      end

  else
    begin
      Excep := DSUtils.EDirectShowException.Create
        (GetErrorString(HR) + format(' ($%x).', [HR]));
      Excep.ErrorCode := HR;
      raise Excep;
    end;
  end;
end;

function Succeeded(Status: HRESULT): Boolean; overload;
begin
  result := Status = s_ok;
end;

procedure EnumeratorRender(const Group: TGUID; const arr: array of string;
Select: tproc<TFilCatNode>);
var
  i: Integer;
  SysDevEnum: TSysDevEnum;
begin
  SysDevEnum := TSysDevEnum.Create(Group);
  with SysDevEnum do
    try
      for i := 0 to CountFilters - 1 do
        if length(arr) > 0 then
        begin
          if MatchStr(guidtostring(Filters[i].clsid), arr) then
            Select(Filters[i]);
        end
        else
          Select(Filters[i]);
    finally
      FreeAndNil(SysDevEnum);
    end;
end;

{ Function IndexRender(GUID: TGUID; index: Integer): TFilCatNode;
  begin
  with TSysDevEnum.Create(GUID) do
  try
  if inRange(index, 0, CountFilters - 1) then
  result := Filters[index];
  finally
  Free;
  end;
  end; }

function FindScanSubFolders(StartFolder: string): Boolean;
var
  SearchRec: TSearchRec;
begin
  result := false;
  StartFolder := IncludeTrailingPathDelimiter(StartFolder);
  ChDir(StartFolder);
  try
    if FindFirst(StartFolder + '*.*', faAnyFile, SearchRec) = 0 then
      repeat
        with SearchRec do
          if (Attr and faDirectory) <> 0 then
            if (Name <> '.') and (Name <> '..') then
              exit(true);
      until FindNext(SearchRec) <> 0;
  finally
    System.SysUtils.FindClose(SearchRec);
  end;
end;

function AnonymousThread(const ThreadProc: tproc;
const AThreadName: String): Thandle;
begin
  with TThread.CreateAnonymousThread(ThreadProc) do
  begin
    OnTerminate := home.OnTerminate;
    Priority := tpHighest;
    result := Handle;
    NameThreadForDebugging(AThreadName, ThreadID);
    start;
  end;
end;

// MEDIATYPE_Audio
// video=0,audio=1,sub=2
function NewItem(const ACaption: string; AChecked, AEnabled: Boolean;
ShortCut: string; AOnClick: TNotifyEvent; GroupIndex: Byte = 0;
Tag: nativeint = 0; iconIndex: Integer = -1): TMenuItem; overload;
begin
  result := Vcl.Menus.NewItem(ACaption, 0, AChecked, AEnabled, AOnClick, 0, '');
  result.GroupIndex := GroupIndex;
  result.Tag := Tag;
  result.ImageIndex := iconIndex;
  result.ShortCut := TextToShortCut(ShortCut);
end;

function ReadRegistry(const Key: string; name: string; def: Double): Double;
var
  Registry: TRegistry;
begin
  result := def;
  Registry := TRegistry.Create;
  with Registry do
    try
      try
        RootKey := HKEY_CURRENT_USER;
        OpenKey(Key, false);
        if ValueExists(name) then
          result := Readfloat(name);
      except
        result := def;
      end;
    finally
      FreeAndNil(Registry);
    end;
end;

function ReadRegistry(const Key: string; name: string; def: string): string;
var
  Registry: TRegistry;
begin
  result := def;
  Registry := TRegistry.Create;
  with Registry do
    try
      try
        RootKey := HKEY_CURRENT_USER;
        OpenKey(Key, false);
        if ValueExists(name) then
          result := ReadString(name);
      except
        result := def;
      end;
    finally
      FreeAndNil(Registry);
    end;
end;

function ReadRegistry(const Key: string; name: string; def: Boolean): Boolean;
begin
  try
    result := ReadRegistry(Key, name, Integer(def)) <> 0;
  except
    result := def;
  end;
end;

function ReadRegistry(const Key: string; const name: string; var Buffer;
BufSize: Integer): Integer;
var
  Registry: TRegistry;
begin
  result := 0;
  Registry := TRegistry.Create;
  with Registry do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, false);
      if ValueExists(name) then
        result := readBinaryData(Name, Buffer, BufSize);
    finally
      FreeAndNil(Registry);
    end;
end;

function ReadRegistry(const Key: string; name: string; def: Integer): Integer;
var
  Registry: TRegistry;
begin
  result := def;
  Registry := TRegistry.Create;
  with Registry do
    try
      try
        RootKey := HKEY_CURRENT_USER;
        OpenKey(Key, false);
        if ValueExists(name) then
          result := ReadInteger(name);
      except
        result := def;
      end;
    finally
      FreeAndNil(Registry);
    end;
end;

procedure WriteRegistry(const Key: string; name: string;
const value: string); overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, true);
      WriteString(name, value);
      CloseKey;
    finally
      FreeAndNil(Registry);
    end;
end;

procedure WriteRegistry(const Key: string; name: string;
const value: Boolean); overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, true);
      WriteBool(name, value);
      CloseKey;
    finally
      FreeAndNil(Registry);
    end;
end;

procedure WriteRegistry(const Key: string; name: string; const value: Integer);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, true);
      writeInteger(name, value);
      CloseKey;
    finally
      FreeAndNil(Registry);
    end;
end;

procedure WriteRegistry(const Key: string; name: string;
const value: Double); overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, true);
      WriteFloat(name, value);
      CloseKey;
    finally
      FreeAndNil(Registry);
    end;
end;

procedure WriteRegistry(const Key: string; const name: string; var Buffer;
BufSize: Integer);
begin
  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(Key, true);
      WriteBinaryData(name, Buffer, BufSize);
    finally
      Free;
    end;
end;

function DeleteValue(const Key: string; const name: string): Boolean;
begin
  result := false;
  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(Key, true) and ValueExists(Name) then
        DeleteValue(Name);
    finally
      Free;
    end;
end;

function GetValueNames(const Key: string): Tarray<string>;
var
  _EQPresets: TStringList;
begin
  _EQPresets := TStringList.Create;
  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(Key, false) then
        GetValueNames(_EQPresets);
      result := _EQPresets.ToStringArray;
    finally
      FreeAndNil(_EQPresets);
      Free;
    end;
end;

// \\\–ÂÂÒÚ\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\App Paths\

procedure RegPO;
var
  S: string;
begin

  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey
        ('\Software\Microsoft\Windows\CurrentVersion\App Paths\Cameta.exe', true)
      then
      begin
        WriteString('', application.ExeName);
        WriteString('Path', ApplicationFolder);
        CloseKey;
      end;

      RootKey := HKEY_CURRENT_USER;
      if OpenKey('\Software\Clients\Media\Cameta Media Player\DefaultIcon', true)
      then
        WriteString('', application.ExeName);
      CloseKey;
      /// ///////
      if OpenKey('\Software\Clients\Media\Cameta Media Player', true) then
      begin
        WriteString('', 'Cameta Media Player');
        WriteString('LocalizedString', 'Cameta Media Player');
        CloseKey;
      end;
      /// ///////////
      if OpenKey('\Software\Clients\Media\Cameta Media Player\Capabilities',
        true) then
      begin
        WriteString('ApplicationDescription', 'Cameta Media Player');
        WriteString('ApplicationName', 'Cameta Media Player');
        CloseKey;
      end;

      if OpenKey
        ('\Software\Clients\Media\Cameta Media Player\Capabilities\FileAssociations',
        true) then
        for S in iext do
          WriteString('.' + S, 'Applications\Cameta.exe');
      CloseKey;
      // \Software\RegisteredApplications
      if OpenKey('\Software\RegisteredApplications', true) then
      begin
        WriteString('Cameta Media Player',
          '\Software\Clients\Media\Cameta Media Player\Capabilities');
        CloseKey;
      end;

    finally
      Free;
    end;
end;

procedure EnsureShellFolderPopupItem;
var
  IconShell: tfunc<string>;
begin
  IconShell := function: string
    begin
      if not ExistsModule('bas_icons.ico', result) then
        result := application.ExeName;
    end;

  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey('\Software\Classes\Directory\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Add Cameta', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[3]
                + ' "%1"');
              CloseKey
            end;

      if OpenKey('\Software\Classes\Directory\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Play Cameta', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[4]
                + ' "%1"');
              CloseKey
            end;

      if OpenKey('\Software\Classes\Directory\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Now Play Cameta', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[6]
                + ' "%1"');
              CloseKey
            end;
      // **** DefaultIcon

      if OpenKey('\Software\Classes\Applications\Cameta.exe\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Open', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[2]
                + ' "%1"');
              CloseKey
            end;

      if OpenKey('\Software\Classes\Applications\Cameta.exe\', true) then
        if OpenKey('DefaultIcon', true) then
        begin
          WriteString('', IconShell);
          CloseKey
        end;

      if OpenKey('\Software\Classes\Applications\Cameta.exe\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Play', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[1]
                + ' "%1"');
              CloseKey
            end;

      if OpenKey('\Software\Classes\Applications\Cameta.exe\', true) then
        if OpenKey('shell', true) then
          if OpenKey('Add Cameta', true) then
            if OpenKey('command', true) then
            begin
              WriteString('', '"' + application.ExeName + '" -' + arrCmd[5]
                + ' "%1"');
              CloseKey
            end;
    finally
      Free;
    end;
end;

function GetAssociation: Boolean;
var
  S: string;
  reg: TRegistry;
begin
  result := false;
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CURRENT_USER;
  try
    begin
      if reg.OpenKey('\Software\Classes\', true) then
        if reg.OpenKey('.' + 'mp3', true) then
          S := reg.ReadString('');
      if S = 'Applications\Cameta.exe' then
        exit(true);
      reg.CloseKey;
    end;
  finally
    FreeAndNil(reg);
  end
end;

procedure association;
var
  S: string;
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CURRENT_USER;
  try
    for S in iext do
    begin
      if reg.OpenKey('\Software\Classes\', true) then
        if reg.OpenKey('.' + S, true) then
          reg.WriteString('', 'Applications\Cameta.exe');
      reg.CloseKey;
    end;
  finally
    FreeAndNil(reg);
  end
end;

Procedure Regestration;
begin
  RegPO;
  EnsureShellFolderPopupItem;
  association;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

// ***************************************************************
function TaskDialogExecute(sources: pwidechar; targets: pwidechar): Integer;
var
{$WARN SYMBOL_PLATFORM OFF}
  TaskDialog: TTaskDialog;
  Button: TTaskDialogBaseButtonItem;
  errorstr: string;
begin
  case GetLastError of
    112:
      errorstr := SysErrorMessage(GetLastError) + ' ' +
        ExtractFileDrive(targets) + '.  Exit now?';
  else
    errorstr := format(StrErroCopy, [ExtractFilename(sources),
      SysErrorMessage(GetLastError)]);
  end;
  TaskDialog := TTaskDialog.Create(home);
  TaskDialog.title := errorstr;
  TaskDialog.Caption := 'Eror Copie File:';
  TaskDialog.CommonButtons := [];
  TaskDialog.ModalResult := MB_ABORTRETRYIGNORE;
  Button := TaskDialog.Buttons.Add;
  Button.Caption := 'Continue';
  Button.ModalResult := MB_OK;
  Button := TaskDialog.Buttons.Add;
  Button.Caption := 'Retry';
  Button.ModalResult := MB_RETRYCANCEL;
  Button := TaskDialog.Buttons.Add;
  Button.Caption := 'Break';
  Button.ModalResult := MB_ABORTRETRYIGNORE;
  TaskDialog.Execute;
  result := TaskDialog.ModalResult;
{$WARN SYMBOL_PLATFORM ON}
end;

function DoFilecopy(Sour: ISuperObject): Boolean;

  function CopyCallback(TotalFileSize, TotalBytesTransferred, StreamSize,
    StreamBytesTransferred: int64; dwStreamNumber, dwCallbackReason: DWORD;
  hSourceFile, hDestinationFile: Thandle; lpData: pointer): DWORD; stdcall;
  const
    PROCESS_CONTINUE = 0;
  begin

    case dwCallbackReason of
      CALLBACK_CHUNK_FINISHED:
        home.SendMessages(copufiles, pointer(TotalBytesTransferred));
      CALLBACK_STREAM_SWITCH:
        ;
      // Thome.SendMessages(copufiles_FileSize, pointer(TotalFileSize));
    end;
    result := PROCESS_CONTINUE;
  end;

var
  sources: pwidechar;
  targets: pwidechar;
  TotalBytesTransferred: int64;
  index: Integer;
begin
  TotalBytesTransferred := 0;
  result := false;
  home.SendMessages(copufiles_AllFileSize,
    pointer(Sour.S['TotalFileSize'].ToInt64));
  index := 0;
  with Sour.A['CopiFiles'] do
    while length > index do
      with XSuperObject.so(S[index]) do
      begin
        sources := pwidechar(S['FileName']);
        targets := pwidechar(S['DestName']);
        inc(TotalBytesTransferred, S['Size'].ToInt64);
        SetLastError(ERROR_SUCCESS);
        result := CopyFileEx(sources, targets, @CopyCallback, pointer(home),
          Pbool(false), 0);
        home.SendMessages(copufiles_FileSize, pointer(TotalBytesTransferred));
        if not result then
        begin
          case TaskDialogExecute(sources, targets) of
            MB_ABORTRETRYIGNORE:
              exit;
            MB_RETRYCANCEL:
              begin
                Dec(TotalBytesTransferred, S['Size'].ToInt64);
                Dec(index);
                home.SendMessages(copufiles_FileSize,
                  pointer(TotalBytesTransferred));
              end;
          end;
        end;
        inc(index);
      end;
end;

procedure IFN(var sb: string);
var
  index: Integer;
  FInvalidFileNameChars: TCharArray;
begin
  FInvalidFileNameChars := TCharArray.Create(#0, #1, #2, #3, #4, #5, #6, #7, #8,
    #9, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20, #21, #22, #23,
    #24, #25, #26, #27, #28, #29, #30, #31, '"', '*', '/', ':', '<', '>', '?',
    '|', ' ');
  for Index := high(FInvalidFileNameChars) - 1 downto 0 do
    sb := sb.replace(FInvalidFileNameChars[Index], '');
end;

function GTF(Folderpath: string): string;
begin
  result := IncludeTrailingPathDelimiter(Folderpath)
end;

Procedure CopieFiles(SuperObject: ISuperObject);
begin
  Tread[4] := AnonymousThread(
    procedure
    var
      paths: string;
      newname: string;
      tt: PointerItem;
    begin
      with SuperObject.A['CopiFiles'].GetEnumerator do
        while MoveNext do
          with XSuperObject.so(Current.AsString) do
          begin
            if not SuperObject.B['TAg_name'] then
            begin
              SetData('DestName', GTF(SuperObject.S['DestPath']) +
                ExtractFilename(S['Filename']));
            end
            else if TCametaList.AddFilename(Current.AsString, tt) then
            begin
              newname := tt.GetFormatString(StrGetPath);
              IFN(newname);
              paths := GTF(SuperObject.S['DestPath']) + newname;
              TDirectory.CreateDirectory(paths);
              // ************************************************************
              newname := tt.GetFormatString(StrGetName);
              newname := newname + ExtractFileExt(tt.Filename);
              IFN(newname);
              paths := IncludeTrailingPathDelimiter(paths) + newname;
              // ************************************************************
              SetData('DestName', paths);
              dispose(tt);
            end;
            Current.AsString := AsJSON;
          end;
      // SuperObject.SaveTo('1.txt');
      DoFilecopy(SuperObject);
    end, 'CopieFilies')
end;

// ***************************************************************
function ReadStringFromMailslot(out str: String): Boolean;
var
  MessageSize: DWORD;
  Len: LongInt;
  BpData: TBytes;
begin
  result := false;
  str := '';
  try
    GetMailslotInfo(ServerMailslotHandle, nil, MessageSize, nil, nil);
    if MessageSize = MAILSLOT_NO_MESSAGE then
    begin
      result := false;
      exit;
    end;
    Fileread(ServerMailslotHandle, Len, SizeOf(Len));
    setlength(BpData, Len);
    if Len > 0 then
      result := (Fileread(ServerMailslotHandle, BpData, 0, Len)) > 0;
    str := StringOf(BpData);
  except
    result := false;
  end;
end;

function EnumeratorLogicalDrivesMenu(DriveType: UINT; out Drives:TArray<String>):integer;
var
  SS: String;
  VolumeName: string;
begin
  Drives:=[];
  for SS in System.IOUtils.TDirectory.GetLogicalDrives do
    if not('A:\' = SS) and (GetDriveType(pwidechar(SS)) = DriveType) and
      GetVolumeLabel(SS, VolumeName) then
      Drives := Drives + [SS + ';' + VolumeName];
    exit(length(Drives));
end;

function GetVolumeLabel(const Drive: string; out VolumeName: string): Boolean;
var
  SerialNum: DWORD;
  A, B: DWORD;
  CVolumeName: array [0 .. MAX_PATH] of char;
begin
  try
    exit(GetVolumeInformation(PChar(Drive), CVolumeName, SizeOf(CVolumeName),
      @SerialNum, A, B, nil, 0));
  finally
    VolumeName := CVolumeName;
  end;
end;

threadvar myDir: string;

function BrowseCallbackProc(hwnd: hwnd; uMsg: UINT; lParam: lParam;
lpData: lParam): Integer; stdcall;
begin
  result := 0;
  if uMsg = BFFM_INITIALIZED then
  begin
    SendMessage(hwnd, BFFM_SETSELECTION, 1, LongInt(PChar(myDir)))
  end;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
var Directory: string): Boolean;
var
  WindowList: pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  myDir := Directory;
  result := false;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = s_ok) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(application.Handle, nil, POleStr(Root),
          Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpfn := @BrowseCallbackProc;
        lParam := Integer(PChar(Directory));
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS or $0040 or BIF_EDITBOX or
          BIF_STATUSTEXT;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);

      end;
      result := ItemIDList <> nil;
      if result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

function FolderExecute(TitleName: string; out Folderpath: string): Boolean;
var
  TempPath: array [0 .. MAX_PATH] of char;
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array [0 .. MAX_PATH] of char;
begin
  result := true;
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  ZeroMemory(@DisplayName, SizeOf(DisplayName));
  ZeroMemory(@TempPath, SizeOf(TempPath));
  Folderpath := '';
  BrowseInfo.hwndOwner := application.Handle;
  DisplayName := 'Current Folder';
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := BIF_NEWDIALOGSTYLE;
  lpItemID := ShBrowseForFolder(BrowseInfo);
  if not assigned(lpItemID) then
    exit(false);
  ShGetPathFromIDList(lpItemID, TempPath);
  Folderpath := TempPath;
  GlobalFreePtr(lpItemID);
  // ZeroMemory(@DisplayName, SizeOf(DisplayName));
  // ZeroMemory(@TempPath, SizeOf(TempPath));
  ZeroMemory(@BrowseInfo, SizeOf(BrowseInfo));
  ZeroMemory(@lpItemID, SizeOf(lpItemID));
end;

function MatchesMask(const Filenames: string; const MaskArray: TStringDynArray)
  : Integer; overload;
begin
  for result := 0 to length(MaskArray) - 1 do
    if System.Masks.MatchesMask(Filenames, MaskArray[result].toupper) then
      exit;
  result := -1;
end;

function MatchesMask(const Filenames: string;
const CaseList: AnsiString): Integer;
begin
  result := MatchesMask(Filenames, SplitString(string(CaseList), ';'));
end;

function GetParamStrs(P: PChar; var param: string): PChar;
var
  i, Len: Integer;
  start, S: PChar;
begin

  while true do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do
      inc(P);
    if (P[0] = '"') and (P[1] = '"') then
      inc(P, 2)
    else
      break;
  end;
  Len := 0;
  start := P;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        inc(Len);
        inc(P);
      end;
      if P[0] <> #0 then
        inc(P);
    end
    else
    begin
      inc(Len);
      inc(P);
    end;
  end;

  setlength(param, Len);

  P := start;
  S := pointer(param);
  i := 0;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        S[i] := P^;
        inc(P);
        inc(i);
      end;
      if P[0] <> #0 then
        inc(P);
    end
    else
    begin
      S[i] := P^;
      inc(P);
      inc(i);
    end;
  end;

  result := P;
end;

function ParamCounts(param: pwidechar): Integer;
var
  P: PChar;
  S: string;
begin
  result := 0;
  P := GetParamStrs(param, S);
  while true do
  begin
    P := GetParamStrs(P, S);
    if S = '' then
      break;
    inc(result);
  end;
end;

function ParamStrs(index: Integer; param: pwidechar): string;
var
  P: PChar;
  // Buffer: array [0 .. 260] of Char;
begin
  result := '';
  if Index = 0 then
    exit;
  P := param;
  while true do
  begin
    P := GetParamStrs(P, result);
    if (Index = 0) or (result = '') then
      break;
    Dec(Index);
  end;
  // end;
end;

procedure readDefParam(param: pwidechar; var cmd: Tarray<string>);
var
  y: Integer;
begin
  for y := 1 to ParamCounts(param) do
    cmd := cmd + [ParamStrs(y, param)];
end;

function FindCmdLineSwitch(const Switch: string; Cparam: pwidechar;
var value: Tarray<string>): Boolean; overload;
type
  TCompareProc = function(const S1, S2: string): Boolean;
var
  param: string;
  i, y, SwitchLen: Integer;
  SameSwitch: TCompareProc;
begin
  result := false;
  // Value := '';
  SameSwitch := SameText;

  for i := 1 to ParamCounts(Cparam) do
  begin
    param := ParamStrs(i, Cparam);
    SwitchLen := param.length;
    if CharInSet(param.Chars[0], SwitchChars) and
      SameSwitch(param.Substring(1, SwitchLen), Switch) then
    begin
      if (i < ParamCounts(Cparam)) and
        not CharInSet(ParamStrs(i + 1, Cparam).Chars[0], SwitchChars) then
        for y := i to ParamCounts(Cparam) - 1 do
          value := value + [(ParamStrs(y + 1, Cparam))];
      result := true;
      break;
    end;
  end;
end;

// procedure loaddecoder;
// begin
// exit;
// graph.AddFilter(LoadFilter(vobsubm, vobsubclisid), SubtitlesFilterName);
//
// LoadFilter(stringtoguid('{E1F1A0B8-BEEE-490D-BA7C-066C40B5E2B9}'));
//
// LoadFilter(stringtoguid('{212690FB-83E5-4526-8FD7-74478B7939CD}'));
//
// LoadFilter(stringtoguid('{E8E73B6B-4CB3-44A4-BE99-4F7BCB96E491}'));
//
// InitDMO(CLISID_WMADECODER, DMOCATEGORY_AUDIO_DECODER);
//
// InitDMO(MP3_DecoderDMO, DMOCATEGORY_AUDIO_DECODER);
// InitDMO(CLISID_WMvDECODER, DMOCATEGORY_VIDEO_DECODER);

// InitDMO(stringtoguid('{CBA9E78B-49A3-49EA-93D4-6BCBA8C4DE07}'),
// DMOCATEGORY_VIDEO_DECODER);
//
// InitDMO(stringtoguid('{F371728A-6052-4D47-827C-D039335DFE0A}'),
// DMOCATEGORY_VIDEO_DECODER);
//
// InitDMO(stringtoguid('{2A11BAE2-FE6E-4249-864B-9E9ED6E8DBC2}'),
// DMOCATEGORY_VIDEO_DECODER);

// LoadFilter(CLISID_ffaDECODER);

// LoadFilter(stringtoguid('{EE30215D-164F-4A92-A4EB-9D4C13390F9F}'));

// LoadFilter('MpaDecFilter.ax',
// stringtoguid('{3D446B6F-71DE-4437-BE15-8CE47174340F}'));
//
// LoadFilter(CLISID_WAVDECODER);
//
// LoadFilter('MPCVideoDec.ax',
// stringtoguid('{008BAC12-FBAF-497B-9670-BC6F6FBAE2C4}'));
//
// LoadFilter('GplMpgDec.ax',
// stringtoguid('{CE1B27BE-851B-45DD-AB26-44389A8F71B4}'));
// LoadFilter(CLISID_ffvDECODER);
//
// LoadFilter('ac3filter.ax', CLISID_AC3FILTER);
// end;

function GetSpecialPath(CSIDL: Word): string;
var
  S: string;
begin
  setlength(S, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(S), CSIDL, true) then
    S := '';
  result := PChar(S);
end;

procedure prioreter(prioretet: Cardinal);
var
  ThreadHandle: Thandle;
begin
  SetPriorityClass(OpenProcess(PROCESS_SET_INFORMATION, false,
    GetCurrentProcessID), prioretet);
  ThreadHandle := GetCurrentThread;
  SetThreadPriority(ThreadHandle, THREAD_PRIORITY_TIME_CRITICAL);
end;


// ****************************************************************************

function GetLoadsDec(Filters: Tarray<string>; var index: Integer;
var Count: Integer): IBaseFilter;
var
  i: Integer;
  st: Tarray<string>;
  clsid: TCLSID;
begin
  Count := length(Filters);
  for i := index to High(Filters) do
  begin
    st := Filters[i].split([';'], TStringSplitOptions.ExcludeEmpty);
    case length(st) of
      1:
        if Succeeded(CLSIDFromString(pwidechar(st[0]), clsid)) then
          result := LoadFilter(clsid)
        else
          result := LoadFilter(st[0]);
      2:
        if Succeeded(CLSIDFromString(pwidechar(st[0]), clsid)) then
          result := LoadFilter(clsid)
        else
          result := LoadFilter(st[0]);
      3:
        result := InitDMO(stringtoguid(st[1]), stringtoguid(st[2]));
    end;

    if assigned(result) then
    begin
      index := i;
      exit(result);
    end;
  end;
end;

function Connect(Filters: Tarray<string>; clisidarr: Tarray<TGUID>): string;
var
  i: Integer;
begin
  for i := 0 to High(clisidarr) do
    Filters := Filters + [clisidarr[i].ToString];
  result := string.Join(';', Filters)
end;

procedure DefaultDecoder(var result: IBaseFilter; var index: Integer;
var Count: Integer);
begin
  result := GetLoadsDec([Connect(['DMA'], [CLISID_WMvDECODER,
    DMOCATEGORY_VIDEO_DECODER]), Connect(['DMA'], [CLISID_WMADECODER,
    DMOCATEGORY_AUDIO_DECODER]), LAV_Audio_Decoder, LAV_Video_Decoder],
    index, Count);
end;

function ReadDeCoders(Guid: TGUID): Tarray<string>;
var
  Registry: TRegistry;
  strings: TStringList;
begin
  Registry := TRegistry.Create;
  Try
    strings := TStringList.Create;
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey(registr + 'clsid\' + Guid.ToString, false) then
    begin
      Registry.GetValueNames(strings);
      result := strings.ToStringArray;
      Registry.CloseKey;
    end;
  Finally
    FreeAndNil(strings);
    Registry.Free;
  End;
end;

function GetDecoders(EnumMediaType: IEnumMediaType; var index: Integer;
var Count: Integer): IBaseFilter;
var
  MediaType: TMediaType;
  ssts: Tarray<string>;
begin
  result := nil;
  try
    for MediaType in EnumMediaType do
    begin
      if MediaType.majortype = MEDIATYPE_Subtitle then
        exit(LoadFilter(vobsubm));
      ssts := ReadDeCoders(MediaType.SubType);
      if length(ssts) > 0 then
        exit(GetLoadsDec(ssts, index, Count));
    end;
  finally
    if not assigned(result) then
      DefaultDecoder(result, index, Count);
  end;
end;

function InitDMO(const clsidDMO, catDMO: TGUID): IBaseFilter;
var
  pDmoWrapper: IDMOWrapperFilter;
  HR: HRESULT;
begin
  HR := CoCreateInstance(CLSID_DMOWrapperFilter, nil, CLSCTX_INPROC,
    IID_IBaseFilter, result);
  if Succeeded(HR) then
  begin
    HR := result.QueryInterface(IID_IDMOWrapperFilter, pDmoWrapper);
    if Succeeded(HR) then
      pDmoWrapper.Init(clsidDMO, catDMO);
    pDmoWrapper := nil;
  end;
end;

Function LoadFilter(name: string; Var filter: IBaseFilter): HRESULT; overload;
Var
  txt: TGUID;
  Fhandle: HMODULE;
Begin
  result := s_false;
  for txt in GetClisidsFiles(name, Fhandle) do
  begin
    filter := LoadFilter(Fhandle, txt);
    if assigned(filter) then
      exit(s_ok);
  end;
end;

Function LoadFilter(name: string; clsid: TGUID;
Var filter: IBaseFilter): HRESULT;
Var
  DllGetClassObject: Function(Const clsid, IID: TGUID; Var Obj)
    : HRESULT; STDCALL;
  LibHandle: Integer;
  ClassF: IClassFactory;
Begin
  result := s_false;
  try
    LibHandle := safeLoadLibrary(pwidechar(name));
    If LibHandle = 0 Then
      exit(s_false);

    DllGetClassObject := GetProcAddress(LibHandle, 'DllGetClassObject');
    DllGetClassObject(clsid, IClassFactory, ClassF);
    if assigned(ClassF) then
    begin
      result := ClassF.CreateInstance(nil, IID_IBaseFilter, filter);
      if result = ERROR_SUCCESS then
        exit;
    end;

  except
    exit(s_false);
  end;
End;

function LoadFilter(const Fhandle: HMODULE; clis: TGUID): IBaseFilter; overload;
Var
  DllGetClassObject: Function(Const clsid, IID: TGUID; Var Obj)
    : HRESULT; STDCALL;
  ClassF: IClassFactory;
Begin
  result := nil;
  try
    If Fhandle = 0 Then
      exit();
    DllGetClassObject := GetProcAddress(Fhandle, 'DllGetClassObject');
    DllGetClassObject(clis, IClassFactory, ClassF);
    if assigned(ClassF) then
    begin
      if ClassF.CreateInstance(nil, IID_IBaseFilter, result) = ERROR_SUCCESS
      then
        exit;
    end;
  except
    exit();
  end;
end;

function LoadFilter(const Filename: string; clis: TGUID): IBaseFilter;
var
  pathF: string;
begin
  // CoCreateInstance(StringtoGUID(clis), nil, CLSCTX_INPROC_SERVER,
  // IID_IBaseFilter, result);
  result := nil;
  if ExistsModule(Filename, pathF) then
    if failed(LoadFilter(pathF, clis, result)) then
      result := nil;
end;

function LoadFilter(const Filename: string): IBaseFilter; overload;
var
  pathF: string;
begin
  result := nil;
  if ExistsModule(Filename, pathF) then
    if failed(LoadFilter(pathF, result)) then
      result := nil;
end;

function LoadFilter(clis: TGUID): IBaseFilter;
begin
  if CoCreateInstance(clis, nil, CLSCTX_INPROC, IID_IBaseFilter, result) <> s_ok
  then
    exit(nil);
end;

// ****************************************************************************

procedure registrFilters;
var
  clisidarr: Tarray<TGUID>;
  Registry: TRegistry;
  Guid: TGUID;
  arr: Tarray<string>;
  txt: string;
begin
  clisidarr := [MEDIASUBTYPE_XVID, MEDIASUBTYPE_xvid1, MEDIASUBTYPE_avc1,
    MEDIASUBTYPE_DX50, MEDIASUBTYPE_h264, MEDIASUBTYPE_MPEG2_VIDEO,
    MEDIASUBTYPE_VP90, MEDIASUBTYPE_VP80, MEDIASUBTYPE_VP62, MEDIASUBTYPE_SVQ3,
    MEDIASUBTYPE_MP3, MEDIASUBTYPE_RAW_AAC1, MEDIASUBTYPE_DVM,
    MEDIASUBTYPE_DVD_LPCM_AUDIO, MEDIASUBTYPE_DOLBY_AC3, MEDIASUBTYPE_Vorbis2,
    MEDIASUBTYPE_MPEG1Packet, MEDIASUBTYPE_MPEG1Payload,
    MEDIASUBTYPE_MPEG1AudioPayload, MEDIASUBTYPE_WMAUDIO_LOSSLESS,
    MEDIASUBTYPE_WAVE];

  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CURRENT_USER;
    for Guid in clisidarr do
    begin
      if not Registry.KeyExists(registr + 'clsid\' + Guid.ToString) then
      begin
        Registry.OpenKey(registr + 'clsid\' + Guid.ToString, true);
        case IndexGUID(Guid, clisidarr) of
          0 .. 1:
            arr := [LAV_Video_Decoder, MPCVideoDecax];
          2:
            arr := [LAV_Video_Decoder, MPCVideoDecax];
          3:
            arr := [LAV_Video_Decoder, MPCVideoDecax];
          4:
            arr := [LAV_Video_Decoder, MPCVideoDecax];
          5:
            arr := [LAV_Video_Decoder, GplMpgDec];
          6 .. 9:
            arr := [LAV_Video_Decoder];
          10:
            arr := [Connect(['DMA'], [MP3_DecoderDMO,
              DMOCATEGORY_AUDIO_DECODER])];
          11:
            arr := [MpaDecFilter, LAV_Audio_Decoder];
          12:
            arr := [MpaDecFilter, LAV_Audio_Decoder];
          13 .. 14:
            arr := ['ac3filter.ax', MpaDecFilter, LAV_Audio_Decoder];
          15:
            arr := [LAV_Audio_Decoder];
          16 .. 17:
            arr := [CLSID_CMpegVideoCodec.ToString];
          18:
            arr := [CLSID_CMpegAudioCodec.ToString];
          19:
            arr := [Connect(['DMA'], [CLISID_WMADECODER,
              DMOCATEGORY_AUDIO_DECODER])];
          20:
            arr := ['{D51BD5A1-7548-11CF-A520-0080C77EF58A}'];
        end;
        for txt in arr do
          Registry.WriteString(txt, '');
        Registry.CloseKey;
      end;
    end;
  Finally
    Registry.Free;
  End;
end;

function GetIext(Filenames: string; MaskArray: TStringDynArray): ext_s;
begin
  result := unkow;
  if Filenames.IsEmpty then
  begin
    exit(unkow);
  end;

  if Filenames.Contains('//') then
  begin
    result := Url;
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
          exit(unkow);
        end;
      5:
        begin
          result := (wmv);
        end;
      6 .. 8:
        begin
          result := (bass);
        end;
      9:
        begin
          exit(avi);
        end;
      10:
        exit(flv);
      11 .. 12:
        begin
          result := (bass);
        end;
      13 .. 17:
        begin
          result := (bass);

        end;
      18:
        result := (cda);
      21:
        begin
          result := (dvd);
        end;
      23:
        exit(unkow);
      -1:
        begin
          exit(unkow);
        end;
    end;
end;



// if MediaType.majortype = MEDIATYPE_Subtitle then
// exit(LoadFilter(vobsubm));

// txt := MediaType.SubType.ToString;

initialization

registrFilters;

finalization

end.
