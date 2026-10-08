unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg, MMSystem;

 type
  TKolorInfo = record
    Asy: Integer;
    Dziesiatki: Integer;
    Krole: Integer;
    Damy: Integer;
    Walety: Integer;
    Dziewiatki: Integer;
    Meldunek: Boolean;
  end;

type
  TForm4 = class(TForm)
    Winner: TImage;
    Wygrana: TLabel;
    Label1: TLabel;
    Tlo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);

 type
  TAIHandMemory = record
    StartHand: array[0..9] of Integer;  // ręka po rozdaniu
    CurrentHand: array[0..9] of Integer;// aktualna ręka
    AsyKolor: array[0..3] of Integer;
    DziesiatkiKolor: array[0..3] of Integer;
    MeldunekKolor: array[0..3] of Boolean;
    LiczbaKartKolor: array[0..3] of Integer;
  end;


  public
  KolejGracza: Integer;
  GraczKontraktowy: Integer;
  ZadeklarowanaStawka: Integer;
  AtuKolor: Integer;
  KartyStol: array[0..2] of Integer;
  KtoRzucil: array[0..2] of Integer;
  PunktyRunda: array[0..2] of Integer;
  PunktySuma: array[0..2] of Integer;
  LewyWygrane: array[0..2] of Integer;
  CzyMeldowal: array[0..2, 0..3] of Boolean;
  NrKartyNaStole: Integer;
  OddanoL, OddanoP: integer;
  MoznaRzucac: Boolean;
  KolorLewy: Integer;
  NajwyzszaKarta: Integer;
  ZwyciezcaLewy: Integer;

  CzyRozgrywkaTrwa: Boolean;
  StatystykiZapisane: Boolean;

  KartyWyszly: array[0..23] of Boolean;
  NajlepszyKolorAI: array[0..2] of Integer;
  PelneMeldunki: Integer;
  SumaMeldunkow: Integer;
  Pasowal: array[0..2] of Boolean;
  LiczbaAktywnych: Integer;
  OstatniPodbijajacy: Integer;
  RekL: array[0..9] of Integer;
  RekP: array[0..9] of Integer;
  Mus: array[0..2] of Integer;
  AIPamiec: array[1..2] of TAIHandMemory;

  function NastepnyGracz(G: Integer): Integer;
  procedure LicytacjaAI(G: Integer);
  procedure SprawdzKoniecLicytacji;
  procedure PrzydzielMusa(Zwyciezca: Integer);
  function CzyKazdyMa8Kart: Boolean;
  procedure OdrzucKartyAI(var R: array of Integer; KtoOddaje: Integer);
  procedure DecyzjaPoMusieAI(G: Integer);
  function ProcesOddaniaKarty(MousePos: TPoint; KartaIdx: Integer): Boolean;

  procedure StartRozgrywki;
  procedure RuchGracza(KartaIdx: Integer);
  procedure RuchAI(G: Integer);
  procedure PolozKarteNaStole(Gracz, Karta: Integer);
  procedure RozstrzygnijLewe;
  function WartoscKarty(K: Integer): Integer;
  function KolorKarty(K: Integer): Integer;
  procedure SprawdzMeldunek(Gracz, Karta: Integer);
  procedure ZakonczRunde;
  function CzyKartaLepsza(Nowa, Stara: Integer): Boolean;
  function CzyRuchLegalny(var R: array of Integer; Karta: Integer): Boolean;
  function CzyMozePrzekroczyc800(G: Integer): Boolean;
  function CzyKoniecRozdania: Boolean;
  function SilaFigury(F: Integer): Integer;
  procedure PlayResSound(const ResName: string);
  function CzyNajwyzszaWKolorze(Karta: Integer): Boolean;
  function PoliczPewneLewy(var R: array of Integer): Integer;
  function WybierzNajlepszyKolor(var R: array of Integer): Integer;
  function ZnajdzNajlepszeWyjscie(var R: array of Integer): Integer;
  procedure AnalizujReke(var R: array of Integer; var Kolory: array of TKolorInfo);
  procedure ZapamietajRekeAI(G: Integer);
  function StrategiaAI(G: Integer; var R: array of Integer): Integer;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

//{$R 'resources.res' 'resources.rc'} //do audio auto-resource

Uses Unit1, Unit2, Unit3, Unit8;

procedure TForm4.PlayResSound(const ResName: string);
begin
  PlaySound(PChar(ResName), HInstance, SND_RESOURCE or SND_ASYNC);
end;

function TForm4.NastepnyGracz(G: Integer): Integer;
begin
  repeat
    G := (G + 1) mod 3;
  until not Pasowal[G];
  Result := G;
end;


procedure TForm4.LicytacjaAI(G: Integer);
var
  Prog, MaxLicytacja: Integer;
  Kolory: array[0..3] of TKolorInfo;
  WartoscMeldunku: Integer;
  AsyWKolorze, DziesiatkiWKolorze: array[0..3] of Integer;
  Kolor, i: Integer;
  Asy, As10, PewneLewy: Integer;
begin
  WartoscMeldunku := 0;
  SumaMeldunkow := 0;
  As10 := 0;
  PewneLewy := 0;

  if Pasowal[G] then
  begin
    SprawdzKoniecLicytacji;
    Exit;
  end;

  //--------------------------------------------------
  // RĘKA + ANALIZA
  //--------------------------------------------------
  if G = 1 then
  begin
    AnalizujReke(RekL, Kolory);
    PewneLewy := PoliczPewneLewy(RekL);
  end
  else if G = 2 then
  begin
    AnalizujReke(RekP, Kolory);
    PewneLewy := PoliczPewneLewy(RekP);
  end;

  //--------------------------------------------------
  // MELDUNKI
  //--------------------------------------------------
  if Form1.AtuGry = 0 then
  begin
    if Kolory[0].Meldunek then begin Inc(WartoscMeldunku,80);  Inc(SumaMeldunkow); end; // Karo
    if Kolory[1].Meldunek then begin Inc(WartoscMeldunku,40);  Inc(SumaMeldunkow); end; // Pik
    if Kolory[2].Meldunek then begin Inc(WartoscMeldunku,100); Inc(SumaMeldunkow); end; // Kier
    if Kolory[3].Meldunek then begin Inc(WartoscMeldunku,60);  Inc(SumaMeldunkow); end; // Trefl
  end
  else
  begin
    if Kolory[0].Meldunek then begin Inc(WartoscMeldunku,40);  Inc(SumaMeldunkow); end; // Karo
    if Kolory[1].Meldunek then begin Inc(WartoscMeldunku,80);  Inc(SumaMeldunkow); end; // Pik
    if Kolory[2].Meldunek then begin Inc(WartoscMeldunku,60);  Inc(SumaMeldunkow); end; // Kier
    if Kolory[3].Meldunek then begin Inc(WartoscMeldunku,100); Inc(SumaMeldunkow); end; // Trefl
  end;

  //--------------------------------------------------
  // ASY / 10
  //--------------------------------------------------
  FillChar(AsyWKolorze, SizeOf(AsyWKolorze), 0);
  FillChar(DziesiatkiWKolorze, SizeOf(DziesiatkiWKolorze), 0);

  if G = 1 then
  begin
    for i := 0 to 9 do
      if RekL[i] <> -1 then
      begin
        Kolor := RekL[i] div 6;
        if (RekL[i] mod 6) = 5 then Inc(AsyWKolorze[Kolor]);
        if (RekL[i] mod 6) = 1 then Inc(DziesiatkiWKolorze[Kolor]);
      end;
  end
  else if G = 2 then
  begin
    for i := 0 to 9 do
      if RekP[i] <> -1 then
      begin
        Kolor := RekP[i] div 6;
        if (RekP[i] mod 6) = 5 then Inc(AsyWKolorze[Kolor]);
        if (RekP[i] mod 6) = 1 then Inc(DziesiatkiWKolorze[Kolor]);
      end;
  end;

  // Zsumowanie Asów do jednej zmiennej
  Asy := AsyWKolorze[0] + AsyWKolorze[1] + AsyWKolorze[2] + AsyWKolorze[3];

  for i := 0 to 3 do
    if (AsyWKolorze[i] > 0) and (DziesiatkiWKolorze[i] > 0) then
      Inc(As10);

  //--------------------------------------------------
  // PROG
  //--------------------------------------------------
  Prog := Form1.Stawka + 10;

  //--------------------------------------------------
  // LOGIKA LICYTACJI
  //--------------------------------------------------

  // SPOSÓB A: GRA BEZ MELDUNKU
  if SumaMeldunkow = 0 then
  begin
    if PewneLewy >= 6 then MaxLicytacja := 120
    else if PewneLewy >= 5 then MaxLicytacja := 110
    else if Asy >= 3 then MaxLicytacja := 100
    else MaxLicytacja := 0;
  end

  // SPOSÓB B: GRA Z MELDUNKAMI
  else
  begin
    if Asy > 0 then
    begin
      // POPRAWKA: Używamy zmiennej 'Asy' zamiast tablicy, co usuwa Hint kompilatora!
       MaxLicytacja := Round((WartoscMeldunku + (Asy * 11) + (As10 * 10)) * 0.7);
    end
    else
    begin
      MaxLicytacja := WartoscMeldunku;
    end;

    if MaxLicytacja < 100 then MaxLicytacja := 100;
  end;

  //--------------------------------------------------
  // HARD LIMIT
  //--------------------------------------------------
  if (Asy = 0) and (SumaMeldunkow = 0) then
    MaxLicytacja := 0;

  //--------------------------------------------------
  // NORMALIZACJA
  //--------------------------------------------------
  MaxLicytacja := (MaxLicytacja div 10) * 10;


   // =========================================================================
  // RĘCZNE STEROWANIE - Z PODZIAŁEM NA LEWEGO (G=1) I PRAWEGO (G=2) BOTA
  // =========================================================================

 // --- RĘCZNE REGUŁY DLA LEWEGO BOTA (G = 1) ---

   //meldunek 100
  if G = 1 then
  begin
    // Sytuacja A: Wariant KIER (AtuGry = 0) to 100 pkt
    if (Form1.AtuGry = 0) and Kolory[2].Meldunek then
    begin
      // 1. Jeśli ma meldunek 100 + AS+10 w tym samym kolorze (Kier)
      if (AsyWKolorze[2] > 0) and (DziesiatkiWKolorze[2] > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      // 2. LUB ma Asa w kolorze meldunku (Kier) + parę AS+10 w jakimkolwiek innym kolorze (As10 > 0)
      else if (AsyWKolorze[2] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      // 3. Warunek bazowy: Po prostu meldunek 100 bez tych super-dodatków -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Sytuacja B: Wariant TREFL (AtuGry = 1) to 100 pkt
    if (Form1.AtuGry = 1) and Kolory[3].Meldunek then
    begin
      // 1. Jeśli ma meldunek 100 + AS+10 w tym samym kolorze (Trefl)
      if (AsyWKolorze[3] > 0) and (DziesiatkiWKolorze[3] > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      // 2. LUB ma Asa w kolorze meldunku (Trefl) + parę AS+10 w jakimkolwiek innym kolorze
      else if (AsyWKolorze[3] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      // 3. Warunek bazowy -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Tutaj będą kolejne reguły dla bota Lewego (G = 1)...
  end

  // --- RĘCZNE REGUŁY DLA PRAWEGO BOTA (G = 2) ---

  else if G = 2 then
  begin
    // Sytuacja A: Wariant KIER (AtuGry = 0) to 100 pkt
    if (Form1.AtuGry = 0) and Kolory[2].Meldunek then
    begin
      if (AsyWKolorze[2] > 0) and (DziesiatkiWKolorze[2] > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      else if (AsyWKolorze[2] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Sytuacja B: Wariant TREFL (AtuGry = 1) to 100 pkt
    if (Form1.AtuGry = 1) and Kolory[3].Meldunek then
    begin
      if (AsyWKolorze[3] > 0) and (DziesiatkiWKolorze[3] > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      else if (AsyWKolorze[3] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 130 then MaxLicytacja := 130;
      end
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Tutaj będą kolejne reguły dla bota Prawego (G = 2)...
  end;



   //meldunek 80
  if G = 1 then
  begin
    // Sytuacja A: Wariant KIER (AtuGry = 0) to 100 pkt
    if (Form1.AtuGry = 0) and Kolory[0].Meldunek then
    begin
      // 1. Jeśli ma meldunek 80 + AS+10 w tym samym kolorze (Kier)
      if (AsyWKolorze[0] > 0) and (DziesiatkiWKolorze[0] > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 2. LUB ma Asa w kolorze meldunku (Kier) + parę AS+10 w jakimkolwiek innym kolorze (As10 > 0)
      else if (AsyWKolorze[0] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 10 then MaxLicytacja := 120;
      end
      // 3. Warunek bazowy: Po prostu meldunek 100 bez tych super-dodatków -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Sytuacja B: Wariant TREFL (AtuGry = 1) to 100 pkt
    if (Form1.AtuGry = 1) and Kolory[1].Meldunek then
    begin
      // 1. Jeśli ma meldunek 80 + AS+10 w tym samym kolorze (Trefl)
      if (AsyWKolorze[1] > 0) and (DziesiatkiWKolorze[1] > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 2. LUB ma Asa w kolorze meldunku (Trefl) + parę AS+10 w jakimkolwiek innym kolorze
      else if (AsyWKolorze[1] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 3. Warunek bazowy -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Tutaj będą kolejne reguły dla bota Lewego (G = 1)...
  end

  // --- RĘCZNE REGUŁY DLA PRAWEGO BOTA (G = 2) ---

  else if G = 2 then
  begin
    // Sytuacja A: Wariant KIER (AtuGry = 0) to 100 pkt
    if (Form1.AtuGry = 0) and Kolory[0].Meldunek then
    begin
      // 1. Jeśli ma meldunek 80 + AS+10 w tym samym kolorze (Kier)
      if (AsyWKolorze[0] > 0) and (DziesiatkiWKolorze[0] > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 2. LUB ma Asa w kolorze meldunku (Kier) + parę AS+10 w jakimkolwiek innym kolorze (As10 > 0)
      else if (AsyWKolorze[0] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 10 then MaxLicytacja := 120;
      end
      // 3. Warunek bazowy: Po prostu meldunek 100 bez tych super-dodatków -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Sytuacja B: Wariant TREFL (AtuGry = 1) to 100 pkt
    if (Form1.AtuGry = 1) and Kolory[1].Meldunek then
    begin
      // 1. Jeśli ma meldunek 80 + AS+10 w tym samym kolorze (Trefl)
      if (AsyWKolorze[1] > 0) and (DziesiatkiWKolorze[1] > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 2. LUB ma Asa w kolorze meldunku (Trefl) + parę AS+10 w jakimkolwiek innym kolorze
      else if (AsyWKolorze[1] > 0) and (As10 > 0) then
      begin
        if MaxLicytacja < 120 then MaxLicytacja := 120;
      end
      // 3. Warunek bazowy -> licytuj do 110
      else
      begin
        if MaxLicytacja < 110 then MaxLicytacja := 110;
      end;
    end;

    // Tutaj będą kolejne reguły dla bota Lewego (G = 1)...
  end;

  //--------------------------------------------------
  // DECYZJA
  //--------------------------------------------------
  if MaxLicytacja >= Prog then
  begin
    Form1.Stawka := Prog;
    OstatniPodbijajacy := G;
    Form1.Label2.Caption := IntToStr(Form1.Stawka);
    Application.ProcessMessages;
    Sleep(100);
  end
  else
  begin
    Pasowal[G] := True;
    Dec(LiczbaAktywnych);
  end;

  SprawdzKoniecLicytacji;
end;


procedure TForm4.SprawdzKoniecLicytacji;
var
  i, wygrany: Integer;
begin
  // 1. Sprawdza czy licytacja jeszcze trwa
  if LiczbaAktywnych > 1 then
  begin
    // Przejście do następnego gracza (jeśli gracz rozdaje, to po kolei: Lewy, Prawy, Gracz...)
    Form1.AktualnyGracz := NastepnyGracz(Form1.AktualnyGracz);

    // Jeśli teraz kolej na AI, wywołujemy ich ruch
    if Form1.AktualnyGracz <> 0 then
    begin
      LicytacjaAI(Form1.AktualnyGracz);
      Exit; // Wychodzimy, czekamy na decyzję AI
    end
    else Exit; // Czekamy na ruch (jeśli teraz kolej gracz)
  end;

  // 2. Jeśli został tylko 1 gracz (LiczbaAktywnych = 1) - KONIEC LICYTACJI
  wygrany := -1;
  for i := 0 to 2 do
    if not Pasowal[i] then
    begin
      wygrany := i;
       break;
    end;

  // Jeśli wszyscy spasowali (nikt nie przebił 100), wygrywa GraczNaMusie
  if wygrany = -1 then wygrany := OstatniPodbijajacy;
  if wygrany = -1 then wygrany := Form1.GraczNaMusie;

  GraczKontraktowy := wygrany;
  ZadeklarowanaStawka := Form1.Stawka;

  // 3. tutaj karty trafiają do zwycięzcy
  PrzydzielMusa(wygrany);

   if wygrany = 0 then
    Form1.Panel12.Caption := 'Karty z Musu są Twoje. Oddaj po jednej karcie przeciwnikom.'
    else
    Form1.Panel12.Caption := 'Licytację wygrał: ' + Form1.NazwaGracza(wygrany) + '. Rozpocznij grę.';
end;


procedure TForm4.PrzydzielMusa(Zwyciezca: Integer);
var
  i, k: Integer;
begin
  // 2. Dodawanie kart Musu do zwycięzcy
  if Zwyciezca = 0 then
  begin
    // Gracz bierze Mus (szukamy wolnych miejsc)
    for i := 0 to 2 do
    begin
      for k := 0 to 9 do
        if Form1.Reka[k] = -1 then
        begin
          Form1.Reka[k] := Mus[i];
          Break;
        end;
    end;

    Form1.Button1.Enabled := False;
    Form1.Button2.Enabled := False;
    Form1.Button3.Enabled := False;
    Form1.Button4.Enabled := False;
    Form1.Button6.Enabled := False;
    Form1.Combobox1.Enabled := False;
    Form1.CheckBox1.Enabled := False;

  end
    else if Zwyciezca = 1 then
  begin
    // Lewy bierze Mus
    for i := 0 to 2 do RekL[7+i] := Mus[i];
    OdrzucKartyAI(RekL, 1); // AI analizuje i oddaje 2 karty
    NajlepszyKolorAI[1] := WybierzNajlepszyKolor(RekL);
    Form1.KompresujRekeAI;
    Form1.OdswiezAI;
    DecyzjaPoMusieAI(1);
  end
    else if Zwyciezca = 2 then
  begin
    // Prawy bierze Mus
     for i := 0 to 2 do RekP[7+i] := Mus[i];
    OdrzucKartyAI(RekP, 2); // AI analizuje i oddaje 2 karty
    NajlepszyKolorAI[2] := WybierzNajlepszyKolor(RekP);
    Form1.KompresujRekeAI;
    Form1.OdswiezAI;
    DecyzjaPoMusieAI(2);
  end;

  //WYCZYŚĆ MUS
  try
    FillChar(Mus, SizeOf(Mus), $FF);
    Form1.Karta1.Picture := nil;
    Form1.Karta2.Picture := nil;
    Form1.Karta3.Picture := nil;

  Except

  end;

  // 3. Synchronizacja stanu
  Form1.OdswiezReke;
  Form1.KompresujRekeAI;
  Form1.OdswiezAI;

  KolejGracza := Zwyciezca;
  Form1.AktualnyGracz := Zwyciezca;
end;

function TForm4.CzyKazdyMa8Kart: Boolean;
var
  i, c: Integer;
begin
  Result := True;

  c := 0;
  for i := 0 to 9 do if Form1.Reka[i] <> -1 then Inc(c);
  if c <> 8 then Result := False;

  c := 0;
  for i := 0 to 9 do if RekL[i] <> -1 then Inc(c);
  if c <> 8 then Result := False;

  c := 0;
  for i := 0 to 9 do if RekP[i] <> -1 then Inc(c);
  if c <> 8 then Result := False;
end;

procedure TForm4.AnalizujReke(var R: array of Integer; var Kolory: array of TKolorInfo);
var
  i, kolor, figura: Integer;
begin
  // POPRAWKA: Czyścimy dokładnie 4 elementy tablicy struktur, zamiast używać wadliwego Size Of
  FillChar(Kolory[0], SizeOf(TKolorInfo) * 4, 0);

  for i := 0 to High(R) do
  begin
    if R[i] = -1 then Continue;

    kolor := R[i] div 6;
    figura := R[i] mod 6;

    case figura of
      5: Inc(Kolory[kolor].Asy);
      4: Inc(Kolory[kolor].Krole);
      3: Inc(Kolory[kolor].Damy);
      2: Inc(Kolory[kolor].Walety);
      1: Inc(Kolory[kolor].Dziesiatki);
      0: Inc(Kolory[kolor].Dziewiatki);
    end;
  end;

  for i := 0 to 3 do
    Kolory[i].Meldunek := (Kolory[i].Krole > 0) and (Kolory[i].Damy > 0);
end;


procedure TForm4.OdrzucKartyAI(var R: array of Integer; KtoOddaje: Integer);
var
  i, przekazano, cel, najlepszaDoOddania, najwyzszaWaga: Integer;
  Wagi: array[0..9] of Integer;  KolorKartyIdx: Integer;
  Kolory: array[0..3] of TKolorInfo;

  procedure WstawDoReki(WartoscKarta: Integer; DoGracza: Integer);
  var
    m: Integer;
  begin
    if DoGracza = 0 then
      for m := 0 to 9 do
        if Form1.Reka[m] = -1 then
        begin
          Form1.Reka[m] := WartoscKarta;
          Break;
        end;

    if DoGracza = 1 then
      for m := 0 to 9 do
        if RekL[m] = -1 then
        begin
          RekL[m] := WartoscKarta;
          Break;
        end;

    if DoGracza = 2 then
      for m := 0 to 9 do
        if RekP[m] = -1 then
        begin
          RekP[m] := WartoscKarta;
          Break;
        end;
  end;

begin
   AnalizujReke(R, Kolory);

// --- SYSTEM ANALIZY I USUWANIA GONGÓW ---
  begin
    var KartyWKolorze: array[0..3] of Integer;

    // Zliczamy ile dokładnie kart mamy w każdym z 4 kolorów na ręce
    for i := 0 to 3 do
    begin
      KartyWKolorze[i] := Kolory[i].Asy + Kolory[i].Dziesiatki + Kolory[i].Krole +
                          Kolory[i].Damy + Kolory[i].Walety + Kolory[i].Dziewiatki;
    end;

    przekazano := 0;

    for i := 0 to 9 do
    begin
      if R[i] = -1 then
      begin
        Wagi[i] := -1000;
        Continue;
      end;

      KolorKartyIdx := R[i] div 6;

      // 1. USTALENIE WAGI BAZOWEJ NA PODSTAWIE DŁUGOŚCI KOLORU

      if KartyWKolorze[KolorKartyIdx] = 1 then
        Wagi[i] := 600  // Samotny gong - idealny do oddania

      else if KartyWKolorze[KolorKartyIdx] = 2 then
        Wagi[i] := 300  // Słaby, krótki kolor

      else
        Wagi[i] := 0;   // Długi kolor - bot chce go zachować

    // 2. MODYFIKACJA WAGI NA PODSTAWIE WARTOŚCI FIGURY

      case (R[i] mod 6) of
        0: Inc(Wagi[i], 100); // 9 - normalnie chętnie odda
        2: Inc(Wagi[i], 70);  // Walet - normalnie chętnie odda
        3: Inc(Wagi[i], 45);  // Dama
        4: Inc(Wagi[i], 45);  // Król
        1: Dec(Wagi[i], 40);  // 10 - bot stara się chronić dychy przed rywalem
        5: Dec(Wagi[i], 280); // As - silna ochrona Asa
      end;

      // nie oddawaj pewnych lew
      if CzyNajwyzszaWKolorze(R[i]) then
        Dec(Wagi[i], 250);

      // chroń układ As + 10
      if (R[i] mod 6 = 5) then // As
      begin
        if Kolory[KolorKartyIdx].Dziesiatki > 0 then
          Dec(Wagi[i], 200);
      end;

      if (R[i] mod 6 = 1) then // 10
      begin
        if Kolory[KolorKartyIdx].Asy > 0 then
          Dec(Wagi[i], 150);
      end;


      // 3. BEZWZGLĘDNA OCHRONA KOLORU ATUTOWEGO (MELDUNKOWEGO)
      if Kolory[KolorKartyIdx].Meldunek then
      begin
        if (R[i] mod 6 = 3) or (R[i] mod 6 = 4) then
          Dec(Wagi[i], 2000); // dama lub król meldunkowy

        if (R[i] mod 6 = 5) then
          Dec(Wagi[i], 1000); // as w meldunku

        if (R[i] mod 6 = 1) then
          Dec(Wagi[i], 700);  // 10 w meldunku
      end;
    end;
  end;

  while przekazano < 2 do
  begin
    najwyzszaWaga := -1001;
    najlepszaDoOddania := -1;

    for i := 0 to 9 do
    begin
      if (R[i] <> -1) and (Wagi[i] > najwyzszaWaga) then
      begin
        najwyzszaWaga := Wagi[i];
        najlepszaDoOddania := i;
      end;
    end;

    if najlepszaDoOddania <> -1 then
    begin
      if przekazano = 0 then
        cel := 0
      else
      begin
        if KtoOddaje = 1 then
          cel := 2
        else
          cel := 1;
      end;

      WstawDoReki(R[najlepszaDoOddania], cel);

      R[najlepszaDoOddania] := -1;
      Wagi[najlepszaDoOddania] := -1000;

      Inc(przekazano);
    end
    else
      Break;
  end;

  Form1.OdswiezReke;
  Form1.OdswiezAI;
end;

procedure TForm4.DecyzjaPoMusieAI(G: Integer);
var
  ostatecznaGra, i, punktyZaKarty: Integer;
  SumaMeldunkow: Integer;
  RealneBity, WartoscMeldunku : Integer;
  Kolory: array[0..3] of TKolorInfo;
begin
  WartoscMeldunku := 0;
  SumaMeldunkow := 0;
  RealneBity := 0;
  punktyZaKarty := 0;

  // 1. ANALIZA RĘKI I MELDUNKÓW
  if G = 1 then AnalizujReke(RekL, Kolory)
  else
  if G = 2 then AnalizujReke(RekP, Kolory);


  if Form1.AtuGry = 0 then
  begin
    if Kolory[0].Meldunek then begin Inc(WartoscMeldunku, 80);  Inc(SumaMeldunkow); end;
    if Kolory[1].Meldunek then begin Inc(WartoscMeldunku, 40);  Inc(SumaMeldunkow); end;
    if Kolory[2].Meldunek then begin Inc(WartoscMeldunku, 100); Inc(SumaMeldunkow); end;
    if Kolory[3].Meldunek then begin Inc(WartoscMeldunku, 60);  Inc(SumaMeldunkow); end;
  end
  else
  begin
    if Kolory[0].Meldunek then begin Inc(WartoscMeldunku, 40);  Inc(SumaMeldunkow); end;
    if Kolory[1].Meldunek then begin Inc(WartoscMeldunku, 80);  Inc(SumaMeldunkow); end;
    if Kolory[2].Meldunek then begin Inc(WartoscMeldunku, 60);  Inc(SumaMeldunkow); end;
    if Kolory[3].Meldunek then begin Inc(WartoscMeldunku, 100); Inc(SumaMeldunkow); end;
  end;

  // 2. LICZENIE PUNKTÓW Z KART
  if G = 1 then
  begin
    for i := 0 to 9 do
    begin
      if RekL[i] <> -1 then
      begin
        case RekL[i] mod 6 of
          5: Inc(punktyZaKarty, 11); // As
          1: Inc(punktyZaKarty, 10); // 10
          4: Inc(punktyZaKarty, 4);  // Król
          3: Inc(punktyZaKarty, 3);  // Dama
          2: Inc(punktyZaKarty, 2);  // Walet
        end;
      end;
    end;
    RealneBity := PoliczPewneLewy(RekL);
  end
  else
  if G = 2 then
  begin
    for i := 0 to 9 do
    begin
      if RekP[i] <> -1 then
      begin
        case RekP[i] mod 6 of
          5: Inc(punktyZaKarty, 11); // As
          1: Inc(punktyZaKarty, 10); // 10
          4: Inc(punktyZaKarty, 4);  // Król
          3: Inc(punktyZaKarty, 3);  // Dama
          2: Inc(punktyZaKarty, 2);  // Walet
        end;
      end;
    end;
    RealneBity := PoliczPewneLewy(RekP);
  end;

 if SumaMeldunkow = 1 then
  begin
    ostatecznaGra := WartoscMeldunku + Round(punktyZaKarty * 0.5) + (RealneBity * 5);
  end
  else if SumaMeldunkow > 1 then
  begin
    // --- INTELIGENTNA ANALIZA I SPECYFICZNA WYCENA TWOJEJ TAKTYKI ---
    var PosiadaneMeldunki: array[0..3] of Integer;
    var LiczbaM: Integer := 0;
    var k, mIdx, temp: Integer;
    var WycenaMeldunkowa: Integer := 0;

    // Lokalna funkcja pomocnicza chroniąca przed ostrzeżeniami W1036
    var PobierzWartoscMeldunku := function(KolorIdx: Integer): Integer
    begin
      Result := 0;
      if Form1.AtuGry = 0 then
      begin
        case KolorIdx of
          0: Result := 80;  // Karo
          1: Result := 40;  // Pik
          2: Result := 100; // Kier
          3: Result := 60;  // Trefl
        end;
      end
      else
      begin
        case KolorIdx of
          0: Result := 40;  // Karo
          1: Result := 80;  // Pik
          2: Result := 60;  // Kier
          3: Result := 100; // Trefl
        end;
      end;
    end;

    // Krok A: Zbieramy indeksy kolorów z meldunkami
    for k := 0 to 3 do
    begin
      if Kolory[k].Meldunek then
      begin
        PosiadaneMeldunki[LiczbaM] := k;
        Inc(LiczbaM);
      end;
    end;

    // Krok B: Sortowanie meldunków od najdroższego do najtańszego
    for k := 0 to LiczbaM - 2 do
    begin
      for mIdx := 0 to LiczbaM - 2 - k do
      begin
        if PobierzWartoscMeldunku(PosiadaneMeldunki[mIdx]) < PobierzWartoscMeldunku(PosiadaneMeldunki[mIdx + 1]) then
        begin
          temp := PosiadaneMeldunki[mIdx];
          PosiadaneMeldunki[mIdx] := PosiadaneMeldunki[mIdx + 1];
          PosiadaneMeldunki[mIdx + 1] := temp;
        end;
      end;
    end;

    // Krok C: Analiza obstawy i wycena z priorytetem wyjścia
    for k := 0 to LiczbaM - 1 do
    begin
      var KolorMeldunku: Integer := PosiadaneMeldunki[k];
      var MaAsa: Boolean := Kolory[KolorMeldunku].Asy > 0;
      var MaDycha: Boolean := Kolory[KolorMeldunku].Dziesiatki > 0;
      var AktualnaWartosc: Integer := PobierzWartoscMeldunku(KolorMeldunku);

      if k = 0 then
      begin
        // Pierwszy meldunek jest bezpieczny, bo AI wychodzi jako pierwsze po wygranej licytacji
        WycenaMeldunkowa := WycenaMeldunkowa + AktualnaWartosc;
      end
      else
      begin
        // Kolejne meldunki zależą od posiadanej obstawy (ponowne przejęcie ruchu):

        // 1. Pełna obstawa (As + 10): Gwarancja odzyskania ruchu w tym kolorze
        if MaAsa and MaDycha then
        begin
          WycenaMeldunkowa := WycenaMeldunkowa + AktualnaWartosc;
        end
        // 2. Sam As: Dobra szansa na przejęcie, ale kolor może być za krótki
        else if MaAsa then
        begin
          WycenaMeldunkowa := WycenaMeldunkowa + Round(AktualnaWartosc * 0.7);
        end
        // 3. Meldunek bez obstawy ("Goły"): Zagrany na końcu, tylko jeśli inne karty dają radę przejąć stół
        else
        begin
          // Wykorzystujemy Twoją zmienną RealneBity wyliczoną przez PoliczPewneLewy
          if RealneBity >= 4 then
            WycenaMeldunkowa := WycenaMeldunkowa + Round(AktualnaWartosc * 0.4)
          else
            WycenaMeldunkowa := WycenaMeldunkowa + 0; // Goły meldunek przy braku bitek przepadnie
        end;
      end;
    end;

    ostatecznaGra := WycenaMeldunkowa + Round(punktyZaKarty * 0.5) + (RealneBity * 5);
  end
  else
  begin
    if RealneBity >= 6 then ostatecznaGra := 120
    else if RealneBity >= 5 then ostatecznaGra := 110
    else ostatecznaGra := 100;
  end;

  // Zaokrąglenie końcowe do pełnych dziesiątek
  ostatecznaGra := (ostatecznaGra div 10) * 10;

  // Bezpiecznik musu (Twój oryginalny kod)
  if ostatecznaGra < Form1.Stawka then ostatecznaGra := Form1.Stawka;

  // 4. WYBÓR ATUTU (Twój oryginalny kod)
  if G = 1 then
    NajlepszyKolorAI[G] := WybierzNajlepszyKolor(RekL)
  else
    if G = 2 then
    NajlepszyKolorAI[G] := WybierzNajlepszyKolor(RekP);

  // Zapis do systemu gry i panelu (Twój oryginalny kod)
  Form1.Stawka := ostatecznaGra;
  ZadeklarowanaStawka := ostatecznaGra;

  Form1.Label2.Caption := IntToStr(Form1.Stawka);
  Form1.ComboBox1.ItemIndex := Form1.ComboBox1.Items.IndexOf(Form1.Label2.Caption);
end;



procedure TForm4.FormCreate(Sender: TObject);
begin
   if Winner.Picture.Graphic is TGIFImage then
    TGIFImage(Winner.Picture.Graphic).Animate := True;
end;

function TForm4.ProcesOddaniaKarty(MousePos: TPoint; KartaIdx: Integer): Boolean;
var
  i, cel: Integer;
  P: TPoint;
  ControlNode: TControl;
begin
  Result := False;
  P := Form1.ScreenToClient(MousePos);
  cel := -1;

  Form1.Ghost.Visible := False;
  Form1.Ghost.Visible := True;

  // LEWY GRACZ
  for i := 1 to 10 do
  begin
    ControlNode := Form1.FindComponent('LSlot' + IntToStr(i)) as TControl;
    if (ControlNode <> nil) and PtInRect(ControlNode.BoundsRect, P) then
    begin
      cel := 1;
      Break;
    end;
  end;

  // PRAWY GRACZ
  if cel = -1 then
  begin
    for i := 1 to 10 do
    begin
      ControlNode := Form1.FindComponent('PSlot' + IntToStr(i)) as TControl;
      if (ControlNode <> nil) and PtInRect(ControlNode.BoundsRect, P) then
      begin
        cel := 2;
        Break;
      end;
    end;
  end;

  if cel <> -1 then
  begin
    // BLOKADA: Sprawdzamy czy już user oddał kartę temu graczowi
    if (cel = 1) and (OddanoL >= 1) then
      begin
        Form1.Panel12.Caption := 'Już oddałeś kartę graczowi: ' + Form1.NazwaGracza(cel);
        Exit(False);
      end;

      if (cel = 2) and (OddanoP >= 1) then
        begin
          Form1.Panel12.Caption := 'Już oddałeś kartę graczowi: ' + Form1.NazwaGracza(cel);
          Exit(False);
        end;

    if cel = 1 then
    begin
      for i := 0 to 9 do
        if RekL[i] = -1 then
        begin
          RekL[i] := Form1.Ghost.Tag;
          Inc(OddanoL); // Liczymy oddaną kartę
          Result := True;
          Form1.Panel12.Caption := 'Oddałeś 1 kartę graczowi: '+ Form1.NazwaGracza(cel); // Twój komunikat
          Break;
        end;
    end
    else
    begin
      for i := 0 to 9 do
        if RekP[i] = -1 then
        begin
          RekP[i] := Form1.Ghost.Tag;
          Inc(OddanoP); // Liczy oddaną kartę
          Result := True;
          Form1.Panel12.Caption := 'Oddałeś 1 kartę graczowi: '+ Form1.NazwaGracza(cel); // Twój komunikat
          Break;
        end;
    end;
  end;

   // ZMIANA W BLOKADZIE STOŁU
  if PtInRect(Form1.Table.BoundsRect, P) then
  begin
    // Nawet jak oddał obie, to dopóki nie kliknie Button3, flaga MożnaRzucać jest False
    if not MoznaRzucac then
    begin
      Form1.Panel12.Caption := 'Nie możesz jeszcze kłaść kart na stół!';
      Result := False;
      Exit;
    end;
  end;

  if Result then
  begin
    Form1.Reka[KartaIdx] := -1;
    Form1.KompresujReke;
    Form1.KompresujRekeAI;
    Form1.OdswiezReke;
    Form1.OdswiezAI; // To narysuje karty "bokiem" i bez dziur w talii

    // SPRAWDZENIE CZY MOŻNA ZACZYNAĆ
    if (OddanoL = 1) and (OddanoP = 1) then
    begin
      Form1.Panel12.Caption := 'Ustal wysokość stawki';

        Form1.Button1.Enabled := False;
        Form1.Button2.Enabled := False;
        Form1.Button3.Enabled := False;
        Form1.Button4.Enabled := False;
        Form1.Button6.Enabled := True;// Odblokowanie Stawki gracza
        Form1.Combobox1.Enabled := True;

    end;

    Form1.Ghost.Visible := False;
    Form1.Dragging := False;
  end;
end;

procedure TForm4.RuchGracza(KartaIdx: Integer);
var
  Karta: Integer;
begin
  if KolejGracza <> 0 then Exit;
  if NrKartyNaStole >= 3 then Exit;

  Karta := Form1.Reka[KartaIdx];

  if not CzyRuchLegalny(Form1.Reka, Karta) then
  begin
    Form1.Panel12.Caption := 'Musisz: dołożyć kolor / przebić / Użyć ATU';
    Exit;
  end;

  PolozKarteNaStole(0, Karta);
  SprawdzMeldunek(0, Karta);

  Form1.Reka[KartaIdx] := -1;
  Form1.KompresujReke;
  Form1.KompresujRekeAI;
  Form1.OdswiezReke;
  Form1.OdswiezAI;

  KolejGracza := (KolejGracza + 1) mod 3;
  Form1.AktualnyGracz := KolejGracza;

  if NrKartyNaStole = 3 then
  begin
    Form1.Button5.Visible := True;
    Form1.Button5.Enabled := True;
    Form1.Panel12.Caption := 'Kliknij przycisk, aby rozpocząć nową kolejkę';
    Exit; // Czeka na gracza
  end;

  if KolejGracza <> 0 then RuchAI(KolejGracza);
end;

procedure TForm4.PolozKarteNaStole(Gracz, Karta: Integer);
begin
  // PIERWSZA karta lewy - sprawdza TYLKO licznik kart na stole
  if (NrKartyNaStole = 0) then
  begin
    KolorLewy := KolorKarty(Karta);
    NajwyzszaKarta := Karta;
    ZwyciezcaLewy := Gracz;
  end
  else
  begin
    if CzyKartaLepsza(Karta, NajwyzszaKarta) then
    begin
      NajwyzszaKarta := Karta;
      ZwyciezcaLewy := Gracz;
    end;
  end;


  KartyStol[NrKartyNaStole] := Karta;
  KtoRzucil[NrKartyNaStole] := Gracz;

  case NrKartyNaStole of
    0: Form1.Karta1.Picture.Assign(Form1.Karta[Karta].Picture);
    1: Form1.Karta2.Picture.Assign(Form1.Karta[Karta].Picture);
    2: Form1.Karta3.Picture.Assign(Form1.Karta[Karta].Picture);
  end;

  Inc(NrKartyNaStole);

  if NrKartyNaStole = 3 then
  begin
    Form1.Button5.Visible := True;
    Form1.Button5.Enabled := True;

    Form1.Panel12.Caption := 'Kliknij przycisk, aby rozpocząć nową kolejkę';
  end;

end;

procedure TForm4.SprawdzMeldunek(Gracz, Karta: Integer);
var
  kolor, figura: Integer;
  i, WartoscMeldunku: Integer;
  MaDame, MaKrola: Boolean;
begin
  if NrKartyNaStole <> 1 then Exit;

  figura := Karta mod 6;
  kolor := Karta div 6;

  if CzyMeldowal[Gracz, kolor] then Exit;


  if (figura <> 3) and (figura <> 4) then Exit;     //dama i król melduje

  MaKrola := False;
  MaDame := False;

  case Gracz of
  0:
    for i := 0 to 9 do
      if (Form1.Reka[i] <> -1) and (Form1.Reka[i] div 6 = kolor) then
      begin
        if Form1.Reka[i] mod 6 = 4 then MaKrola := True;
        if Form1.Reka[i] mod 6 = 3 then MaDame := True;
      end;

  1:
    for i := 0 to 9 do
      if (RekL[i] <> -1) and (RekL[i] div 6 = kolor) then
      begin
        if RekL[i] mod 6 = 4 then MaKrola := True;
        if RekL[i] mod 6 = 3 then MaDame := True;
      end;

  2:
    for i := 0 to 9 do
      if (RekP[i] <> -1) and (RekP[i] div 6 = kolor) then
      begin
        if RekP[i] mod 6 = 4 then MaKrola := True;
        if RekP[i] mod 6 = 3 then MaDame := True;
      end;
  end;

  if not (MaKrola and MaDame) then Exit;

  AtuKolor := kolor;
  CzyMeldowal[Gracz, kolor] := True;

  // DYNAMICZNE USTALANIE WARTOŚCI MELDUNKU
  WartoscMeldunku := 0;

  if Form1.AtuGry = 0 then // Wariant KIER (System 1)
  begin
    case kolor of
      0: WartoscMeldunku := 80;  // Karo
      1: WartoscMeldunku := 40;  // Pik
      2: WartoscMeldunku := 100; // Kier
      3: WartoscMeldunku := 60;  // Trefl
    end;
  end
  else // Wariant TREFL (System 2)
  if Form1.AtuGry = 1 then
  begin
    case kolor of
      0: WartoscMeldunku := 40;  // Karo
      1: WartoscMeldunku := 80;  // Pik
      2: WartoscMeldunku := 60;  // Kier
      3: WartoscMeldunku := 100; // Trefl
    end;
  end;

  Inc(PunktyRunda[Gracz], WartoscMeldunku);

  Form1.PokazAnimacjeMeldunku(WartoscMeldunku);

  // Aktualizacja komunikatów i interfejsu
  Form1.Panel12.Caption := 'Gracz ' + Form1.NazwaGracza(Gracz) + ' zameldował ' + IntToStr(WartoscMeldunku);

  // Odświeżamy panele wyników w Unit1
  Form1.Panel8.Caption := IntToStr(PunktyRunda[1]); // Lewy
  Form1.Panel9.Caption := IntToStr(PunktyRunda[0]); // Ty
  Form1.Panel10.Caption := IntToStr(PunktyRunda[2]); // Prawy

  case kolor of
    0: Form1.Meldunek.Picture.Assign(Form2.MKaro.Picture);
    1: Form1.Meldunek.Picture.Assign(Form2.MPik.Picture);
    2: Form1.Meldunek.Picture.Assign(Form2.Mserce.Picture);
    3: Form1.Meldunek.Picture.Assign(Form2.MTrefl.Picture);
  end;
end;


function TForm4.WartoscKarty(K: Integer): Integer;
begin
  case K mod 6 of
    5: Result := 11;
    1: Result := 10;
    4: Result := 4;
    3: Result := 3;
    2: Result := 2;
  else
    Result := 0;
  end;
end;

function TForm4.SilaFigury(F: Integer): Integer;
begin
  case F of
    0: Result := 1; // 9
    2: Result := 2; // walet
    3: Result := 3; // dama
    4: Result := 4; // król
    1: Result := 5; // 10
    5: Result := 6; // as
  else
    Result := 0;
  end;
end;

procedure TForm4.RozstrzygnijLewe;
var
  i, wygral: Integer;
  SumaPunktow: Integer;
begin
  wygral := ZwyciezcaLewy;

  SumaPunktow := 0;
  for i := 0 to 2 do
    SumaPunktow := SumaPunktow + WartoscKarty(KartyStol[i]);

  for i := 0 to 2 do
    KartyWyszly[KartyStol[i]] := True;

  Inc(PunktyRunda[wygral], SumaPunktow);
  Inc(LewyWygrane[wygral]);

  // przypisuje nową "kartę" do kupki zwycięzcy
  case wygral of
    0: if Form1.KolorRewers = 0 then Form1.SlotLEW.Picture.Assign(Form2.BackCard.Picture)
       else Form1.SlotLEW.Picture.Assign(Form2.Back1.Picture);
    1: if Form1.KolorRewers = 0 then Form1.LSlotLEW.Picture.Assign(Form2.BackCardBok.Picture)
       else Form1.LSlotLEW.Picture.Assign(Form2.Back1Bok.Picture);
    2: if Form1.KolorRewers = 0 then Form1.PSlotLEW.Picture.Assign(Form2.BackCardBok.Picture)
       else Form1.PSlotLEW.Picture.Assign(Form2.Back1Bok.Picture);
  end;

  // Czyści stół (karty rzucone)
  Form1.Karta1.Picture := nil;
  Form1.Karta2.Picture := nil;
  Form1.Karta3.Picture := nil;
  NrKartyNaStole := 0;

  KolorLewy := -1;
  NajwyzszaKarta := -1;
  ZwyciezcaLewy := -1;

  Form1.Button5.Visible := False;

  Form1.Panel8.Caption := IntToStr(PunktyRunda[1]);
  Form1.Panel9.Caption := IntToStr(PunktyRunda[0]);
  Form1.Panel10.Caption := IntToStr(PunktyRunda[2]);

  KolejGracza := wygral;
  Form1.AktualnyGracz := wygral;

  if CzyKoniecRozdania then
    ZakonczRunde
  else
  begin
    Form1.Panel12.Caption := 'Lewę wziął gracz ' + Form1.NazwaGracza(wygral);

    if KolejGracza <> 0 then
    begin
      Application.ProcessMessages;
      Sleep(500);
      RuchAI(KolejGracza);
    end;
  end;
end;


function Zaokraglij10(P: Integer): Integer;
begin
  Result := (P div 10) * 10;
end;

procedure TForm4.ZakonczRunde;
var
  i: Integer;
begin
  for i := 0 to 2 do
    PunktyRunda[i] := Zaokraglij10(PunktyRunda[i]);

  // kontrakt
  if PunktyRunda[GraczKontraktowy] >= ZadeklarowanaStawka then
    Inc(PunktySuma[GraczKontraktowy], ZadeklarowanaStawka)
  else
    Dec(PunktySuma[GraczKontraktowy], ZadeklarowanaStawka);

  // pozostali normalnie
  for i := 0 to 2 do
    if i <> GraczKontraktowy then
      if PunktySuma[i] >= 800 then
      begin
        if CzyMozePrzekroczyc800(i) then
        Inc(PunktySuma[i], PunktyRunda[i]);
      end
      else
        Inc(PunktySuma[i], PunktyRunda[i]);

  Form1.Button1.Enabled := True;
  Form1.Button2.Enabled := False;
  Form1.Button3.Enabled := False;
  Form1.Button4.Enabled := False;
  Form1.Button6.Enabled := False;
  Form1.Combobox1.Enabled := False;

  Form1.Panel12.Caption := 'Koniec rundy. Rozdaj ponownie.';

    for i := 0 to 2 do
    begin
      if PunktySuma[i] >= 1000 then
      begin
          if not StatystykiZapisane then   //Zapis statystyki
          begin
            Form1.Statystyka(i);
            StatystykiZapisane := True;
          end;

          if not Form3.CheckBox1.Checked then
          begin
            if i = 0 then PlayResSound('WIN') else PlayResSound('LOSE');
          end;

          //wygrana gry

          Form1.Panel12.Caption := 'Gracz ' + Form1.NazwaGracza(i) + ' wygrał grę! Gratulacje!';

          Form1.Panel2.Caption := IntToStr(Form4.PunktySuma[1]);
          Form1.Panel3.Caption := IntToStr(Form4.PunktySuma[0]);
          Form1.Panel4.Caption := IntToStr(Form4.PunktySuma[2]);

          Form1.Panel8.Caption := '0';
          Form1.Panel9.Caption := '0';
          Form1.Panel10.Caption := '0';

          Form4.Show;
          Form1.Button1.Enabled := False;
          Form1.Button2.Enabled := False;
          Form1.Button3.Enabled := False;
          Form1.Button4.Enabled := False;
          Form1.Button6.Enabled := False;
          Form1.Combobox1.Enabled := False;
          CzyRozgrywkaTrwa := False;

          Exit;
      end;
    end;

   Form1.NoweRozdanie;
end;

procedure TForm4.StartRozgrywki;
var
  WartoscMeldunkow, SumaMeldunkow: Integer;
begin
  // 1. RESET STOŁU I PARAMETRÓW RUNDY
  FillChar(KartyStol, SizeOf(KartyStol), -1);
  FillChar(KtoRzucil, SizeOf(KtoRzucil), -1);
  FillChar(CzyMeldowal, SizeOf(CzyMeldowal), 0);
  FillChar(PunktyRunda, SizeOf(PunktyRunda), 0);
  FillChar(LewyWygrane, SizeOf(LewyWygrane), 0);
  FillChar(KartyWyszly, SizeOf(KartyWyszly), 0);
  FillChar(SumaMeldunkow, SizeOf(SumaMeldunkow), 0);
  FillChar(WartoscMeldunkow, SizeOf(WartoscMeldunkow), 0);

  ZapamietajRekeAI(1);
  ZapamietajRekeAI(2);

  NrKartyNaStole := 0;
  AtuKolor := -1; // Na początku rundy nie ma atutu
  CzyRozgrywkaTrwa := True;
  StatystykiZapisane := False;

  // 2. USTALENIE KONTRAKTU (Z LICYTACJI)
  ZadeklarowanaStawka := Form1.Stawka;

  // Pierwszą kartę w całej rundzie rzuca ZAWSZE zwycięzca licytacji!
  KolejGracza := GraczKontraktowy;
  Form1.AktualnyGracz := KolejGracza;

  // 4. RESET UI (INTERFEJS)
  Form1.Panel8.Caption := '0';
  Form1.Panel9.Caption := '0';
  Form1.Panel10.Caption := '0';
  Form1.Meldunek.Picture.Assign(Form2.MBrak.Picture);

  Form1.SlotLEW.Picture := nil;
  Form1.LSlotLEW.Picture := nil;
  Form1.PSlotLEW.Picture := nil;

  Form1.Panel12.Caption := 'Rozgrywkę zaczyna: ' + Form1.NazwaGracza(KolejGracza) + '. Stawka: ' + Form1.label2.Caption;

  Application.ProcessMessages;

  // 5. START GRY (OBSŁUGA WYJŚCIA AI)
  if KolejGracza <> 0 then
  begin
    Sleep(800); // Mała pauza dla naturalności
    RuchAI(KolejGracza);
  end;
end;

function TForm4.KolorKarty(K: Integer): Integer;
begin
  Result := K div 6;
end;

procedure TForm4.Label1Click(Sender: TObject);
begin
  Form8.Show;
  Form1.Nowagra1Click(Sender);
  Form4.Close;
end;

procedure TForm4.RuchAI(G: Integer);
var
  i, KartaIdx, WybranaKarta: Integer;
  AktualnaSila, SzukanaSila: Integer;
  karta, IleKartAI: Integer;
  MozeBic: Boolean;
begin
  // 1. BEZPIECZEŃSTWO: Sprawdź ile gracz ma kart
  WybranaKarta := -1;
  SzukanaSila := -1;
  karta := -1;

  IleKartAI := 0;
  for i := 0 to 9 do
  begin
    if (G = 1) and (RekL[i] <> -1) then Inc(IleKartAI);
    if (G = 2) and (RekP[i] <> -1) then Inc(IleKartAI);
  end;

  if IleKartAI = 0 then
  begin
    KolejGracza := (KolejGracza + 1) mod 3;
    if (NrKartyNaStole < 3) and (KolejGracza <> 0) then RuchAI(KolejGracza);
    Exit;
  end;

  KartaIdx := -1;

  // TRYB 1: AI ZACZYNA LEWĘ
  if NrKartyNaStole = 0 then
  begin
      // --- WYWOŁANIE STRATEGII PEWNYCH LEW ---
      if G = 1 then
        KartaIdx := StrategiaAI(1, RekL)
      else
      if G = 2 then
        KartaIdx := StrategiaAI(2, RekP);

      // meldowanie TYLKO wtedy, gdy StrategiaAI nie znalazła pewnej bitki
      if KartaIdx = -1 then
      begin
        // A. Inteligentny meldunek
        for i := 0 to 9 do
        begin
          if G = 1 then WybranaKarta := RekL[i] else
          if G = 2 then WybranaKarta := RekP[i];

          if (WybranaKarta <> -1) and (WybranaKarta mod 6 = 3) then
          begin
            for AktualnaSila := 0 to 9 do
            begin
              if G = 1 then SzukanaSila := RekL[AktualnaSila]
              else if G = 2 then SzukanaSila := RekP[AktualnaSila];

              if (SzukanaSila <> -1) and (KolorKarty(SzukanaSila) = KolorKarty(WybranaKarta))
                 and (SzukanaSila mod 6 = 4) then
              begin
                if KolorKarty(WybranaKarta) <> NajlepszyKolorAI[G] then
                begin
                  KartaIdx := i;
                  Break;
                end;

                // JEŚLI MA ASA W MELDUNKU -> najpierw As
                var MaAs: Boolean := False;
                var AsIdx: Integer := -1;
                var j: Integer;

                for j := 0 to 9 do
                begin
                  if G = 1 then karta := RekL[j] else if G = 2 then karta := RekP[j];

                  if (karta <> -1) and (KolorKarty(karta) = KolorKarty(WybranaKarta))
                     and (karta mod 6 = 5) then
                  begin
                    MaAs := True;
                    AsIdx := j;
                    Break;
                  end;
                end;

                // JEŚLI JUŻ JEST ATU/MELDUNEK NA STOLE TO CHROŃ MELDUNEK
                if AtuKolor <> -1 then KartaIdx := i
                else
                begin
                  if MaAs then KartaIdx := AsIdx else KartaIdx := i;
                end;
                Break;
              end;
            end;
          end;
          if KartaIdx <> -1 then Break;
        end;
      end; // <-- KONIEC BLOKADY STRATEGICZNEJ MELDUNKU

      // B. Atak: Wyjdź najwyższą kartą (Tylko gdy KartaIdx nadal wynosi -1)
      if KartaIdx = -1 then
      begin
        if G = 1 then
          KartaIdx := ZnajdzNajlepszeWyjscie(RekL)
        else
          if G = 2 then
            KartaIdx := ZnajdzNajlepszeWyjscie(RekP);
      end;
  end

  // TRYB 2: AI DOKŁADA (Obrona/Przejmowanie)
  else
  begin
    SzukanaSila := 999;
    for i := 0 to 9 do
    begin
      if G = 1 then WybranaKarta := RekL[i] else if G = 2 then WybranaKarta := RekP[i];

      if WybranaKarta = -1 then Continue;

      MozeBic := False;
      if G = 1 then
      begin
        if CzyRuchLegalny(RekL, WybranaKarta) then MozeBic := True;
      end
      else
      if G = 2 then
      begin
        if CzyRuchLegalny(RekP, WybranaKarta) then MozeBic := True;
      end;

      if MozeBic then
      begin
        if CzyKartaLepsza(WybranaKarta, NajwyzszaKarta) then
        begin
          AktualnaSila := SilaFigury(WybranaKarta mod 6);
          if (KartaIdx = -1) or (AktualnaSila < SzukanaSila) then
          begin
            SzukanaSila := AktualnaSila;
            KartaIdx := i;
          end;
        end;
      end;
    end;

    if KartaIdx = -1 then
    begin
      var NajgorszyWynik: Integer := -999;
      var AktualnyWynik: Integer;

      for i := 0 to 9 do
      begin
        if G = 1 then WybranaKarta := RekL[i] else if G = 2 then WybranaKarta := RekP[i];

        if WybranaKarta = -1 then Continue;

        MozeBic := False;
        if G = 1 then
        begin
          if CzyRuchLegalny(RekL, WybranaKarta) then MozeBic := True;
        end
        else
        if G = 2 then
        begin
          if CzyRuchLegalny(RekP, WybranaKarta) then MozeBic := True;
        end;

        if MozeBic then
        begin
          AktualnyWynik := 10 - SilaFigury(WybranaKarta mod 6);
          if not CzyNajwyzszaWKolorze(WybranaKarta) then Inc(AktualnyWynik, 20);

          if AktualnyWynik > NajgorszyWynik then
          begin
            NajgorszyWynik := AktualnyWynik;
            KartaIdx := i;
          end;
        end;
      end;
    end;

    if KartaIdx = -1 then
    begin
      for i := 0 to 9 do
      begin
        if G = 1 then WybranaKarta := RekL[i] else if G = 2 then WybranaKarta := RekP[i];
        if WybranaKarta = -1 then Continue;

        MozeBic := False;
        if G = 1 then
        begin
          if CzyRuchLegalny(RekL, WybranaKarta) then MozeBic := True;
        end
        else
        if G = 2 then
        begin
          if CzyRuchLegalny(RekP, WybranaKarta) then MozeBic := True;
        end;

        if MozeBic then
        begin
          KartaIdx := i;
          Break;
        end;
      end;
    end;
  end;

  // WYKONANIE RUCHU I KOMPRESJA
  if KartaIdx <> -1 then
  begin
    if G = 1 then WybranaKarta := RekL[KartaIdx] else if G = 2 then WybranaKarta := RekP[KartaIdx];

    AIPamiec[G].CurrentHand[KartaIdx] := -1;

    PolozKarteNaStole(G, WybranaKarta);
    SprawdzMeldunek(G, WybranaKarta);

    if G = 1 then RekL[KartaIdx] := -1 else if G = 2 then RekP[KartaIdx] := -1;

    Form1.KompresujRekeAI;
    Form1.OdswiezAI;
  end;

  KolejGracza := (KolejGracza + 1) mod 3;
  if NrKartyNaStole = 3 then
  begin
    Form1.Button5.Visible := True;
    Form1.Button5.Enabled := True;
    Exit;
  end;

  if KolejGracza <> 0 then RuchAI(KolejGracza);
end;


function TForm4.CzyKartaLepsza(Nowa, Stara: Integer): Boolean;
var
  KolorNowa, KolorStara: Integer;
begin

  KolorNowa := KolorKarty(Nowa);
  KolorStara := KolorKarty(Stara);

  // 1. Obsługa ATUTU (Atu bije wszystko co nie jest wyższym atu)
  if (AtuKolor <> -1) then
  begin
    if (KolorNowa = AtuKolor) and (KolorStara <> AtuKolor) then Exit(True);
    if (KolorNowa <> AtuKolor) and (KolorStara = AtuKolor) then Exit(False);
    if (KolorNowa = AtuKolor) and (KolorStara = AtuKolor) then
      Exit(SilaFigury(Nowa mod 6) > SilaFigury(Stara mod 6));
  end;

  // 2. Jeśli żadna nie jest Atu, sprawdza zgodność z kolorem wyjścia (KolorLewy)
  if (KolorNowa = KolorLewy) and (KolorStara <> KolorLewy) then Exit(True);
  if (KolorNowa <> KolorLewy) and (KolorStara = KolorLewy) then Exit(False);

  // 3. Jeśli obie karty są w tym samym kolorze (i jest to kolor wyjścia)
  if (KolorNowa = KolorStara) and (KolorNowa = KolorLewy) then
    Exit(SilaFigury(Nowa mod 6) > SilaFigury(Stara mod 6));

  // 4. W każdym innym przypadku - nowa nie bije starej
  Result := False;
end;

function TForm4.CzyRuchLegalny(var R: array of Integer; Karta: Integer): Boolean;
var
  i: Integer;
  MaKolor: Boolean;
  MaLepsza: Boolean;
  MaAtu: Boolean;
  MaLepszeAtu: Boolean;
begin
  Result := True;

  if NrKartyNaStole = 0 then
    Exit;

  // MA KOLOR?
  MaKolor := False;

  for i := 0 to High(R) do
    if (R[i] <> -1) and (KolorKarty(R[i]) = KolorLewy) then
    begin
      MaKolor := True;
      Break;
    end;

  if MaKolor then
  begin
    // musi dołożyć kolor
    if KolorKarty(Karta) <> KolorLewy then
      Exit(False);

    // czy ma lepszą?
    MaLepsza := False;

    for i := 0 to High(R) do
      if (R[i] <> -1)
      and (KolorKarty(R[i]) = KolorLewy)
      and CzyKartaLepsza(R[i], NajwyzszaKarta) then
      begin
        MaLepsza := True;
        Break;
      end;

    // jeśli ma lepszą -> musi przebić
    if MaLepsza then
      Exit(CzyKartaLepsza(Karta, NajwyzszaKarta));

    Exit(True);
  end;

  // NIE MA KOLORU -> ATU
  MaAtu := False;

  for i := 0 to High(R) do
    if (R[i] <> -1)
    and (KolorKarty(R[i]) = AtuKolor) then
    begin
      MaAtu := True;
      Break;
    end;

  if MaAtu then
  begin
    // musi rzucić atu
    if KolorKarty(Karta) <> AtuKolor then
      Exit(False);

    // czy może przebić atu?
    MaLepszeAtu := False;

    for i := 0 to High(R) do
      if (R[i] <> -1)
      and (KolorKarty(R[i]) = AtuKolor)
      and CzyKartaLepsza(R[i], NajwyzszaKarta) then
      begin
        MaLepszeAtu := True;
        Break;
      end;

    // jeśli ma lepsze atu -> musi przebić
    if MaLepszeAtu then
      Exit(CzyKartaLepsza(Karta, NajwyzszaKarta));

    Exit(True);
  end;
  Result := True;
end;

function TForm4.CzyMozePrzekroczyc800(G: Integer): Boolean;
begin
  Result :=
    (G = GraczKontraktowy);
end;

function TForm4.CzyKoniecRozdania: Boolean;
var
  i: Integer;
begin
  Result := True;

  for i := 0 to 9 do
  begin
    if Form1.Reka[i] <> -1 then Exit(False);
    if RekL[i] <> -1 then Exit(False);
    if RekP[i] <> -1 then Exit(False);
  end;
end;

function TForm4.CzyNajwyzszaWKolorze(Karta: Integer): Boolean;
var
  i, kolor, sila: Integer;
begin
  Result := True;

  kolor := KolorKarty(Karta);
  sila := SilaFigury(Karta mod 6);

  for i := 0 to 23 do
  begin
    if KartyWyszly[i] then Continue;

    if KolorKarty(i) <> kolor then Continue;

    if SilaFigury(i mod 6) > sila then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TForm4.PoliczPewneLewy(var R: array of Integer): Integer;
var
  k: Integer;
  Kolory: array[0..3] of TKolorInfo;
  LiczbaKartWKolorze: Integer;
begin
  Result := 0;

  // 1. Najpierw wywołujemy funkcję analityczną, aby zapełnić informacje o figurach
  AnalizujReke(R, Kolory);

  // 2. Analizuje każdy z 4 kolorów osobno za pomocą sztywnych warunków if-then (BEZ PĘTLI)
  for k := 0 to 3 do
  begin
    // Zliczamy ile kart w tym konkretnym kolorze ma AI na ręce (na bazie Twojej struktury TKolorInfo)
    LiczbaKartWKolorze := Kolory[k].Asy + Kolory[k].Dziesiatki + Kolory[k].Krole +
                          Kolory[k].Damy + Kolory[k].Walety + Kolory[k].Dziewiatki;

    // --- PRZYPADEK 1: 6 KART W KOLORZE ---
    if LiczbaKartWKolorze = 6 then
    begin
      Inc(Result, 6);
      Continue;
    end;

    // --- PRZYPADEK 2: 5 KART W KOLORZE ---
    if LiczbaKartWKolorze = 5 then
    begin
      // pierwszy przykład: AI ma Asa, Króla, Damę, Waleta i 9 (Brak 10)
      // Przeciwnik ma singlową 10, która musi spaść pod Asa. AI kontroluje kolor w pełni (5 bitek).
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 0) and (Kolory[k].Krole = 1) and
         (Kolory[k].Damy = 1) and (Kolory[k].Walety = 1) and (Kolory[k].Dziewiatki = 1) then
      begin
        Inc(Result, 5);
        Continue;
      end;

      // Każdy inny układ 5 kart z Asem (np. brak Waleta lub 9) - brakująca karta i tak spadnie w 1. lewie pod Asa
      if Kolory[k].Asy = 1 then
      begin
        Inc(Result, 5);
        Continue;
      end;

      // 5 kart, ale brak Asa (Masz 10, K, D, W, 9) - As przeciwnika weźmie 1 lewę, AI bierze 0
      if (Kolory[k].Asy = 0) and (Kolory[k].Dziesiatki = 1) then
      begin
        Inc(Result, 0);
        Continue;
      end;
    end;

    // --- PRZYPADEK 3: 4 KARTY W KOLORZE ---
    if LiczbaKartWKolorze = 4 then
    begin
      // Cztery najwyższe karty: As, 10, Król, Dama - pełna, czysta kontrola i 4 pewne bitki
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 1) and (Kolory[k].Krole = 1) and (Kolory[k].Damy = 1) then
      begin
        Inc(Result, 4);
        Continue;
      end;

      // drugi przykład: AI ma As, K, D, W (brak 10 i 9)
      // Ryzyko złego rozkładu kart 2-0 u jednego gracza. Zakładamy pesymistyczne, bezpieczne 2 lewy.
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 0) and (Kolory[k].Krole = 1) and
         (Kolory[k].Damy = 1) and (Kolory[k].Walety = 1) and (Kolory[k].Dziewiatki = 0) then
      begin
        Inc(Result, 2);
        Continue;
      end;

      // Masz As, 10 i dwie mniejsze karty (np. Walet, 9) - As i 10 gwarantują 2 pewne bitki
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 1) then
      begin
        Inc(Result, 2);
        Continue;
      end;

      // Sytuacja bliźniacza do przykładu nr 2: As, K, D, 9 (brak 10 i Waleta) - bezpieczne 2 lewy
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 0) and (Kolory[k].Krole = 1) and
         (Kolory[k].Damy = 1) and (Kolory[k].Walety = 0) and (Kolory[k].Dziewiatki = 1) then
      begin
        Inc(Result, 2);
        Continue;
      end;
    end;

    // --- PRZYPADEK 4: 3 KARTY W KOLORZE ---
    if LiczbaKartWKolorze = 3 then
    begin
      // Trzy najwyższe: As, 10, Król - 3 pewne lewy
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 1) and (Kolory[k].Krole = 1) then
      begin
        Inc(Result, 3);
        Continue;
      end;

      // Masz As, 10 i jedną małą kartę - zgarniasz 2 pewne lewy (As, 10)
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 1) then
      begin
        Inc(Result, 2);
        Continue;
      end;

      // Masz As, K, D (brak 10) - Dziesiątka przeciwnika zablokuje linię, zgarniasz tylko 1 lewę (Asa)
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 0) and (Kolory[k].Krole = 1) and (Kolory[k].Damy = 1) then
      begin
        Inc(Result, 1);
        Continue;
      end;
    end;

    // --- PRZYPADEK 5: 2 KARTY LUB JEDNA KARTA (Krótkie kolory) ---
    if LiczbaKartWKolorze <= 2 then
    begin
      // Krótki kolor, ale z dwiema najwyższymi kartami: As + 10 - 2 pewne lewy
      if (Kolory[k].Asy = 1) and (Kolory[k].Dziesiatki = 1) then
      begin
        Inc(Result, 2);
        Continue;
      end;

      // Sam As (jako singiel lub z mniejszą kartą bez 10-tki) - zawsze 1 pewna lewa
      if Kolory[k].Asy = 1 then
      begin
        Inc(Result, 1);
        Continue;
      end;
    end;
  end;
end;

function TForm4.WybierzNajlepszyKolor(var R: array of Integer): Integer;
var
  k, i, score: Integer;
  bestScore: Integer;
begin
  Result := 0;
  bestScore := -999;

  for k := 0 to 3 do
  begin
    score := 0;

    for i := 0 to High(R) do
    begin
      if R[i] = -1 then Continue;

      if KolorKarty(R[i]) <> k then Continue;

      case R[i] mod 6 of
        5: Inc(score, 30); // As
        1: Inc(score, 20); // 10
        4: Inc(score, 10); // Król
        3: Inc(score, 8);  // Dama
        2: Inc(score, 2);  // walet
      end;
    end;

    if score > bestScore then
    begin
      bestScore := score;
      Result := k;
    end;
  end;
end;

function TForm4.ZnajdzNajlepszeWyjscie(var R: array of Integer): Integer;
var
  i, bestIdx, bestScore, score, karta: Integer;
begin
  bestIdx := -1;
  bestScore := -999;

  for i := 0 to High(R) do
  begin
    karta := R[i];

    if karta = -1 then Continue;

    score := 0;

    if CzyNajwyzszaWKolorze(karta) then
      Inc(score, 100);

    case karta mod 6 of
      5: Inc(score, 50);
      1: Inc(score, 40);
      4: Inc(score, 20);
      3: Inc(score, 15);
    end;

    // każda karta, która pasuje do "najlepszego koloru" AI, dostanie +30 do wagi
    if KolorKarty(karta) = NajlepszyKolorAI[KolejGracza] then
      Inc(score, 30);

    // Ocena końcowa karty na tym indeksie
    if score > bestScore then
    begin
      bestScore := score;
      bestIdx := i;
    end;
  end;

  Result := bestIdx;
end;

procedure TForm4.ZapamietajRekeAI(G: Integer);
var
  i, kolor: Integer;
  Karta: Integer;
  LokalneKolory: array[0..3] of TKolorInfo;
begin
  // Zabezpieczenie: Funkcja przetwarza dane TYLKO dla AI 1 i 2
  if (G <> 1) and (G <> 2) then Exit;

  FillChar(AIPamiec[G], SizeOf(AIPamiec[G]), 0);

  // 1. Pętla zliczania figur (Asy i Dziesiątki)
  for i := 0 to 9 do
  begin
    Karta := -1;

      if G = 1 then Karta := RekL[i]
    else
      if G = 2 then Karta := RekP[i];

    AIPamiec[G].StartHand[i] := Karta;
    AIPamiec[G].CurrentHand[i] := Karta;

    if Karta = -1 then
      Continue;

    kolor := Karta div 6;
    Inc(AIPamiec[G].LiczbaKartKolor[kolor]);

    case Karta mod 6 of
      5:
        Inc(AIPamiec[G].AsyKolor[kolor]);
      1:
        Inc(AIPamiec[G].DziesiatkiKolor[kolor]);
    end;
  end;

  // 2. ROZRÓŻNIENIE DLA PEWNEGO OŻYWIENIA MELDUNEKKOLOR
  if G = 1 then
    AnalizujReke(RekL, LokalneKolory)
  else
    if G = 2 then
      AnalizujReke(RekP, LokalneKolory);

  // Przepisujemy wykryte meldunki do trwałej pamięci właściwego AIPamiec
  for kolor := 0 to 3 do
  begin
    AIPamiec[G].MeldunekKolor[kolor] := LokalneKolory[kolor].Meldunek;
  end;
end;


function TForm4.StrategiaAI(G: Integer; var R: array of Integer): Integer;
var
  i, j, cKolor: Integer;
  WybranaKarta, SzukanaSila: Integer;
  MeldunkoweKolory: array[0..3] of Boolean;
  LiczbaPewnych: Integer;
  AtuIstnieje: Boolean;
  PewnyAsIdx, Pewna10Idx, DowolnyPewniakIdx: Integer;
begin
  Result := -1; // Domyślnie: brak ingerencji strategii

  // 1. Sprawdzamy czy na stole jest już aktywny atu
  AtuIstnieje := False;
  for i := 0 to 2 do
  begin
    for j := 0 to 3 do
    begin
      if CzyMeldowal[i, j] then
      begin
        AtuIstnieje := True;
        Break;
      end;
    end;
    if AtuIstnieje then Break;
  end;

  // 2. Pobieramy aktualną liczbę pewnych bitek
  LiczbaPewnych := PoliczPewneLewy(R);

  // 3. Mapujemy kolory meldunkowe na ręce AI
  FillChar(MeldunkoweKolory, SizeOf(MeldunkoweKolory), 0);
  for i := 0 to High(R) do
  begin
    WybranaKarta := R[i];
    if (WybranaKarta <> -1) and (WybranaKarta mod 6 = 3) then // Dama
    begin
      for j := 0 to High(R) do
      begin
        SzukanaSila := R[j];
        if (SzukanaSila <> -1) and (KolorKarty(SzukanaSila) = KolorKarty(WybranaKarta))
           and (SzukanaSila mod 6 = 4) then // Król
          begin
            MeldunkoweKolory[KolorKarty(WybranaKarta)] := True;
          end;
      end;
    end;
  end;

  // --- RDZEŃ LOGIKI: NAJPIERW WSZYSTKIE PEWNE LEWY ---

  // Jeśli funkcja PoliczPewneLewy mówi, że AI ma chociaż 1 pewną kartę na ręce,
  // to BEZWZGLĘDNIE musimy ją teraz znaleźć i rzucić na stół, blokując meldunek!
  if LiczbaPewnych > 0 then
  begin
    PewnyAsIdx := -1;
    Pewna10Idx := -1;
    DowolnyPewniakIdx := -1;

    // Przeszukujemy rękę w poszukiwaniu kart, które są aktualnie najwyższe w swoim kolorze
    for i := 0 to High(R) do
    begin
      WybranaKarta := R[i];
      if WybranaKarta = -1 then Continue;

      // Sprawdzamy funkcją, czy ta karta na 100% weźmie lewę
      if CzyNajwyzszaWKolorze(WybranaKarta) then
      begin
        cKolor := KolorKarty(WybranaKarta);

        // PRIORYTET 1: Ściągamy pewne Asy (figura 5) poza kolorem meldunku,
        // żeby nie niszczyć sobie struktury meldunku, dopóki mamy inne pewniaki.
        if (WybranaKarta mod 6 = 5) and (not MeldunkoweKolory[cKolor]) then
        begin
          PewnyAsIdx := i;
          Break; // Znaleźliśmy idealną kartę, przerywamy szukanie
        end;

        // PRIORYTET 2: Jeśli nie ma bocznego Asa, szukamy pewnej 10-tki (figura 1) poza meldunkiem
        if (WybranaKarta mod 6 = 1) and (not MeldunkoweKolory[cKolor]) and (Pewna10Idx = -1) then
        begin
          Pewna10Idx := i;
        end;

        // PRIORYTET 3: Jeśli nie ma nic..., zapamiętujemy jakikolwiek inny pewniak
        // (np. As w kolorze meldunku lub awansowany Król/Dama)
        if DowolnyPewniakIdx = -1 then
        begin
          DowolnyPewniakIdx := i;
        end;
      end;
    end;

    // Decyzja o zwrocie indeksu karty (bezwzględne ściąganie bitek przed meldunkiem)
    if PewnyAsIdx <> -1 then
    begin
      Result := PewnyAsIdx;
      Exit;
    end
    else if Pewna10Idx <> -1 then
    begin
      Result := Pewna10Idx;
      Exit;
    end
    else if DowolnyPewniakIdx <> -1 then
    begin
      Result := DowolnyPewniakIdx;
      Exit;
    end;
  end;

end;


end.
