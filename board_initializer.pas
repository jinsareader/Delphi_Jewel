unit board_initializer;

interface
  procedure clear_board(var board : array of integer; board_width : integer; board_height : integer);
  procedure set_board_wall(var board : array of integer; board_width : integer; board_height : integer);
  procedure change_block(var board: array of integer; board_width : integer; board_height : integer; first_click : integer; second_click : integer);
  procedure set_jewels(var board : array of integer; board_width : integer; board_height : integer);
  function drop_block(var board:array of integer; board_width :integer; board_height : integer) : boolean;
  function destroy_block(var board:array of integer; board_width : integer; board_height : integer) : integer;

implementation

  procedure clear_board(var board : array of integer; board_width : integer; board_height : integer);
var
  i: Integer;
  begin
    for i := 0 to (board_width + 2) * (board_height + 2) - 1 do
      board[i] := 0;
  end;

  procedure set_board_wall(var board : array of integer; board_width : integer; board_height : integer);
var
  i: Integer;
  begin
    for i := 0 to board_width + 1 do
    begin
      board[i] := -100;
      board[i+(board_width+2)*(board_height+1)] := -100;
    end;
    for i := 0 to board_height + 1 do
    begin
      board[i*(board_width+2)] := -100;
      board[i*(board_width+2)+(board_width+1)] := -100;
    end;

  end;

  procedure set_jewels(var board : array of integer; board_width : integer; board_height : integer);
var
  i : integer;
  begin
    for i := 0 to (board_width + 2) * (board_height + 2) - 1 do
      if board[i] >= 0 then
        board[i] := random(7) + 1;
  end;

  procedure change_block(var board: array of integer; board_width : integer; board_height : integer; first_click : integer; second_click : integer);
var
  temp, i : integer;
  begin
    for i := 0 to (board_width + 2) * (board_height + 2) - 1 do
      if board[i] > 100 then
        board[i] := board[i] mod 100;
    temp := board[first_click];
    board[first_click] := board[second_click];
    board[second_click] := temp;
  end;

  function drop_block(var board:array of integer; board_width :integer; board_height : integer) : boolean;
var
  i, j, k : integer;
  remain : boolean;
  begin
    remain := false;

    for i := board_height downto 1 do
      for j := board_width downto 1 do
        begin
          if board[(board_width+2)*i+j] = 0 then
          begin
            k := 0;
            while board[(board_width+2)*i+j-k] = 0 do
              k := k + 1;
            if board[(board_width+2)*i+j-k] < 0 then
            begin
              k := k - 1;
              board[(board_width+2)*i+j-k] := random(7) + 1;
            end;
            if k > 0 then
            begin
              board[(board_width+2)*i+j] := board[(board_width+2)*i+j-k];
              board[(board_width+2)*i+j-k] := 0;
            end;
          end;
        end;

    result := remain;
  end;

  function destroy_block(var board:array of integer; board_width : integer; board_height : integer) : integer;
var
  i, j, k, count : integer;
  destroyed : integer;
  begin
    destroyed := 0;

    for i := 1 to board_width - 2 do
      for j := 1 to board_height do
        begin
          count := 1;
          while True do
          begin
            if board[(board_width+2)*j+i] mod 1000 = board[(board_width+2)*j+i+count] mod 1000 then
              count := count + 1
            else
              break;
          end;
          if count >= 3 then
          begin
            for k := 0 to count - 1 do
              board[(board_width+2)*j+i+K] := board[(board_width+2)*j+i+k] + 1000;
          end;
        end;
    for i := 1 to board_height - 2 do
      for j := 1 to board_width do
        begin
          count := 1;
          while True do
          begin
            if board[(board_width+2)*i+j] mod 1000 = board[(board_width+2)*(i+count)+j] mod 1000 then
              count := count + 1
            else
              break;
          end;
          if count >= 3 then
          begin
            for k := 0 to count - 1 do
              board[(board_width+2)*(i+k)+j] := board[(board_width+2)*(i+k)+j] + 1000;
          end;
        end;

    for i := 0 to (board_width + 2) * (board_height + 2) - 1 do
    begin
      if board[i] >= 1000 then
      begin
        board[i] := 0;
        destroyed := destroyed + 1;
      end;
    end;

    result := destroyed;
  end;

end.
