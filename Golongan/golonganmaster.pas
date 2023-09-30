unit golonganmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, Grids, DBGrids, PDJDBGridex, StdCtrls, RzCmboBx, Mask,
  RzEdit, RzPanel, AdvSmoothButton, RzLabel, ExtCtrls;

type
  TFrmgolonganmaster = class(TForm)
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
  Frmgolonganmaster: TFrmgolonganmaster;
  ShowDetail : boolean;

implementation

uses Golongan, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmgolonganmaster.FormShowFirst;
begin
 ShowDetail := false;

 SalesBtnEdit.Enabled := isedit;
 SalesBtnDel.Enabled  := isdel;

 SalesBtnClearClick(Self);
end;

procedure TFrmgolonganmaster.salesDBGridTitleClick(Column: TColumn);
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
      with DataModule1.ZQryGolongan do
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

procedure TFrmgolonganmaster.SalesBtnAddClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmgolongan=nil then
 application.CreateForm(TFrmgolongan,Frmgolongan);
 Frmgolongan.Align:=alclient;
 Frmgolongan.Parent:=self.parent;
 Frmgolongan.BorderStyle:=bsnone;
 frmgolongan.LblCaption.Caption := 'Tambah Golongan';
 Frmgolongan.FormShowFirst;
 Frmgolongan.Show;

end;

procedure TFrmgolonganmaster.SalesBtnEditClick(Sender: TObject);
begin
  if DataModule1.ZQryGolongan.IsEmpty then Exit;

 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF Frmgolongan=nil then
 application.CreateForm(TFrmgolongan,Frmgolongan);
 Frmgolongan.Align:=alclient;
 Frmgolongan.Parent:=self.parent;
 Frmgolongan.BorderStyle:=bsnone;
 frmgolongan.LblCaption.Caption := 'Edit Golongan';
 Frmgolongan.FormShowFirst;
 Frmgolongan.Show;

end;

procedure TFrmgolonganmaster.DeleteData(Data: string);
var
  Nama: string;
  PosRecord: integer;
begin
  Nama := Data;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from Golongan');
    SQL.Add('where kode = ' + QuotedStr(Nama) );
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQryGolongan.RecNo;
  DataModule1.ZQryGolongan.Close;
  DataModule1.ZQryGolongan.Open;
  DataModule1.ZQryGolongan.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus Golongan ' + Nama);
  InfoDialog('Golongan ' + Nama + ' berhasil dihapus !');
end;

procedure TFrmgolonganmaster.SalesBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQryGolongan.IsEmpty then Exit;

  if QuestionDialog('Hapus Golongan ' + DataModule1.ZQryGolongannama.Value + ' ?') = True then
  begin
    DeleteData(DataModule1.ZQryGolongankode.Text);
  end;

end;

procedure TFrmgolonganmaster.SalesBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if Trim(SalesTxtSearch.Text) = '' then Exit;
  case SalesTxtSearchby.ItemIndex of
  0 : SearchCategories := 'kode';
  1 : SearchCategories := 'nama';
  end;

  with DataModule1.ZQryGolongan do
  begin
    Close;
    SQL.Strings[1] :=  'where ' + SearchCategories + ' like ''' + '%' + SalesTxtSearch.Text + '%' + '''';
    SQL.Strings[5] :=  'order by ' + SearchCategories;
    open;
  end;


end;

procedure TFrmgolonganmaster.SalesBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryGolongan do
  begin
    Close;
    SQL.Strings[1] := '';
    open;
  end;

  SalesTxtSearch.Text := '';

end;

procedure TFrmgolonganmaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then DataModule1.ZQryGolongan.Close;

end;

end.
