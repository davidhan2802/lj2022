unit customermaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, Grids, DBGrids, PDJDBGridex, StdCtrls, RzCmboBx, Mask,
  RzEdit, RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, jpeg,
  frxpngimage;

type
  TFrmcustomermaster = class(TForm)
    PanelCustomer: TRzPanel;
    RzPanel9: TRzPanel;
    RzLabel21: TRzLabel;
    RzPanel10: TRzPanel;
    RzLabel31: TRzLabel;
    RzLabel32: TRzLabel;
    RzLabel33: TRzLabel;
    CustBtnAdd: TAdvSmoothButton;
    CustBtnEdit: TAdvSmoothButton;
    CustBtnDel: TAdvSmoothButton;
    RzGroupBox3: TRzGroupBox;
    RzLabel35: TRzLabel;
    RzLabel36: TRzLabel;
    RzLabel37: TRzLabel;
    RzLabel38: TRzLabel;
    CustBtnSearch: TAdvSmoothButton;
    CustTxtSearch: TRzEdit;
    CustTxtSearchby: TRzComboBox;
    CustBtnClear: TAdvSmoothButton;
    CustDBGrid: TPDJDBGridEx;
    CustFilter: TRzRadioGroup;
    pnl_cetak: TRzPanel;
    CustBtnPrint: TAdvSmoothButton;
    RzLabel34: TRzLabel;
    procedure CustBtnSearchClick(Sender: TObject);
    procedure CustBtnClearClick(Sender: TObject);
    procedure CustBtnPrintClick(Sender: TObject);
    procedure CustDBGridTitleClick(Column: TColumn);
    procedure CustBtnAddClick(Sender: TObject);
    procedure CustBtnEditClick(Sender: TObject);
    procedure CustBtnDelClick(Sender: TObject);
    procedure CustFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure PrintListCustomer;
    procedure DeleteData(Data: string);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmcustomermaster: TFrmcustomermaster;
  ShowDetail : boolean;

implementation

uses SparePartFunction, Data, frmCustomer;

{$R *.dfm}

procedure TFrmcustomermaster.FormShowFirst;
begin
  ShowDetail := false;

  CustBtnEdit.Enabled := isedit;
  CustBtnDel.Enabled  := isdel;

  pnl_cetak.Visible := true;//isprintcustomer;

  CustBtnClearClick(Self);
end;

procedure TFrmcustomermaster.CustBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if Trim(CustTxtSearch.Text) = '' then Exit;

  case CustTxtSearchby.ItemIndex of
  0 : SearchCategories := 'kode';
  1 : SearchCategories := 'nama';
  2 : SearchCategories := 'Alamat';
  3 : SearchCategories := 'Kota';
  end;

  with DataModule1.ZQryCustomer do
  begin
    Close;
    SQL.Strings[1] := 'where ' + SearchCategories + ' like ' + QuotedStr(CustTxtSearch.Text + '%') ;
  end;
  CustFilterClick(Self);
end;

procedure TFrmcustomermaster.CustBtnClearClick(Sender: TObject);
begin

  with DataModule1.ZQryCustomer do
  begin
    Close;
    SQL.Strings[1] := '';
//    Open;
  end;
  CustFilterClick(Self);
  CustTxtSearch.Text := '';

end;

procedure TFrmcustomermaster.PrintListCustomer;
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\customer.fr3');
//  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
//  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',Now) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmcustomermaster.CustBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryCustomer.IsEmpty then Exit;
  PrintListCustomer;

end;

procedure TFrmcustomermaster.CustDBGridTitleClick(Column: TColumn);
var
  i: integer;
  s: string;
  sorted: string;
begin
  for i := 1 to CustDBGrid.Columns.Count - 1 do
  begin
    if (CustDBGrid.PDJDBGridExColumn[i].FieldName = Column.FieldName) then
    begin
      if CustDBGrid.PDJDBGridExColumn[i].SortArrow = saDown then
      begin
        CustDBGrid.PDJDBGridExColumn[i].SortArrow := saUp;
        s := 'order by ' + CustDBGrid.PDJDBGridExColumn[i].FieldName;
        sorted := '';
      end
      else
      begin
        CustDBGrid.PDJDBGridExColumn[i].SortArrow := saDown;
        s := 'order by ' + CustDBGrid.PDJDBGridExColumn[i].FieldName + ' desc';
        sorted := 'desc';
      end;
      with DataModule1.ZQryCustomer do
      begin
        Close;
        SQL.Strings[3] := s;
        Open;
      end;
      ConfigINI.Strings[17] := 'sort-by=' + CustDBGrid.PDJDBGridExColumn[i].FieldName;
      ConfigINI.Strings[18] := 'sort=' + sorted;
      ConfigINI.SaveToFile(ExtractFilePath(Application.ExeName) + 'config.ini');
    end
    else
      CustDBGrid.PDJDBGridExColumn[i].SortArrow := saNone;
  end;
end;

procedure TFrmcustomermaster.CustBtnAddClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF frmCust=nil then
 application.CreateForm(TfrmCust,frmCust);
 frmCust.Align:=alclient;
 frmCust.Parent:=self.parent;
 frmCust.BorderStyle:=bsnone;
 frmCust.CustLblCaption.Caption := 'Tambah Customer';
 frmCust.FormShowFirst;
 frmCust.Show;

end;

procedure TFrmcustomermaster.CustBtnEditClick(Sender: TObject);
begin
 if DataModule1.ZQryCustomer.IsEmpty then Exit;

 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF frmCust=nil then
 application.CreateForm(TfrmCust,frmCust);
 frmCust.Align:=alclient;
 frmCust.Parent:=self.parent;
 frmCust.BorderStyle:=bsnone;
 frmCust.CustLblCaption.Caption := 'Edit Customer';
 frmCust.FormShowFirst;
 frmCust.Show;

end;

procedure TFrmcustomermaster.DeleteData(Data: String);
var
  Nama: string;
  PosRecord: integer;
begin
  Nama := Data;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from customer');
    SQL.Add('where kode = ' + QuotedStr(Nama));
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQryCustomer.RecNo;
  DataModule1.ZQryCustomer.Close;
  DataModule1.ZQryCustomer.Open;
  DataModule1.ZQryCustomer.RecNo := PosRecord;

  LogInfo(UserName,'Menghapus Customer ' + Nama);

  InfoDialog('Customer ' + Nama + ' berhasil dihapus !');
end;

procedure TFrmcustomermaster.CustBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQryCustomer.IsEmpty then Exit;
  ///Cek Tabel Pembelian
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select kodecustomer from sellmaster');
    SQL.Add('where kodecustomer = ' + QuotedStr(DataModule1.ZQryCustomerkode.Value) + ' ');
    SQL.Add('or customer = ' + QuotedStr(DataModule1.ZQryCustomernama.Value) );
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Data Customer tidak bisa dihapus ' + #13+#10 + 'karena masih ada transaksi penjualan');
      Exit;
    end;
  end;
  if QuestionDialog('Hapus customer ' + DataModule1.ZQryCustomernama.Value + ' ?') = True then
  begin
    DeleteData(DataModule1.ZQryCustomerkode.Value);
  end;

end;

procedure TFrmcustomermaster.CustFilterClick(Sender: TObject);
var
  s, con: string;
begin
  case CustFilter.ItemIndex of
  0 : s := 'tglnoneffective is null';
  1 : s := 'tglnoneffective is not null';
  end;
  with DataModule1.ZQryCustomer do
  begin
    Close;
    if SQL.Strings[1] = '' then
      con := 'where '
    else
      con := 'and ';
    SQL.Strings[2] := con + s;
    Open;
  end;

end;

procedure TFrmcustomermaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ShowDetail=false then DataModule1.ZQryCustomer.Close;

end;

end.
