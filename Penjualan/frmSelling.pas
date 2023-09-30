unit frmSelling;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk;

type
  TfrmSell = class(TForm)
    PanelSell: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    RzStatusPane1: TRzStatusPane;
    RzLabel9: TRzLabel;
    SellLblGrandTotal: TRzLabel;
    RzPanel1: TRzPanel;
    RzLabel11: TRzLabel;
    SellBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    SellTxtPembayaran: TRzComboBox;
    RzPanel3: TRzPanel;
    RzLabel13: TRzLabel;
    SellTxtNo: TRzEdit;
    RzLabel15: TRzLabel;
    SellTxtTgl: TRzDateTimeEdit;
    PenjualanDBGrid: TRzDBGrid;
    RzPanel4: TRzPanel;
    RzLabel1: TRzLabel;
    SellTxtSubTotal: TRzNumericEdit;
    RzLabel2: TRzLabel;
    SellTxtPPN: TRzNumericEdit;
    RzLabel3: TRzLabel;
    SellTxtTotal: TRzNumericEdit;
    SellTxtDisc: TRzNumericEdit;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    SellTxtDiscRp: TRzNumericEdit;
    RzLabel6: TRzLabel;
    SellTxtGrandTotal: TRzNumericEdit;
    RzPanel5: TRzPanel;
    RzLabel7: TRzLabel;
    SellTxtKembali: TRzNumericEdit;
    SellTxtCetak: TRzCheckBox;
    SellPanelCredit: TRzPanel;
    RzLabel16: TRzLabel;
    SellTxtTempo: TRzDateTimeEdit;
    RzLabel10: TRzLabel;
    SellTxtDibayar: TRzNumericEdit;
    SellLblNoCredit: TRzLabel;
    SellTxtNoCredit: TRzEdit;
    RzLabel18: TRzLabel;
    cbxP1: TRzCheckBox;
    cbxP2: TRzCheckBox;
    SellTxtSales: TRzEdit;
    RzPanel7: TRzPanel;
    RzLabel20: TRzLabel;
    sellTxtalamat: TRzMemo;
    SellTxtCustomer: TRzEdit;
    RzGroupBox1: TRzGroupBox;
    mem_notes: TRzMemo;
    procedure FormShow(Sender: TObject);
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure PenjualanDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellTxtPPNChange(Sender: TObject);
    procedure SellTxtDiscChange(Sender: TObject);
    procedure SellTxtDibayarChange(Sender: TObject);
    procedure SellTxtPembayaranChange(Sender: TObject);
    procedure SellTxtTempoChange(Sender: TObject);
  private
    oldTotal: Double;
    procedure FillCombo;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    procedure CekMaxStock;
    procedure CalculateSell;
    procedure CalculateGridSell;
    procedure PostingJual(Faktur: string);
    { Private declarations }
  public
    SubTotal : Double;
    CetakFaktur,vkodecust,vkodesales,valamat,vkota: string;
    vidcust : integer;
    isclearsellmaster : boolean;
    { Public declarations }
  end;

var
  frmSell: TfrmSell;

implementation

uses uMain, SparePartFunction, Data, DB, frmSearchProduct, Math,
  StrUtils, frmhistorybuysell, sellmaster, frmSearchCust;

{$R *.dfm}

procedure TfrmSell.CekMaxStock;
begin
  if (DataModule1.ZQryFormSell.State <> dsInsert) or (DataModule1.ZQryFormSell.State <> dsEdit) then
    DataModule1.ZQryFormSell.Edit;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select UT from product');
    SQL.Add('where kode = ' + QuotedStr(DataModule1.ZQryFormSellkode.Value));
    Open;
    if DataModule1.ZQryFormSellquantity.AsInteger > DataModule1.ZQryFunction.Fields[0].AsInteger then
    begin
      WarningDialog('Jumlah Stock Maksimum adalah ' + Fields[0].AsString);
//      DataModule1.ZQryFormSellquantity.AsInteger := DataModule1.ZQryFunction.Fields[0].AsInteger;
    end;
  end;
end;

procedure TfrmSell.CalculateSell;
begin
  with frmSell do
  begin
    SellTxtTotal.Value := SellTxtSubTotal.Value - SellTxtPPN.Value;
    SellTxtGrandTotal.Value := SellTxtTotal.Value - SellTxtDiscRp.Value;
    SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',SellTxtGrandTotal.Value);
    SellTxtKembali.Value := SellTxtDibayar.Value - SellTxtGrandTotal.Value;
    if SellTxtKembali.Value<0 then SellTxtKembali.Value:=0;
  end;
end;

procedure TfrmSell.CalculateGridSell;
begin
  if (DataModule1.ZQryFormSell.State <> dsInsert) or (DataModule1.ZQryFormSell.State <> dsEdit) then
    DataModule1.ZQryFormSell.Edit;
  with frmSell do
  begin

    if DataModule1.ZQryFormSellidstts.AsInteger=0 then
    begin
     if DataModule1.ZQryFormSellsubtotal.AsFloat <> 0 then SubTotal := SubTotal - DataModule1.ZQryFormSellsubtotal.AsFloat;

     DataModule1.ZQryFormSelltotalharga.AsInteger := DataModule1.ZQryFormSellharga.AsInteger * DataModule1.ZQryFormSellquantity.AsInteger;
     DataModule1.ZQryFormSelldiskonrp.AsFloat := (DataModule1.ZQryFormSelltotalharga.AsFloat * DataModule1.ZQryFormSelldiskon.AsFloat * 0.01)+((DataModule1.ZQryFormSelltotalharga.AsFloat - (DataModule1.ZQryFormSelltotalharga.AsFloat * DataModule1.ZQryFormSelldiskon.AsFloat * 0.01)) * DataModule1.ZQryFormSelldiskon2.AsFloat * 0.01);
     DataModule1.ZQryFormSellsubtotal.AsFloat := DataModule1.ZQryFormSelltotalharga.AsFloat - DataModule1.ZQryFormSelldiskonrp.AsFloat;

     DataModule1.ZQryFormSellvsubtotal.AsString := formatfloat(',0;(,0)',DataModule1.ZQryFormSellsubtotal.AsFloat);
    end
    else if DataModule1.ZQryFormSellidstts.AsInteger>0 then
    begin
     DataModule1.ZQryFormSelltotalharga.Asfloat := 0;
     DataModule1.ZQryFormSelldiskon.Asfloat := 0;
     DataModule1.ZQryFormSelldiskon2.Asfloat := 0;
     DataModule1.ZQryFormSelldiskonrp.Asfloat := 0;
     DataModule1.ZQryFormSellsubtotal.Asfloat := 0;

     if DataModule1.ZQryFormSellidstts.Asinteger=1 then DataModule1.ZQryFormSellvsubtotal.AsString := 'FREE'
     else if DataModule1.ZQryFormSellidstts.Asinteger=2 then DataModule1.ZQryFormSellvsubtotal.AsString := 'TUKAR';
    end;

    SubTotal := SubTotal + DataModule1.ZQryFormSellsubtotal.AsFloat;
    SellTxtSubTotal.Value := SubTotal;
    CalculateSell;
  end;
end;

procedure TfrmSell.PostingJual(Faktur: string);
var
  FakturBaru,idTrans,GrandTotal,typebayar,totpayment,vtgl,vwaktu: string;
  islunas: integer;
begin
  with FrMain do
  begin
    ///Ganti No Faktur temp dengan yang asli...
    ///Format NO FAKTUR TEMP : MSyy/MM/dd-hhmmss
    ///Format NO FAKTUR ASLI : MSP/Tahun 2 digit/Bulan 2 Digit disambung kode urut (MSP/09/110001)
    with DataModule1.ZQrySearch do
    begin
      FakturBaru := Faktur;
      frmSell.CetakFaktur := FakturBaru;

      Close;
      SQL.Clear;
      SQL.Add('select * from sellmaster');
      SQL.Add('where faktur = ''' + Faktur + '''');
      Open;

      idTrans := FieldByName('idSell').AsString;
      if idTrans = '' then idTrans := '0';
      islunas := FieldByName('lunas').AsInteger;
      totpayment := FieldByName('totalpayment').AsString;
      typebayar  := FieldByName('pembayaran').AsString;
      GrandTotal := FieldByName('grandtotal').AsString;
      vtgl       := Formatdatetime('yyyy-mm-dd',FieldByName('tanggal').Asdatetime);
      vwaktu     := Formatdatetime('hh:nn:ss',FieldByName('waktu').Asdatetime);
    end;

    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update selldetail set');
      SQL.Add('faktur = ''' + FakturBaru + '''');
      SQL.Add('where faktur = ''' + Faktur + '''');
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('update sellmaster set');
      SQL.Add('isposted = ''' + '1' + ''',');
      SQL.Add('faktur = ''' + FakturBaru + '''');
      SQL.Add('where faktur = ''' + Faktur + '''');
      ExecSQL;

      ///Input Inventory
{      Close;
      SQL.Clear;
      SQL.Add('insert into inventory ');
      SQL.Add('(kodebrg,qty,satuan,faktur,typetrans,idTrans,tglTrans,kodeGudang) ');
      SQL.Add('select kode,(quantity * -1),satuan,faktur,''penjualan'','''+idTrans+''',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + KodeGudang + ''' from selldetail ');
      SQL.Add('where faktur = ''' + FakturBaru + '''');
      ExecSQL;      }

      ///Input Operasional
      if (typebayar = 'TUNAI')or(typebayar = 'BG') then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into operasional');
        SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
        SQL.Add('(''' + idTrans + ''',');
        SQL.Add('''' + FakturBaru + ''',');
        SQL.Add('''' + vtgl + ''',');
        SQL.Add('''' + vwaktu + ''',');
        SQL.Add('''' + UserName + ''',');
        SQL.Add('''' + 'PENJUALAN' + ''',');
        if islunas=1 then SQL.Add('''' + 'LUNAS ' + ''',')
        else SQL.Add('''' + 'DP ' + ''',');
        SQL.Add('''' + totpayment + ''')');
        ExecSQL;
      end;

      LogInfo(UserName,'Posting transaksi penjualan, no faktur : ' + FakturBaru + ', nilai transaksi:' + GrandTotal);
      InfoDialog('Faktur ' + Faktur + ' berhasil diposting !');
    end;
  end;
end;

procedure TfrmSell.FillCombo;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryFormSell.Close;
  DataModule1.ZQryFormSell.SQL.Text := 'select * from formsell where ipv='+ Quotedstr(ipcomp) + ' order by kode ';

  cbxP1.Checked := false;
  cbxP2.Checked := false;
end;

procedure TfrmSell.ClearForm;
begin
  SellTxtCetak.Checked := false;

  ClearTabel('formsell where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQryFormSell);
  SellTxtNo.Text :=  'LJ' + FormatDateTime('yy/MM/dd-hhmmss',Now);
  SellTxtTgl.Date := TglSkrg;
  SellLblGrandTotal.Caption := 'Rp 0';
  SellTxtSubTotal.Value := 0;
  SellTxtPPN.Value := 0;
  SellTxtTotal.Value := 0;
  SellTxtDisc.Value := 0;
  SellTxtDiscRp.Value := 0;
  SellTxtGrandTotal.Value := 0;
  SellTxtPembayaran.ItemIndex := 1;
  SellTxtDibayar.Value := 0;
  SellTxtKembali.Value := 0;
  SellTxtNoCredit.Clear;
  SellTxtTempo.Date := incday(TglSkrg,30);
  SellTxtPembayaranchange(SellTxtPembayaran);

  vidcust := -1;
  vkodecust := '';
  valamat := '';
  vkota   := '';
  SellTxtCustomer.Text := '';
  sellTxtalamat.Text :='';

  vkodesales := '';
  SellTxtSales.Text := '';

  mem_notes.Text := '';

  SellTxtCustomer.SetFocus;
  SubTotal := 0;
end;

procedure TfrmSell.InsertDataMaster;
var idTrans,vfaktur: string;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;

    idTrans := inttostr(getNewUniqueID('idsell','sellmaster'));

    SQL.Add('insert into sellmaster');
    SQL.Add('(idsell,faktur,tanggal,waktu,kasir,IDcustomer,kodecustomer,customer,alamat,kota,notes,');
    SQL.Add('pembayaran,nogiro,tgljatuhtempo,subtotal,ppn,total,diskon,diskonrp,');
    SQL.Add('grandtotal,bayar,kembali,kodesales,namasales,totalpayment,isposted,lunas) values');
    SQL.Add('(''' + idTrans + ''',');
    SQL.Add('''' + SellTxtNo.Text + ''',');
    SQL.Add('''' + FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date) + ''',');
    SQL.Add('''' + FormatDateTime('hh:mm:ss',Now) + ''',');
    SQL.Add(QuotedStr(UserName) + ',');
    SQL.Add(QuotedStr(Inttostr(vIDcust)) + ',');
    SQL.Add(QuotedStr(vkodecust) + ',');
    SQL.Add(QuotedStr(SellTxtCustomer.Text) + ',');
    SQL.Add(QuotedStr(valamat) + ',');
    SQL.Add(QuotedStr(vkota) + ',');
    SQL.Add(QuotedStr(mem_notes.Text) + ',');
    SQL.Add('''' + SellTxtPembayaran.Text + ''',');
    SQL.Add('''' + SellTxtNoCredit.Text + ''',');
    SQL.Add('''' + FormatDateTime('yyyy-MM-dd',SellTxtTempo.Date) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtSubTotal.Value) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtPPN.Value) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtTotal.Value) + ''',');
    SQL.Add('''' + AnsiReplaceText(FloatToStr(SellTxtDisc.Value),',','.') + ''',');
    SQL.Add('''' + FloatToStr(SellTxtDiscRp.Value) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtGrandTotal.Value) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtDibayar.Value) + ''',');
    SQL.Add('''' + FloatToStr(SellTxtKembali.Value) + ''',');
    SQL.Add(QuotedStr(vKodesales) + ',');
    SQL.Add(QuotedStr(SellTxtSales.Text) + ',');
    SQL.Add('''' + FloatToStr(SellTxtDibayar.Value - SellTxtKembali.Value) + ''',');
    SQL.Add('''' + '0' + ''',');
    if (SellTxtDibayar.Value - SellTxtKembali.Value)>=SellTxtGrandTotal.Value then
      SQL.Add('''' + '1' + ''')')
    else
      SQL.Add('''' + '0' + ''')');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Text := 'select faktur from sellmaster where idsell='+ idTrans;
    Open;
    vfaktur := Fields[0].AsString;

    Close;
    SQL.Clear;
    SQL.Add('insert into selldetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,tipe,seri,hargajual,diskon,diskon2,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan,kodepromo,idstts,idsell,subtotal,vsubtotal)');
    SQL.Add('select '+Quotedstr(vfaktur)+',kode,nama,kategori,merk,tipe,seri,harga,diskon,diskon2,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan,getKodePromo('+QuotedStr(vKodeCust)+',kode),idstts,'''+idTrans+''',subtotal,vsubtotal from formsell where ipv='+Quotedstr(ipcomp));
    ExecSQL;

    DataModule1.ZConnection1.ExecuteDirect('update selldetail o set o.satuan=(select satuan from product where kode=o.kode) where (o.faktur="'+ SellTxtNo.Text +'") and ((o.satuan="") or (o.satuan is null))');

    DataModule1.ZConnection1.ExecuteDirect('update sellmaster set isposted=1 where idsell=' + idTrans);

    ///Input Inventory
{    Close;
    SQL.Clear;
    SQL.Add('insert into inventory ');
    SQL.Add('(kodebrg,qty,satuan,faktur,typetrans,idTrans,tglTrans,kodeGudang) ');
    SQL.Add('select kode,(quantity * -1),satuan,faktur,''penjualan'','''+idTrans+''',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + KodeGudang + ''' from selldetail ');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;             }
  end;

  ///Jika cetak maka langsung diposting / dibuat final (tidak bisa dihapus lagi)
  if SellTxtCetak.Checked = True then
  begin

  end;
end;

procedure TfrmSell.UpdateData;
var idTrans: string;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update sellmaster set ');
//    SQL.Add('tanggal = ''' + FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date) + ''',');
//    SQL.Add('waktu = ''' + FormatDateTime('hh:mm:ss',Now) + ''',');
    SQL.Add('kasir = ' + QuotedStr(UserName) + ',');
    SQL.Add('IDcustomer = ' + QuotedStr(inttostr(vIDCust)) + ',');
    SQL.Add('kodecustomer = ' + QuotedStr(vKodeCust) + ',');
    SQL.Add('customer = ' + QuotedStr(SellTxtCustomer.Text) + ',');
    SQL.Add('alamat = ' + QuotedStr(valamat) + ',');
    SQL.Add('kota = ' + QuotedStr(vKota) + ',');
    SQL.Add('notes = ' + QuotedStr(mem_notes.Text) + ',');
    SQL.Add('kodesales = ' + QuotedStr(vKodesales) + ',');
    SQL.Add('namasales = ' + QuotedStr(SellTxtSales.text) + ',');
    SQL.Add('pembayaran = ''' + SellTxtPembayaran.Text + ''',');
    SQL.Add('nogiro = ''' + SellTxtNoCredit.Text + ''',');
    SQL.Add('tgljatuhtempo = ''' + FormatDateTime('yyyy-MM-dd',SellTxtTempo.Date) + ''',');
    SQL.Add('subtotal = ''' + FloatToStr(SellTxtSubTotal.Value) + ''',');
    SQL.Add('ppn = ''' + FloatToStr(SellTxtPPN.Value) + ''',');
    SQL.Add('total = ''' + FloatToStr(SellTxtTotal.Value) + ''',');
    SQL.Add('diskon = ''' + AnsiReplaceText(FloatToStr(SellTxtDisc.Value),',','.') + ''',');
    SQL.Add('diskonrp = ''' + FloatToStr(SellTxtDiscRp.Value) + ''',');
    SQL.Add('grandtotal = ''' + FloatToStr(SellTxtGrandTotal.Value) + ''',');
    SQL.Add('bayar = ''' + FloatToStr(SellTxtDibayar.Value) + ''',');
    SQL.Add('kembali = ''' + FloatToStr(SellTxtKembali.Value) + ''',');
    SQL.Add('isposted = 0,');
    SQL.Add('totalpayment = ''' + FloatToStr(SellTxtDibayar.Value - SellTxtKembali.Value) + ''',');
    if (SellTxtDibayar.Value - SellTxtKembali.Value)>=SellTxtGrandTotal.Value then
      SQL.Add('lunas = ''' + '1' + '''')
    else
      SQL.Add('lunas = ''' + '0' + '''');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from selldetail');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Text := 'select idsell from sellmaster where faktur='''+ SellTxtNo.Text +'''';
    Open;
    idTrans := Fields[0].AsString;

    Close;
    SQL.Clear;
    SQL.Add('insert into selldetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,tipe,seri,hargajual,diskon,diskon2,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan,kodepromo,idstts,idsell,subtotal,vsubtotal)');
    SQL.Add('select faktur,kode,nama,kategori,merk,tipe,seri,harga,diskon,diskon2,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan,getKodePromo('+QuotedStr(vKodeCust)+',kode),idstts,'''+idTrans+''',subtotal,vsubtotal from formsell where ipv='+Quotedstr(ipcomp));
    ExecSQL;

    DataModule1.ZConnection1.ExecuteDirect('update selldetail o set o.satuan=(select satuan from product where kode=o.kode) where (o.faktur="'+ SellTxtNo.Text +'") and ((o.satuan="") or (o.satuan is null))');

    DataModule1.ZConnection1.ExecuteDirect('delete from inventory where faktur = ''' + SellTxtNo.Text + '''');
    DataModule1.ZConnection1.ExecuteDirect('delete from operasional where kategori=''PENJUALAN'' and faktur = ''' + SellTxtNo.Text + '''');


    DataModule1.ZConnection1.ExecuteDirect('update sellmaster set isposted=1 where faktur = ''' + SellTxtNo.Text + '''');

    ///Input Inventory
{    Close;
    SQL.Clear;
    SQL.Add('insert into inventory ');
    SQL.Add('(kodebrg,qty,satuan,faktur,typetrans,idTrans,tglTrans,kodeGudang) ');
    SQL.Add('select kode,(quantity * -1),satuan,faktur,''penjualan'','''+idTrans+''',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + KodeGudang + ''' from selldetail ');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;  }
  end;
end;

procedure TfrmSell.FormShow(Sender: TObject);
begin
  FillCombo;

  if SellLblCaption.Caption = 'Tambah Penjualan' then
  begin
    ClearForm;
  end
  else
  begin
    SellTxtCetak.Checked := false;

    ClearForm;
    SellTxtNo.Text := DataModule1.ZQrySellMasterfaktur.Value;
    SellTxtTgl.Date := DataModule1.ZQrySellMastertanggal.Value;
    vkodecust := DataModule1.ZQrysellmasterkodecustomer.Value;
    vIDcust := DataModule1.ZQrysellmasterIDcustomer.Value;
    SellTxtCustomer.Text := DataModule1.ZQrysellmastercustomer.Value;
    valamat := DataModule1.ZQrysellmasteralamat.Value;
    vkota   := DataModule1.ZQrysellmasterkota.Value;
    sellTxtalamat.Clear;
    sellTxtalamat.Lines.Add(DataModule1.ZQrysellmasteralamat.AsString);
    sellTxtalamat.Lines.Add(DataModule1.ZQrysellmasterkota.AsString);
    vkodesales := DataModule1.ZQrysellmasterkodesales.Value;
    SellTxtSales.Text := DataModule1.ZQrysellmasternamasales.Value;
    mem_notes.Text := DataModule1.ZQrysellmasternotes.Value;

    SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',DataModule1.ZQrySellMastergrandtotal.Value);
    SellTxtSubTotal.Value := DataModule1.ZQrySellMastersubtotal.Value;
    SellTxtPPN.Value := DataModule1.ZQrySellMasterppn.Value;
    SellTxtTotal.Value := DataModule1.ZQrySellMastertotal.Value;
    SellTxtDisc.Value := DataModule1.ZQrySellMasterdiskon.Value;
    SellTxtDiscRp.Value := DataModule1.ZQrySellMasterdiskonrp.Value;
    SellTxtGrandTotal.Value := DataModule1.ZQrySellMastergrandtotal.Value;
    IndexCombo(SellTxtPembayaran,DataModule1.ZQrySellMasterpembayaran.Value);
    SellTxtDibayar.Value := DataModule1.ZQrySellMasterbayar.Value;
    SellTxtKembali.Value := DataModule1.ZQrySellMasterkembali.Value;
    SellTxtNoCredit.Text := DataModule1.ZQrySellMasternogiro.Value;
    SellTxtTempo.Date := DataModule1.ZQrySellMastertgljatuhtempo.Value;
    SellTxtPembayaranChange(Self);

    oldTotal := DataModule1.ZQrySellMastergrandtotal.Value;

    ClearTabel('formsell where ipv='+Quotedstr(ipcomp));
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into formsell');
      SQL.Add('(kode,nama,harga,quantity,totalharga,satuan,diskon,diskon2,diskonrp,subtotal,vsubtotal,');
      SQL.Add('faktur,kategori,merk,tipe,seri,kodepromo,idstts,nomordet,ipv)');
      SQL.Add('select kode,nama,hargajual,quantity,quantity * hargajual,satuan,');
      SQL.Add('diskon,diskon2,diskonrp,subtotal,vsubtotal,');
      SQL.Add('faktur,kategori,merk,tipe,seri,kodepromo,idstts,nomordet,'+Quotedstr(ipcomp)+' from selldetail');
      SQL.Add('where faktur = ''' + DataModule1.ZQrySellMasterfaktur.Text + '''');
      ExecSQL;
    end;
    RefreshTabel(DataModule1.ZQryFormSell);

    SubTotal := DataModule1.ZQrySellMastersubtotal.Value;
  end;
end;

procedure TfrmSell.SellBtnAddClick(Sender: TObject);
begin
  CetakFaktur := SellTxtNo.Text;
  DataModule1.ZQryFormSell.CommitUpdates;

  if SellTxtCustomer.text = '' then
  begin
    ErrorDialog('Pelanggan belum dipilih/diisi !');
    SellTxtCustomer.SetFocus;
    Exit;
  end;

  if SellTxtSales.text = '' then
  begin
    ErrorDialog('Sales belum dipilih/diisi !');
    Exit;
  end;

{  if (SellTxtNoCredit.Visible = True) and (SellTxtNoCredit.Text = '') then
  begin
    ErrorDialog('No. ' + SellTxtPembayaran.Value+ ' belum diisi');
    SellTxtNoCredit.SetFocus;
    Exit;
  end;      }
  if (SellTxtNoCredit.Visible = false) then SellTxtNoCredit.Text := '';

{  if SellTxtDibayar.Value = 0 then
  begin
    ErrorDialog('Pembayaran belum diisi !');
    SellTxtDibayar.SetFocus;
    Exit;
  end;      }
  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select faktur from formsell ');
    SQL.Add('where quantity <= 0 and ipv='+Quotedstr(ipcomp));
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Nilai tidak boleh kosong!');
      Exit;
    end;
  end;

  if SellLblCaption.Caption = 'Tambah Penjualan' then
  begin
    InsertDataMaster;
    if SellTxtCetak.Checked = True then
    begin
      PostingJual(CetakFaktur);
      PrintStruck(CetakFaktur);
    end;
    LogInfo(UserName,'Insert Penjualan Faktur No: ' + SellTxtNo.Text + ',Total: ' + FloatToStr(SellTxtGrandTotal.Value));
    ClearForm;
  end
  else
  begin
    UpdateData;
    if SellTxtCetak.Checked = True then
    begin
      PostingJual(CetakFaktur);
      PrintStruck(CetakFaktur);
    end;
    InfoDialog('Edit Penjualan Faktur No. ' + SellTxtNo.Text + ' berhasil');
    LogInfo(UserName,'Edit Penjualan Faktur No. ' + SellTxtNo.Text + ', Old Total: ' + FloatToStr(OldTotal) + ' New Total: ' + FloatToStr(SellTxtGrandTotal.Value));

    if isclearsellmaster then Frmsellmaster.SellBtnClearClick(Sender) else Frmsellmaster.SellBtnSearchClick(Sender);
    Close;
  end;

end;

procedure TfrmSell.SellBtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSell.PenjualanDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var vnourut : integer;
begin
  if Key = VK_F1 then
  begin
    if trim(SellTxtCustomer.Text)='' then
    begin
     errordialog('Input Data Customer/Pelanggan dulu!');
     SellTxtCustomer.SetFocus;
     exit;
    end;
    frmSrcProd.formSender := frmSell;
    frmSrcProd.ShowModal;

    frmhistoryBS.transmode := 1;
    frmhistoryBS.kodecust := vkodecust;
    frmhistoryBS.namacust := SellTxtCustomer.Text;
    frmhistoryBS.kodebrg := DataModule1.ZQryFormSellkode.Value;
    frmhistoryBS.namabrg := DataModule1.ZQryFormSellnama.Value;
    frmhistoryBS.ShowModal;
  end;

 if Key = VK_F3 then
 begin
  frmSrcCust.formSender := frmSell;
  frmSrcCust.ShowModal;
 end;

  if Key = VK_F4 then
    SellTxtDibayar.SetFocus;
  if (Key in [VK_RETURN, VK_RIGHT, VK_TAB]) then
  begin
    if PenjualanDBGrid.SelectedIndex in [5,6] then
    begin
      DataModule1.ZQryFormSell.CommitUpdates;
      CekMaxStock;
      CalculateGridSell;
      PenjualanDBGrid.SelectedIndex := 8;
    end
    else if PenjualanDBGrid.SelectedIndex = 8 then
    begin
      DataModule1.ZQryFormSell.CommitUpdates;
      CalculateGridSell;

      DataModule1.ZQryFormSell.Append;
      PenjualanDBGrid.SelectedIndex := 6;
    end
    else
    begin
      DataModule1.ZQryFormSell.CommitUpdates;
      CalculateGridSell;
    end;
  end;

  if (Key=VK_UP) then
  begin
   CalculateGridSell;
  end;

  if (Key=VK_DOWN) then
  begin
   DataModule1.ZQryFormSell.CommitUpdates;
   CalculateGridSell;
   DataModule1.ZQryFormSell.Append;
   PenjualanDBGrid.SelectedIndex := 6;
  end;

  if (Key in [VK_DELETE]) then
  begin
    SubTotal := SubTotal - DataModule1.ZQryFormSellsubtotal.Value;
    DataModule1.ZQryFormSell.Delete;

    DataModule1.ZQryFormSell.first;
    vnourut := 1;
    while not DataModule1.ZQryFormSell.Eof do
    begin
     DataModule1.ZQryFormSell.Edit;
     DataModule1.ZQryFormSellnomordet.Value := vnourut;
     DataModule1.ZQryFormSell.Post;

     vnourut := vnourut + 1;

     DataModule1.ZQryFormSell.Next;
    end;

    CalculateGridSell;
  end;
end;

procedure TfrmSell.SellTxtPPNChange(Sender: TObject);
begin
  CalculateSell;
end;

procedure TfrmSell.SellTxtDiscChange(Sender: TObject);
begin
  SellTxtDiscRp.Value := SellTxtTotal.Value * SellTxtDisc.Value * 0.01;
  CalculateSell;
end;

procedure TfrmSell.SellTxtDibayarChange(Sender: TObject);
begin
  SellTxtKembali.Value := SellTxtDibayar.Value - SellTxtGrandTotal.Value;
  if SellTxtKembali.Value<0 then SellTxtKembali.Value:=0;
end;

procedure TfrmSell.SellTxtPembayaranChange(Sender: TObject);
begin
  if SellTxtPembayaran.Value = 'TUNAI' then
  begin
    SellPanelCredit.Visible := False;
    SellTxtNoCredit.Visible := False;
  end
  else
  begin
    SellPanelCredit.Visible := True;
    SellLblNoCredit.Caption := 'No. Bukti';
    SellLblNoCredit.Visible := True;
    SellTxtNoCredit.Visible := SellLblNoCredit.Visible;

    SellPanelCredit.SetFocus;
  end;
end;

procedure TfrmSell.SellTxtTempoChange(Sender: TObject);
begin
{  if SellTxtPembayaran.Value <> 'TUNAI' then
  begin
    SellPanelCredit.Visible := True;
    SellLblNoCredit.Caption := 'No. ' + SellTxtPembayaran.Value;
    SellPanelCredit.SetFocus;
  end
  else
    SellPanelCredit.Visible := False;     }
end;

end.
