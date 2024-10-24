unit Junit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxGDIPlusClasses, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  Tmainform = class(TForm)
    Button1: TButton;
    drop_test: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure show_board;
    procedure imagesclick(Sender: Tobject);
    procedure drop_testClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure initial_creation;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TAthread = class(TThread)
  protected
    procedure Execute; override;
  public
  end;

var
  mainform: Tmainform;
  Athread: TAthread;
  board : array of integer;
  images : array of Timage;
  board_height : integer = 10;
  board_width : integer = 10;
  score : integer;
  times : real;
  is_start : boolean = false;
  is_click : boolean = false;
  is_destroyed : integer = 0;

  board_datas : array[0..3] of integer;
implementation

uses
  board_initializer;

{$R *.dfm}

procedure Tmainform.Button1Click(Sender: TObject);
begin
  timer1.Enabled := true;
  is_start := true;
  times := -1;
  is_click := false;
  set_jewels(board, board_width, board_height);
  set_board_wall(board, board_width, board_height);
  is_destroyed := 1;
  while is_destroyed <>0 do
  begin
    drop_block(board,board_width,board_height);
    is_destroyed := destroy_block(board,board_width,board_height);
  end;

  score := 0;
  label2.Caption := inttostr(score);
  times := 20;
  label4.Caption := formatfloat('0', times);
  show_board;
  athread.Resume;
end;

procedure Tmainform.drop_testClick(Sender: TObject);
begin
  drop_block(board, board_width, board_height);
  show_board;
end;

procedure Tmainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    athread.Terminate;
    athread.Free;
  except

  end;
end;

procedure Tmainform.FormCreate(Sender: TObject);
begin
  mainform.Width := 80 + (board_width + 2) * 40;
  mainform.Height := 80 + (board_height + 2) * 40;
  initial_creation;
end;

procedure Tmainform.imagesclick(Sender: Tobject);
var
  i, tags : integer;
  is_adj : boolean;
begin
  tags := (sender as Timage).Tag;

  if (board[tags]>0) and (is_destroyed = 0) and (times >= 0) then
  begin
    if not is_click then
    begin
      board[tags] := board[tags] + 100;
      is_click := true;
      show_board;
    end
    else
    begin
      is_adj := false;
      for i := 0 to 3 do
      begin
        if board[tags + board_datas[i]] > 100 then
          begin
            change_block(board, board_width, board_height, tags, tags + board_datas[i]);
            is_destroyed := destroy_block(board, board_width, board_height);
            score := score + is_destroyed;
            Label2.Caption := inttostr(score);
            if is_destroyed = 0 then
              change_block(board, board_width, board_height, tags, tags + board_datas[i]);
            is_adj := true;
            show_board;
            break;
          end
      end;
      if not is_adj then
      begin
        for i := 0 to (board_width + 2) * (board_height + 2) - 1 do
          if board[i] > 100 then
            board[i] := board[i] mod 100;
        show_board;
      end;

      is_click := false;
    end;
  end;
end;

procedure Tmainform.initial_creation;
var
  i, j : integer;
begin
    Athread := TAthread.Create(true);
    board_datas[0] := -(board_width + 2);
    board_datas[1] := -1;
    board_datas[2] := 1;
    board_datas[3] := board_width + 2;
    randomize();

    setlength(board, (board_width+2) * (board_height+2));
    setlength(images, (board_width+2) * (board_height+2));

    for i := 0 to board_height + 1 do
      for j := 0 to board_width + 1 do
      begin
        images[i * (board_width+2) + j] := timage.Create(self);
        images[i * (board_width+2) + j].parent := self;
        images[i * (board_width+2) + j].AutoSize := false;
        images[i * (board_width+2) + j].Width := 40;
        images[i * (board_width+2) + j].Height := 40;
        images[i * (board_width+2) + j].Stretch := true;
        images[i * (board_width+2) + j].Tag := i * (board_width+2) + j;

        images[i * (board_width+2) + j].top := 40 + 40 * j;
        images[i * (board_width+2) + j].left := 40 + 40 * i;


        images[i * (board_width+2) + j].OnClick := imagesclick;
      end;
end;

procedure Tmainform.show_board;
var
  i : integer;
  address : string;
begin
  for i := 0 to (board_width+2) * (board_height+2) - 1 do
  begin
    if board[i] >= 0 then
    begin
      address := 'jewel\b' + inttostr(board[i]) + '.png';
      images[i].Picture.LoadFromFile(address);
    end
    else
      images[i].Picture.LoadFromFile('jewel\empty.png');
  end;
end;

procedure Tmainform.Timer1Timer(Sender: TObject);
begin
  if (is_destroyed = 0) and (times >= 0) then
  begin
    times := times - 1;
    label4.Caption := formatfloat('0', times);
  end;
  if times < 0 then
    label4.caption := 'You Lose!'
end;

{ TAthread }

procedure TAthread.Execute;
begin
  while true do
  begin
    if terminated then
      break;
    if (is_destroyed <> 0) and (times >= 0) then
    begin
    times := times + is_destroyed * 0.5;
    mainform.label4.Caption := formatfloat('0', times);
    sleep(100);
    drop_block(board, board_width, board_height);
    sleep(100);
    mainForm.show_board;
    sleep(100);
    is_destroyed := destroy_block(board, board_width, board_height);
    score := score + is_destroyed;
    mainform.Label2.Caption := inttostr(score);
    mainForm.show_board;
    end;
  end;

end;

end.
