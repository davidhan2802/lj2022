unit merkmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, Grids, DBGrids, PDJDBGridex, StdCtrls, RzCmboBx, Mask,
  RzEdit, RzPanel, AdvSmoothButton, RzLabel, ExtCtrls;

type
  TFrmmerkmaster = class(TForm)
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
  Frmmerkmaster: TFrmmerkmaster;
  ShowDetail : boolean;

implementation

uses merk, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmmerkmaster.FormShowFirst;
begin
 ShowDetail := false;

 SalesBtnEdit.Enabled := isedit;
 SalesBtnDel.Enabled  := isdel;

 SalesBtnClearClick(Self);
end;

procedure TFrmmerkmaster.salesDBGridTitleClick(Column: TColumn);
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
      with DataModule1.ZQrymerk do
      begin
        Close;
        SQL.Strings[3] := s;
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

procedure TFrmmerkmaster.SalesBtnAddClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmmerk=nil then
 application.CreateForm(TFrmmerk,Frmmerk);
 Frmmerk.Align:=alclient;
 Frmmerk.Parent:=self.parent;
 Frmmerk.BorderStyle:=bsnone;
 frmmerk.LblCaption.Caption := 'Tambah Merk';
 Frmmerk.FormShowFirst;
 Frmmerk.Show;

end;

procedure TFrmmerkmaster.SalesBtnEditClick(Sender: TObject);
begin
  if DataModule1.ZQrymerk.IsEmpty then Exit;

 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmmerk=nil then
 application.CreateForm(TFrmmerk,Frmmerk);
 Frmmerk.Align:=alclient;
 Frmmerk.Parent:=self.parent;
 Frmmerk.BorderStyle:=bsnone;
 frmmerk.LblCaption.Caption := 'Edit Merk';
 Frmmerk.FormShowFirst;
 Frmmerk.Show;

end;

procedure TFrmmerkmaster.DeleteData(Data: string);
var
  Nama: string;
  PosRecord: integer;
begin
  Nama := Data;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from merk');
    SQL.Add('where merk = ' + QuotedStr(Nama) );
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQrymerk.RecNo;
  DataModule1.ZQrymerk.Close;
  DataModule1.ZQrymerk.Open;
  DataModule1.ZQrymerk.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus merk ' + Nama);
  InfoDialog('merk ' + Nama + ' berhasil dihapus !');
end;

procedure TFrmmerkmaster.SalesBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQrymerk.IsEmpty then Exit;

  if QuestionDialog('Hapus merk ' + DataModule1.ZQrymerkmerk.Value + ' ?') = True then
  begin
    DeleteData(DataModule1.ZQrymerkmerk.Text);
  end;

end;

procedure TFrmmerkmaster.SalesBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if Trim(SalesTxtSearch.Text) = '' then Exit;
  case SalesTxtSearchby.ItemIndex of
  0 : SearchCategories := 'merk';
  1 : SearchCategories := 'kategori';
  end;

  with DataModule1.ZQrymerk do
  begin
    Close;
    SQL.Strings[1] :=  'where ' + SearchCategories + ' like ''' + '%' + SalesTxtSearch.Text + '%' + '''';
    SQL.Strings[5] :=  'order by ' + SearchCategories;
    open;
  end;


end;

procedure TFrmmerkmaster.SalesBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQrymerk do
  begin
    Close;
    SQL.Strings[1] := '';
    open;
  end;

  SalesTxtSearch.Text := '';

end;

procedure TFrmmerkmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then DataModule1.ZQrymerk.Close;

end;

end.
