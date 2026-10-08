unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, System.UITypes,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, System.IniFiles;

type
  TForm3 = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
  private
    { Private declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

Uses Unit1, Unit2;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Form1.Label6.Caption := Edit1.Text;
  Form1.Label7.Caption := Edit2.Text;
  Form1.Label8.Caption := Edit3.Text;

  Form1.Label10.Caption := Edit1.Text;
  Form1.Label11.Caption := Edit2.Text;
  Form1.Label12.Caption := Edit3.Text;

  Form1.ZapiszUstawienia;

  Form1.Wczytajzapisangr1Click(nil);
  Form1.Repaint;

  Form1.Wyczysc;

  Form3.Close;
end;


procedure TForm3.RadioButton1Click(Sender: TObject);
begin
    if Form3.RadioButton1.Checked then
    image9.Picture := Form2.Mserce.Picture;
    Form1.AtuGry := 0;
    Form2.ZasadyPunktacji;
end;

procedure TForm3.RadioButton2Click(Sender: TObject);
begin
    if Form3.RadioButton2.Checked then
    image9.Picture := Form2.MTrefl.Picture;
    Form1.AtuGry := 1;
    Form2.ZasadyPunktacji;
end;

procedure TForm3.RadioButton3Click(Sender: TObject);
begin
    if Form3.RadioButton3.Checked then
    image10.Picture := Form2.Background.Picture;
    Form1.Tlo := 0;
    Form1.background.Picture.Assign(Form2.Background.Picture);
end;

procedure TForm3.RadioButton4Click(Sender: TObject);
begin
    if Form3.RadioButton4.Checked then
    image10.Picture := Form2.Background1.Picture;
    Form1.Tlo := 1;
    Form1.background.Picture.Assign(Form2.Background1.Picture);
end;

procedure TForm3.RadioButton5Click(Sender: TObject);
begin
    if Form3.RadioButton5.Checked then
    image11.Picture := Form2.Table.Picture;
    Form1.Stol := 0;
    Form1.Table.Picture.Assign(Form2.Table.Picture);
end;

procedure TForm3.RadioButton6Click(Sender: TObject);
begin
    if Form3.RadioButton6.Checked then
    image11.Picture := Form2.Table1.Picture;
    Form1.Stol := 1;
    Form1.Table.Picture.Assign(Form2.Table1.Picture);
end;

procedure TForm3.RadioButton7Click(Sender: TObject);
begin
    if Form3.RadioButton7.Checked then
    image12.Picture := Form2.BackCardbok.Picture;
    Form1.KolorRewers := 0;
end;

procedure TForm3.RadioButton8Click(Sender: TObject);
begin
    if Form3.RadioButton8.Checked then
    image12.Picture := Form2.Back1Bok.Picture;
    Form1.KolorRewers := 1;
end;

end.
