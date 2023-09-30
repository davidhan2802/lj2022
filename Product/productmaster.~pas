unit productmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, Grids, DBGrids, PDJDBGridex, ExtCtrls, StdCtrls,
  RzCmboBx, Mask, RzEdit, RzPanel, AdvSmoothButton, RzLabel, DateUtils, frxClass,
  RzButton, RzRadChk;

type
  TFrmproductmaster = class(TForm)
    panelproduct: TRzPanel;
    RzPanel2: TRzPanel;
    RzLabel11: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel13: TRzLabel;
    RzLabel14: TRzLabel;
    ProdBtnAdd: TAdvSmoothButton;
    ProdBtnEdit: TAdvSmoothButton;
    ProdBtnDel: TAdvSmoothButton;
    RzGroupBox1: TRzGroupBox;
    RzLabel16: TRzLabel;
    RzLabel17: TRzLabel;
    RzLabel18: TRzLabel;
    RzLabel19: TRzLabel;
    ProdBtnSearch: TAdvSmoothButton;
    ProdTxtSearch: TRzEdit;
    ProdTxtSearchby: TRzComboBox;
    ProdBtnClear: TAdvSmoothButton;
    ProductDBGrid: TPDJDBGridEx;
    ProdFilter: TRzRadioGroup;
    btn_printbarcode: TRzButton;
    pnl_cetak: TRzPanel;
    SellLblDateLast: TRzLabel;
    ProdStockCardLblPrint: TRzLabel;
    ProdTxtSearchFirst: TRzDateTimeEdit;
    ProdTxtSearchLast: TRzDateTimeEdit;
    ProdStockCardBtnPrint: TAdvSmoothButton;
    SellBtnPrintList: TAdvSmoothButton;
    RzLabel43: TRzLabel;
    RzLabel3: TRzLabel;
    lbl_totalrecords: TRzLabel;
    edtnum_totalinventory: TRzNumericEdit;
    procedure ProductDBGridTitleClick(Column: TColumn);
    procedure ProdBtnSearchClick(Sender: TObject);
    procedure ProdBtnClearClick(Sender: TObject);
    procedure ProdFilterClick(Sender: TObject);
    procedure ProdBtnAddClick(Sender: TObject);
    procedure ProdBtnEditClick(Sender: TObject);
    procedure ProdBtnDelClick(Sender: TObject);
    procedure ProductDBGridCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printbarcodeClick(Sender: TObject);
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure ProdStockCardBtnPrintClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintStockbyQuantity;
//    procedure PrintStockbyCategories;
    procedure PrintStockbyTotalPrice;
    procedure DeleteData(Data: string);
  public
    { Public declarations }
    ConfigINI: TStringList;
    procedure FormShowFirst;
  end;

var
  Frmproductmaster: TFrmproductmaster;
  ShowDetail : boolean;

implementation

uses frmProduct, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmproductmaster.FormShowFirst;
var vtglakhir : TDate;
begin
 ShowDetail := false;

 ipcomp := getComputerIP;

 ProdBtnDel.Enabled := isdel;
 ProdBtnEdit.Enabled := isedit;


 ProdFilterClick(Self);
end;

procedure TFrmproductmaster.ProductDBGridTitleClick(Column: TColumn);
var
  i: integer;
  s: string;
  sorted: string;
begin
  for i := 0 to ProductDBGrid.Columns.Count - 1 do
  begin
    if (ProductDBGrid.PDJDBGridExColumn[i].FieldName = Column.FieldName) then
    begin
      if ProductDBGrid.PDJDBGridExColumn[i].FieldName = 'satuan' then Exit;

      if ProductDBGrid.PDJDBGridExColumn[i].SortArrow = saDown then
      begin
        ProductDBGrid.PDJDBGridExColumn[i].SortArrow := saUp;
        s := 'order by ' + ProductDBGrid.PDJDBGridExColumn[i].FieldName;
        sorted := '';
      end
      else
      begin
        ProductDBGrid.PDJDBGridExColumn[i].SortArrow := saDown;
        s := 'order by ' + ProductDBGrid.PDJDBGridExColumn[i].FieldName + ' desc';
        sorted := 'desc';
      end;

      with DataModule1.ZQryProduct do
      begin
        Close;
        SQL.Strings[3] := s;
        Open;
      end;

      ConfigINI.Strings[5] := 'sort-by=' + ProductDBGrid.PDJDBGridExColumn[i].FieldName;
      ConfigINI.Strings[6] := 'sort=' + sorted;
      ConfigINI.SaveToFile(ExtractFilePath(Application.ExeName) + 'config.ini');
    end
    else
      ProductDBGrid.PDJDBGridExColumn[i].SortArrow := saNone;
  end;
end;

procedure TFrmproductmaster.ProdBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if Trim(ProdTxtSearch.Text) = '' then Exit;
  case ProdTxtSearchby.ItemIndex of
  0 : SearchCategories := 'kode';
  1 : SearchCategories := 'nama';
  2 : SearchCategories := 'Merk';
  3 : SearchCategories := 'Kategori';
  end;

  with DataModule1.ZQryProduct do
  begin
    Close;
    SQL.Strings[0] := 'select * from product ';
    SQL.Strings[1] :=  'where ' + SearchCategories + ' like ''' + ProdTxtSearch.Text + '%' + '''';
  end;
  ProdFilterClick(Self);
end;

procedure TFrmproductmaster.ProdBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryProduct do
  begin
    Close;
    SQL.Strings[0] := 'select * from product ';
    SQL.Strings[1] := '';
  end;
  ProdFilterClick(Self);
  ProdTxtSearch.Text := '';
end;

procedure TFrmproductmaster.ProdFilterClick(Sender: TObject);
var
  s, con: string;
begin
  case ProdFilter.ItemIndex of
  0 : s := 'tglnoneffective is null';
  1 : s := 'tglnoneffective is not null';
  end;
  with DataModule1.ZQryProduct do
  begin
    Close;

    SQL.Strings[0] := 'select * from product ';

    if SQL.Strings[1] = '' then
      con := 'where '
    else
      con := 'and ';
    SQL.Strings[2] := con + s;
    Open;
  end;

  ///Cari Total Nilai Jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(hargabeli*UT),count(kode) from product');
    SQL.Add('where '+ s);
    Open;
    edtnum_totalinventory.Value := Fields[0].AsFloat;
    lbl_totalrecords.Caption := formatfloat(',0;(,0)',Fields[1].Asfloat)+' Records';
    Close;
  end;

end;

procedure TFrmproductmaster.ProdBtnAddClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmprod=nil then
 application.CreateForm(TFrmprod,Frmprod);
 Frmprod.Align:=alclient;
 Frmprod.Parent:=self.parent;
 Frmprod.BorderStyle:=bsnone;
 frmProd.ProdLblCaption.Caption := 'Tambah Item';
 Frmprod.Tag := 0;
 Frmprod.FormShowFirst;
 Frmprod.Show;

end;

procedure TFrmproductmaster.ProdBtnEditClick(Sender: TObject);
begin
 if DataModule1.ZQryProduct.IsEmpty then Exit;

 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmprod=nil then
 application.CreateForm(TFrmprod,Frmprod);
 Frmprod.Align:=alclient;
 Frmprod.Parent:=self.parent;
 Frmprod.BorderStyle:=bsnone;
 frmProd.ProdLblCaption.Caption := 'Edit Item';
 Frmprod.Tag := 0;
 Frmprod.FormShowFirst;
 Frmprod.Show;

end;

procedure TFrmproductmaster.DeleteData(Data: string);
var
//  LoadPic: String;
  NamaProd: string;
  PosRecord: integer;
begin
  NamaProd := Data;

{  if isdataexist('select kodebrg from inventory where kodebrg = ' + QuotedStr(NamaProd)+' and typetrans<>"STOCK AWAL" limit 1') then
  begin
   errordialog('Tidak Dapat dihapus!! Pada Item/Service ini telah terjadi Transaksi!!');
   exit;
  end;       }

{  LoadPic := PicturePath + '\' + DataModule1.ZQryProductkode.Text + '.jpg';
  if FileExists(LoadPic) then
  begin
    ProdImage.Picture := nil;
    DeleteFile(LoadPic);
  end;     }
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('delete from inventory');
    SQL.Add('where kodebrg = ' + QuotedStr(NamaProd));
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('Delete from product');
    SQL.Add('where kode = ' + QuotedStr(NamaProd));
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQryProduct.RecNo;
  DataModule1.ZQryProduct.Close;
  DataModule1.ZQryProduct.Open;
  DataModule1.ZQryProduct.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus Item ' + NamaProd);
  InfoDialog('Item ' + NamaProd + ' berhasil dihapus !');
end;

procedure TFrmproductmaster.ProdBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQryProduct.IsEmpty then Exit;

  ///cek apakah ada pembelian atau penjualan
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from selldetail');
    SQL.Add('where kode = ' + QuotedStr(DataModule1.ZQryProductkode.Value));
    SQL.Add('and isposted = 1');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Item tidak dapat dihapus karena ada transaksi penjualan');
      Exit;
    end;

    Close;
    SQL.Clear;
    SQL.Add('select * from buydetail');
    SQL.Add('where kode = "' + DataModule1.ZQryProductkode.Value + '"');
    SQL.Add('and isposted = 1');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Item tidak dapat dihapus karena ada transaksi pembelian');
      Exit;
    end;
  end;
  if QuestionDialog('Hapus Item ' + DataModule1.ZQryProductnama.Value + ' ?') = True then
  begin
    DeleteData(DataModule1.ZQryProductkode.Text);
  end;

end;

procedure TFrmproductmaster.PrintStockbyQuantity;
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\Inventory.fr3');
//  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
//  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',Now) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmproductmaster.PrintStockbyTotalPrice;
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\Inventoryamount.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',Now) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

{procedure TFrmproductmaster.PrintStockbyCategories;
begin
end;
 }
procedure TFrmproductmaster.ProductDBGridCellClick(Column: TColumn);
{var
  LoadPic: string; }
begin
{  LoadPic := PicturePath + '\' + DataModule1.ZQryProductkode.Text + '.jpg';
  if FileExists(LoadPic) then
    ProdImage.Picture.LoadFromFile(LoadPic)
  else
    ProdImage.Picture := nil;   }
end;

procedure TFrmproductmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then DataModule1.ZQryProduct.Close;
end;

procedure TFrmproductmaster.btn_printbarcodeClick(Sender: TObject);
var FrxMemo: TfrxMemoView;
begin
 DataModule1.frxReport1.LoadFromFile(vpath+'Report\productbarcode.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('yyyy-MM-dd hh:nn:ss',Now) ;

  DataModule1.frxReport1.ShowReport();

end;

procedure TFrmproductmaster.SellBtnPrintListClick(Sender: TObject);
var FrxMemo: TfrxMemoView;
begin
 if DataModule1.ZQryProduct.IsEmpty then Exit;

 Datamodule1.frxReport1.LoadFromFile(vpath+'Report\productlist.fr3');

 FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('titlejual'));
 FrxMemo.Memo.Text := 'LIST PRODUCT (' + lokasigudang + ')';

 FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
 FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

 Datamodule1.frxReport1.ShowReport();
end;

procedure TFrmproductmaster.ProdStockCardBtnPrintClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
 if DataModule1.ZQryProduct.IsEmpty then Exit;
 DataModule1.ZConnection1.ExecuteDirect('set @saldo'+standpos+' := getsaldostock('+QuotedStr(DataModule1.ZQryProductkode.Value)+',"UT",'+QuotedStr(getMySQLDateStr(incday(ProdTxtSearchFirst.Date,-1)))+')+getsaldostock('+QuotedStr(DataModule1.ZQryProductkode.Value)+',"UTT",'+QuotedStr(getMySQLDateStr(incday(ProdTxtSearchFirst.Date,-1)))+')');

 DataModule1.ZQryStockCard.Close;
 DataModule1.ZQryStockCard.SQL.Text := '(select cast('+QuotedStr(getMySQLDateStr(ProdTxtSearchFirst.Date))+' as date) tgltrans, cast("00:00:00" as time) waktu, cast(@saldo'+standpos+' as signed) as masuk,0 keluar,cast(@saldo'+standpos+' as signed) as sisa, null faktur, "SALDO AWAL" as typetrans, null username, null keterangan, null kodegdg) union '+
                                       '(select tgltrans,waktu,cast(if(qty>0,qty,0) as signed) masuk,if(qty<0,qty,0) keluar,cast((@saldo'+standpos+':=@saldo'+standpos+'+qty) as signed) sisa,faktur,typetrans,username,keterangan,if(kodegudang="UT","Gudang","Toko") kodegdg from inventory where kodebrg='+QuotedStr(DataModule1.ZQryProductkode.Value)+' and left(kodegudang,2)="UT" and tgltrans between '+QuotedStr(getMySQLDateStr(ProdTxtSearchFirst.Date))+' and '+QuotedStr(getMySQLDateStr(ProdTxtSearchLast.Date))+') order by tgltrans,waktu ';
 DataModule1.ZQryStockCard.Open;

 DataModule1.frxReport1.LoadFromFile(vpath+'Report\stockcard.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('yyyy-MM-dd hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  FrxMemo.Memo.Text := 'KARTU STOCK '+DataModule1.ZQryProductnama.Value;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tanggal ' + FormatDateTime('dd/MM/yyyy',ProdTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',ProdTxtSearchLast.Date);
  DataModule1.frxReport1.ShowReport();

 DataModule1.ZQryStockCard.Close;
end;

end.
