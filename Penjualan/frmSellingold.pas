unit frmSelling;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls;

type
  TfrmSell = class(TForm)
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
    PenjualanDBGrid: TRzDBGrid;
    RzPanel4: TRzPanel;
    RzLabel1: TRzLabel;
    SellTxtSubTotal: TRzNumericEdit;
    RzLabel3: TRzLabel;
    SellTxtGrandTotal: TRzNumericEdit;
    RzLabel4: TRzLabel;
    RzLabel6: TRzLabel;
    edt_kembali: TRzNumericEdit;
    SellTxtCetak: TRzCheckBox;
    SellPanelCredit: TRzPanel;
    RzPanel7: TRzPanel;
    SellBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    cb_cardbank: TRzComboBox;
    RzLabel11: TRzLabel;
    RzPanel1: TRzPanel;
    memketerangan: TRzMemo;
    edtnum_discbulat: TRzNumericEdit;
    RzLabel2: TRzLabel;
    edt_bayar: TRzNumericEdit;
    RzLabel5: TRzLabel;
    edt_bayartunai: TRzNumericEdit;
    RzLabel7: TRzLabel;
    edt_bayarcard: TRzNumericEdit;
    RzLabel10: TRzLabel;
    edt_cardno: TRzEdit;
    RzLabel8: TRzLabel;
    edt_cardname: TRzEdit;
    RzLabel16: TRzLabel;
    edt_kode: TRzEdit;
    procedure FormActivate(Sender: TObject);
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure PenjualanDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellTxtDiscChange(Sender: TObject);
    procedure SellTxtCustomerChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SellTxtCustomerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_bayarcardChange(Sender: TObject);
    procedure edt_kodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memketeranganKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    oldTotal: Double;
    function getNoFakturJual : string;
    function CekMaxStock : boolean;
    procedure CalculateGridSell;
    procedure CalculateSell;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    procedure inputkodebarcode(nilai:string);
    { Private declarations }
  public
    SubTotal,vservicesaldo : Double;
    CetakFaktur: string;
    vidcust : integer;
    procedure PostingJual(Faktur: string);
    procedure PrintStruck(NoFaktur: string);
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  frmSell: TfrmSell;

implementation

uses SparePartFunction, U_cetak, frmSearchProduct, Data;

{$R *.dfm}

procedure TfrmSell.PrintStruck(NoFaktur: string);
var
  FrxMemo: TfrxMemoView;
  F : TextFile;
  i : integer;
  nmfile : string;
begin
  DataModule1.ZQryFormSell.First;

  nmfile := vpath + 'struk.txt';
  if portstruk<>'USB' then
  begin
   Datamodule1.ZQrystruk.Close;
   Datamodule1.ZQrystruk.Open;

   AssignFile(F,nmfile);
   Rewrite(F);
   Writeln(F,'    * M PLUS *');
   Writeln(F,'    '+Datamodule1.ZQrystrukcabang.Value);
   Writeln(F,' ------------------------------- ');
   Writeln(F,' No. '+SellTxtNo.Text);
   Writeln(F,' Tgl.'+FormatDatetime('dd/mm/yyyy',SellTxtTgl.Date));
   Writeln(F,' ------------------------------- ');
   i:=1;
   while not DataModule1.ZQryFormSell.Eof do
   begin
    Writeln(F,' ('+inttostr(i)+') '+DataModule1.ZQryFormSellkode.Value+' '+leftstr(DataModule1.ZQryFormSellnama.Value,17));
//    Writeln(F,' '+FormatFloat('###,##0',DataModule1.ZQryFormSellquantity.Value)+' X @Rp.'+FormatFloat('###,##0',DataModule1.ZQryFormSellharga.Value-DataModule1.ZQryFormSelldiskon_rp.Value)+' = Rp.'+FormatFloat('###,##0',DataModule1.ZQryFormSellsubtotal.Value));
    Writeln(F,' '+FormatFloat('###,##0',DataModule1.ZQryFormSellquantity.Value)+' X @Rp.'+FormatFloat('###,##0',DataModule1.ZQryFormSellharga.Value)+' = Rp.'+FormatFloat('###,##0',DataModule1.ZQryFormSellquantity.Value*DataModule1.ZQryFormSellharga.Value));
    if DataModule1.ZQryFormSelldiskon_rp.Value<>0 then
    begin
     Writeln(F,' Diskon Item :');
     Writeln(F,' '+FormatFloat('###,##0',DataModule1.ZQryFormSellquantity.Value)+' X @Rp.'+FormatFloat('###,##0',DataModule1.ZQryFormSelldiskon_rp.Value)+'   = (Rp.'+FormatFloat('###,##0', DataModule1.ZQryFormSellquantity.Value*DataModule1.ZQryFormSelldiskon_rp.Value)+')');
    end;

    Writeln(F,'');

    i := i + 1;
    DataModule1.ZQryFormSell.Next;
   end;

   Writeln(F,' ------------------------------- ');
   Writeln(F,' TOTAL................Rp.'+FormatFloat('###,##0', SellTxtSubTotal.value));
   Writeln(F,' BAYAR................Rp.'+FormatFloat('###,##0', edt_bayar.Value));
   Writeln(F,' DISKON PEMBULATAN....Rp.'+FormatFloat('###,##0', edtnum_discbulat.Value));
   Writeln(F,' KEMBALI..............Rp.'+FormatFloat('###,##0', edt_kembali.Value));
   Writeln(F,' ------------------------------- ');
   Writeln(F,' Anda Telah berhemat..Rp.'+FormatFloat('###,##0', edtnum_discbulat.Value));
   Writeln(F,'');
   Writeln(F,' '+Datamodule1.ZQrystrukfooter1.Value);
   Writeln(F,' '+Datamodule1.ZQrystrukfooter2.Value);
   Writeln(F,'');
   Writeln(F,' '+Datamodule1.ZQrystrukfooter3.Value);
   Writeln(F,' '+Datamodule1.ZQrystrukfooter4.Value);
   Writeln(F,' '+Datamodule1.ZQrystrukfooter5.Value);
   Writeln(F,' ------------------------------- ');
   Writeln(F,' '+Datamodule1.ZQrystrukendfooter1.Value);
   Writeln(F,' '+Datamodule1.ZQrystrukendfooter2.Value);
   Writeln(F,' '+Datamodule1.ZQrystrukendfooter3.Value);
   Writeln(F,'');
   Writeln(F,'Printed By ' + UserName + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',getnow));
   Writeln(F,'');
   Writeln(F,'');
   Writeln(F,'');
   Writeln(F,chr(27)+chr(105));
   Writeln(F,chr(27)+chr(112)+chr(0)+chr(50)+chr(250));

   CloseFile(F);

   Datamodule1.ZQrystruk.Close;

   cetakFile(nmfile);
  end
  else
  begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\fakturpenjualan.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := SellTxtNo.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglNota'));
  FrxMemo.Memo.Text := 'Tanggal : '+SellTxtTgl.Text;


  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemSubTotal'));
  FrxMemo.Memo.Text := FormatFloat(',0;(,0)',SellTxtSubTotal.value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('diskonbulat'));
  FrxMemo.Memo.Text := FormatFloat(',0;(,0)',edtnum_discbulat.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('bayar'));
  FrxMemo.Memo.Text := FormatFloat(',0;(,0)',edt_bayar.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('diskonbulat2'));
  FrxMemo.Memo.Text := FormatFloat(',0;(,0)',edtnum_discbulat.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kembali'));
  FrxMemo.Memo.Text := FormatFloat(',0;(,0)',edt_kembali.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Kasir'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',getnow);

  Datamodule1.ZQrystruk.Close;
  Datamodule1.ZQrystruk.Open;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('cabang'));
  FrxMemo.Memo.Text := Datamodule1.ZQrystrukcabang.Value;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('footer12'));
  FrxMemo.Memo.Clear;
  FrxMemo.Memo.Add(Datamodule1.ZQrystrukfooter1.Value);
  FrxMemo.Memo.Add(Datamodule1.ZQrystrukfooter2.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('footer345'));
  FrxMemo.Memo.Clear;
  FrxMemo.Memo.Add(Datamodule1.ZQrystrukfooter3.Value);
  FrxMemo.Memo.Add(Datamodule1.ZQrystrukfooter4.Value);
  FrxMemo.Memo.Add(Datamodule1.ZQrystrukfooter5.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('endfooter123'));
  FrxMemo.Memo.Clear;
  if SellTxtGrandTotal.Value>=Datamodule1.ZQrystrukmintrans.Value then
  begin
   FrxMemo.Memo.Add(Datamodule1.ZQrystrukendfooter1.Value);
   FrxMemo.Memo.Add(Datamodule1.ZQrystrukendfooter2.Value);
   FrxMemo.Memo.Add(Datamodule1.ZQrystrukendfooter3.Value);
  end;

  Datamodule1.ZQrystruk.Close;

  DataModule1.frxReport1.PrepareReport();
  DataModule1.frxReport1.PrintOptions.ShowDialog := False;
  DataModule1.frxReport1.Print;
  end;
end;

procedure TfrmSell.PostingJual(Faktur: string);
var
  FakturBaru,idTrans,GrandTotal,totpayment,vwktt: string;
  islunas: integer;
  vtotpayment: double;
begin
    ///Ganti No Faktur temp dengan yang asli...
    ///Format NO FAKTUR TEMP : MSyy/MM/dd-hhmmss
    ///Format NO FAKTUR ASLI : MSP/Tahun 2 digit/Bulan 2 Digit disambung kode urut (MSP/09/110001)
    FakturBaru := Faktur;
    CetakFaktur := FakturBaru;


    with DataModule1.ZQryFunction do
    begin

      Close;
      SQL.Clear;
      SQL.Add('update sellmaster set');
      SQL.Add('isposted = ''' + '1' + ''' ');
      SQL.Add('where faktur = ''' + Faktur + '''');
      ExecSQL;
     end;

    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sellmaster');
      SQL.Add('where faktur = ''' + Faktur + '''');
      Open;

      idTrans := FieldByName('idSell').AsString;
      if idTrans = '' then idTrans := '0';
      islunas := FieldByName('lunas').AsInteger;
      totpayment := FieldByName('totalpayment').AsString;
      GrandTotal := FieldByName('grandtotal').AsString;
      vtotpayment := FieldByName('totalpayment').AsFloat;
      vwktt := FormatDateTime('hh:nn:ss',FieldByName('waktu').AsDateTime);
    end;

    with DataModule1.ZQryFunction do
    begin
      ///Input Operasional
      if (vtotpayment<>0) then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into operasional');
        SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
        SQL.Add('(''' + idTrans + ''',');
        SQL.Add('''' + FakturBaru + ''',');
        SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
        SQL.Add('''' + vwktt + ''',');
        SQL.Add('''' + UserName + ''',');
        SQL.Add('''' + 'PENJUALAN' + ''',');
        if islunas=1 then SQL.Add('''' + 'LUNAS' + ''',')
        else SQL.Add('''' + 'DP' + ''',');
        SQL.Add('''' + totpayment + ''')');
        ExecSQL;
      end;

      LogInfo(UserName,'Posting transaksi penjualan, no faktur : ' + FakturBaru + ', nilai transaksi:' + GrandTotal);
//      InfoDialog('Faktur ' + Faktur + ' berhasil diposting !');
    end;
end;

function TfrmSell.getNoFakturJual : string;
var Year,Month,Day: Word;
    vlengthfaktur: integer;
begin
    DataModule1.ZQrySearch.Close;

    DecodeDate(TglSkrg,Year,Month,Day);

    vlengthfaktur:=0;
    DataModule1.ZQrySearch.SQL.Text := 'select max(length(faktur)) from sellmaster ' +
                                       'where faktur like "' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '" ';
    DataModule1.ZQrySearch.Open;
    if (DataModule1.ZQrySearch.IsEmpty=false)and(DataModule1.ZQrySearch.Fields[0].IsNull=false) then
     vlengthfaktur := DataModule1.ZQrySearch.Fields[0].AsInteger;
    DataModule1.ZQrySearch.Close;

    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;

      if (vlengthfaktur=11) then
       SQL.Add('select max(right(faktur,4)) from sellmaster ')
      else SQL.Add('select max(right(faktur,6)) from sellmaster ');

      if (vlengthfaktur>0) then
       SQL.Add('where length(faktur)='+inttostr(vlengthfaktur)+' and faktur like "' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '" ')
      else SQL.Add('where faktur like "' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '" ');

      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '000001'
      else
        result := standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TfrmSell.CalculateGridSell;
var vhrgpromodiskon : double;
begin
  if (DataModule1.ZQryFormSell.State <> dsInsert) or (DataModule1.ZQryFormSell.State <> dsEdit) then
    DataModule1.ZQryFormSell.Edit;

  if (DataModule1.ZQryFormSell.IsEmpty=false)and(PenjualanDBGrid.Fields[10].IsNull=false) then
  begin
//    if PenjualanDBGrid.Fields[9].AsFloat <> 0 then
//      SubTotal := SubTotal - PenjualanDBGrid.Fields[9].AsFloat;

    PenjualanDBGrid.Fields[6].AsFloat := PenjualanDBGrid.Fields[4].AsFloat * PenjualanDBGrid.Fields[5].AsFloat;

    PenjualanDBGrid.Fields[7].AsFloat := 0;

    if (PenjualanDBGrid.Fields[7].AsFloat > 0)or(PenjualanDBGrid.Fields[8].AsFloat > 0) then
      PenjualanDBGrid.Fields[11].AsFloat := (PenjualanDBGrid.Fields[6].AsFloat * PenjualanDBGrid.Fields[7].AsFloat * 0.01) + (PenjualanDBGrid.Fields[8].AsFloat * PenjualanDBGrid.Fields[5].AsFloat)
    else PenjualanDBGrid.Fields[11].AsFloat := 0;

    PenjualanDBGrid.Fields[9].AsFloat := PenjualanDBGrid.Fields[6].AsFloat - PenjualanDBGrid.Fields[11].AsFloat;

    Subtotal := getDatanum('sum(subtotal)','formsell where ipv='+ Quotedstr(ipcomp) +' and nourut<>'+ PenjualanDBGrid.Fields[10].AsString );
    SubTotal := SubTotal + PenjualanDBGrid.Fields[9].AsFloat;
  end
  else SubTotal := 0;
  SellTxtSubTotal.Value := SubTotal;
  CalculateSell;
end;

function TfrmSell.CekMaxStock : boolean;
begin
  result := false;

  if (DataModule1.ZQryFormSell.State <> dsInsert) or (DataModule1.ZQryFormSell.State <> dsEdit) then
    DataModule1.ZQryFormSell.Edit;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
//    SQL.Add('select qty from v_stock');
//    SQL.Add('where kodegudang = '+ QuotedStr(KodeGudang) +' and kodebrg = ' + QuotedStr(DataModule1.ZQryFormSellkode.Value));
    SQL.Add('select '+kodegudang+'T from product');
    SQL.Add('where kode = ' + QuotedStr(DataModule1.ZQryFormSellkode.Value));
    Open;
    if PenjualanDBGrid.Fields[5].AsFloat > DataModule1.ZQryFunction.Fields[0].AsFloat then
    begin
      WarningDialog('Jumlah Stock Maksimum '+DataModule1.ZQryFormSellnama.Value+' adalah ' + Fields[0].AsString);
      PenjualanDBGrid.Fields[5].AsFloat := DataModule1.ZQryFunction.Fields[0].AsFloat;
    end
    else result := true;
  end;
end;

procedure TfrmSell.CalculateSell;
begin
 edtnum_discbulat.Value := 0;
 if SellTxtSubTotal.Value>=100 then edtnum_discbulat.Value := strtofloat(rightstr(floattostr(SellTxtSubTotal.value),2));

 SellTxtGrandTotal.Value  := SellTxtSubTotal.Value - edtnum_discbulat.Value;


 if SellTxtGrandTotal.Value<0 then SellTxtGrandTotal.Value:=0;
 SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',SellTxtGrandTotal.Value);

 edt_bayar.Value := edt_bayarcard.Value + edt_bayartunai.Value;

 edt_Kembali.Value := edt_bayar.Value - SellTxtGrandTotal.Value;

 if edt_Kembali.Value<0 then edt_Kembali.Value:=0;
end;

procedure TfrmSell.ClearForm;
begin                                                                                                            
  vIDcust := 1;

  SellTxtCetak.Checked := true;

  ClearTabel('formsell where ipv='+Quotedstr(ipcomp));

  RefreshTabel(DataModule1.ZQryFormSell);

  SellTxtNo.Text :=  getNoFakturJual;
  SellTxtTgl.Date := TglSkrg;

  edtnum_discbulat.Value := 0;

  SellLblGrandTotal.Caption := 'Rp 0';
  SellTxtSubTotal.Value := 0;
  SellTxtGrandTotal.Value := 0;
  memketerangan.Text := '';

  edt_bayarcard.Value := 0;
  edt_bayartunai.Value := 0;

  cb_cardbank.ItemIndex := -1;

  edt_cardno.Text := '';
  edt_cardname.Text := '';

  edt_kode.Text := '';

  edt_kode.SetFocus;
  SubTotal := 0;
end;

procedure TfrmSell.InsertDataMaster;
var idTrans,vwkt: string;
begin
  Subtotal := getDatanum('sum(subtotal)','formsell where ipv='+ Quotedstr(ipcomp));
  SellTxtSubTotal.Value := SubTotal;
  CalculateSell;

  DataModule1.ZConnection1.ExecuteDirect('call p_cancelfaktur('+ QuotedStr(SellTxtNo.Text) +')');

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into sellmaster ');
    SQL.Add('(faktur,tanggal,waktu,kasir,IDcustomer,subtotal,discbulat,bayartunai,bayarcard,cardbank,cardno,cardname,kembali,');
    SQL.Add('grandtotal,keterangan,totalpayment,lunas) values ');
    SQL.Add('(' + QuotedStr(SellTxtNo.Text) + ',');
    SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date)) + ',');
    vwkt := FormatDateTime('hh:nn:ss',Now);
    SQL.Add(QuotedStr(vwkt) + ',');
    SQL.Add(QuotedStr(UserName) + ',');
    SQL.Add(QuotedStr(inttostr(vidCust)) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtSubTotal.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(edtnum_discbulat.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(edt_bayartunai.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(edt_bayarcard.Value)) + ',');
    SQL.Add(QuotedStr(trim(cb_cardbank.Text)) + ',');
    SQL.Add(QuotedStr(trim(edt_cardno.Text)) + ',');
    SQL.Add(QuotedStr(trim(edt_cardname.Text)) + ',');
    SQL.Add(QuotedStr(FloatToStr(edt_kembali.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtGrandTotal.Value)) + ',');
    SQL.Add(QuotedStr(Memketerangan.Text) + ',');
    SQL.Add(QuotedStr(FloatToStr(SellTxtGrandTotal.Value)) + ',');
    SQL.Add(QuotedStr('1') + ')');
    ExecSQL;

    DataModule1.ZConnection1.ExecuteDirect('update formsell o, product p set o.faktur='+Quotedstr(SellTxtNo.Text)+', o.satuan=p.satuan where (o.kode=p.kode) and (o.ipv='+Quotedstr(ipcomp)+') ');

    Close;
    SQL.Clear;
    SQL.Text := 'select idsell from sellmaster where faktur='+ Quotedstr(SellTxtNo.Text) ;
    Open;
    idTrans := Fields[0].AsString;

    Close;
    SQL.Clear;
    SQL.Add('insert into selldetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,seri,hargajual,diskon,diskonrp,diskon_rp,');
    SQL.Add('quantity,hargabeli,satuan,subtotal,idsell)');
    SQL.Add('select faktur,kode,nama,kategori,merk,seri,harga,diskon,diskonrp,diskon_rp,');
    SQL.Add('quantity,hargabeli,satuan,subtotal,'+ Quotedstr(idTrans) +' from formsell where ipv='+ Quotedstr(ipcomp) );
    ExecSQL;

     ///Input Inventory
     Close;
     SQL.Clear;
     SQL.Add('insert into inventory ');
     SQL.Add('(kodebrg,qty,satuan,hargabeli,hargajual,faktur,keterangan,typetrans,idTrans,username,tglTrans,waktu,kodeGudang) ');
     SQL.Add('select kode,(quantity * -1),satuan,hargabeli,harga,faktur,'+Quotedstr(memketerangan.Text)+',''penjualan'','''+idTrans+''',' + QuotedStr(UserName) + ',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + vwkt + ''',''' + KodeGudang + 'T'' from formsell where ipv='+ Quotedstr(ipcomp) );
     ExecSQL;
  end;

end;

procedure TfrmSell.UpdateData;
var idTrans: string;
begin
  Subtotal := getDatanum('sum(subtotal)','formsell where ipv='+ Quotedstr(ipcomp));
  SellTxtSubTotal.Value := SubTotal;
  CalculateSell;

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update sellmaster set');
    SQL.Add('tanggal = ''' + FormatDateTime('yyyy-MM-dd',SellTxtTgl.Date) + ''',');
    SQL.Add('waktu = ''' + FormatDateTime('hh:nn:ss',Now) + ''',');
    SQL.Add('kasir = ' + QuotedStr(UserName) + ',');
    SQL.Add('kodecustomer = ' + QuotedStr(inttostr(vidCust)) + ',');
    SQL.Add('subtotal = ''' + FloatToStr(SellTxtSubTotal.Value) + ''',');
    SQL.Add('grandtotal = ''' + FloatToStr(SellTxtGrandTotal.Value) + ''',');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from selldetail');
    SQL.Add('where faktur = ''' + SellTxtNo.Text + '''');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into selldetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,seri,hargajual,diskon,diskon_rp,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan)');
    SQL.Add('select faktur,kode,nama,kategori,merk,seri,harga,diskon,diskon_rp,diskonrp,');
    SQL.Add('quantity,hargabeli,satuan from formsell where ipv='+ Quotedstr(ipcomp));
    ExecSQL;

    DataModule1.ZConnection1.ExecuteDirect('update selldetail o set o.satuan=(select satuan from product where kode=o.kode) where (o.faktur="'+ SellTxtNo.Text +'") and ((o.satuan="") or (o.satuan is null))');

{        DataModule1.ZQryUtil.Close;
        DataModule1.ZQryUtil.SQL.Clear;
        DataModule1.ZQryUtil.SQL.Text:='select sum((quantity*hargajual)-diskonrp) from selldetail where faktur="'+SellTxtNo.Text+'"';
        DataModule1.ZQryUtil.Open;
        DataModule1.ZConnection1.ExecuteDirect('update sellmaster set subtotal="'+DataModule1.ZQryUtil.Fields[0].AsString+'",total="'+FloattoStr(DataModule1.ZQryUtil.Fields[0].AsFloat+SellTxtPPN.Value)+'",grandtotal="'+FloattoStr(DataModule1.ZQryUtil.Fields[0].AsFloat+SellTxtPPN.Value-SellTxtDiscRp.Value)+'" where faktur="'+SellTxtNo.Text+'"');
        DataModule1.ZQryUtil.Close;  }

    DataModule1.ZConnection1.ExecuteDirect('delete from inventory where faktur=' + Quotedstr(SellTxtNo.Text) + ' and typetrans=' + Quotedstr('penjualan') );

    Close;
    SQL.Clear;
    SQL.Text := 'select idsell from sellmaster where faktur='''+ SellTxtNo.Text +'''';
    Open;
    idTrans := Fields[0].AsString;
    ///Input Inventory
    Close;
    SQL.Clear;
    SQL.Add('insert into inventory ');
    SQL.Add('(kodebrg,qty,satuan,hargabeli,hargajual,faktur,typetrans,idTrans,tglTrans,kodeGudang) ');
    SQL.Add('select kode,(quantity * -1),satuan,hargabeli,harga,faktur,''penjualan'','''+idTrans+''',''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',''' + KodeGudang + 'T'' from formsell where ipv='+ Quotedstr(ipcomp));
    ExecSQL;
  end;
end;

procedure TfrmSell.FormActivate(Sender: TObject);
begin
{  frmSell.Top := frmSellMaster.PanelPenjualan.Top - 65;
  frmSell.Height := frmSellMaster.PanelPenjualan.Height + 95;
  frmSell.Width := frmSellMaster.PanelPenjualan.Width;
  if frmSell.Width > 800 then
  begin
    frmSell.Left := 1;
    PenjualanDBGrid.Columns.Items[1].Width := 350;
//    PenjualanDBGrid.Columns.Items[7].Width := 200;
  end
  else
  begin
    frmSell.Left := 2;
    PenjualanDBGrid.Columns.Items[1].Width := 150;
//    PenjualanDBGrid.Columns.Items[7].Width := 84;
  end;      }
end;

procedure TfrmSell.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryFormSell.Close;
  DataModule1.ZQryFormSell.SQL.Text := 'select * from formsell where ipv='+ Quotedstr(ipcomp) + ' order by kode ';

  SellLblCaption.Caption := 'Input Penjualan';

  if SellLblCaption.Caption = 'Input Penjualan' then
  begin
    ClearForm;
  end
  else
  begin
    SellTxtCetak.Checked := true;

    SellTxtNo.Text := DataModule1.ZQrySellMasterfaktur.Value;
    SellTxtTgl.Date := DataModule1.ZQrySellMastertanggal.Value;

    SellLblGrandTotal.Caption := FormatCurr('Rp ###,##0',DataModule1.ZQrySellMastergrandtotal.Value);
    SellTxtSubTotal.Value := DataModule1.ZQrySellMastersubtotal.Value;
    SellTxtGrandTotal.Value := DataModule1.ZQrySellMastergrandtotal.Value;

    oldTotal := DataModule1.ZQrySellMastergrandtotal.Value;

    ClearTabel('formsell where ipv='+ Quotedstr(ipcomp));
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into formsell ');
      SQL.Add('(ipv,kode,nama,harga,hargabeli,quantity,totalharga,diskon,diskonrp,subtotal,');
      SQL.Add('faktur,kategori,merk,seri)');
      SQL.Add('select '+Quotedstr(ipcomp)+',kode,nama,hargajual,hargabeli,quantity,quantity * hargajual,');
      SQL.Add('diskon,diskonrp,(quantity * hargajual) - diskonrp,');
      SQL.Add('faktur,kategori,merk,seri from selldetail');
      SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQrySellMasterfaktur.Text) );
      ExecSQL;
    end;
    RefreshTabel(DataModule1.ZQryFormSell);
    SubTotal := DataModule1.ZQrySellMastersubtotal.Value;
  end;
end;

procedure TfrmSell.SellBtnAddClick(Sender: TObject);
var vqty : double;
begin
 if DataModule1.ZQryFormSell.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if SellTxtGrandTotal.Value>edt_bayar.Value then
 begin
  errordialog('Pembayaran lebih kecil dari Total Tagihan!');
  exit;
 end;

  CetakFaktur := SellTxtNo.Text;
  DataModule1.ZQryFormSell.CommitUpdates;

  DataModule1.ZQryFormSell.First;
  while not DataModule1.ZQryFormSell.Eof do
  begin
//   if CekMaxStock=false then exit;

   if (DataModule1.ZQryFormSell.State <> dsInsert) or (DataModule1.ZQryFormSell.State <> dsEdit) then
    DataModule1.ZQryFormSell.Edit;

   if (DataModule1.ZQryFormSell.IsEmpty=false)and(PenjualanDBGrid.Fields[10].IsNull=false) then
   begin
    vqty := PenjualanDBGrid.Fields[5].AsFloat;

    PenjualanDBGrid.Fields[6].AsFloat := PenjualanDBGrid.Fields[4].AsFloat * PenjualanDBGrid.Fields[5].AsFloat;

    PenjualanDBGrid.Fields[7].AsFloat := 0;

    if (PenjualanDBGrid.Fields[7].AsFloat > 0)or(PenjualanDBGrid.Fields[8].AsFloat > 0) then
      PenjualanDBGrid.Fields[11].AsFloat := (PenjualanDBGrid.Fields[6].AsFloat * PenjualanDBGrid.Fields[7].AsFloat * 0.01) + (PenjualanDBGrid.Fields[8].AsFloat * PenjualanDBGrid.Fields[5].AsFloat)
    else PenjualanDBGrid.Fields[11].AsFloat := 0;

    PenjualanDBGrid.Fields[9].AsFloat := PenjualanDBGrid.Fields[6].AsFloat - PenjualanDBGrid.Fields[11].AsFloat;
   end;

   if (PenjualanDBGrid.Fields[7].AsFloat>100) then
   begin
    DataModule1.ZQryFormSell.Cancel;
    errordialog('Nilai Disc(%) tidak boleh lebih dari 100%!');
    exit;
   end;

   DataModule1.ZQryFormSell.CommitUpdates;

   DataModule1.ZQryFormSell.Next;
  end;
  Subtotal := getDatanum('sum(subtotal)','formsell where ipv='+Quotedstr(ipcomp) );
  SellTxtSubTotal.Value := SubTotal;
  CalculateSell;

  if SellTxtSubTotal.Value<0 then
  begin
    ErrorDialog('Sub Total Faktur tidak boleh minus!');
    Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select faktur from formsell ');
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
    InsertDataMaster;
    PostingJual(CetakFaktur);
    LogInfo(UserName,'Insert Penjualan Faktur No: ' + SellTxtNo.Text + ',Total: ' + FloatToStr(SellTxtGrandTotal.Value));

    DataModule1.ZConnection1.Commit;

    PrintStruck(CetakFaktur);
    ClearForm;
  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelfaktur('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba ulangi Buat Faktur lagi!');
    ClearForm;
  end;

{  else
  begin
    UpdateData;
    if SellTxtCetak.Checked = True then
    begin
      PostingJual(CetakFaktur);
      PrintStruck(CetakFaktur);
    end;
    InfoDialog('Edit Penjualan Faktur No. ' + SellTxtNo.Text + ' berhasil');
    LogInfo(UserName,'Edit Penjualan Faktur No. ' + SellTxtNo.Text + ', Old Total: ' + FloatToStr(OldTotal) + ' New Total: ' + FloatToStr(SellTxtGrandTotal.Value));
    Close;
  end; }
//  RefreshTabel(DataModule1.ZQrySellMaster);
end;

procedure TfrmSell.SellBtnDelClick(Sender: TObject);
begin
 ClearForm;
end;

procedure TfrmSell.PenjualanDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcProd.formSender := frmSell;
    frmSrcProd.ShowModal;

  end;

//  if Key = VK_F3 then
//  begin
//    frmSrcCust.formSender := frmSell;
//    frmSrcCust.ShowModal;
//  end;

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQryFormSell.CommitUpdates;
//      if PenjualanDBGrid.SelectedIndex in [4,5] then CekMaxStock;
      CalculateGridSell;
    if PenjualanDBGrid.SelectedIndex in [4,5] then
    begin
{      DataModule1.ZQryFormSell.CommitUpdates;
      CekMaxStock;
      CalculateGridSell;   }
      PenjualanDBGrid.SelectedIndex := 7;
    end
    else if PenjualanDBGrid.SelectedIndex in [7,8] then
    begin
{      DataModule1.ZQryFormSell.CommitUpdates;
      CalculateGridSell;   }

      DataModule1.ZQryFormSell.Append;
      PenjualanDBGrid.SelectedIndex := 5;
    end;
  end;

  if (Key in [VK_DELETE]) then
  begin
    SubTotal := SubTotal - DataModule1.ZQryFormSellsubtotal.Value;
    DataModule1.ZQryFormSell.Delete;
    CalculateGridSell;
  end;

  if (Key=VK_F5) then SellBtnAddClick(sender);
  if (Key=VK_F9) then SellBtnDelClick(sender);

end;

procedure TfrmSell.SellTxtDiscChange(Sender: TObject);
begin
  CalculateSell;
end;

procedure TfrmSell.SellTxtCustomerChange(Sender: TObject);
begin
{ sellTxtalamat.Clear;

 DataModule1.ZQryUtil.Close;
 DataModule1.ZQryUtil.SQL.Clear;
// DataModule1.ZQryUtil.SQL.Text:='select alamat,kota,if((day(tgllahir)=day(CURRENT_DATE))and(month(tgllahir)=month(CURRENT_DATE)),getcustdiscbirthday(),0) discbirthday from customer where kode="'+cbx_kodecust.Items[cbx_kodecust.ItemIndex]+'"';
 DataModule1.ZQryUtil.SQL.Text:='select alamat,kota from customer where kode="'+cbx_kodecust.Items[cbx_kodecust.ItemIndex]+'"';
 DataModule1.ZQryUtil.Open;
 if DataModule1.ZQryUtil.Fields[0].IsNull=false then sellTxtalamat.Lines.Add(DataModule1.ZQryUtil.Fields[0].AsString);
 if DataModule1.ZQryUtil.Fields[1].IsNull=false then sellTxtalamat.Lines.Add(DataModule1.ZQryUtil.Fields[1].AsString);
// if DataModule1.ZQryUtil.Fields[2].IsNull=false then SellTxtDiscRp.Value := DataModule1.ZQryUtil.Fields[2].AsFloat;
 DataModule1.ZQryUtil.Close;
 }
end;

procedure TfrmSell.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQryFormSell.Close;

 { IF Frmsellmaster=nil then
 application.CreateForm(TFrmsellmaster,Frmsellmaster);
 Frmsellmaster.Align:=alclient;
 Frmsellmaster.Parent:=Self.Parent;
 Frmsellmaster.BorderStyle:=bsnone;
 Frmsellmaster.FormShowFirst;
 Frmsellmaster.Show; }

end;

procedure TfrmSell.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TfrmSell.SellTxtCustomerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcProd.formSender := frmSell;
    frmSrcProd.ShowModal;
  end;

//  if Key = VK_F3 then
//  begin
//    frmSrcCust.formSender := frmSell;
//    frmSrcCust.ShowModal;
//  end;
end;

procedure TfrmSell.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
 VK_F4 : edt_bayartunai.SetFocus;
 end;
end;

procedure TfrmSell.edt_bayarcardChange(Sender: TObject);
begin
 CalculateSell;
end;

procedure TfrmSell.inputkodebarcode(nilai:string);
var bufstr : string;
    vhrgpromodiskon,vqty : double;
begin
  bufstr := trim(nilai);

  if bufstr='' then exit;

   DataModule1.ZQrySearchProduct.Close;
   DataModule1.ZQrySearchProduct.SQL.Strings[0] := 'select p.*,cast("" as char(20)) faktur,p.'+kodegudang+' qty,p.'+kodegudang+'T qtytoko,p.'+kodegudang+'R qtybad,null kategori from product p ';
   DataModule1.ZQrySearchProduct.SQL.Strings[1] := '';
   DataModule1.ZQrySearchProduct.SQL.Strings[2] := 'where (p.kode='+Quotedstr(bufstr)+')or(p.barcode='+Quotedstr(bufstr)+') ';
   DataModule1.ZQrySearchProduct.Open;

   if DataModule1.ZQrySearchProduct.IsEmpty then infodialog('Barang Kosong')
   else
   begin
    if DataModule1.ZQryFormSell.Locate('kode',DataModule1.ZQrySearchProductkode.Value,[]) then
    begin
     DataModule1.ZQryFormSell.Edit;
     vqty := DataModule1.ZQryFormSellquantity.Value + 1;
     DataModule1.ZQryFormSellquantity.Value := DataModule1.ZQryFormSellquantity.Value + 1;

     DataModule1.ZQryFormSelldiskon_rp.Value := getDataNum('t.diskonrp','diskondet t left join diskon d on t.IDdiskon=d.IDdiskon where d.isactive=1 and t.minqty<='+floattostr(vqty)+' and t.maxqty>='+floattostr(vqty)+' and t.IDproduct='+DataModule1.ZQrySearchProductIDproduct.AsString+' and '+Quotedstr(getmysqldatestr(Tglskrg))+' between d.tglawal and d.tglakhir ');
     DataModule1.ZQryFormSelldiskonrp.Value := DataModule1.ZQryFormSelldiskon_rp.Value * DataModule1.ZQryFormSellquantity.Value;
     DataModule1.ZQryFormSellharga.Value := DataModule1.ZQrySearchProducthargajual.Value;
    end
    else
    begin
     if DataModule1.ZQryFormSell.State <> dsEdit then DataModule1.ZQryFormSell.Append
     else
     begin
      DataModule1.ZQryFormSell.CommitUpdates;
      CalculateGridSell;
      DataModule1.ZQryFormSell.CommitUpdates;
      DataModule1.ZQryFormSell.Append;
     end;
     DataModule1.ZQryFormSellfaktur.Value := frmSell.SellTxtNo.Text;
     DataModule1.ZQryFormSellkode.Value := DataModule1.ZQrySearchProductkode.Value;
     DataModule1.ZQryFormSellnama.Value := DataModule1.ZQrySearchProductnama.Value;

     vqty := 1;
     DataModule1.ZQryFormSelldiskon_rp.Value := getDataNum('t.diskonrp','diskondet t left join diskon d on t.IDdiskon=d.IDdiskon where d.isactive=1 and t.minqty<='+floattostr(vqty)+' and t.maxqty>='+floattostr(vqty)+' and t.IDproduct='+DataModule1.ZQrySearchProductIDproduct.AsString+' and '+Quotedstr(getmysqldatestr(Tglskrg))+' between d.tglawal and d.tglakhir ');
     DataModule1.ZQryFormSellquantity.Value := 1;
     DataModule1.ZQryFormSelldiskonrp.Value := DataModule1.ZQryFormSelldiskon_rp.Value * DataModule1.ZQryFormSellquantity.Value;
     DataModule1.ZQryFormSellharga.Value := DataModule1.ZQrySearchProducthargajual.Value;

     DataModule1.ZQryFormSellhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
     DataModule1.ZQryFormSellkategori.Value := DataModule1.ZQrySearchProductkategori.Value;
     DataModule1.ZQryFormSellmerk.Value := DataModule1.ZQrySearchProductmerk.Value;
     DataModule1.ZQryFormSellseri.Value := DataModule1.ZQrySearchProductseri.Value;
     DataModule1.ZQryFormSellsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
     DataModule1.ZQryFormSellipv.Value := ipcomp;
    end;

    DataModule1.ZQryFormSell.CommitUpdates;
    CalculateGridSell;
    DataModule1.ZQryFormSell.CommitUpdates;

    PenjualanDBGrid.SetFocus;
    PenjualanDBGrid.SelectedIndex := 5;
   end;

   DataModule1.ZQrySearchProduct.Close;
end;

procedure TfrmSell.edt_kodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
 VK_RETURN : begin
              inputkodebarcode(edt_kode.Text);
              edt_kode.Text:='';
              edt_kode.SetFocus;
             end;


 VK_F1 :     begin
              frmSrcProd.formSender := frmSell;
              frmSrcProd.ShowModal;
             end;

 VK_F5 : SellBtnAddClick(sender);
 VK_F9 : SellBtnDelClick(sender);
 end;

end;

procedure TfrmSell.memketeranganKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
 VK_F1 :     begin
              frmSrcProd.formSender := frmSell;
              frmSrcProd.ShowModal;
             end;

 VK_F5 : SellBtnAddClick(sender);
 VK_F9 : SellBtnDelClick(sender);
 end;
end;

end.
