unit frmSearchProductRetur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, RzEdit, Grids, DBGrids, RzDBGrid, StdCtrls,
  Mask, AdvSmoothButton, RzCmboBx, RzLabel, RzStatus, ExtCtrls, RzPanel, Db;

type
  TfrmSrcProdRtr = class(TForm)
    PanelProd: TRzPanel;
    RzPanel2: TRzPanel;
    SellLblCaption: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    RzLabel44: TRzLabel;
    RzLabel45: TRzLabel;
    RzLabel46: TRzLabel;
    RzLabel47: TRzLabel;
    SearchBtnSearch: TAdvSmoothButton;
    SearchTxtSearch: TRzEdit;
    SearchTxtSearchBy: TRzComboBox;
    SearchBtnClear: TAdvSmoothButton;
    RzPanel7: TRzPanel;
    SearchBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SearchBtnClose: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    SearchDBGrid: TRzDBGrid;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    cb_gudang: TRzComboBox;
    RtrPanelCredit: TRzPanel;
    RzLabel8: TRzLabel;
    RzLabel7: TRzLabel;
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
  private
    SearchCategories: string;
    { Private declarations }
  public
    formSender : TForm;
    KodeGdg, vKodeCust, vKodeSupp : string;
    { Public declarations }
  end;

var
  frmSrcProdRtr: TfrmSrcProdRtr;
  tampsearchtxt: string;

implementation

uses Data, SparePartFunction, frmReturJual, frmReturBeli;

{$R *.dfm}


procedure TfrmSrcProdRtr.FormShow(Sender: TObject);
begin
  ipcomp := getComputerIP;

  tampsearchtxt := '';

  cb_gudang.ItemIndex := cb_gudang.IndexOf(KodeGdg);

  if formSender=frmRtrJual then SearchDBGrid.Columns[11].Title.Caption := 'Faktur Jual'
  else if formSender=frmRtrBeli then SearchDBGrid.Columns[11].Title.Caption := 'Faktur Beli';

  SearchTxtSearchBy.ItemIndex := 0;
  SearchTxtSearchByChange(Sender);

  SearchTxtSearch.SetFocus;

  SearchBtnClearClick(Self);
end;

procedure TfrmSrcProdRtr.SearchBtnSearchClick(Sender: TObject);
var vstrpriv : string;
begin
  if Trim(SearchTxtSearch.Text) = '' then Exit;
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchProductRetur do
  begin
    Close;
    if formSender=frmRtrJual then
    begin
      SQL.text := 'select d.kode,d.nama,getQtysisaReturJual(d.faktur,d.kode) qty,d.satuan,d.hargajual harga,d.hargajual,d.kategori,d.merk,d.tipe,d.seri,d.faktur fakturjual,d.diskon,d.diskon2,d.diskon_rp,d.hargabeli from selldetail d '+
                  'left join sellmaster s on d.faktur=s.faktur left join customer c on s.kodecustomer=c.kode ' +
                  'where c.kode = ' + quotedstr(vKodeCust) + ' and ' + SearchCategories + ' like ' + QuotedStr(Trim(SearchTxtSearch.Text)+'%') + ' having qty<>0 order by ' + SearchCategories;
    end
    else if formSender=frmRtrBeli then
    begin
      SQL.text := 'select d.kode,d.nama,getQtysisaReturBeli(d.faktur,d.kode) qty,d.satuan,d.hargabeli harga,d.harganondiskon hargajual,d.kategori,d.merk,d.tipe,d.seri,d.faktur fakturjual,d.diskon,d.diskon2,(d.diskon2-d.diskon2) diskon_rp,d.hargabeli from buydetail d '+
                  'left join buymaster s on d.faktur=s.faktur left join supplier c on s.kodesupplier=c.kode ' +
                  'where c.kode = ' + quotedstr(vKodesupp) + ' and ' + SearchCategories + ' like ' + QuotedStr(Trim(SearchTxtSearch.Text)+'%') + ' having qty<>0 order by ' + SearchCategories;

    end;
    Open;
  end;

end;

procedure TfrmSrcProdRtr.SearchBtnClearClick(Sender: TObject);
var vstrpriv : string;
begin
  SearchTxtSearch.Text:='';
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchProductRetur do
  begin
    Close;
    if formSender=frmRtrJual then
    begin
      SQL.text := 'select d.kode,d.nama,getQtysisaReturJual(d.faktur,d.kode) qty,d.satuan,d.hargajual harga,d.hargajual,d.kategori,d.merk,d.tipe,d.seri,d.faktur fakturjual,d.diskon,d.diskon2,d.diskon_rp,d.hargabeli from selldetail d '+
                  'left join sellmaster s on d.faktur=s.faktur left join customer c on s.kodecustomer=c.kode ' +
                  'where c.kode = ' + quotedstr(vKodeCust) + ' having qty<>0 order by ' + SearchCategories;
    end
    else if formSender=frmRtrBeli then
    begin
      SQL.text := 'select d.kode,d.nama,getQtysisaReturBeli(d.faktur,d.kode) qty,d.satuan,d.hargabeli harga,d.harganondiskon hargajual,d.kategori,d.merk,d.tipe,d.seri,d.faktur fakturjual,d.diskon,d.diskon2,(d.diskon2-d.diskon2) diskon_rp,d.hargabeli from buydetail d '+
                  'left join buymaster s on d.faktur=s.faktur left join supplier c on s.kodesupplier=c.kode ' +
                  'where c.kode = ' + quotedstr(vKodesupp) + ' having qty<>0 order by ' + SearchCategories;

    end;
    Open;
  end;

end;

procedure TfrmSrcProdRtr.SearchBtnAddClick(Sender: TObject);
var qtytamp: integer;
    vhrgpromodiskon,vqty : double;
begin
  if cb_gudang.ItemIndex=0 then KodeGdg := 'UT' else KodeGdg := 'RS';

  if (formSender = frmRtrJual) or (formSender = frmRtrBeli) then
  begin
    if (DataModule1.ZQrySearchProductRetur.IsEmpty) then
    begin
     ErrorDialog('Tidak ada Barang yang dapat di-Retur!');
     exit;
    end;

    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from formretur');
      SQL.Add('where kode = ' + QuotedStr(DataModule1.ZQrySearchProductreturkode.Value) + ' and kodegudang=' + Quotedstr(KodeGdg) + ' and fakturjual=' + Quotedstr(DataModule1.ZQrySearchProductreturfakturjual.Value) + ' and ipv=' + Quotedstr(ipcomp) );
      Open;
      if (not IsEmpty) then
      begin
       ErrorDialog('Barang dengan Faktur dan Tujuan Gudang tersebut sudah ter-input pada Form Retur!');
       Exit;
      end;
    end;

 //   if DataModule1.ZQryFormretur.State <> dsEdit then
    DataModule1.ZQryFormretur.Append;

    if (formSender = frmRtrJual) then
     DataModule1.ZQryFormreturfaktur.Value := frmRtrJual.RtrJualTxtFaktur.Text
    else DataModule1.ZQryFormreturfaktur.Value := frmRtrBeli.RtrBeliTxtFaktur.Text;
    DataModule1.ZQryFormreturkode.Value := DataModule1.ZQrySearchProductReturkode.Value;
    DataModule1.ZQryFormreturnama.Value := DataModule1.ZQrySearchProductReturnama.Value;
    DataModule1.ZQryFormreturharga.Value := DataModule1.ZQrySearchProductReturharga.Value;
    DataModule1.ZQryFormreturkategori.Value := DataModule1.ZQrySearchProductReturkategori.Value;
    DataModule1.ZQryFormreturmerk.Value := DataModule1.ZQrySearchProductReturmerk.Value;
    DataModule1.ZQryFormreturseri.Value := DataModule1.ZQrySearchProductReturseri.Value;
    DataModule1.ZQryFormreturtipe.Value := DataModule1.ZQrySearchProductReturtipe.Value;
    DataModule1.ZQryFormretursatuan.Value := DataModule1.ZQrySearchProductRetursatuan.Value;
    DataModule1.ZQryFormreturquantity.Value := DataModule1.ZQrySearchProductReturqty.Value;
    DataModule1.ZQryFormreturdiskon.Value := DataModule1.ZQrySearchProductReturdiskon.Value;
    DataModule1.ZQryFormreturdiskon2.Value := DataModule1.ZQrySearchProductReturdiskon2.Value;
    DataModule1.ZQryFormreturdiskon_rp.Value := DataModule1.ZQrySearchProductReturdiskon_rp.Value;
    DataModule1.ZQryFormreturfakturjual.Value := DataModule1.ZQrySearchProductReturfakturjual.Value;
    DataModule1.ZQryFormreturkodegudang.Value := KodeGdg;
    DataModule1.ZQryFormreturipv.Value        := ipcomp;

    DataModule1.ZQryFormretur.CommitUpdates;
    SearchBtnCloseClick(Self);
    if (formSender = frmRtrJual) then
    begin
     frmRtrJual.ReturJualDBGrid.SetFocus;
     frmRtrJual.ReturJualDBGrid.SelectedIndex := 6;
    end
    else if (formSender = frmRtrBeli) then
    begin
     frmRtrBeli.ReturBeliDBGrid.SetFocus;
     frmRtrBeli.ReturBeliDBGrid.SelectedIndex := 6;
    end
  end;
{  else
  if formSender = frmRtrBeli then
  begin
  end;   }
end;

procedure TfrmSrcProdRtr.SearchBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSrcProdRtr.SearchDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    SearchBtnAddClick(Self);
  if (Key = VK_ESCAPE) then
    SearchBtnCloseClick(Self);
end;

procedure TfrmSrcProdRtr.SearchDBGridDblClick(Sender: TObject);
begin
  SearchBtnAddClick(Self);
end;

procedure TfrmSrcProdRtr.SearchTxtSearchKeyDown(Sender: TObject;
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

  if (Key = VK_UP) and (DataModule1.ZQrySearchProductRetur.Bof = False) then
    DataModule1.ZQrySearchProductRetur.Prior
  else
  if (Key = VK_DOWN) and (DataModule1.ZQrySearchProductRetur.Eof = False) then
    DataModule1.ZQrySearchProductRetur.Next
  else
  if (Key = VK_PRIOR) and (DataModule1.ZQrySearchProductRetur.Bof = False) then
    DataModule1.ZQrySearchProductRetur.MoveBy(-12)
  else
  if (Key = VK_NEXT) and (DataModule1.ZQrySearchProductRetur.Eof = False) then
    DataModule1.ZQrySearchProductRetur.MoveBy(12)
  else
    Exit;
end;

procedure TfrmSrcProdRtr.SearchTxtSearchByChange(Sender: TObject);
begin
  case SearchTxtSearchBy.ItemIndex of
  0 : SearchCategories := 'd.kode';
  1 : SearchCategories := 'd.nama';
  2 : SearchCategories := 'd.merk';
  3 : SearchCategories := 'd.tipe';
  4 : SearchCategories := 'd.divisi';
  5 : SearchCategories := 'd.faktur';
  end;
end;

procedure TfrmSrcProdRtr.SearchTxtSearchChange(Sender: TObject);
begin
//  if (formSender = frmRtrJual) then exit;

  if (tampsearchtxt <> SearchTxtSearch.Text) then
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
  end;

end;

end.
