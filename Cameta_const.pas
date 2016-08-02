// { TreadHandle= array [0..10] of THandle;  0:  FCopyProgressText := 'Rendering...';  1:  FCopyProgressText := 'Starting Play';  2:  FCopyProgressText := 'Search Files';  3:  FCopyProgressText := 'Search Files';  4:  FCopyProgressText := 'Search DVD';  5: FCopyProgressText := 'Load Playlist'; 6:  FCopyProgressText := 'Search Track';  7:  ;  8:  FCopyProgressText := 'Search Files';  9:  FCopyProgressText := FCopyS;

unit Cameta_const;

interface

uses
  Messages,
  EVR9,
  DirectShow9,
  System.Generics.Collections,
  TagsLibrary,
  System.SysUtils;

resourcestring
  StrEQPresets = 'EQPresets';
  PositiP = 'PositionProc';
  State = 'State';
  BitFloat = 'BitFloat';
  StrMaskTitle =
    '.::[%ARTIST% Ч ["["%ALBUM%[ CD%DISCNUMBER%[/%TOTALDISCS%]][ %YEAR%]"]"] ]%TITLE%::.';
  SttCaption = '[] .::::.';
  StrMask = ' Ч []';
  StrPlaylisSupportType = 'Playlist|*.m3u|All Fiels|*.*';
  StrLogo = 'Logo';
  StrPlaylist = 'Playlist';
  StrSupportType = 'Support Type|*.avi;*.mpg;*.mp4;*.mpg;*.mpeg;*.3gp;*.wmv;' +
    '*.mp3;*.wma;*.ogg;*.wav;*.dat;*.mpeg;*.flac;*.flv;*.ape;*.m4a;*.mkv;*.wv;'
    + '*.cda;*.vob|All Files|*.*|Dvd Video|VIDEO_TS.IFO;|IFO|*.IFO';
  StrPlaylistWidth = 'PlaylistWidth';
  StrLoadTrack = 'Load Track';
  StrSearchDVD = 'Search DVD';
  StrRendering = 'Rendering...';
  StrWindowspos = 'WindowsPosition';
  StrDeleteFiles = 'Delete Files ?';
  RegSpectr = 'Spectr';
  StrOpenLogo = 'Open Logo';
  StrSkinlogo = 'skin\logo';
  StrBarStart = 'BarStart';
  StrBarEnd = 'BarEnd';
  StrBackStart = 'BackStart';
  StrBackEnd = 'BackEnd';
  StrBackVisual = 'Back';
  StrMute = 'Mute';
  TPlay = 'Play';
  TPause = 'Pause';
  Tstop = 'Stop';
  Cametaname = 'Cameta Media Player';
  Cametapls = 'CametaPLS';
  AudioRenderS = 'Audio Renderer';
  VideoRenderS = 'Video Renderer';
  SoundFormat = 'Volume:[%2f db]';
  SeekFormat = 'Seek To:[ %s (-%s) / %s ] - %2f';
  copyformat = 'Copy Files [%2f';
  Muteformat = 'Mute: ';
  VisualizationF = 'Visualization: ';
  CloseFileSF = 'Close File';
  PreviousFormat = ('Previous Track');
  NextFormat = ('Next Track');
  SearchFPT = 'Search Folder Previous Track';
  SearchFNT = ('Search Folder Next Track');
  NextCF = 'Next Chapter (Ctrl down)';
  PreviousCF = 'Previous Chapter (Ctrl down)';
  FoldesOpenF = 'C подпапками ' + #13;
  LogoF = '‘айл Logo ненайден ';
  SAFTSTF = 'Select a folder to Search Track';
  TSOpen_FolderF = 'Open_Folder';
  SearchTrackF = 'Search Track';
  OpenPlaylistSF = 'Open Playlist';
  OpenPlaylistS = 'Open Playlist - [%s]';
  OpenFolderS = 'Open Folder - [%s]';
  AddFolderS = 'Add Folder - [%s]';
  SearchFolderS = 'Search Folder - [%s]';
  AddTrackS = 'Add Track';
  AddPlaylistS = 'Add Playlist - [%s]';
  SelectFilesSF = '.::Select %d Files ::.';
  AddFilesS = 'Add Files';
  OpenFilesS = 'Open File(s)...';
  SearchDVDS = 'Search DVD';
  OpenSF = 'Open';
  ResumePlaybackF = 'Resume Playback: %s';
  RestartPlaybackSF = 'Restart Playback: %s';
  StartPlaybackFS = 'Start Playback: %s';
  NewTrackFSS = '%d of %d %s New Track';
  PlayFS = '%d of %d %s Play';
  StopFS = '%d of %d %s Stop';
  PauseFSF = '%d of %d %s Pause';
  PauseFS = 'Pause Playback: %s';
  DynAmpSF = 'Out %s Amplify %.1fx';
  Stopafterthistrack = ('Stop after this track');
  StrLoadPrevNextFileinFo = 'LoadPrevNextFileinFolder';
  StrLinearVolume = 'LinearVolume';
  StrShowBalloonHint = 'ShowBalloonHint';
  StrRestorePlayback = 'RestorePlayback';
  StrSoundLevel = 'SoundLevel';
  StrStartPosiion = 'Setpos';
  StrStartPlayTitle = 'PlayTitle';
  StrStartPlayTrack = 'PlayTrack';
  StrStartPlayStat = 'PlayStat';
  StrAudioRender = 'AudioRender';
  StrVideoRender = 'VideoRender';
  StrRevers = 'revers';
  StrTimerevers = 'timerevers';
  StrActivePage = 'ActivePage';
  StrOpenControlPanel = 'Open: Control Panel';
  StrAllChannels = 'All Channels';
  StrAVolumes = 'Amplify Volume(%s):%s';
  StrTimeAttackS = 'Time Attack: [%s]';
  StrMaximumAmplificatio = 'Maximum Amplification: [%s]';
  StrReleasetimeS = 'Releasetime: [%s]';
  StrBalance = 'Balance';
  StrBalanceS = 'Balance: [%S]';
  StrBalanceLeftChannl = 'Balance: Left Channle[%2f db]';
  StrBalanceRightChann = 'Balance: Right Channle[%2f db]';
  StrCenter = 'Center';
  StrAmplify = 'Amplify:';
  StrDynamicAmplify = ' Dynamic Amplify:';
  StrEqualizer = 'Equalizer:';
  StrVisualization = 'Visualization:';
  StrChannelS = 'Channel: [%s]';
  StrMaxAmplifyVolume = 'Max Amplify Volume: [%s]';
  StrRangedbd = 'Range(db):%d';
  StrLoadPresents = 'Load EQPreset ';
  StrVideoCollapsed = 'VideoCollapsed';
  StrSoundCollapsed = 'SoundCollapsed';
  StrEQPresetName = 'EQPresetName';
  StrErroCopy = '‘айл не скопирован %s, = %s.  Exit now?';
  StrGetPath = '[%ARTIST%\]["["%YEAR%"]"][ - %album%]';
  StrGetName = '[%TRACKNUMBER%.][%TOTALTRACKS% ]%Title%';
  Dslibdvdnav = 'dslibdvdnav.ax';
  FLVSplitter = 'FLVSplitter.ax';
  MatroskaSplitter = 'MatroskaSplitter.ax';
  rMP4Splitter = 'MP4Splitter.ax';
  MpegSplitter = 'MpegSplitter.ax';
  CAviSplitter = 'AviSplitter.ax';

const
  S_Dsp = 'DSP Filter';
  SubtitlesFilterName = 'Subtitle';
  SSubName = 'Subtitles';
  HomeMESSAGE = WM_USER + 4240;
  SC_DragMove = $F012;
  ABOVE_NORMAL_PRIORITY_CLASS = $00008000;
  CametaPLSv = 1;
  WM_GRAPHNOTIF = WM_APP + 1;
  group_m = 001;
  st = 1;
  SoundChang = st + 120;
  copufiles_FileSize = SoundChang + 1;
  copufiles = copufiles_FileSize + 1;
  copufiles_AllFileSize = copufiles + 1;
  MuteBS = copufiles_AllFileSize + 1;
  // GraphError = MuteBS + 1;
  LoadPlayback = MuteBS + 1;
  // **********************spliter codec****************************************
  allspliter: TGUID = '{E436EBB5-524F-11CE-9F53-0020AF0BA770}';
  DCDSPFilter = 'DCDSPFilter.dll';
  dspFiltrclis: TGUID = '{B38C58A0-1809-11D6-A458-EDAE78F1DF12}';
  accpath = 'mmaacd.ax';
  accclisid: TGUID = '{3FC3DBBF-9D37-4CE0-8689-653FE8BAB9B3}';
  aacc: TGUID = '{000000FF-0000-0010-8000-00AA00389B71}';
  flacsource = 'madFlac.ax';
  flacclisid: TGUID = '{C52908F0-1C06-4C0D-A4CD-3D10EA51C757}';
  cddreader = 'cddareader.ax';
  cddreaderclisid: TGUID = '{54A35221-2C8D-4A31-A5DF-6D809847E393}';
  avi_spliter: TGUID = '{1B544C20-FD0B-11CE-8C63-00AA0044B51E}';
  vobsubclisid: TGUID = '{93A22E7A-5091-45EF-BA61-6DA26156A5D0}';
  vobsubm = 'vsfilter.dll';
  MpaSplitterclisid: TGUID = '{0E9D4BF7-CBCB-46C7-BD80-4EF223A3DC2B}';
  MpaSplitter = 'MpaSplitter.ax';
  Mac: TGUID = '{41FAF0F4-DCEC-4F6A-82D2-56E100F2A8E5}';
  MacFilter = 'RLAPEDec.ax';
  MpaDecFilter = 'MpaDecFilter.ax';
  MPCVideoDecax = 'MPCVideoDec.ax';
  GplMpgDec = 'GplMpgDec.ax';
  // VorbisDecoderclisid: TGUID = '{02391F44-2767-4E6A-A484-9B47B506F3A4}';
  // VorbisDecoder = 'vorbis\VorbisDS.ax';

  // OggDSclisid: TGUID = '{F07E245F-5A1F-4D1E-8BFF-DC31D84A55AB}';
  // OggDS = 'vorbis\OggDS.ax';
  CLISID_audi_switch: TGUID = '{D3CD7858-971A-4838-ACEC-40CA5D529DC8}';
  CLSID_MatroskaSplitter: TGUID = '{564FD788-86C9-4444-971E-CC4A243DA150}';
  CLSID_MatroskaSource: TGUID = '{55DA30FC-F16B-49FC-BAA5-AE59FC65F82D}';
  CLSID_lavsplite: TGUID = '{171252A0-8820-4AFE-9DF8-5C92B2D66B04}';
  CLSID_Mpegspliter: TGUID = '{DC257063-045F-4BE2-BD5B-E12279C464F0}';
  CLSID_Mpg4spliter: TGUID = '{61F47056-E400-43D3-AF1E-AB7DFFD4C4AD}';
  CLSID_dvdnavigato: TGUID = '{1FFD2F97-0C57-4E21-9FC1-60DF6C6D20BF}';
  CLSID_flvspliter: TGUID = '{C9ECE7B3-1D8E-41F5-9F24-B255DF16C087}';
  CLSID_MkSource: TGUID = '{0A68C3B5-9164-4A54-AFAF-995B2FF0E0D4}';
  CLISID_AVISOURCE: TGUID = '{CEA8DEFF-0AF7-4DB9-9A38-FB3C3AEFC0DE}';
  CLISID_ffaDECODER: TGUID = '{0F40E1E5-4F79-4988-B1A9-CC98794E6B55}';
  CLISID_ffvDECODER: TGUID = '{04FE9017-F873-410E-871E-AB91661A4EF7}';
  CLISID_AC3FILTER: TGUID = '{A753A1EC-973E-4718-AF8E-A3F554D45C44}';
  CLISID_WMADECODER: TGUID = '{2EEB4ADF-4578-4D10-BCA7-BB955F56320A}';
  CLISID_WMvDECODER: TGUID = '{82D353DF-90BD-4382-8BC2-3F6192B76E34}';

  CLISID_WAVDECODER: TGUID = '{D51BD5A1-7548-11cf-A520-0080C77EF58A}';
  MP3_DecoderDMO: TGUID = '{BBEEA841-0A63-4F52-A7AB-A9B3A84ED38A}';
  CLSID_HaaliVideoRenderer: TGUID = '{760A8F35-97E7-479D-AAF5-DA9EFF95D751}';
  CLSID_madVR: TGUID = '{E1A8B82A-32CE-4B0D-BE0D-AA68C772E423}';
  Microsoft_DTV_DVD_Audio_Decoder
    : TGUID = '{E1F1A0B8-BEEE-490D-BA7C-066C40B5E2B9}';
  Microsoft_DTV_DVD_Video_Decoder
    : TGUID = '{212690FB-83E5-4526-8FD7-74478B7939CD}';
  LAV_Video_Decoder = '{EE30215D-164F-4A92-A4EB-9D4C13390F9F}';
  LAV_Audio_Decoder = '{E8E73B6B-4CB3-44A4-BE99-4F7BCB96E491}';
  MpaDecFilterGuid = '{3D446B6F-71DE-4437-BE15-8CE47174340F}';
  MPCVideoDecGuid = '{008BAC12-FBAF-497B-9670-BC6F6FBAE2C4}';
  GplMpgDecGuid = '{CE1B27BE-851B-45DD-AB26-44389A8F71B4}';
  // result:=(LoadFilter(Microsoft_DTV_DVD_Audio_Decoder));
  MEDIASUBTYPE_avc1: TGUID = '{31435641-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_XVID: TGUID = '{44495658-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_xvid1: TGUID = '{64697678-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_DX50: TGUID = '{30355844-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_h264: TGUID = '{34363268-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_MPEG2_VIDEO: TGUID = '{E06D8026-DB46-11CF-B4D1-00805F6CBBEA}';
  MEDIASUBTYPE_VP90: TGUID = '{30395056-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_VP80: TGUID = '{30385056-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_VP62: TGUID = '{32365056-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_SVQ3: TGUID = '{33515653-0000-0010-8000-00AA00389B71}';

  // ****************************************************************************
  MEDIASUBTYPE_MP3: TGUID = '{00000055-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_RAW_AAC1: TGUID = '{000000FF-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_DVM: TGUID = '{00002000-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_DVD_LPCM_AUDIO: TGUID = '{E06D8032-DB46-11CF-B4D1-00805F6CBBEA}';
  MEDIASUBTYPE_Vorbis2: TGUID = '{AFBC2343-3DCB-4047-9655-E1E62A61B1C5}';
  MEDIASUBTYPE_DOLBY_AC3: TGUID = '{E06D802C-DB46-11CF-B4D1-00805F6CBBEA}';
  MEDIASUBTYPE_WMAUDIO_LOSSLESS
    : TGUID = '{00000163-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_WAVE: TGUID = '{E436EB8B-524F-11CE-9F53-0020AF0BA770}';

  // ***************************************************************************
  // txt '{E06D802C-DB46-11CF-B4D1-00805F6CBBEA}'//'{E06D802C-DB46-11CF-B4D1-00805F6CBBEA}'//'{E06D802C-DB46-11CF-B4D1-00805F6CBBEA}'
  _ONOFF: array [boolean] of string = ('ON', 'OFF');

  maxext = 20;
  iconWidth = 16;
  circc = 4;
  iext: array of string = ['avi', 'mpg', 'mp4', 'mkv', '3gp', 'wmv', 'mpeg',
    'flv', 'mpeg', 'wav', 'ogg', 'mp3', 'wma', 'flac', 'ape', 'm4a', 'mkv',
    'wv', 'cda', 'm3u', 'webm'];

  CopyInfa = 'Select a folder to Copy files:%d' + #13 + 'Files Size:%s';
  playback_time = string('Playback_time');
  VHeight = string('VHeight');
  VWidth = string('VWidth');
  VCompression = string('VCompression');
  nChannels = string('nChannels');
  wBitsPerSample = string('wBitsPerSample');
  nSamplesPerSec = string('nSamplesPerSec');
  CountTrack = string('CountTrack');
  Playtrack = string('Playtrack');
  Ampli = string('CurrentAmplification');
  Equalizer_ = string('Equalizer');
  Type_ = string('Type');
  ExtractFileName_ = string('ExtractFileName');
  Filesize_ = string('Filesize');
  I_TRACKNUMBER = string('TRACKNUMBER');
  I_TOTALTRACKS = string('TOTALTRACKS');
  C_TITLE = string('TITLE');
  c_ARTIST = string('ARTIST');
  c_ALBUM = string('ALBUM');
  C_ALBUMARTIST = string('ALBUMARTIST');
  i_YEAR = string('YEAR');
  I_DISCNUMBER = string('DISCNUMBER');
  i_TOTALDISCS = string('TOTALDISCS');
  c_GENRE = string('GENRE');
  C_LYRICS = string('LYRICS');
  readtagS: array of string = [I_TRACKNUMBER, I_TOTALTRACKS, C_TITLE, c_ARTIST,
    c_ALBUM, i_YEAR, I_DISCNUMBER, i_TOTALDISCS];
  // tracknumber   totaltracks                                                 discnumber totaldiscs
  TagFormat: array of string = [I_TRACKNUMBER, I_TOTALTRACKS, C_TITLE, c_ARTIST,
    c_ALBUM, C_ALBUMARTIST, i_YEAR, I_DISCNUMBER, i_TOTALDISCS, c_GENRE,
    C_LYRICS];
  TagAttributes: array of string = ['FILENAME', 'DURATION', 'CHANNELS',
    'SAMPLESPERSEC', 'BITSPERSAMPLE', 'SAMPLECOUNT', 'BITRATE', 'GETURLSIZE'];
  PlaylistViewSF: array [boolean] of string = ('Playlist: Hide',
    'Playlist: Show');
  SFulscreenF: array [boolean] of string = ('Exit FullScreen', 'FullScreen');
  SBalloonChecked: array [boolean] of string = ('Hide Balloon Hint',
    'Show Balloon Hint');
  MuteFBS: array [boolean] of string = ('Mute: Off', 'Mute: On');
  MuteFBI: array [boolean] of integer = (23, 22);
  TimeSF: array [boolean] of string = ('Time Remaining', 'Time Elapsed');
  GNSS: array [0 .. 2] of string = ('Video', 'Audio', 'Subtitle');
  ChFormat: array [1 .. 7] of string = ('Mono', 'Stereo', '2.1', '3.1', '4.1',
    '5.1', '6.1');
  arrCmd: array of string = ['Play', 'Open', 'ADF', 'ADFPlay', 'ADD', 'PlayF'];
  so = char('[');
  sc = char(']');
  skob: array [1 .. 2] of char = (so, sc);
  urlAdress: array of string = ['youtu.be', 'youtube.com', 'vk.com/video'];
  DefFild: array of string = ['Sreaming Link', 'Name'];
  // F_ext = ('.avi .mpg .mp4 .mkv .3gp .wmv .mpeg .flv .mpeg .wav .ogg .mp3 .wma .flac .ape .m4a .mkv .wv .cda .vob .ifo');
  S_Ext = 'oga;ogg;ogm;ogv;ogx;oma;opus;pls;qcp;ram;rec;rm;rmi;rmvb;s3m;sdp;snd;spx;tod;ts;tta;tts;vlc;vob;vqf;vro;w64;wav;webm;wma;wmv;wv;xa;xm;xspf;3g2;m1v;voc;';
  SS_ext = '3ga;3gp;3gp2;3gpp;669;a52;aac;ac3;adt;adts;aif;aifc;aiff;amr;amv;aob;ape;asf;asx;au;avi;b4s;bin;caf;cda;cue;divx;drc;dts;dv;f4v;flac;flv;gxf;ifo;it;m2t;';
  st_ext = 'm2ts;m2v;m3u;m3u8;m4a;m4p;m4v;mid;mka;mkv;mlp;mod;mov;mp1;mp2;mp2v;mp3;mp4;mp4v;mpa;mpc;mpe;mpeg;mpeg1;mpeg2;mpeg4;mpg;mpv2;mts;mtv;mxf;nsv;nuv;';
  // ***************************************************************************

  savp = 'Data.cmp';
  registr = 'SOFTWARE\AzzZ(Developen)\Cameta\';
  NumEQBands = 10;
  DspRegistr = registr + 'Dsp\';
  MEDIASUBTYPE_MP42: TGUID = '{3234504D-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_DIVX: TGUID = '{58564944-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_VOXWARE: TGUID = '{00000075-0000-0010-8000-00AA00389B71}';
  TimerInterval = 1000;

  VideoRendes_: array of string = ['{51B4ABF3-748F-4E3B-A276-C828330E926A}',
    '{FA10746C-9B63-4B6C-BC49-FC300EA5F256}'];

  // ****************************************************************************
type
  ProcAmpControlRange = record
    dwProperty: integer;
    MinValue: integer;
    MaxValue: integer;
    DefaultValue: integer;
    StepSize: integer;
  end;

TYPE
  // ShowDLLForm = procedure(s: string); cdecl;
  Time_Date = single;
  IACoverArt = TArray<ICoverArt>;
  _Delfunction = TFunc<integer, boolean>;

Type
  PEQBandsVolume = ^TEQBandsVolume;
  TEQBandsVolume = array [0 .. NumEQBands - 1] of ShortInt;
  StreamTypes = (_Saudio, _Ssubtitles);
  _RepeatState = (repeatall, repeatt, Norepeat, randomplay);
  RepeatStates = set of _RepeatState;
  ext_s = (unkow, mkv, avi, dvd, wmv, bass, flv, cda, url);

  CametaState = (resump, rest, star, pause, stop, closefiles,
    Rendering, Icameta);
  _ItemState = (IProgress, IStop, IPause, IPlay, IClose, IError, INone);

  // TCmdComandType = (addf,adfo,funkow,addfplay);
  TreadHandle = array [0 .. 10] of THandle;

var
  ApplicationFolder: string;
  Roaming: string;

implementation

end.
