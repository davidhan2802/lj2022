unit buymaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzRadGrp, ComCtrls, dateutils;

type
  TFrmbuymaster = class(TForm)
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
    PenjualanDB: TPDJDBGridEx;
    pnl_del: TRzPanel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel42: TRzLabel;
    pnl_edit: TRzPanel;
    pnl_cetak_list: TRzPanel;
    RzLabel43: TRzLabel;
    SellBtnPrintList: TAdvSmoothButton;
    RGgroup: TRzRadioGroup;
    BtnEdit: TAdvSmoothButton;
    lbledit: TRzLabel;
    SellBtnPrintStruck: TAdvSmoothButton;
    RzLabel204: TRzLabel;
    btn_delall: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    RzPanel15: TRzPanel;
    RzLabel62: TRzLabel;
    SellTxtTotalJual: TRzNumericEdit;
    procedure SellBtnDelClick(Sender: TObject);
    procedure SellBtnPrintStruckClick(Sender: TObject);
    procedure SellBtnSearchClick(Sender: TObject);
    procedure SellBtnClearClick(Sender: TObject);
    procedure PenjualanDBDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure SellTxtSearchbyChange(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure btn_delallClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListPembelian;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmbuymaster: TFrmbuymaster;
  ShowDetail : boolean;

implementation

uses SparePartFunction, frmbuying, Data;

{$R *.dfm}

procedure TFrmbuymaster.FormShowFirst;
begin
 ShowDetail := false;

 ipcomp := getComputerIP;

 pnl_del.Visible       := isdel;
 pnl_edit.Visible      := isedit;

// pnl_cetak_faktur.Visible := isprintfakturpenjualan;
// SellTxtSearchFirst.Date := EncodeDate(Year,Month,1);
// SellTxtSearchLast.Date  := EncodeDate(Year,Month,(DaysInAMonth(Year,Month)));
 SellTxtSearchFirst.Date := startofthemonth(TglSkrg);
 SellTxtSearchLast.Date  := endofthemonth(TglSkrg);

 SellBtnClearClick(Self);
end;

procedure TFrmbuymaster.SellBtnDelClick(Sender: TObject);
var
  Qs: string;
begin
  if DataModule1.ZQryBuyMaster.IsEmpty then Exit;

  if DataModule1.ZQryBuyMasterisposted.Value = 0 then
    Qs := 'Hapus '
  else
    Qs := 'Faktur ' + DataModule1.ZQryBuyMasterfaktur.Value + ' sudah diposting !' + #13+#10 + 'Batalkan ';
  if QuestionDialog(Qs + 'Pembelian ' + DataModule1.ZQryBuyMasterfaktur.Value + ' ?') = True then
  begin
    Qs := 'Hapus ';
    if Qs = 'Hapus ' then
    begin
      LogInfo(UserName,'Menghapus faktur pembelian ' + DataModule1.ZQryBuyMasterfaktur.Text + ', nilai pembelian : ' + FormatCurr('Rp ###,##0',DataModule1.ZQryBuyMastergrandtotal.Value));
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from buydetail');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQryBuyMasterfaktur.Value));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from buymaster');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQryBuyMasterfaktur.Value));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from operasional');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQryBuyMasterfaktur.Value) + ' and kategori = '+ Quotedstr('PEMBELIAN') );
        ExecSQL;

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from inventory');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQryBuyMasterfaktur.Value) + ' and typetrans = ' + Quotedstr('pembelian') );
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryBuyMasterfaktur.Value + ' berhasil dihapus !');
    end
    else
    begin
      LogInfo(UserName,'Membatalkan faktur pembelian ' + DataModule1.ZQryBuyMasterfaktur.Text + ', nilai pembelian : ' + FormatCurr('Rp ###,##0',DataModule1.ZQryBuyMastergrandtotal.Value));
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update buydetail set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryBuyMasterfaktur.Value + '''');
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('update buymaster set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryBuyMasterfaktur.Value + '''');
        ExecSQL;

        ///Hapus data di operasional
        Close;
        SQL.Clear;
        SQL.Add('delete from operasional');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQryBuyMasterfaktur.Value) + ' and kategori = '+ Quotedstr('PEMBELIAN') );
        ExecSQL;

        ///Hapus data di hutang

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from inventory');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQryBuyMasterfaktur.Value) + ' and typetrans = ' + Quotedstr('pembelian') );
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryBuyMasterfaktur.Value + ' berhasil dibatalkan !');
    end;
    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmbuymaster.SellBtnPrintStruckClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
  vlok : string;
begin
  ///Hanya berlaku untuk yang sudah diposting saja
  ///(Sebagai Backup jika ada trouble pada saat pencetakan struck
{  if DataModule1.ZQryBuyMasterisposted.Value <> 1 then
  begin
    ErrorDialog('Faktur ' + DataModule1.ZQryBuyMasterfaktur.Value + ' belum diposting !');
    Exit;
  end;     }
  if (DataModule1.ZQryBuyMaster.IsEmpty)or(DataModule1.ZQryBuyMasterfaktur.IsNull) then
  begin
   ErrorDialog('Tidak ada Faktur !');
   exit;
  end;

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\fakturpembelian.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := DataModule1.ZQryBuyMasterfaktur.Value;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tanggal'));
  FrxMemo.Memo.Text := FormatDatetime('dd/mm/yyyy',DataModule1.ZQryBuyMastertanggal.Value);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('supplier'));
  FrxMemo.Memo.Text := DataModule1.ZQryBuyMastersupplier.Value;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('noinvoice'));
  FrxMemo.Memo.Text := DataModule1.ZQryBuyMasternoinvoice.Value;

  vlok := trim(getdata('lokasi','gudang where kodegudang='+Quotedstr('UT')));
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('lokasi'));
  FrxMemo.Memo.Text := vlok;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Footercaption'));
  FrxMemo.Memo.Text := 'Printed By ' + Username + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',now);

  ClearTabel('formbuy where ipv='+ Quotedstr(ipcomp) );

  DataModule1.ZConnection1.ExecuteDirect('insert into formbuy '+
    ' (ipv,faktur,kode,nama,barcode,kategori,merk,seri,tipe,harga,harganondiskon,quantity,satuan,subtotal)' +
    ' select '+Quotedstr(ipcomp)+',faktur,kode,nama,barcode,kategori,merk,seri,tipe,hargabeli,harganondiskon,quantity,satuan,subtotal from buydetail' +
    ' where faktur = "' + DataModule1.ZQryBuyMasterfaktur.Value + '" order by kode');

  DataModule1.ZQryFormBuy.Close;
  DataModule1.ZQryFormBuy.SQL.Text := 'select * from formbuy where ipv='+ Quotedstr(ipcomp) + ' order by kode ';
  RefreshTabel(DataModule1.ZQryFormBuy);

  DataModule1.frxReport1.ShowReport();

end;

procedure TFrmbuymaster.SellBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '') then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'faktur';
  1 : SearchCategories := 'kasir';
  2 : SearchCategories := 'supplier';
  3 : SearchCategories := 'noinvoice';
  end;

  with DataModule1.ZQryBuyMaster do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from buymaster ');
    SQL.Add('where ' + SearchCategories + ' like ''' + SellTxtSearch.Text + '%' + ''' and isposted <> -1 ');
      SQL.Add('and tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
      SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + '''');
    Open;
    Last;
  end;

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal) from buymaster ');

    if (SellTxtSearchby.ItemIndex<2)or(SellTxtSearchby.ItemIndex=5) then
    begin
     SQL.Add('where ' + SearchCategories );
     SQL.Add('and isposted <> -1 ');
    end
    else SQL.Add('where isposted <> -1 ');

    SQL.Add('and tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''' ');
    Open;
    SellTxtTotalJual.Value := Fields[0].AsFloat;
    Close;
  end;


  SellBtnPrintList.Enabled := true;
end;

procedure TFrmbuymaster.SellBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryBuyMaster do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from buymaster ');
    SQL.Add('where (tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''') ');
    SQL.Add('and (isposted <> -1)');
    Open;
    Last;
  end;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal) from buymaster');
      SQL.Add('where (tanggal between ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchFirst.Date) + '''');
      SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',SellTxtSearchLast.Date) + ''') ');
      SQL.Add('and (isposted <> -1) ');
    Open;
    SellTxtTotalJual.Value := Fields[0].AsFloat;
    Close;
  end;


  SellBtnPrintList.Enabled := true;
end;

procedure TFrmbuymaster.PenjualanDBDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if DataModule1.ZQryBuyMasterisposted.Value <> 0 then
    PenjualanDB.Canvas.Brush.Color := $00A8FFA8
  else
    PenjualanDB.Canvas.Brush.Color := clWindow;
  PenjualanDB.DefaultDrawColumnCell(Rect, DataCol, Column, State);


end;

procedure TFrmbuymaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// if ShowDetail=false then

 DataModule1.ZQryBuyMaster.Close;

end;

procedure TFrmbuymaster.PrintListPembelian;
var
  FrxMemo: TfrxMemoView;
  ketstr, SearchCategories, strfilter : string;
begin
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'a.faktur';
  1 : SearchCategories := 'a.kasir';
  2 : SearchCategories := 'b.supplier';
  3 : SearchCategories := 'b.noinvoice';
  end;

 strfilter := '';
 if SellTxtSearch.Text<>'' then strfilter := 'and ('+SearchCategories + ' like ' + Quotedstr(SellTxtSearch.Text + '%') + ') ';

 case RGGroup.ItemIndex of
 0 :
 begin
 DataModule1.ZQryBuyingrep.Close;
 DataModule1.ZQryBuyingrep.SQL.Text := 'select b.tanggal,b.faktur,b.noinvoice,b.supplier,sum(d.quantity) quantity,b.grandtotal from buydetail d ' +
                                       'left join buymaster b on d.idbeli=b.idbeli ' +
                                       'where (b.isposted = 1) and (b.tanggal between ' + QuotedStr(getMySQLDateStr(SellTxtSearchFirst.Date)) + ' and ' + QuotedStr(getMySQLDateStr(SellTxtSearchLast.Date)) + ') '+ strfilter +
                                       'group by b.tanggal,b.faktur,b.noinvoice,b.supplier,b.grandtotal '+
                                       'order by b.tanggal,b.faktur';

 DataModule1.ZQryBuyingrep.open;

 DataModule1.frxReport1.LoadFromFile(vpath+'Report\Buying.fr3');
 end;
 1 :
 begin
 DataModule1.ZQryBuyingrep2.Close;
 DataModule1.ZQryBuyingrep2.SQL.Text := 'select b.tanggal,b.faktur,b.noinvoice,b.supplier,sum(d.quantity) quantity,b.grandtotal totalbeli,sum(d.quantity*d.harganondiskon*(1-(d.diskon*0.01)))*if(b.ppn>0,1.1,1) totaljual,b.tgljatuhtempo,b.pembayaran from buydetail d ' +
                                        'left join buymaster b on d.idbeli=b.idbeli ' +
                                        'where (b.isposted = 1) and (b.tanggal between ' + QuotedStr(getMySQLDateStr(SellTxtSearchFirst.Date)) + ' and ' + QuotedStr(getMySQLDateStr(SellTxtSearchLast.Date)) + ') '+ strfilter +
                                        'group by b.tanggal,b.faktur,b.noinvoice,b.supplier,b.grandtotal,b.tgljatuhtempo,b.pembayaran ' +
                                        'order by b.pembayaran,b.tanggal,b.faktur; ';

 DataModule1.ZQryBuyingrep2.open;

 DataModule1.frxReport1.LoadFromFile(vpath+'Report\Buying2.fr3');
 end;
 end;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  ketstr := '';
  if (SellTxtSearch.Text<>'')and(SellTxtSearchby.ItemIndex>=0) then ketstr := ' (' + uppercase(SellTxtSearchby.Text) + ' : ' + SellTxtSearch.Text + '...)';

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  FrxMemo.Memo.Text := 'LAPORAN PEMBELIAN'+ketstr;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tanggal ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchLast.Date);

  DataModule1.frxReport1.ShowReport();

  DataModule1.ZQrybuyingrep.Close;
  DataModule1.ZQryBuyingrep2.Close;
end;

procedure TFrmbuymaster.SellBtnPrintListClick(Sender: TObject);
begin
  if DataModule1.ZQryBuyMaster.IsEmpty then Exit;
  PrintListPembelian;
end;

procedure TFrmbuymaster.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmbuymaster.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQryBuyMasterIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF frmBuy=nil then
 application.CreateForm(TfrmBuy,frmBuy);
 frmBuy.Align:=alclient;
 frmBuy.Parent:=self.parent;

 frmBuy.BorderStyle:=bsnone;
 frmBuy.SellLblCaption.Caption := 'Edit Pembelian';
 Frmbuy.FormShowFirst;
 frmBuy.Show;

end;

procedure TFrmbuymaster.btn_delallClick(Sender: TObject);
begin
 if DataModule1.ZQryBuyMaster.IsEmpty then Exit;

 if QuestionDialog('Hapus semua yang tampil?') and
 DataModule1.ZConnection1.ExecuteDirect('delete from buymaster '+
 DataModule1.ZQryBuyMaster.SQL.Strings[1] + ' ' +
 DataModule1.ZQryBuyMaster.SQL.Strings[2] + ' ' +
 DataModule1.ZQryBuyMaster.SQL.Strings[3]) then
 begin
  DataModule1.ZQryBuyMaster.Close;
  DataModule1.ZQryBuyMaster.Open;

  infodialog('Berhasil hapus data.');
 end
 else errordialog('Gagal hapus data.');
end;

end.
