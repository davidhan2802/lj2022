unit sellmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzButton, RzRadChk, db,
  RzRadGrp, ComCtrls, strutils, dateutils;

type
  TFrmsellmaster = class(TForm)
    PanelPenjualan: TRzPanel;
    RzPanel11: TRzPanel;
    RzLabel39: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    RzLabel44: TRzLabel;
    RzLabel45: TRzLabel;
    RzLabel46: TRzLabel;
    RzLabel47: TRzLabel;
    RzLabel60: TRzLabel;
    SellLblDateLast: TRzLabel;
    SellBtnSearch: TAdvSmoothButton;
    SellTxtSearch: TRzEdit;
    SellTxtSearchby: TRzComboBox;
    SellBtnClear: TAdvSmoothButton;
    SellTxtSearchFirst: TRzDateTimeEdit;
    SellTxtSearchLast: TRzDateTimeEdit;
    RzPanel15: TRzPanel;
    RzLabel62: TRzLabel;
    SellTxtTotalJual: TRzNumericEdit;
    PenjualanDB: TPDJDBGridEx;
    pnl_cetak_list: TRzPanel;
    RzLabel43: TRzLabel;
    SellBtnPrintList: TAdvSmoothButton;
    pnl_del: TRzPanel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel42: TRzLabel;
    pnl_cetak_faktur: TRzPanel;
    SellBtnPrintStruck: TAdvSmoothButton;
    RzLabel204: TRzLabel;
    RGgroup: TRzRadioGroup;
    edtnum_terlakutop: TRzNumericEdit;
    UpDown1: TUpDown;
    btn_delall: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    cb_terlakutop: TRzComboBox;
    pnl_edit: TRzPanel;
    lbledit: TRzLabel;
    BtnEdit: TAdvSmoothButton;
    AdvSmoothButton1: TAdvSmoothButton;
    RzLabel2: TRzLabel;
    procedure SellBtnDelClick(Sender: TObject);
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure SellBtnPrintStruckClick(Sender: TObject);
    procedure SellBtnSearchClick(Sender: TObject);
    procedure SellBtnClearClick(Sender: TObject);
    procedure PenjualanDBDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SellTxtSearchbyChange(Sender: TObject);
    procedure btn_delallClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure AdvSmoothButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListPenjualan;
    procedure PrintListPenjualanItem;
    procedure ZQrySellMasterAfterScroll(DataSet: TDataSet);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmsellmaster: TFrmsellmaster;
  ShowDetail : boolean;

implementation

uses frmSelling,SparePartFunction, U_cetak, Data;

{$R *.dfm}

procedure TFrmsellmaster.FormShowFirst;
begin
 ShowDetail := false;

 ipcomp := getComputerIP;

 DataModule1.ZQrySellMaster.AfterScroll := ZQrySellMasterAfterScroll;


 pnl_del.Visible       := isdel;

 cb_terlakutop.ItemIndex := 0;

 SellTxtSearchFirst.Date := startofthemonth(TglSkrg);
 SellTxtSearchLast.Date  := endofthemonth(TglSkrg);

 edtnum_terlakutop.Value := 20;

 SellBtnClearClick(Self);
end;

procedure TFrmsellmaster.PrintListPenjualan;
var
  FrxMemo: TfrxMemoView;
  ketstr : string;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\selling.fr3');
//  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
//  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));

  ketstr := '';
  if (SellTxtSearch.Text<>'')and(SellTxtSearchby.ItemIndex>=0) then ketstr := ' ' + uppercase(SellTxtSearchby.Text) + ' : ' + SellTxtSearch.Text + '...';

  FrxMemo.Memo.Text := 'PENJUALAN'+ketstr;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tanggal ' + FormatDateTime('dd/MM/yyyy',frmSellMaster.SellTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',frmSellMaster.SellTxtSearchLast.Date);
  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmsellmaster.PrintListPenjualanItem;
var
  FrxMemo: TfrxMemoView;
  ketstr, SearchCategories, strfilter : string;
begin
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 's.faktur';
  1 : SearchCategories := 's.kasir';
  2 : SearchCategories := 's.customer';
  3 : SearchCategories := 's.kota';
  4 : SearchCategories := 's.kodesales';
  end;

  strfilter := '';
  if SellTxtSearch.Text<>'' then strfilter := 'and ('+SearchCategories + ' like ' + Quotedstr(SellTxtSearch.Text + '%') + ') ';

  case RGgroup.ItemIndex of
  0 : DataModule1.frxReport1.LoadFromFile(vpath+'Report\selling.fr3');
  1 :
  begin
   DataModule1.ZQrysellinggol.Close;
   DataModule1.ZQrysellinggol.SQL.Text := 'select p.merk,count(d.kode) frek,sum(d.quantity) qty,sum(d.diskon*d.quantity*d.hargajual*0.01) disc, sum(d.subtotal) subtotal from selldetail d ' +
                                          'left join sellmaster s on d.faktur=s.faktur ' +
                                          'left join product p on d.kode=p.kode ' +
                                          'where (s.isposted = 1) and (s.tanggal between '+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+' and '+Quotedstr(getmysqldatestr(SellTxtSearchLast.Date))+') '+ strfilter +
                                          'group by p.merk order by p.merk ';
   DataModule1.ZQrysellinggol.Open;


   DataModule1.frxReport1.LoadFromFile(vpath+'Report\sellinggol.fr3');
  end;
  2 :
  begin
   DataModule1.ZQrysellingitem.Close;
   DataModule1.ZQrysellingitem.SQL.Text := 'select s.tanggal, s.faktur,p.kode,p.nama,p.barcode,d.quantity, d.hargajual, (d.diskon*d.quantity*d.hargajual*0.01) disc, d.subtotal from selldetail d ' +
                                           'left join sellmaster s on d.faktur=s.faktur '+
                                           'left join product p on d.kode=p.kode ' +
                                           'where (s.isposted = 1) and (s.tanggal between '+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+' and '+Quotedstr(getmysqldatestr(SellTxtSearchLast.Date))+') '+ strfilter + 'order by s.tanggal,s.faktur,p.kode';
   DataModule1.ZQrysellingitem.Open;


   DataModule1.frxReport1.LoadFromFile(vpath+'Report\sellingitem.fr3');
  end;
  3 :
  begin
   if (cb_terlakutop.ItemIndex=0) then
   begin
    DataModule1.ZQrysellingtop.Close;
    DataModule1.ZQrysellingtop.SQL.Text := 'select p.kode,p.barcode,p.nama,p.UT stok,sum(d.quantity) qty,p.hargajual,p.merk nmgol from selldetail d ' +
                                           'left join sellmaster s on d.faktur=s.faktur '+
                                           'left join product p on d.kode=p.kode ' +
                                           'where (s.isposted = 1) and (s.tanggal between '+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+' and '+Quotedstr(getmysqldatestr(SellTxtSearchLast.Date))+') '+ strfilter +
                                           'group by p.kode ' +
                                           'having qty>0 ' +
                                           'order by qty desc limit '+floattostr(edtnum_terlakutop.value);

    DataModule1.ZQrysellingtop.Open;

    DataModule1.frxReport1.LoadFromFile(vpath+'Report\sellingtop.fr3');
   end
   else
   begin
    DataModule1.ZQrysellinggoltop.Close;
    DataModule1.ZQrysellinggoltop.SQL.Text := 'select p.merk,sum(d.quantity) qty,sum(d.subtotal) totjual from selldetail d ' +
                                           'left join sellmaster s on d.faktur=s.faktur '+
                                           'left join product p on d.kode=p.kode ' +
                                           'where (s.isposted = 1) and (s.tanggal between '+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+' and '+Quotedstr(getmysqldatestr(SellTxtSearchLast.Date))+') '+ strfilter +
                                           'group by p.merk ' +
                                           'having qty>0 ' +
                                           'order by qty desc limit '+floattostr(edtnum_terlakutop.value);

    DataModule1.ZQrysellinggoltop.Open;

    DataModule1.frxReport1.LoadFromFile(vpath+'Report\sellinggoltop.fr3');
   end;
  end;

  end;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  ketstr := '';
  if (SellTxtSearch.Text<>'')and(SellTxtSearchby.ItemIndex>=0) then ketstr := ' (' + uppercase(SellTxtSearchby.Text) + ' : ' + SellTxtSearch.Text + '...)';

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  if RGGroup.itemindex=4 then
  begin
   if cb_terlakutop.ItemIndex=0 then
      FrxMemo.Memo.Text := 'BARANG TERLAKU TOP '+floattostr(edtnum_terlakutop.value)+ketstr
   else FrxMemo.Memo.Text := 'DIVISI TERLAKU TOP '+floattostr(edtnum_terlakutop.value)+ketstr;
  end
  else FrxMemo.Memo.Text := 'LAPORAN PENJUALAN'+ketstr;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tanggal ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchLast.Date);

  DataModule1.frxReport1.ShowReport();

  DataModule1.ZQrysellingitem.Close;
  DataModule1.ZQrysellinggol.Close;
  DataModule1.ZQrysellingtop.Close;
end;

procedure TFrmsellmaster.SellBtnDelClick(Sender: TObject);
var
  Qs: string;
begin
  if DataModule1.ZQrySellMaster.IsEmpty then Exit;
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from returjualmaster ');
    SQL.Add('where fakturjual = "' + DataModule1.ZQrySellMasterfaktur.Value + '"');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Penjualan tidak bisa dibatalkan karena sudah ada retur');
      Exit;
    end;
  end;
  if DataModule1.ZQrySellMasterisposted.Value = 0 then
    Qs := 'Hapus '
  else
    Qs := 'Faktur ' + DataModule1.ZQrySellMasterfaktur.Value + ' sudah diposting !' + #13+#10 + 'Batalkan ';
  if QuestionDialog(Qs + 'penjualan ' + DataModule1.ZQrySellMasterfaktur.Value + ' ?') = True then
  begin
    if Qs = 'Hapus ' then
    begin
      LogInfo(UserName,'Menghapus faktur penjualan ' + DataModule1.ZQrySellMasterfaktur.Text + ', nilai penjualan : ' + FormatCurr('Rp ###,##0',DataModule1.ZQrySellMastergrandtotal.Value));
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from selldetail');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQrySellMasterfaktur.Value));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from sellmaster');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQrySellMasterfaktur.Value));
        ExecSQL;

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from inventory');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQrySellMasterfaktur.Value)  + ' and typetrans = ' + Quotedstr('penjualan') );
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQrySellMasterfaktur.Value + ' berhasil dihapus !');
    end
    else
    begin
      LogInfo(UserName,'Membatalkan faktur penjualan ' + DataModule1.ZQrySellMasterfaktur.Text + ', nilai penjualan : ' + FormatCurr('Rp ###,##0',DataModule1.ZQrySellMastergrandtotal.Value));
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update selldetail set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQrySellMasterfaktur.Value + '''');
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('update sellmaster set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQrySellMasterfaktur.Value + '''');
        ExecSQL;

        ///Hapus data di operasional
        Close;
        SQL.Clear;
        SQL.Add('delete from operasional');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQrySellMasterfaktur.Value) + ' and kategori = '+ Quotedstr('PENJUALAN') );
        ExecSQL;

        ///Hapus data di hutang

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from inventory');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQrySellMasterfaktur.Value) + ' and typetrans = ' + Quotedstr('penjualan') );
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQrySellMasterfaktur.Value + ' berhasil dibatalkan !');
    end;
    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmsellmaster.SellBtnPrintListClick(Sender: TObject);
begin
  PrintListPenjualanItem;

end;

procedure TFrmsellmaster.SellBtnPrintStruckClick(Sender: TObject);
begin
 if DataModule1.ZQrySellMaster.IsEmpty then exit;

 PrintStruck(DataModule1.ZQrySellMasterfaktur.Value);
end;

procedure TFrmsellmaster.SellBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'faktur like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'kasir like ''' + SellTxtSearch.Text + '%' + ''' ';
  2 : SearchCategories := 'customer like ''' + SellTxtSearch.Text + '%' + ''' ';
  3 : SearchCategories := 'kota like ''' + SellTxtSearch.Text + '%' + ''' ';
  4 : SearchCategories := 'kodesales like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with DataModule1.ZQrySellMaster do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from sellmaster ');

  //  if (SellTxtSearchby.ItemIndex<2)or(SellTxtSearchby.ItemIndex=5) then
    SQL.Add('where ' + SearchCategories + ' and isposted <> -1 ');
  //  else SQL.Add('where isposted <> -1 ');

    SQL.Add('and tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''' ');
    SQL.Add('order by tanggal,waktu,customer,faktur');

    Open;
    Last;
  end;

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal) from sellmaster ');

//    if (SellTxtSearchby.ItemIndex<2)or(SellTxtSearchby.ItemIndex=5) then
//    begin
     SQL.Add('where ' + SearchCategories );
     SQL.Add('and isposted <> -1 ');
//    end
//    else SQL.Add('where isposted <> -1 ');

    SQL.Add('and tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''' ');
    Open;
    SellTxtTotalJual.Value := Fields[0].AsFloat;
    Close;
  end;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmsellmaster.SellBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQrySellMaster do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from sellmaster ');
    SQL.Add('where (tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''') ');
    SQL.Add('and (isposted <> -1) ');
    SQL.Add('order by tanggal,waktu,customer,faktur');
    Open;
    Last;
  end;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  ///Cari Total Nilai Jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal) from sellmaster');
      SQL.Add('where (tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + '''');
      SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''') ');
      SQL.Add('and (isposted <> -1) ');
    Open;
    SellTxtTotalJual.Value := Fields[0].AsFloat;
    Close;
  end;

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmsellmaster.PenjualanDBDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if DataModule1.ZQrySellMasterisposted.Value <> 0 then
    PenjualanDB.Canvas.Brush.Color := $00A8FFA8
  else
    PenjualanDB.Canvas.Brush.Color := clWindow;
  PenjualanDB.DefaultDrawColumnCell(Rect, DataCol, Column, State);


end;

procedure TFrmsellmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// if ShowDetail=false then

 DataModule1.ZQrySellMaster.Close;

end;

procedure TFrmsellmaster.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := true;

end;

procedure TFrmsellmaster.ZQrySellMasterAfterScroll(DataSet: TDataSet);
begin
end;

procedure TFrmsellmaster.btn_delallClick(Sender: TObject);
begin
 if DataModule1.ZQrySellMaster.IsEmpty then Exit;

 if QuestionDialog('Hapus semua yang tampil?') and
 DataModule1.ZConnection1.ExecuteDirect('delete from sellmaster '+
 DataModule1.ZQrySellMaster.SQL.Strings[1] + ' ' +
 DataModule1.ZQrySellMaster.SQL.Strings[2] + ' ' +
 DataModule1.ZQrySellMaster.SQL.Strings[3]) then
 begin
  DataModule1.ZQrySellMaster.Close;
  DataModule1.ZQrySellMaster.Open;

  infodialog('Berhasil hapus data.');
 end
 else errordialog('Gagal hapus data.');

end;

procedure TFrmsellmaster.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQrySellMasterIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF frmsell=nil then
 application.CreateForm(Tfrmsell,frmsell);

 frmSell.SellLblCaption.Caption := 'Edit Penjualan';
 frmSell.Align:=alclient;
 frmSell.Parent:=self.parent;
 frmSell.BorderStyle:=bsnone;

 if (trim(SellTxtSearch.Text)='') then frmsell.isclearsellmaster := true
 else frmsell.isclearsellmaster := false;

 frmSell.Show;

end;

procedure TFrmsellmaster.AdvSmoothButton1Click(Sender: TObject);
begin
  if (DataModule1.ZQrySellMaster.IsEmpty)or(DataModule1.ZQrySellMasterfaktur.IsNull) then
  begin
   ErrorDialog('Tidak ada Faktur !');
   exit;
  end;

//  if QuestionDialog('Print Amplop Faktur Customer ini?') = False then Exit;

  PrintAmplop(DataModule1.ZQrySellMasterkodecustomer.Value);
end;

end.
