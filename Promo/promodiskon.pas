unit promodiskon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls;

type
  TFrmpromodiskon = class(TForm)
    PanelSell: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    DBGriddet: TRzDBGrid;
    RzPanel7: TRzPanel;
    SellBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    GB_promo: TRzGroupBox;
    RzLabel13: TRzLabel;
    edt_docno: TRzEdit;
    RzLabel15: TRzLabel;
    dte_doctgl: TRzDateTimeEdit;
    BtnSave: TAdvSmoothButton;
    RzPanel1: TRzPanel;
    RzLabel2: TRzLabel;
    RzLabel1: TRzLabel;
    mem_notes: TRzMemo;
    dte_tglawal: TRzDateTimeEdit;
    dte_tglakhir: TRzDateTimeEdit;
    ccx_isactive: TRzCheckBox;
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure DBGriddetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dte_tglawalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  Frmpromodiskon: TFrmpromodiskon;

implementation

uses frmSearchProduct, SparePartFunction, data, promodiskonlist;

{$R *.dfm}

function TFrmpromodiskon.getNobpg : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(docno,3)) from diskon');
      SQL.Add('where docno like "PD' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'PD'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '001'
      else
        result := 'PD'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TFrmpromodiskon.ClearForm;
begin
  ClearTabel('diskondetform where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQrydiskondetform);

  edt_docno.Text     := getNobpg;
  dte_doctgl.Date    := Tglskrg;
  dte_tglawal.Date   := Tglskrg;
  dte_tglakhir.Date  := Tglskrg;

  mem_notes.Text := '';

  ccx_isactive.checked := true;

  dte_tglawal.SetFocus;
end;

procedure TFrmpromodiskon.InsertDataMaster;
var idTrans: string;
    visactive : byte;
begin
    visactive := 0;
    if ccx_isactive.checked then visactive := 1;

    DataModule1.ZConnection1.ExecuteDirect('insert into diskon (docno,doctgl,tglawal,tglakhir,isactive,notes) values '+
            '(' + QuotedStr(trim(edt_docno.Text)) + ',' +
                  QuotedStr(getmysqldatestr(dte_doctgl.Date)) + ',' +
                  QuotedStr(getmysqldatestr(dte_tglawal.Date)) + ',' +
                  QuotedStr(getmysqldatestr(dte_tglakhir.Date)) + ',' +
                  QuotedStr(inttostr(visactive)) + ',' +
                  QuotedStr(trim(mem_notes.Text)) + ')' );

    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDdiskon from diskon where docno='+ Quotedstr(trim(edt_docno.Text)) ;
    Open;
    idTrans := Fields[0].AsString;
    end;

    DataModule1.ZConnection1.ExecuteDirect('insert into diskondet (IDdiskon,IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli) ' +
       'select '+Quotedstr(idTrans)+',IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli from diskondetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update diskon set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDdiskon=' + Quotedstr(idTrans));
end;

procedure TFrmpromodiskon.UpdateDataMaster;
var idTrans: string;
    visactive : byte;
begin
    visactive := 0;
    if ccx_isactive.checked then visactive := 1;

   DataModule1.ZConnection1.ExecuteDirect('update diskon set '+
            'docno='   + Quotedstr(trim(edt_docno.Text)) +
            ',doctgl='   + QuotedStr(getmysqldatestr(dte_doctgl.Date)) +
            ',tglawal='   + QuotedStr(getmysqldatestr(dte_tglawal.Date)) +
            ',tglakhir='   + QuotedStr(getmysqldatestr(dte_tglakhir.Date)) + 
            ',isactive='   + QuotedStr(inttostr(visactive)) + 
            ',notes='   + QuotedStr(trim(mem_notes.Text)) +
            ',IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +
            ',usernameposted='+ QuotedStr(UserName) +
            ',posted=null ' +
            ' where IDdiskon=' + DataModule1.ZQrydiskonlistIDdiskon.AsString );

    DataModule1.ZConnection1.ExecuteDirect('delete from diskondet where IDdiskon=' + DataModule1.ZQrydiskonlistIDdiskon.AsString );

    DataModule1.ZConnection1.ExecuteDirect('insert into diskondet (IDdiskon,IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli) ' +
       'select '+Quotedstr(DataModule1.ZQrydiskonlistIDdiskon.AsString)+',IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli from diskondetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update diskon set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDdiskon=' + DataModule1.ZQrydiskonlistIDdiskon.AsString);
end;

procedure TFrmpromodiskon.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQrydiskondetform.Close;
  DataModule1.ZQrydiskondetform.SQL.Text := 'select * from diskondetform where ipv='+Quotedstr(ipcomp)+' order by kode ';

  GB_promo.Enabled := true;
  DBGriddet.ReadOnly := false;

  ClearForm;

  if tagacc=EDIT_ACCESS then
    DataModule1.ZConnection1.ExecuteDirect('insert into diskondetform (ipv,IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli) ' +
       'select '+Quotedstr(ipcomp)+',IDproduct,kode,nama,satuan,hargajual,diskonrp,minqty,maxqty,hargabeli from diskondet where IDdiskon='+ DataModule1.ZQrydiskonlistIDdiskon.AsString + ' order by kode ');

  RefreshTabel(DataModule1.ZQrydiskondetform);

  if tagacc=EDIT_ACCESS then
  begin
   if DataModule1.ZQrydiskonlistdocno.IsNull=false then edt_docno.Text := DataModule1.ZQrydiskonlistdocno.Value;
   if DataModule1.ZQrydiskonlistdoctgl.IsNull=false then dte_doctgl.Date := DataModule1.ZQrydiskonlistdoctgl.Value;
   if DataModule1.ZQrydiskonlisttglawal.IsNull=false then dte_tglawal.Date := DataModule1.ZQrydiskonlisttglawal.Value;
   if DataModule1.ZQrydiskonlisttglakhir.IsNull=false then dte_tglakhir.Date := DataModule1.ZQrydiskonlisttglakhir.Value;
   if DataModule1.ZQrydiskonlistnotes.IsNull=false then mem_notes.Text := DataModule1.ZQrydiskonlistnotes.Value;
   if DataModule1.ZQrydiskonlistisactive.IsNull=false then ccx_isactive.checked := DataModule1.ZQrydiskonlistisactive.Value=1;

//   GB_promo.Enabled := dte_tglawal.Date > dateof(tglskrg);
//   DBGriddet.ReadOnly := GB_promo.Enabled = false;
  end;

end;

procedure TFrmpromodiskon.SellBtnAddClick(Sender: TObject);
begin
 if dte_tglawal.Date>dte_tglakhir.Date then
 begin
  errordialog('Tanggal Akhir tidak boleh lebih kecil dari tanggal awal!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(dte_tglawal.Date<dateof(Tglskrg)) then
 begin
  errordialog('Tanggal Awal minimal hari ini!');
  exit;
 end;

 if DataModule1.ZQrydiskondetform.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if edt_docno.Text='' then
 begin
  errordialog('No. Bukti Promo Diskon tidak boleh kosong!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(isdataexist('select IDdiskon from diskon where docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Promo Diskon sudah terdaftar!');
  exit;
 end;

 if (tagacc=EDIT_ACCESS)and(isdataexist('select IDdiskon from diskon where IDdiskon<>'+DataModule1.ZQrydiskonlistIDdiskon.AsString+' and docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Promo Diskon sudah terdaftar!');
  exit;
 end;

  CetakFaktur := trim(edt_docno.Text);
  DataModule1.ZQrydiskondetform.CommitUpdates;

  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select IDproduct from diskondetform where ((diskonrp=0)or(maxqty<minqty)) and (ipv='+ Quotedstr(ipcomp) + ') ');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Diskon (Rp.) tidak boleh kosong dan Max. Qty harus lebih besar dari Min. Qty!');
      Exit;
    end;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    if tagacc=ADD_ACCESS then InsertDataMaster else UpdateDataMaster;
//    PostingJual(CetakFaktur);

    if tagacc=ADD_ACCESS then LogInfo(UserName,'Insert Promo Diskon No Bukti: ' + edt_docno.Text )
    else LogInfo(UserName,'Edit Promo Diskon No Bukti: ' + edt_docno.Text );

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    if tagacc=ADD_ACCESS then
    begin
     ClearForm;
     InfoDialog('Berhasil Posting, silakan bila hendak Input Promo Diskon lagi!');
    end
    else
    begin
     InfoDialog('Berhasil Edit Posting!');
     close;
    end;
  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelpromodiskon('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba cek Input Promo Diskonnya!');
  end;

end;

procedure TFrmpromodiskon.SellBtnDelClick(Sender: TObject);
begin
 if tagacc=ADD_ACCESS then ClearForm else close;
end;

procedure TFrmpromodiskon.DBGriddetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcprod.formSender := frmpromodiskon;
    frmSrcprod.ShowModal;
  end;

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
    DataModule1.ZQrydiskondetform.CommitUpdates;
//      CalculateGridSell;
    if DBGriddet.SelectedIndex = 3 then DBGriddet.SelectedIndex := 0;
  end;

  if (Key in [VK_DELETE]) then
  begin
    DataModule1.ZQrydiskondetform.Delete;
  end;
end;

procedure TFrmpromodiskon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQrydiskondetform.Close;

 if tagacc=EDIT_ACCESS then
 begin
  DataModule1.ZQrydiskondetlist.Close;
  DataModule1.ZQrydiskonlist.Close;
  DataModule1.ZQrydiskonlist.Open;
  DataModule1.ZQrydiskondetlist.Open;
  DataModule1.ZQrydiskonlist.Locate('docno',edt_docno.Text,[]);

  frmpromodiskonlist.Show;
 end;

end;

procedure TFrmpromodiskon.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmpromodiskon.dte_tglawalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
   if (edt_docno.Text='') then
   begin
    errordialog('Isi dahulu No. Bukti Promo Diskon !');
    exit;
   end
   else
   begin
    frmSrcprod.formSender := frmpromodiskon;
    frmSrcprod.ShowModal;
   end;
  end;

end;

end.
