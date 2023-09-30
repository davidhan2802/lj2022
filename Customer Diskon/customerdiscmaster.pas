unit customerdiscmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, Grids, DBGrids, PDJDBGridex, StdCtrls, RzCmboBx, Mask,
  RzEdit, RzPanel, AdvSmoothButton, RzLabel, ExtCtrls;

type
  TFrmcustomerdiscmaster = class(TForm)
    PanelSales: TRzPanel;
    RzPanel58: TRzPanel;
    RzLabel243: TRzLabel;
    RzPanel60: TRzPanel;
    RzLabel246: TRzLabel;
    RzLabel247: TRzLabel;
    RzLabel248: TRzLabel;
    SalesBtnAdd: TAdvSmoothButton;
    SalesBtnEdit: TAdvSmoothButton;
    SalesBtnDel: TAdvSmoothButton;
    RzGroupBox18: TRzGroupBox;
    RzLabel250: TRzLabel;
    RzLabel251: TRzLabel;
    RzLabel252: TRzLabel;
    RzLabel253: TRzLabel;
    SalesBtnSearch: TAdvSmoothButton;
    SalesTxtSearch: TRzEdit;
    SalesTxtSearchby: TRzComboBox;
    SalesBtnClear: TAdvSmoothButton;
    salesDBGrid: TPDJDBGridEx;
    procedure salesDBGridTitleClick(Column: TColumn);
    procedure SalesBtnAddClick(Sender: TObject);
    procedure SalesBtnEditClick(Sender: TObject);
    procedure SalesBtnDelClick(Sender: TObject);
    procedure SalesBtnSearchClick(Sender: TObject);
    procedure SalesBtnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure DeleteData(Data: string);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmcustomerdiscmaster: TFrmcustomerdiscmaster;
  ShowDetail : boolean;

implementation

uses customerdisc, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmcustomerdiscmaster.FormShowFirst;
begin
 ShowDetail := false;

 SalesBtnEdit.Enabled := isedit;
 SalesBtnDel.Enabled  := isdel;

 SalesBtnClearClick(Self);
end;

procedure TFrmcustomerdiscmaster.salesDBGridTitleClick(Column: TColumn);
var
  i: integer;
  s: string;
  sorted: string;
begin
  for i := 0 to SalesDBGrid.Columns.Count - 1 do
  begin
    if (SalesDBGrid.PDJDBGridExColumn[i].FieldName = Column.FieldName) then
    begin
      if SalesDBGrid.PDJDBGridExColumn[i].SortArrow = saDown then
      begin
        SalesDBGrid.PDJDBGridExColumn[i].SortArrow := saUp;
        s := 'order by ' + SalesDBGrid.PDJDBGridExColumn[i].FieldName;
        sorted := '';
      end
      else
      begin
        SalesDBGrid.PDJDBGridExColumn[i].SortArrow := saDown;
        s := 'order by ' + SalesDBGrid.PDJDBGridExColumn[i].FieldName + ' desc';
        sorted := 'desc';
      end;
      with DataModule1.ZQryCustomerdisc do
      begin
        Close;
        SQL.Strings[4] := s;
        Open;
      end;
      ConfigINI.Strings[33] := 'sort-by=' + SalesDBGrid.PDJDBGridExColumn[i].FieldName;
      ConfigINI.Strings[34] := 'sort=' + sorted;
      ConfigINI.SaveToFile(ExtractFilePath(Application.ExeName) + 'config.ini');
    end
    else
      SalesDBGrid.PDJDBGridExColumn[i].SortArrow := saNone;
  end;
end;

procedure TFrmcustomerdiscmaster.SalesBtnAddClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmcustomerdisc=nil then
 application.CreateForm(TFrmcustomerdisc,Frmcustomerdisc);
 Frmcustomerdisc.Align:=alclient;
 Frmcustomerdisc.Parent:=self.parent;
 Frmcustomerdisc.BorderStyle:=bsnone;
 Frmcustomerdisc.LblCaption.Caption := 'Tambah Customer Diskon';
 Frmcustomerdisc.FormShowFirst;
 Frmcustomerdisc.Show;

end;

procedure TFrmcustomerdiscmaster.SalesBtnEditClick(Sender: TObject);
begin
  if DataModule1.ZQryCustomerdisc.IsEmpty then Exit;

 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmcustomerdisc=nil then
 application.CreateForm(TFrmcustomerdisc,Frmcustomerdisc);
 Frmcustomerdisc.Align:=alclient;
 Frmcustomerdisc.Parent:=self.parent;
 Frmcustomerdisc.BorderStyle:=bsnone;
 Frmcustomerdisc.LblCaption.Caption := 'Edit Customer Diskon';
 Frmcustomerdisc.FormShowFirst;
 Frmcustomerdisc.Show;

end;

procedure TFrmcustomerdiscmaster.DeleteData(Data: string);
var
  id: string;
  PosRecord: integer;
begin
  id := Data;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from customerdiskon');
    SQL.Add('where id = ' + QuotedStr(id) );
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQryCustomerdisc.RecNo;
  DataModule1.ZQryCustomerdisc.Close;
  DataModule1.ZQryCustomerdisc.Open;
  DataModule1.ZQryCustomerdisc.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus Customer Diskon ' + DataModule1.ZQryCustomerdisckode.Value + ' merk ' + DataModule1.ZQryCustomerdiscmerk.Value );
  InfoDialog('Customer Diskon ' + DataModule1.ZQryCustomerdisckode.Value + ' merk ' + DataModule1.ZQryCustomerdiscmerk.Value + ' berhasil dihapus !');
end;

procedure TFrmcustomerdiscmaster.SalesBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQryCustomerdisc.IsEmpty then Exit;

  if QuestionDialog('Hapus Customer Diskon ' + DataModule1.ZQryCustomerdisckode.Value + ' merk ' + DataModule1.ZQryCustomerdiscmerk.Value + ' ?') = True then
  begin
    DeleteData(DataModule1.ZQryCustomerdiscid.AsString);
  end;

end;

procedure TFrmcustomerdiscmaster.SalesBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if Trim(SalesTxtSearch.Text) = '' then Exit;
  case SalesTxtSearchby.ItemIndex of
  0 : SearchCategories := 'c.kode';
  1 : SearchCategories := 'c.nama';
  2 : SearchCategories := 'd.merk';
  end;

  with DataModule1.ZQryCustomerdisc do
  begin
    Close;
    SQL.Strings[1] :=  'where ' + SearchCategories + ' like ''' + '%' + SalesTxtSearch.Text + '%' + '''';
    SQL.Strings[4] :=  'order by ' + SearchCategories;
    open;
  end;


end;

procedure TFrmcustomerdiscmaster.SalesBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryCustomerdisc do
  begin
    Close;
    SQL.Strings[1] := '';
    open;
  end;

  SalesTxtSearch.Text := '';

end;

procedure TFrmcustomerdiscmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then DataModule1.ZQryCustomerdisc.Close;

end;

end.
