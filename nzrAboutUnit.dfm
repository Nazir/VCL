object nzrAboutForm: TnzrAboutForm
  Left = 372
  Top = 155
  BorderStyle = bsNone
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
  ClientHeight = 298
  ClientWidth = 407
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 7820873
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pnBackground: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 298
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 2
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    OnClick = FormClick
    object lbVersion: TLabel
      Left = 0
      Top = 33
      Width = 405
      Height = 13
      Align = alTop
      Alignment = taRightJustify
      Caption = #1074#1077#1088#1089#1080#1103' 0.0.0     '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7820873
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = FormClick
    end
    object lbProjectName: TLabel
      Left = 0
      Top = 0
      Width = 405
      Height = 33
      Align = alTop
      Alignment = taCenter
      BiDiMode = bdLeftToRight
      Caption = 'Nazir Tools [NZR]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7820873
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
      Transparent = True
      OnClick = FormClick
    end
    object lbCreators: TLabel
      Left = 0
      Top = 160
      Width = 405
      Height = 136
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 
        #1055#1088#1072#1074#1072' '#1085#1072' '#1087#1072#1082#1077#1090' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074' '#1087#1088#1077#1085#1072#1076#1083#1077#1078#1072#1090':'#13#10#1061#1091#1089#1085#1091#1076#1080#1085#1086#1074' '#1053#1072#1079#1080#1088' '#1050#1072#1088#1080#1084#1086 +
        #1074#1080#1095'  (aka Wild Pointer)'#13#10#13#10'Nazir Software '#169' 2002-2013,'#13#10#1042#1089#1077' '#1087#1088#1072#1074 +
        #1072' '#1089#1086#1073#1083#1102#1076#1077#1085#1099'.'
      Transparent = True
      OnClick = FormClick
    end
    object lbComponentInfo: TLabel
      Left = 0
      Top = 46
      Width = 405
      Height = 114
      Align = alClient
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7820873
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      OnClick = FormClick
    end
  end
end
