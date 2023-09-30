unit frmhistorybuysell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzButton, RzRadChk, DB, ZAbstractRODataset, ZDataset, PDJDBGridex;

type
  TfrmHistoryBS = class(TForm)
    PanelProd: TRzPanel;
    HistBuyDBGrid: TPDJDBGridEx;
    ZQryhistorybuy: TZReadOnlyQuery;
    DSHistBuy: TDataSource;
    ZQryhistorybuyTanggal: TDateField;
    ZQryhistorybuyfaktur: TStringField;
    ZQryhistorybuyharganondiskon: TFloatField;
    ZQryhistorybuydiskon: TFloatField;
    ZQryhistorybuyhargabeli: TFloatField;
    ZQryhistorybuysupplier: TStringField;
    ZQryhistorysell: TZReadOnlyQuery;
    ZQryhistorysellTanggal: TDateField;
    ZQryhistorysellfaktur: TStringField;
    ZQryhistorysellquantity: TIntegerField;
    ZQryhistorysellhargajual: TFloatField;
    ZQryhistoryselldiskon: TFloatField;
    ZQryhistorysellnetto: TFloatField;
    ZQryhistorysellsales: TStringField;
    DSHistSell: TDataSource;
    HistSellDBGrid: TPDJDBGridEx;
    ZQryhistorysellhargabeli: TFloatField;
    ZQryhistorybuyquantity: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    transmode : byte;
    kodecust  : string;
    namacust  : string;
    kodebrg   : string;
    namabrg   : string;
  end;

var
  frmHistoryBS: TfrmHistoryBS;

implementation

uses Data;

{$R *.dfm}

procedure TfrmHistoryBS.FormShow(Sender: TObject);
begin
 if transmode=0 then
 begin
  HistBuyDBGrid.Visible := true;
  HistSellDBGrid.Visible := false;

  Self.caption := 'History Pembelian Barang ['+kodebrg+'] '+namabrg;

  ZQryhistorybuy.Close;
  ZQryhistorybuy.SQL.Text := 'select b.Tanggal,a.faktur,a.quantity,a.hargabeli harganondiskon,a.diskon,a.hargabeli-round(a.hargabeli*a.diskon*0.01) hargabeli,concat("[",b.kodesupplier,"] ",b.supplier) supplier '+
                             'from buydetail a inner join buymaster b on a.faktur = b.faktur '+
                             'where a.kode='+ QuotedStr(kodebrg) +' order by b.Tanggal desc, b.waktu desc limit 6 ';
  ZQryhistorybuy.Open;
 end
 else
 begin
  HistBuyDBGrid.Visible := false;
  HistSellDBGrid.Visible := true;

  Self.caption := 'History Penjualan Barang ['+kodebrg+'] '+namabrg + ' Customer ['+kodecust+'] '+namacust;

  ZQryhistorysell.Close;
  ZQryhistorysell.SQL.Text := 'select a.Tanggal,a.faktur,a.quantity,a.hargajual,a.diskon,a.netto,a.hargabeli,concat("[",a.kodesales,"] ",a.namasales) sales '+
                              'from historybuysell a '+
                              'where a.kodecust='+QuotedStr(kodecust)+' and a.kodebrg='+QuotedStr(kodebrg)+' '+
                              'order by a.Tanggal desc limit 6 ';
  ZQryhistorysell.Open;
 end;
end;

procedure TfrmHistoryBS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_RETURN then
 begin
  ZQryhistorybuy.Close;
  ZQryhistorysell.Close;

  Close;
 end;

end;

end.
