unit pindahgudang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls;

type
  TFrmpindahgudang = class(TForm)
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
    RzPanel1: TRzPanel;
    RzLabel2: TRzLabel;
    cb_gudang: TRzComboBox;
    RzLabel1: TRzLabel;
    cb_gudangto: TRzComboBox;
    mem_notes: TRzMemo;
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
    function CekMaxStock : boolean;
    function getNobpg : string;
    procedure createfilepindahgudang;
    procedure inputkodebarcode(nilai:string);
    { Private declarations }
  public
    tagacc : byte;
    CetakFaktur: string;
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  Frmpindahgudang: TFrmpindahgudang;

implementation

uses frmSearchProduct, SparePartFunction, data, pindahgudanglist;

{$R *.dfm}

function TFrmpindahgudang.getNobpg : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(docno,3)) from pindahgudang');
      SQL.Add('where docno like "PG' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'PG'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '001'
      else
        result := 'PG'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TFrmpindahgudang.ClearForm;
begin
  Fill_ComboBox_with_Data_n_ID(cb_gudang,'select IDgudang,namagudang from gudang where left(kodegudang,2)='+Quotedstr(kodegudang)+' order by IDgudang','namagudang','IDgudang');

  cb_gudang.ItemIndex := cb_gudang.Items.IndexOf(namagudang);
  Fill_ComboBox_with_Data_n_ID(cb_gudangto,'select IDgudang,namagudang from gudang order by IDgudang','namagudang','IDgudang');

  ClearTabel('pindahgudangdetform where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQrypindahgudangdetform);

  edt_docno.Text     := getNobpg;
  dte_doctgl.Date   := Tglskrg;
  cb_gudangto.itemindex  := 0;
  mem_notes.Text := '';

  cb_gudangto.SetFocus;
end;

procedure TFrmpindahgudang.InsertDataMaster;
var idTrans: string;
begin
    DataModule1.ZConnection1.ExecuteDirect('insert into pindahgudang (docno,doctgl,IDgudang,IDgudangto,notes) values '+
            '(' + QuotedStr(trim(edt_docno.Text)) + ',' +
                  QuotedStr(getmysqldatestr(dte_doctgl.Date)) + ',' +
                  QuotedStr(inttostr(longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex]))) + ',' +
                  QuotedStr(inttostr(longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]))) + ',' +
                  QuotedStr(trim(mem_notes.Text)) + ')' );

    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDpindahgudang from pindahgudang where docno='+ Quotedstr(trim(edt_docno.Text)) ;
    Open;
    idTrans := Fields[0].AsString;
    end;

    DataModule1.ZConnection1.ExecuteDirect('insert into pindahgudangdet (IDpindahgudang,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(idTrans)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from pindahgudangdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update pindahgudang set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDpindahgudang=' + Quotedstr(idTrans));
end;

procedure TFrmpindahgudang.UpdateDataMaster;
var idTrans: string;
begin
   DataModule1.ZConnection1.ExecuteDirect('update pindahgudang set '+
            'docno='   + Quotedstr(trim(edt_docno.Text)) +
            ',doctgl='   + QuotedStr(getmysqldatestr(dte_doctgl.Date)) +
            ',IDgudang='   + QuotedStr(inttostr(longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex]))) +
            ',IDgudangto='   + QuotedStr(inttostr(longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]))) +
            ',notes='   + QuotedStr(trim(mem_notes.Text)) +
            ',IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +
            ',usernameposted='+ QuotedStr(UserName) +
            ',posted=null ' +
            ' where IDpindahgudang=' + DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString );

    DataModule1.ZConnection1.ExecuteDirect('delete from pindahgudangdet where IDpindahgudang=' + DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString );

    DataModule1.ZConnection1.ExecuteDirect('insert into pindahgudangdet (IDpindahgudang,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from pindahgudangdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update pindahgudang set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDpindahgudang=' + DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString);
end;

procedure TFrmpindahgudang.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQrypindahgudangdetform.Close;
  DataModule1.ZQrypindahgudangdetform.SQL.Text := 'select * from pindahgudangdetform where ipv='+Quotedstr(ipcomp)+' order by kode ';

  ClearForm;

  if tagacc=EDIT_ACCESS then
    DataModule1.ZConnection1.ExecuteDirect('insert into pindahgudangdetform (ipv,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(ipcomp)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from pindahgudangdet where IDpindahgudang='+ DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString + ' order by kode ');

  RefreshTabel(DataModule1.ZQrypindahgudangdetform);

  if tagacc=EDIT_ACCESS then
  begin
   if DataModule1.ZQrypindahgudanglistdocno.IsNull=false then edt_docno.Text := DataModule1.ZQrypindahgudanglistdocno.Value;
   if DataModule1.ZQrypindahgudanglistdoctgl.IsNull=false then dte_doctgl.Date := DataModule1.ZQrypindahgudanglistdoctgl.Value;
   if DataModule1.ZQrypindahgudanglistIDgudang.IsNull=false then cb_gudang.itemindex := cb_gudang.Items.IndexOfObject(TObject(DataModule1.ZQrypindahgudanglistIDgudang.Value));
   if DataModule1.ZQrypindahgudanglistIDgudangto.IsNull=false then cb_gudangto.itemindex := cb_gudangto.Items.IndexOfObject(TObject(DataModule1.ZQrypindahgudanglistIDgudangto.Value));
   if DataModule1.ZQrypindahgudanglistnotes.IsNull=false then mem_notes.Text := DataModule1.ZQrypindahgudanglistnotes.Value;
  end;

end;

procedure TFrmpindahgudang.createfilepindahgudang;
var pgkodegdgto : string;
begin
 pgkodegdgto := trim(getdata('kodegudang','gudang where IDgudang='+inttostr(longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]))));
 deletefile(pgpathloc+'/'+trim(edt_docno.Text)+pgkodegdgto+'.txt');
 DataModule1.ZConnection1.ExecuteDirect('select '+Quotedstr(ipcomp)+',i.IDproduct,p.kode,p.nama,p.satuan,i.qty,i.hargabeli,i.hargajual,p.merk,p.seri,p.IDgolongan,p.hargabeli,p.hargajual,p.keterangan,p.tglnoneffective,p.diskon,p.diskonrp,p.barcode,p.reorderqty,p.expdate from pindahgudangdetform i ' +
                                        'left join product p on i.kode=p.kode where i.ipv='+Quotedstr(ipcomp)+ ' order by i.IDproduct into outfile "'+pgpathloc+'/'+trim(edt_docno.Text)+pgkodegdgto+'.txt" ');

end;

procedure TFrmpindahgudang.SellBtnAddClick(Sender: TObject);
begin
 cb_gudang.ItemIndex := cb_gudang.Items.IndexOf(cb_gudang.Text);
 cb_gudangto.ItemIndex := cb_gudangto.Items.IndexOf(cb_gudangto.Text);

 if cb_gudang.ItemIndex<=-1 then
 begin
  errordialog('Pilih dahulu Gudang Asal dengan benar!');
  exit;
 end;

 if cb_gudangto.ItemIndex<=-1 then
 begin
  errordialog('Pilih dahulu Gudang Tujuan dengan benar!');
  exit;
 end;

 if longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex])=longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]) then
 begin
  errordialog('Gudang Asal dan Tujuan tidak boleh sama!');
  exit;
 end;

 if DataModule1.ZQrypindahgudangdetform.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if edt_docno.Text='' then
 begin
  errordialog('No. Bukti Pengeluaran Gudang tidak boleh kosong!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(isdataexist('select IDpindahgudang from pindahgudang where docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Pengeluaran Gudang sudah terdaftar!');
  exit;
 end;

 if (tagacc=EDIT_ACCESS)and(isdataexist('select IDpindahgudang from pindahgudang where IDpindahgudang<>'+DataModule1.ZQrypindahgudanglistIDpindahgudang.AsString+' and docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Pengeluaran Gudang sudah terdaftar!');
  exit;
 end;

  CetakFaktur := trim(edt_docno.Text);
  DataModule1.ZQrypindahgudangdetform.CommitUpdates;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select IDproduct from pindahgudangdetform where qty=0 and ipv='+ Quotedstr(ipcomp));
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Nilai tidak boleh kosong!');
      Exit;
    end;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    if tagacc=ADD_ACCESS then InsertDataMaster else UpdateDataMaster;
//    PostingJual(CetakFaktur);
    if tagacc=ADD_ACCESS then LogInfo(UserName,'Insert Pengeluaran Gudang No Bukti: ' + edt_docno.Text )
    else LogInfo(UserName,'Edit Pengeluaran Gudang No Bukti: ' + edt_docno.Text );

    createfilepindahgudang;

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    ClearForm;
    InfoDialog('Berhasil Posting, silakan bila hendak Input Pengeluaran Gudang lagi!');

    if tagacc=EDIT_ACCESS then close;

  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelpindahgudang('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba cek Input Pengeluaran Gudangnya!');
  end;

end;

procedure TFrmpindahgudang.SellBtnDelClick(Sender: TObject);
begin
 if tagacc=ADD_ACCESS then ClearForm else close;
end;

function TFrmpindahgudang.CekMaxStock : boolean;
var vqtyprev : double;
begin
  result := false;

  vqtyprev:= 0;
  if tagacc=EDIT_ACCESS then vqtyprev := DataModule1.ZQrypindahgudangdetformqty.Value;

  if (DataModule1.ZQrypindahgudangdetform.State <> dsInsert) or (DataModule1.ZQrypindahgudangdetform.State <> dsEdit) then
    DataModule1.ZQrypindahgudangdetform.Edit;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
//    SQL.Add('select qty from v_stock');
//    SQL.Add('where kodegudang = '+ QuotedStr(KodeGudang) +' and kodebrg = ' + QuotedStr(DataModule1.ZQrypindahgudangdetformkode.Value));
    SQL.Add('select '+getdata('kodegudang','gudang where namagudang='+Quotedstr(trim(cb_gudang.Text)))+' from product ');
    SQL.Add('where IDproduct = ' + QuotedStr(DataModule1.ZQrypindahgudangdetformIDproduct.AsString)); //+ ' and IDgudang='+ Inttostr(longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex])) );
    Open;
    if DBGriddet.Fields[2].AsFloat > (DataModule1.ZQryFunction.Fields[0].AsFloat+vqtyprev) then
    begin
      WarningDialog('Jumlah Stock Maksimum '+DataModule1.ZQrypindahgudangdetformkode.Value+' adalah ' + Fields[0].AsString);
      DBGriddet.Fields[2].AsFloat := DataModule1.ZQryFunction.Fields[0].AsFloat;
    end
    else result := true;
  end;
end;

procedure TFrmpindahgudang.DBGriddetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (trim(cb_gudang.Text)='')or(cb_gudang.ItemIndex=-1) then
  begin
   errordialog('Pilih dahulu Gudang Asal!');
   exit;
  end;

  if (trim(cb_gudangto.Text)='')or(cb_gudangto.ItemIndex=-1) then
  begin
   errordialog('Pilih dahulu Gudang Tujuan!');
   exit;
  end;

  if Key = VK_F1 then
  begin
    frmSrcprod.formSender := frmpindahgudang;
    frmSrcprod.ShowModal;
  end;

  if Key = VK_F5 then SellBtnAddClick(sender);
  if Key = VK_F9 then SellBtnDelClick(sender);

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQrypindahgudangdetform.CommitUpdates;
//      CalculateGridSell;
    if DBGriddet.SelectedIndex = 2 then
    begin
      CekMaxStock;

      DBGriddet.SelectedIndex := 0;
    end;
  end;

  if (Key in [VK_DELETE]) then
  begin
    DataModule1.ZQrypindahgudangdetform.Delete;
  end;
end;

procedure TFrmpindahgudang.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQrypindahgudangdetform.Close;

 if tagacc=EDIT_ACCESS then
 begin
  DataModule1.ZQrypindahgudanglistdet.Close;
  DataModule1.ZQrypindahgudanglist.Close;
  DataModule1.ZQrypindahgudanglist.Open;
  DataModule1.ZQrypindahgudanglistdet.Open;
  DataModule1.ZQrypindahgudanglist.Locate('docno',edt_docno.Text,[]);

  Frmpindahgudanglist.Show;
 end;

end;

procedure TFrmpindahgudang.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmpindahgudang.inputkodebarcode(nilai:string);
var bufstr : string;
    vqty : double;
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
    if DataModule1.ZQrypindahgudangdetform.Locate('kode',DataModule1.ZQrySearchProductkode.Value,[]) then
    begin
     DataModule1.ZQrypindahgudangdetform.Edit;
     vqty := DataModule1.ZQrypindahgudangdetformqty.Value + 1;
     DataModule1.ZQrypindahgudangdetformqty.Value := DataModule1.ZQrypindahgudangdetformqty.Value + 1;

    end
    else
    begin
     if DataModule1.ZQrypindahgudangdetform.State <> dsEdit then DataModule1.ZQrypindahgudangdetform.Append
     else
     begin
      DataModule1.ZQrypindahgudangdetform.CommitUpdates;
      DataModule1.ZQrypindahgudangdetform.Append;
     end;

    if DataModule1.ZQrypindahgudangdetform.State <> dsEdit then DataModule1.ZQrypindahgudangdetform.Append;
    DataModule1.ZQrypindahgudangdetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQrypindahgudangdetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQrypindahgudangdetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQrypindahgudangdetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQrypindahgudangdetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQrypindahgudangdetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQrypindahgudangdetformipv.Value    := ipcomp;
    end;

    DataModule1.ZQrypindahgudangdetform.CommitUpdates;

    DBGriddet.SetFocus;
    DBGriddet.SelectedIndex := 2;
   end;

   DataModule1.ZQrySearchProduct.Close;
end;

procedure TFrmpindahgudang.edt_kodeKeyDown(Sender: TObject; var Key: Word;
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
              if (trim(cb_gudang.Text)='')or(cb_gudang.ItemIndex=-1) then
              begin
               errordialog('Pilih dahulu Gudang Asal!');
               exit;
              end;

              if (trim(cb_gudangto.Text)='')or(cb_gudangto.ItemIndex=-1) then
              begin
               errordialog('Pilih dahulu Gudang Tujuan!');
               exit;
              end;

              frmSrcprod.formSender := frmpindahgudang;
              frmSrcprod.ShowModal;
             end;

 VK_F5 : SellBtnAddClick(sender);
 VK_F9 : SellBtnDelClick(sender);

 end;

end;

end.
