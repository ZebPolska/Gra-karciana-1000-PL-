unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Menus, Math, MMSystem, Unit2;


type

  TForm1 = class(TForm)
    background: TImage;
    Slot1, Slot2, Slot3, Slot4, Slot5, Slot6, Slot7, Slot8, Slot9, Slot10 : TImage;
    LSlot1, LSlot2, LSlot3, LSlot4, LSlot5, LSlot6, LSlot7, LSlot8, LSlot9, LSlot10 : TImage;
    PSlot1, PSlot2, PSlot3, PSlot4, PSlot5, PSlot6, PSlot7, PSlot8, PSlot9, PSlot10 : TImage;
    Karta1, Karta2, Karta3: TImage; //3 miejsca na Karty MUS
    Panel1: TPanel;
    Button1: TButton; // rozdaj
    Button2: TButton; // Licytuj / podbij o 10
    Button3: TButton; // Zatwierdź zmiany/informacje rozpocznij rozgrywkę
    Button4: TButton; // pas
    Button5: TButton; // pojawiający się przycisk,
    Button6: TButton; // ile grasz w rozgrywce po wygranej licytacji
    ComboBox1: TComboBox; // ustaw ile grasz w rozgrywce
    Panel2, Panel3, Panel4: TPanel; //Tabela wyników 2-gracz lewy , 3-gracz, 4-gracz prawy
    Panel5, Panel6: TPanel;
    Label1: TLabel;
    Table: TImage;
    SlotLEW: TImage;
    LSlotLEW: TImage;
    PSlotLEW: TImage;
    Panel7: TPanel;
    Panel11: TPanel;
    MainMenu1: TMainMenu;
    Plik1: TMenuItem;
    Wczytajzapisangr1: TMenuItem;
    Zapiszobecngr1: TMenuItem;
    N1: TMenuItem;
    Zamknijprogram1: TMenuItem;
    Ustawienia1: TMenuItem;
    Punktacjakart1: TMenuItem;
    Oprogramie1: TMenuItem;
    WyborKoloruATU: TMenuItem;
    Nowagra1: TMenuItem;
    N2: TMenuItem;
    Label2: TLabel; // stawka licytacji
    Panel8, Panel9, Panel10: TPanel; //obecna punktacja w rozgrywce: 8-lewy, 9-gracz, 10-prawy
    Panel12: TPanel;
    Meldunek: TImage; //rysunek obecnego meldunku
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    Statystyka1: TMenuItem;
    N3: TMenuItem;
    procedure WyborKoloruATUClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nowagra1Click(Sender: TObject);
    procedure Zapiszobecngr1Click(Sender: TObject);
    procedure Wczytajzapisangr1Click(Sender: TObject);
    procedure Slot1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Slot1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Slot1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Zamknijprogram1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Punktacjakart1Click(Sender: TObject);
    procedure Oprogramie1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Wygrana1Click(Sender: TObject);
    procedure Statystyka1Click(Sender: TObject);
    procedure ZapiszUstawienia;
    procedure Winner1Click(Sender: TObject);
    procedure loser1Click(Sender: TObject);
    procedure ass1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);

  public
    MeldLabel: TLabel;    //animacja meldunku
    MeldTimer: TTimer;    //animacja meldunku
    MeldScale: Double;    //animacja meldunku
    MeldTarget: Integer;  //animacja meldunku
    MeldAlpha: Integer;   //animacja meldunku
    MeldTicks: Integer;   //animacja meldunku
    MeldBaseColor: TColor;//animacja meldunku

    Reka: array[0..9] of Integer; // -1 = pusty slot
    Sloty: array[0..9] of TImage;
    DragIndex: Integer;
    Ghost: TImage;
    Dragging: Boolean;

    AtuGry: Integer;      //Kier lub Trefl
    KolorRewers: Integer; //kolor rewersu talii
    Tlo: Integer;         // 0: Zielone, 1: Niebieskie
    Stol: Integer;        // 0: Zielony, 1: Niebieski

    GraczNaMusie, AktualnyGracz, Licytator, Rozdajacy: Integer;

    Karta: array[0..23] of TImage;    // talia
    KartaBok: array[0..23] of TImage; // talia"bok"
    Talia: array[0..23] of Integer;   // talia + talia"bok" jako jedna talia

    Stawka: Integer;
    Aktywni: array[0..2] of Boolean;
    OstatniGracz: Integer;
    GrabPos: TPoint;
    LastTargetIndex: Integer;

    procedure TablicaKart;
    procedure TasujTalie;

    procedure UstawRozdanie; // KOLEJNOŚĆ ROZDANIA (CYKL)
    procedure NoweRozdanie; // ROTACJA ROZDANIA
    procedure OdswiezReke;
    procedure KompresujReke;
    procedure KompresujRekeAI;
    procedure SwapInt(var A, B: Integer);
    function LiczbaKart: Integer;
    procedure OdswiezAI;
    function NazwaGracza(ID: Integer): string;
    procedure ResetGry;
    procedure Statystyka(Zwyciezca: Integer);
    function SprawdzTalie: Boolean;
    procedure BezpieczneTasowanie;
    procedure Wyczysc;

    procedure MeldTimerTick(Sender: TObject);        //animacja meldunku
    procedure PokazAnimacjeMeldunku(Wartosc: Integer); //animacja meldunku
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit3, Unit4, Unit5, Unit6, Unit8;

procedure TForm1.ass1Click(Sender: TObject);
begin
  Form4.PlayResSound('TAS');
end;

procedure TForm1.BezpieczneTasowanie;
begin
  repeat
    TasujTalie;
  until SprawdzTalie;
end;

function TForm1.SprawdzTalie: Boolean;
var
  Used: array[0..23] of Boolean;
  i, v: Integer;
begin
  FillChar(Used, SizeOf(Used), False);

  Result := True;

  for i := 0 to 23 do
  begin
    v := Talia[i];

    if (v < 0) or (v > 23) then
      Exit(False);

    if Used[v] then
      Exit(False);

    Used[v] := True;
  end;
end;

function TForm1.NazwaGracza(ID: Integer): string;
begin
  case ID of
    0: Result := Form3.Edit2.Text; // User
    1: Result := Form3.Edit1.Text; // Lewy
    2: Result := Form3.Edit3.Text; // Prawy
  else
    Result := 'gracz';
  end;
end;

function PozostaleLevy: Integer;
begin
  Result := Form1.LiczbaKart;
end;

procedure TForm1.TablicaKart;
var
  i: Integer;
begin

  // Larty KARO
  Form2.K9.Tag  := 0; Form2.K10.Tag := 1; Form2.KW.Tag  := 2;
  Form2.KD.Tag  := 3; Form2.KK.Tag  := 4; Form2.KA.Tag  := 5;
  // Larty PIK
  Form2.P9.Tag  := 6; Form2.P10.Tag := 7; Form2.PW.Tag  := 8;
  Form2.PD.Tag  := 9; Form2.PK.Tag  := 10; Form2.PA.Tag := 11;
  // Larty SERCE/KIER
  Form2.S9.Tag  := 12; Form2.S10.Tag := 13; Form2.SW.Tag  := 14;
  Form2.SD.Tag  := 15; Form2.SK.Tag  := 16; Form2.SA.Tag  := 17;
  // Larty TREFL
  Form2.T9.Tag  := 18; Form2.T10.Tag := 19; Form2.TW.Tag  := 20;
  Form2.TD.Tag  := 21; Form2.TK.Tag  := 22; Form2.TA.Tag  := 23;

  // Mapowanie obrazków pionowych Larty KARO
  Karta[0] := Form2.K9;  Karta[1] := Form2.K10; Karta[2] := Form2.KW;
  Karta[3] := Form2.KD;  Karta[4] := Form2.KK;  Karta[5] := Form2.KA;
  // Mapowanie obrazków poziomych Larty PIK
  Karta[6] := Form2.P9;  Karta[7] := Form2.P10; Karta[8] := Form2.PW;
  Karta[9] := Form2.PD;  Karta[10]:= Form2.PK;  Karta[11]:= Form2.PA;
  // Mapowanie obrazków poziomych Larty SERCE/KIER
  Karta[12]:= Form2.S9;  Karta[13]:= Form2.S10; Karta[14]:= Form2.SW;
  Karta[15]:= Form2.SD;  Karta[16]:= Form2.SK;  Karta[17]:= Form2.SA;
  // Mapowanie obrazków poziomych Larty TREFL
  Karta[18]:= Form2.T9;  Karta[19]:= Form2.T10; Karta[20]:= Form2.TW;
  Karta[21]:= Form2.TD;  Karta[22]:= Form2.TK;  Karta[23]:= Form2.TA;

  // Mapowanie obrazków poziomych Larty KARO
  Kartabok[0] := Form2.K9bok;  Kartabok[1] := Form2.K10bok; Kartabok[2] := Form2.KWbok;
  Kartabok[3] := Form2.KDbok;  Kartabok[4] := Form2.KKbok;  Kartabok[5] := Form2.KAbok;
   // Mapowanie obrazków poziomych Larty PIK
  Kartabok[6] := Form2.P9bok;  Kartabok[7] := Form2.P10bok; Kartabok[8] := Form2.PWbok;
  Kartabok[9] := Form2.PDbok;  Kartabok[10]:= Form2.PKbok;  Kartabok[11]:= Form2.PAbok;
  // Mapowanie obrazków poziomych Larty SERCE/KIER
  Kartabok[12]:= Form2.S9bok;  Kartabok[13]:= Form2.S10bok; Kartabok[14]:= Form2.SWbok;
  Kartabok[15]:= Form2.SDbok;  Kartabok[16]:= Form2.SKbok;  Kartabok[17]:= Form2.SAbok;
  // Mapowanie obrazków poziomych Larty TREFL
  Kartabok[18]:= Form2.T9bok;  Kartabok[19]:= Form2.T10bok; Kartabok[20]:= Form2.TWbok;
  Kartabok[21]:= Form2.TDbok;  Kartabok[22]:= Form2.TKbok;  Kartabok[23]:= Form2.TAbok;

    for i := 0 to 23 do
    begin
      Karta[i].Visible := True;
      Kartabok[i].Visible := True;
    end;
end;


procedure TForm1.TasujTalie;
var
  i, j, tmp: Integer;
begin
  for i := 0 to 23 do
    Talia[i] := i;

  Randomize;
  for i := 23 downto 1 do
  begin
    j := Random(i + 1);
    tmp := Talia[i];
    Talia[i] := Talia[j];
    Talia[j] := tmp;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i :integer;
begin

  FillChar(Form4.AIPamiec, SizeOf(Form4.AIPamiec), 0);

  if PozostaleLevy = 0 then
  begin
    Form1.Panel2.Caption := IntToStr(Form4.PunktySuma[1]);
    Form1.Panel3.Caption := IntToStr(Form4.PunktySuma[0]);
    Form1.Panel4.Caption := IntToStr(Form4.PunktySuma[2]);
  end;

  FillChar(Form4.CzyMeldowal, SizeOf(Form4.CzyMeldowal), 0);
  FillChar(Form4.KartyWyszly, SizeOf(Form4.KartyWyszly), 0);
  FillChar(Form4.SumaMeldunkow, SizeOf(Form4.SumaMeldunkow), 0);


  if not Form3.CheckBox1.Checked then
  Form4.PlayResSound('TAS');

  Ustawienia1.Enabled := False;

  // 1. USTALENIE ROTACJI I MUSU

  combobox1.ItemIndex  := 0;

  Label2.Caption := '100';
  GraczNaMusie := (Rozdajacy + 1) mod 3;
  Licytator    := (GraczNaMusie + 1) mod 3;

  AktualnyGracz := Licytator;

  Panel12.Caption := Format('Rozdaje: %s | Mus: %s | Licytuje: %s',
  [ NazwaGracza(Rozdajacy), NazwaGracza(GraczNaMusie), NazwaGracza(Licytator)]);

  // 2. Czyścimy tablice i interfejs
  for i := 0 to 9 do
  begin
    Form4.RekL[i] := -1;
    Form4.RekP[i] := -1;
    Reka[i] := -1;
  end;

  Panel8.Caption := '0';
  Panel9.Caption := '0';
  Panel10.Caption := '0';
  Form4.OddanoL := 0;
  Form4.OddanoP := 0;
  Form4.MoznaRzucac := False;
  Form4.AtuKolor := -1;
  Form4.LiczbaAktywnych := 3;
  Stawka := 100;
  label2.Caption := '100';
  label5.Caption := 'Ilość LEW do końca kolejki : 8';

  Button1.Enabled := False;
  Button2.Enabled := True;
  Button3.Enabled := False;
  Button4.Enabled := True;
  Button6.Enabled := False;
  Combobox1.Enabled := False;
  Form1.CheckBox1.Enabled := True;
  Wyczysc;

  if Ghost = nil then
  begin
    Ghost := TImage.Create(Self);
    Ghost.Parent := Self;
    Ghost.Visible := False;
    Ghost.Transparent := True;
    Ghost.BringToFront;
    Ghost.Stretch := True;
  end;

  for i := 0 to 9 do
  begin
    Sloty[i] := Form1.FindComponent('Slot' + IntToStr(i+1)) as TImage;
    Sloty[i].OnMouseDown := Slot1MouseDown;
    Sloty[i].OnMouseMove := Slot1MouseMove;
    Sloty[i].OnMouseUp   := Slot1MouseUp;
  end;

  TablicaKart;
  BezpieczneTasowanie;

  // 3. ROZDAWANIE KART
  // MUS
  Form4.Mus[0] := Talia[21];
  Form4.Mus[1] := Talia[22];
  Form4.Mus[2] := Talia[23];

  // GRACZ (7 kart)
  for i := 0 to 6 do Reka[i] := Talia[i];

  // LEWY (7 kart)
  for i := 0 to 6 do Form4.RekL[i] := Talia[i+7];

  // PRAWY (7 kart)
  for i := 0 to 6 do Form4.RekP[i] := Talia[i+14];

  // 4. WIZUALIZACJA REWERSÓW AI
  if KolorRewers = 0 then
  begin
    LSlot1.Picture.Assign(Form2.BackCardbok.Picture);
    PSlot1.Picture.Assign(Form2.BackCardbok.Picture);
  end else begin
    LSlot1.Picture.Assign(Form2.Back1Bok.Picture);
    PSlot1.Picture.Assign(Form2.Back1Bok.Picture);
  end;

  // 5. WIZUALIZACJA MUSU (ZAKRYTY/ODKRYTY)
  if CheckBox1.Checked then
  begin
    Karta1.Picture.Assign(Karta[Talia[21]].Picture);
    Karta2.Picture.Assign(Karta[Talia[22]].Picture);
    Karta3.Picture.Assign(Karta[Talia[23]].Picture);
  end else begin
    if KolorRewers = 0 then
    begin
      Karta1.Picture.Assign(Form2.BackCard.Picture);
      Karta2.Picture.Assign(Form2.BackCard.Picture);
      Karta3.Picture.Assign(Form2.BackCard.Picture);
    end else begin
      Karta1.Picture.Assign(Form2.Back1.Picture);
      Karta2.Picture.Assign(Form2.Back1.Picture);
      Karta3.Picture.Assign(Form2.Back1.Picture);
    end;
  end;

  // 6. START LICYTACJI
  Form4.Pasowal[0] := False;
  Form4.Pasowal[1] := False;
  Form4.Pasowal[2] := False;
  Form4.OstatniPodbijajacy := GraczNaMusie;

  Panel12.Caption := 'Na Musie: ' + Form1.NazwaGracza(GraczNaMusie) + '. Licytację rozpoczął: ' + Form1.NazwaGracza(AktualnyGracz);

  OdswiezReke;
  OdswiezAI;
  Form1.Meldunek.Picture.Assign(Form2.MBrak.Picture);

  // WYWOŁANIE PIERWSZEGO RUCHU AI (jeśli licytację zaczyna AI)
  if AktualnyGracz <> 0 then
  begin
    Application.ProcessMessages;
    Sleep(500);
    Form4.LicytacjaAI(AktualnyGracz);
  end;

end;

procedure TForm1.OdswiezReke;
var i: Integer;
    // zmienna lokalna do mapowania
    LSlo: array[0..9] of TImage;
begin
  LSlo[0] := Slot1; LSlo[1] := Slot2; LSlo[2] := Slot3;
  LSlo[3] := Slot4; LSlo[4] := Slot5; LSlo[5] := Slot6;
  LSlo[6] := Slot7; LSlo[7] := Slot8; LSlo[8] := Slot9;
  LSlo[9] := Slot10;

  for i := 0 to 9 do
  begin
    // Sprawdz czy slot w tablicy Reka ma przypisaną kartę
    if (Reka[i] >= 0) and (Reka[i] <= 23) then
    begin
      LSlo[i].Picture.Assign(Karta[Reka[i]].Picture);
      LSlo[i].Visible := True;
    end
    else
    begin
      // Jeśli -1 (pusta karta), czyścimy TImage
      LSlo[i].Picture := nil;
    end;
  end;

  // POPRAWNY Z-ORDER
  for i := 0 to 9 do
    Sloty[i].SendToBack;

  for i := 0 to 9 do
    if Reka[i] <> -1 then
      Sloty[i].BringToFront;

  // Wymuszamy przerysowanie formy, żeby zmiany były widoczne od razu
  Self.Repaint;
end;


procedure TForm1.Oprogramie1Click(Sender: TObject);
begin
  Form6.Show;
end;

procedure TForm1.Punktacjakart1Click(Sender: TObject);
begin
  Form5.Show;
end;

procedure TForm1.KompresujReke;
var i, j: Integer;
begin
  j := 0;
  for i := 0 to 9 do
  begin
    if Reka[i] <> -1 then
    begin
      Reka[j] := Reka[i];
      if j <> i then Reka[i] := -1; // Czyścimy stare miejsce
      Inc(j);
    end;
  end;
  // KRYTYCZNE: Wszystko powyżej j musi być puste (-1)
  for i := j to 9 do Reka[i] := -1;
end;

procedure TForm1.KompresujRekeAI;
var i, j: Integer;
begin
  // LEWY - dopychamy do góry
  j := 0;
  for i := 0 to 9 do
    if Form4.RekL[i] <> -1 then begin
      Form4.RekL[j] := Form4.RekL[i];
      if i <> j then Form4.RekL[i] := -1;
      Inc(j);
    end;
  // PRAWY - TEŻ dopychamy do góry (skoro PSlot1 jest na górze)
  j := 0;
  for i := 0 to 9 do
    if Form4.RekP[i] <> -1 then begin
      Form4.RekP[j] := Form4.RekP[i];
      if i <> j then Form4.RekP[i] := -1;
      Inc(j);
    end;
end;

procedure TForm1.Slot1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;

begin
   if not Form3.CheckBox1.Checked then
   Form4.PlayResSound('UP');



   for i := 9 downto 0 do
    if Sender = Sloty[i] then begin
      if Reka[i] = -1 then Exit;
      DragIndex := i;

      LastTargetIndex := DragIndex;

      Dragging := True;
      GrabPos := Point(X, Y); // Zapamiętujemy offset chwytu

      //Ghost zapamiętuje indeks karty (np. 15 dla Damy Kier)
      Ghost.Tag := Reka[i];

      Ghost.Picture.Assign(Sloty[i].Picture);
      Ghost.SetBounds(Sloty[i].Left, Sloty[i].Top, Sloty[i].Width, Sloty[i].Height);
      Ghost.Visible := True;
      Ghost.BringToFront;
      Sloty[i].Visible := False;
      Break;
    end;
end;

procedure TForm1.Slot1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var p: TPoint;
    i, Best: Integer;
    MD, CD: Integer;
begin
  if not Dragging then Exit;
  GetCursorPos(p);
  p := Self.ScreenToClient(p);
  Ghost.Left := p.X - GrabPos.X;
  Ghost.Top := p.Y - GrabPos.Y;

  // Podświetlanie najbliższej krawędzi (bez błędu BMP)
  Best := -1; MD := 9999;
  for i := 0 to 9 do begin
    CD := Abs(p.X - Sloty[i].Left);
    if CD < MD then begin MD := CD; Best := i; end;
  end;

  if Best <> LastTargetIndex then begin
    LastTargetIndex := Best;
  end;
end;

procedure TForm1.Slot1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
i, TargetIndex, Temp: Integer;
    MinDist, CurDist: Integer;
    p: TPoint;
begin
  if not Dragging then Exit;

  if not Form3.CheckBox1.Checked then
  Form4.PlayResSound('DOWN');

  for i := 0 to 9 do
  Sloty[i].Visible := True;

  GetCursorPos(p);
  // Jeśli trwa faza oddawania (masz 10 kart)
  if LiczbaKart > 8 then
  begin
    if Form4.ProcesOddaniaKarty(p, DragIndex) then
    begin
      Dragging := False;
      Ghost.Visible := False;

      OdswiezReke;
      Exit;
    end;
  end;

  Dragging := False;
  Ghost.Visible := False;

  // Pozycja myszy względem Formy
  GetCursorPos(p);
  p := Self.ScreenToClient(p);

  TargetIndex := 0;
  MinDist := 9999; // Duża liczba na start

  // SZUKAMY NAJBLIŻSZEJ LEWEJ KRAWĘDZI
  for i := 0 to 9 do
  begin
    if Reka[i] = -1 then Continue; // Skipujemy puste sloty

    // Obliczamy odległość kursora (p.X) od lewej krawędzi slotu (Sloty[i].Left)
    CurDist := Abs(p.X - Sloty[i].Left);

    if CurDist < MinDist then
    begin
      MinDist := CurDist;
      TargetIndex := i;
    end;
  end;

  // karty na stół
  if PtInRect(Form1.Table.BoundsRect, p) then
    begin
      if PtInRect(Form1.Table.BoundsRect, p) then
      begin
        if not Form4.MoznaRzucac then
          begin
            Panel12.Caption := 'Nie możesz jeszcze kłaść kart na stół!';
            Ghost.Visible := False;
            Dragging := False;

            for i := 0 to 9 do
            Sloty[i].Visible := True;

            Exit;
          end;

        Form4.RuchGracza(DragIndex);

        Ghost.Visible := False;
        Dragging := False;

        for i := 0 to 9 do
        Sloty[i].Visible := True;

        Exit;
      end;
    end;

  // LOGIKA WSTAWIANIA (Przesuwanie w tablicy)
  if (TargetIndex <> DragIndex) then
  begin
    Temp := Reka[DragIndex];
    if DragIndex < TargetIndex then
      for i := DragIndex to TargetIndex - 1 do Reka[i] := Reka[i + 1]
    else
      for i := DragIndex downto TargetIndex + 1 do Reka[i] := Reka[i - 1];
    Reka[TargetIndex] := Temp;
  end;

  for i := 0 to 9 do Sloty[i].Visible := True;
  OdswiezReke;
  LastTargetIndex := -1;
end;

procedure TForm1.SwapInt(var A, B: Integer);
var tmp: Integer;
begin
  tmp := A;
  A := B;
  B := tmp;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if AktualnyGracz <> 0 then Exit;

  if not Form3.CheckBox1.Checked then
  Form4.PlayResSound('BUTTON');

  Stawka := Stawka + 10;
  Form4.OstatniPodbijajacy := 0; // Teraz TY jesteś liderem licytacji
  Label2.Caption := IntToStr(Stawka);
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(Label2.Caption);
  // Przekaż ruch do następnego gracza
  AktualnyGracz := Form4.NastepnyGracz(AktualnyGracz);
  Form4.LicytacjaAI(AktualnyGracz);

  Form1.CheckBox1.Enabled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if not Form3.CheckBox1.Checked then
  Form4.PlayResSound('BUTTON');

  Form4.MoznaRzucac := True;
  Form1.OdswiezReke;
  // kompresja
  Form1.OdswiezAI;
  SprawdzTalie;

  if not Form4.CzyKazdyMa8Kart then
  begin
    Panel12.Caption := 'Błąd rozdania. Rozdaj ponownie.';
    Button1.Enabled := True;
    Exit;
  end;

  Form4.StartRozgrywki;
  Form1.Button1.Enabled := False;
  Form1.Button2.Enabled := False;
  Form1.Button3.Enabled := False;
  Form1.Button4.Enabled := False;
  Form1.Button6.Enabled := False;
  Form1.Combobox1.Enabled := False;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if AktualnyGracz <> 0 then Exit;

  if not Form3.CheckBox1.Checked then
  Form4.PlayResSound('BUTTON');

  KompresujRekeAI;
  Form4.Pasowal[0] := True;
  Dec(Form4.LiczbaAktywnych);

  Form4.SprawdzKoniecLicytacji;

  Form1.Button1.Enabled := False;
  Form1.Button2.Enabled := False;
  Form1.Button3.Enabled := True;
  Form1.Button4.Enabled := False;
  Form1.Button6.Enabled := False;
  Form1.Combobox1.Enabled := False;
  Form1.CheckBox1.Enabled := False;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin

  Button5.Visible := False;

  Form4.RozstrzygnijLewe;
  Form1.AktualnyGracz := Form4.KolejGracza;
  // następny ruch dopiero po zebraniu lewy
  if Form4.CzyRozgrywkaTrwa then
  begin
    if Form4.KolejGracza <> 0 then
      Form4.RuchAI(Form4.KolejGracza);
  end;

  Label5.Caption := 'Ilość LEW do końca kolejki: ' + IntToStr(PozostaleLevy);

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    if not Form3.CheckBox1.Checked then
    Form4.PlayResSound('BUTTON');

    Label2.Caption := Combobox1.Text;
    Stawka := StrToIntDef(ComboBox1.Text, Stawka);

    Button1.Enabled := False;
    Button2.Enabled := False;
    Button3.Enabled := True;
    Button4.Enabled := False;
    Button6.Enabled := False;
    Combobox1.Enabled := False;

    Button3Click(Sender);
    Form1.Panel12.Caption := 'Rozpocznij grę.';
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  begin
    if Reka[0] = -1 then
    begin
      Panel12.Caption := 'Najpierw rozdaj karty!';
      CheckBox1.Checked := False;
      Exit;
    end;

    OdswiezAI;

  // MUS
    if CheckBox1.Checked then
      begin
        Karta1.Picture.Assign(Karta[Form4.Mus[0]].Picture);
        Karta2.Picture.Assign(Karta[Form4.Mus[1]].Picture);
        Karta3.Picture.Assign(Karta[Form4.Mus[2]].Picture);
      end
        else
      begin
        if KolorRewers = 0 then
          begin
            Karta1.Picture.Assign(Form2.BackCard.Picture);
            Karta2.Picture.Assign(Form2.BackCard.Picture);
            Karta3.Picture.Assign(Form2.BackCard.Picture);
          end
            else
          begin
            Karta1.Picture.Assign(Form2.Back1.Picture);
            Karta2.Picture.Assign(Form2.Back1.Picture);
            Karta3.Picture.Assign(Form2.Back1.Picture);
          end;
      end;
  end;
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    if StrToIntDef(ComboBox1.Text, 0) < StrToIntDef(Label2.Caption, 0)
    then ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(Label2.Caption);
end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ZapiszUstawienia;
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);

var i: Integer;

begin
  Button1.Enabled := False;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button6.Enabled := False;
  Combobox1.Enabled := False;
  Form1.CheckBox1.Enabled := False;

  for i := 0 to 9 do
    Reka[i] := -1;

  Ghost := TImage.Create(Self);
  Ghost.Parent := Self;
  Ghost.Visible := False;
  Ghost.Transparent := True;
  Ghost.Picture.Bitmap.AlphaFormat := afDefined;
  Ghost.Picture.Bitmap.Canvas.Brush.Style := bsClear;
  Ghost.BringToFront;
  Ghost.Stretch := True;

  Sloty[0] := Slot1;
  Sloty[1] := Slot2;
  Sloty[2] := Slot3;
  Sloty[3] := Slot4;
  Sloty[4] := Slot5;
  Sloty[5] := Slot6;
  Sloty[6] := Slot7;
  Sloty[7] := Slot8;
  Sloty[8] := Slot9;
  Sloty[9] := Slot10;

  for i := 0 to 9 do
  begin
    Sloty[i].OnMouseDown := Slot1MouseDown;
    Sloty[i].OnMouseMove := Slot1MouseMove;
    Sloty[i].OnMouseUp   := Slot1MouseUp;
  end;


  MeldLabel := TLabel.Create(Self);

  MeldLabel.Parent := Self; // stół gry

  MeldLabel.Visible := False;
  MeldLabel.Transparent := True;
  MeldLabel.AutoSize := True;

  MeldLabel.Font.Name := 'Arial Black';
  MeldLabel.Font.Style := [fsBold];
  MeldLabel.Font.Color := clYellow;
  MeldLabel.Font.Size := 10;

  MeldTimer := TTimer.Create(Self);
  MeldTimer.Enabled := False;
  MeldTimer.Interval := 15;
  MeldTimer.OnTimer := MeldTimerTick;

end;

procedure TForm1.FormShow(Sender: TObject);
var
  ini: TIniFile;

begin
  try
    Wczytajzapisangr1Click(nil);
  finally
    // wczytane
  end;

  Form1.Label6.Caption := Form3.Edit1.Text;
  Form1.Label7.Caption := Form3.Edit2.Text;
  Form1.Label8.Caption := Form3.Edit3.Text;

  Form1.Label10.Caption := Form3.Edit1.Text;
  Form1.Label11.Caption := Form3.Edit2.Text;
  Form1.Label12.Caption := Form3.Edit3.Text;

  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Settings Game_1000.ini');

  try
    form8.Label8.Caption  := IntToStr(ini.ReadInteger('Statistic', 'Lewy', 0));
    form8.Label12.Caption := IntToStr(ini.ReadInteger('Statistic', 'User', 0));
    form8.Label10.Caption := IntToStr(ini.ReadInteger('Statistic', 'Prawy', 0));
  finally
    ini.Free;
  end;

  Form3.RadioButton1.Checked := AtuGry = 0;
  Form3.RadioButton2.Checked := AtuGry = 1;

  Form3.RadioButton3.Checked := Tlo = 0;
  Form3.RadioButton4.Checked := Tlo = 1;

  Form3.RadioButton5.Checked := Stol = 0;
  Form3.RadioButton6.Checked := Stol = 1;

  Form3.RadioButton7.Checked := KolorRewers = 0;
  Form3.RadioButton8.Checked := KolorRewers = 1;

  Wyczysc;
end;

procedure TForm1.Nowagra1Click(Sender: TObject);
begin
  ResetGry;
  Wyczysc;
  Label2.Caption := '100';
  if Form4.Visible then Form4.Close;
  Form1.CheckBox1.Enabled := False;
end;

procedure TForm1.UstawRozdanie;
begin
  case Rozdajacy of
    0: Licytator := 2; // Gracz → start Prawy
    1: Licytator := 0; // Lewy → start Ty
    2: Licytator := 1; // Prawy → start Lewy
  end;

  Stawka := 100;

  Aktywni[0] := True;
  Aktywni[1] := True;
  Aktywni[2] := True;

  AktualnyGracz := Licytator;
end;

procedure TForm1.NoweRozdanie;
begin
  Rozdajacy := (Rozdajacy + 1) mod 3;
  UstawRozdanie;
end;

procedure TForm1.Wczytajzapisangr1Click(Sender: TObject);
var
  ini: TIniFile;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'Settings Game_1000.ini') then Exit;

  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings Game_1000.ini');
  try
    // 1. ODCZYT CYFR Z PLIKU
    AtuGry      := ini.ReadInteger('Settings', 'Atu', 0);
    KolorRewers := ini.ReadInteger('Settings', 'Revers', 0);
    Tlo         := ini.ReadInteger('Settings', 'Background', 0);
    Stol        := ini.ReadInteger('Settings', 'Table', 0);

    // 2. USTAWIANIE KOLORÓW W FORM3 (Synchronizacja wizualna)

    // Atu (Panel 4/5)
    if AtuGry = 0 then Form3.RadioButton1.Checked else Form3.RadioButton2.Checked;

    // Tło (Panel 7/8)
    if Tlo = 0 then Form3.RadioButton3.Checked else Form3.RadioButton4.Checked;

    // Stół (Panel 10/11)
    if Stol = 0 then Form3.RadioButton5.Checked else Form3.RadioButton6.Checked;

    // Rewers (Panel 13/14)
    if KolorRewers = 0 then Form3.RadioButton7.Checked else Form3.RadioButton8.Checked;

    //Sound
     if ini.ReadInteger('Sound', 'Active', 0) = 0 then
      Form3.CheckBox1.Checked := True
    else
      Form3.CheckBox1.Checked := False;


    // 3. AKTUALIZACJA GRAFIKI W FORM1
    Form2.ZasadyPunktacji;
    Form2.Rewers;

    if Tlo = 0 then background.Picture.Assign(Form2.Background.Picture)
    else background.Picture.Assign(Form2.Background1.Picture);

    if Stol = 0 then Table.Picture.Assign(Form2.Table.Picture)
    else Table.Picture.Assign(Form2.Table1.Picture);

    // Odczyt nazw graczy
    Form3.Edit1.Text := ini.ReadString('Name', 'Lewy', Form3.Edit1.Text);
    Form3.Edit2.Text := ini.ReadString('Name', 'User', Form3.Edit2.Text);
    Form3.Edit3.Text := ini.ReadString('Name', 'Prawy', Form3.Edit3.Text);

  finally
    ini.Free;
  end;
    Wyczysc;
end;

procedure TForm1.Winner1Click(Sender: TObject);
begin
  Form4.PlayResSound('WIN');
end;

procedure TForm1.WyborKoloruATUClick(Sender: TObject);
begin

  Form3.RadioButton1.Checked := Form1.AtuGry = 0;
  Form3.RadioButton2.Checked := Form1.AtuGry = 1;

  // Tło
  Form3.RadioButton3.Checked := Form1.Tlo = 0;
  Form3.RadioButton4.Checked := Form1.Tlo = 1;

  // Stół
  Form3.RadioButton5.Checked := Form1.Stol = 0;
  Form3.RadioButton6.Checked := Form1.Stol = 1;

  // Rewers
  Form3.RadioButton7.Checked := Form1.KolorRewers = 0;
  Form3.RadioButton8.Checked := Form1.KolorRewers = 1;

  Form3.Edit1.Text := Form1.Label10.Caption;
  Form3.Edit2.Text := Form1.Label11.Caption;
  Form3.Edit3.Text := Form1.Label12.Caption;
  Form3.Show;
end;

procedure TForm1.Wygrana1Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.Zamknijprogram1Click(Sender: TObject);
begin
  ZapiszUstawienia;
  Application.Terminate;
end;

procedure TForm1.Zapiszobecngr1Click(Sender: TObject);
begin
 ZapiszUstawienia;
end;

function PointInControl(C: TControl; P: TPoint): Boolean;
var R: TRect;
begin
  R := C.BoundsRect;
  Result := PtInRect(R, P);
end;

function TForm1.LiczbaKart: Integer;
var i, c: Integer;
begin
  c := 0;
  for i := 0 to 9 do if Reka[i] <> -1 then Inc(c);
  Result := c;
end;

procedure TForm1.loser1Click(Sender: TObject);
begin
  Form4.PlayResSound('LOSE');
end;

procedure TForm1.OdswiezAI;
var
  i: Integer;
  ImgL, ImgP: TImage;
begin
  for i := 0 to 9 do
  begin
    ImgL := TImage(FindComponent('LSlot' + IntToStr(i+1)));
    ImgP := TImage(FindComponent('PSlot' + IntToStr(i+1)));

    // --- LEWY AI ---
    if (Form4.RekL[i] <> -1) and (ImgL <> nil) then
    begin
      ImgL.Visible := True;

      // LOGIKA CHECKBOXA
      if CheckBox1.Checked then
        ImgL.Picture.Assign(Kartabok[Form4.RekL[i]].Picture) // ODKRYTE
      else
      begin
        // ZAKRYTE
        if KolorRewers = 0 then ImgL.Picture.Assign(Form2.BackCardbok.Picture)
        else ImgL.Picture.Assign(Form2.Back1Bok.Picture);
      end;
    end
    else if ImgL <> nil then
    begin
      ImgL.Picture := nil;
      ImgL.Visible := False; // Brak dziur w talii
    end;

    // --- PRAWY AI ---
    if (Form4.RekP[i] <> -1) and (ImgP <> nil) then
    begin
      ImgP.Visible := True;

      if CheckBox1.Checked then
        ImgP.Picture.Assign(Kartabok[Form4.RekP[i]].Picture)
      else
      begin
        if KolorRewers = 0 then ImgP.Picture.Assign(Form2.BackCardbok.Picture)
        else ImgP.Picture.Assign(Form2.Back1Bok.Picture);
      end;
    end
    else if ImgP <> nil then
    begin
      ImgP.Picture := nil;
      ImgP.Visible := False;
    end;
  end;
end;

procedure TForm1.ResetGry;
var
  i: Integer;
begin
  // reset tablic
  for i := 0 to 9 do
  begin
    Reka[i] := -1;
    Form4.RekL[i] := -1;
    Form4.RekP[i] := -1;
  end;

  // reset MUS
  for i := 0 to 2 do
    Form4.Mus[i] := -1;

  // reset stanów
  Form4.OddanoL := 0;
  Form4.OddanoP := 0;
  Form4.MoznaRzucac := False;

  Dragging := False;
  DragIndex := -1;
  LastTargetIndex := -1;

  // reset licytacji
  Stawka := 100;
  AktualnyGracz := 0;
  Licytator := 0;

  // reset punktów
  Panel2.Caption := '0';
  Panel3.Caption := '0';
  Panel4.Caption := '0';

  Panel8.Caption := '0';
  Panel9.Caption := '0';
  Panel10.Caption := '0';

  // reset obrazków
  Wyczysc;

  // GUI
  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button5.Visible := False;
  Button6.Enabled := False;

  ComboBox1.Enabled := False;

  Panel12.Caption := 'Rozdaj karty';
  Label5.Caption := 'Ilość LEW do końca kolejki : 8';

  Meldunek.Picture.Assign(Form2.MBrak.Picture);

  Panel2.Caption :='0';
  Panel3.Caption :='0';
  Panel4.Caption :='0';
  Panel8.Caption :='0';
  Panel9.Caption :='0';
  Panel10.Caption :='0';

  Ustawienia1.Enabled := True;

  // RESET PUNKTÓW
  FillChar(Form4.PunktySuma, SizeOf(Form4.PunktySuma), 0);
  FillChar(Form4.PunktyRunda, SizeOf(Form4.PunktyRunda), 0);
  FillChar(Form4.LewyWygrane, SizeOf(Form4.LewyWygrane), 0);

  // RESET STANU ROZGRYWKI
  FillChar(Form4.KartyStol, SizeOf(Form4.KartyStol), $FF);
  FillChar(Form4.KtoRzucil, SizeOf(Form4.KtoRzucil), $FF);
  FillChar(Form4.CzyMeldowal, SizeOf(Form4.CzyMeldowal), 0);

  Form4.NrKartyNaStole := 0;
  Form4.GraczKontraktowy := -1;
  Form4.ZadeklarowanaStawka := 0;
  Form4.AtuKolor := -1;
  Form4.KolorLewy := -1;
  Form4.NajwyzszaKarta := -1;
  Form4.ZwyciezcaLewy := -1;

  Form4.CzyRozgrywkaTrwa := False;

  Rozdajacy := 0;
end;

procedure TForm1.Statystyka(Zwyciezca: Integer);
begin
  case Zwyciezca of
    0:
      Form8.Label12.Caption :=
        IntToStr(StrToIntDef(Form8.Label12.Caption, 0) + 1);
    1:
      Form8.Label8.Caption :=
        IntToStr(StrToIntDef(Form8.Label8.Caption, 0) + 1);

    2:
      Form8.Label10.Caption :=
        IntToStr(StrToIntDef(Form8.Label10.Caption, 0) + 1);
  end;

  ZapiszUstawienia;
end;

procedure TForm1.Statystyka1Click(Sender: TObject);
begin
  Form8.Show;
end;


procedure TForm1.ZapiszUstawienia;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings Game_1000.ini');

  try
    // SETTINGS
    // Atu
    if Form3.RadioButton1.Checked then
      ini.WriteInteger('Settings', 'Atu', 0);

    if Form3.RadioButton2.Checked then
      ini.WriteInteger('Settings', 'Atu', 1);

    // Tło
    if Form3.RadioButton3.Checked then
      ini.WriteInteger('Settings', 'Background', 0);

    if Form3.RadioButton4.Checked then
      ini.WriteInteger('Settings', 'Background', 1);

    // Stół
    if Form3.RadioButton5.Checked then
      ini.WriteInteger('Settings', 'Table', 0);

    if Form3.RadioButton6.Checked then
      ini.WriteInteger('Settings', 'Table', 1);

    // Rewers
    if Form3.RadioButton7.Checked then
      ini.WriteInteger('Settings', 'Revers', 0);

    if Form3.RadioButton8.Checked then
      ini.WriteInteger('Settings', 'Revers', 1);

    // NAME
    if Form3.Edit1.Text <> '' then
      ini.WriteString('Name', 'Lewy', Form3.Edit1.Text)
    else
      ini.WriteString('Name', 'Lewy', 'Gracz z lewej');

    if Form3.Edit2.Text <> '' then
      ini.WriteString('Name', 'User', Form3.Edit2.Text)
    else
      ini.WriteString('Name', 'User', 'User');

    if Form3.Edit3.Text <> '' then
      ini.WriteString('Name', 'Prawy', Form3.Edit3.Text)
    else
      ini.WriteString('Name', 'Prawy', 'Gracz z Prawej');

    // STATISTIC
    ini.WriteInteger('Statistic', 'Lewy',
      StrToIntDef(Form8.Label8.Caption, 0));

    ini.WriteInteger('Statistic', 'User',
      StrToIntDef(Form8.Label12.Caption, 0));

    ini.WriteInteger('Statistic', 'Prawy',
      StrToIntDef(Form8.Label10.Caption, 0));

    //SOUND
    if Form3.CheckBox1.Checked then
      ini.WriteInteger('Sound', 'Active', 0) // Zaznaczone -> 0
    else
      ini.WriteInteger('Sound', 'Active', 1); // Niezaznaczone -> 1

  finally
    ini.Free;
  end;
end;

procedure TForm1.Wyczysc;
var
  i: Integer;
begin
  // 1. Czyszczenie grafiki slotów i kart przeciwników
  for i := 1 to 10 do
  begin
    TImage(FindComponent('Slot' + IntToStr(i))).Picture := nil;
    TImage(FindComponent('LSlot' + IntToStr(i))).Picture := nil;
    TImage(FindComponent('PSlot' + IntToStr(i))).Picture := nil;
  end;

  // 2. Czyszczenie grafiki kart na stole
  for i := 1 to 3 do
    TImage(FindComponent('Karta' + IntToStr(i))).Picture := nil;

  // 3. Czyszczenie grafiki zdobytych lew
  SlotLEW.Picture := nil;
  LSlotLEW.Picture := nil;
  PSlotLEW.Picture := nil;

  // 4. BEZPIECZEŃSTWO: Czyszczenie zmiennych logicznych obecnej lewy w Form4
  Form4.NrKartyNaStole := 0;
  Form4.NajwyzszaKarta := -1;
  Form4.KolorLewy      := -1;
  Form4.ZwyciezcaLewy  := -1;

  // Czyszczenie tablic kart leżących na stole
  FillChar(Form4.KartyStol, SizeOf(Form4.KartyStol), $FF);
  FillChar(Form4.KtoRzucil, SizeOf(Form4.KtoRzucil), $FF);
end;


procedure TForm1.PokazAnimacjeMeldunku(Wartosc: Integer);
begin
  MeldScale := 0.2;

  MeldTicks := 10;
  MeldAlpha := 200;

  MeldLabel.Caption := IntToStr(Wartosc);

  case Wartosc of
    40: MeldBaseColor := clLime;
    60: MeldBaseColor := clLime;
    80: MeldBaseColor := clLime;
    100: MeldBaseColor := clLime;
  else
    MeldBaseColor := clWhite;
  end;

  MeldLabel.Font.Color := MeldBaseColor;

  MeldLabel.Font.Size := 8;

  MeldLabel.Left :=
    Table.Left + (Table.Width div 2) - 40;

  MeldLabel.Top :=
    Table.Top + (Table.Height div 2) - 30;

  MeldLabel.Visible := True;

  MeldTimer.Enabled := True;
end;


procedure TForm1.MeldTimerTick(Sender: TObject);
var
  Size: Integer;
  R, G, B: Byte;
  FadeFactor: Double;
begin
  Inc(MeldTicks);

  // skala
  MeldScale := MeldScale + 0.07;

  Size := Round(8 + (64 * MeldScale));

  MeldLabel.Font.Size := Size;

  // pozycja
  MeldLabel.Left :=
    Table.Left + (Table.Width div 2) - (MeldLabel.Width div 2);

  MeldLabel.Top :=
    Table.Top + (Table.Height div 2) - (MeldLabel.Height div 2);

  // lekki ruch do góry
  if MeldScale > 0.5 then
    MeldLabel.Top := MeldLabel.Top - 1;

  // ===== FADE =====

  // około 3 sekundy przy timerze 15ms
  if MeldTicks > 60 then
  begin
    Dec(MeldAlpha, 3);

    if MeldAlpha < 0 then
      MeldAlpha := 60;

    FadeFactor := MeldAlpha / 150;

    R := Round(GetRValue(ColorToRGB(MeldBaseColor)) * FadeFactor);
    G := Round(GetGValue(ColorToRGB(MeldBaseColor)) * FadeFactor);
    B := Round(GetBValue(ColorToRGB(MeldBaseColor)) * FadeFactor);

    MeldLabel.Font.Color := RGB(R, G, B);
  end;

  // KONIEC
  if MeldTicks >= 50 then
  begin
    MeldTimer.Enabled := False;
    MeldLabel.Visible := False;
  end;
end;


end.
