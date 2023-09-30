unit frmReturBeli;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, Db;

type
  TfrmRtrBeli = class(TForm)
    Panel: TRzPanel;
    RzStatusPane1: TRzStatusPane;
    RzLabel9: TRzLabel;
    RtrBeliLblGrandTotal: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel15: TRzLabel;
    RtrBeliTxtTglRetur: TRzDateTimeEdit;
    ReturBeliDBGrid: TRzDBGrid;
    RzPanel2: TRzPanel;
    LblCaption: TRzLabel;
    RzLabel1: TRzLabel;
    RtrBeliTxtFaktur: TRzEdit;
    RtrBeliTxtCetak: TRzCheckBox;
    RzPanel7: TRzPanel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RtrBeliBtnAdd: TAdvSmoothButton;
    RtrBeliDel: TAdvSmoothButton;
    RzPanel1: TRzPanel;
    RzLabel4: TRzLabel;
    sellTxtalamat: TRzMemo;
    RzPanel4: TRzPanel;
    RzLabel6: TRzLabel;
    RtrTxtGrandTotal: TRzNumericEdit;
    RtrPanelCredit: TRzPanel;
    RzLabel11: TRzLabel;
    RtrTxtpembayaran: TRzComboBox;
    RzLabel5: TRzLabel;
    RtrTxtSubTotal: TRzNumericEdit;
    RtrTxtPPN: TRzNumericEdit;
    ccx_isppn: TRzCheckBox;
    RtrBeliTxtsupplier: TRzEdit;
    RzLabel8: TRzLabel;
    RzLabel7: TRzLabel;
    procedure RtrBeliBtnAddClick(Sender: TObject);
    procedure RtrBeliDelClick(Sender: TObject);
    procedure ReturBeliDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RtrBeliTxtSupplierChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ccx_isppnClick(Sender: TObject);
  private
    oldTotal: Double;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    procedure CalculateGridRetur;
    procedure CalculateRetur;
    function lastfakturbeli : string;
    { Private declarations }
  public
    SubTotal,TotalTrans : Double;
    CetakFaktur: string;
    vkodesupp : string;
    procedure PostingReturbeli(Faktur: string);
    procedure PrintStruck(NoFaktur: string);
    procedure FormShowFirst;
    function getNoRetur : string;
    { Public declarations }
  end;

var
  frmRtrBeli: TfrmRtrBeli;
  vinvoicebeli : string;

implementation

uses SparePartFunction, frmSearchProductRetur, frmSearchSupp, Data;

{$R *.dfm}

procedure TfrmRtrBeli.ClearForm;
begin
  ClearTabel('formretur where ipv='+ Quotedstr(ipcomp) );
  RefreshTabel(DataModule1.ZQryFormRetur);
  RtrbeliTxtFaktur.Text := '';
  RtrbeliTxtTglRetur.Date := TglSkrg;
  RtrTxtSubTotal.Value := 0;
  ccx_isppn.Checked := false;
  RtrTxtPPN.Value := 0;
  RtrTxtGrandTotal.Value := 0;
  RtrbeliLblGrandTotal.Caption := 'Rp 0';
  ReturbeliDBGrid.SetFocus;
  SubTotal   := 0;
  TotalTrans := 0;

  RtrBeliTxtSupplier.Text := '';
  vinvoicebeli := '';
  vkodesupp := '';
  sellTxtalamat.clear;

  RtrBeliTxtSupplier.SetFocus;
end;

procedure TfrmRtrBeli.CalculateRetur;
begin
    if ccx_isppn.Checked then RtrTxtPPN.Value := round(RtrTxtSubTotal.Value*0.1) else RtrTxtPPN.Value := 0;

    RtrTxtGrandTotal.Value := RtrTxtSubTotal.Value + RtrTxtPPN.Value;
    if RtrTxtGrandTotal.Value<0 then RtrTxtGrandTotal.Value:=0;
    RtrBeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',RtrTxtGrandTotal.Value);
end;

procedure TfrmRtrBeli.InsertDataMaster;
var idtrans, vkodegdg : string;
begin
  SubTotal := getDatanum('sum(subtotal)','formretur where ipv='+ Quotedstr(ipcomp));
  RtrTxtSubTotal.Value := SubTotal;
  CalculateRetur;

  vkodegdg:='UT';

  DataModule1.ZConnection1.ExecuteDirect('call p_cancelreturbeli('+ QuotedStr(RtrbeliTxtFaktur.Text) +')');

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into returbelimaster');
    SQL.Add('(faktur,tanggal,waktu,operator,kodesupplier,supplier,alamat,kota,');
    SQL.Add('totalretur,TotalTrans,subtotal,ppn,pembayaran,kodegudang,isposted) values');
    SQL.Add('("' + RtrbeliTxtFaktur.Text + '",');
    SQL.Add('"' + FormatDateTime('yyyy-MM-dd',RtrbeliTxtTglRetur.Date) + '",');
    SQL.Add('"' + FormatDateTime('hh:nn:ss',Now) + '",');
    SQL.Add(QuotedStr(UserName) + ',');
    SQL.Add(QuotedStr(vkodesupp) + ',');
    SQL.Add(QuotedStr(sellTxtalamat.Lines.Strings[0]) + ',');
    SQL.Add(QuotedStr(sellTxtalamat.Lines.Strings[1]) + ',');
    SQL.Add(QuotedStr(sellTxtalamat.Lines.Strings[2]) + ',');
    SQL.Add('"' + FloatToStr(RtrTxtGrandTotal.Value) + '",');
    SQL.Add('"' + FloatToStr(TotalTrans) + '",');
    SQL.Add('"' + FloatToStr(RtrTxtSubTotal.Value) + '",');
    SQL.Add('"' + FloatToStr(RtrTxtPPN.Value) + '",');
    SQL.Add(QuotedStr(RtrTxtpembayaran.Text) + ',');
    SQL.Add(QuotedStr(vkodegdg) + ',');
    SQL.Add('"' + '0' + '")');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('select idReturBeli from returbelimaster');
    SQL.Add('where faktur = ' + QuotedStr(RtrbeliTxtFaktur.Text) );
    Open;
    idtrans := Fields[0].AsString;
    Close;
    SQL.Clear;
    SQL.Add('insert into returbelidetail');
    SQL.Add('(faktur,idReturBeli,kode,nama,kategori,merk,seri,tipe,keterangan,qtybeli,qtyretur,hargabeli,hargajual,diskon,diskon2,diskon_rp,diskonrp,satuan,kodegudang,fakturbeli)');
    SQL.Add('select '+Quotedstr(RtrbeliTxtFaktur.Text)+','+Quotedstr(idtrans)+',kode,nama,kategori,merk,seri,tipe,keterangan,quantity,quantityretur,hargabeli,harga,diskon,diskon2,diskon_rp,diskonrp,satuan,kodegudang,fakturjual ');
    SQL.Add('from formretur where ipv='+ Quotedstr(ipcomp) +' and quantityretur>0 ');
    ExecSQL;
  end;
end;

procedure TfrmRtrBeli.UpdateData;
var vkodegdg : string;
begin
  RtrTxtGrandTotal.Value := SubTotal;
  RtrbeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',SubTotal);

  vkodegdg:='UT';

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update returbelimaster set');
    SQL.Add('tanggal = "' + FormatDateTime('yyyy-MM-dd',RtrbeliTxtTglRetur.Date) + '",');
    SQL.Add('waktu = "' + FormatDateTime('hh:nn:ss',Now) + '",');
    SQL.Add('operator = "' + UserName + '",');
//    SQL.Add('pembayaran = "' + RtrTxtPembayaran.Text + '",');
    SQL.Add('kodegudang = ' + QuotedStr(vkodegdg) + ',');
    SQL.Add('totaltrans = "' + FloatToStr(totaltrans) + '",');
    SQL.Add('totalretur = "' + FloatToStr(SubTotal) + '"');
    SQL.Add('where faktur = "' + RtrbeliTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from returbelidetail');
    SQL.Add('where faktur = "' + RtrbeliTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into returbelidetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,seri,tipe,keterangan,qtybeli,qtyretur,hargabeli,hargajual,diskon,diskon2,diskonrp,satuan,fakturbeli,kodegudang,hargabeli)');
    SQL.Add('select faktur,kode,nama,kategori,merk,seri,tipe,keterangan,quantity,quantityretur,hargabeli,harga,diskon,diskon2,diskonrp,satuan,fakturjual,kodegudang,hargabeli ');
    SQL.Add('from formretur where ipv='+ Quotedstr(ipcomp) );
    ExecSQL;
  end;
end;

function TfrmRtrBeli.getNoRetur : string;
//var Year,Month,Day: Word;
begin
    DataModule1.ZQrySearch2.Close;
    DataModule1.ZQrySearch2.SQL.Text := 'select faktur from returbelimaster where (isposted=-1) and (faktur like "RB' + vkodesupp + '%") order by idreturbeli limit 1';
    DataModule1.ZQrySearch2.Open;
    if (DataModule1.ZQrySearch2.IsEmpty=false)and(DataModule1.ZQrySearch2.Fields[0].IsNull=false) then
    begin
     result := DataModule1.ZQrySearch2.Fields[0].AsString;
     exit;
    end;
    DataModule1.ZQrySearch2.Close;

//    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select count(faktur) from returbelimaster');
      SQL.Add('where faktur like "RB' + vkodesupp + '%"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsInteger = 0) then
        result := 'RB' + vkodesupp + '-1'
      else
        result := 'RB' + vkodesupp + '-' + inttostr(Fields[0].AsInteger+1);
      Close;
    end;
end;

procedure TfrmRtrBeli.CalculateGridRetur;
begin
  if (DataModule1.ZQryFormRetur.State <> dsInsert) or (DataModule1.ZQryFormRetur.State <> dsEdit) then
    DataModule1.ZQryFormRetur.Edit;

  if ReturbeliDBGrid.Fields[6].AsFloat > ReturbeliDBGrid.Fields[5].AsFloat then
  begin
    ErrorDialog('Retur Quantity Maksimal adalah ' + ReturbeliDBGrid.Fields[5].AsString);
    ReturbeliDBGrid.Fields[6].AsFloat := ReturbeliDBGrid.Fields[5].AsFloat;
  end;

  if (DataModule1.ZQryFormRetur.IsEmpty=false)and(ReturbeliDBGrid.Fields[14].IsNull=false) then
  begin
//  if ReturbeliDBGrid.Fields[13].AsFloat <> 0 then
//    SubTotal := SubTotal - ReturbeliDBGrid.Fields[13].AsFloat;
    if (ReturbeliDBGrid.Fields[10].AsFloat > 0)or(ReturbeliDBGrid.Fields[11].AsFloat > 0)or(ReturbeliDBGrid.Fields[12].AsFloat > 0) then
        ReturbeliDBGrid.Fields[15].AsFloat := Round(ReturbeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat * ReturBeliDBGrid.Fields[10].AsFloat * 0.01)+(((ReturBeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat) - Round(ReturBeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat * ReturBeliDBGrid.Fields[10].AsFloat * 0.01))*ReturBeliDBGrid.Fields[11].AsFloat * 0.01)+ReturBeliDBGrid.Fields[12].AsFloat
    else ReturbeliDBGrid.Fields[15].AsFloat := 0;

   ReturbeliDBGrid.Fields[13].AsFloat := (ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[9].AsFloat) - ReturbeliDBGrid.Fields[15].AsFloat;

   Subtotal := getDatanum('sum(subtotal)','formretur where ipv='+ Quotedstr(ipcomp) + ' and nourut<>'+ ReturbeliDBGrid.Fields[14].AsString );
   SubTotal := SubTotal + ReturbeliDBGrid.Fields[13].AsFloat;
  end
  else SubTotal := 0;

  RtrTxtSubTotal.Value := SubTotal;
  CalculateRetur;
end;

procedure TfrmRtrBeli.PostingReturbeli(Faktur: string);
var
  Year,Month,Day: Word;
  //FakturBaru,
  idTrans,Total,JenisBayar,vwkt: string;
begin
    ///Ganti No Faktur temp dengan yang asli...
    ///Format NO FAKTUR TEMP : MSyy/MM/dd-hhmmss
    ///Format NO FAKTUR ASLI : BRJ/Tahun 2 digit/Bulan 2 Digit disambung kode urut (MSP/09/110001)
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
  {    Close;
      SQL.Clear;
      SQL.Add('select max(right(faktur,6)) from returbelimaster');
      SQL.Add('where faktur like ''' + 'BRJ/' + Copy(IntToStr(Year),3,2) + '/' + FormatCurr('00',Month) + '%' + '''');
      Open;
      if Fields[0].AsString = '' then
        FakturBaru := 'BRJ/' + Copy(IntToStr(Year),3,2) + '/' + FormatCurr('00',Month) + '0001'
      else
        FakturBaru := 'BRJ/' + Copy(IntToStr(Year),3,2) + '/' + FormatCurr('000000',Fields[0].AsInteger + 1);

      CetakFaktur := FakturBaru;
  }
      CetakFaktur := Faktur;

      Close;
      SQL.Clear;
      SQL.Add('select * from returbelimaster');
      SQL.Add('where faktur = ' + QuotedStr(Faktur) );
      Open;

      idTrans := FieldByName('idReturbeli').AsString;
      if idTrans = '' then idTrans := '0';
      Total := FieldByName('totalretur').AsString;
      JenisBayar := FieldByName('pembayaran').AsString;
      vwkt := FormatDateTime('hh:nn:ss',FieldByName('waktu').AsDateTime);
    end;

    with DataModule1.ZQryFunction do
    begin
{      Close;
      SQL.Clear;
      SQL.Add('update returbelidetail set');
      SQL.Add('faktur = "' + FakturBaru + '"');
      SQL.Add('where faktur = "' + Faktur + '"');
      ExecSQL;
                    }
      Close;
      SQL.Clear;
      SQL.Add('update returbelimaster set ');
      SQL.Add('lunas = if((pembayaran="CASH"),1,0),');
      SQL.Add('isposted = "' + '1' + '" ');
      SQL.Add('where faktur = "' + Faktur + '"');
      ExecSQL;

      ///Input Inventory
      Close;
      SQL.Clear;
      SQL.Add('insert into inventory');
      SQL.Add('(kodebrg,qty,satuan,hargabeli,hargajual,faktur,kodegudang,keterangan,typetrans,idTrans,username,waktu,tglTrans)');
      SQL.Add('select kode,-1*quantityretur,satuan,hargabeli,harga,'+Quotedstr(RtrbeliTxtFaktur.Text)+',kodegudang,'+Quotedstr(sellTxtalamat.Lines.Strings[0])+',"retur pembelian","'+idTrans+'",' + QuotedStr(UserName) +',"'+ vwkt+'","'+FormatDateTime('yyyy-MM-dd',TglSkrg)+'" from formretur where ipv='+ Quotedstr(ipcomp) + ' and quantityretur>0');
      ExecSQL;

      ///Input Operasional
      if JenisBayar = 'CASH' then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into operasional');
        SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
        SQL.Add('(''' + idTrans + ''',');
        SQL.Add('''' + Faktur + ''',');
        SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
        SQL.Add('''' + vwkt + ''',');
        SQL.Add('''' + UserName + ''',');
        SQL.Add('''' + 'RETUR PEMBELIAN TUNAI' + ''',');
        SQL.Add('''' + 'LUNAS' + ''',');
        SQL.Add('''' + Total + ''')');
        ExecSQL;
      end;

      LogInfo(UserName,'Posting transaksi retur pembelian, No. Faktur Retur : ' + Faktur + ', nilai transaksi:' + Total);
      InfoDialog('Faktur Retur beli ' + Faktur + ' berhasil diposting !');
    end;
end;

procedure TfrmRtrBeli.PrintStruck(NoFaktur: string);
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.ZConnection1.ExecuteDirect('delete from formretur where ipv='+ Quotedstr(ipcomp) + ' and quantityretur<=0 ');


  DataModule1.frxReport1.LoadFromFile(vpath+'Report\FakturReturbeli.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := RtrbeliTxtFaktur.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglNota'));
  FrxMemo.Memo.Text := RtrbeliTxtTglRetur.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NmCustomer'));
  FrxMemo.Memo.Text := sellTxtalamat.Lines.Strings[0];
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('AlmCustomer'));
  FrxMemo.Memo.Text := sellTxtalamat.Lines.Strings[1] + ' ' + sellTxtalamat.Lines.Strings[2];

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemGrandTotal'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',RtrTxtGrandTotal.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Kasir'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName  + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',now);

  RefreshTabel(DataModule1.ZQryFormRetur);

  DataModule1.frxReport1.ShowReport();
end;

procedure TfrmRtrBeli.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryFormRetur.Close;
  DataModule1.ZQryFormRetur.SQL.Text := 'select * from formretur where ipv='+ Quotedstr(ipcomp) + ' order by kode,nourut ';

  LblCaption.Caption := 'Input Retur Beli';

  if LblCaption.Caption = 'Input Retur Beli' then
  begin
    ClearForm;
  end
  else
  begin
    RtrbeliTxtFaktur.Text := DataModule1.ZQryReturbelifaktur.Value;
    RtrbeliTxtTglRetur.Date := DataModule1.ZQryReturbelitanggal.Value;
    RtrTxtGrandTotal.Value := DataModule1.ZQryReturbelitotalretur.AsFloat;
    RtrbeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',DataModule1.ZQryReturbelitotalretur.Value);

    oldTotal := DataModule1.ZQryReturbelitotalretur.Value;

    ClearTabel('formretur where ipv='+ Quotedstr(ipcomp));
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into formretur ');
      SQL.Add('(ipv,kode,nama,quantity,quantityretur,keterangan,hargabeli,harga,subtotal,');
      SQL.Add('kategori,merk,seri,tipe,faktur,diskon,diskon2,diskonrp,fakturjual,kodegudang,hargabeli)');
      SQL.Add('select '+Quotedstr(ipcomp)+',kode,nama,qtybeli,qtyretur,keterangan,hargabeli,hargajual,(qtyretur * hargabeli)-diskonrp,');
      SQL.Add('kategori,merk,seri,tipe,faktur,diskon,diskon2,diskonrp,fakturbeli,kodegudang,hargabeli from returbelidetail');
      SQL.Add('where faktur = ''' + DataModule1.ZQryReturbelifaktur.Text + '''');
      ExecSQL;
    end;
    RefreshTabel(DataModule1.ZQryFormRetur);
    SubTotal := DataModule1.ZQryReturbelitotalretur.Value;
  end;
end;

procedure TfrmRtrBeli.RtrBeliBtnAddClick(Sender: TObject);
begin
 if DataModule1.ZQryFormRetur.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

  DataModule1.ZQryFormRetur.CommitUpdates;
  DataModule1.ZQryFormRetur.First;
  while not DataModule1.ZQryFormRetur.Eof do
  begin
   if (DataModule1.ZQryFormRetur.State <> dsInsert) or (DataModule1.ZQryFormRetur.State <> dsEdit) then
       DataModule1.ZQryFormRetur.Edit;

   if (ReturbeliDBGrid.Fields[17].AsString<>'UT')and(ReturbeliDBGrid.Fields[17].AsString<>'RS') then
   begin
    ErrorDialog('Isi Gudang dengan UT (Utama/Baik) atau RS (Rusak)!');
    Exit;
   end;

   if ReturbeliDBGrid.Fields[6].AsFloat > ReturbeliDBGrid.Fields[5].AsFloat then
   begin
    ErrorDialog('Retur Quantity Maksimal adalah ' + ReturbeliDBGrid.Fields[5].AsString);
    ReturbeliDBGrid.Fields[6].AsFloat := ReturbeliDBGrid.Fields[5].AsFloat;
   end;

   if (DataModule1.ZQryFormRetur.IsEmpty=false)and(ReturbeliDBGrid.Fields[14].IsNull=false) then
   begin
    if (ReturbeliDBGrid.Fields[10].AsFloat > 0)or(ReturbeliDBGrid.Fields[11].AsFloat > 0)or(ReturbeliDBGrid.Fields[12].AsFloat > 0) then
        ReturBeliDBGrid.Fields[15].AsFloat := Round(ReturBeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat * ReturBeliDBGrid.Fields[10].AsFloat * 0.01)+(((ReturBeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat) - Round(ReturBeliDBGrid.Fields[6].AsFloat * ReturBeliDBGrid.Fields[9].AsFloat * ReturBeliDBGrid.Fields[10].AsFloat * 0.01))*ReturBeliDBGrid.Fields[11].AsFloat * 0.01)+ReturBeliDBGrid.Fields[12].AsFloat
    else ReturbeliDBGrid.Fields[15].AsFloat := 0;

    ReturbeliDBGrid.Fields[13].AsFloat := (ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[9].AsFloat) - ReturbeliDBGrid.Fields[15].AsFloat;
   end;

   DataModule1.ZQryFormRetur.CommitUpdates;
   DataModule1.ZQryFormRetur.Next;
  end;

  if (RtrbeliTxtFaktur.Text='') then
  begin
    ErrorDialog('Isi dahulu No. Retur dan Faktur Pembelian yang akan di-Retur!');
    Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select sum(quantityretur) from formretur where ipv='+ Quotedstr(ipcomp));
//    SQL.Add('where quantityretur <= 0 ');
    Open;
    if IsEmpty or(Fields[0].AsFloat<=0) then
    begin
      ErrorDialog('Tidak ada Retur!');
      Exit;
    end;
    Close;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    InsertDataMaster;
    PostingReturbeli(RtrbeliTxtFaktur.Text);
    LogInfo(UserName,'Insert Retur Pembelian Faktur No: ' + RtrbeliTxtFaktur.Text + ',Total: ' + FloatToStr(SubTotal));

    DataModule1.ZConnection1.Commit;

//    PrintStruck(RtrbeliTxtFaktur.Text);
    ClearForm;
  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelreturbeli('+QuotedStr(RtrbeliTxtFaktur.Text)+')');
    ErrorDialog('Gagal Posting, coba ulangi buat Retur Pembelian lagi!');
    ClearForm;
  end;
{  end
  else
  begin
    UpdateData;
    InfoDialog('Edit Retur Penbelian Faktur No. ' + RtrbeliTxtFaktur.Text + ' berhasil');
    LogInfo(UserName,'Edit Retur Penbelian Faktur No. ' + RtrbeliTxtFaktur.Text + ', Old Total: ' + FloatToStr(OldTotal) + ' New Total: ' + FloatToStr(SubTotal));
  end; }
//  RefreshTabel(DataModule1.ZQryReturbeli);
end;

procedure TfrmRtrBeli.RtrBeliDelClick(Sender: TObject);
begin
 ClearForm;
end;

procedure TfrmRtrBeli.ReturBeliDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    if (RtrBeliTxtFaktur.Text='')or(trim(vkodesupp)='') then
    begin
     ErrorDialog('Isi dahulu No. Retur dan Supplier !');
     exit;
    end;
    frmSrcProdRtr.formSender := frmRtrBeli;
    frmSrcProdRtr.KodeGdg  := 'UT';
    frmSrcProdRtr.vKodeSupp := vkodeSupp;
    frmSrcProdRtr.ShowModal;
  end;

  if Key = VK_F3 then
  begin
   frmSrcSupp.formSender := frmRtrBeli;
   frmSrcSupp.ShowModal;
  end;


  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQryFormRetur.CommitUpdates;
      CalculateGridRetur;
  end;

  if (Key in [VK_DELETE]) then
  begin
    SubTotal := SubTotal - DataModule1.ZQryFormRetursubtotal.Value;
    DataModule1.ZQryFormRetur.Delete;
    CalculateGridRetur;
  end;

end;

function TfrmRtrBeli.lastfakturbeli : string;
begin
 Datamodule1.ZQryUtil.Close;
 Datamodule1.ZQryUtil.SQL.Clear;
 Datamodule1.ZQryUtil.SQL.Text := 'select faktur from buymaster where isposted=1 and kodesupplier=' + QuotedStr(vkodesupp) + ' order by idbeli desc limit 1';
 Datamodule1.ZQryUtil.Open;
 if (Datamodule1.ZQryUtil.IsEmpty) or (Datamodule1.ZQryUtil.Fields[0].IsNull) then result:=''
 else result := Datamodule1.ZQryUtil.Fields[0].AsString;
 Datamodule1.ZQryUtil.Close;
end;

procedure TfrmRtrBeli.RtrBeliTxtSupplierChange(Sender: TObject);
var vlastfakturj,vkodegdg : string;
begin
  if (trim(RtrBeliTxtSupplier.Text)='') then
  begin
   RtrbeliTxtFaktur.Text := '';
   ClearTabel('formretur where ipv='+ Quotedstr(ipcomp));

   vinvoicebeli :='';
   vkodesupp := '';
   sellTxtalamat.clear;

   TotalTrans := 0;
   SubTotal   := 0;
   RtrTxtSubTotal.Value := SubTotal;
   ccx_isppn.Checked := false;
   RtrTxtPPN.Value := 0;
   CalculateRetur;

   RefreshTabel(DataModule1.ZQryFormRetur);

   exit;
  end;


  ClearTabel('formretur where ipv='+ Quotedstr(ipcomp));

  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select c.kode kodesupplier,c.nama supplier,c.alamat,c.kota from supplier c ');
    SQL.Add('where c.kode = ' + Quotedstr(vkodesupp) );
    Open;

 //   vinvoicebeli := FieldByName('noinvoice').AsString;

    vkodesupp := FieldByName('kodesupplier').AsString;


    RtrbeliTxtFaktur.Text := getNoRetur;

    sellTxtalamat.Clear;
    sellTxtalamat.Lines.Add(FieldByName('supplier').AsString);
    sellTxtalamat.Lines.Add(FieldByName('alamat').AsString);
    sellTxtalamat.Lines.Add(FieldByName('kota').AsString);
    TotalTrans := 0;//FieldByName('GrandTotal').AsCurrency;

    SubTotal := 0;
    RtrTxtSubTotal.Value := SubTotal;
    ccx_isppn.Checked := false;//FieldByName('ppn').AsFloat<>0;
    RtrTxtPPN.Value := 0;
    CalculateRetur;

    RtrTxtpembayaran.ItemIndex := 1;//RtrTxtpembayaran.Items.IndexOf(FieldByName('pembayaran').AsString);

    Close;
    SQL.Clear;
    SQL.Add('insert into formretur ');
    SQL.Add('(ipv,kode,nama,quantity,satuan,hargabeli,harga,kodegudang,kategori,merk,seri,faktur,fakturjual,diskon,diskon2,tipe)');
    SQL.Add('select '+Quotedstr(ipcomp)+',d.kode,d.nama,getQtysisaReturbeli(d.faktur,d.kode),d.satuan,d.hargabeli,d.harganondiskon,d.kodegudang,d.kategori,d.merk,d.seri,'+Quotedstr(RtrbeliTxtFaktur.Text)+',d.faktur,d.diskon,d.diskon2,d.tipe from buydetail d');
    SQL.Add('left join buymaster s on d.faktur=s.faktur left join supplier c on s.kodesupplier=c.kode ');
    SQL.Add('where c.kode = ' + Quotedstr(vkodesupp) );
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from formretur where ipv='+ Quotedstr(ipcomp)+ ' and quantity=0');
    ExecSQL;

{    Close;
    SQL.Clear;
    SQL.Add('update formretur set quantityretur=quantity where ipv='+Quotedstr(ipcomp));
    ExecSQL; }
  end;

  RefreshTabel(DataModule1.ZQryFormRetur);

//  if DataModule1.ZQryFormRetur.IsEmpty then errordialog('Sudah tidak ada yang dapat di-Retur dari No. Faktur Pembelian ini !');
end;

procedure TfrmRtrBeli.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DataModule1.ZQryFormRetur.Close;

end;

procedure TfrmRtrBeli.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TfrmRtrBeli.ccx_isppnClick(Sender: TObject);
begin
 calculateretur;
end;

end.
