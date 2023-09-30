unit frmSearchCust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, RzEdit, Grids, DBGrids, RzDBGrid, StdCtrls,
  Mask, AdvSmoothButton, RzCmboBx, RzLabel, RzStatus, ExtCtrls, RzPanel, Db;

type
  TfrmSrcCust = class(TForm)
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
    RzPanel7: TRzPanel;
    SearchBtnAdd: TAdvSmoothButton;
    RzLabel12: TRzLabel;
    SearchBtnClose: TAdvSmoothButton;
    RzLabel14: TRzLabel;
    procedure SearchBtnSearchClick(Sender: TObject);
    procedure SearchBtnClearClick(Sender: TObject);
    procedure SearchBtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SearchDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchDBGridDblClick(Sender: TObject);
    procedure SearchTxtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchTxtSearchByChange(Sender: TObject);
    procedure SearchTxtSearchChange(Sender: TObject);
    procedure SearchBtnAddClick(Sender: TObject);
  private
    SearchCategories: string;
    { Private declarations }
  public
    formSender : TForm;
    { Public declarations }
  end;

var
  frmSrcCust: TfrmSrcCust;
  tampsearchtxt: string;

implementation

uses SparePartFunction, frmsellingorder, frmselling, frmReturJual, Data;

{$R *.dfm}


procedure TfrmSrcCust.FormShow(Sender: TObject);
begin
  tampsearchtxt := '';
  SearchTxtSearch.SetFocus;

  SearchBtnClearClick(Self);
end;

procedure TfrmSrcCust.SearchBtnSearchClick(Sender: TObject);
begin
  if Trim(SearchTxtSearch.Text) = '' then Exit;
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchCust do
  begin
    Close;
      SQL.Strings[0] := 'select c.IDcustomer,c.kode,c.nama,c.alamat,c.kota,c.tgllahir,c.kodesales,s.nama namasales from customer c left join sales s on c.kodesales=s.kode where c.tglnoneffective is null and c.' + SearchCategories + ' like ' + QuotedStr(SearchTxtSearch.Text + '%');
      SQL.Strings[1] := 'order by c.' + SearchCategories;
    Open;
  end;
end;

procedure TfrmSrcCust.SearchBtnClearClick(Sender: TObject);
begin
  SearchTxtSearch.Text:='';
  SearchTxtSearchByChange(Self);
  with DataModule1.ZQrySearchCust do
  begin
    Close;
      SQL.Strings[0] := 'select c.IDcustomer,c.kode,c.nama,c.alamat,c.kota,c.tgllahir,c.kodesales,s.nama namasales from customer c left join sales s on c.kodesales=s.kode where c.tglnoneffective is null ';
      SQL.Strings[1] := 'order by c.' + SearchCategories;
    Open;
  end;
end;

procedure TfrmSrcCust.SearchBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSrcCust.SearchDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    SearchBtnAddClick(Self);
  if (Key = VK_ESCAPE) then
    SearchBtnCloseClick(Self);
end;

procedure TfrmSrcCust.SearchDBGridDblClick(Sender: TObject);
begin
  SearchBtnAddClick(Self);
end;

procedure TfrmSrcCust.SearchTxtSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then SearchBtnAddClick(Self);
  if (Key = VK_ESCAPE) then SearchBtnCloseClick(Self);

  if (Key = VK_UP) and (DataModule1.ZQrySearchCust.Bof = False) then
    DataModule1.ZQrySearchCust.Prior
  else
  if (Key = VK_DOWN) and (DataModule1.ZQrySearchCust.Eof = False) then
    DataModule1.ZQrySearchCust.Next
  else
  if (Key = VK_PRIOR) and (DataModule1.ZQrySearchCust.Bof = False) then
    DataModule1.ZQrySearchCust.MoveBy(-12)
  else
  if (Key = VK_NEXT) and (DataModule1.ZQrySearchCust.Eof = False) then
    DataModule1.ZQrySearchCust.MoveBy(12)
  else
    Exit;
end;

procedure TfrmSrcCust.SearchTxtSearchByChange(Sender: TObject);
begin
  case SearchTxtSearchBy.ItemIndex of
  0 : SearchCategories := 'kode';
  1 : SearchCategories := 'nama';
  2 : SearchCategories := 'alamat';
  3 : SearchCategories := 'kota';
  end;
end;

procedure TfrmSrcCust.SearchTxtSearchChange(Sender: TObject);
begin
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

procedure TfrmSrcCust.SearchBtnAddClick(Sender: TObject);
begin
 if formSender = frmRtrJual then
 begin
  frmRtrJual.vkodecust := '';
  frmRtrJual.RtrJualTxtcustomer.Text := '';
  frmRtrJual.sellTxtalamat.Clear;
 end;

 if formSender = frmSell then
 begin
  frmsell.vidcust := -1;
  frmsell.vkodecust := '';
  frmsell.valamat := '';
  frmsell.vkota   := '';
  frmsell.SellTxtCustomer.Text := '';
  frmsell.sellTxtalamat.Clear;
  frmsell.vkodesales := '';
  frmsell.SellTxtSales.Text := '';
 end;

 if formSender = frmSellOrder then
 begin
  frmsellorder.vidcust := -1;
  frmsellorder.vkodecust := '';
  frmsellorder.valamat := '';
  frmsellorder.vkota   := '';
  frmsellorder.SellTxtCustomer.Text := '';
  frmsellorder.sellTxtalamat.Clear;
  frmsellorder.vkodesales := '';
  frmsellorder.SellTxtSales.Text := '';
 end;

 if  Datamodule1.ZQrySearchCust.IsEmpty then exit;

 if formSender = frmSellOrder then
 begin
  frmsellorder.vidcust := Datamodule1.ZQrySearchCustIDcustomer.Value;
  frmsellorder.vkodecust := Datamodule1.ZQrySearchCustkode.Value;
  frmsellorder.SellTxtCustomer.Text := Datamodule1.ZQrySearchCustnama.Value;

  frmsellorder.valamat := Datamodule1.ZQrySearchCustalamat.Value;
  frmsellorder.vkota   := Datamodule1.ZQrySearchCustkota.Value;

  frmsellorder.sellTxtalamat.Clear;
  frmsellorder.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustalamat.AsString);
  frmsellorder.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustkota.AsString);

  frmsellorder.vkodesales := Datamodule1.ZQrySearchCustkodesales.Value;
  frmsellorder.SellTxtsales.Text := Datamodule1.ZQrySearchCustnamasales.Value;


//  if formatdatetime('ddmm',Tglskrg)=formatdatetime('ddmm',Datamodule1.ZQrySearchCustTgllahir.Value) then infodialog(Datamodule1.ZQrySearchCustnama.Value+' Hari ini Ulang Tahun!');

  SearchBtnCloseClick(Self);
 end;

 if formSender = frmSell then
 begin
  frmsell.vidcust := Datamodule1.ZQrySearchCustIDcustomer.Value;
  frmsell.vkodecust := Datamodule1.ZQrySearchCustkode.Value;
  frmsell.SellTxtCustomer.Text := Datamodule1.ZQrySearchCustnama.Value;

  frmsell.valamat := Datamodule1.ZQrySearchCustalamat.Value;
  frmsell.vkota   := Datamodule1.ZQrySearchCustkota.Value;

  frmsell.sellTxtalamat.Clear;
  frmsell.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustalamat.AsString);
  frmsell.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustkota.AsString);

  frmsell.vkodesales := Datamodule1.ZQrySearchCustkodesales.Value;
  frmsell.SellTxtsales.Text := Datamodule1.ZQrySearchCustnamasales.Value;


//  if formatdatetime('ddmm',Tglskrg)=formatdatetime('ddmm',Datamodule1.ZQrySearchCustTgllahir.Value) then infodialog(Datamodule1.ZQrySearchCustnama.Value+' Hari ini Ulang Tahun!');

  SearchBtnCloseClick(Self);
 end;

 if formSender = frmRtrJual then
 begin
  frmRtrJual.vkodecust := Datamodule1.ZQrySearchCustkode.Value;
  frmRtrJual.RtrJualTxtcustomer.Text := Datamodule1.ZQrySearchCustnama.Value;

  frmRtrJual.RtrJualTxtFaktur.Text := frmRtrJual.getNoRetur;

  frmRtrJual.sellTxtalamat.Clear;
  frmRtrJual.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustalamat.AsString);
  frmRtrJual.sellTxtalamat.Lines.Add(Datamodule1.ZQrySearchCustkota.AsString);

//  if formatdatetime('ddmm',Tglskrg)=formatdatetime('ddmm',Datamodule1.ZQrySearchCustTgllahir.Value) then infodialog(Datamodule1.ZQrySearchCustnama.Value+' Hari ini Ulang Tahun!');

  SearchBtnCloseClick(Self);
 end;

end;

end.
