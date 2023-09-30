unit po;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls;

type
  TFrmpo = class(TForm)
    PanelSell: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    DBGriddet: TRzDBGrid;
    RzPanel7: TRzPanel;
    SellBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    RzGroupBox1: TRzGroupBox;
    RzLabel13: TRzLabel;
    edt_docno: TRzEdit;
    RzLabel15: TRzLabel;
    dte_doctgl: TRzDateTimeEdit;
    BtnSave: TAdvSmoothButton;
    mem_notes: TRzMemo;
    RzLabel2: TRzLabel;
    cb_supplier: TRzComboBox;
    RzLabel1: TRzLabel;
    edtnum_totalprice: TRzNumericEdit;
    RzLabel16: TRzLabel;
    edt_kode: TRzEdit;
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure DBGriddetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edt_kodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateDataMaster;
    procedure CalculateGridSell;
    procedure inputkodebarcode(nilai:string);
    function getNobpg : string;

    { Private declarations }
  public
    tagacc : byte;
    CetakFaktur: string;
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  Frmpo: TFrmpo;

implementation

uses frmSearchProduct, SparePartFunction, data, polist;

{$R *.dfm}

procedure TFrmpo.CalculateGridSell;
begin
 edtnum_totalprice.Value := getDatanum('sum(qty*hargabeli)','purchaseorderdetform where ipv='+ Quotedstr(ipcomp));
end;

function TFrmpo.getNobpg : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(pono,3)) from purchaseorder');
      SQL.Add('where pono like "PO' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'PO'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '001'
      else
        result := 'PO'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TFrmpo.ClearForm;
begin
  Fill_ComboBox_with_Data_n_ID(cb_supplier,'select IDsupplier,nama from supplier order by nama','nama','IDsupplier');

  ClearTabel('purchaseorderdetform where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQrypodetform);

  edt_docno.Text     := getNobpg;
  dte_doctgl.Date   := Tglskrg;
  cb_supplier.itemindex  := 0;
  mem_notes.Text := '';
  edtnum_totalprice.value:=0;

  cb_supplier.SetFocus;
end;

procedure TFrmpo.InsertDataMaster;
var idTrans: string;
begin
    DataModule1.ZConnection1.ExecuteDirect('insert into purchaseorder (pono,tgl,IDsupplier,totalprice,notes) values '+
            '(' + QuotedStr(trim(edt_docno.Text)) + ',' +
                  QuotedStr(getmysqldatestr(dte_doctgl.Date)) + ',' +
                  QuotedStr(inttostr(longint(cb_supplier.Items.Objects[cb_supplier.ItemIndex]))) + ',' +
                  QuotedStr(FloatToStr(edtnum_totalprice.Value)) + ',' +
                  QuotedStr(trim(mem_notes.Text)) + ')' );

    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDpurchaseorder from purchaseorder where pono='+ Quotedstr(trim(edt_docno.Text)) ;
    Open;
    idTrans := Fields[0].AsString;
    end;

    DataModule1.ZConnection1.ExecuteDirect('insert into purchaseorderdet (IDpurchaseorder,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(idTrans)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from purchaseorderdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update purchaseorder set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDpurchaseorder=' + Quotedstr(idTrans));
end;

procedure TFrmpo.UpdateDataMaster;
var idTrans: string;
begin
   DataModule1.ZConnection1.ExecuteDirect('update purchaseorder set '+
            'pono='   + Quotedstr(trim(edt_docno.Text)) +
            ',tgl='   + QuotedStr(getmysqldatestr(dte_doctgl.Date)) +
            ',IDsupplier='   + QuotedStr(inttostr(longint(cb_supplier.Items.Objects[cb_supplier.ItemIndex]))) +
            ',totalprice='   + QuotedStr(FloatToStr(edtnum_totalprice.Value)) +
            ',notes='   + QuotedStr(trim(mem_notes.Text)) +
            ',IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +
            ',usernameposted='+ QuotedStr(UserName) +
            ',posted=null ' +
            ' where IDpurchaseorder=' + DataModule1.ZQrypolistIDpurchaseorder.AsString );

    DataModule1.ZConnection1.ExecuteDirect('delete from purchaseorderdet where IDpurchaseorder=' + DataModule1.ZQrypolistIDpurchaseorder.AsString );

    DataModule1.ZConnection1.ExecuteDirect('insert into purchaseorderdet (IDpurchaseorder,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(DataModule1.ZQrypolistIDpurchaseorder.AsString)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from purchaseorderdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update purchaseorder set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDpurchaseorder=' + DataModule1.ZQrypolistIDpurchaseorder.AsString);
end;

procedure TFrmpo.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQrypodetform.Close;
  DataModule1.ZQrypodetform.SQL.Text := 'select * from purchaseorderdetform where ipv='+Quotedstr(ipcomp)+' order by kode ';

  ClearForm;

  if tagacc=EDIT_ACCESS then
    DataModule1.ZConnection1.ExecuteDirect('insert into purchaseorderdetform (ipv,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(ipcomp)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from purchaseorderdet where IDpurchaseorder='+ DataModule1.ZQrypolistIDpurchaseorder.AsString + ' order by kode ');

  RefreshTabel(DataModule1.ZQrypodetform);

  if tagacc=EDIT_ACCESS then
  begin
   if DataModule1.ZQrypolistpono.IsNull=false then edt_docno.Text := DataModule1.ZQrypolistpono.Value;
   if DataModule1.ZQrypolisttgl.IsNull=false then dte_doctgl.Date := DataModule1.ZQrypolisttgl.Value;
   if DataModule1.ZQrypolistIDsupplier.IsNull=false then cb_supplier.itemindex := cb_supplier.Items.IndexOfObject(TObject(DataModule1.ZQrypolistIDsupplier.Value));
   if DataModule1.ZQrypolistnotes.IsNull=false then mem_notes.Text := DataModule1.ZQrypolistnotes.Value;
   if DataModule1.ZQrypolisttotalprice.IsNull=false then edtnum_totalprice.value := DataModule1.ZQrypolisttotalprice.Value;
  end;

end;

procedure TFrmpo.SellBtnAddClick(Sender: TObject);
begin
 cb_supplier.ItemIndex := cb_supplier.Items.IndexOf(cb_supplier.Text);

 if cb_supplier.ItemIndex<=-1 then
 begin
  errordialog('Pilih dahulu Supplier dengan benar!');
  exit;
 end;

 if DataModule1.ZQrypodetform.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if edt_docno.Text='' then
 begin
  errordialog('No. PO tidak boleh kosong!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(isdataexist('select IDpurchaseorder from purchaseorder where pono=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. PO sudah terdaftar!');
  exit;
 end;

 if (tagacc=EDIT_ACCESS)and(isdataexist('select IDpurchaseorder from purchaseorder where IDpurchaseorder<>'+DataModule1.ZQrypolistIDpurchaseorder.AsString+' and docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. PO sudah terdaftar!');
  exit;
 end;

  CetakFaktur := trim(edt_docno.Text);
  DataModule1.ZQrypodetform.CommitUpdates;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select IDproduct from purchaseorderdetform where qty=0 and ipv='+ Quotedstr(ipcomp));
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Nilai tidak boleh kosong!');
      Exit;
    end;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    edtnum_totalprice.Value := getDatanum('sum(qty*hargabeli)','purchaseorderdetform where ipv='+ Quotedstr(ipcomp));
  
    if tagacc=ADD_ACCESS then InsertDataMaster else UpdateDataMaster;
//    PostingJual(CetakFaktur);
    if tagacc=ADD_ACCESS then LogInfo(UserName,'Insert Order Pembelian No PO: ' + edt_docno.Text )
    else LogInfo(UserName,'Edit Order Pembelian No PO: ' + edt_docno.Text );

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    ClearForm;
    InfoDialog('Berhasil Posting, silakan bila hendak Input Order Pembelian lagi!');

    if tagacc=EDIT_ACCESS then close;

  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelpo('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba cek Input Order Pembeliannya!');
  end;

end;

procedure TFrmpo.SellBtnDelClick(Sender: TObject);
begin
 if tagacc=ADD_ACCESS then ClearForm else close;
end;

procedure TFrmpo.DBGriddetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcprod.formSender := Frmpo;
    frmSrcprod.ShowModal;
  end;

  if Key=VK_F5 then SellBtnAddClick(sender);
  if Key=VK_F9 then SellBtnDelClick(sender);

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQrypodetform.CommitUpdates;
      CalculateGridSell;
    if DBGriddet.SelectedIndex = 2 then
    begin
      DBGriddet.SelectedIndex := 0;
    end;
  end;

  if (Key in [VK_DELETE]) then
  begin
    DataModule1.ZQrypodetform.Delete;
    DataModule1.ZQrypodetform.CommitUpdates;
    CalculateGridSell;
  end;
end;

procedure TFrmpo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQrypodetform.Close;

 if tagacc=EDIT_ACCESS then
 begin
  DataModule1.ZQrypodetlist.Close;
  DataModule1.ZQrypolist.Close;
  DataModule1.ZQrypolist.Open;
  DataModule1.ZQrypodetlist.Open;
  DataModule1.ZQrypolist.Locate('pono',edt_docno.Text,[]);

  Frmpolist.Show;
 end;

end;

procedure TFrmpo.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmpo.inputkodebarcode(nilai:string);
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
    if DataModule1.ZQrypodetform.Locate('kode',DataModule1.ZQrySearchProductkode.Value,[]) then
    begin
     DataModule1.ZQrypodetform.Edit;
     vqty := DataModule1.ZQrypodetformqty.Value + 1;
     DataModule1.ZQrypodetformqty.Value := DataModule1.ZQrypodetformqty.Value + 1;

    end
    else
    begin
     if DataModule1.ZQrypodetform.State <> dsEdit then DataModule1.ZQrypodetform.Append
     else
     begin
      DataModule1.ZQrypodetform.CommitUpdates;
      DataModule1.ZQrypodetform.Append;
     end;

    if DataModule1.ZQrypodetform.State <> dsEdit then DataModule1.ZQrypodetform.Append;
    DataModule1.ZQrypodetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQrypodetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQrypodetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQrypodetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQrypodetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQrypodetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQrypodetformipv.Value    := ipcomp;
    end;

    DataModule1.ZQrypindahgudangdetform.CommitUpdates;

    DBGriddet.SetFocus;
    DBGriddet.SelectedIndex := 2;
   end;

   DataModule1.ZQrySearchProduct.Close;
end;

procedure TFrmpo.edt_kodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
 VK_RETURN : if (Sender=TRzEdit(edt_kode)) then
             begin
              inputkodebarcode(edt_kode.Text);
              edt_kode.Text:='';
              edt_kode.SetFocus;
             end;

 VK_F1 :     begin
              if (cb_supplier.itemindex=-1)or(trim(cb_supplier.text)='') then
              begin
               errordialog('Pilih dahulu supplier!');
               exit;
              end;

              frmSrcprod.formSender := Frmpo;
              frmSrcprod.ShowModal;
             end;

 VK_F5 : SellBtnAddClick(sender);
 VK_F9 : SellBtnDelClick(sender);

 end;

end;

end.
