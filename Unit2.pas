unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Unit1,Unit3, StdCtrls, ExtCtrls, jpeg;

type
  TForm2 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    pnl1: TPanel;
    img1: TImage;
    img2: TImage;
    lbl1: TLabel;
    btn3: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm2.btn2Click(Sender: TObject);
begin
   Form3.Show;
end;

procedure TForm2.btn3Click(Sender: TObject);
begin
Close;
end;

end.
