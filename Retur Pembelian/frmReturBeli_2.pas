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
    RtrBeliTxtFakturBeli: TRzComboBox;
    sellTxtalamat: TRzMemo;
    RzPanel4: TRzPanel;
    RzLabel6: TRzLabel;
    RtrTxtGrandTotal: TRzNumericEdit;
    RtrPanelCredit: TRzPanel;
    RzLabel11: TRzLabel;
    RtrTxtpembayaran: TRzComboBox;
    RzLabel5: TRzLabel;
    RzLabel7: TRzLabel;
    RtrTxtSubTotal: TRzNumericEdit;
    RtrTxtPPN: TRzNumericEdit;
    procedure RtrBeliBtnAddClick(Sender: TObject);
    procedure RtrBeliDelClick(Sender: TObject);
    procedure ReturBeliDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RtrBeliTxtFakturBeliChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RtrBeliTxtFakturBeliKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RtrTxtPPNChange(Sender: TObject);
  private
    oldTotal: Double;
    procedure FillCombo;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    procedure CalculateGridRetur;
    procedure CalculateRetur;
    function getNoRetur : string;
    function lastfakturbeli : string;
    { Private declarations }
  public
    SubTotal,TotalTrans : Double;
    CetakFaktur: string;
    vkodesupp : string;
    procedure PostingReturbeli(Faktur: string);
    procedure PrintStruck(NoFaktur: string);
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  frmRtrBeli: TfrmRtrBeli;
  vfakturbeli : string;

implementation

uses SparePartFunction, frmSearchProduct, Data;

{$R *.dfm}

procedure TfrmRtrBeli.FillCombo;
begin
//  FillComboBox('faktur','sparepart.buymaster where tanggal>DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY) and isposted=1 and faktur like "' + standPos + '-%"' ,RtrbeliTxtFakturbeli,false,'faktur');
  FillComboBox('noinvoice','sparepart.buymaster where tanggal>DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY) and isposted=1 ', RtrbeliTxtFakturbeli, false, 'noinvoice');

end;

procedure TfrmRtrBeli.ClearForm;
begin
  ClearTabel('formretur'+ standpos);
  RefreshTabel(DataModule1.ZQryFormRetur);
  FillCombo;
  RtrbeliTxtFaktur.Text := '';
  RtrbeliTxtTglRetur.Date := TglSkrg;
  RtrTxtSubTotal.Value := 0;
  RtrTxtPPN.Value := 0;
  RtrTxtGrandTotal.Value := 0;
  RtrbeliLblGrandTotal.Caption := 'Rp 0';
  ReturbeliDBGrid.SetFocus;
  SubTotal   := 0;
  TotalTrans := 0;

  RtrbeliTxtFakturbeli.ItemIndex:=-1;
  RtrbeliTxtFakturbeli.Text := '';
  RtrbeliTxtFakturbelichange(self);

  vkodesupp := '';
  sellTxtalamat.clear;

  RtrbeliTxtFakturbeli.SetFocus;
end;

procedure TfrmRtrBeli.CalculateRetur;
begin
    RtrTxtGrandTotal.Value := RtrTxtSubTotal.Value + RtrTxtPPN.Value;
    if RtrTxtGrandTotal.Value<0 then RtrTxtGrandTotal.Value:=0;
    RtrBeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',RtrTxtGrandTotal.Value);
end;

procedure TfrmRtrBeli.InsertDataMaster;
begin
  SubTotal := getDatanum('sum(subtotal)','sparepart.formretur'+ standPos);
  RtrTxtSubTotal.Value := SubTotal;
  CalculateRetur;

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.returbelimaster');
    SQL.Add('(faktur,tanggal,waktu,operator,kodesupplier,supplier,alamat,kota,');
    SQL.Add('totalretur,TotalTrans,subtotal,ppn,fakturbeli,noinvoice,pembayaran,isposted) values');
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
    SQL.Add(QuotedStr(vfakturbeli) + ',');
    SQL.Add(QuotedStr(RtrbeliTxtFakturbeli.Text) + ',');
    SQL.Add(QuotedStr(RtrTxtpembayaran.Text) + ',');
    SQL.Add('"' + '0' + '")');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.returbelidetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,seri,keterangan,qtybeli,qtyretur,hargabeli,diskon,diskon_rp,diskonrp,satuan,kodegudang)');
    SQL.Add('select '+Quotedstr(RtrbeliTxtFaktur.Text)+',kode,nama,kategori,merk,seri,keterangan,quantity,quantityretur,harga,diskon,diskon_rp,diskonrp,satuan,kodegudang ');
    SQL.Add('from sparepart.formretur'+ standpos + ' where quantityretur>0 ');
    ExecSQL;
  end;
end;

procedure TfrmRtrBeli.UpdateData;
begin
  RtrTxtGrandTotal.Value := SubTotal;
  RtrbeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',SubTotal);

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update sparepart.returbelimaster set');
    SQL.Add('tanggal = "' + FormatDateTime('yyyy-MM-dd',RtrbeliTxtTglRetur.Date) + '",');
    SQL.Add('waktu = "' + FormatDateTime('hh:nn:ss',Now) + '",');
    SQL.Add('operator = "' + UserName + '",');
//    SQL.Add('pembayaran = "' + RtrTxtPembayaran.Text + '",');
    SQL.Add('totaltrans = "' + FloatToStr(totaltrans) + '",');
    SQL.Add('totalretur = "' + FloatToStr(SubTotal) + '"');
    SQL.Add('where faktur = "' + RtrbeliTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from sparepart.returbelidetail');
    SQL.Add('where faktur = "' + RtrbeliTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.returbelidetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,seri,keterangan,qtybeli,qtyretur,hargabeli,diskon,diskonrp,satuan,fakturbeli,kodegudang,hargabeli)');
    SQL.Add('select faktur,kode,nama,kategori,merk,seri,keterangan,quantity,quantityretur,harga,diskon,diskonrp,satuan,fakturbeli,kodegudang,hargabeli ');
    SQL.Add('from sparepart.formretur'+ standpos);
    ExecSQL;
  end;
end;

function TfrmRtrBeli.getNoRetur : string;
//var Year,Month,Day: Word;
begin
//    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select count(faktur) from sparepart.returbelimaster');
      SQL.Add('where faktur like "R' + RtrbeliTxtFakturbeli.Text + '%"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsInteger = 0) then
        result := 'R' + RtrbeliTxtFakturbeli.Text + '-1'
      else
        result := 'R' + RtrbeliTxtFakturbeli.Text + '-' + inttostr(Fields[0].AsInteger+1);
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

  if (DataModule1.ZQryFormRetur.IsEmpty=false)and(ReturbeliDBGrid.Fields[12].IsNull=false) then
  begin
//  if ReturbeliDBGrid.Fields[11].AsFloat <> 0 then
//    SubTotal := SubTotal - ReturbeliDBGrid.Fields[11].AsFloat;
    if (ReturbeliDBGrid.Fields[9].AsFloat > 0)or(ReturbeliDBGrid.Fields[10].AsFloat > 0) then
        ReturbeliDBGrid.Fields[13].AsFloat := Round(ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[8].AsFloat * ReturbeliDBGrid.Fields[9].AsFloat * 0.01)+ReturbeliDBGrid.Fields[10].AsFloat
    else ReturbeliDBGrid.Fields[13].AsFloat := 0;

   ReturbeliDBGrid.Fields[11].AsFloat := (ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[8].AsFloat) - ReturbeliDBGrid.Fields[13].AsFloat;

   Subtotal := getDatanum('sum(subtotal)','sparepart.formretur'+ standPos +' where nourut<>'+ ReturbeliDBGrid.Fields[12].AsString );
   SubTotal := SubTotal + ReturbeliDBGrid.Fields[11].AsFloat;
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
      SQL.Add('select max(right(faktur,6)) from sparepart.returbelimaster');
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
      SQL.Add('select * from sparepart.returbelimaster');
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
      SQL.Add('update sparepart.returbelidetail set');
      SQL.Add('faktur = "' + FakturBaru + '"');
      SQL.Add('where faktur = "' + Faktur + '"');
      ExecSQL;
                    }
      Close;
      SQL.Clear;
      SQL.Add('update sparepart.returbelimaster set ');
      SQL.Add('lunas = if((pembayaran="CASH"),1,0),');
      SQL.Add('isposted = "' + '1' + '" ');
      SQL.Add('where faktur = "' + Faktur + '"');
      ExecSQL;

      ///Input Inventory
      Close;
      SQL.Clear;
      SQL.Add('insert into sparepart.inventory');
      SQL.Add('(kodebrg,qty,satuan,faktur,kodegudang,typetrans,idTrans,username,waktu,tglTrans)');
      SQL.Add('select kode,-1*qtyretur,satuan,faktur,kodegudang,"retur pembelian","'+idTrans+'",' + QuotedStr(UserName) +',"'+ vwkt+'","'+FormatDateTime('yyyy-MM-dd',TglSkrg)+'" from sparepart.returbelidetail');
      SQL.Add('where faktur = "' + Faktur + '"');
      ExecSQL;

      ///Input Operasional
      if JenisBayar = 'CASH' then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into sparepart.operasional');
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
  DataModule1.ZConnection1.ExecuteDirect('delete from sparepart.formretur'+ standpos + ' where quantityretur<=0 ');


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
  DataModule1.ZQryFormRetur.Close;
  DataModule1.ZQryFormRetur.SQL.Text := 'select * from sparepart.formretur'+ standPos + ' order by kode,nourut ';

  LblCaption.Caption := 'Input Retur Beli';

  if LblCaption.Caption = 'Input Retur Beli' then
  begin
    ClearForm;
  end
  else
  begin
    FillCombo;
    RtrbeliTxtFaktur.Text := DataModule1.ZQryReturbelifaktur.Value;
    RtrbeliTxtTglRetur.Date := DataModule1.ZQryReturbelitanggal.Value;
    RtrTxtGrandTotal.Value := DataModule1.ZQryReturbelitotalretur.AsFloat;
    RtrbeliLblGrandTotal.Caption := FormatCurr('Rp ###,##0',DataModule1.ZQryReturbelitotalretur.Value);

    oldTotal := DataModule1.ZQryReturbelitotalretur.Value;

    ClearTabel('formretur'+ standpos);
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into sparepart.formretur'+ standpos);
      SQL.Add('(kode,nama,quantity,quantityretur,keterangan,harga,subtotal,');
      SQL.Add('kategori,merk,seri,faktur,diskon,diskonrp,fakturbeli,kodegudang,hargabeli)');
      SQL.Add('select kode,nama,qtybeli,qtyretur,keterangan,hargabeli,(qtyretur * hargabeli)-diskonrp,');
      SQL.Add('kategori,merk,seri,faktur,diskon,diskonrp,fakturbeli,kodegudang,hargabeli from sparepart.returbelidetail');
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

   if ReturbeliDBGrid.Fields[6].AsFloat > ReturbeliDBGrid.Fields[5].AsFloat then
   begin
    ErrorDialog('Retur Quantity Maksimal adalah ' + ReturbeliDBGrid.Fields[5].AsString);
    ReturbeliDBGrid.Fields[6].AsFloat := ReturbeliDBGrid.Fields[5].AsFloat;
   end;

   if (DataModule1.ZQryFormRetur.IsEmpty=false)and(ReturbeliDBGrid.Fields[12].IsNull=false) then
   begin
    if (ReturbeliDBGrid.Fields[9].AsFloat > 0)or(ReturbeliDBGrid.Fields[10].AsFloat > 0) then
        ReturbeliDBGrid.Fields[13].AsFloat := Round(ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[8].AsFloat * ReturbeliDBGrid.Fields[9].AsFloat * 0.01)+ReturbeliDBGrid.Fields[10].AsFloat
    else ReturbeliDBGrid.Fields[13].AsFloat := 0;

    ReturbeliDBGrid.Fields[11].AsFloat := (ReturbeliDBGrid.Fields[6].AsFloat * ReturbeliDBGrid.Fields[8].AsFloat) - ReturbeliDBGrid.Fields[13].AsFloat;
   end;

   DataModule1.ZQryFormRetur.CommitUpdates;
   DataModule1.ZQryFormRetur.Next;
  end;

  if (RtrbeliTxtFaktur.Text='')or(RtrbeliTxtFakturbeli.ItemIndex=-1) then
  begin
    ErrorDialog('Isi dahulu No. Retur dan Invoice yang akan di-Retur!');
    Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select sum(quantityretur) from sparepart.formretur'+ standPos +' ');
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
    DataModule1.ZConnection1.ExecuteDirect('call sparepart.p_cancelreturbeli('+QuotedStr(RtrbeliTxtFaktur.Text)+')');
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
{  if Key = VK_F1 then
  begin
    if (RtrbeliTxtFaktur.Text='')or(SellTxtCustomer.ItemIndex=-1) then
    begin
     ErrorDialog('Isi dahulu No. Retur dan Customer !');
     exit;
    end;
    frmSrcProd.formSender := frmRtrbeli;
    frmSrcProd.ShowModal;
  end;
 }

{  if (Key in [VK_TAB]) and (DataModule1.ZQryFormRetur.RecordCount = DataModule1.ZQryFormRetur.RecNo) and (ReturbeliDBGrid.SelectedIndex = 7) then
    Key := VK_RETURN;
}

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQryFormRetur.CommitUpdates;
      CalculateGridRetur;

    if ReturbeliDBGrid.SelectedIndex in [6,7] then
    begin
//      DataModule1.ZQryFormRetur.CommitUpdates;
//      CalculateGridRetur;
      ReturbeliDBGrid.SelectedIndex := 0;
    end;
//    else if ReturbeliDBGrid.SelectedIndex in [9,10] then
//    begin
//      DataModule1.ZQryFormRetur.CommitUpdates;
//      CalculateGridRetur;

//      DataModule1.ZQryFormRetur.Append;
//      ReturbeliDBGrid.SelectedIndex := 0;
//    end;

  end;

  if (Key in [VK_RETURN]) then
    Key := VK_DOWN;

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
 Datamodule1.ZQryUtil.SQL.Text := 'select faktur from sparepart.buymaster where isposted=1 and kodesupplier=' + QuotedStr(vkodesupp) + ' order by idbeli desc limit 1';
 Datamodule1.ZQryUtil.Open;
 if (Datamodule1.ZQryUtil.IsEmpty) or (Datamodule1.ZQryUtil.Fields[0].IsNull) then result:=''
 else result := Datamodule1.ZQryUtil.Fields[0].AsString;
 Datamodule1.ZQryUtil.Close;
end;

procedure TfrmRtrBeli.RtrBeliTxtFakturBeliChange(Sender: TObject);
var vlastfakturj : string;
begin
  if (RtrbeliTxtFakturbeli.Text='')or(RtrbeliTxtFakturbeli.ItemIndex=-1) then
  begin
   RtrbeliTxtFaktur.Text := '';
   ClearTabel('formretur'+standPos);

   vkodesupp := '';
   sellTxtalamat.clear;

   TotalTrans := 0;
   SubTotal   := 0;
   RtrTxtSubTotal.Value := SubTotal;
   RtrTxtPPN.Value := 0;
   CalculateRetur;

   RefreshTabel(DataModule1.ZQryFormRetur);

   exit;
  end;

//  RtrbeliTxtFaktur.Text := getNoRetur;

  ClearTabel('formretur'+standPos);
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from sparepart.buymaster');
    SQL.Add('where noinvoice = ' + Quotedstr(RtrbeliTxtFakturbeli.Text) );
    Open;

    vfakturbeli := FieldByName('faktur').AsString;

    vkodesupp := FieldByName('kodesupplier').AsString;

    sellTxtalamat.Clear;
    sellTxtalamat.Lines.Add(FieldByName('supplier').AsString);
    sellTxtalamat.Lines.Add(FieldByName('alamat').AsString);
    sellTxtalamat.Lines.Add(FieldByName('kota').AsString);
    TotalTrans := FieldByName('GrandTotal').AsCurrency;

    SubTotal := 0;
    RtrTxtSubTotal.Value := SubTotal;
    RtrTxtPPN.Value := 0;
    CalculateRetur;

    RtrTxtpembayaran.ItemIndex := RtrTxtpembayaran.Items.IndexOf(FieldByName('pembayaran').AsString);

    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.formretur'+standPos);
    SQL.Add('(kode,nama,quantity,satuan,harga,kodegudang,kategori,merk,seri,faktur,diskon)');
    SQL.Add('select kode,nama,sparepart.getQtysisaReturbeli(faktur,kode),satuan,hargabeli,"'+KodeGudang+'",kategori,merk,seri,'+Quotedstr(RtrbeliTxtFaktur.Text)+',diskon from sparepart.buydetail');
    SQL.Add('where faktur = ' + Quotedstr(vfakturbeli) );
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from sparepart.formretur'+standPos+' where quantity=0');
    ExecSQL;

{    Close;
    SQL.Clear;
    SQL.Add('update sparepart.formretur'+standPos+' set quantityretur=quantity');
    ExecSQL; }
  end;

  RefreshTabel(DataModule1.ZQryFormRetur);

  if DataModule1.ZQryFormRetur.IsEmpty then errordialog('Sudah tidak ada yang dapat di-Retur dari No. Invoice ini !');
end;

procedure TfrmRtrBeli.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DataModule1.ZQryFormRetur.Close;

end;

procedure TfrmRtrBeli.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TfrmRtrBeli.RtrBeliTxtFakturBeliKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{  if Key = VK_F1 then
  begin
    if (RtrbeliTxtFaktur.Text='')or(SellTxtCustomer.ItemIndex=-1) then
    begin
     ErrorDialog('Isi dahulu No. Retur dan Customer !');
     exit;
    end;
    frmSrcProd.formSender := frmRtrbeli;
    frmSrcProd.ShowModal;
  end;
 }
end;

procedure TfrmRtrBeli.RtrTxtPPNChange(Sender: TObject);
begin
 calculateretur;
end;

end.
