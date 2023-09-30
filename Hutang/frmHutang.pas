unit frmHutang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzLabel, ExtDlgs, JPEG,
  PDJDBGridex, ComCtrls, RzDTP;

type
  TfrmHtg = class(TForm)
    PanelPtg: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel1: TRzPanel;
    HtgBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    HtgBtnBack: TAdvSmoothButton;
    RzLabel3: TRzLabel;
    PaymentdetDBGrid: TPDJDBGridEx;
    BuyPaymentDBGrid: TPDJDBGridEx;
    RzLabel242: TRzLabel;
    htgcbxkodesupp: TRzComboBox;
    htgcbxnamasupp: TRzComboBox;
    RzPanel3: TRzPanel;
    RzLabel1: TRzLabel;
    HtgTxtTglAwal: TRzDateTimePicker;
    RzLabel87: TRzLabel;
    HtgTxtTglAkhir: TRzDateTimePicker;
    procedure FormActivate(Sender: TObject);
    procedure HtgBtnDelClick(Sender: TObject);
    procedure HtgBtnBackClick(Sender: TObject);
    procedure htgcbxkodesuppChange(Sender: TObject);
    procedure htgcbxnamasuppChange(Sender: TObject);
    procedure HtgTxtTglAwalChange(Sender: TObject);
  private
    { Private declarations }
    procedure Htgdisplayfaktur;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  frmHtg: TfrmHtg;

implementation

uses hutangmaster, SparePartFunction, Data, DB, dateutils;

{$R *.dfm}

procedure TfrmHtg.Htgdisplayfaktur;
begin
  with DataModule1.ZQryBuyPayment do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,concat("[",kodesupplier,"] ",supplier) kodenmsupp from buypayment ');
    SQL.Add('where isposted=1 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = "' + htgcbxkodesupp.Text + '" ');
    SQL.Add('and tanggal between "' + FormatDateTime('yyyy-MM-dd',HtgTxtTglAwal.Date) + '" and "' + FormatDateTime('yyyy-MM-dd',HtgTxtTglAkhir.Date) + '" ');
    SQL.Add('order by tanggalinput,waktu,faktur');
    Open;
  end;

  DataModule1.ZQryBuyPaymentdet.DataSource := DataModule1.DSBuyPayment;
  DataModule1.ZQryBuyPaymentdet.Close;
  DataModule1.ZQryBuyPaymentdet.Open;

end;

procedure TfrmHtg.FormActivate(Sender: TObject);
begin
//  frmHtg.Top := frMain.PanelHutang.Top + 26;
//  frmHtg.Height := frMain.PanelHutang.Height;
//  frmHtg.Width := frMain.PanelHutang.Width;
//  frmHtg.Left := 1;
end;

procedure TfrmHtg.HtgBtnDelClick(Sender: TObject);
begin
 if DataModule1.ZQryBuyPayment.IsEmpty then exit;

 if htgcbxkodesupp.ItemIndex<=0 then
 begin
  ErrorDialog('Pilih Salah Satu Supplier dahulu!');
  exit;
 end;

 if dateof(DataModule1.ZQryBuyPaymentTanggal.value)<dateof(now) then
 begin
  ErrorDialog('Pembayaran Hutang kemarin tidak dapat dihapus/batalkan!');
  exit;
 end
 else
 begin
  DataModule1.ZQryBuyPayment.Next;
  if DataModule1.ZQryBuyPayment.eof=false then
  begin
   DataModule1.ZQryBuyPayment.Prior;
   ErrorDialog('Pembatalan Pembayaran Hutang hanya dapat dilakukan mulai dari Pembayaran Terakhir !');
   exit;
  end;
  DataModule1.ZQryBuyPayment.Last;
 end;

 if QuestionDialog('Hapus Pembayaran Faktur dengan No. TT ' + DataModule1.ZQryBuyPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQryBuyPaymentTanggal.Value) + ' ?') = False then Exit;

 LogInfo(UserName,'Menghapus Pembayaran Faktur Beli dengan No. TT ' + DataModule1.ZQryBuyPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQryBuyPaymentTanggal.Value));
 DataModule1.ZConnection1.ExecuteDirect('update buymaster s,operasional o set s.lunas=if(s.grandtotal<=(s.totalpayment-o.kredit),1,0),s.totalpayment=s.totalpayment-o.kredit where o.fakturpay="'+DataModule1.ZQryBuyPaymentfaktur.Value+'" and s.faktur=o.faktur');
 DataModule1.ZConnection1.ExecuteDirect('update returbelimaster set lunas=0 where faktur in (select faktur from operasional where kredit=0 and fakturpay="'+DataModule1.ZQryBuyPaymentfaktur.Value+'") ');
 DataModule1.ZConnection1.ExecuteDirect('delete from operasional where fakturpay="'+DataModule1.ZQryBuyPaymentfaktur.Value+'"');
 DataModule1.ZConnection1.ExecuteDirect('delete from buypayment where faktur="'+DataModule1.ZQryBuyPaymentfaktur.Value+'"');
 InfoDialog('Pembayaran Faktur dengan No. TT ' + DataModule1.ZQryBuyPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQryBuyPaymentTanggal.Value) + ' berhasil dihapus !');

 Htgdisplayfaktur;
 DataModule1.ZQryBuyPayment.Last;
end;

procedure TfrmHtg.FormShowFirst;
begin
  FillComboBox('kode','supplier',htgcbxkodesupp,false,'kode',true);
  FillComboBox('nama','supplier',htgcbxnamasupp,false,'kode',true);
  HtgTxtTglAwal.date  := dateof(startofthemonth(now));
  HtgTxtTglAkhir.date := dateof(now);

  htgcbxkodesupp.ItemIndex := Frmhutangmaster.htgcbxkodesupp.ItemIndex;
  htgcbxkodesuppchange(htgcbxkodesupp);
end;

procedure TfrmHtg.HtgBtnBackClick(Sender: TObject);
begin
 close;
end;

procedure TfrmHtg.htgcbxkodesuppChange(Sender: TObject);
begin
 htgcbxnamasupp.ItemIndex := htgcbxkodesupp.ItemIndex;

 Htgdisplayfaktur;
end;

procedure TfrmHtg.htgcbxnamasuppChange(Sender: TObject);
begin
 htgcbxkodesupp.ItemIndex := htgcbxnamasupp.ItemIndex;

 Htgdisplayfaktur;
end;

procedure TfrmHtg.HtgTxtTglAwalChange(Sender: TObject);
begin
 Htgdisplayfaktur;
end;

end.
