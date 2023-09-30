unit ubahharga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, DateUtils, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass, strutils, DB, RzDBCmbo, DBCtrls,
  VolDBGrid;

type
  TFrmubahharga = class(TForm)
    PanelSell: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
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
    DBGriddet: TVolgaDBGrid;
    procedure SellBtnAddClick(Sender: TObject);
    procedure SellBtnDelClick(Sender: TObject);
    procedure DBGriddet2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cb_gudangKeyDown(Sender: TObject; var Key: Word;
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
  Frmubahharga: TFrmubahharga;

implementation

uses frmSearchProduct, SparePartFunction, data, ubahhargalist;

{$R *.dfm}

function TFrmubahharga.getNobpg : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(docno,3)) from ubahharga');
      SQL.Add('where docno like "UH' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'UH'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '001'
      else
        result := 'UH'+standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TFrmubahharga.ClearForm;
begin
  ClearTabel('ubahhargadetform where ipv='+Quotedstr(ipcomp));
  RefreshTabel(DataModule1.ZQryubahhargadetform);

  edt_docno.Text     := getNobpg;
  dte_doctgl.Date   := Tglskrg;
  mem_notes.Text := '';

  dte_doctgl.SetFocus;
end;

procedure TFrmubahharga.InsertDataMaster;
var idTrans: string;
begin
    DataModule1.ZConnection1.ExecuteDirect('insert into ubahharga (docno,doctgl,notes) values '+
            '(' + QuotedStr(trim(edt_docno.Text)) + ',' +
                  QuotedStr(getmysqldatestr(dte_doctgl.Date)) + ',' +
                  QuotedStr(trim(mem_notes.Text)) + ')' );

    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDubahharga from ubahharga where docno='+ Quotedstr(trim(edt_docno.Text)) ;
    Open;
    idTrans := Fields[0].AsString;
    end;

    DataModule1.ZConnection1.ExecuteDirect('insert into ubahhargadet (IDubahharga,IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku) ' +
       'select '+Quotedstr(idTrans)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku from ubahhargadetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update ubahharga set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDubahharga=' + Quotedstr(idTrans));
end;

procedure TFrmubahharga.UpdateDataMaster;
var idTrans: string;
begin
   DataModule1.ZConnection1.ExecuteDirect('update ubahharga set '+
            'docno='   + Quotedstr(trim(edt_docno.Text)) +
            ',doctgl='   + QuotedStr(getmysqldatestr(dte_doctgl.Date)) +
            ',notes='   + QuotedStr(trim(mem_notes.Text)) +
            ',IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +
            ',usernameposted='+ QuotedStr(UserName) +
            ',posted=null ' +
            ' where IDubahharga=' + DataModule1.ZQryubahhargalistIDubahharga.AsString );

    DataModule1.ZConnection1.ExecuteDirect('delete from ubahhargadet where IDubahharga=' + DataModule1.ZQryubahhargalistIDubahharga.AsString );

    DataModule1.ZConnection1.ExecuteDirect('insert into ubahhargadet (IDubahharga,IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku) ' +
       'select '+Quotedstr(DataModule1.ZQryubahhargalistIDubahharga.AsString)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku from ubahhargadetform where ipv='+ Quotedstr(ipcomp) + ' order by kode ');

    DataModule1.ZConnection1.ExecuteDirect('update ubahharga set IDuserposted='+ QuotedStr(inttostr(IDuserlogin)) +',usernameposted='+ QuotedStr(UserName) + ',posted=now() where IDubahharga=' + DataModule1.ZQryubahhargalistIDubahharga.AsString);
end;

procedure TFrmubahharga.FormShowFirst;
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryubahhargadetform.Close;
  DataModule1.ZQryubahhargadetform.SQL.Text := 'select * from ubahhargadetform where ipv='+Quotedstr(ipcomp)+' order by kode ';

  ClearForm;

  if tagacc=EDIT_ACCESS then
    DataModule1.ZConnection1.ExecuteDirect('insert into ubahhargadetform (ipv,IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku) ' +
       'select '+Quotedstr(ipcomp)+',IDproduct,kode,nama,satuan,hargabeli,hargajual,hargajualbaru,tglberlaku from ubahhargadet where IDubahharga='+ DataModule1.ZQryubahhargalistIDubahharga.AsString + ' order by kode ');

  RefreshTabel(DataModule1.ZQryubahhargadetform);

  if tagacc=EDIT_ACCESS then
  begin
   if DataModule1.ZQryubahhargalistdocno.IsNull=false then edt_docno.Text := DataModule1.ZQryubahhargalistdocno.Value;
   if DataModule1.ZQryubahhargalistdoctgl.IsNull=false then dte_doctgl.Date := DataModule1.ZQryubahhargalistdoctgl.Value;
   if DataModule1.ZQryubahhargalistnotes.IsNull=false then mem_notes.Text := DataModule1.ZQryubahhargalistnotes.Value;
  end;

end;

procedure TFrmubahharga.SellBtnAddClick(Sender: TObject);
begin
 if DataModule1.ZQryubahhargadetform.IsEmpty then
 begin
  errordialog('Transaksi tidak boleh kosong!');
  exit;
 end;

 if edt_docno.Text='' then
 begin
  errordialog('No. Bukti Ubah Harga tidak boleh kosong!');
  exit;
 end;

 if (tagacc=ADD_ACCESS)and(isdataexist('select IDubahharga from ubahharga where docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Ubah Harga sudah terdaftar!');
  exit;
 end;

 if (tagacc=EDIT_ACCESS)and(isdataexist('select IDubahharga from ubahharga where IDubahharga<>'+DataModule1.ZQryubahhargalistIDubahharga.AsString+' and docno=' + Quotedstr(trim(edt_docno.Text)))) then
 begin
  errordialog('No. Bukti Ubah Harga sudah terdaftar!');
  exit;
 end;

  CetakFaktur := trim(edt_docno.Text);
  DataModule1.ZQryubahhargadetform.CommitUpdates;

  DataModule1.ZQryubahhargadetform.First;
  while not DataModule1.ZQryubahhargadetform.Eof do
  begin
   if isdataexist('select IDproduct from ubahhargadet where IDproduct='+DataModule1.ZQryubahhargadetformIDproduct.AsString+' and tglberlaku='+Quotedstr(getmysqldatestr(DataModule1.ZQryubahhargadetformtglberlaku.Value))) then
   begin
    errordialog('Barang '+DataModule1.ZQryubahhargadetformnama.Value+' untuk tgl berlaku tersebut sudah terdaftar!');
    exit;
   end;
   DataModule1.ZQryubahhargadetform.Next;
  end;


  with DataModule1.ZQrySearch do
  begin
    ///Check apakah ada yang belum diinput
    Close;
    SQL.Clear;
    SQL.Add('select IDproduct from ubahhargadetform where ((hargajualbaru<=0)or(tglberlaku is null)) and (ipv='+ Quotedstr(ipcomp) + ')');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Isi Harga Baru dan Tgl Berlaku dengan benar!');
      Exit;
    end;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    if tagacc=ADD_ACCESS then InsertDataMaster else UpdateDataMaster;
//    PostingJual(CetakFaktur);
    if tagacc=ADD_ACCESS then LogInfo(UserName,'Insert Ubah Harga No Bukti: ' + edt_docno.Text )
    else LogInfo(UserName,'Edit Ubah Harga No Bukti: ' + edt_docno.Text );

    DataModule1.ZConnection1.ExecuteDirect('update product p, ubahhargadet u set p.`hargajual`=u.`hargajualbaru` ' +
    'where p.`IDproduct`=u.`IDproduct` and u.`tglberlaku`=date(now()) and p.`hargajual`<>u.`hargajualbaru`;');

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    ClearForm;
    InfoDialog('Berhasil Posting, silakan bila hendak Input Ubah Harga lagi!');

    if tagacc=EDIT_ACCESS then close;

  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_cancelubahharga('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba cek Input Ubah Harganya!');
  end;

end;

procedure TFrmubahharga.SellBtnDelClick(Sender: TObject);
begin
 if tagacc=ADD_ACCESS then ClearForm else close;
end;

procedure TFrmubahharga.DBGriddet2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcprod.formSender := frmubahharga;
    frmSrcprod.ShowModal;
  end;

  if (Key in [VK_RETURN, VK_RIGHT, VK_UP, VK_DOWN, VK_TAB]) then
  begin
      DataModule1.ZQryubahhargadetform.CommitUpdates;
//      CalculateGridSell;
    if DBGriddet.SelectedIndex = 5 then
    begin
      DBGriddet.SelectedIndex := 0;
    end;
  end;

  if (Key in [VK_DELETE]) then
  begin
    DataModule1.ZQryubahhargadetform.Delete;
  end;
end;

procedure TFrmubahharga.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DataModule1.ZQryubahhargadetform.Close;

 if tagacc=EDIT_ACCESS then
 begin
  DataModule1.ZQryubahhargalistdet.Close;
  DataModule1.ZQryubahhargalist.Close;
  DataModule1.ZQryubahhargalist.Open;
  DataModule1.ZQryubahhargalistdet.Open;
  DataModule1.ZQryubahhargalist.Locate('docno',edt_docno.Text,[]);

  Frmubahhargalist.Show;
 end;

end;

procedure TFrmubahharga.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmubahharga.cb_gudangKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
   if (edt_docno.Text='') then
   begin
    errordialog('Isi dahulu No. Bukti Ubah Harga !');
    exit;
   end
   else
   begin
    frmSrcprod.formSender := frmubahharga;
    frmSrcprod.ShowModal;
   end;
  end;

end;

end.
