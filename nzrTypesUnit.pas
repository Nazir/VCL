unit nzrTypesUnit;

interface

uses
  Controls, Classes, Graphics, Windows;

const
{$IFDEF MSWINDOWS}
  CRLF = #13 + #10;
{$ENDIF}
{$IFDEF LINUX}
  CRLF = #10;
{$ENDIF}
  CR   = #13;
  LF   = #10;
  TAB  = #9;
  NULL_TERMINATOR = #0;

 CSIDL_LOCAL_APPDATA             = $1c;
  // AppData для приложений, которые не переносятся на другой компьютер (обычно C:\Documents and Settings\username\Local Settings\Application Data)  

type

  TColorArray = array of TColor;

  TGradientType = (gtNone, gtHorizontal,
                  gtVertical, gtEnvelope,
                  gtCircles, gtTopBottomPies,
                  gtLeftRightPies, gtTopLeftDiagonal,
                  gtTopRightDiagonal, gtDiamond,
                  gtHorizontalWaves, gtVerticalWaves,
                  gtStar,gtTopLeftFan,gtTopRightFan,
                  gtBottomLeftFan,gtBottomRightFan);

  TAboutProperty = type string;
  TComponentInfo = type string;

  TPlaytype=(ptFile, ptRes, ptSystemSound);

{  TSystemSounds = (SYSTEMSTART,
                  SYSTEMEXIT,
                  SYSTEMHAND,
                  SYSTEMASTERISK,
                  SYSTEMQUESTION,
                  SYSTEMEXCLAMATION,
                  SYSTEMWELCOME,
                  SYSTEMDEFAULT);}

  TSystemSounds = (ssSystemStart,
                  ssSystemExit,
                  ssSystemHand,
                  ssSystemAsterisk,
                  ssSystemQuestion,
                  ssSystemExclamation,
                  ssSystemWelcome,
                  ssSystemDefault);

  TPath = (pthNone, pthApp, pthAppData, pthWindows, pthTempUser);
  
  TPropStorage = (psLeft, psTop, psHeight, psWidth, psWindowState);
  TPropStorages = set of TPropStorage;

  TFormatType = (ftCustom, ftCurrency, ftFloat, ftInteger);
  TCurrencyFormat = (cfRuble, cfUSD, cfEuro);

  // for TnzrLabel & TnzrGroupBar
  TBlinkState = (bsOn, bsOff);
  TRotation = (roNone, roFlat, roCurve);
  TCenterPoint = ( cpUpperLeft,  cpUpperCenter, cpUpperRight,
                   cpLeftCenter, cpCenter,      cpRightCenter,
                   cpLowerLeft,  cpLowerCenter, cpLowerRight );

  TTextStyle = ( tsNormal, tsRaised, tsRecessed, tsShadow );


  TSide = ( sdLeft, sdTop, sdRight, sdBottom );
  TSides = set of TSide;

  TFrameStyleEx = ( fsNone, fsFlat, fsGroove, fsBump, fsLowered, fsButtonDown, fsRaised, fsButtonUp, fsStatus, fsPopup, fsFlatBold, fsFlatRounded );
  TFrameStyle = fsNone..fsFlatBold;
  TCondenseCaption = ( ccNone, ccAtEnd, ccWithinPath );

var
  nzrComponentInfo: TComponentInfo;

const
  // for TnzrLabel & TnzrGroupBar
  cm_GetBlinking                = cm_Base + 1000;
  cm_Blink                      = cm_Base + 1001;

  DrawTextAlignments: array[ TAlignment ] of Word = ( dt_Left,
                                                      dt_Right,
                                                      dt_Center );
  ULFrameColor: array[ TFrameStyle ] of TColor = ( clWindow,             // fsNone
                                                   cl3DDkShadow,         // fsFlat
                                                   clBtnShadow,          // fsGroove
                                                   clBtnHighlight,       // fsBump
                                                   clBtnShadow,          // fsLowered
                                                   clNone,               // fsButtonDown
                                                   cl3DDkShadow,         // fsRaised
                                                   clNone,               // fsButtonUp
                                                   clBtnShadow,          // fsStatus
                                                   clBtnHighlight,       // fsPopup
                                                   clBtnShadow );        // fsFlatBold

  LRFrameColor: array[ TFrameStyle ] of TColor = ( clWindow,             // fsNone
                                                   cl3DDkShadow,         // fsFlat
                                                   clBtnHighlight,       // fsGroove
                                                   clBtnShadow,          // fsBump
                                                   clBtnHighlight,       // fsLowered
                                                   clNone,               // fsButtonDown
                                                   clBtnFace,            // fsRaised
                                                   clNone,               // fsButtonUp
                                                   clBtnHighlight,       // fsStatus
                                                   clBtnShadow,          // fsPopup
                                                   clBtnShadow );        // fsFlatBold

implementation

end.
