unit report;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, RzEdit, StdCtrls, Mask, RzCmboBx,
  AdvSmoothButton, RzLabel, ExtCtrls, RzPanel;

type
  TFrmReport = class(TForm)
    PanelLaporan: TRzPanel;
    RzPanel31: TRzPanel;
    RzLabel120: TRzLabel;
    RzPanel27: TRzPanel;
    RzLabel100: TRzLabel;
    RzLabel105: TRzLabel;
    RzLabel118: TRzLabel;
    RzLabel119: TRzLabel;
    RzLabel121: TRzLabel;
    RzLabel122: TRzLabel;
    RptSellBtnPrint: TAdvSmoothButton;
    RptSellTxtSearchBy: TRzComboBox;
    RptSellTxtStartDate: TRzDateTimeEdit;
    RptSellTxtFinishDate: TRzDateTimeEdit;
    RptSellTxtSearch: TRzEdit;
    RzPanel28: TRzPanel;
    RzLabel101: TRzLabel;
    RzLabel103: TRzLabel;
    RzLabel110: TRzLabel;
    RzLabel111: TRzLabel;
    RzLabel112: TRzLabel;
    RzLabel113: TRzLabel;
    RptStockBtnPrint: TAdvSmoothButton;
    RptStockTxtSearchBy: TRzComboBox;
    RptStockTxtStartDate: TRzDateTimeEdit;
    RptStockTxtFinishDate: TRzDateTimeEdit;
    RptStockTxtSearch: TRzEdit;
    procedure RptSellBtnPrintClick(Sender: TObject);
    procedure RptStockBtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmReport: TFrmReport;

implementation

{$R *.dfm}

procedure TFrmReport.FormShowFirst;
var
  Year, Month, Day : Word;
begin
  DecodeDate(TglSkrg,Year,Month,Day);

  RptBuyTxtStartDate.Date := EncodeDate(Year,Month,1);
  RptBuyTxtFinishDate.Date := TglSkrg;

  RptSellTxtStartDate.Date := EncodeDate(Year,Month,1);
  RptSellTxtFinishDate.Date := TglSkrg;

  RptStockTxtStartDate.Date := EncodeDate(Year,Month,1);
  RptStockTxtFinishDate.Date := TglSkrg;

  RptCashTxtStartDate.Date := EncodeDate(Year,Month,1);
  RptCashTxtFinishDate.Date := TglSkrg;

  FillComboBox('kode','sparepart.customer where tglnoneffective is null ',RptOmzCbxKodeCust,false,'kode',true);
  FillComboBox('nama','sparepart.customer where tglnoneffective is null ',RptOmzCbxNamaCust,false,'kode',true);
end;

procedure TFrmReport.RptSellBtnPrintClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
  Kategori: string;
begin
  if Trim(RptSellTxtSearch.Text) = '' then Exit;
  case RptSellTxtSearchBy.ItemIndex of
  0 : Kategori := 'b.customer';
  1 : Kategori := 'a.nama';
  end;
  with DataModule1.ZQryListSell do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.faktur, b.tanggal, a.nama, a.kategori, a.merk, a.quantity, a.hargajual, a.diskon, ((a.quantity * a.hargajual)-a.diskonrp) as subtotal, b.customer');
    SQL.Add('from sparepart.selldetail a left join sparepart.sellmaster b');
    SQL.Add('on a.faktur = b.faktur');
    SQL.Add('where b.tanggal >= ''' + FormatDateTime('yyyy-MM-dd',RptSellTxtStartDate.Date) + '''');
    SQL.Add('and b.tanggal <= ''' + FormatDateTime('yyyy-MM-dd',RptSellTxtFinishDate.Date) + '''');
    if Trim(RptSellTxtSearch.Text) <> '' then
       SQL.Add('and ' + kategori + ' like ''' + RptSellTxtSearch.Text + '%''');
    SQL.Add('and b.isposted = 1');
    SQL.Add('order by b.tanggal, ' + kategori);
    Open;
    if IsEmpty then
    begin
      ErrorDialog('Tidak ada Transaksi !');
      Exit;
    end;
  end;
  DataModule1.frxReport1.LoadFromFile('listselling.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMMM yyyy',RptSellTxtStartDate.Date) + ' s/d Tgl ' + FormatDateTime('dd MMMM yyyy',RptSellTxtFinishDate.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ListSell'));
  FrxMemo.Memo.Text := 'List Penjualan berdasarkan ' + RptSellTxtSearchBy.Value + ' ' + RptSellTxtSearch.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('yyyy-MM-dd,hh:mm:ss',Now) + ' oleh ' + frmUtama.UserName;
  DataModule1.frxReport1.ShowReport();

end;

procedure TFrmReport.RptStockBtnPrintClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
  with DataModule1.ZQryListStockin do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.nama, sum(a.quantity) qty, a.satuan, a.merk, a.kategori, a.hargajual ');
    SQL.Add('from sparepart.buydetail a left join sparepart.buymaster b on a.faktur = b.faktur ');
    SQL.Add('where b.tanggal >= ''' + FormatDateTime('yyyy-MM-dd',RptStockTxtStartDate.Date) + '''');
    SQL.Add('and b.tanggal <= ''' + FormatDateTime('yyyy-MM-dd',RptStockTxtFinishDate.Date) + '''');
    SQL.Add('and b.isposted = 1');
    SQL.Add('group by a.kode order by a.kode');
    Open;
    if IsEmpty then
    begin
      ErrorDialog('Tidak ada Transaksi !');
      Exit;
    end;
  end;
  DataModule1.frxReport1.LoadFromFile('liststockin.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ListBuy'));
  FrxMemo.Memo.Text := 'Barang Datang ' + FormatDateTime('dd/mm/yyyy',RptStockTxtStartDate.Date) + ' s/d ' + FormatDateTime('dd/mm/yyyy',RptStockTxtFinishDate.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-MM-yyyy,hh:mm:ss',Now) + ' oleh ' + frmUtama.UserName;
  DataModule1.frxReport1.ShowReport();

{smentara  if (RptStockTxtSearchBy.ItemIndex = 1) and (Trim(RptStockTxtSearch.Text) = '') then Exit;
  with DataModule1.ZQryListStock do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.kodebrg,b.nama, from sparepart.inventory a');

    SQL.Add('and b.isposted = 1');
    Open;
    if IsEmpty then
    begin
      ErrorDialog('Tidak ada Transaksi !');
      Exit;
    end;
  end;
  DataModule1.frxReport1.LoadFromFile('liststock.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMMM yyyy',RptSellTxtStartDate.Date) + ' s/d Tgl ' + FormatDateTime('dd MMMM yyyy',RptSellTxtFinishDate.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ListSell'));
  FrxMemo.Memo.Text := 'List Penjualan berdasarkan ' + RptSellTxtSearchBy.Value + ' ' + RptSellTxtSearch.Text;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('yyyy-MM-dd,hh:mm:ss',Now) + ' oleh ' + frmUtama.UserName;
  DataModule1.frxReport1.ShowReport(); }

end;

end.
