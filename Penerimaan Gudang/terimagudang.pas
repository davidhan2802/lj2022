unit terimagudang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls;

type
  TFrmterimagudang = class(TForm)
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
    OpenDialog1: TOpenDialog;
    btn_getfile: TRzButton;
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure DBGriddetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cb_gudangKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_getfileClick(Sender: TObject);
  private
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateDataMaster;
    function getNobpg : string;

    { Private declarations }
  public
    tagacc : byte;
    CetakFaktur: string;
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  Frmterimagudang: TFrmterimagudang;

implementation

uses frmSearchProduct, SparePartFunction, data, terimagudanglist;

{$R *.dfm}

function TFrmterimagudang.getNobpg : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(docno,3)) from terimagudang');
      SQL.Add('where docno like "TG' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'TG'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '001'
      else
        result := 'TG'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TFrmterimagudang.ClearForm;
begin
  Fill_ComboBox_with_Data_n_ID(cb_gudangto,'select IDgudang,namagudang from gudang where left(kodegudang,2)='+Quotedstr(kodegudang)+' order by IDgudang','namagudang','IDgudang');

  cb_gudangto.ItemIndex := cb_gudangto.Items.IndexOf(namagudang);
  Fill_ComboBox_with_Data_n_ID(cb_gudang,'select IDgudang,namagudang from gudang order by IDgudang','namagudang','IDgudang');

  ClearTabel('terimagudangdetform where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQryterimagudangdetform);

  edt_docno.Text     := getNobpg;
  dte_doctgl.Date   := Tglskrg;
  cb_gudang.itemindex  := 0;
  cb_gudangto.itemindex := 1;
  mem_notes.Text := '';

  cb_gudangto.SetFocus;
end;

procedure TFrmterimagudang.InsertDataMaster;
var idTrans: string;
begin
    DataModule1.ZConnection1.ExecuteDirect('insert into terimagudang (docno,doctgl,IDgudangfrom,IDgudang,notes) values '+
            '(' + QuotedStr(trim(edt_docno.Text)) + ',' +
                  QuotedStr(getmysqldatestr(dte_doctgl.Date)) + ',' +
                  QuotedStr(inttostr(longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex]))) + ',' +
                  QuotedStr(inttostr(longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]))) + ',' +
                  QuotedStr(trim(mem_notes.Text)) + ')' );

    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDterimagudang from terimagudang where docno='+ Quotedstr(trim(edt_docno.Text)) ;
    Open;
    idTrans := Fields[0].AsString;
    end;

    DataModule1.ZConnection1.ExecuteDirect('insert into terimagudangdet (IDterimagudang,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(idTrans)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from terimagudangdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update terimagudang set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDterimagudang=' + Quotedstr(idTrans));
end;

procedure TFrmterimagudang.UpdateDataMaster;
var idTrans: string;
begin
   DataModule1.ZConnection1.ExecuteDirect('update terimagudang set '+
            'docno='   + Quotedstr(trim(edt_docno.Text)) +
            ',doctgl='   + QuotedStr(getmysqldatestr(dte_doctgl.Date)) +
            ',IDgudangfrom='   + QuotedStr(inttostr(longint(cb_gudang.Items.Objects[cb_gudang.ItemIndex]))) +
            ',IDgudang='   + QuotedStr(inttostr(longint(cb_gudangto.Items.Objects[cb_gudangto.ItemIndex]))) +
            ',notes='   + QuotedStr(trim(mem_notes.Text)) +
            ',IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +
            ',usernameposted='+ QuotedStr(UserName) +
            ',posted=null ' +
            ' where IDterimagudang=' + DataModule1.ZQryterimagudanglistIDterimagudang.AsString );

    DataModule1.ZConnection1.ExecuteDirect('delete from terimagudangdet where IDterimagudang=' + DataModule1.ZQryterimagudanglistIDterimagudang.AsString );

    DataModule1.ZConnection1.ExecuteDirect('insert into terimagudangdet (IDterimagudang,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(DataModule1.ZQryterimagudanglistIDterimagudang.AsString)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from terimagudangdetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update terimagudang set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDterimagudang=' + DataModule1.ZQryterimagudanglistIDterimagudang.AsString);
end;

procedure TFrmterimagudang.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryterimagudangdetform.Close;
  DataModule1.ZQryterimagudangdetform.SQL.Text := 'select * from terimagudangdetform where ipv='+Quotedstr(ipcomp)+' order by kode ';

  ClearForm;

  if tagacc=EDIT_ACCESS then
    DataModule1.ZConnection1.ExecuteDirect('insert into terimagudangdetform (ipv,IDproduct,kode,nama,satuan,hargabeli,hargajual,qty) ' +
       'select '+Quotedstr(ipcomp)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,qty from terimagudangdet where IDterimagudang='+ DataModule1.ZQryterimagudanglistIDterimagudang.AsString + ' order by kode ');

  RefreshTabel(DataModule1.ZQryterimagudangdetform);

  if tagacc=EDIT_ACCESS then
  begin
   if DataModule1.ZQryterimagudanglistdocno.IsNull=false then edt_docno.Text := DataModule1.ZQryterimagudanglistdocno.Value;
   if DataModule1.ZQryterimagudanglistdoctgl.IsNull=false then dte_doctgl.Date := DataModule1.ZQryterimagudanglistdoctgl.Value;
   if DataModule1.ZQryterimagudanglistIDgudangfrom.IsNull=false then cb_gudang.itemindex := cb_gudang.Items.IndexOfObject(TObject(DataModule1.ZQryterimagudanglistIDgudangfrom.Value));
   if DataModule1.ZQryterimagudanglistIDgudang.IsNull=false then cb_gudangto.itemindex := cb_gudangto.Items.IndexOfObject(TObject(DataModule1.ZQryterimagudanglistIDgudang.Value));
   if DataModule1.ZQryterimagudanglistnotes.IsNull=false then mem_notes.Text := DataModule1.ZQryterimagudanglistnotes.Value;
  end;

end;

procedure TFrmterimagudang.SellBtnAddClick(Sender: TObject);
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

 if DataModule1.ZQryterimagudangdetform.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if edt_docno.Text='' then
 begin
  errordialog('No. Bukti Penerimaan Gudang tidak boleh kosong!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(isdataexist('select IDterimagudang from terimagudang where docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Penerimaan Gudang sudah terdaftar!');
  exit;
 end;

 if (tagacc=EDIT_ACCESS)and(isdataexist('select IDterimagudang from terimagudang where IDterimagudang<>'+DataModule1.ZQryterimagudanglistIDterimagudang.AsString+' and docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Penerimaan Gudang sudah terdaftar!');
  exit;
 end;

  CetakFaktur := trim(edt_docno.Text);
  DataModule1.ZQryterimagudangdetform.CommitUpdates;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select IDproduct from terimagudangdetform where qty=0 and ipv='+ Quotedstr(ipcomp));
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
    if tagacc=ADD_ACCESS then LogInfo(UserName,'Insert Penerimaan Gudang No Bukti: ' + edt_docno.Text )
    else LogInfo(UserName,'Edit Penerimaan Gudang No Bukti: ' + edt_docno.Text );

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    ClearForm;
    InfoDialog('Berhasil Posting, silakan bila hendak Input Penerimaan Gudang lagi!');

    if tagacc=EDIT_ACCESS then close;

  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelterimagudang('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba cek Input Penerimaan Gudangnya!');
  end;

end;

procedure TFrmterimagudang.SellBtnDelClick(Sender: TObject);
begin
 if tagacc=ADD_ACCESS then ClearForm else close;
end;

procedure TFrmterimagudang.DBGriddetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcprod.formSender := frmterimagudang;
    frmSrcprod.ShowModal;
  end;

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQryterimagudangdetform.CommitUpdates;
//      CalculateGridSell;
    if DBGriddet.SelectedIndex = 2 then
    begin
      DBGriddet.SelectedIndex := 0;
    end;
  end;

  if (Key in [VK_DELETE]) then
  begin
    DataModule1.ZQryterimagudangdetform.Delete;
  end;
end;

procedure TFrmterimagudang.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQryterimagudangdetform.Close;

 if tagacc=EDIT_ACCESS then
 begin
  DataModule1.ZQryterimagudanglistdet.Close;
  DataModule1.ZQryterimagudanglist.Close;
  DataModule1.ZQryterimagudanglist.Open;
  DataModule1.ZQryterimagudanglistdet.Open;
  DataModule1.ZQryterimagudanglist.Locate('docno',edt_docno.Text,[]);

  Frmterimagudanglist.Show;
 end;

end;

procedure TFrmterimagudang.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmterimagudang.cb_gudangKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
   if (edt_docno.Text='') then
   begin
    errordialog('Isi dahulu No. Bukti Penerimaan Gudang !');
    exit;
   end
   else
   begin
    frmSrcprod.formSender := frmterimagudang;
    frmSrcprod.ShowModal;
   end;
  end;

end;

procedure TFrmterimagudang.btn_getfileClick(Sender: TObject);
var vnmfile : string;
begin
 if OpenDialog1.Execute then
 begin
  ClearTabel('terimagudangdetform where ipv='+Quotedstr(ipcomp));

  Datamodule1.ZConnection1.ExecuteDirect('delete from inventoryimp');// where ipv='+Quotedstr(ipcomp) );

  vnmfile :=  stringreplace(OpenDialog1.FileName,'\','/',[rfReplaceAll,rfIgnorecase]);
  if Datamodule1.ZConnection1.ExecuteDirect('LOAD DATA INFILE "'+vnmfile+'" INTO TABLE inventoryimp;') then
  begin
   Datamodule1.ZConnection1.ExecuteDirect('update terimagudangdetform set ipv='+Quotedstr(ipcomp));
   infodialog('Proses Loading Data From File selesai.');
  end;

  DataModule1.ZQryterimagudangdetform.Close;
  DataModule1.ZQryterimagudangdetform.Open;
 end;

end;

end.
