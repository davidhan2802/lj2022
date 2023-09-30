unit frmAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzStatus, RzButton, RzRadChk, frxClass;

type
  TfrmAdj = class(TForm)
    Panel: TRzPanel;
    RzPanel3: TRzPanel;
    RzLabel15: TRzLabel;
    AdjustTxtTgl: TRzDateTimeEdit;
    AdjustDBGrid: TRzDBGrid;
    RzPanel2: TRzPanel;
    LblCaption: TRzLabel;
    RzLabel1: TRzLabel;
    AdjustTxtFaktur: TRzEdit;
    RtrJualTxtCetak: TRzCheckBox;
    RzPanel7: TRzPanel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    SellBtnAdd: TAdvSmoothButton;
    SellBtnDel: TAdvSmoothButton;
    AdjustTxtGudang: TRzComboBox;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdjustBtnAddClick(Sender: TObject);
    procedure AdjustBtnDelClick(Sender: TObject);
    procedure AdjustDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellBtnDelClick(Sender: TObject);
  private
    oldTotal,TotalTrans: Double;
    procedure ClearForm;
    procedure InsertDataMaster;
    procedure UpdateData;
    function getNoAdjust : string;
    { Private declarations }
  public
    SubTotal : Double;
    CetakFaktur: string;
    procedure PostingAdjust(Faktur: string);
    procedure PrintStruck(NoFaktur: string);
    { Public declarations }
  end;

var
  frmAdj: TfrmAdj;

implementation

uses SparePartFunction, Data, frmSearchProduct;

{$R *.dfm}

function TfrmAdj.getNoAdjust : string;
var Year,Month,Day: Word;
begin
    DecodeDate(TglSkrg,Year,Month,Day);
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(right(faktur,3)) from adjustmaster');
      SQL.Add('where faktur like "ADJ' + standPos + '-' + Copy(IntToStr(Year),3,2) + '%' + '"');
//      SQL.Add('where faktur like "ADJ' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '%' + '"');
      Open;
      if (isEmpty) or (Fields[0].IsNull) or (Fields[0].AsString = '') then
        result := 'ADJ' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + '0001'
      else
        result := 'ADJ' + standPos + '-' + Copy(IntToStr(Year),3,2) + FormatCurr('00',Month) + FormatCurr('0000',Fields[0].AsInteger + 1);
      Close;
    end;
end;

procedure TfrmAdj.ClearForm;
begin
  ClearTabel('formadjust where ipv='+ Quotedstr(ipcomp));
  AdjustTxtFaktur.Text := getNoAdjust;
  RefreshTabel(DataModule1.ZQryFormAdjust);
  AdjustTxtTgl.Date := TglSkrg;
  AdjustTxtGudang.ItemIndex := 0;
  AdjustDBGrid.SetFocus;
end;

procedure TfrmAdj.InsertDataMaster;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into adjustmaster');
    SQL.Add('(faktur,tanggal,waktu,operator,kodegudang,totaladjust,isposted) values');
    SQL.Add('("' + AdjustTxtFaktur.Text + '",');
    SQL.Add('"' + FormatDateTime('yyyy-MM-dd',AdjustTxtTgl.Date) + '",');
    SQL.Add('"' + FormatDateTime('hh:nn:ss',Now) + '",');
    SQL.Add('"' + UserName + '",');
    case AdjustTxtGudang.ItemIndex of
    0 : SQL.Add('"'+kodegudang+'",');
    1 : SQL.Add('"'+kodegudang+'T",');
    2 : SQL.Add('"'+kodegudang+'R",');
    end;
    SQL.Add('"' + FloatToStr(SubTotal) + '",');
    SQL.Add('"' + '0' + '")');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into adjustdetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,tipe,seri,keterangan,qtybefore,qtyafter,hargabeli,hargajual,diskon,diskonrp,satuan,subtotal)');
    SQL.Add('select faktur,kode,nama,kategori,merk,tipe,seri,keterangan,quantity,quantityadjust,harga,hargajual,diskon,diskonrp,satuan,subtotal ');
    SQL.Add('from formadjust where ipv='+ Quotedstr(ipcomp));
    ExecSQL;
  end;
end;

procedure TfrmAdj.UpdateData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update adjustmaster set');
    SQL.Add('tanggal = "' + FormatDateTime('yyyy-MM-dd',AdjustTxtTgl.Date) + '",');
    SQL.Add('waktu = "' + FormatDateTime('hh:nn:ss',Now) + '",');
    SQL.Add('operator = "' + UserName + '",');
    SQL.Add('totaladjust = "' + FloatToStr(SubTotal) + '"');

    case AdjustTxtGudang.ItemIndex of
    0 : SQL.Add('kodegudang = "'+kodegudang+'",');
    1 : SQL.Add('kodegudang = "'+kodegudang+'T",');
    2 : SQL.Add('kodegudang = "'+kodegudang+'R",');
    end;


    SQL.Add('where faktur = "' + AdjustTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('delete from adjustdetail');
    SQL.Add('where faktur = "' + AdjustTxtFaktur.Text + '"');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into adjustdetail');
    SQL.Add('(faktur,kode,nama,kategori,merk,tipe,seri,keterangan,qtybefore,qtyafter,hargabeli,hargajual,diskon,diskonrp,satuan)');
    SQL.Add('select faktur,kode,nama,kategori,merk,tipe,seri,keterangan,quantity,quantityadjust,harga,hargajual,diskon,diskonrp,satuan');
    SQL.Add('from formadjust where ipv='+ Quotedstr(ipcomp));
    ExecSQL;
  end;
end;

procedure TfrmAdj.PostingAdjust(Faktur: string);
var idTrans,Total,vwkt,vkodegdg: string;
begin
    with DataModule1.ZQrySearch do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from adjustmaster');
      SQL.Add('where faktur = ' + Quotedstr(Faktur) );
      Open;

      idTrans := FieldByName('idAdjust').AsString;
      if idTrans = '' then idTrans := '0';
      Total := FieldByName('totaladjust').AsString;
      vwkt  := Formatdatetime('hh:nn:ss', FieldByName('waktu').AsDateTime);
    end;

    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update adjustmaster set');
      SQL.Add('isposted = 1 ');
      SQL.Add('where faktur = ' + Quotedstr(Faktur) );
      ExecSQL;

      case AdjustTxtGudang.ItemIndex of
      0 : vkodegdg := kodegudang;
      1 : vkodegdg := kodegudang+'T';
      2 : vkodegdg := kodegudang+'R';
      end;

      ///Input Inventory
      Close;
      SQL.Clear;
      SQL.Add('insert into inventory');
      SQL.Add('(kodebrg,qty,satuan,hargabeli,hargajual,faktur,typetrans,keterangan,idTrans,username,tglTrans,waktu,kodeGudang)');
      SQL.Add('select kode,(quantityadjust - quantity),satuan,harga,hargajual,faktur,"ADJUSTMENT",keterangan,' + idTrans + ',' + QuotedStr(UserName) + ',' + QuotedStr(FormatDateTime('yyyy-MM-dd',TglSkrg)) + ',' + Quotedstr(vwkt) + ',' + QuotedStr(vkodegdg) + ' from formadjust where ipv='+ Quotedstr(ipcomp));
      ExecSQL;

      {///Input Operasional
      if JenisBayar = 'TUNAI' then
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into operasional');
        SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,');
        if StrToFloat(Total) > 0 then
          SQL.Add('debet) values')
        else
          SQL.Add('kredit) values');
        SQL.Add('(''' + idTrans + ''',');
        SQL.Add('''' + FakturBaru + ''',');
        SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
        SQL.Add('''' + FormatDateTime('hh:nn:ss',Now) + ''',');
        SQL.Add('''' + UserName + ''',');
        SQL.Add('''' + 'ADJUSTMENT' + ''',');
        SQL.Add('''' + '' + ''',');
        SQL.Add('''' + Total + ''')');
        ExecSQL;
      end;     }

      LogInfo(UserName,'Posting transaksi adjust, no faktur : ' + Faktur + ', nilai transaksi:' + Total);
      InfoDialog('Faktur Adjust ' + Faktur + ' berhasil diposting !');
    end;
end;

procedure TfrmAdj.PrintStruck(NoFaktur: string);
var
  FrxMemo: TfrxMemoView;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from adjustmaster');
    SQL.Add('where faktur = ''' + NoFaktur + '''');
    Open;
  end;
  DataModule1.frxReport1.LoadFromFile('fakturadjust.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('Faktur').AsString;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglNota'));
  FrxMemo.Memo.Text := FormatDateTime('dd MMMM yyyy',DataModule1.ZQryFunction.FieldByName('Tanggal').AsDateTime);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('JamNota'));
  FrxMemo.Memo.Text := FormatDateTime('hh:nn:ss',DataModule1.ZQryFunction.FieldByName('Waktu').AsDateTime);
  ///Isi FormSupplier dengan DetailSupplier

  ClearTabel('formadjust where ipv='+ Quotedstr(ipcomp));

  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into formadjust ');
    SQL.Add('(ipv,nama,quantityadjust,harga,hargajual,diskon,diskonrp,subtotal)');
    SQL.Add('select '+Quotedstr(ipcomp)+',nama,(qtyafter - qtybefore),hargabeli,hargajual,diskon,diskonrp,(qtyafter - qtybefore) * (hargabeli - diskonrp) as subtotal from adjustdetail ');
    SQL.Add('where faktur = ''' + NoFaktur + '''');
    ExecSQL;
  end;

  RefreshTabel(DataModule1.ZQryFormAdjust);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Kasir'));
  FrxMemo.Memo.Text := 'Kasir : ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

procedure TfrmAdj.FormActivate(Sender: TObject);
begin
{  frmAdj.Top := frmadjustmaster.PanelAdjust.Top + 26;
  frmAdj.Height := frmadjustmaster.PanelAdjust.Height;
  frmAdj.Width := frmadjustmaster.PanelAdjust.Width;
  frmAdj.Left := 1;  }
end;

procedure TfrmAdj.FormShow(Sender: TObject);
begin
  ipcomp := getComputerIP;

  DataModule1.ZQryformAdjust.Close;
  DataModule1.ZQryformAdjust.SQL.Text := 'select * from formadjust where ipv='+ Quotedstr(ipcomp) + ' order by kode ';

  LblCaption.Caption := 'Input Adjustment';

  if LblCaption.Caption = 'Input Adjustment' then
  begin
    ClearForm;
  end
  else
  begin
    AdjustTxtFaktur.Text := DataModule1.ZQryAdjustfaktur.Value;
    AdjustTxtTgl.Date := DataModule1.ZQryAdjusttanggal.Value;
    TotalTrans := DataModule1.ZQryAdjusttotaladjust.Value;

    oldTotal := DataModule1.ZQryAdjusttotaladjust.Value;

    ClearTabel('formadjust where ipv='+ Quotedstr(ipcomp));
    with DataModule1.ZQryFunction do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into formadjust ');
      SQL.Add('(ipv,kode,nama,quantity,quantityadjust,keterangan,harga,hargajual,subtotal,');
      SQL.Add('kategori,merk,tipe,seri,faktur,harganodiskon,diskon,diskonrp)');
      SQL.Add('select '+Quotedstr(ipcomp)+',kode,nama,qtybefore,qtyafter,keterangan,hargabeli,hargajual,(qtyafter - qtybefore) * hargabeli,');
      SQL.Add('kategori,merk,tipe,seri,faktur,hargabeli,diskon,diskonrp from adjustdetail');
      SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Text + '''');
      ShowMessage(SQL.Text);
      ExecSQL;
    end;
    RefreshTabel(DataModule1.ZQryFormAdjust);
    SubTotal := DataModule1.ZQryAdjusttotaladjust.Value;
  end;
end;

procedure TfrmAdj.AdjustBtnAddClick(Sender: TObject);
begin
  if DataModule1.ZQryFormAdjust.IsEmpty then
  begin
   errordialog('Transaksi tidak boleh kosong!');
   exit;
  end;

  if (AdjustTxtGudang.ItemIndex = -1)or(AdjustTxtGudang.Text='') then
  begin
   errordialog('Pilih dahulu ITEM GUDANG atau TOKO atau RUSAK!');
   exit;
  end;

  DataModule1.ZQryFormAdjust.CommitUpdates;
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from formadjust ');
    SQL.Add('where ipv='+Quotedstr(ipcomp)+' and quantityadjust = quantity');
    Open;
    if not IsEmpty then
    begin
      ErrorDialog('Ada yang belum di sesuaikan');
      Exit;
    end;

    Close;
    SQL.Clear;
    SQL.Add('select sum((quantityadjust - quantity) * harga) from formadjust where ipv='+ Quotedstr(ipcomp));
    Open;
    SubTotal := Fields[0].AsCurrency;
  end;

  DataModule1.ZConnection1.StartTransaction;
  try
    InsertDataMaster;
    PostingAdjust(AdjustTxtFaktur.Text);
    LogInfo(UserName,'Insert Adjustment Faktur No: ' + AdjustTxtFaktur.Text + ',Total: ' + FloatToStr(SubTotal));

    DataModule1.ZConnection1.Commit;

//    PrintStruck(CetakFaktur);
    ClearForm;
  except
    DataModule1.ZConnection1.Rollback;
    DataModule1.ZConnection1.ExecuteDirect('call p_canceladjust('+QuotedStr(CetakFaktur)+')');
    ErrorDialog('Gagal Posting, coba ulangi Buat Adjustment lagi!');
    ClearForm;
  end;

end;

procedure TfrmAdj.AdjustBtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAdj.AdjustDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    frmSrcProd.formSender := frmAdj;
    frmSrcProd.ShowModal;
  end;

  if (Key = VK_DELETE) then
  begin
    DataModule1.ZQryFormAdjust.Delete;
  end;

end;

procedure TfrmAdj.SellBtnDelClick(Sender: TObject);
begin
 ClearForm;
end;

end.
