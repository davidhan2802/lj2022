unit frmRusak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzButton, RzRadChk;

type
  TfrmRsk = class(TForm)
    PanelProd: TRzPanel;
    RzPanel2: TRzPanel;
    RskLblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    ProdBtnAdd: TAdvSmoothButton;
    ProdBtnDel: TAdvSmoothButton;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    ProdTxtNama: TRzEdit;
    RzLabel5: TRzLabel;
    RzLabel9: TRzLabel;
    RzLabel16: TRzLabel;
    ProdTxtMerk: TRzEdit;
    RzLabel18: TRzLabel;
    ProdTxtKategori: TRzEdit;
    ProdTxtKeterangan: TRzEdit;
    RzLabel23: TRzLabel;
    ProdTxtRusak: TRzNumericEdit;
    ProdTxtSatuan: TRzEdit;
    ProdTxtKode: TRzEdit;
    lblMax: TRzLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProdBtnAddClick(Sender: TObject);
    procedure ProdBtnDelClick(Sender: TObject);
  private
    MaxQty : integer;
    KodeGudang: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRsk: TfrmRsk;

implementation

uses frmMain, SparePartFunction, Data, DB, frmDlgGb, Math;

{$R *.dfm}

procedure TfrmRsk.FormActivate(Sender: TObject);
begin
  frmRsk.Top := frmUtama.PanelInventory.Top + 26;
  frmRsk.Height := frmUtama.PanelInventory.Height;
  frmRsk.Width := frmUtama.PanelInventory.Width;
  frmRsk.Left := 1;
end;

procedure TfrmRsk.FormShow(Sender: TObject);
begin
  ProdTxtKode.Text := DataModule1.ZQryInventorykodebrg.Value;
  ProdTxtNama.Text := DataModule1.ZQryInventorynama.Value;
  ProdTxtMerk.Text := DataModule1.ZQryInventorymerk.Value;
  ProdTxtKategori.Text := DataModule1.ZQryInventoryKategori.Value;
  ProdTxtSatuan.Text := DataModule1.ZQryInventorysatuan.Value;
  ProdTxtRusak.Value := 0;
  MaxQty := DataModule1.ZQryInventoryqty.Value;
  lblMax.Caption := 'Maks : ' + IntToStr(MaxQty);
  KodeGudang := DataModule1.ZQryInventorykodegudang.Value;
end;

procedure TfrmRsk.ProdBtnAddClick(Sender: TObject);
begin
  if Trim(ProdTxtKeterangan.Text) = '' then
  begin
    ErrorDialog('Keterangan wajib diisi');
    ProdTxtKeterangan.SetFocus;
    Exit;
  end;
  if ProdTxtRusak.Value > MaxQty then
  begin
    ErrorDialog('Jumlah kerusakan melebihi maksimal');
    ProdTxtRusak.SetFocus;
    Exit;
  end;
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.inventory ');
    SQL.Add('(tgltrans,kodebrg,kodegudang,qty,satuan,typetrans) values ');
    SQL.Add('(''' + FormatDateTime('yyyy-MM-dd',frmUtama.TglSkrg) + ''',');
    SQL.Add('''' + DataModule1.ZQryInventorykodebrg.Value + ''',');
    SQL.Add('''' + DataModule1.ZQryInventorykodegudang.Value + ''',');
    SQL.Add('''' + FloatToStr(ProdTxtRusak.Value * -1) + ''',');
    SQL.Add('''' + DataModule1.ZQryInventorysatuan.Value + ''',');
    SQL.Add('''' + 'rusak' + ''')');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.inventory ');
    SQL.Add('(tgltrans,kodebrg,kodegudang,qty,satuan,typetrans) values ');
    SQL.Add('(''' + FormatDateTime('yyyy-MM-dd',frmUtama.TglSkrg) + ''',');
    SQL.Add('''' + DataModule1.ZQryInventorykodebrg.Value + ''',');
    SQL.Add('''RSK'',');
    SQL.Add('''' + FloatToStr(ProdTxtRusak.IntValue) + ''',');
    SQL.Add('''' + DataModule1.ZQryInventorysatuan.Value + ''',');
    SQL.Add('''' + 'TOKO rusak' + ''')');
    ExecSQL;
  end;
  InfoDialog('Tambah Produk Rusak (' + ProdTxtNama.Text + ') berhasil');
  LogInfo(frmUtama.UserName,'Insert Product Rusak kode: ' + ProdTxtKode.Text + ',nama: ' + ProdTxtNama.Text + ',quantity: ' + IntToStr(ProdTxtRusak.IntValue));
  Close;
end;

procedure TfrmRsk.ProdBtnDelClick(Sender: TObject);
begin
  Close;
end;

end.
