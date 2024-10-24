program Jproject;

uses
  Vcl.Forms,
  Junit in 'Junit.pas' {mainform},
  board_initializer in 'board_initializer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
