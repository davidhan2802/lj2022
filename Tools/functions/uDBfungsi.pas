unit uDBfungsi;

interface

uses Windows,Controls,Forms,Sysutils,Dialogs,Classes,StrUtils,ShellApi,WinSvc,Inifiles;

function WinExecAndWait32(FileName:String; Visibility:integer):integer;
function ServiceGetStatus(sMachine,sService : string) : DWord;
function ServiceRunning(sMachine,sService : string) : boolean;
function ServiceStart(sMachine,sService : string) : boolean;
function ServiceStop(sMachine, sService: string) : boolean;
function CheckMyIni(variable: string; server:boolean=True): integer;
function GetMyIniPath(variable: string; linenumber: integer; server: boolean = True): string;
procedure LoadConfigDefault;
procedure InstallMetaService;
procedure UnInstallMetaService;
procedure StartMetaService;
procedure StopMetaService;

implementation

var   MyIni    : String;
      ConfigIni: TStringList;
      Handle   : HWND;

function WinExecAndWait32(FileName:String; Visibility:integer):integer;
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Resultado: DWord;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes}
    nil,                           { pointer to thread security attributes}
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then Result := -1 { pointer to PROCESS_INF }

  else
  begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Resultado);
    Result := Resultado;
  end;
end;

function ServiceGetStatus(sMachine,sService : string) : DWord;
var
  schm,schs: SC_Handle;
  ss: TServiceStatus;
  dwStat: DWord;
begin
  dwStat := 0;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (QueryServiceStatus(schs,ss)) then
      begin
        dwStat := ss.dwCurrentState;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := dwStat;
end;

function ServiceRunning(sMachine,sService : string) : boolean;
begin
  Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService);
end;

function ServiceStart(sMachine,sService : string) : boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  psTemp: PChar;
  dwChkP: DWord;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_START or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      psTemp := Nil;
      if (StartService(schs,0,psTemp)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_RUNNING <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

function ServiceStop(sMachine, sService: string) : boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwChkP: DWord;
begin
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (ControlService(schs,SERVICE_CONTROL_STOP,ss)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP)then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_STOPPED = ss.dwCurrentState;
end;

function CheckMyIni(variable: string; server:boolean=True): integer;
var
  MyIniText: TStringList;
  i: integer;
  area: string;
begin
  MyIniText := TStringList.Create;
  MyIniText.LoadFromFile(MyIni);
  area := 'neutral';
  result := -1;
  for i:= 0 to MyIniText.Count - 1 do
  begin
    if MyIniText.Strings[i] = '[client]' then
      area := 'client'
    else
    if MyIniText.Strings[i] = '[mysqld]' then
      area := 'server';
    if (area = 'client') and (server = false) and (AnsiPos(variable,MyIniText.Strings[i]) > 0) then
    begin
      Result := i;
      Break;
    end
    else
    if (area = 'server') and (server = true) and (AnsiPos(variable,MyIniText.Strings[i]) > 0) then
    begin
      Result := i;
      Break;
    end;
  end;
  MyIniText.Destroy;
end;

function GetMyIniPath(variable: string; linenumber: integer; server: boolean = True): string;
var
  MyIniText: TStringList;
  area: string;
  i: integer;
begin
  MyIniText := TStringList.Create;
  MyIniText.LoadFromFile(MyIni);
  Result := '';
  area := 'normal';
  for i:= 0 to MyIniText.Count - 1 do
  begin
    if i = linenumber then Break;
    if MyIniText.Strings[i] = '[client]' then
      area := 'client'
    else
    if MyIniText.Strings[i] = '[mysqld]' then
      area := 'server';
  end;
  if (area = 'client') and (server = false) and (Pos(variable,MyIniText.Strings[linenumber]) > 0) then
    Result := Copy(MyIniText.Strings[linenumber],Length(variable) + 1,200)
  else
  if (area = 'server') and (server = true) and (Pos(variable,MyIniText.Strings[linenumber]) > 0) then
    Result := Copy(MyIniText.Strings[linenumber],Length(variable) + 1,200);
  MyIniText.Destroy;
end;

procedure LoadConfigDefault;
var
  i: integer;
begin
  MyIni := ExtractFilePath(Application.ExeName) + '\Metabrain Database\metaservice.ini';
  if not FileExists(MyIni) then
  begin
    showmessage('File konfigurasi my.ini tidak ditemukan' + #13+#10 + 'Aplikasi akan dimatikan');
    Application.Terminate;
  end;

  ConfigIni := TStringList.Create;
  ConfigIni.LoadFromFile(MyIni);

  for i := 0 to ConfigIni.Count - 1 do
  begin
    if AnsiPos('port=',ConfigIni.Strings[i]) > 0 then
      ConfigIni.Strings[i] := 'port=3337';
    if AnsiPos('basedir',ConfigIni.Strings[i]) > 0 then
      ConfigIni.Strings[i] := 'basedir="' + AnsiReplaceText(ExtractFilePath(Application.ExeName),'\','/') + 'Metabrain Database/database"';
    if AnsiPos('datadir',ConfigIni.Strings[i]) > 0 then
      ConfigIni.Strings[i] := 'datadir="' + AnsiReplaceText(ExtractFilePath(Application.ExeName),'\','/') + 'Metabrain Database/database/data"';
  end;
  ConfigIni.SaveToFile(MyIni);
  ConfigIni.Destroy;
end;

procedure InstallMetaService;
begin
    if ServiceRunning('','MetaService') then exit;
    ShellExecute(Handle,'open',PChar(ExtractFilePath(Application.ExeName) + 'Metabrain Database\database\bin\mysqld-nt.exe'),PChar('--install MetaService --defaults-file="' + ExtractFilePath(Application.ExeName) + 'Metabrain Database\metaservice.ini'),PChar(ExtractFilePath(Application.ExeName) + 'Metabrain Database\database\bin'),SW_HIDE);
    Sleep(3000);
    StartMetaService;
end;

procedure UnInstallMetaService;
begin
   if ServiceRunning('','MetaService') then StopMetaService;
   ShellExecute(Handle,'open',PChar(ExtractFilePath(Application.ExeName) + 'Metabrain Database\database\bin\mysqld-nt.exe'),'--remove MetaService',PChar(ExtractFilePath(Application.ExeName) + 'Metabrain Database\database\bin'),SW_HIDE);
end;

procedure StartMetaService;
begin
 WinExecAndWait32('net start MetaService',0);
{  if ServiceStart('','MetaService') then
  begin
    CurrentStatus := 'Aktif';
    TrayIcon.ShowBalloonHint('MetaService versi 1.0','MetaService sudah aktif',bhiInfo,10);
  end
  else
  begin
    TrayIcon.ShowBalloonHint('MetaService versi 1.0','MetaService tidak dapat diaktifkan',bhiError,10);
    StartMetaService1.Enabled := False;
    StopMetaService1.Enabled := False;
  end;      }
end;

procedure StopMetaService;
begin
//  TrayIcon.ShowBalloonHint('MetaService versi 1.0','MetaService sedang dihentikan',bhiWarning,10);
  WinExecAndWait32('net stop MetaService',0);
  {
  if not ServiceRunning('','MetaService') then
  begin
    CurrentStatus := 'Nonaktif';
    TrayIcon.ShowBalloonHint('MetaService versi 1.0','MetaService sudah dihentikan',bhiInfo,10);
  end
  else
  begin
    TrayIcon.ShowBalloonHint('MetaService versi 1.0','MetaService tidak dapat dihentikan',bhiError,10);
    StartMetaService1.Enabled := True;
    StopMetaService1.Enabled := False;
  end;
  }
end;

end.
