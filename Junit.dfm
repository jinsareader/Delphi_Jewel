object mainform: Tmainform
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'mainform'
  ClientHeight = 309
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 192
    Top = 8
    Width = 55
    Height = 19
    Caption = 'Score : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 252
    Top = 8
    Width = 18
    Height = 19
    Caption = '00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 296
    Top = 8
    Width = 52
    Height = 19
    Caption = 'Time : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 357
    Top = 8
    Width = 18
    Height = 19
    Caption = '00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object drop_test: TButton
    Left = 96
    Top = 0
    Width = 75
    Height = 25
    Caption = 'drop_test'
    Enabled = False
    TabOrder = 1
    Visible = False
    OnClick = drop_testClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 480
  end
end
