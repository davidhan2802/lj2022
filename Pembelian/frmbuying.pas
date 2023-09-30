unit frmbuying;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls,
  VolDBGrid;

type
  TfrmBuy = class(TForm)
    PanelSell: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    RzStatusPane1: TRzStatusPane;
    RzLabel9: TRzLabel;
    SellLblGrandTotal: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel13: TRzLabel;
    SellTxtNo: TRzEdit;
    RzLabel15: TRzLabel;
    SellTxtTgl: TRzDateTimeEdit;
    RzPanel4: TRzPanel;
    RzLabel6: TRzLabel;
    SellTxtGrandTotal: TRzNumericEdit;
    SellTxtCetak: TRzCheckBox;
    RzPanel7: TRzPanel;
    SellBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    RzLabel3: TRzLabel;
    SellTxtSubTotal: TRzNumericEdit;
    SellTxtPPN: TRzNumericEdit;
    SellPanelCredit: TRzPanel;
    RzLabel11: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel10: TRzLabel;
    SellTxtpembayaran: TRzComboBox;
    edtnum_tempohari: TRzNumericEdit;
    BuyTxtTglJatuhTempo: TRzDateTimeEdit;
    ccx_isppn: TRzCheckBox;
    RzLabel16: TRzLabel;
    edt_kode: TRzEdit;
    BuyDBGrid: TVolgaDBGrid;
    RzLabel5: TRzLabel;
    SellTxtDiscRp: TRzNumericEdit;
    RzLabel1: TRzLabel;
    SellTxtNoInvoice: TRzEdit;
    RzPanel1: TRzPanel;
    RzLabel4: TRzLabel;
    sellTxtalamat: TRzMemo;
    SellTxtsupplier: TRzEdit;
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure BuyDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SellTxtpembayaranChange(Sender: TObject);
    procedure BuyTxtTglJatuhTempoChange(Sender: TObject);
    procedure ccx_isppnClick(Sender: TObject);
    procedure edt_kodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellTxtDiscRpChange(Sender: TObject);
  private
    oldTotal: Double;
    function getNoFakturJual : string;
    procedure CalculateGridSell;
    procedure Calculatebuy;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    procedure inputkodebarcode(nilai:string);
    { Private declarations }
  public
    SubTotal : Double;
    CetakFaktur,vkodesupp,valamat,vkota: string;
    vidsupp : integer;
    procedure PostingJual(Faktur: string);
    procedure PrintStruck(NoFaktur: string);
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  frmBuy: TfrmBuy;

implementation

uses SparePartFunction, frmSearchProduct, frmproduct, buymaster,
  frmhistorybuysell, frmSearchSupp, Data;

{$R *.dfm}

procedure TfrmBuy.PrintStruck(NoFaktur: string);
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\fakturpembelian.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := SellTxtNo.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tanggal'));
  FrxMemo.Memo.Text := SellTxtTgl.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('supplier'));
  FrxMemo.Memo.Text := SellTxtsupplier.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('noinvoice'));
  FrxMemo.Memo.Text := SellTxtNoInvoice.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('lokasi'));
  FrxMemo.Memo.Text := lokasigudang;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Footercaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',now);

  RefreshTabel(DataModule1.ZQryformbuy);

  DataModule1.frxReport1.ShowReport();
end;

procedure TfrmBuy.PostingJual(Faktur: string);
var
  FakturBaru,idTrans,GrandTotal,totpayment,vwkt: string;
  islunas: integer;
  vtotpayment: double;
begin
    ///Ganti No Faktur temp dengan yang asli...
    ///Format NO FAKTUR TEMP : MSyy/MM/dd-hhmmss
    ///Format NO FAKTUR ASLI : MSP/Tahun 2 digit/Bulan 2 Digit disambung kode urut (MSP/09/110001)
    with DataModule1.ZQrySearch do
    begin
      FakturBaru := Faktur;
      CetakFaktur := FakturBaru;

      Close;
      SQL.Clear;
      SQL.Add('select * from buymaster');
      SQL.Add('where faktur = ''' + Faktur + '''');
      Open;

      idTrans := FieldByName('idBeli').AsString;
      if idTrans = '' then idTrans := '0';
      islunas := FieldByName('lunas').AsInteger;
      totpayment := FieldByName('totalpayment').AsString;
      GrandTotal := FieldByName('grandtotal').AsString;
      vtotpayment := FieldByName('totalpayment').AsFloat;
      vwkt := FormatDateTime('hh:nn:ss',FieldByName('waktu').AsDateTime);
    end;

    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update buymaster set');
      SQL.Add('isposted = 1 ');
      SQL.Add('where faktur = ''' + Faktur + '''');
      ExecSQL;

      ///Input Operasional
{      if (vtotpayment<>0) then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into operasional');
        SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,kredit) values');
        SQL.Add('(''' + idTrans + ''',');
        SQL.Add('''' + FakturBaru + ''',');
        SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
        SQL.Add('''' + vwkt + ''',');
        SQL.Add('''' + UserName + ''',');
        SQL.Add('''' + 'PEMBELIAN' + ''',');
        if islunas=1 then SQL.Add('''' + 'LUNAS' + ''',')
        else SQL.Add('''' + 'DP' + ''',');
        SQL.Add('''' + totpayment + ''')');
        ExecSQL;
      end;
}
      DataModule1.ZConnection1.ExecuteDirect('update product p, formbuy b set p.hargabeli=round((b.harga-(b.harga*b.diskon*0.01))-((b.harga-(b.harga*b.diskon*0.01))*b.diskon2*0.01)) where ipv='+Quotedstr(ipcomp)+' and p.kode=b.kode ');

      LogInfo(UserName,'Posting transaksi pembelian, no faktur : ' + FakturBaru + ', nilai transaksi:' + GrandTotal);
//      InfoDialog('Faktur ' + Faktur + ' berhasil diposting !');
    end;
end;

function TfrmBuy.getNoFakturJual : string;
var Year,Month,Day: Word;
begin
    DataModule1.ZQrySearch.Close;
    DataModule1.ZQrySearch.SQL.Text := 'select faktur from buymaster where isposted=-1 and left(faktur,2)='+Quotedstr('B'+standPos)+' order by idBeli limit 1';
    DataModule1.ZQrySearch.Open;
    if (DataModule1.ZQrySearch.IsEmpty=false)and(DataModule1.ZQrySearch.Fields[0].IsNull=false) then
    begin
     result := DataModule1.ZQrySearch.Fields[0].AsString;
     exit;
    end;
    DataModule1.ZQrySearch.Close;

    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(faktur,4)) from buymaster');
//      SQL.Add('where faktur like "' + standPos + '-' + Copy(IntToStr(Year),3,2) + '%' + '"');
      SQL.Add('where faktur like "B' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'B' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '0001'
      else
        result := 'B' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('0000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TfrmBuy.CalculateGridSell;
begin
  if (DataModule1.ZQryformbuy.State <> dsInsert) or (DataModule1.ZQryformbuy.State <> dsEdit) then
    DataModule1.ZQryformbuy.Edit;

  if (DataModule1.ZQryformbuy.IsEmpty=false)and(BuyDBGrid.Fields[10].IsNull=false) then
  begin
//    if (BuyDBGrid.Fields[9].AsFloat<>0)and(BuyDBGrid.Fields[4].AsFloat=0) then
//    BuyDBGrid.Fields[9].AsFloat := round(BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * (1-(0.01*BuyDBGrid.Fields[7].AsFloat)));

    BuyDBGrid.Fields[9].AsFloat := (BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat)-round((BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * BuyDBGrid.Fields[7].AsFloat * 0.01)+(((BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat) - (BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * BuyDBGrid.Fields[7].AsFloat * 0.01)) * BuyDBGrid.Fields[8].AsFloat * 0.01));

    Subtotal := getDatanum('sum(subtotal)','formbuy where ipv='+Quotedstr(ipcomp)+' and nourut<>'+ BuyDBGrid.Fields[10].AsString );
    SubTotal := SubTotal + BuyDBGrid.Fields[9].AsFloat;
  end
  else SubTotal := 0;
  SellTxtSubTotal.Value := SubTotal;
  Calculatebuy;

end;

procedure TfrmBuy.Calculatebuy;
begin
    if ccx_isppn.Checked then SellTxtPPN.Value := round(SellTxtSubTotal.Value*0.1) else  SellTxtPPN.Value := 0;

    SellTxtGrandTotal.Value := SellTxtSubTotal.Value + SellTxtPPN.Value - SellTxtDiscRp.Value;
    if SellTxtGrandTotal.Value<0 then SellTxtGrandTotal.Value:=0;
    SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',SellTxtGrandTotal.Value);
//    SellTxtKembali.Value := SellTxtDibayar.Value - SellTxtGrandTotal.Value;
//    if SellTxtKembali.Value<0 then SellTxtKembali.Value:=0;
end;

procedure TfrmBuy.ClearForm;
begin
  SellTxtCetak.Checked := true;

  ClearTabel('formbuy where ipv='+ Quotedstr(ipcomp) );
  RefreshTabel(DataModule1.ZQryformbuy);

  SellTxtNo.Text :=  getNoFakturJual;
  SellTxtNoInvoice.Text := '';
  SellTxtTgl.Date := TglSkrg;
  SellTxtSubTotal.Value := 0;
  ccx_isppn.Checked := false;
  SellTxtPPN.Value := 0;
  SellTxtDiscRp.Value := 0;
  SellLblGrandTotal.Caption := 'Rp 0';
  SellTxtGrandTotal.Value := 0;

  BuyTxtTglJatuhTempo.Date := incday(TglSkrg,30);
  BuyTxtTglJatuhTempoChange(self);

  SellTxtpembayaran.itemindex := 1;
  SellTxtpembayaranChange(SellTxtpembayaran);

  edt_kode.Text := '';

  SubTotal := 0;

  vidsupp := -1;
  vkodesupp := '';
  valamat := '';
  vkota   := '';
  SellTxtsupplier.Text := '';
  sellTxtalamat.Text :='';

//  SellTxtsupplier.SetFocus;
end;

procedure TfrmBuy.InsertDataMaster;
var idTrans,vwkt,valamat,vkota,vpono: string;
begin
  Subtotal := getDatanum('sum(subtotal)','formbuy where ipv='+ Quotedstr(ipcomp));
  SellTxtSubTotal.Value := SubTotal;
  CalculateBuy;

{  valamat:=''; vkota :='';
  DataModule1.ZQryUtil.Close;
  DataModule1.ZQryUtil.SQL.Text := 'select alamat,kota from supplier where kode=' + Quotedstr(cb_kode_supplier.Text);
  DataModule1.ZQryUtil.Open;
  if DataModule1.ZQryUtil.Fields[0].Isnull=false then valamat := DataModule1.ZQryUtil.Fields[0].AsString;
  if DataModule1.ZQryUtil.Fields[1].Isnull=false then vkota   := DataModule1.ZQryUtil.Fields[1].AsString;
  DataModule1.ZQryUtil.Close;
}
  DataModule1.ZConnection1.ExecuteDirect('call p_cancelbuy('+ QuotedStr(SellTxtNo.Text) +')');


  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into buymaster (faktur,noinvoice,tanggal,tgljatuhtempo,tempohari,pembayaran,waktu,kasir,kodesupplier,supplier,alamat,kota,subtotal,ppn,diskonrp,grandtotal,IDuserposted,totalpayment,isposted,lunas) values');
    SQL.Add('(' + QuotedStr(SellTxtNo.Text) + ',');
    SQL.Add(QuotedStr(trim(SellTxtNoInvoice.Text)) + ',');
    SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date)) + ',');
    SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd',BuyTxtTglJatuhTempo.Date)) + ',');
    SQL.Add(QuotedStr(FloatToStr(edtnum_tempohari.Value)) + ',');
    SQL.Add(QuotedStr(SellTxtpembayaran.Text) + ',');
    vwkt := FormatDateTime('hh:nn:ss',Now);
    SQL.Add(QuotedStr(vwkt) + ',');
    SQL.Add(QuotedStr(UserName) + ',');
    SQL.Add(QuotedStr(vkodesupp) + ',');
    SQL.Add(QuotedStr(SellTxtsupplier.Text) + ',');
    SQL.Add(QuotedStr(valamat) + ',');
    SQL.Add(QuotedStr(vkota) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtSubTotal.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtPPN.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtDiscRp.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtGrandTotal.Value)) + ',');
    SQL.Add(QuotedStr(inttostr(IDuserlogin)) + ',');
    SQL.Add('0,0,0)');
    ExecSQL;

    DataModule1.ZConnection1.ExecuteDirect('update formbuy o, product p set o.faktur='+Quotedstr(SellTxtNo.Text)+', o.satuan=p.satuan where (o.kode=p.kode) and (o.ipv='+Quotedstr(ipcomp)+') ');

    Close;
    SQL.Clear;
    SQL.Text := 'select idbeli from buymaster where faktur='+ Quotedstr(SellTxtNo.Text) ;
    Open;
    idTrans := Fields[0].AsString;

    DataModule1.ZConnection1.ExecuteDirect('insert into buydetail '+
    '(idbeli,faktur,kode,nama,kategori,merk,tipe,seri,barcode,hargabeli,harganondiskon,quantity,diskon,diskon2,satuan,subtotal) '+
    'select '+Quotedstr(idTrans)+',faktur,kode,nama,kategori,merk,tipe,seri,barcode,harga,harganondiskon,quantity,diskon,diskon2,satuan,subtotal from formbuy where ipv='+ Quotedstr(ipcomp));

    ///Input Inventory
    DataModule1.ZConnection1.ExecuteDirect('insert into inventory ' +
    '(kodebrg,qty,satuan,hargabeli,hargajual,faktur,keterangan,typetrans,idTrans,username,tglTrans,waktu,kodeGudang) ' +
    'select kode,quantity,satuan,harga,harganondiskon,faktur,'+Quotedstr('Invoice No.'+SellTxtNoInvoice.Text+' '+SellTxtsupplier.Text)+',''pembelian'','''+idTrans+''',' + QuotedStr(UserName) + ',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + vwkt + ''',''' + KodeGudang + ''' from formbuy where ipv=' + Quotedstr(ipcomp) );

  end;

end;

procedure TfrmBuy.UpdateData;
var idTrans,vwkt,valamat,vkota,vpono: string;
begin
  Subtotal := getDatanum('sum(subtotal)','formbuy where ipv='+ Quotedstr(ipcomp));
  SellTxtSubTotal.Value := SubTotal;
  CalculateBuy;

{  valamat:=''; vkota :='';
  DataModule1.ZQryUtil.Close;
  DataModule1.ZQryUtil.SQL.Text := 'select alamat,kota from supplier where kode=' + Quotedstr(cb_kode_supplier.Text);
  DataModule1.ZQryUtil.Open;
  if DataModule1.ZQryUtil.Fields[0].Isnull=false then valamat := DataModule1.ZQryUtil.Fields[0].AsString;
  if DataModule1.ZQryUtil.Fields[1].Isnull=false then vkota   := DataModule1.ZQryUtil.Fields[1].AsString;
  DataModule1.ZQryUtil.Close;
 }
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update buymaster set ');
    SQL.Add('noinvoice=' +QuotedStr(trim(SellTxtNoInvoice.Text)) + ',');
    SQL.Add('tanggal=' + QuotedStr(FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date)) + ',');
    SQL.Add('tgljatuhtempo=' +QuotedStr(FormatDateTime('yyyy-MM-dd',BuyTxtTglJatuhTempo.Date)) + ',');
    SQL.Add('tempohari=' + QuotedStr(FloatToStr(edtnum_tempohari.Value)) + ',');
    SQL.Add('pembayaran=' + QuotedStr(SellTxtpembayaran.Text) + ',');
    vwkt := FormatDateTime('hh:nn:ss',Now);
    SQL.Add('waktu=' + QuotedStr(vwkt) + ',');
    SQL.Add('kasir=' +QuotedStr(UserName) + ',');
    SQL.Add('kodesupplier=' +QuotedStr(vkodesupp) + ',');
    SQL.Add('supplier=' + QuotedStr(SellTxtsupplier.Text) + ',');
    SQL.Add('alamat=' + QuotedStr(valamat) + ',');
    SQL.Add('kota=' +QuotedStr(vkota) + ',');
    SQL.Add('subtotal=' +QuotedStr(FloatToStr(SellTxtSubTotal.Value)) + ',');
    SQL.Add('ppn=' +QuotedStr(FloatToStr(SellTxtPPN.Value)) + ',');
    SQL.Add('diskonrp=' +QuotedStr(FloatToStr(SellTxtDiscRp.Value)) + ',');
    SQL.Add('grandtotal=' +QuotedStr(FloatToStr(SellTxtGrandTotal.Value)) + ',');
    SQL.Add('isposted=0,');
    SQL.Add('IDuserposted=' +QuotedStr(inttostr(IDuserlogin)) + ',');
    if DataModule1.ZQrybuymastertotalpayment.Value>=SellTxtGrandTotal.Value then
    SQL.Add('lunas=1 ') else SQL.Add('lunas=0 ');
    SQL.Add('where faktur=' + Quotedstr(DataModule1.ZQrybuymasterfaktur.Value));
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from buydetail ');
    SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQrybuymasterfaktur.Value) );
    ExecSQL;
  end;

    DataModule1.ZConnection1.ExecuteDirect('update formbuy o, product p set o.faktur='+Quotedstr(SellTxtNo.Text)+', o.satuan=p.satuan where (o.kode=p.kode) and (o.ipv='+Quotedstr(ipcomp)+') ');

    idTrans := DataModule1.ZQrybuymasteridbeli.AsString;

    DataModule1.ZConnection1.ExecuteDirect('insert into buydetail '+
    '(idbeli,faktur,kode,nama,kategori,merk,tipe,seri,barcode,hargabeli,harganondiskon,quantity,diskon,diskon2,satuan,subtotal) '+
    'select '+Quotedstr(idTrans)+',faktur,kode,nama,kategori,merk,tipe,seri,barcode,harga,harganondiskon,quantity,diskon,diskon2,satuan,subtotal from formbuy where ipv='+ Quotedstr(ipcomp));

    DataModule1.ZConnection1.ExecuteDirect('delete from inventory where faktur=' + Quotedstr(SellTxtNo.Text) + ' and typetrans=' + Quotedstr('pembelian') );

    ///Input Inventory
    DataModule1.ZConnection1.ExecuteDirect('insert into inventory ' +
    '(kodebrg,qty,satuan,hargabeli,hargajual,faktur,keterangan,typetrans,idTrans,username,tglTrans,waktu,kodeGudang) ' +
    'select kode,quantity,satuan,harga,harganondiskon,faktur,'+Quotedstr('Invoice No.'+SellTxtNoInvoice.Text+' '+SellTxtsupplier.Text)+',''pembelian'','''+idTrans+''',' + QuotedStr(UserName) + ',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + vwkt + ''',''' + KodeGudang + ''' from formbuy where ipv=' + Quotedstr(ipcomp) );

end;

procedure TfrmBuy.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryformbuy.Close;
  DataModule1.ZQryformbuy.SQL.Text := 'select * from formbuy where ipv='+Quotedstr(ipcomp)+' order by kode ';

  if SellLblCaption.Caption = 'Input Pembelian' then
  begin
    ClearForm;
  end
  else
  begin
    ClearForm;

    SellTxtCetak.Checked := true;

    SellTxtNo.Text := DataModule1.ZQrybuymasterfaktur.Value;
    SellTxtTgl.Date := DataModule1.ZQrybuymastertanggal.Value;

    vkodesupp := DataModule1.ZQrybuymasterkodesupplier.Value;
    vIDsupp := strtoint(getdata('IDsupplier','supplier where kode='+Quotedstr(vkodesupp)));
    SellTxtsupplier.Text := DataModule1.ZQrybuymastersupplier.Value;
    valamat := DataModule1.ZQrybuymasteralamat.Value;
    vkota   := DataModule1.ZQrybuymasterkota.Value;
    sellTxtalamat.Clear;
    sellTxtalamat.Lines.Add(valamat);
    sellTxtalamat.Lines.Add(vkota);


    SellTxtNoInvoice.Text := DataModule1.ZQryBuyMasternoinvoice.Value;

    SellTxtSubTotal.Value := DataModule1.ZQryBuyMastersubtotal.Value;

    ccx_isppn.Checked := DataModule1.ZQryBuyMasterppn.Value<>0;

    SellTxtPPN.Value := DataModule1.ZQryBuyMasterppn.Value;

    SellTxtDiscRp.Value := DataModule1.ZQryBuyMasterdiskonrp.Value;

    SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',DataModule1.ZQrybuymastergrandtotal.Value);
    SellTxtGrandTotal.Value := DataModule1.ZQrybuymastergrandtotal.Value;

    SellTxtpembayaran.itemindex := SellTxtpembayaran.items.IndexOf(DataModule1.ZQryBuyMasterpembayaran.Value);

    if DataModule1.ZQryBuyMastertgljatuhtempo.IsNull=false then BuyTxtTglJatuhTempo.Date := DataModule1.ZQryBuyMastertgljatuhtempo.Value;

    edtnum_tempohari.value := DataModule1.ZQryBuyMastertempohari.Value;

    oldTotal := DataModule1.ZQrybuymastergrandtotal.Value;

    ClearTabel('formbuy where ipv='+ quotedstr(ipcomp) );
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into formbuy ');
      SQL.Add('(ipv,kode,nama,harga,harganondiskon,quantity,diskon,diskon2,subtotal,');
      SQL.Add('faktur,kategori,merk,barcode,satuan,seri,tipe)');
      SQL.Add('select '+Quotedstr(ipcomp)+',kode,nama,hargabeli,harganondiskon,quantity,');
      SQL.Add('diskon,diskon2,subtotal,');
      SQL.Add('faktur,kategori,merk,barcode,satuan,seri,tipe from buydetail');
      SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQrybuymasterfaktur.Text) );
      ExecSQL;
    end;
    RefreshTabel(DataModule1.ZQryformbuy);
//    SubTotal := DataModule1.ZQrybuymastersubtotal.Value;
  end;
end;

procedure TfrmBuy.SellBtnAddClick(Sender: TObject);
begin
 if DataModule1.ZQryFormbuy.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if SellTxtNoInvoice.Text='' then
 begin
  errordialog('No. Invoice tidak boleh kosong!');
  exit;
 end;

 if (SellLblCaption.Caption = 'Input Pembelian')and(isdataexist('select idBeli from buymaster where isposted=1 and noinvoice=' + Quotedstr(SellTxtNoInvoice.Text))) then
 begin
  errordialog('No. Invoice sudah terdaftar!');
  exit;
 end;

 if (SellLblCaption.Caption = 'Edit Pembelian')and(isdataexist('select idBeli from buymaster where isposted=1 and faktur<>'+ Quotedstr(trim(SellTxtNo.Text)) +' and noinvoice=' + Quotedstr(SellTxtNoInvoice.Text))) then
 begin
  errordialog('No. Invoice sudah terdaftar!');
  exit;
 end;

 if (SellTxtpembayaran.ItemIndex=1) and ((BuyTxtTglJatuhTempo.Text='')or(BuyTxtTglJatuhTempo.Date<SellTxtTgl.date)) then
 begin
  errordialog('Tgl Jatuh Tempo harus diisi dengan benar!');
  exit;
 end;

  CetakFaktur := SellTxtNo.Text;
  DataModule1.ZQryformbuy.CommitUpdates;

  DataModule1.ZQryformbuy.First;
  while not DataModule1.ZQryformbuy.Eof do
  begin
   if (DataModule1.ZQryformbuy.State <> dsInsert) or (DataModule1.ZQryformbuy.State <> dsEdit) then
       DataModule1.ZQryformbuy.Edit;

   if (DataModule1.ZQryformbuy.IsEmpty=false)and(BuyDBGrid.Fields[10].IsNull=false) then
   begin
 //   BuyDBGrid.Fields[9].AsFloat := round(BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * (1-(0.01*BuyDBGrid.Fields[7].AsFloat)))
     BuyDBGrid.Fields[9].AsFloat := (BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat)-round((BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * BuyDBGrid.Fields[7].AsFloat * 0.01)+(((BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat) - (BuyDBGrid.Fields[4].AsFloat * BuyDBGrid.Fields[5].AsFloat * BuyDBGrid.Fields[7].AsFloat * 0.01)) * BuyDBGrid.Fields[8].AsFloat * 0.01));
   end;

   DataModule1.ZQryformbuy.CommitUpdates;
   DataModule1.ZQryformbuy.Next;
  end;

  Subtotal := getDatanum('sum(subtotal)','formbuy where ipv='+ quotedstr(ipcomp));
  SellTxtSubTotal.Value := SubTotal;
  Calculatebuy;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select faktur from formbuy ');
    SQL.Add('where ipv='+Quotedstr(ipcomp)+' and quantity <= 0 ');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Nilai tidak boleh kosong!');
      Exit;
    end;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    if (SellLblCaption.Caption = 'Input Pembelian') then InsertDataMaster else updatedata;
    PostingJual(CetakFaktur);

    if (SellLblCaption.Caption = 'Input Pembelian') then
     LogInfo(UserName,'Insert Pembelian Faktur No: ' + SellTxtNo.Text + ',Total: ' + FloatToStr(SellTxtGrandTotal.Value))
    else LogInfo(UserName,'Update Pembelian Faktur No: ' + SellTxtNo.Text + ',Total: ' + FloatToStr(SellTxtGrandTotal.Value));

//    printbarcode;

    DataModule1.ZConnection1.Commit;

    PrintStruck(CetakFaktur);
    ClearForm;
    BuyDBGrid.SetFocus;

    if (SellLblCaption.Caption = 'Edit Pembelian') then
    begin
     InfoDialog('Berhasil Posting!');
     close;
    end
    else InfoDialog('Berhasil Posting, silakan bila hendak Pembelian/Input Barang Masuk lagi!');
  except
    DataModule1.ZConnection1.Rollback;
    if (SellLblCaption.Caption = 'Edit Pembelian') then
    begin
     ErrorDialog('Gagal Posting, coba ulangi Edit Pembelian/Barang Masuk lagi!');
     close;
    end
    else
    begin
     DataModule1.ZConnection1.ExecuteDirect('call p_cancelbuy('+QuotedStr(CetakFaktur)+')');
     ErrorDialog('Gagal Posting, coba ulangi buat Pembelian/Input Barang Masuk lagi!');
     ClearForm;
     BuyDBGrid.SetFocus

    end;
  end;

{  end
  else
  begin
    UpdateData;
    if SellTxtCetak.Checked = True then
    begin
      PostingJual(CetakFaktur);
      PrintStruck(CetakFaktur);
    end;
    InfoDialog('Edit Pembelian Faktur No. ' + SellTxtNo.Text + ' berhasil');
    LogInfo(UserName,'Edit Pembelian Faktur No. ' + SellTxtNo.Text + ', Old Total: ' + FloatToStr(OldTotal) + ' New Total: ' + FloatToStr(SellTxtGrandTotal.Value));
    Close;
  end;     }
//  RefreshTabel(DataModule1.ZQrybuymaster);
end;

procedure TfrmBuy.SellBtnDelClick(Sender: TObject);
begin
 if SellLblCaption.Caption = 'Input Pembelian' then ClearForm else close;
end;

procedure TfrmBuy.BuyDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
   if (SellTxtNoInvoice.Text='')or(vkodesupp='') then
   begin
    errordialog('Input Data No. Invoice dan Supplier dulu!');
    SellTxtsupplier.SetFocus;
    exit;
   end;

   frmSrcProd.formSender := frmbuy;
   frmSrcProd.ShowModal;

   frmhistoryBS.transmode := 0;
   frmhistoryBS.kodebrg := DataModule1.ZQryFormBuykode.Value;
   frmhistoryBS.namabrg := DataModule1.ZQryFormBuynama.Value;
   frmhistoryBS.ShowModal;

  end;

 if Key = VK_F3 then
 begin
  frmSrcSupp.formSender := frmbuy;
  frmSrcSupp.ShowModal;
 end;

  if Key = VK_F2 then
  begin
   IF Frmprod=nil then
   application.CreateForm(TFrmprod,Frmprod);
   Frmprod.Align:=alclient;
   Frmprod.Parent:=self.parent;
   Frmprod.BorderStyle:=bsnone;
   frmProd.ProdLblCaption.Caption := 'Tambah Item';
   Frmprod.Tag := 1;
   Frmprod.FormShowFirst;
   Frmprod.Show;
  end;

  if Key = VK_F5 then SellBtnAddClick(sender);
  if Key = VK_F9 then SellBtnDelClick(sender);

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_TAB]) then
  begin
      DataModule1.ZQryformbuy.CommitUpdates;
      CalculateGridSell;
    if BuyDBGrid.SelectedIndex = 8 then
    begin
      DataModule1.ZQryformbuy.Append;
      BuyDBGrid.SelectedIndex := 4;
    end;
  end
  else if (Key=VK_DOWN) then
  begin
      DataModule1.ZQryformbuy.CommitUpdates;
      CalculateGridSell;
      DataModule1.ZQryformbuy.Append;
      BuyDBGrid.SelectedIndex := 4;
  end;

  if (Key in [VK_DELETE]) then
  begin
    SubTotal := SubTotal - DataModule1.ZQryformbuysubtotal.Value;
    DataModule1.ZQryformbuy.Delete;
    CalculateGridSell;
  end;
end;

procedure TfrmBuy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQryformbuy.Close;

 if SellLblCaption.Caption = 'Edit Pembelian' then
 begin
  DataModule1.ZQrybuymaster.Close;
  DataModule1.ZQrybuymaster.Open;
  DataModule1.ZQrybuymaster.Locate('faktur',SellTxtNo.Text,[]);

  Frmbuymaster.Show;
 end;

end;

procedure TfrmBuy.FormShow(Sender: TObject);
begin
// FormShowFirst;
  BuyDBGrid.SetFocus

end;

procedure TfrmBuy.SellTxtpembayaranChange(Sender: TObject);
begin
 BuyTxtTglJatuhTempo.enabled  := SellTxtpembayaran.ItemIndex=1 ;
 edtnum_tempohari.enabled   := BuyTxtTglJatuhTempo.enabled;

end;

procedure TfrmBuy.BuyTxtTglJatuhTempoChange(Sender: TObject);
begin
 if BuyTxtTglJatuhTempo.Text='' then edtnum_tempohari.value:=0;

 edtnum_tempohari.value := DaysBetween(SellTxtTgl.date, BuyTxtTglJatuhTempo.date);

end;

procedure TfrmBuy.ccx_isppnClick(Sender: TObject);
begin
 calculatebuy;

 if ccx_isppn.checked then SellTxtNo.Text := getNoFakturJual else SellTxtNo.Text := getNoFakturJual;
end;

procedure TfrmBuy.inputkodebarcode(nilai:string);
var bufstr : string;
    vhrgpromodiskon,vqty : double;
begin
  bufstr := trim(nilai);

  if bufstr='' then exit;

   DataModule1.ZQrySearchProduct.Close;
   DataModule1.ZQrySearchProduct.SQL.Strings[0] := 'select p.*,cast("" as char(20)) faktur,p.'+kodegudang+' qty,p.'+kodegudang+'T qtytoko,p.'+kodegudang+'R qtybad,null kategori from product p ';
   DataModule1.ZQrySearchProduct.SQL.Strings[1] := '';
   DataModule1.ZQrySearchProduct.SQL.Strings[2] := 'where (p.kode='+Quotedstr(bufstr)+')or(p.barcode='+Quotedstr(bufstr)+')';
   DataModule1.ZQrySearchProduct.Open;

   if DataModule1.ZQrySearchProduct.IsEmpty then infodialog('Barang Kosong')
   else
   begin
    if DataModule1.ZQryFormbuy.Locate('kode',DataModule1.ZQrySearchProductkode.Value,[]) then
    begin
     DataModule1.ZQryFormbuy.Edit;
     vqty := DataModule1.ZQryFormbuyquantity.Value + 1;
     DataModule1.ZQryFormbuyquantity.Value := DataModule1.ZQryFormbuyquantity.Value + 1;

    end
    else
    begin
     if DataModule1.ZQryFormbuy.State <> dsEdit then DataModule1.ZQryFormbuy.Append
     else
     begin
      DataModule1.ZQryFormbuy.CommitUpdates;
      CalculateGridSell;
      DataModule1.ZQryFormbuy.CommitUpdates;
      DataModule1.ZQryFormbuy.Append;
     end;
    DataModule1.ZQryFormBuyfaktur.Value := SellTxtNo.Text;
    DataModule1.ZQryFormBuykode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryFormBuynama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryFormBuyharga.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryFormBuyharganondiskon.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryFormBuykategori.Value := DataModule1.ZQrySearchProductkategori.Value;
    DataModule1.ZQryFormbuymerk.Value := DataModule1.ZQrySearchProductmerk.Value;
    DataModule1.ZQryFormbuyseri.Value := DataModule1.ZQrySearchProductseri.Value;
    DataModule1.ZQryFormbuysatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryFormBuybarcode.Value := DataModule1.ZQrySearchProductbarcode.Value;
    DataModule1.ZQryFormBuyquantity.Value := 1;
    DataModule1.ZQryFormbuyipv.Value    := ipcomp;
    end;

    DataModule1.ZQryFormbuy.CommitUpdates;
    CalculateGridSell;
    DataModule1.ZQryFormbuy.CommitUpdates;

    BuyDBGrid.SetFocus;
    BuyDBGrid.SelectedIndex := 5;
   end;

   DataModule1.ZQrySearchProduct.Close;
end;

procedure TfrmBuy.edt_kodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
 VK_RETURN : if (Sender=TRzEdit(edt_kode)) then
             begin
              inputkodebarcode(edt_kode.Text);
              edt_kode.Text:='';
              BuyDBGrid.SetFocus;
             end;

 VK_F1 :     begin
              if (SellTxtNoInvoice.Text='')or(vkodesupp='') then
              begin
               errordialog('Input Data No. Invoice dan Supplier dulu!');
               SellTxtsupplier.SetFocus;
               exit;
              end;
              frmSrcProd.formSender := frmBuy;
              frmSrcProd.ShowModal;
             end;

 VK_F2 :     begin
              IF Frmprod=nil then application.CreateForm(TFrmprod,Frmprod);
              Frmprod.Align:=alclient;
              Frmprod.Parent:=self.parent;
              Frmprod.BorderStyle:=bsnone;
              frmProd.ProdLblCaption.Caption := 'Tambah Item';
              Frmprod.Tag := 1;
              Frmprod.FormShowFirst;
              Frmprod.Show;
             end;

 VK_F5 : SellBtnAddClick(sender);
 VK_F9 : SellBtnDelClick(sender);

 end;

end;

procedure TfrmBuy.SellTxtDiscRpChange(Sender: TObject);
begin
 calculatebuy;
end;

end.
