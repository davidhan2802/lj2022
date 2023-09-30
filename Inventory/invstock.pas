unit invstock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, StdCtrls, Mask, RzEdit, RzPanel,
  AdvSmoothButton, RzCmboBx, RzLabel, ExtCtrls;

type
  TFrmInventory = class(TForm)
    PanelInventory: TRzPanel;
    RzPanel43: TRzPanel;
    RzLabel187: TRzLabel;
    InvCbxGudang: TRzComboBox;
    RzPanel44: TRzPanel;
    RzLabel73: TRzLabel;
    RzLabel188: TRzLabel;
    RzLabel189: TRzLabel;
    RzLabel191: TRzLabel;
    RzLabel260: TRzLabel;
    InvBtnRusak: TAdvSmoothButton;
    InvBtnAdjust: TAdvSmoothButton;
    InvBtnPrint: TAdvSmoothButton;
    InvBtnPrintStockPrice: TAdvSmoothButton;
    RzGroupBox13: TRzGroupBox;
    RzLabel192: TRzLabel;
    RzLabel193: TRzLabel;
    RzLabel194: TRzLabel;
    RzLabel195: TRzLabel;
    InvBtnSearch: TAdvSmoothButton;
    InvTxtSearch: TRzEdit;
    InvTxtSearchby: TRzComboBox;
    InvBtnClear: TAdvSmoothButton;
    InvDBGrid: TPDJDBGridEx;
    procedure InvDBGridTitleClick(Column: TColumn);
    procedure InvBtnRusakClick(Sender: TObject);
    procedure InvBtnAdjustClick(Sender: TObject);
    procedure InvBtnPrintClick(Sender: TObject);
    procedure InvBtnSearchClick(Sender: TObject);
    procedure InvBtnClearClick(Sender: TObject);
    procedure InvTxtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InvBtnPrintStockPriceClick(Sender: TObject);
    procedure InvCbxGudangChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmInventory: TFrmInventory;

implementation

{$R *.dfm}

procedure TFrmInventory.FormShowFirst;
begin
  SortArrowGrid(InvDBGrid,13);

  FillComboBox('namagudang','sparepart.gudang',invcbxgudang,false,'kodegudang',false);
  invcbxgudang.ItemIndex := invcbxgudang.Items.IndexOf('PUSAT');

  InvBtnClearClick(Self);
end;

procedure TFrmInventory.InvDBGridTitleClick(Column: TColumn);
var
  i: integer;
  s: string;
  sorted: string;
begin
  for i := 0 to InvDBGrid.Columns.Count - 1 do
  begin
    if (InvDBGrid.PDJDBGridExColumn[i].FieldName = Column.FieldName) then
    begin
      if InvDBGrid.PDJDBGridExColumn[i].FieldName = 'satuan' then Exit;

      if InvDBGrid.PDJDBGridExColumn[i].SortArrow = saDown then
      begin
        InvDBGrid.PDJDBGridExColumn[i].SortArrow := saUp;
        s := 'order by ' + InvDBGrid.PDJDBGridExColumn[i].FieldName;
        sorted := '';
      end
      else
      begin
        InvDBGrid.PDJDBGridExColumn[i].SortArrow := saDown;
        s := 'order by ' + InvDBGrid.PDJDBGridExColumn[i].FieldName + ' desc';
        sorted := 'desc';
      end;

      with DataModule1.ZQryInventory do
      begin
        Close;
        SQL.Strings[2] := s;
        Open;
      end;

      ConfigINI.Strings[13] := 'sort-by=' + InvDBGrid.PDJDBGridExColumn[i].FieldName;
      ConfigINI.Strings[14] := 'sort=' + sorted;
      ConfigINI.SaveToFile(ExtractFilePath(Application.ExeName) + 'config.ini');
    end
    else
      InvDBGrid.PDJDBGridExColumn[i].SortArrow := saNone;
  end;
end;

procedure TFrmInventory.InvBtnRusakClick(Sender: TObject);
begin
  if DataModule1.ZQryInventory.IsEmpty then Exit;
  with frmRsk do
  begin
    RskLblCaption.Caption := 'Produk Rusak';
    ShowModal;
  end;
  RefreshTabel(DataModule1.ZQryInventory);

end;

procedure TFrmInventory.InvBtnAdjustClick(Sender: TObject);
begin
  PanelAdjust.Visible := True;

  AdjustBtnClearClick(Self);
end;

procedure TFrmInventory.InvBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryInventory.IsEmpty then Exit;

  PrintStockbyQuantity;

end;

procedure TFrmInventory.InvBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if (Trim(InvTxtSearch.Text) = '') or (InvCbxGudang.ItemIndex=-1) then Exit;
  case InvTxtSearchby.ItemIndex of
  0 : SearchCategories := 'kodebrg';
  1 : SearchCategories := 'nama';
  2 : SearchCategories := 'merk';
  3 : SearchCategories := 'kategori';
  4 : SearchCategories := 'typetrans';
  end;

  with DataModule1.ZQryInventory do
  begin
    Close;
    SQL.Strings[1] :=  'where namagudang='+QuotedStr(InvCbxGudang.Text) + ' and ' + SearchCategories + ' like ''' + '%' + InvTxtSearch.Text + '%' + '''';
    Open;
  end;
end;

procedure TFrmInventory.InvBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryInventory do
  begin
    Close;
    SQL.Strings[1] := 'where namagudang='+QuotedStr(InvCbxGudang.Text);
    Open;
  end;
  InvTxtSearch.Text := '';

end;

procedure TFrmInventory.InvTxtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if InvTxtSearch.Text <> '' then
      InvBtnSearchClick(Self)
    else
      InvBtnClearClick(Self);
  end;

end;

procedure TFrmInventory.InvBtnPrintStockPriceClick(Sender: TObject);
begin
  if DataModule1.ZQryInventory.IsEmpty then Exit;

//  InvDBGrid.PDJDBGridExColumn[0].SortArrow := saUp;
//  InvDBGridTitleClick(InvDBGrid.PDJDBGridExColumn[0] as TColumn);

  PrintStockbyTotalPrice;

end;

procedure TFrmInventory.InvCbxGudangChange(Sender: TObject);
begin
    if InvTxtSearch.Text <> '' then
      InvBtnSearchClick(Self)
    else
      InvBtnClearClick(Self);

end;

end.
