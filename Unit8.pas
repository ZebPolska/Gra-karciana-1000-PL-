unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles;

type
  TForm8 = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label11: TLabel;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

Uses Unit1;

procedure TForm8.Button1Click(Sender: TObject);
begin
  Form8.Close;
end;

procedure TForm8.Button2Click(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Settings Game_1000.ini');
  try
    ini.WriteInteger('Statistic', 'Lewy', 0);
    ini.WriteInteger('Statistic', 'User', 0);
    ini.WriteInteger('Statistic', 'Prawy', 0);
  finally
    ini.Free;
  end;

  Form8.label8.Caption := '0';
  Form8.label10.Caption := '0';
  Form8.label12.Caption := '0';

  ShowMessage('Statystyki w pliku wyczyszczone.');
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  label1.Caption := Form1.label10.Caption; // GraczL
  label3.Caption := Form1.label12.Caption; // GraczP
  label9.Caption := Form1.label11.Caption; // User
end;

end.
