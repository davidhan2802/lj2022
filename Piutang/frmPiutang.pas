unit frmPiutang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzLabel, ExtDlgs, JPEG,
  PDJDBGridex, ComCtrls, RzDTP, DB, dateutils;

type
  TfrmPtg = class(TForm)
    PanelPtg: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel1: TRzPanel;
    PtgBtnBack: TAdvSmoothButton;
    RzLabel3: TRzLabel;
    PaymentdetDBGrid: TPDJDBGridEx;
    SellPaymentDBGrid: TPDJDBGridEx;
    RzLabel242: TRzLabel;
    ptgcbxkodecust: TRzComboBox;
    ptgcbxnamacust: TRzComboBox;
    RzPanel3: TRzPanel;
    RzLabel1: TRzLabel;
    PtgTxtTglAwal: TRzDateTimePicker;
    RzLabel87: TRzLabel;
    PtgTxtTglAkhir: TRzDateTimePicker;
    pnl_cancel: TRzPanel;
    RzLabel14: TRzLabel;
    PtgBtnDel: TAdvSmoothButton;
    procedure FormActivate(Sender: TObject);
    procedure PtgBtnDelClick(Sender: TObject);
    procedure PtgBtnBackClick(Sender: TObject);
    procedure ptgcbxkodecustChange(Sender: TObject);
    procedure ptgcbxnamacustChange(Sender: TObject);
    procedure PtgTxtTglAwalChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure Ptgdisplayfaktur;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  frmPtg: TfrmPtg;

implementation

uses SparePartFunction, Data, piutangmaster;

{$R *.dfm}

procedure TfrmPtg.Ptgdisplayfaktur;
begin
  with DataModule1.ZQrySellPayment do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,concat("[",kodecustomer,"] ",customer) kodenmcust from sellpayment ');
    SQL.Add('where isposted=1 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = "' + ptgcbxkodecust.Text + '" ');
    SQL.Add('and tanggal between "' + FormatDateTime('yyyy-MM-dd',PtgTxtTglAwal.Date) + '" and "' + FormatDateTime('yyyy-MM-dd',PtgTxtTglAkhir.Date) + '" ');
    SQL.Add('order by tanggalinput,waktu,faktur');
    Open;
  end;

  DataModule1.ZQryPaymentdet.DataSource := DataModule1.DSSellPayment;
  DataModule1.ZQryPaymentdet.Close;
  DataModule1.ZQryPaymentdet.Open;

end;

procedure TfrmPtg.FormActivate(Sender: TObject);
begin
{  frmPtg.Top := frmpiutangmaster.PanelPiutang.Top + 26;
  frmPtg.Height := frmpiutangmaster.PanelPiutang.Height;
  frmPtg.Width := frmpiutangmaster.PanelPiutang.Width;
  frmPtg.Left := 1; }
end;

procedure TfrmPtg.PtgBtnDelClick(Sender: TObject);
begin
 if DataModule1.ZQrySellPayment.IsEmpty then exit;

 if frmpiutangmaster.ptgcbxkodecust.ItemIndex<=0 then
 begin
  ErrorDialog('Pilih Salah Satu Customer dahulu!');
  exit;
 end;

 if dateof(DataModule1.ZQrySellPaymentTanggal.value)<dateof(now) then
 begin
  ErrorDialog('Pembayaran Piutang kemarin tidak dapat dihapus/batalkan!');
  exit;
 end
 else
 begin
  DataModule1.ZQrySellPayment.Next;
  if DataModule1.ZQrySellPayment.eof=false then
  begin
   DataModule1.ZQrySellPayment.Prior;
   ErrorDialog('Pembatalan Pembayaran Piutang hanya dapat dilakukan mulai dari Pembayaran Terakhir !');
   exit;
  end;
  DataModule1.ZQrySellPayment.Last;
 end;

 if QuestionDialog('Hapus Pembayaran Faktur dengan No. TT ' + DataModule1.ZQrySellPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQrySellPaymentTanggal.Value) + ' ?') = False then Exit;

 LogInfo(UserName,'Menghapus Pembayaran Faktur dengan No. TT ' + DataModule1.ZQrySellPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQrySellPaymentTanggal.Value));
 DataModule1.ZConnection1.ExecuteDirect('update sellmaster s,operasional o set s.lunas=if(s.grandtotal<=(s.totalpayment-o.debet),1,0),s.totalpayment=s.totalpayment-o.debet where o.fakturpay="'+DataModule1.ZQrySellPaymentfaktur.Value+'" and s.faktur=o.faktur');
 DataModule1.ZConnection1.ExecuteDirect('update returjualmaster set lunas=0 where faktur in (select faktur from operasional where debet=0 and fakturpay="'+DataModule1.ZQrySellPaymentfaktur.Value+'") ');
 DataModule1.ZConnection1.ExecuteDirect('delete from operasional where fakturpay="'+DataModule1.ZQrySellPaymentfaktur.Value+'"');
 DataModule1.ZConnection1.ExecuteDirect('delete from sellpayment where faktur="'+DataModule1.ZQrySellPaymentfaktur.Value+'"');
 InfoDialog('Pembayaran Faktur dengan No. TT ' + DataModule1.ZQrySellPaymentfaktur.Value + ', Tanggal ' + FormatDateTime('dd/mm/yyyy',DataModule1.ZQrySellPaymentTanggal.Value) + ' berhasil dihapus !');

 Ptgdisplayfaktur;
 DataModule1.ZQrySellPayment.Last;
end;

procedure TfrmPtg.FormShowFirst;
begin
 pnl_cancel.Visible := true;//iscancellistpayment;

  FillComboBox('kode','customer',ptgcbxkodecust,false,'kode',true);
  FillComboBox('nama','customer',ptgcbxnamacust,false,'kode',true);
  PtgTxtTglAwal.date  := dateof(startofthemonth(now));
  PtgTxtTglAkhir.date := dateof(now);

  ptgcbxkodecust.ItemIndex := frmpiutangmaster.ptgcbxkodecust.ItemIndex;
  ptgcbxkodecustchange(ptgcbxkodecust);
end;

procedure TfrmPtg.PtgBtnBackClick(Sender: TObject);
begin
 close;
end;

procedure TfrmPtg.ptgcbxkodecustChange(Sender: TObject);
begin
 ptgcbxnamacust.ItemIndex := ptgcbxkodecust.ItemIndex;

 Ptgdisplayfaktur;
end;

procedure TfrmPtg.ptgcbxnamacustChange(Sender: TObject);
begin
 ptgcbxkodecust.ItemIndex := ptgcbxnamacust.ItemIndex;

 Ptgdisplayfaktur;
end;

procedure TfrmPtg.PtgTxtTglAwalChange(Sender: TObject);
begin
 Ptgdisplayfaktur;
end;

procedure TfrmPtg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQryPaymentdet.Close;
 DataModule1.ZQrySellPayment.Close;

 IF Frmpiutangmaster=nil then
 application.CreateForm(TFrmpiutangmaster,Frmpiutangmaster);
 Frmpiutangmaster.Align:=alclient;
 Frmpiutangmaster.Parent:=Self.Parent;
 Frmpiutangmaster.BorderStyle:=bsnone;
 Frmpiutangmaster.Ptgdisplayfaktur;
 Frmpiutangmaster.Show;

end;

end.
