unit polist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass;

type
  TFrmpolist = class(TForm)
    PanelPenjualan: TRzPanel;
    RzPanel11: TRzPanel;
    RzLabel39: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    RzLabel44: TRzLabel;
    RzLabel45: TRzLabel;
    RzLabel46: TRzLabel;
    RzLabel47: TRzLabel;
    RzLabel60: TRzLabel;
    SellLblDateLast: TRzLabel;
    SellBtnSearch: TAdvSmoothButton;
    SellTxtSearch: TRzEdit;
    SellTxtSearchby: TRzComboBox;
    SellBtnClear: TAdvSmoothButton;
    SellTxtSearchFirst: TRzDateTimeEdit;
    SellTxtSearchLast: TRzDateTimeEdit;
    pnl_cetak_list: TRzPanel;
    RzLabel43: TRzLabel;
    SellBtnPrintList: TAdvSmoothButton;
    pnl_del: TRzPanel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel42: TRzLabel;
    RzPanel1: TRzPanel;
    DBMaster: TPDJDBGridEx;
    DBGdet: TPDJDBGridEx;
    BtnEdit: TAdvSmoothButton;
    lbledit: TRzLabel;
    procedure SellBtnDelClick(Sender: TObject);
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure SellBtnSearchClick(Sender: TObject);
    procedure SellBtnClearClick(Sender: TObject);
    procedure DBMasterDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SellTxtSearchbyChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListpo;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmpolist: TFrmpolist;
  SearchCategories: string;

implementation

uses SparePartFunction, data, po;

{$R *.dfm}

procedure TFrmpolist.FormShowFirst;
begin
 pnl_del.Visible := isdel;

 SellTxtSearchFirst.Date := TglSkrg;
 SellTxtSearchLast.Date  := TglSkrg;

 SellBtnClearClick(Self);
end;

procedure TFrmpolist.PrintListpo;
var
  FrxMemo: TfrxMemoView;
begin
 Datamodule1.frxReport1.LoadFromFile(vpath+'Report\polist.fr3');

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('docno'));
  FrxMemo.Memo.Text := Datamodule1.ZQrypolistpono.Value ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('doctgl'));
  FrxMemo.Memo.Text := FormatDateTime('dd-mm-yyyy',Datamodule1.ZQrypolisttgl.Value);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('supplier'));
  FrxMemo.Memo.Text := Datamodule1.ZQrypolistnmsupplier.Value;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('totalprice'));
  FrxMemo.Memo.Text := Datamodule1.ZQrypolisttotalprice.DisplayText;

  Datamodule1.frxReport1.ShowReport();
end;

procedure TFrmpolist.SellBtnDelClick(Sender: TObject);
begin
  if Datamodule1.ZQrypolist.IsEmpty then Exit;

  if QuestionDialog('Menghapus Data Order Pembelian No. PO ' + Datamodule1.ZQrypolistpono.Value + ' ?') = True then
  begin
      LogInfo(UserName,'Menghapus Data Order Pembelian No. PO ' + Datamodule1.ZQrypolistpono.Value);
      with Datamodule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from purchaseorderdet ');
        SQL.Add('where IDpurchaseorder = ' + QuotedStr(Datamodule1.ZQrypolistIDpurchaseorder.AsString));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from purchaseorder ');
        SQL.Add('where IDpurchaseorder = ' + QuotedStr(Datamodule1.ZQrypolistIDpurchaseorder.AsString));
        ExecSQL;

      end;
      InfoDialog('No. PO ' + Datamodule1.ZQrypolistpono.Value + ' berhasil dihapus !');

    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmpolist.SellBtnPrintListClick(Sender: TObject);
begin
  if Datamodule1.ZQrypolist.IsEmpty then Exit;
  PrintListpo;

end;

procedure TFrmpolist.SellBtnSearchClick(Sender: TObject);
//var
//  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'p.pono like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'p.usernameposted like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with Datamodule1.ZQrypolist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select p.*,concat(s.kode," - ",s.nama) nmsupplier from purchaseorder p ');
    SQL.Add('left join supplier s on p.IDsupplier=s.IDsupplier ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and p.posted is not null ');
    SQL.Add('and p.tgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by p.tgl,p.pono ');
    Open;
    Last;
  end;

  Datamodule1.ZQrypodetlist.Close;
  Datamodule1.ZQrypodetlist.Open;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmpolist.SellBtnClearClick(Sender: TObject);
begin
  with Datamodule1.ZQrypolist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select p.*,concat(s.kode," - ",s.nama) nmsupplier from purchaseorder p ');
    SQL.Add('left join supplier s on p.IDsupplier=s.IDsupplier ');
    SQL.Add('where p.posted is not null ');
    SQL.Add('and p.tgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by p.tgl,p.pono ');

    Open;
    Last;
  end;

  Datamodule1.ZQrypodetlist.Close;
  Datamodule1.ZQrypodetlist.Open;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmpolist.DBMasterDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Datamodule1.ZQrypolistposted.IsNull=false then
    DBMaster.Canvas.Brush.Color := $00A8FFA8
  else
    DBMaster.Canvas.Brush.Color := clWindow;
  DBMaster.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmpolist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQrypodetlist.Close;
 Datamodule1.ZQrypolist.Close;

end;

procedure TFrmpolist.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmpolist.FormShow(Sender: TObject);
begin
// FormShowFirst;
end;

procedure TFrmpolist.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQrypolistIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF Frmpo=nil then
 application.CreateForm(TFrmpo,Frmpo);
 Frmpo.Align:=alclient;
 Frmpo.Parent:=self.parent;
 Frmpo.BorderStyle:=bsnone;
 Frmpo.tagacc := EDIT_ACCESS;
 Frmpo.Show;

end;

end.
