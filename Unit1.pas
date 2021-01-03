unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,Math, jpeg;

type
  TForm1 = class(TForm)
    pb1: TPaintBox;
    start: TButton;
    PrevLine: TButton;
    clearLine: TButton;
    tmr1: TTimer;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    img1: TImage;
    img2: TImage;
    btn1: TButton;
    procedure startClick(Sender: TObject);
    procedure pb1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrevLineClick(Sender: TObject);
    procedure clearLineClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const maxlenght = 40;
      a=-200;
var
  Form1: TForm1;
  mass, programmmass:array[1..8] of array[1..8] of Integer;
  yline,xline,yline1,xline1:array [1..8] of Integer;
  //xline - горизонтальная линия
  //yline - вертикальная линия
  prevxy:Integer;
  fortimer,rekord:Integer;
implementation

{$R *.dfm}
procedure drawMap;                      //новая карта
var i,j:Integer;
begin
  Form1.pb1.Canvas.Pen.Color:=clBlack;
  Form1.pb1.Canvas.Pen.Width:=2;
  Form1.pb1.Canvas.Brush.Color:=clWhite;
  Form1.pb1.canvas.rectangle(0,0,425,425);
  for i:=1 to 8 do
  begin
    for j:=1 to 8 do
    begin
      if(mass[i][j]<0)then
        Form1.pb1.Canvas.Brush.Color:=clSkyBlue
      else
      if(mass[i][j]=100)then
        Form1.pb1.Canvas.Brush.Color:=clGreen
      else
        Form1.pb1.Canvas.Brush.Color:=clWhite;
      Form1.pb1.canvas.rectangle(i*50-50,j*50-50,i*50,j*50);
      if(mass[i][j]<>0) and (mass[i][j]<>-100) and (mass[i][j]<>-200)and (mass[i][j]<>100)then
      Form1.pb1.Canvas.TextOut(i*50-25,j*50-25,IntToStr(Abs(mass[i,j])));
    end;
  end;
  Form1.pb1.Canvas.Brush.Color:=clWhite;
  for i:=1 to 8 do
  begin
    if(xline[i]>0) then
     Form1.pb1.Canvas.TextOut(i*50-25,410,IntToStr(xline[i]));
    if(yline[i]>0) then
     Form1.pb1.Canvas.TextOut(415,i*50-25,IntToStr(yline[i]));
  end;
end;
function count():integer;
var c,i,j:Integer;
begin
  c:=0;
  for i:=1 to 8 do
    for j:=1 to 8 do
        if(mass[i][j]<0)then
          c:=c+1;
  Result:=c;
end;
function pravierka(x,y:integer):Boolean;
var v:Integer;
begin
  v:=0;
  if(mass[x+1][y]<0)and(x<8) then v:=v+1;
  if(mass[x-1][y]<0)and(x>0) then v:=v+1;
  if(mass[x][y+1]<0)and(y<8) then v:=v+1;
  if(mass[x][y-1]<0)and(y>0) then v:=v+1;
  Result:=v=1;
end;
procedure newMap();
var i,j:Integer;
    x,y,y0,x0:Integer;
    v:Integer;
begin
  prevxy:=0;
  for i:=1 to 8 do
  begin
    yline[i]:=0;
    xline[i]:=0;
    for j:=1 to 8 do
    begin
      mass[i,j]:=0;
    end;
  end;
    x:=  Random(8)+1;
    y:=  Random(8)+1;
    mass[x][y]:=-1;
    while count<31 do
    begin
      x0:=x;
      y0:=y;
      v:=Random(4);// Form1.mmo1.Lines.Add('v='+IntToStr(v));
      if (v=0) and (x<8)and (mass[x+1][y]>=0) and (pravierka(x+1,y)) then
        x:=x+1;

      if (v=1) and (x>1)and (mass[x-1][y]>=0) and (pravierka(x-1,y)) then
        x:=x-1;

      if (v=2) and (y<8)and (mass[x][y+1]>=0) and (pravierka(x,y+1)) then
        y:=y+1;

      if (v=3) and (y<1)and (mass[x][y-1]>=0) and (pravierka(x,y-1)) then
        y:=y-1;
      if(prevxy=14)and (pravierka(x,y-1))then y:=y-1;
      mass[x][y]:=a;
      if count=1 then  mass[x][y]:=-1;
      if count=16 then  mass[x][y]:=-16;
      if count=31 then  mass[x][y]:=-31;
      if(x0=x)and (y0=y)then prevxy:=prevxy+1 else prevxy:=0;
     // Form1.mmo1.Lines.Add(IntToStr(count));
     // Form1.mmo1.Lines.Add(IntToStr(x));
     // Form1.mmo1.Lines.Add(IntToStr(y));
     // drawMap;

      if(prevxy=15)then newMap;
    end;

end;
procedure getRecord();
var a:TextFile;
    min,sec:integer;
begin
    AssignFile(a,'Record.txt');
    Reset(a);
    readln(a, rekord);
    CloseFile(a);
    min:=rekord div 60;
    sec:=rekord mod 60;
    Form1.lbl2.Caption:=IntToStr(min)+':'+inttostr(sec);
end;
procedure setRecord();
var a:TextFile;
    min,sec:integer;
begin
    AssignFile(a,'Record.txt');
    Rewrite(a);
    writeln(a, fortimer);
    CloseFile(a);
end;
procedure TForm1.startClick(Sender: TObject);
var i,j,z:Integer;
begin
  getRecord();
  fortimer:=0;
  tmr1.Enabled:=True;
  prevxy:=0;
  newMap();
  programmmass:=mass;
   for i:=1 to 8 do
    begin
      for j:=1 to 8 do
      begin
        if(mass[i][j]<0) then
        begin
          Inc(yline[j]);
          Inc(xline[i]);
          if(mass[i][j]=-200)then
            mass[i][j]:=0;
        end;
      end;
    end;
  drawMap();
end;

procedure TForm1.pb1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var i,j:Integer;
begin
     if (mbLeft = Button) then
     begin

      if mass[x div 50 +1][y div 50 +1]=0 then
        mass[x div 50 +1][y div 50 +1]:=-100
      else  if mass[x div 50 +1][y div 50 +1]=-100 then
        mass[x div 50 +1][y div 50 +1]:=0
      else mass[x div 50 +1][y div 50 +1]:=-1*mass[x div 50 +1][y div 50 +1];



     end;
     if (mbRight = Button) then
     begin

      if mass[x div 50 +1][y div 50 +1]=0 then
        mass[x div 50 +1][y div 50 +1]:=100
      else  if mass[x div 50 +1][y div 50 +1]=100 then
        mass[x div 50 +1][y div 50 +1]:=0
      



     end;
     {if(mbRight = Button)and(false)then
     begin

      if(y>400)then
     //   xline[x div 50 +1]:= StrToInt(lik.text)
      else if(x>400)then
     //   yline[y div 50 +1]:= StrToInt(lik.text)
      else
    //  mass[x div 50 +1][y div 50 +1]:=StrToInt(lik.text);
     end;}
     drawMap;

end;

procedure TForm1.PrevLineClick(Sender: TObject);
begin
  mass:=programmmass;
  drawMap;
end;

procedure TForm1.clearLineClick(Sender: TObject);
var win:Boolean;
    i,j:Integer;
begin
  win:=True;
  yline1:=yline;
  xline1:=xline;
   for i:=1 to 8 do
    begin
      for j:=1 to 8 do
      begin
        if(mass[i][j]<0) then
        begin
          dec(yline1[j]);
          dec(xline1[i]);
        end;
      end;
    end;
    for i:=1 to 8 do
    begin
      if (yline1[i]<>0) or (xline1[i]<>0) then win:=False;
    end;
    tmr1.Enabled:=not(win);
    if(win)then
    begin
      ShowMessage('Победа');
      setRecord();
    end
    else ShowMessage('Проuгрыш');

end;

procedure TForm1.tmr1Timer(Sender: TObject);
var min,sec:Integer;
begin
  Inc(fortimer);
  min:=fortimer div 60;
  sec:=fortimer mod 60;
  lbl1.Caption:=IntToStr(min)+':'+inttostr(sec);
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
Close;
end;



end.
