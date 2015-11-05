{1 ������ ������ � ���������� ������� WinRAR. }
{{
������ ���������� �������� ����� TnzrWinRAR  ��� ���������� ���������� 
���������� ������ WinRAR.
�������������� ���������� ������ �������� �� ������� WinRAR � �������� "����� 
��������� ������".
}
unit nzrWinRARUnit;

{******************************************************************************}
{                                                                              }
{          ������ ���������� ���������� ������ WinRAR                          }
{       ��������� ����� � 2004-2005, Nazir Software                            }
{                                                                              }
{  �����������: ����������� ����� ���������  (Wild Pointer)                    }
{  �������������: 1 ������� 2005                                               }
{                                                                              }
{******************************************************************************}

interface

uses
  Windows, SysUtils, Classes, ShellAPI, nzrTypesUnit;

type
  TCommands = (
    cmdAddFilesInArchive,                    // a // �������� ����� � �����
    cmdAddArchiveCommentary,                 // c // �������� �������� �����������
    cmdDeleteFilesFromArchive,               // d // ������� ����� �� ������
    cmdExtractFilesFromArchiveIgnoringWay,   // e // ������� ����� �� ������, ��������� ����
    cmdRefreshFilesInArchive,                // f // �������� ����� � ������
    cmdFindLineInArchive,                    // i // ����� ������ � �������
    cmdBlockArchive,                         // k // ������������� �����
    cmdMoveFilesAndFoldersInArchive,         // m // ����������� ����� � ����� � �����
    cmdRestoreDamagedArchive,                // r // ������������ ������������ �����
    cmdReconstructLackingVolume,             // rc // ���������� ����������� ����
    cmdRenameFilesInArchive,                 // rn // ������������� ����� � ������
    cmdAddInfoToRecovery,                    // rr[N] // �������� ���������� ��� ��������������
    cmdAddInformationForRecovering,          // rv[N] // ������� ���� ��� ��������������
    cmdConvertArchiveInSFX,                  // s[���] // ������������� ����� � ���������������������
    cmdDeleteSFXModule,                      // s- // ������� SFX-������
    cmdTestFilesInArchive,                   // t // �������������� ����� � ������
    cmdWillUpdateFilesInArchive,             // u // �������� ����� � ������
    cmdExtractFilesFromArchiveWithFullPathes); // x // ������� ����� �� ������ � ������� ������

  TCommand = set of TCommands;

  TArchiveFormats = (afRAR,afZIP);

  TArchiveFormat = set of TArchiveFormats;

  {1 ����� ��� ������� SFX-������. }
  {{
  �������� ����� (�� ������� ��������) ��� ��������� SFX-������.
  }
  TSFXArchive = class (TPersistent)
  private
    FCreateSFXArchive: Boolean;
    FSFXModule: string;
    procedure SetCreateSFXArchive(const Value: Boolean);
    procedure SetSFXModule(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    {1 ������� SFX-����� }
    property CreateSFXArchive: Boolean read FCreateSFXArchive write 
            SetCreateSFXArchive;
    {1 ������� SFX-������. �� ��������� WinRAR ���������� SFX-������ 
            Default.SFX }
    property SFXModule: string read FSFXModule write SetSFXModule;
  end;
  
  {1 ����� ��� ��������� ������ ������ ��� �������� � ���������� ������ WinRAR. 
          }
  TKeys = class (TPersistent)
  private
    FArchiveFormat: TArchiveFormats;
    FBackgroundArchiving: Boolean;
    FBreakFurtherSearchingForAnKeys: Boolean;
    FPassword: string;
    FRecursivelyEnclosedFolders: Boolean;
    FRemoveFilesAfterArchiving: Boolean;
    FSaveFullWaysOfFiles: Boolean;
    FSFXArchive: TSFXArchive;
    FSwitchOffComputer: Boolean;
    procedure SetArchiveFormat(const Value: TArchiveFormats);
    procedure SetBackgroundArchiving(const Value: Boolean);
    procedure SetBreakFurtherSearchingForAnKeys(const Value: Boolean);
    procedure SetPassword(const Value: string);
    procedure SetRecursivelyEnclosedFolders(const Value: Boolean);
    procedure SetRemoveFilesAfterArchiving(const Value: Boolean);
    procedure SetSaveFullWaysOfFiles(const Value: Boolean);
    procedure SetSFXArchive(const Value: TSFXArchive);
    procedure SetSwitchOffComputer(const Value: Boolean);
  public
    {{
    Constructor Create overrides the inherited Create. 
    First inherited Create is called, then the internal data structure is 
    initialized
    }
    constructor Create; virtual;
    {{
    Destructor Destroy overrides the inherited Destroy.
    First all owned fields are free'd, finally inherited Destroy is called.
    }
    destructor Destroy; override;
    {{
    function GetArchiveFormatExt.
    Returns:
    }
    function GetArchiveFormatExt: string;
    {{
    function GetKeys.
    Returns:
    }
    function GetKeys: string;
  published
    {1 ������� ������ ������ (-af<type>) }
    {{
    � ������� ����� ����� ����� ��������� � ��������� ������ ��� ������, 
    ������� ����� ��������� WinRAR.  �������� <���> ����� ��������� �������� 
    'rar' ��� 'zip'.
    }
    property ArchiveFormat: TArchiveFormats read FArchiveFormat write 
            SetArchiveFormat;
    {1 ��������� WinRAR ��� ������� ������� � ��������� ����� (-ibck). }
    {{
    ������������ WinRAR � ��������� ����� ��� ������� ��� ��������� ��� 
    ����������.
    }
    property BackgroundArchiving: Boolean read FBackgroundArchiving write 
            SetBackgroundArchiving;
    {1 �������� ���������� ����� ������ � ��������� ������ (--). }
    {{
    ������ ���� ��������� WinRAR, ��� � ��������� ������ ������ ��� ������. ��� 
    ����� ���� ������� � ��� �������, ����� � ������� '�' ���������� ��� ������ 
    ��� ������-���� �����. ��� ����� '���' �������� ��� ����� ������������ ��� 
    ����.
    ������:
    
    WinRAR  a  �s  � �  �StrangeName
    
    ��� ������� ������� ��� ����� �� ������� ����� � ����������� ����� � ������ 
    �StrangeName.
    }
    property BreakFurtherSearchingForAnKeys: Boolean read 
            FBreakFurtherSearchingForAnKeys write 
            SetBreakFurtherSearchingForAnKeys;
    {1 ���������� ������ (-p[password]). }
    {{
    � ������� ����� ����� ����� ���������� <������> ��� ���������� ������ ��� 
    ��������� ��� ��� �� ����������� ��� ����������. ������� �������� � ������ 
    �����������. �� ����������� ������������ �� ������ �� ��������� ������ � 
    ��������� ������, � ���� ������ ��������� ��������� ��� ��� ������.
    
    ������:
    
    WinRAR  a  �pZaBaToAd  �r  secret  games\*.*
    
    ��� ������� ������� ���������� ����� games � ����� secret, ��������� ������ 
    ZaBaToAd.
    
    ����������:
    
    1)	��� ����������� ���������� ������� ������ ������ ������ ���� �� ������ 
    8 ��������, �� ������� ��������� ����� ����������� ������;
    2)	������� ���� ������ � ������� �����, ����� ���� �� �������� ��� 
    ��������� ������, �� ��� ���� ������ �������� �����������!
    }
    property Password: string read FPassword write SetPassword;
    {1 ���������� � ���������� ������� (-r). }
    {{
    �������� �������� ��������� ����� (�.�. ��������� ������� � ���� � 
    ��������� �����). ����� ������������ ������ � ���������: A, U, F, M, X, E, 
    T, K, RR, C � S.
    ��� ������������� � ��������� A, U, F ��� M ����� ���������� ����� �� 
    ������ � �������, �� � �� ���� ��������� ������.
    
    ��� ������������� � ��������� X, E, T, K, RR, C ��� S ����� ���������� 
    ������ �� ������ � �������, �� � �� ���� ��������� ������.
    
    �������:
    1) �������� ���������� ����� C: � ����� Backup:
    
    WinRAR  a  �r  Backup  c:\*.*
    
    2) �������������� ��� ������ *.rar �� ������� �����:
    
    WinRAR  t  �r  \*.rar
    }
    property RecursivelyEnclosedFolders: Boolean read 
            FRecursivelyEnclosedFolders write SetRecursivelyEnclosedFolders;
    {1 ������� ����� ����� ��������� (-df). }
    {{
    ���������� ����� � �����. ��� ������������� ������ � �������� a ���� ���� 
    ��������� �� �� ��������, ��� � ������� m.
    }
    property RemoveFilesAfterArchiving: Boolean read FRemoveFilesAfterArchiving 
            write SetRemoveFilesAfterArchiving;
    {1 ��������� ������ ���� ������ (-ep2). }
    {{
    ��������� ��� ������������� ������ ���� ������, �� ����������� ����� ����� 
    � ������ � ������ �������� ����� ����� ("\").
    }
    property SaveFullWaysOfFiles: Boolean read FSaveFullWaysOfFiles write 
            SetSaveFullWaysOfFiles;
    {1 ������� ��������������������� ����� (-sfx[name]). }
    {{
    ���� ���� ���� ������������ ��� �������� ������ ������, �� ����� ������ 
    ��������������������� (SFX) �����. �� ��������� WinRAR ���������� 
    SFX-������ Default.SFX ��� ������� RAR, � SFX-������ Zip.SFX � ��� ������� 
    ZIP. ��� ������ ������ ���������� � ��� �� �����, ��� � ���� WinRAR.exe. 
    ����� ����� "�sfx" ����� ���� ������ �������������� ������ SFX.
    
    �������:
    
    a)	������� ��������������������� ����������� ����� � ����������� 
    ��������������:
    
    WinRAR  a  �sfx  �v360  �s  Games
    
    �)	������� ��������������������� ����� � ������� WinCon.SFX:
    
    WinRAR  a  �sfxWinCon.SFX  Gift.rar
    }
    property SFXArchive: TSFXArchive read FSFXArchive write SetSFXArchive;
    {1 ��������� ��������� (-ioff). }
    {{
    ��������� �� �� ���������� ��������.  ��� ������ ���� ������� ��������� 
    ���������� ��������� ���������� �������.
    }
    property SwitchOffComputer: Boolean read FSwitchOffComputer write 
            SetSwitchOffComputer;
  end;
  
  {1 ����� ��� ��������� ���������� ����� WinRAR. }
  TCommandLine = class (TPersistent)
  private
    FArchiveName: string;
    FCommand: TCommands;
    FDefaultArchiveName: string;
    FExtractPath: string;
    FFileListName: string;
    FFiles: TStrings;
    FFilesDirectory: string;
    FKeys: TKeys;
    procedure SetArchiveName(const Value: string);
    procedure SetCommand(const Value: TCommands);
    procedure SetDefaultArchiveName(const Value: string);
    procedure SetExtractPath(const Value: string);
    procedure SetFileListName(const Value: string);
    procedure SetFiles(Value: TStrings);
    procedure SetFilesDirectory(const Value: string);
    procedure SetKeys(const Value: TKeys);
  public
    {{
    Constructor Create overrides the inherited Create. 
    First inherited Create is called, then the internal data structure is 
    initialized
    }
    constructor Create; virtual;
    {{
    Destructor Destroy overrides the inherited Destroy.
    First all owned fields are free'd, finally inherited Destroy is called.
    }
    destructor Destroy; override;
    {{
    function GetArchiveName.
    Returns:
    }
    function GetArchiveName: string;
    {{
    function GetCommand.
    Returns:
    }
    function GetCommand: string;
  published
    {1 ��� ������ }
    property ArchiveName: string read FArchiveName write SetArchiveName;
    {{
    }
    property Command: TCommands read FCommand write SetCommand;
    {{
    }
    property DefaultArchiveName: string read FDefaultArchiveName write 
            SetDefaultArchiveName;
    {{
    }
    property ExtractPath: string read FExtractPath write SetExtractPath;
    {{
    }
    property FileListName: string read FFileListName write SetFileListName;
    {{
    }
    property Files: TStrings read FFiles write SetFiles;
    {{
    }
    property FilesDirectory: string read FFilesDirectory write 
            SetFilesDirectory;
    {{
    }
    property Keys: TKeys read FKeys write SetKeys;
  end;
  
  {1 �����  nstWinRAR ��� ���������� ���������� ������ � WinRAR. }
  TnzrWinRAR = class (TComponent)
  private
    FAbout: TAboutProperty;
    FCommandLine: TCommandLine;
    FVersionWinRAR: string;
    FWinRARPath: TFileName;
    procedure SetCommandLine(Value: TCommandLine);
    procedure SetWinRARPath(Value: TFileName);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    procedure OpenWinRAR;
    property WinRARPath: TFileName read FWinRARPath write SetWinRARPath;
  published
    property About: TAboutProperty read FAbout write FAbout;
    property CommandLine: TCommandLine read FCommandLine write SetCommandLine;
    property VersionWinRAR: string read FVersionWinRAR;
  end;
  

implementation

{1 ����� ��� ������� SFX-������. }
{{
�������� ����� (�� ������� ��������) ��� ��������� SFX-������.
}
{ TSFXArchive }
constructor TSFXArchive.Create;
begin
  inherited;
  
  FCreateSFXArchive := False;
  
  FSFXModule := '';
end;

destructor TSFXArchive.Destroy;
begin
  inherited;
end;

procedure TSFXArchive.SetCreateSFXArchive(const Value: Boolean);
begin
  if FCreateSFXArchive <> Value then
  begin
  
  FCreateSFXArchive := Value;
  
  end;
end;

procedure TSFXArchive.SetSFXModule(const Value: string);
begin
  if FSFXModule <> Value then
  begin
  
  FSFXModule := Value;
  
  end;
end;

{1 ����� ��� ��������� ������ ������ ��� �������� � ���������� ������ WinRAR. }
{ TKeys }
{{
Constructor Create overrides the inherited Create. 
First inherited Create is called, then the internal data structure is 
initialized
}
constructor TKeys.Create;
begin
  FSFXArchive := TSFXArchive.Create;
  
  FBackgroundArchiving := True;
  
  FRecursivelyEnclosedFolders := True;
  
  FBreakFurtherSearchingForAnKeys := True;
end;

{{
Destructor Destroy overrides the inherited Destroy.
First all owned fields are free'd, finally inherited Destroy is called.
}
destructor TKeys.Destroy;
begin
  FSFXArchive.Free;
  
  inherited;
end;

{{
function GetArchiveFormatExt.
Returns:
}
function TKeys.GetArchiveFormatExt: string;
begin
  if FArchiveFormat = TArchiveFormats(0) then
    Result := '.rar';
  
  if FArchiveFormat = TArchiveFormats(1) then
    Result := '.zip';
  
  if FSFXArchive.FCreateSFXArchive then
    Result := '.exe';
end;

{{
function GetKeys.
Returns:
}
function TKeys.GetKeys: string;
begin
  if FArchiveFormat = TArchiveFormats(0) then
    Result := Result + '';
  
  if FArchiveFormat = TArchiveFormats(1) then
    Result := Result + ' -afZIP';
  
  if FRemoveFilesAfterArchiving then
    Result := Result + ' -df';
  
  if FSaveFullWaysOfFiles then
    Result := Result + ' -ep2';
  
  if FBackgroundArchiving then
    Result := Result + ' -ibck';
  
  if FSwitchOffComputer then
    Result := Result + ' -ioff';
  
  if not (FPassword = '') then
    Result := Result + ' -p' + FPassword;
  
  if FSFXArchive.FCreateSFXArchive then
    Result := Result + ' -sfx' + FSFXArchive.FSFXModule;
  
  if FBreakFurtherSearchingForAnKeys then
    Result := Result + ' --';
end;

{{
SetArchiveFormat is the write access method of the ArchiveFormat property.
}
procedure TKeys.SetArchiveFormat(const Value: TArchiveFormats);
begin
  if FArchiveFormat <> Value then
  begin
  
  FArchiveFormat := Value;
  
  end;
end;

{{
SetBackgroundArchiving is the write access method of the BackgroundArchiving 
property.
}
procedure TKeys.SetBackgroundArchiving(const Value: Boolean);
begin
  if FBackgroundArchiving <> Value then
  begin
  
  FBackgroundArchiving := Value;
  
  end;
end;

{{
SetBreakFurtherSearchingForAnKeys is the write access method of the 
BreakFurtherSearchingForAnKeys property.
}
procedure TKeys.SetBreakFurtherSearchingForAnKeys(const Value: Boolean);
begin
  if FBreakFurtherSearchingForAnKeys <> Value then
  begin
  
  FBreakFurtherSearchingForAnKeys := Value;
  
  end;
end;

{{
SetPassword is the write access method of the Password property.
}
procedure TKeys.SetPassword(const Value: string);
begin
  if FPassword <> Value then
  begin
  
  FPassword := Value;
  
  end;
end;

{{
SetRecursivelyEnclosedFolders is the write access method of the 
RecursivelyEnclosedFolders property.
}
procedure TKeys.SetRecursivelyEnclosedFolders(const Value: Boolean);
begin
  if FRecursivelyEnclosedFolders <> Value then
  begin
  
  FRecursivelyEnclosedFolders := Value;
  
  end;
end;

{{
SetRemoveFilesAfterArchiving is the write access method of the 
RemoveFilesAfterArchiving property.
}
procedure TKeys.SetRemoveFilesAfterArchiving(const Value: Boolean);
begin
  if FRemoveFilesAfterArchiving <> Value then
  begin
  
  FRemoveFilesAfterArchiving := Value;
  
  end;
end;

{{
SetSaveFullWaysOfFiles is the write access method of the SaveFullWaysOfFiles 
property.
}
procedure TKeys.SetSaveFullWaysOfFiles(const Value: Boolean);
begin
  if FSaveFullWaysOfFiles <> Value then
  begin
  
  FSaveFullWaysOfFiles := Value;
  
  end;
end;

{{
SetSFXArchive is the write access method of the SFXArchive property.
}
procedure TKeys.SetSFXArchive(const Value: TSFXArchive);
begin
  FSFXArchive.Assign(Value);
end;

{{
SetSwitchOffComputer is the write access method of the SwitchOffComputer 
property.
}
procedure TKeys.SetSwitchOffComputer(const Value: Boolean);
begin
  if FSwitchOffComputer <> Value then
  begin
  
  FSwitchOffComputer := Value;
  
  end;
end;

{1 ����� ��� ��������� ���������� ����� WinRAR. }
{ TCommandLine }
{{
Constructor Create overrides the inherited Create. 
First inherited Create is called, then the internal data structure is 
initialized
}
constructor TCommandLine.Create;
begin
  inherited;
  
  FKeys := TKeys.Create;
  
  FFiles := TStringList.Create;
  
  FCommand := TCommands(0);// cmdAddFilesInArchive;
  
  FDefaultArchiveName :=  'NewArchive';
  
  FArchiveName := FDefaultArchiveName;
  
  FFiles.Clear;
  FFiles.Add('*.*');
  
  FFileListName := '';
  
  FExtractPath := '';
end;

{{
Destructor Destroy overrides the inherited Destroy.
First all owned fields are free'd, finally inherited Destroy is called.
}
destructor TCommandLine.Destroy;
begin
  FKeys.Free;
  
  FFiles.Free;
  
  inherited;
end;

{{
function GetArchiveName.
Returns:
}
function TCommandLine.GetArchiveName: string;
var
  sFileDir: string;
  iCounter: Integer;
  sFileName: string;
  sArchiveNameDir: string;
begin
  Result := FDefaultArchiveName;
  
  sFileName := ExtractFileName(FFiles[0]);
  
  sFileDir := ExtractFileDir(FFiles[0]);
  if sFileDir = '' then
    sFileDir := GetCurrentDir;
  FFilesDirectory := sFileDir;
  for iCounter := Length(sFileDir) downto 1 do
  begin
    if sFileDir[iCounter - 1] = '\' then
    begin
      sArchiveNameDir := Copy(sFileDir, iCounter, Length(sFileDir));
      Break;
    end;
  end;
  
  if FFiles.Count = 0 then
    Result := FDefaultArchiveName;
  if FFiles.Count = 1 then
  begin
    if FileExists(sFileName)then
      Result := ChangeFileExt(sFileName, '');
    if sFileName = '*.*' then
    begin
      if sFileDir = '' then
        Result := FDefaultArchiveName
      else
        Result := sArchiveNameDir;
    end
  end;
  if FFiles.Count > 1 then
  begin
    if sFileDir = '' then
    begin
      if FileExists(sFileName)then
        Result := ChangeFileExt(sFileName, '');
    end
    else
      Result := sArchiveNameDir;
  end;
end;

{{
function GetCommand.
Returns:
}
function TCommandLine.GetCommand: string;
var
  iCounter: Integer;
  arrCommand: array of string;
begin
  SetLength(arrCommand,18);
  
  arrCommand[0] := 'a'; arrCommand[1] := 'c'; arrCommand[2] := 'd';
  arrCommand[3] := 'e'; arrCommand[4] := 'f'; arrCommand[5] := 'i';
  arrCommand[6] := 'k'; arrCommand[7] := 'm'; arrCommand[8] := 'r';
  arrCommand[9] := 'rc'; arrCommand[10] := 'rn'; arrCommand[11] := 'rr';
  arrCommand[12] := 'rv'; arrCommand[13] := 's'; arrCommand[14] := 's-';
  arrCommand[15] := 't'; arrCommand[16] := 'u'; arrCommand[17] := 'x';
  
  for iCounter := 0 to 17 do
    if FCommand = TCommands(iCounter) then
       Result := Result + arrCommand[iCounter];
  
  if FArchiveName = '' then
    Result := Result + FKeys.GetKeys + ' ' + FDefaultArchiveName
  else
    Result := Result + FKeys.GetKeys + ' ' + FArchiveName;
  
  if FFileListName = '' then
  begin
    for iCounter := 0 to FFiles.Count - 1 do
    begin
      if ExtractFileDir(FFiles.Strings[iCounter]) = GetCurrentDir then
      Result := Result  + ' ' + ExtractFileName(FFiles.Strings[iCounter]);
    end;
  end
  else
    Result := Result + ' @' + FFileListName;
  
  if not (FExtractPath = '') then
    Result := Result + ' ' + FExtractPath;
  
  Finalize(arrCommand);
end;

{{
SetArchiveName is the write access method of the ArchiveName property.
}
procedure TCommandLine.SetArchiveName(const Value: string);
begin
  if FArchiveName <> Value then
  begin
  
  FArchiveName := Value;
  
  end;
end;

{{
SetCommand is the write access method of the Command property.
}
procedure TCommandLine.SetCommand(const Value: TCommands);
begin
  if FCommand <> Value then
  begin
  
  FCommand := Value;
  
  end;
end;

{{
SetDefaultArchiveName is the write access method of the DefaultArchiveName 
property.
}
procedure TCommandLine.SetDefaultArchiveName(const Value: string);
begin
  if FDefaultArchiveName <> Value then
  begin
  
  FDefaultArchiveName := Value;
  
  end;
end;

{{
SetExtractPath is the write access method of the ExtractPath property.
}
procedure TCommandLine.SetExtractPath(const Value: string);
begin
  if FExtractPath <> Value then
  begin
  
  FExtractPath := Value;
  
  end;
end;

{{
SetFileListName is the write access method of the FileListName property.
}
procedure TCommandLine.SetFileListName(const Value: string);
begin
  if FFileListName <> Value then
  begin
  
  FFileListName := Value;
  
  end;
end;

{{
SetFiles is the write access method of the Files property.
}
procedure TCommandLine.SetFiles(Value: TStrings);
begin
  FFiles.Assign(Value);
end;

{{
SetFilesDirectory is the write access method of the FilesDirectory property.
}
procedure TCommandLine.SetFilesDirectory(const Value: string);
begin
  if FFilesDirectory <> Value then
  begin
  
  FFilesDirectory := Value;
  
  end;
end;

{{
SetKeys is the write access method of the Keys property.
}
procedure TCommandLine.SetKeys(const Value: TKeys);
begin
  FKeys.Assign(Value);
end;

{1 �����  nstWinRAR ��� ���������� ���������� ������ � WinRAR. }
{ TnzrWinRAR }
constructor TnzrWinRAR.Create(AOwner: TComponent);
begin
  FVersionWinRAR := '3.x';
  
  FCommandLine := TCommandLine.Create;
  
  FWinRARPath := 'WinRAR.exe';
  
  inherited;
end;

destructor TnzrWinRAR.Destroy;
begin
  FCommandLine.Free;
  
  inherited;
end;

function TnzrWinRAR.Execute: Boolean;
begin
  if ShellExecute(0, PChar('open'), PChar(FWinRARPath),
                  PChar(FCommandLine.GetCommand), nil, SW_SHOWNORMAL) < 32 then
    Result := False
  else
    Result := True;
end;

procedure TnzrWinRAR.OpenWinRAR;
begin
  ShellExecute(0, nil, PChar(FWinRARPath), nil, nil,
               SW_SHOWNORMAL);
end;

procedure TnzrWinRAR.SetCommandLine(Value: TCommandLine);
begin
  FCommandLine.Assign(Value);
end;

procedure TnzrWinRAR.SetWinRARPath(Value: TFileName);
begin
  if FWinRARPath <> Value then
  begin
  
  FWinRARPath := Value;
  
  end;
end;

end.
