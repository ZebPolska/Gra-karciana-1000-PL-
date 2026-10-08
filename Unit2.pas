unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TForm2 = class(TForm)

    K9bok, K10bok, KWbok, KDbok, KKbok, KAbok: TImage; // poziomo talia: Karo 8,10,W,D,K,A
    P9bok, P10bok, PWbok, PDbok, PKbok, PAbok: TImage; // poziomo talia: Pik 8,10,W,D,K,A
    S9bok, S10bok, SWbok, SDbok, SKbok, SAbok: TImage; // poziomo talia: Serce 8,10,W,D,K,A
    T9bok, T10bok, TWbok, TDbok, TKbok, TAbok: TImage; // poziomo talia: Trefl 8,10,W,D,K,A
    BackCardbok, Back1Bok: TImage; //poziomo talia: back 2 warianty

    K9, K10, KW, KD, KK, KA: TImage;  // pionowo talia: Karo 8,10,W,D,K,A
    P9, P10, PW, PD, PK, PA: TImage;  // pionowo talia: Pik 8,10,W,D,K,A
    S9, S10, SW, SD, SK, SA: TImage;  // pionowo talia: Serce 8,10,W,D,K,A
    T9, T10, TW, TD, TK, TA: TImage;  // pionowo talia: Trefl 8,10,W,D,K,A
    BackCard, Back1: TImage; //pionowo talia: back 2 warianty

    MKaro, MPik, Mserce, Mtrefl, Mbrak: TImage;  // obrazki meldunków

    Table, Table1: TImage;  //stó³ 2 warianty
    Background, Background1: TImage;  // tapeta 2 warianty

  private
    // Unit 2 magazyn kart
  public
    Meldunki: array[0..3] of Integer;
    procedure Rewers;
    procedure ZasadyPunktacji;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
Uses Unit1, Unit3;

procedure TForm2.Rewers;
begin
  if Form1.KolorRewers = 0 then
  begin
    // REWERSY NIEBIESKIE
    // Gracz (PIONOWE 1-10)
    Form1.Slot1.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot2.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot3.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot4.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot5.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot6.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot7.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot8.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot9.Picture.Assign(Form2.BackCard.Picture);
    Form1.Slot10.Picture.Assign(Form2.BackCard.Picture);

    // Mus (PIONOWE)
    Form1.Karta1.Picture.Assign(Form2.BackCard.Picture);
    Form1.Karta2.Picture.Assign(Form2.BackCard.Picture);
    Form1.Karta3.Picture.Assign(Form2.BackCard.Picture);

    // Miejsce na lewy (PIONOWE)
    Form1.SlotLEW.Picture.Assign(Form2.BackCard.Picture);

    // Lewy przeciwnik (POZIOME "BOK" 1-10)
    Form1.LSlot1.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot2.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot3.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot4.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot5.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot6.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot7.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot8.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot9.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.LSlot10.Picture.Assign(Form2.BackCardbok.Picture);

    // Prawy przeciwnik (POZIOME "BOK" 1-10)
    Form1.PSlot1.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot2.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot3.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot4.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot5.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot6.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot7.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot8.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot9.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlot10.Picture.Assign(Form2.BackCardbok.Picture);

    // Miejsca na lewy przeciwników (POZIOME "BOK")
    Form1.LSlotLEW.Picture.Assign(Form2.BackCardbok.Picture);
    Form1.PSlotLEW.Picture.Assign(Form2.BackCardbok.Picture);
  end
  else
  begin
    // REWERSY BR¥ZOWE
    // Gracz (PIONOWE 1-10)
    Form1.Slot1.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot2.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot3.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot4.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot5.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot6.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot7.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot8.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot9.Picture.Assign(Form2.Back1.Picture);
    Form1.Slot10.Picture.Assign(Form2.Back1.Picture);

    // Mus (PIONOWE)
    Form1.Karta1.Picture.Assign(Form2.Back1.Picture);
    Form1.Karta2.Picture.Assign(Form2.Back1.Picture);
    Form1.Karta3.Picture.Assign(Form2.Back1.Picture);

    // Miejsce na lewy (PIONOWE)
    Form1.SlotLEW.Picture.Assign(Form2.Back1.Picture);

    // Lewy przeciwnik (POZIOME "BOK" 1-10)
    Form1.LSlot1.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot2.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot3.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot4.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot5.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot6.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot7.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot8.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot9.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.LSlot10.Picture.Assign(Form2.Back1Bok.Picture);

    // Prawy przeciwnik (POZIOME "BOK" 1-10)
    Form1.PSlot1.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot2.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot3.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot4.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot5.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot6.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot7.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot8.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot9.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlot10.Picture.Assign(Form2.Back1Bok.Picture);

    // Miejsca na lewy przeciwników (POZIOME "BOK")
    Form1.LSlotLEW.Picture.Assign(Form2.Back1Bok.Picture);
    Form1.PSlotLEW.Picture.Assign(Form2.Back1Bok.Picture);
  end;

  Form1.Repaint;
end;


procedure TForm2.ZasadyPunktacji;
begin
  if Form1.AtuGry = 1 then
  begin
    // JEŒLI TREFL (GlowneAtu = 1): Trefl: 100, Pik: 80, Kier: 60, Karo: 40
    Meldunki[0] := 40;  // Karo
    Meldunki[1] := 80;  // Pik
    Meldunki[2] := 60;  // Kier
    Meldunki[3] := 100; // Trefl
  end
  else
  begin
    // JEŒLI KIER (GlowneAtu = 0): Kier: 100, Karo: 80, Trefl: 60, Pik: 40
    Meldunki[0] := 80;  // Karo
    Meldunki[1] := 40;  // Pik
    Meldunki[2] := 100; // Kier
    Meldunki[3] := 60;  // Trefl
  end;
end;
end.
