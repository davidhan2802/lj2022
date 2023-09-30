unit piutangmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, VolDBGrid, RzPanel, AdvSmoothButton, StdCtrls, Mask,
  RzEdit, ComCtrls, RzDTP, RzCmboBx, RzLabel, frxpngimage, ExtCtrls, dateutils, frxClass, ZDataSet, Db;

type
  TFrmpiutangmaster = class(TForm)
    PanelPiutang: TRzPanel;
    Image1: TImage;
    ptgpnlcust: TRzPanel;
    RzLabel242: TRzLabel;
    RzLabel88: TRzLabel;
    RzLabel87: TRzLabel;
    RzLabel83: TRzLabel;
    ptgcbxkodecust: TRzComboBox;
    ptgcbxnamacust: TRzComboBox;
    PtgDtpTempoAwal: TRzDateTimePicker;
    PtgDtpTempoAkhir: TRzDateTimePicker;
    PtgTxtTotal: TRzNumericEdit;
    RzPanel61: TRzPanel;
    RzLabel81: TRzLabel;
    PtgBtnPrint: TAdvSmoothButton;
    ptgpnlbayar: TRzPanel;
    lblbayar: TRzLabel;
    RzLabel254: TRzLabel;
    lblbatal: TRzLabel;
    RzLabel77: TRzLabel;
    RzLabel79: TRzLabel;
    RzLabel85: TRzLabel;
    RzLabel86: TRzLabel;
    RzLabel249: TRzLabel;
    RzLabel257: TRzLabel;
    RzLabel259: TRzLabel;
    PtgBtnBack: TAdvSmoothButton;
    PtgBtnlist: TAdvSmoothButton;
    PtgBtnPost: TAdvSmoothButton;
    PtgBtnAdd: TAdvSmoothButton;
    PtgTxtTgl: TRzDateTimePicker;
    ptgTxtFaktur: TRzEdit;
    ptgTxtSisaBayar: TRzNumericEdit;
    ptgTxtnotes: TRzEdit;
    RzGroupBox7: TRzGroupBox;
    RzLabel82: TRzLabel;
    RzLabel84: TRzLabel;
    RzLabel256: TRzLabel;
    PtgTxtTunai: TRzNumericEdit;
    PtgTxtBG: TRzNumericEdit;
    PtgTxtTsf: TRzNumericEdit;
    ptgTxtTagihan: TRzNumericEdit;
    ptgTxtBayar: TRzNumericEdit;
    ptgTxtSisaPiutang: TRzNumericEdit;
    RzPanel20: TRzPanel;
    RzLabel80: TRzLabel;
    RzLabel255: TRzLabel;
    RzLabel258: TRzLabel;
    ptgTxtTotalRetur: TRzNumericEdit;
    ptgTxtTotalpiutangFaktur: TRzNumericEdit;
    ptgTxtdiskonrp: TRzNumericEdit;
    PiutangDBGrid: TVolgaDBGrid;
    ReturDBGrid: TVolgaDBGrid;
    RzPanel24: TRzPanel;
    RzLabel89: TRzLabel;
    procedure PtgBtnAddClick(Sender: TObject);
    procedure PtgBtnBackClick(Sender: TObject);
    procedure PtgBtnPrintClick(Sender: TObject);
    procedure ptgcbxkodecustChange(Sender: TObject);
    procedure ptgcbxnamacustChange(Sender: TObject);
    procedure PtgDtpTempoAwalChange(Sender: TObject);
    procedure PtgBtnPostClick(Sender: TObject);
    procedure PtgBtnlistClick(Sender: TObject);
    procedure ptgTxtdiskonrpChange(Sender: TObject);
    procedure PtgTxtBGKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PtgTxtTunaiChange(Sender: TObject);
    procedure ptgTxtBayarChange(Sender: TObject);
    procedure PiutangDBGridCellClick(Sender: TObject;
      Column: TVolgaColumn);
    procedure PiutangDBGridTitleClick(Sender: TObject;
      Column: TVolgaColumn);
    procedure ReturDBGridTitleClick(Sender: TObject; Column: TVolgaColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure PtgCalculateRefreshChecked(Faktur,Retur: boolean);
    procedure PrintListPiutang;

  public
    { Public declarations }
    procedure FormShowFirst;
    procedure Ptgdisplayfaktur;
  end;

var
  Frmpiutangmaster: TFrmpiutangmaster;
  vtotalpiutangnodisc : double;
  ShowDetail : boolean;

implementation

uses frmPiutang, frmPiutangBG, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmpiutangmaster.FormShowFirst;
begin
  ipcomp := getComputerIP;

  FillComboBox('kode','customer where tglnoneffective is null ',ptgcbxkodecust,false,'kode',true);
  FillComboBox('nama','customer where tglnoneffective is null ',ptgcbxnamacust,false,'kode',true);

  PtgDtpTempoAwal.Date  := startofthemonth(TglSkrg);
  PtgDtpTempoAkhir.Date := endofthemonth(TglSkrg);

  PtgDtpTempoAwal.Checked  := false;
  PtgDtpTempoAkhir.Checked := false;

  PtgBtnAdd.Visible   := true;
  PtgBtnlist.Visible  := true;
  PtgBtnPost.Visible  := false;
  PtgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  ptgcbxkodecust.Enabled   := true;
  ptgcbxnamacust.Enabled   := true;
  PtgDtpTempoAwal.Enabled  := true;
  PtgDtpTempoAkhir.Enabled := true;
  PtgTxtTunai.enabled      := true;
  PtgTxtBG.enabled         := true;
  PtgTxtTsf.enabled        := true;
  ptgTxtdiskonrp.enabled   := true;

  DataModule1.ZConnection1.ExecuteDirect('update sellmaster set bayarskrg=0,checked=1 where isposted=1 and lunas=0 ');
  DataModule1.ZConnection1.ExecuteDirect('update returjualmaster set checked=1 where isposted=1 and lunas=0 ');

  PtgTxtFaktur.text        := '';
  ClearTabel('formbg where ipv='+ Quotedstr(ipcomp));

  ptgcbxkodecust.ItemIndex := 0;
  ptgcbxkodecustchange(ptgcbxkodecust);
end;

procedure TFrmpiutangmaster.PtgBtnAddClick(Sender: TObject);
var totpay: double;
begin
  if (DataModule1.ZQryPiutang.IsEmpty)or(ptgTxtTagihan.Value=0) then
  begin
    ErrorDialog('Pilih/Check Faktur yang akan dibayar dahulu!');
    Exit;
  end;

  if (ptgTxtFaktur.text='') then
  begin
    ErrorDialog('Isi No. TT Pembayaran dahulu! dengan No. Kwitansi atau yang lain...');
    Exit;
  end
  else if ((PtgTxtTsf.value+PtgTxtTunai.value+PtgTxtBG.value)<=0)or(PtgTxtBG.value<0)or(PtgTxtTsf.value<0) then
  begin
    ErrorDialog('Isi Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan atau BG dengan benar!');
    Exit;
  end
  else if (PtgTxtTsf.value+PtgTxtTunai.value+PtgTxtBG.value)>ptgTxtTagihan.Value then
  begin
    ErrorDialog('Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan BG tidak boleh lebih besar dari Jumlah Tagihan!');
    Exit;
  end;

  if QuestionDialog('Bayar Piutang ?') = false then exit;

  PtgBtnAdd.Visible   := false;
  PtgBtnlist.Visible  := false;
  PtgBtnPost.Visible  := true;
  PtgBtnBack.Visible  := true;
  lblbayar.Caption    := 'Posting';
  lblbatal.Caption    := 'Batal';

  DataModule1.ZConnection1.ExecuteDirect('update sellmaster set bayarskrg=0 where bayarskrg<>0 and isposted=1 and lunas=0 ');
  totpay := PtgTxtTsf.value + PtgTxtTunai.value + PtgTxtBG.value + ptgTxtTotalRetur.Value + ptgTxtdiskonrp.Value;
  with DataModule1 do
  begin
   ZQryPiutang.First;
   while (not ZQryPiutang.Eof)and(totpay>0) do
   begin
    if ZQryPiutangchecked.Value=0 then
    begin
     ZQryPiutang.Next;
     continue;
    end;

    ZQryPiutang.Edit;

    if totpay > ZQryPiutangPiutang.Value then
       ZQryPiutangbayarskrg.Value := ZQryPiutangPiutang.Value
    else ZQryPiutangbayarskrg.Value := totpay;
    totpay := totpay - ZQryPiutangPiutang.Value;

    ZQryPiutang.Post;
    ZQryPiutang.Next;
   end;
  end;

  ptgcbxkodecust.Enabled   := false;
  ptgcbxnamacust.Enabled   := false;
  PtgDtpTempoAwal.Enabled  := false;
  PtgDtpTempoAkhir.Enabled := false;
  PtgTxtTsf.enabled        := false;
  PtgTxtTunai.enabled      := false;
  PtgTxtBG.enabled         := false;
  PtgTxtdiskonrp.enabled   := false;

  PiutangDBGrid.Columns[7].Visible  := PtgBtnPost.Visible;
  RefreshTabel(DataModule1.ZQryPiutang);
end;

procedure TFrmpiutangmaster.PtgBtnBackClick(Sender: TObject);
begin
//  if DataModule1.ZQryPiutang.IsEmpty then Exit;
  if QuestionDialog('Batal Bayar Piutang ?') = false then exit;

  PtgBtnAdd.Visible   := true;
  PtgBtnlist.Visible  := true;
  PtgBtnPost.Visible  := false;
  PtgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  ptgcbxkodecust.Enabled   := true;
  ptgcbxnamacust.Enabled   := true;
  PtgDtpTempoAwal.Enabled  := true;
  PtgDtpTempoAkhir.Enabled := true;
  PtgTxtTsf.enabled        := true;
  PtgTxtTunai.enabled      := true;
  PtgTxtBG.enabled         := true;
  ptgTxtdiskonrp.enabled   := true;

  DataModule1.ZConnection1.ExecuteDirect('update sellmaster set bayarskrg=0 where bayarskrg<>0 and isposted=1 and lunas=0 ');

  PiutangDBGrid.Columns[7].Visible := PtgBtnPost.Visible;
  RefreshTabel(DataModule1.ZQryPiutang);

end;

procedure TFrmpiutangmaster.PtgBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryPiutang.IsEmpty then Exit;
  PrintListPiutang;

end;

procedure TFrmpiutangmaster.PtgCalculateRefreshChecked(Faktur,Retur: boolean);
begin
  if (Faktur=False)and(Retur=False) then exit;

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
   if Faktur then
   begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal-totalpayment) from sellmaster ');
    SQL.Add('where isposted=1 and checked=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    if PtgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAwal.Date)) + ' ');
    if PtgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAkhir.Date)) + ' ');
    Open;
    ptgTxtTotalpiutangFaktur.value := Fields[0].AsFloat;
    Close;
   end;

   if Retur then
   begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(totalretur) from returjualmaster ');
    SQL.Add('where isposted=1 and checked=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    Open;
    ptgTxtTotalRetur.Value := Fields[0].AsFloat;
    Close;
   end;
  end;

  PtgTxtTagihan.Value := ptgTxtTotalpiutangFaktur.value - ptgTxtTotalRetur.Value - ptgTxtdiskonrp.Value;
end;

procedure TFrmpiutangmaster.Ptgdisplayfaktur;
begin
  PiutangDBGrid.Columns[7].Visible := PtgBtnPost.Visible;

  PiutangDBGrid.Columns[0].ReadOnly := (ptgcbxkodecust.ItemIndex = 0);

  with DataModule1.ZQryPiutang do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,(grandtotal-totalpayment) piutang,concat("[",kodecustomer,"] ",customer) kodenmcust from sellmaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    if PtgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAwal.Date)) + ' ');
    if PtgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAkhir.Date)) + ' ');
    SQL.Add('order by faktur');
    Open;
  end;

  with DataModule1.ZQryPiutangRetur do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,concat("[",kodecustomer,"] ",customer) kodenmcust from returjualmaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    SQL.Add('order by faktur');
    Open;
  end;

  ptgpnlbayar.visible := (ptgcbxkodecust.ItemIndex > 0); //and (DataModule1.ZQryPiutang.IsEmpty=false);

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal-totalpayment) from sellmaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    if PtgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAwal.Date)) + ' ');
    if PtgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAkhir.Date)) + ' ');
    Open;
    ptgTxtTotalpiutangFaktur.value := Fields[0].AsFloat;
    Close;
    SQL.Clear;
    SQL.Add('select sum(totalretur) from returjualmaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if ptgcbxkodecust.ItemIndex>0 then SQL.Add('and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ');
    Open;
    ptgTxtTotalRetur.Value := Fields[0].AsFloat;
    Close;
  end;

  vtotalpiutangnodisc := ptgTxtTotalpiutangFaktur.value - ptgTxtTotalRetur.Value;
  PtgTxtTotal.Value   := vtotalpiutangnodisc - ptgTxtdiskonrp.Value;
  PtgTxtTagihan.Value := PtgTxtTotal.Value;
end;

procedure TFrmpiutangmaster.ptgcbxkodecustChange(Sender: TObject);
begin
 ptgcbxnamacust.ItemIndex := ptgcbxkodecust.ItemIndex;

  PtgTxtTsf.Value          := 0;
  PtgTxtTunai.Value        := 0;
  PtgTxtBG.Value           := 0;
  PtgTxtTgl.Date           := now;

  PtgTxtTagihan.Value      := 0;
  PtgTxtBayar.Value        := 0;
  PtgTxtSisaBayar.Value    := 0;
  PtgTxtSisaPiutang.Value  := 0;

  ptgTxtnotes.Text         := '';

 ptgTxtdiskonrp.Value := 0;

 Ptgdisplayfaktur;

end;

procedure TFrmpiutangmaster.ptgcbxnamacustChange(Sender: TObject);
begin
 ptgcbxkodecust.ItemIndex := ptgcbxnamacust.ItemIndex;

  PtgTxtTsf.Value          := 0;
  PtgTxtTunai.Value        := 0;
  PtgTxtBG.Value           := 0;
  PtgTxtTgl.Date           := now;

  PtgTxtTagihan.Value      := 0;
  PtgTxtBayar.Value        := 0;
  PtgTxtSisaBayar.Value    := 0;
  PtgTxtSisaPiutang.Value  := 0;

  ptgTxtnotes.Text         := '';

 ptgTxtdiskonrp.Value := 0;

 Ptgdisplayfaktur;

end;

procedure TFrmpiutangmaster.PtgDtpTempoAwalChange(Sender: TObject);
begin
 Ptgdisplayfaktur;

end;

procedure TFrmpiutangmaster.PtgBtnPostClick(Sender: TObject);
var vbyrskrg,vsisapiutang: double;
    ketstr,pketstr  : string;
begin
  if (DataModule1.ZQryPiutang.IsEmpty)or(ptgTxtTagihan.Value=0) then
  begin
    ErrorDialog('Pilih/Check Faktur yang akan dibayar dahulu!');
    Exit;
  end;

  if (ptgTxtFaktur.text='') then
  begin
    ErrorDialog('Isi No. TT dahulu!');
    Exit;
  end
  else if isDataExist('select faktur from sellpayment where faktur='+ QuotedStr(ptgTxtFaktur.text)) then
  begin
    ErrorDialog('No. TT telah terdaftar! Isi dengan Nomor yang lain...');
    Exit;
  end
  else if ((PtgTxtTsf.value+PtgTxtTunai.value+PtgTxtBG.value)<=0)or(PtgTxtBG.value<0)or(PtgTxtTsf.value<0) then
  begin
    ErrorDialog('Isi Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan atau BG dengan benar!');
    Exit;
  end
  else if (PtgTxtTsf.value+PtgTxtTunai.value+PtgTxtBG.value)>PtgTxtTagihan.Value then
  begin
    ErrorDialog('Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan BG tidak boleh lebih besar dari Jumlah Tagihan!');
    Exit;
  end;

  if QuestionDialog('Posting Pembayaran Piutang ini ?') = False then Exit;

  ketstr := '';
  pketstr := '';
  if PtgTxtTunai.Value>0 then pketstr := 'Tunai '+ FormatCurr('Rp ###,##0',PtgTxtTunai.Value) + ' ';
  if PtgTxtTsf.Value>0 then pketstr := pketstr + 'Transfer '+ FormatCurr('Rp ###,##0',PtgTxtTsf.Value) + ' ';
  if PtgTxtBG.Value>0 then pketstr := pketstr + 'BG '+FormatCurr('Rp ###,##0',PtgTxtBG.Value)+' ';

  with DataModule1 do
  begin
   ZQryPiutang.First;
   while (not ZQryPiutang.Eof) do
   begin
    if ZQryPiutangbayarskrg.Value<>0 then
    begin
     ZQryPiutang.Edit;
     vbyrskrg := ZQryPiutangtotalpayment.Value + ZQryPiutangbayarskrg.Value;
     vsisapiutang := ZQryPiutanggrandtotal.Value - vbyrskrg;
     if vsisapiutang<=0 then ZQryPiutanglunas.Value := 1;
     ZQryPiutangtotalpayment.Value := vbyrskrg;
     vbyrskrg := ZQryPiutangbayarskrg.Value;
     ZQryPiutangbayarskrg.Value    := 0;
     ZQryPiutang.Post;

     if ZQryPiutanglunas.Value = 1 then
        ketstr := 'Pelunasan Piutang Faktur ' + ZQryPiutangfaktur.value + ' : ' + FormatCurr('Rp ###,##0',vbyrskrg)+' . Total Tagihan Faktur : '+FormatCurr('Rp ###,##0',ptgTxtTotalpiutangFaktur.Value)+' . Total Retur : '+FormatCurr('Rp ###,##0',ptgTxtTotalRetur.Value)+' . Diskon '+FormatCurr('Rp ###,##0',ptgTxtdiskonrp.Value)+' . TT No: '+ptgTxtFaktur.text+' pada Tanggal '+Formatdatetime('dd-mm-yyyy',PtgTxtTgl.Date)+' dengan Total '+ pketstr
     else ketstr := 'Cicilan Pembayaran Piutang Faktur ' + ZQryPiutangfaktur.value + ' : ' + FormatCurr('Rp ###,##0',vbyrskrg) +' (sisa Piutang jadi ' + FormatCurr('Rp ###,##0',vsisapiutang) + '). Total Tagihan Faktur : '+FormatCurr('Rp ###,##0',ptgTxtTotalpiutangFaktur.Value)+' . Total Retur : '+FormatCurr('Rp ###,##0',ptgTxtTotalRetur.Value)+' . Diskon '+FormatCurr('Rp ###,##0',ptgTxtdiskonrp.Value)+' . TT No: '+ptgTxtFaktur.text+' pada Tanggal '+Formatdatetime('dd-mm-yyyy',PtgTxtTgl.Date)+' dengan Total '+ pketstr;

     ZConnection1.ExecuteDirect('insert into operasional '+
                                            '(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet,fakturpay,saldoawaltagihan) values '+
                                            '("' + ZQryPiutangidsell.AsString  + '",' +
                                            '"' + ZQryPiutangfaktur.value      + '",' +
                                            '"' + FormatDateTime('yyyy-MM-dd',PtgTxtTgl.Date) + '",' +
                                            '"' + FormatDateTime('hh:mm:ss',Now) + '",' +
                                            '"' + UserName + '",' +
                                            '"' + 'PIUTANG PENJUALAN' + '",' +
                                            '"' + ketstr + '",' +
                                            '"' + FloatToStr(vbyrskrg) + '",' +
                                            '"' + ptgTxtFaktur.text + '",' +
                                            '"' + ZQryPiutangpiutang.AsString  + '")');

     LogInfo(UserName,ketstr);
    end;

    ZQryPiutang.Next;
   end;

     ZConnection1.ExecuteDirect('insert into sellpayment '+
                                            '(faktur,kodecustomer,customer,tanggal,waktu,kasir,saldo_piutang,transfer,tunai,bg,totalpiutangfaktur,totalretur,diskonrp,tanggalinput,notes,isposted) values '+
                                            '(' + QuotedStr(ptgTxtFaktur.text) + ',' +
                                                  QuotedStr(ptgcbxkodecust.text) + ',' +
                                                  QuotedStr(ptgcbxnamacust.text) + ',' +
                                                  QuotedStr(FormatDateTime('yyyy-MM-dd',PtgTxtTgl.Date)) + ',' +
                                                  QuotedStr(FormatDateTime('hh:mm:ss',Now)) + ',' +
                                                  QuotedStr(UserName) + ',' +
                                                  QuotedStr(FloatToStr(ptgtxtsisaPiutang.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgtxttsf.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgtxttunai.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgtxtBG.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgTxtTotalpiutangFaktur.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgTxtTotalRetur.Value)) + ',' +
                                                  QuotedStr(FloatToStr(ptgTxtdiskonrp.Value)) + ',CURRENT_DATE,' +
                                                  QuotedStr(ptgTxtnotes.Text) + ',1)');

     ZConnection1.ExecuteDirect('insert into sellpaymentbg (faktur,tgl,transfer,bg,bgno,bgbank,bgtempo,tobank) select faktur,tgl,transfer,bg,bgno,bgbank,bgtempo,tobank from formbg where ipv='+Quotedstr(ipcomp)+' and faktur = '+QuotedStr(PtgTxtfaktur.Text));
//     ZConnection1.ExecuteDirect('delete from formbg where ipv='+Quotedstr(ipcomp)+' and faktur = '+QuotedStr(PtgTxtfaktur.Text));
     ClearTabel('formbg where ipv='+ Quotedstr(ipcomp));

     ZQryPiutangRetur.First;
     while (not ZQryPiutangRetur.Eof) do
     begin
      if ZQryPiutangReturchecked.Value=0 then
      begin
       ZQryPiutangRetur.Next;
       continue;
      end;

      ZConnection1.ExecuteDirect('insert into operasional '+
                                 '(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,kredit,fakturpay,saldoawaltagihan) values '+
                                 '("' + ZQryPiutangReturidReturJual.AsString + '",' +
                                 '"' + ZQryPiutangReturfaktur.AsString + '",' +
                                 '"' + FormatDateTime('yyyy-MM-dd',PtgTxtTgl.Date) + '",' +
                                 '"' + FormatDateTime('hh:mm:ss',Now) + '",' +
                                 '"' + UserName + '",' +
                                 '"' + 'RETUR PENJUALAN' + '",' +
                                 '"' + 'LUNAS' + '",' +
                                 '"' + ZQryPiutangReturtotalretur.AsString + '",' +
                                 '"' + ptgTxtFaktur.text + '",' +
                                 '"' + ZQryPiutangReturtotalretur.AsString + '")');

      ZConnection1.ExecuteDirect('update returjualmaster set lunas=1 where isposted=1 and lunas=0 and faktur="' + ZQryPiutangReturfaktur.Value + '" ');

      ZQryPiutangRetur.Next;
     end;
  end;

  InfoDialog('Pembayaran Piutang berhasil diterima !');

  PtgBtnAdd.Visible   := true;
  PtgBtnlist.Visible  := true;
  PtgBtnPost.Visible  := false;
  PtgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  ptgcbxkodecust.Enabled   := true;
  ptgcbxnamacust.Enabled   := true;
  PtgDtpTempoAwal.Enabled  := true;
  PtgDtpTempoAkhir.Enabled := true;
  PtgTxtTsf.enabled        := true;
  PtgTxtTunai.enabled      := true;
  PtgTxtBG.enabled         := true;
  ptgTxtdiskonrp.enabled   := true;

  PtgTxtFaktur.text        := '';
  PtgTxtTsf.Value          := 0;
  PtgTxtTunai.Value        := 0;
  PtgTxtBG.Value           := 0;
  PtgTxtTgl.Date           := now;

  PtgTxtTagihan.Value      := 0;
  PtgTxtBayar.Value        := 0;
  PtgTxtSisaBayar.Value    := 0;
  PtgTxtSisaPiutang.Value  := 0;

  ptgTxtnotes.Text         := '';

  ptgTxtdiskonrp.Value := 0;

  Ptgdisplayfaktur;

end;

procedure TFrmpiutangmaster.PtgBtnlistClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF frmPtg=nil then
 application.CreateForm(TfrmPtg,frmPtg);
 frmPtg.Align:=alclient;
 frmPtg.Parent:=self.parent;
 frmPtg.BorderStyle:=bsnone;
 frmPtg.FormShowFirst;
 frmPtg.Show;

end;

procedure TFrmpiutangmaster.ptgTxtdiskonrpChange(Sender: TObject);
begin
  PtgTxtTotal.Value   := vtotalpiutangnodisc - ptgTxtdiskonrp.Value;
  PtgTxtTagihan.Value := ptgTxtTotalpiutangFaktur.value - ptgTxtTotalRetur.Value - ptgTxtdiskonrp.Value;

end;

procedure TFrmpiutangmaster.PtgTxtBGKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) then
  begin
   if ptgTxtFaktur.Text='' then
   begin
    warningdialog('Isi No. TT dahulu!');
    ptgTxtFaktur.SetFocus;
    exit;
   end;

   ShowDetail := true;

{   TUTUPFORM(self.parent);
   IF frmPtgBG=nil then application.CreateForm(TfrmPtgBG,frmPtgBG);
   frmPtgBG.Align:=alclient;
   frmPtgBG.Parent:=self.parent;
   frmPtgBG.BorderStyle:=bsnone;     }
   frmPtgBG.PtgTxtfaktur.Text := PtgTxtfaktur.Text;
   frmPtgBG.PtgTxtTgl.Date := PtgTxtTgl.Date;
   frmPtgBG.PtgTxtTsf.Value := PtgTxtTsf.Value;
   frmPtgBG.PtgTxtBG.Value := PtgTxtBG.Value;
   frmPtgBG.FormShowFirst;
   frmPtgBG.ShowModal;

  end;

end;

procedure TFrmpiutangmaster.PtgTxtTunaiChange(Sender: TObject);
begin
 ptgTxtBayar.Value := PtgTxtTunai.Value + PtgTxtBG.Value + PtgTxtTsf.Value;

end;

procedure TFrmpiutangmaster.ptgTxtBayarChange(Sender: TObject);
begin
 ptgTxtSisaBayar.Value := PtgTxtTagihan.Value - PtgTxtBayar.Value;
 ptgTxtSisaPiutang.Value := PtgTxtTotal.Value - PtgTxtBayar.Value;


end;

procedure TFrmpiutangmaster.PiutangDBGridCellClick(Sender: TObject;
  Column: TVolgaColumn);
begin
 if (column.Index=0)and((Sender as TVolgaDBGrid).DataSource.DataSet.State=dsEdit) then
 begin
  ((Sender as TVolgaDBGrid).DataSource.DataSet as TZQuery).CommitUpdates;
  PtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
 end;

end;

procedure TFrmpiutangmaster.PiutangDBGridTitleClick(Sender: TObject;
  Column: TVolgaColumn);
var ischeck: byte;
    strbuf : string;
begin
 if (ptgcbxkodecust.ItemIndex=0)or(DataModule1.ZQryPiutang.IsEmpty) then exit;

 if DataModule1.ZQryPiutangchecked.Value=0 then ischeck:=1 else ischeck:=0;
 strbuf := 'where isposted=1 and lunas=0 ';
 if ptgcbxkodecust.ItemIndex>0 then strbuf := strbuf + 'and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ';
 if PtgDtpTempoAwal.Checked then
    strbuf := strbuf + 'and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAwal.Date)) + ' ';
 if PtgDtpTempoAkhir.Checked then
    strbuf := strbuf + 'and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',PtgDtpTempoAkhir.Date)) + ' ';

 DataModule1.ZConnection1.ExecuteDirect('update sellmaster set checked='+inttostr(ischeck)+' '+strbuf);

 RefreshTabel(DataModule1.ZQryPiutang);
 PtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
end;

procedure TFrmpiutangmaster.ReturDBGridTitleClick(Sender: TObject;
  Column: TVolgaColumn);
var ischeck: byte;
    strbuf : string;
begin
 if (ptgcbxkodecust.ItemIndex=0)or(DataModule1.ZQryPiutangretur.IsEmpty) then exit;

 if DataModule1.ZQryPiutangreturchecked.Value=0 then ischeck:=1 else ischeck:=0;
 strbuf := 'where isposted=1 and lunas=0 ';
 if ptgcbxkodecust.ItemIndex>0 then strbuf := strbuf + 'and kodecustomer = ' + QuotedStr(ptgcbxkodecust.Text) + ' ';

 DataModule1.ZConnection1.ExecuteDirect('update returjualmaster set checked='+inttostr(ischeck)+' '+strbuf);

 RefreshTabel(DataModule1.ZQryPiutangretur);
 PtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
end;

procedure TFrmpiutangmaster.PrintListPiutang;
var
  FrxMemo: TfrxMemoView;
  strTgl : string;
begin
{  DataModule1.frxReport1.LoadFromFile('piutang.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  strtgl  := '';
  if frmpiutangmaster.ptgcbxkodecust.ItemIndex>0 then strtgl  := strtgl + frmpiutangmaster.ptgcbxnamacust.Text + ' ';
  if frmpiutangmaster.PtgDtpTempoAwal.Checked and frmpiutangmaster.PtgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',frmpiutangmaster.PtgDtpTempoAwal.Date) +' s/d '+FormatDateTime('dd-MM-yyyy',frmpiutangmaster.PtgDtpTempoAkhir.Date)
  else if frmpiutangmaster.PtgDtpTempoAwal.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',frmpiutangmaster.PtgDtpTempoAwal.Date) + ' dan seterusnya '
  else if frmpiutangmaster.PtgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo'+ ' s/d '+FormatDateTime('dd-MM-yyyy',frmpiutangmaster.PtgDtpTempoAkhir.Date);

  FrxMemo.Memo.Text := strtgl;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TotalRetur'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',frmpiutangmaster.ptgTxtTotalRetur.Value);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TotalPiutang'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',frmpiutangmaster.ptgTxtTotal.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',TglSkrg) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();  }

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\piutang.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  if ptgcbxkodecust.ItemIndex>0 then FrxMemo.Memo.Text := 'DAFTAR PIUTANG (' + ptgcbxnamacust.Text + ')'
  else FrxMemo.Memo.Text := 'DAFTAR PIUTANG';

  strtgl  := '';
  if PtgDtpTempoAwal.Checked and PtgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',PtgDtpTempoAwal.Date) +' s/d '+FormatDateTime('dd-MM-yyyy',PtgDtpTempoAkhir.Date)
  else if frmpiutangmaster.PtgDtpTempoAwal.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',PtgDtpTempoAwal.Date) + ' dan seterusnya '
  else if frmpiutangmaster.PtgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo'+ ' s/d '+FormatDateTime('dd-MM-yyyy',PtgDtpTempoAkhir.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := strtgl;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmpiutangmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then
 begin
  DataModule1.ZQryPiutangRetur.Close;
  DataModule1.ZQryPiutang.Close;
 end;
end;

end.
