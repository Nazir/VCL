unit nzrUtilsUnit;

{*****************************************************************}
{                                                                 }
{                      Модуль с утилитами                         }
{                                                                 }
{  Авторское право: Nazir Software © 2004-2006                    }
{  Разработчики: Хуснутдинов Назир Каримович  (Wild Pointer)      }
{                Галездинов Сергей Фаридович (Sega-Zero)          }
{                Смолин Николай Геннадьевич (SnugForce)           }
{  Модифицирован: 04.10.2006                                      }
{                                                                 }
{*****************************************************************}

interface

uses
  Windows, ActiveX, ComObj, Classes, Graphics, ShlObj, nzrTypesUnit;

const
  //
  iKey_string = 413696;

procedure SaveLog(ALogName, ALogText, ALogStatus: string);
// Запись журналов регистраций
procedure CodeBuf(Buf: Pointer; Len: Integer; Key: Integer);
procedure DeCodeBuf(Buf: Pointer; Len: Integer; Key: Integer);
// function DeCoderString(str: string; key: integer): string;
function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
                       StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
function Get_CATID_List(ACATID: TGUID; AUseDisabled: Boolean = True): TStrings;

function GetFilesList(FindMask: string): string;

function Min( A, B: Integer ): Integer;
function Max( A, B: Integer ): Integer;

procedure ColorToHSL( C: TColor; var H, S, L: Byte );
function IsTrueTypeFont( Font: TFont ): Boolean;
function RotateFont( Font: TFont; Angle: Integer ): HFont;
function HSLtoColor( H, S, L: Byte ): TColor;
function DarkerColor( C: TColor; Adjustment: Byte ): TColor;
function LighterColor( C: TColor; Adjustment: Byte ): TColor;
function AdjustColor( C: TColor; Adjustment: Integer ): TColor;

function DrawSides( Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Sides: TSides ): TRect;

function DrawBevel( Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Width: Integer; Sides: TSides ): TRect;

function DrawBorderSides( Canvas: TCanvas; Bounds: TRect; Style: TFrameStyle; Sides: TSides ): TRect;

function DrawRoundedFlatBorder( Canvas: TCanvas; Bounds: TRect; Color: TColor; Sides: TSides ): TRect;

function DrawCtl3DBorderSides( Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides ): TRect;

function DrawButtonBorderSides( Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides ): TRect;

function DrawInnerOuterBorders( Canvas: TCanvas; Bounds: TRect;
                                BorderOuter, BorderInner: TFrameStyleEx;
                                BorderWidth: Integer; BorderSides: TSides; BevelWidth: Integer;
                                BorderColor, BorderHighlight, BorderShadow: TColor;
                                FlatColor: TColor; FlatColorAdjustment: Integer; Color, ParentColor: TColor;
                                Transparent: Boolean; SoftInnerFlatBorder: Boolean = False ): TRect;

function GetSpecialPath(CSIDL: word): string;
// Специальные (стандартные) папки ОС

function PathOSWindows: string;
function PathOSTempUser: string;
function PathOSAppData: string;

implementation

uses
  SysUtils;

procedure SaveLog(ALogName, ALogText, ALogStatus: string);
// Запись в журнал регистраций (LOG)
const
  sLogExt = '.log'; // расширение для файлов журналов регистраций
var
  sPath: string;    // путь по умолчанию
  tFile: Text;      // файл журнала регистраций
  sLogTime: string; // дата и время записи в журнал регистраций
  sAppName: string; // приложение сделавшее запись в журнал регистраций
begin
  // Укажем путь по умолчанию для папки с файлами журналов
  sPath := ExtractFilePath(ParamStr(0));
  // Получаем имя приложения
  sAppName := ExtractFileName(ParamStr(0));
  // Получаем дату и время записи в журнал событий
  sLogTime := DateToStr(Date) + ' ' + TimeToStr(Time) + ' ';
  // Ассоциируем имя файла с переменной fFile
  AssignFile(tFile, sPath + ALogName + '.log');
  // Проверяем существует ли файл
  if FileExists(sPath + ALogName + '.log') then
    Append(tFile)   // если ДА, то открываем файл для записи в конец файла
  else
    Rewrite(tFile); // если НЕТ, то создаем файл и открываем для записи
  // Записываем в файл строку журнала
  WriteLn(tFile, sLogTime + ALogName + ' ' + ALogStatus + ' ' + sAppName +
          ' ' + ALogText);
  // Закрываем файл
  CloseFile(tFile);

  // При необходимос ведем полный лог событий не зависимо от журнала (ALogName)
  AssignFile(tFile, sPath + 'Full.log');
  if FileExists(sPath + 'Full.log') then
    Append(tFile)
  else
    Rewrite(tFile);
  WriteLn(tFile, sLogTime + ALogName + ' ' + ALogStatus + ' ' + sAppName +
          ' ' + ALogText);
  CloseFile(tFile);  
end;

procedure CodeBuf(Buf: Pointer; Len: Integer; Key: Integer);
var
  i: Integer;
begin
  try
  RandSeed := Key;
  for i := 0 to Len - 1 do
    Byte(Pointer(Integer(Buf) + i)^) := (Byte(Pointer(Integer(Buf) + i)^) + Random(255)) mod 256;
  except
  end;
end;

procedure DeCodeBuf(Buf: Pointer; Len: Integer; Key: Integer);
var
  i: Integer;
begin
  try
  RandSeed := Key;
  for i := 0 to Len - 1 do
    Byte(Pointer(Integer(Buf) + i)^) := (Byte(Pointer(Integer(Buf) + i)^) - Random(255)) mod 256;
  except
  end;
end;

function DeCoderString(str: string; key: integer): string;
var
  i: integer;
  b: byte;
  c: byte;
  k: byte;
begin
  Result := '';
  RandSeed := key;
  for i := 1 to length(str) do
  begin
    k := random(255);
    b := ord(str[i]);
    c := (b-k) mod 256;
    Result := Result + chr(c);
  end;
end;

{$WARNINGS OFF}
function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
var
  i: Integer;
  SRec: TSearchRec;
  FN: string;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    exit;
  Result := True;
  // Добавляем слэш в конце и задаем маску - "все файлы и директории"
  Dir := IncludeTrailingBackslash(Dir);
  i := FindFirst(Dir + '*', faAnyFile, SRec);
  try
    while i = 0 do
    begin
      // Получаем полный путь к файлу или директорию
      FN := Dir + SRec.Name;
      // Если это директория
      if SRec.Attr = faDirectory then
      begin
        // Рекурсивный вызов этой же функции с ключом удаления корня
        if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if DeleteAllFilesAndFolders then
            FileSetAttr(FN, faArchive);
          Result := FullRemoveDir(FN, DeleteAllFilesAndFolders,
            StopIfNotAllDeleted, True);
          if not Result and StopIfNotAllDeleted then
            exit;
        end;
      end
      else // Иначе удаляем файл
      begin
        if DeleteAllFilesAndFolders then
          FileSetAttr(FN, faArchive);
        Result := SysUtils.DeleteFile(FN);
        if not Result and StopIfNotAllDeleted then
          exit;
      end;
      // Берем следующий файл или директорию
      i := FindNext(SRec);
    end;
  finally
    SysUtils.FindClose(SRec);
  end;
  if not Result then
    exit;
  if RemoveRoot then // Если необходимо удалить корень - удаляем
    if not RemoveDir(Dir) then
      Result := false;
end;

function Get_CATID_List(ACATID: TGUID; AUseDisabled: Boolean): TStrings;
var
  EnumGUID: IEnumGUID;
  Fetched: Cardinal;
  Guid: TGUID;
  Rslt: HResult;
  CatInfo: ICatInformation;
  slTemp: TStrings;
  arrWinDir: array[0..MAX_PATH] of Char;
begin
  slTemp := TStringList.Create;
  GetWindowsDirectory(arrWinDir, SizeOf(arrWinDir));
  if FileExists(string(arrWinDir) + '\HMDB_DisabledPlugins.lst') then
    slTemp.LoadFromFile(string(arrWinDir) + '\HMDB_DisabledPlugins.lst')
  else
    slTemp.Clear;

  Result := TStringList.Create;
  Rslt := CoCreateInstance(CLSID_StdComponentCategoryMgr, nil,
    CLSCTX_INPROC_SERVER, ICatInformation, CatInfo);
  if Succeeded(Rslt) then
  begin
    OleCheck(CatInfo.EnumClassesOfCategories(1, @ACATID, 0, nil, EnumGUID));
    while EnumGUID.Next(1, Guid, Fetched) = S_OK do
    try
      if AUseDisabled then
      begin
        if slTemp.IndexOf(GUIDToString(Guid)) = -1 then
          Result.Add(GUIDToString(Guid));
      end   
      else
        Result.Add(GUIDToString(Guid));
    except
      // Ignore
    end;
  end;

  slTemp.Free;
end;

{$WARNINGS ON}

function GetFilesList(FindMask: string): string;
var
  srTemp: TSearchRec;
begin
  if FindFirst(FindMask, faAnyFile, srTemp) = 0 then
  begin
    repeat
      if (srTemp.Attr and faAnyFile) = srTemp.Attr then
        Result := Result + srTemp.Name + #13#10;
    until FindNext(srTemp) <> 0;
    FindClose(srTemp);
  end;
end;

function Min( A, B: Integer ): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max( A, B: Integer ): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

procedure ColorToHSL( C: TColor; var H, S, L: Byte );
var
  Dif, CCmax, CCmin, RC, GC, BC, TempH, TempS, TempL: Double;
begin
  { Convert RGB color to Hue, Saturation and Luminance }

  { Convert Color to RGB color value. This is necessary if Color specifies
    a system color such as clHighlight }
  C := ColorToRGB( C );

  { Determine a percent (as a decimal) for each colorant }
  RC := GetRValue( C ) / 255;
  GC := GetGValue( C ) / 255;
  BC := GetBValue( C ) / 255;

  if RC > GC then
    CCmax := RC
  else
    CCmax := GC;
  if BC > CCmax then
    CCmax := BC;

  if RC < GC then
    CCmin := RC
  else
    CCmin := GC;

  if BC < CCmin then
    CCmin := BC;

  { Calculate Luminance }
  TempL := (CCmax + CCmin) / 2.0;

  if CCmax = CCmin then
  begin
    TempS := 0;
    TempH := 0;
  end
  else
  begin
    Dif := CCmax - CCmin;

    { Calculate Saturation }
    if TempL < 0.5 then
      TempS := Dif / (CCmax + CCmin)
    else
      TempS := Dif / ( 2.0 - CCmax - CCmin );

    { Calculate Hue }
    if RC = CCmax then
      TempH := (GC - BC) / Dif
    else if GC = CCmax then
      TempH := 2.0 + (BC - RC) / Dif
    else
      TempH := 4.0 + (RC - GC) / Dif;

    TempH := TempH / 6;
    if TempH < 0 then
      TempH := TempH + 1;
  end;

  H := Round( 240 * TempH );
  S := Round( 240 * TempS );
  L := Round( 240 * TempL );
end; {= ColorToHSL =}

function IsTrueTypeFont( Font: TFont ): Boolean;
var
  DC: HDC;
  SaveFont: HFont;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC( 0 );
  try
    GetTextMetrics( DC, SysMetrics );
    SaveFont := SelectObject( DC, Font.Handle );
    GetTextMetrics( DC, Metrics );
    SelectObject( DC, SaveFont );
  finally
    ReleaseDC( 0, DC );
  end;

  Result := ( Metrics.tmPitchAndFamily and tmpf_TrueType ) = tmpf_TrueType;
end;

function RotateFont( Font: TFont; Angle: Integer ): HFont;
var
  LogFont: TLogFont;
begin
  FillChar( LogFont, SizeOf( LogFont ), #0 );
  with LogFont do
  begin
    lfHeight := Font.Height;
    lfWidth := 0;
    lfEscapement := Angle * 10;        { Escapement must be in 10th of degrees }
    lfOrientation := 0;
    if fsBold in Font.Style then
      lfWeight := fw_Bold
    else
      lfWeight := fw_Normal;
    lfItalic := Byte( fsItalic in Font.Style );
    lfUnderline := Byte( fsUnderline in Font.Style );
    lfStrikeOut := Byte( fsStrikeOut in Font.Style );
    lfCharSet := Default_CharSet;
    lfOutPrecision := Out_Default_Precis;
    lfClipPrecision := Clip_Default_Precis;
    lfQuality := Default_Quality;
    case Font.Pitch of
      fpVariable:
        lfPitchAndFamily := Variable_Pitch;

      fpFixed:
        lfPitchAndFamily := Fixed_Pitch;

      else
        lfPitchAndFamily := Default_Pitch;
    end;
    StrPCopy( lfFaceName, Font.Name );
  end; { with }
  Result := CreateFontIndirect( LogFont );
end; {= RotateFont =}

function HSLtoColor( H, S, L: Byte ): TColor;
var
  HN, SN, LN, RD, GD, BD, V, M, SV, Fract, VSF, Mid1, Mid2: Double;
  R, G, B: Byte;
  Sextant: Integer;
begin
  { Hue, Saturation, and Luminance must be normalized to 0..1 }

  HN := H / 239;
  SN := S / 240;
  LN := L / 240;

  if LN < 0.5 then
    V := LN * ( 1.0 + SN )
  else
    V := LN + SN - LN * SN;
  if V <= 0 then
  begin
    RD := 0.0;
    GD := 0.0;
    BD := 0.0;
  end
  else
  begin
    M := LN + LN - V;
    SV := (V - M ) / V;
    HN := HN * 6.0;
    Sextant := Trunc( HN );
    Fract := HN - Sextant;
    VSF := V * SV * Fract;
    Mid1 := M + VSF;
    Mid2 := V - VSF;

    case Sextant of
      0:
      begin
        RD := V;
        GD := Mid1;
        BD := M;
      end;

      1:
      begin
        RD := Mid2;
        GD := V;
        BD := M;
      end;

      2:
      begin
        RD := M;
        GD := V;
        BD := Mid1;
      end;

      3:
      begin
        RD := M;
        GD := Mid2;
        BD := V;
      end;

      4:
      begin
        RD := Mid1;
        GD := M;
        BD := V;
      end;

      5:
      begin
        RD := V;
        GD := M;
        BD := Mid2;
      end;

      else
      begin
        RD := V;
        GD := Mid1;
        BD := M;
      end;
    end;
  end;

  if RD > 1.0 then
    RD := 1.0;
  if GD > 1.0 then
    GD := 1.0;
  if BD > 1.0 then
    BD := 1.0;
  R := Round( RD * 255 );
  G := Round( GD * 255 );
  B := Round( BD * 255 );
  Result := RGB( R, G, B );
end; {= HSLtoColor =}

function DarkerColor( C: TColor; Adjustment: Byte ): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL( C, H, S, L );
  Result := HSLtoColor( H, S, Max( L - Adjustment, 0 ) );
end;

function LighterColor( C: TColor; Adjustment: Byte ): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL( C, H, S, L );
  Result := HSLtoColor( H, S, Min( L + Adjustment, 255 ) );
end;

function AdjustColor( C: TColor; Adjustment: Integer ): TColor;
begin
  Result := C;
  if Adjustment < 0 then
    Result := DarkerColor( C, -Adjustment )
  else if Adjustment > 0 then
    Result := LighterColor( C, Adjustment );
end;

function DrawSides( Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Sides: TSides ): TRect;
begin
  if ULColor <> clNone then
  begin
    Canvas.Pen.Color := ULColor;
    if sdLeft in Sides then
    begin
      Canvas.MoveTo( Bounds.Left, Bounds.Top );
      Canvas.LineTo( Bounds.Left, Bounds.Bottom );
    end;

    if sdTop in Sides then
    begin
      Canvas.MoveTo( Bounds.Left, Bounds.Top );
      Canvas.LineTo( Bounds.Right, Bounds.Top );
    end;
  end;

  if LRColor <> clNone then
  begin
    Canvas.Pen.Color := LRColor;
    if sdRight in Sides then
    begin
      Canvas.MoveTo( Bounds.Right - 1, Bounds.Top );
      Canvas.LineTo( Bounds.Right - 1, Bounds.Bottom );
    end;

    if sdBottom in Sides then
    begin
      Canvas.MoveTo( Bounds.Left, Bounds.Bottom - 1 );
      Canvas.LineTo( Bounds.Right, Bounds.Bottom - 1 );
    end;
  end;

  if sdLeft in Sides then
    Inc( Bounds.Left );
  if sdTop in Sides then
    Inc( Bounds.Top );
  if sdRight in Sides then
    Dec( Bounds.Right );
  if sdBottom in Sides then
    Dec( Bounds.Bottom );

  Result := Bounds;
end; {= DrawSides =}

function DrawBevel( Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Width: Integer; Sides: TSides ): TRect;
var
  I: Integer;
begin
  Canvas.Pen.Width := 1;
  for I := 1 to Width do                         { Loop through width of bevel }
  begin
    Bounds := DrawSides( Canvas, Bounds, ULColor, LRColor, Sides );
  end;
  Result := Bounds;
end;

function DrawBorderSides( Canvas: TCanvas; Bounds: TRect; Style: TFrameStyle; Sides: TSides ): TRect;
var
  ULColor, LRColor: TColor;
  R: TRect;
begin
  ULColor := ULFrameColor[ Style ];
  LRColor := LRFrameColor[ Style ];

  { Draw the Frame }
  if Style <> fsNone then
  begin
    if Style in [ fsFlat, fsStatus, fsPopup ] then
      Bounds := DrawSides( Canvas, Bounds, ULColor, LRColor, Sides )
    else if Style in [ fsFlatBold ] then
      Bounds := DrawBevel( Canvas, Bounds, ULColor, LRColor, 2, Sides )
    else if Style in [ fsLowered, fsRaised ] then
      Bounds := DrawCtl3DBorderSides( Canvas, Bounds, Style = fsLowered, Sides )
    else if Style in [ fsButtonDown, fsButtonUp ] then
      Bounds := DrawButtonBorderSides( Canvas, Bounds, Style = fsButtonDown, Sides )
    else
    begin
      { Style must be fsGroove or fsBump }
      R := Bounds;
      { Fill in the gaps created by offsetting the rectangle }
      { Upper Right Gap }
      if sdRight in Sides then
        Canvas.Pixels[ R.Right - 1, R.Top ] := LRColor;
      if ( sdTop in Sides ) and not ( sdRight in Sides ) then
        Canvas.Pixels[ R.Right - 1, R.Top ] := ULColor;

      { Lower Left Gap }
      if sdBottom in Sides then
        Canvas.Pixels[ R.Left, R.Bottom - 1 ] := LRColor;
      if ( sdLeft in Sides ) and not ( sdBottom in Sides ) then
        Canvas.Pixels[ R.Left, R.Bottom - 1 ] := ULColor;

      { Upper Left Gaps }
      if ( sdTop in Sides ) and not ( sdLeft in Sides ) then
        Canvas.Pixels[ R.Left, R.Top + 1 ] := LRColor;
      if not ( sdTop in Sides ) and ( sdLeft in Sides ) then
        Canvas.Pixels[ R.Left + 1, R.Top ] := LRColor;

      { Lower Right Gaps }
      if ( sdBottom in Sides ) and not ( sdRight in Sides ) then
        Canvas.Pixels[ R.Right - 1, R.Bottom - 2 ] := ULColor;
      if not ( sdBottom in Sides ) and ( sdRight in Sides ) then
        Canvas.Pixels[ R.Right - 2, R.Bottom - 1 ] := ULColor;

      Inc( R.Left );
      Inc( R.Top );
      DrawSides( Canvas, R, LRColor, LRColor, Sides );
      OffsetRect( R, -1, -1 );
      DrawSides( Canvas, R, ULColor, ULColor, Sides );
      if sdLeft in Sides then
        Inc( Bounds.Left, 2 );
      if sdTop in Sides then
        Inc( Bounds.Top, 2 );
      if sdRight in Sides then
        Dec( Bounds.Right, 2 );
      if sdBottom in Sides then
        Dec( Bounds.Bottom, 2 );
    end;
  end;
  Result := Bounds;
end; {= DrawBorderSides =}

function DrawRoundedFlatBorder( Canvas: TCanvas; Bounds: TRect; Color: TColor; Sides: TSides ): TRect;
var
  X1, X2, Y1, Y2: Integer;
begin
  Canvas.Pen.Color := Color;

  if sdLeft in Sides then
  begin
    if sdTop in Sides then
      Y1 := 2
    else
      Y1 := 0;
    if sdBottom in Sides then
      Y2 := 2
    else
      Y2 := 0;
    Canvas.MoveTo( Bounds.Left, Bounds.Top + Y1 );
    Canvas.LineTo( Bounds.Left, Bounds.Bottom - Y2 );
  end;

  if sdTop in Sides then
  begin
    if sdLeft in Sides then
      X1 := 2
    else
      X1 := 0;
    if sdRight in Sides then
      X2 := 2
    else
      X2 := 0;
    Canvas.MoveTo( Bounds.Left + X1, Bounds.Top );
    Canvas.LineTo( Bounds.Right - X2, Bounds.Top );
  end;

  if sdRight in Sides then
  begin
    if sdTop in Sides then
      Y1 := 2
    else
      Y1 := 0;
    if sdBottom in Sides then
      Y2 := 2
    else
      Y2 := 0;
    Canvas.MoveTo( Bounds.Right - 1, Bounds.Top + Y1 );
    Canvas.LineTo( Bounds.Right - 1, Bounds.Bottom - Y2 );
  end;

  if sdBottom in Sides then
  begin
    if sdLeft in Sides then
      X1 := 2
    else
      X1 := 0;
    if sdRight in Sides then
      X2 := 2
    else
      X2 := 0;
    Canvas.MoveTo( Bounds.Left + X1, Bounds.Bottom - 1 );
    Canvas.LineTo( Bounds.Right - X2, Bounds.Bottom - 1 );
  end;

  if ( sdLeft in Sides ) and ( sdTop in Sides ) then
    Canvas.Pixels[ Bounds.Left + 1, Bounds.Top + 1 ] := Color;
  if ( sdTop in Sides ) and ( sdRight in Sides ) then
    Canvas.Pixels[ Bounds.Right - 2, Bounds.Top + 1 ] := Color;
  if ( sdRight in Sides ) and ( sdBottom in Sides ) then
    Canvas.Pixels[ Bounds.Right - 2, Bounds.Bottom - 2 ] := Color;
  if ( sdLeft in Sides ) and ( sdBottom in Sides ) then
    Canvas.Pixels[ Bounds.Left + 1, Bounds.Bottom - 2 ] := Color;


  if sdLeft in Sides then
    Inc( Bounds.Left, 2 );
  if sdTop in Sides then
    Inc( Bounds.Top, 2 );
  if sdRight in Sides then
    Dec( Bounds.Right, 2 );
  if sdBottom in Sides then
    Dec( Bounds.Bottom, 2 );

  Result := Bounds;
end; {= DrawRoundedFlatBorder =}

function DrawCtl3DBorderSides( Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides ): TRect;
const
  Colors: array[ 1..4, Boolean ] of TColor = ( ( cl3DLight, clBtnShadow ),
                                                ( cl3DDkShadow, clBtnHighlight ),
                                                ( clBtnHighlight, cl3DDkShadow ),
                                                ( clBtnShadow, cl3DLight ) );
begin
  Bounds := DrawBevel( Canvas, Bounds, Colors[ 1, Lowered ], Colors[ 2, Lowered ], 1, Sides );
  Result := DrawBevel( Canvas, Bounds, Colors[ 3, Lowered ], Colors[ 4, Lowered ], 1, Sides );
end;

function DrawButtonBorderSides( Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides ): TRect;
const
  Colors: array[ 1..4, Boolean ] of TColor = ( ( clBtnHighlight, clBtnText ),
                                                ( cl3DDkShadow, clBtnText ),
                                                ( cl3DLight, clBtnShadow ),
                                                ( clBtnShadow, clBtnShadow ) );
begin
  Bounds := DrawBevel( Canvas, Bounds, Colors[ 1, Lowered ], Colors[ 2, Lowered ], 1, Sides );
  Result := DrawBevel( Canvas, Bounds, Colors[ 3, Lowered ], Colors[ 4, Lowered ], 1, Sides );
end;

function DrawInnerOuterBorders( Canvas: TCanvas; Bounds: TRect;
                                BorderOuter, BorderInner: TFrameStyleEx;
                                BorderWidth: Integer; BorderSides: TSides; BevelWidth: Integer;
                                BorderColor, BorderHighlight, BorderShadow: TColor;
                                FlatColor: TColor; FlatColorAdjustment: Integer; Color, ParentColor: TColor;
                                Transparent: Boolean; SoftInnerFlatBorder: Boolean = False ): TRect;
var
  TempR: TRect;
  C: TColor;
begin
  Result := Bounds;

  { Outer Border }
  if BorderOuter in [ fsFlat, fsFlatBold, fsFlatRounded ] then
  begin
    C := AdjustColor( FlatColor, FlatColorAdjustment );
    if BorderOuter = fsFlat then
      Result := DrawBevel( Canvas, Result, C, C, 1, BorderSides )
    else if BorderOuter = fsFlatBold then
      Result := DrawBevel( Canvas, Result, C, C, 2, BorderSides )
    else
    begin
      if not Transparent then
      begin
        TempR := DrawBevel( Canvas, Result, ParentColor, ParentColor, 1, BorderSides );
        if ( BorderWidth > 0 ) or ( BorderInner <> fsNone ) then
          DrawBevel( Canvas, TempR, BorderColor, BorderColor, 1, BorderSides )
        else
          DrawBevel( Canvas, TempR, Color, Color, 1, BorderSides );
      end
      else // Transparent
      begin
        if ( BorderWidth > 0 ) or ( BorderInner <> fsNone ) then
        begin
          TempR := Result;
          InflateRect( TempR, -1, -1 );
          DrawBevel( Canvas, TempR, BorderColor, BorderColor, 1, BorderSides );
        end;
      end;
      Result := DrawRoundedFlatBorder( Canvas, Result, C, BorderSides );
    end;
  end
  else if BorderOuter = fsPopup then
    Result := DrawBevel( Canvas, Result, BorderHighlight, BorderShadow, BevelWidth, BorderSides )
  else if BorderOuter = fsStatus then
    Result := DrawBevel( Canvas, Result, BorderShadow, BorderHighlight, BevelWidth, BorderSides )
  else
    Result := DrawBorderSides( Canvas, Result, BorderOuter, BorderSides );

  { Space between borders }
  if BorderWidth > 0 then
    Result := DrawBevel( Canvas, Result, BorderColor, BorderColor, BorderWidth, BorderSides );

  { Inner Border }
  if BorderInner in [ fsFlat, fsFlatBold, fsFlatRounded ] then
  begin
    C := AdjustColor( FlatColor, FlatColorAdjustment );
    if BorderInner = fsFlat then
    begin
      if not SoftInnerFlatBorder then
        Result := DrawBevel( Canvas, Result, C, C, 1, BorderSides )
      else
      begin
        Canvas.Pen.Color := C;
        // Left side
        Canvas.MoveTo( Result.Left, Result.Top + 1 );
        Canvas.LineTo( Result.Left, Result.Bottom - 1 );
        // Top side
        Canvas.MoveTo( Result.Left + 1, Result.Top );
        Canvas.LineTo( Result.Right - 1, Result.Top );
        // Right side
        Canvas.MoveTo( Result.Right - 1, Result.Top + 1 );
        Canvas.LineTo( Result.Right - 1, Result.Bottom - 1 );
        // Bottom side
        Canvas.MoveTo( Result.Left + 1, Result.Bottom - 1 );
        Canvas.LineTo( Result.Right - 1, Result.Bottom - 1 );

        InflateRect( Result, -1, -1 );
      end;
    end
    else if BorderInner = fsFlatBold then
      Result := DrawBevel( Canvas, Result, C, C, 2, BorderSides )
    else
    begin
      if not Transparent then
      begin
        TempR := DrawBevel( Canvas, Result, BorderColor, BorderColor, 1, BorderSides );
        DrawBevel( Canvas, TempR, Color, Color, 1, BorderSides );
      end
      else // Transparent
        DrawBevel( Canvas, Result, BorderColor, BorderColor, 1, BorderSides );
      Result := DrawRoundedFlatBorder( Canvas, Result, C, BorderSides );
    end;
  end
  else if BorderInner = fsPopup then
    Result := DrawBevel( Canvas, Result, BorderHighlight, BorderShadow, BevelWidth, BorderSides )
  else if BorderInner = fsStatus then
    Result := DrawBevel( Canvas, Result, BorderShadow, BorderHighlight, BevelWidth, BorderSides )
  else
    Result := DrawBorderSides( Canvas, Result, BorderInner, BorderSides );

end; {= DrawInnerOuterBorders =}

function GetSpecialPath(CSIDL: word): string;
// Специальные (стандартные) папки ОС
var s:  string;
//<04.12.2012> WP Nazir
// uses ShlObj;
// Snowy   http://www.delphilab.ru/content/view/160/85/
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := GetSpecialPath(CSIDL_APPDATA);
  result := PChar(s);
end;

function PathOSWindows: string;
var
  arrWinDir: array[0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(arrWinDir, SizeOf(arrWinDir));
  Result := arrWinDir;
  Result := Result + '\';
end;

function PathOSTempUser: string;
var
  arrTempPath: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(arrTempPath), arrTempPath);
  Result := arrTempPath;
end;

function PathOSAppData: string;
begin
  //<04.12.2012> WP Nazir
  Result := GetSpecialPath($1c);
  Result := Result + '\';
end;

end.

