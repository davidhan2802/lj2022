unit pindahgudanglist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzRadGrp;

type
  TFrmpindahgudanglist = class(TForm)
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
    RGgroup: TRzRadioGroup;
    pnl_edit: TRzPanel;
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
    procedure PrintListpindahgudang;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmpindahgudanglist: TFrmpindahgudanglist;
  SearchCategories: string;

implementation

uses SparePartFunction, data, pindahgudang;

{$R *.dfm}

procedure TFrmpindahgudanglist.FormShowFirst;
begin
 pnl_del.Visible    := isdel;
 pnl_edit.Visible   := isedit;

 SellTxtSearchFirst.Date := TglSkrg;
 SellTxtSearchLast.Date  := TglSkrg;

 SellBtnClearClick(Self);
end;

procedure TFrmpindahgudanglist.PrintListpindahgudang;
var
  FrxMemo: TfrxMemoView;
begin
 Datamodule1.ZQrypindahgudanglistrep.Close;
 Datamodule1.ZQrypindahgudanglistrep.SQL.Clear;
 Datamodule1.ZQrypindahgudanglistrep.SQL.Text := 'select i.IDpindahgudang,g.IDgolongan,g.kode,g.nama,sum(i.qty) qty, sum(i.qty*i.hargabeli) value,p.barcode from pindahgudangdet i ' +
                                                 'left join product p on i.IDproduct=p.IDproduct ' +
                                                 'left join golongan g on p.IDgolongan=g.IDgolongan ' +
                                                 'where i.IDpindahgudang=' + Datamodule1.ZQrypindahgudanglistIDpindahgudang.AsString + ' ' +
                                                 'group by i.IDpindahgudang,g.IDgolongan,g.kode,g.nama ' +
                                                 'order by g.kode; ';
 Datamodule1.ZQrypindahgudanglistrep.Open;

 if RGgroup.ItemIndex=0 then Datamodule1.frxReport1.LoadFromFile(vpath+'Report\pindahgudanglist.fr3')
 else
 begin
  Datamodule1.ZQrypindahgudanglistrepdet.close;
  Datamodule1.ZQrypindahgudanglistrepdet.open;

  Datamodule1.frxReport1.LoadFromFile(vpath+'Report\pindahgudanglistdet.fr3');
 end;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('judul'));
  FrxMemo.Memo.Text := 'LAPORAN PENGELUARAN ' + Datamodule1.ZQrypindahgudanglistnmgudangto.AsString + ' PER DEPARTEMEN';

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('docno'));
  FrxMemo.Memo.Text := Datamodule1.ZQrypindahgudanglistdocno.AsString;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('doctgl'));
  FrxMemo.Memo.Text := FormatDateTime('dd-MM-yyyy',Datamodule1.ZQrypindahgudanglistdoctgl.Asdatetime);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('from'));
  FrxMemo.Memo.Text := Datamodule1.ZQrypindahgudanglistnmgudangto.AsString;

  Datamodule1.frxReport1.ShowReport();

  Datamodule1.ZQrypindahgudanglistrepdet.Close;
  Datamodule1.ZQrypindahgudanglistrep.Close;

end;

procedure TFrmpindahgudanglist.SellBtnDelClick(Sender: TObject);
begin
  if Datamodule1.ZQrypindahgudanglist.IsEmpty then Exit;

  if QuestionDialog('Menghapus Data Pengeluaran Gudang Doc No. ' + Datamodule1.ZQrypindahgudanglistdocno.Value + ' ?') = True then
  begin
      LogInfo(UserName,'Menghapus Data Pengeluaran Gudang Doc No. ' + Datamodule1.ZQrypindahgudanglistdocno.Value);
      with Datamodule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from pindahgudangdet ');
        SQL.Add('where IDpindahgudang = ' + QuotedStr(Datamodule1.ZQrypindahgudanglistIDpindahgudang.AsString));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from pindahgudang ');
        SQL.Add('where IDpindahgudang = ' + QuotedStr(Datamodule1.ZQrypindahgudanglistIDpindahgudang.AsString));
        ExecSQL;

      end;
      InfoDialog('Doc No. ' + Datamodule1.ZQrypindahgudanglistdocno.Value + ' berhasil dihapus !');

    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmpindahgudanglist.SellBtnPrintListClick(Sender: TObject);
begin
  if Datamodule1.ZQrypindahgudanglist.IsEmpty then Exit;
  PrintListpindahgudang;

end;

procedure TFrmpindahgudanglist.SellBtnSearchClick(Sender: TObject);
//var
//  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'b.docno like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'b.usernameposted like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with Datamodule1.ZQrypindahgudanglist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.*,g.namagudang nmgudang,o.namagudang nmgudangto from pindahgudang b ');
    SQL.Add('left join gudang g on b.IDgudang=g.IDgudang ');
    SQL.Add('left join gudang o on b.IDgudangto=o.IDgudang ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQrypindahgudanglistdet.Close;
  Datamodule1.ZQrypindahgudanglistdet.Open;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmpindahgudanglist.SellBtnClearClick(Sender: TObject);
begin
  with Datamodule1.ZQrypindahgudanglist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.*,g.namagudang nmgudang,o.namagudang nmgudangto from pindahgudang b ');
    SQL.Add('left join gudang g on b.IDgudang=g.IDgudang ');
    SQL.Add('left join gudang o on b.IDgudangto=o.IDgudang ');
    SQL.Add('where b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQrypindahgudanglistdet.Close;
  Datamodule1.ZQrypindahgudanglistdet.Open;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmpindahgudanglist.DBMasterDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Datamodule1.ZQrypindahgudanglistposted.IsNull=false then
    DBMaster.Canvas.Brush.Color := $00A8FFA8
  else
    DBMaster.Canvas.Brush.Color := clWindow;
  DBMaster.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmpindahgudanglist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQrypindahgudanglistdet.Close;
 Datamodule1.ZQrypindahgudanglist.Close;

end;

procedure TFrmpindahgudanglist.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmpindahgudanglist.FormShow(Sender: TObject);
begin
// FormShowFirst;
end;

procedure TFrmpindahgudanglist.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQrypindahgudanglistIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF Frmpindahgudang=nil then
 application.CreateForm(TFrmpindahgudang,Frmpindahgudang);
 Frmpindahgudang.Align:=alclient;
 Frmpindahgudang.Parent:=self.parent;
 Frmpindahgudang.BorderStyle:=bsnone;
 Frmpindahgudang.tagacc := EDIT_ACCESS;
 Frmpindahgudang.Show;

end;

end.
