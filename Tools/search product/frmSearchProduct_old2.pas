unit frmSearchProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, RzEdit, Grids, DBGrids, RzDBGrid, StdCtrls,
  Mask, AdvSmoothButton, RzCmboBx, RzLabel, RzStatus, ExtCtrls, RzPanel, Db;

type
  TfrmSrcProd = class(TForm)
    PanelProd: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    SearchDBGrid: TRzDBGrid;
    RzGroupBox4: TRzGroupBox;
    RzLabel44: TRzLabel;
    RzLabel45: TRzLabel;
    RzLabel46: TRzLabel;
    RzLabel47: TRzLabel;
    SearchBtnSearch: TAdvSmoothButton;
    SearchTxtSearch: TRzEdit;
    SearchTxtSearchBy: TRzComboBox;
    SearchBtnClear: TAdvSmoothButton;
    pnlfakturjual: TRzPanel;
    RzLabel1: TRzLabel;
    cbx_fakturjual: TRzComboBox;
    RzPanel7: TRzPanel;
    SearchBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SearchBtnClose: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    ccx_isreorder: TRzCheckBox;
    procedure SearchBtnSearchClick(Sender: TObject);
    procedure SearchBtnClearClick(Sender: TObject);
    procedure SearchBtnAddClick(Sender: TObject);
    procedure SearchBtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SearchDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchDBGridDblClick(Sender: TObject);
    procedure SearchTxtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchTxtSearchByChange(Sender: TObject);
    procedure SearchTxtSearchChange(Sender: TObject);
    procedure ccx_isreorderClick(Sender: TObject);
  private
    SearchCategories: string;
    { Private declarations }
  public
    formSender : TForm;
    KodeGdg    : string;
    { Public declarations }
  end;

var
  frmSrcProd: TfrmSrcProd;
  tampsearchtxt: string;

implementation

uses Data, SparePartFunction, frmSelling, frmbuying, frmAdjust, pindahgudang, promodiskon, terimagudang, po, ubahharga;

{$R *.dfm}


procedure TfrmSrcProd.FormShow(Sender: TObject);
begin
  ipcomp := getComputerIP;

  tampsearchtxt := '';

//  KodeGdg := kodegudang;

  ccx_isreorder.Checked :=false;
  ccx_isreorder.Visible := formSender=frmpo;

{  if formSender=frmRtrJual then
  begin
   pnlfakturjual.Visible:=true;    }
//   FillComboBox('faktur','sparepart.sellmaster where kodecustomer = '+QuotedStr(frmRtrJual.cbx_kodecust.text)+' and isposted = 1 ',cbx_fakturjual,false,'',True);

{   cbx_fakturjual.Text:='';
   if cbx_fakturjual.Items.Count>0 then cbx_fakturjual.ItemIndex := 0
   else cbx_fakturjual.ItemIndex := -1;

   SearchDBGrid.Columns[0].Visible:=true;

   cbx_fakturjual.SetFocus;
  end
  else
  begin }
   SearchDBGrid.Columns[0].Visible:=false;

   cbx_fakturjual.Items.Clear;
   pnlfakturjual.Visible:=false;
   SearchTxtSearch.SetFocus;
//  end;

  SearchBtnClearClick(Self);
end;

procedure TfrmSrcProd.SearchBtnSearchClick(Sender: TObject);
var vstrpriv : string;
begin
  if Trim(SearchTxtSearch.Text) = '' then Exit;
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchProduct do
  begin
    Close;
//    if formSender=frmRtrJual then
//    begin
//      SQL.Strings[0] := 'select cast(a.quantity as decimal) qty,a.kode,a.nama,a.merk,a.seri,a.satuan,cast("" as char(50)) supplier,a.kategori,a.hargabeli,a.hargajual'+',cast("" as char(50)) keterangan,cast(null as date) tglnoneffective,a.diskon,a.diskonrp,a.kodepromo,a.faktur from sparepart.selldetail a ';
{      SQL.Strings[0] := 'select a.quantity qty,a.kode,a.nama,a.merk,a.seri,a.satuan,a.kategori,a.hargajual'+',cast("" as char(50)) keterangan,cast(null as date) tglnoneffective,a.diskon,a.diskonrp,a.faktur,a.komisi_ms,a.komisi_ex from sparepart.selldetail a ';
      if cbx_fakturjual.ItemIndex > 0 then
       SQL.Strings[1] := 'where a.' + SearchCategories + ' like ' + QuotedStr(SearchTxtSearch.Text + '%') + ' and a.faktur = '+ QuotedStr(cbx_fakturjual.Text) +' '
      else
      begin
       SQL.Strings[1] := 'left join sparepart.sellmaster s on a.faktur = s.faktur where s.kodecustomer = '+ QuotedStr(frmRtrJual.cbx_kodecust.text) +' and s.isposted = 1 and a.' + SearchCategories + ' like ' + QuotedStr(SearchTxtSearch.Text + '%') + ' ';
      end;  }
//    end
//    else
//    begin
//      SQL.Strings[0] := 'select a.qty,b.*,cast("" as char(20)) faktur from sparepart.v_stock a left join sparepart.product b on a.kodebrg = b.kode';
//      SQL.Strings[1] := 'where a.kodegudang = '+ QuotedStr(KodeGdg) +' and b.' + SearchCategories + ' like ' + QuotedStr(SearchTxtSearch.Text + '%') + ' '; //and a.qty <> 0';
       SQL.Strings[0] := 'select p.*,cast("" as char(20)) faktur,p.'+kodegudang+' qty,p.'+kodegudang+'T qtytoko,p.'+kodegudang+'R qtybad from sparepart.product p ';
       SQL.Strings[1] := 'where (p.tglnoneffective is null) and (' + SearchCategories + ' like ' + QuotedStr(SearchTxtSearch.Text + '%') + ') ';//and (p.qty > 0) ' //and a.qty <> 0 ';
      if formSender = frmSell then  SQL.Strings[2] := 'and (p.'+kodegudang+'T > 0) ' else SQL.Strings[2] := ''; //and a.qty <> 0 ';

       //    end;
    SQL.Strings[3] := 'order by ' + SearchCategories;
    Open;
  end;

  if formSender = frmbuy then
  begin
   (SearchDBGrid.columns[4] as TColumn).fieldname := 'hargabeli';
   (SearchDBGrid.columns[4] as TColumn).Title.Caption := 'Harga Beli';
  end
  else
  begin
   (SearchDBGrid.columns[4] as TColumn).fieldname := 'hargajual';
   (SearchDBGrid.columns[4] as TColumn).Title.Caption := 'Harga Jual';
  end;

end;

procedure TfrmSrcProd.SearchBtnClearClick(Sender: TObject);
var vstrpriv : string;
begin
  SearchTxtSearch.Text:='';
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchProduct do
  begin
    Close;
 //   if formSender=frmRtrJual then
//    begin
//      SQL.Strings[0] := 'select cast(a.quantity as decimal) qty,a.kode,a.nama,a.merk,a.seri,a.satuan,cast("" as char(50)) supplier,a.kategori,a.hargabeli,a.hargajual'+',cast("" as char(50)) keterangan,cast(null as date) tglnoneffective,a.diskon,a.diskonrp,a.kodepromo,a.faktur from sparepart.selldetail a ';
{      SQL.Strings[0] := 'select a.quantity qty,a.kode,a.nama,a.merk,a.seri,a.satuan,a.kategori,a.hargajual'+',cast("" as char(50)) keterangan,cast(null as date) tglnoneffective,a.diskon,a.diskonrp,a.faktur,a.komisi_ms,a.komisi_ex from sparepart.selldetail a ';
      if cbx_fakturjual.ItemIndex > 0 then
       SQL.Strings[1] := 'where a.faktur = '+ QuotedStr(cbx_fakturjual.Text) +' '
      else
      begin
       SQL.Strings[1] := 'left join sparepart.sellmaster s on a.faktur = s.faktur where s.kodecustomer = '+QuotedStr(frmRtrJual.cbx_kodecust.text)+' and s.isposted = 1 ';
      end;      }
//    end
//    else
//    begin
//      SQL.Strings[0] := 'select a.qty,b.*,cast("" as char(20)) faktur from sparepart.v_stock a left join sparepart.product b on a.kodebrg = b.kode ';
//      SQL.Strings[1] := 'where a.kodegudang = '+ QuotedStr(KodeGdg) +' ';//and a.qty <> 0 ';
       SQL.Strings[0] := 'select p.*,cast("" as char(20)) faktur,p.'+kodegudang+' qty,p.'+kodegudang+'T qtytoko,p.'+kodegudang+'R qtybad from sparepart.product p ';
       SQL.Strings[1] := '';
      if formSender = frmSell then SQL.Strings[2] := 'where p.'+kodegudang+'T > 0 ' else SQL.Strings[2] := ''; //and a.qty <> 0 ';
//    end;
    SQL.Strings[3] := 'order by ' + SearchCategories;
    Open;
  end;

  if formSender = frmbuy then
  begin
   (SearchDBGrid.columns[4] as TColumn).fieldname := 'hargabeli';
   (SearchDBGrid.columns[4] as TColumn).Title.Caption := 'Harga Beli';
  end
  else
  begin
   (SearchDBGrid.columns[4] as TColumn).fieldname := 'hargajual';
   (SearchDBGrid.columns[4] as TColumn).Title.Caption := 'Harga Jual';
  end;

end;

procedure TfrmSrcProd.SearchBtnAddClick(Sender: TObject);
var qtytamp: integer;
begin
  if formSender = frmSell then
  begin
   { with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select kode from sparepart.formsell where ipv='+Quotedstr(ipcomp));
      SQL.Add('where kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) );
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;   }


    if DataModule1.ZQryFormSell.State <> dsEdit then DataModule1.ZQryFormSell.Append;
    DataModule1.ZQryFormSellfaktur.Value := frmSell.SellTxtNo.Text;
    DataModule1.ZQryFormSellkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryFormSellnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryFormSellharga.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryFormSellhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryFormSellmerk.Value := DataModule1.ZQrySearchProductmerk.Value;
    DataModule1.ZQryFormSellseri.Value := DataModule1.ZQrySearchProductseri.Value;
    DataModule1.ZQryFormSellsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryFormSellkategori.Value := '';//DataModule1.ZQrySearchProductkategori.Value;

    DataModule1.ZQryFormSelldiskon.Value := DataModule1.ZQrySearchProductdiskon.Value;
    DataModule1.ZQryFormSelldiskon_rp.Value := DataModule1.ZQrySearchProductdiskonrp.Value;
    DataModule1.ZQryFormSellipv.Value    := ipcomp;

    DataModule1.ZQryFormSell.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmSell.PenjualanDBGrid.SetFocus;
    frmSell.PenjualanDBGrid.SelectedIndex := 5;
  end
{  else
  if formSender = frmRtrJual then
  begin
    if (cbx_fakturjual.ItemIndex=-1) then
    begin
     ErrorDialog('Isi/Pilih dahulu No. Faktur Jual!');
     exit;
    end
    else if (DataModule1.ZQrySearchProduct.IsEmpty) then
    begin
     ErrorDialog('Tidak ada Barang yang dapat di-Retur!');
     exit;
    end;

    with DataModule1.ZQrySearch do
    begin     }
   {   Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.formretur where ipv='+Quotedstr(ipcomp));
      SQL.Add('where kode = ''' + DataModule1.ZQrySearchProductkode.Value + '''');
      Open;
      if not IsEmpty then Exit;            }

{      qtytamp:=0;
      Close;
      SQL.Clear;
      SQL.Add('select sparepart.getQtysisaReturJual('+ QuotedStr(DataModule1.ZQrySearchProductfaktur.Value) +','+ QuotedStr(DataModule1.ZQrySearchProductkode.Value) +') ');
      Open;
      if (IsEmpty) or (Fields[0].IsNull) or (Fields[0].AsInteger<=0) then
      begin
       Close;
       errordialog('Sudah tidak ada lagi Sisa Barang yang dapat di-Retur dari Faktur ini!');
       Exit;
      end;
      qtytamp := Fields[0].AsInteger;
      Close;
    end;

    if DataModule1.ZQryFormretur.State <> dsEdit then DataModule1.ZQryFormretur.Append;
    DataModule1.ZQryFormreturfaktur.Value := frmRtrJual.RtrJualTxtFaktur.Text;
    DataModule1.ZQryFormreturkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryFormreturnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryFormreturharga.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryFormreturkategori.Value := DataModule1.ZQrySearchProductkategori.Value;
    DataModule1.ZQryFormreturmerk.Value := DataModule1.ZQrySearchProductmerk.Value;
    DataModule1.ZQryFormreturseri.Value := DataModule1.ZQrySearchProductseri.Value;
    DataModule1.ZQryFormretursatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryFormreturquantity.Value := qtytamp;
    DataModule1.ZQryFormreturdiskon.Value := DataModule1.ZQrySearchProductdiskon.Value;
    DataModule1.ZQryFormreturdiskon_rp.Value := DataModule1.ZQrySearchProductdiskonrp.Value;
    DataModule1.ZQryFormreturfakturjual.Value := DataModule1.ZQrySearchProductfaktur.Value;
    DataModule1.ZQryFormreturkodegudang.Value := KodeGdg;
    DataModule1.ZQryFormretur.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmRtrJual.ReturJualDBGrid.SetFocus;
    frmRtrJual.ReturJualDBGrid.SelectedIndex := 6;
  end   }
  else
  if formSender = frmbuy then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select kode from sparepart.formbuy ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) );
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQryFormBuy.State <> dsEdit then DataModule1.ZQryFormBuy.Append;
    DataModule1.ZQryFormBuyfaktur.Value := frmBuy.SellTxtNo.Text;
    DataModule1.ZQryFormBuykode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryFormBuynama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryFormBuyharga.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryFormBuyharganondiskon.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryFormBuykategori.Value := '';  //DataModule1.ZQrySearchProductkategori.Value;
    DataModule1.ZQryFormbuymerk.Value := DataModule1.ZQrySearchProductmerk.Value;
    DataModule1.ZQryFormbuyseri.Value := DataModule1.ZQrySearchProductseri.Value;
    DataModule1.ZQryFormbuysatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryFormBuybarcode.Value := DataModule1.ZQrySearchProductbarcode.Value;
    DataModule1.ZQryFormbuyipv.Value    := ipcomp;

    DataModule1.ZQryFormBuy.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmbuy.BuyDBGrid.SetFocus;
    frmbuy.BuyDBGrid.SelectedIndex := 5;
  end
  else
  if formSender = frmAdj then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.formadjust ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;
    if DataModule1.ZQryFormAdjust.State <> dsEdit then DataModule1.ZQryFormAdjust.Append;
    DataModule1.ZQryFormAdjustfaktur.Value := frmAdj.AdjustTxtFaktur.Text;
    DataModule1.ZQryFormAdjustkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryFormAdjustnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryFormAdjustharga.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryFormAdjusthargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryFormAdjustkategori.Value := '';//DataModule1.ZQrySearchProductkategori.Value;
    DataModule1.ZQryFormAdjustmerk.Value := DataModule1.ZQrySearchProductmerk.Value;
    DataModule1.ZQryFormAdjustseri.Value := DataModule1.ZQrySearchProductseri.Value;
    DataModule1.ZQryFormAdjustsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryFormAdjustipv.Value    := ipcomp;

    case frmAdj.AdjustTxtGudang.ItemIndex of
      0 : DataModule1.ZQryFormAdjustquantity.Value := DataModule1.ZQrySearchProductqty.Value;
      1 : DataModule1.ZQryFormAdjustquantity.Value := DataModule1.ZQrySearchProductqtytoko.Value;
      2 : DataModule1.ZQryFormAdjustquantity.Value := DataModule1.ZQrySearchProductqtybad.Value;
    end;

    DataModule1.ZQryFormAdjust.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmAdj.AdjustDBGrid.SetFocus;
    frmAdj.AdjustDBGrid.SelectedIndex := 3;
  end
  else
  if formSender = frmpindahgudang then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.pindahgudangdetform ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQrypindahgudangdetform.State <> dsEdit then DataModule1.ZQrypindahgudangdetform.Append;
    DataModule1.ZQrypindahgudangdetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQrypindahgudangdetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQrypindahgudangdetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQrypindahgudangdetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQrypindahgudangdetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQrypindahgudangdetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQrypindahgudangdetformipv.Value    := ipcomp;

    DataModule1.ZQrypindahgudangdetform.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmpindahgudang.DBGriddet.SetFocus;
    frmpindahgudang.DBGriddet.SelectedIndex := 2;
  end
  else
  if formSender = frmpo then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.purchaseorderdetform ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQrypodetform.State <> dsEdit then DataModule1.ZQrypodetform.Append;
    DataModule1.ZQrypodetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQrypodetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQrypodetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQrypodetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQrypodetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQrypodetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQrypodetformipv.Value    := ipcomp;

    DataModule1.ZQrypodetform.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmpo.DBGriddet.SetFocus;
    frmpo.DBGriddet.SelectedIndex := 2;
  end
  else
  if formSender = frmterimagudang then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.terimagudangdetform ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQryterimagudangdetform.State <> dsEdit then DataModule1.ZQryterimagudangdetform.Append;
    DataModule1.ZQryterimagudangdetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQryterimagudangdetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryterimagudangdetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryterimagudangdetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryterimagudangdetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryterimagudangdetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryterimagudangdetformipv.Value    := ipcomp;

    DataModule1.ZQryterimagudangdetform.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmterimagudang.DBGriddet.SetFocus;
    frmterimagudang.DBGriddet.SelectedIndex := 2;
  end
  else
  if formSender = frmubahharga then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.ubahhargadetform ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQryubahhargadetform.State <> dsEdit then DataModule1.ZQryubahhargadetform.Append;
    DataModule1.ZQryubahhargadetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQryubahhargadetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQryubahhargadetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQryubahhargadetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQryubahhargadetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQryubahhargadetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQryubahhargadetformipv.Value    := ipcomp;

    DataModule1.ZQryubahhargadetform.CommitUpdates;
    SearchBtnCloseClick(Self);
    frmubahharga.DBGriddet.SetFocus;
    frmubahharga.DBGriddet.SelectedIndex := 4;
  end
  else
  if formSender = Frmpromodiskon then
  begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from sparepart.diskondetform ');
      SQL.Add('where ipv='+Quotedstr(ipcomp)+' and kode = ' + QuotedStr(DataModule1.ZQrySearchProductkode.Value) + ' ');
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Item sudah terdaftar !');
       Exit;
      end;
    end;

    if DataModule1.ZQrydiskondetform.State <> dsEdit then DataModule1.ZQrydiskondetform.Append;
    DataModule1.ZQrydiskondetformIDproduct.Value := DataModule1.ZQrySearchProductIDproduct.Value;
    DataModule1.ZQrydiskondetformkode.Value := DataModule1.ZQrySearchProductkode.Value;
    DataModule1.ZQrydiskondetformnama.Value := DataModule1.ZQrySearchProductnama.Value;
    DataModule1.ZQrydiskondetformsatuan.Value := DataModule1.ZQrySearchProductsatuan.Value;
    DataModule1.ZQrydiskondetformhargabeli.Value := DataModule1.ZQrySearchProducthargabeli.Value;
    DataModule1.ZQrydiskondetformhargajual.Value := DataModule1.ZQrySearchProducthargajual.Value;
    DataModule1.ZQrydiskondetformipv.Value    := ipcomp;

    DataModule1.ZQrydiskondetform.CommitUpdates;
    SearchBtnCloseClick(Self);
    Frmpromodiskon.DBGriddet.SetFocus;
    Frmpromodiskon.DBGriddet.SelectedIndex := 3;
  end

end;

procedure TfrmSrcProd.SearchBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSrcProd.SearchDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    SearchBtnAddClick(Self);
  if (Key = VK_ESCAPE) then
    SearchBtnCloseClick(Self);
end;

procedure TfrmSrcProd.SearchDBGridDblClick(Sender: TObject);
begin
  SearchBtnAddClick(Self);
end;

procedure TfrmSrcProd.SearchTxtSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{  if (Key = VK_RIGHT)and(tampsearchtxt <> SearchTxtSearch.Text) then
  begin
    tampsearchtxt := SearchTxtSearch.Text;
    if Trim(SearchTxtSearch.Text) <> '' then
    begin
      SearchBtnSearchClick(Self);
    end
    else
    begin
      SearchBtnClearClick(Self);
    end;
  end;         }
{  if (formSender = frmRtrJual)and(Key = VK_RETURN) then
  begin
    if Trim(SearchTxtSearch.Text) <> '' then
    begin
      SearchBtnSearchClick(Self);
    end
    else
    begin
      SearchBtnClearClick(Self);
    end;
  end
  else }
  if (Key = VK_RETURN) then SearchBtnAddClick(Self);
  if (Key = VK_ESCAPE) then SearchBtnCloseClick(Self);

  if (Key = VK_UP) and (DataModule1.ZQrySearchProduct.Bof = False) then
    DataModule1.ZQrySearchProduct.Prior
  else
  if (Key = VK_DOWN) and (DataModule1.ZQrySearchProduct.Eof = False) then
    DataModule1.ZQrySearchProduct.Next
  else
  if (Key = VK_PRIOR) and (DataModule1.ZQrySearchProduct.Bof = False) then
    DataModule1.ZQrySearchProduct.MoveBy(-12)
  else
  if (Key = VK_NEXT) and (DataModule1.ZQrySearchProduct.Eof = False) then
    DataModule1.ZQrySearchProduct.MoveBy(12)
  else
    Exit;
 { case SearchTxtSearchBy.ItemIndex of
  0: SearchTxtSearch.Text := DataModule1.ZQrySearchProductkode.Value;
  1: SearchTxtSearch.Text := DataModule1.ZQrySearchProductnama.Value;
  end;    }
end;

procedure TfrmSrcProd.SearchTxtSearchByChange(Sender: TObject);
begin
  case SearchTxtSearchBy.ItemIndex of
  0 : SearchCategories := 'p.kode';
  1 : SearchCategories := 'p.barcode';
  2 : SearchCategories := 'p.nama';
  end;
end;

procedure TfrmSrcProd.SearchTxtSearchChange(Sender: TObject);
var vcountstr : integer;
    vfilter : string;
begin
  vfilter := '';

  Datamodule1.ZQrySearchProduct.Filter := '';
  Datamodule1.ZQrySearchProduct.Filtered := false;

  if ccx_isreorder.Checked then vFilter := '(reorderqty>=qty) and ';


  if (tampsearchtxt <> SearchTxtSearch.Text) then
  begin
    tampsearchtxt := SearchTxtSearch.Text;

    SearchTxtSearch.Text := Trim(SearchTxtSearch.Text);

    vcountstr := SearchTxtSearch.GetTextLen;

    if Trim(SearchTxtSearch.Text) <> '' then
    begin
//      SearchBtnSearchClick(Self);
     case SearchTxtSearchBy.ItemIndex of
     0 : vFilter := vFilter + '(left(kode,'+inttostr(vcountstr)+')='+Quotedstr(trim(SearchTxtSearch.Text))+') and ';
     1 : vFilter := vFilter + '(left(barcode,'+inttostr(vcountstr)+')='+Quotedstr(trim(SearchTxtSearch.Text))+') and ';
     2 : vFilter := vFilter + '(left(nama,'+inttostr(vcountstr)+')='+Quotedstr(trim(SearchTxtSearch.Text))+') and ';
     end;
    end;
  end;

  if trim(vfilter)<>'' then
  begin
   vfilter := vfilter + '(1=1) ';
   Datamodule1.ZQrySearchProduct.Filter := vfilter;
   Datamodule1.ZQrySearchProduct.Filtered := true;
  end;

end;

procedure TfrmSrcProd.ccx_isreorderClick(Sender: TObject);
begin
{ DataModule1.ZQrySearchProduct.Filter := '';
 DataModule1.ZQrySearchProduct.Filtered := false;

 if ccx_isreorder.Checked then
 begin
  DataModule1.ZQrySearchProduct.Filter := 'reorderqty>=qty';
  DataModule1.ZQrySearchProduct.Filtered := true;
 end;  }
end;

end.
