unit nzrVersionInfoUnit;

{ Developer: Nazir K. Khusnutdinov }

interface

uses
  Windows, SysUtils, Classes, TypInfo, nzrTypesUnit;

type
{$M+}
  (* Видели директиву $M+??? Это заставляет Delphi включать в код RTTI-информацию для
  перечислимых типов. В основном допускает работу с перечислимыми типами как
  со строками с помощью GetEnumName *)
  TVersionType = (vtCompanyName, vtFileDescription, vtFileVersion,
    vtInternalName, vtLegalCopyright, vtLegalTradeMark, vtOriginalFileName,
    vtProductName, vtProductVersion, vtComments);
{$M-}

  TnzrVersionInfo = class(TComponent)
    (* Данный компонент позволяет получать информацию о версии вашего приложения
    во время его выполенния *)
  private
    FAbout: TAboutProperty;
    FProductVersion: string;
    FFileVersion: string;
    FVersionInfo: array[0..Ord(High(TVersionType))] of string;
    function GetCompleteVersionInformation: string;
  protected
    function GetCompanyName: string;
    function GetFileDescription: string;
    function GetFileVersion: string;
    function GetFileVersionWithoutBuild: string;
    function GetFileVersionMajor: string;
    function GetFileVersionMinor: string;
    function GetFileVersionRelease: string;
    function GetFileVersionBuild: string;
    function GetInternalName: string;
    function GetLegalCopyright: string;
    function GetLegalTradeMark: string;
    function GetOriginalFileName: string;
    function GetProductName: string;
    function GetProductVersion: string;
    function GetComments: string;
    function GetVersionInfo(VersionType: TVersionType): string; virtual;
    procedure SetVersionInfo; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    (* Использовать это очень просто - Label1.Caption := nstVersionInfo1.FileVersion
    Примечание: Все свойства - только для чтения, поэтому они недоступны в
    Инспекторе Объектов *)
    property About: TAboutProperty read FAbout write FAbout;
    property CompanyName: string read GetCompanyName;
    property FileDescription: string read GetFileDescription;
    property FileVersion: string read GetFileVersion;
    property FileVersionWithoutBuild: string read GetFileVersionWithoutBuild;
    property FileVersionMajor: string read GetFileVersionMajor;
    property FileVersionMinor: string read GetFileVersionMinor;
    property FileVersionRelease: string read GetFileVersionRelease;
    property FileVersionBuild: string read GetFileVersionBuild;
    property InternalName: string read GetInternalName;
    property LegalCopyright: string read GetLegalCopyright;
    property LegalTradeMark: string read GetLegalTradeMark;
    property OriginalFileName: string read GetOriginalFileName;
    property ProductName: string read GetProductName;
    property ProductVersion: string read GetProductVersion;
    property Comments: string read GetComments;
    property CompleteVersionInformation: string read GetCompleteVersionInformation;
  end;

implementation

uses StrUtils;

constructor TnzrVersionInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileVersion := '';

  SetVersionInfo;
end;

procedure TnzrVersionInfo.SetVersionInfo;
var
  sAppName, sVersionType: string;
  sCalcLangCharSet: string;
  dwAppSize, dwLenOfValue: DWORD;
  iCounter, iTemp: Integer;
  TransBuffer: PChar;
  pcBuf, pcValue: PChar;
begin
  sAppName := ParamStr(0);
  dwAppSize := GetFileVersionInfoSize(PChar(sAppName), dwAppSize);
  if dwAppSize > 0 then
  begin
    pcBuf := AllocMem(dwAppSize);
    GetFileVersionInfo(PChar(sAppName), 0, dwAppSize, pcBuf);

    VerQueryValue(pcBuf, '\VarFileInfo\Translation', Pointer(TransBuffer),
                  dwAppSize);
    if dwAppSize >= 4 then
    begin
      iTemp := 0;
      StrLCopy(@iTemp, TransBuffer, 2);
      sCalcLangCharSet := IntToHex(iTemp, 4);
      StrLCopy(@iTemp, TransBuffer + 2, 2);
      sCalcLangCharSet := sCalcLangCharSet + IntToHex(iTemp, 4);
    end;

    for iCounter := 0 to Ord(High(TVersionType)) do
    begin
      sVersionType := GetEnumName(TypeInfo(TVersionType), iCounter);
      sVersionType := Copy(sVersionType, 3, Length(sVersionType));
      if VerQueryValue(pcBuf, PChar('\StringFileInfo\'+ sCalcLangCharSet +
        '\' + sVersionType), Pointer(pcValue), dwLenOfValue) then
         FVersionInfo[iCounter] := pcValue;
    end;
    FreeMem(pcBuf, dwAppSize);
  end;
end;

function TnzrVersionInfo.GetCompanyName: string;
begin
  Result := GetVersionInfo(vtCompanyName);
end;

function TnzrVersionInfo.GetFileDescription: string;
begin
  Result := GetVersionInfo(vtFileDescription);
end;

function TnzrVersionInfo.GetFileVersion: string;
begin
  if FFileVersion = '' then
    FFileVersion := GetVersionInfo(vtFileVersion);
  if FFileVersion = '' then
    FFileVersion := '0.0.0.0';
  Result := FFileVersion;
end;

function TnzrVersionInfo.GetFileVersionWithoutBuild: string;
begin
  Result := FileVersion;
  Result := FileVersionMajor + '.' + FileVersionMinor + '.' +  FileVersionRelease;
end;

function TnzrVersionInfo.GetFileVersionMajor: string;
begin
  Result := FileVersion;
  Delete(Result, Pos('.', Result), Length(Result));
end;

function TnzrVersionInfo.GetFileVersionMinor: string;
begin
  Result := FileVersion;
  Delete(Result, 1, Pos('.', Result));
  Delete(Result, Pos('.', Result), Length(Result));
end;

function TnzrVersionInfo.GetFileVersionRelease: string;
begin
  Result := FileVersion;
  Result := ReverseString(Result);
  Delete(Result, 1, Pos('.', Result));
  Delete(Result, Pos('.', Result), Length(Result));
  Result := ReverseString(Result);
end;

function TnzrVersionInfo.GetFileVersionBuild: string;
begin
//  Result := RightStr(FFileVersion, Pos('.', FFileVersion) + 1);
  Result := FileVersion;
  Result := ReverseString(Result);
  Delete(Result, Pos('.', Result), Length(Result));
  Result := ReverseString(Result);
end;

function TnzrVersionInfo.GetInternalName: string;
begin
  Result := GetVersionInfo(vtInternalName);
end;

function TnzrVersionInfo.GetLegalCopyright: string;
begin
  Result := GetVersionInfo(vtLegalCopyright);
end;

function TnzrVersionInfo.GetLegalTradeMark: string;
begin
  Result := GetVersionInfo(vtLegalTradeMark);
end;

function TnzrVersionInfo.GetOriginalFileName: string;
begin
  Result := GetVersionInfo(vtOriginalFileName);
end;

function TnzrVersionInfo.GetProductName: string;
begin
  Result := GetVersionInfo(vtProductName);
end;

function TnzrVersionInfo.GetProductVersion: string;
begin
  if FProductVersion = '' then
    FProductVersion := GetVersionInfo(vtProductVersion);
  if FProductVersion = '' then
    FProductVersion := '0.0.0.0';
  Result := FProductVersion;
end;

function TnzrVersionInfo.GetComments: string;
begin
  Result := GetVersionInfo(vtComments);
end;

function TnzrVersionInfo.GeTVersionInfo(VersionType: TVersionType): string;
begin
  Result := FVersionInfo[ord(VersionType)];
end;

function TnzrVersionInfo.GetCompleteVersionInformation: string;
begin             
  Result := 'Производитель: ' + CompanyName + CRLF +
            'Авторские права: ' + LegalCopyright + CRLF +
            'Товарные знаки: ' + LegalTradeMark + CRLF +
            'Название продукта: ' + ProductName + CRLF +
            'Версия продукта: ' + ProductVersion + CRLF +
            'Версия файла: ' + FileVersion + CRLF +
            'Описание файла: ' + FileDescription + CRLF +
            'Внутреннее имя: ' + InternalName + CRLF +
            'Исходное имя файла: ' + OriginalFileName + CRLF +
            'Комментарий: ' + Comments;
end;

end.
