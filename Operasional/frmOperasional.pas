unit frmOperasional;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, RzLabel, ExtDlgs, JPEG, RzRadGrp, DB;

type
  TfrmOpr = class(TForm)
    PanelOpr: TRzPanel;
    RzPanel2: TRzPanel;
    OprLblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    OprBtnAdd: TAdvSmoothButton;
    OprBtnDel: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    OprTxtKeterangan: TRzMemo;
    OprTxtNo: TRzEdit;
    OprTxtTgl: TRzDateTimeEdit;
    OprTxtBiaya: TRzNumericEdit;
    OprLblBiaya: TRzLabel;
    RzLabel3: TRzLabel;
    OprTxtDebet: TRzNumericEdit;
    OprLblDebet: TRzLabel;
    RGkategori: TRzRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure OprBtnAddClick(Sender: TObject);
    procedure OprBtnDelClick(Sender: TObject);
    procedure OprTxtBiayaChange(Sender: TObject);
    procedure OprTxtDebetChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    OldBiaya: Double;
    procedure InsertData;
    procedure UpdateData;
    { Private declarations }
  public
    procedure DeleteData(NoFaktur: string);
    { Public declarations }
  end;

var
  frmOpr: TfrmOpr;

implementation

uses SparePartFunction, Data, operasionalmaster;

{$R *.dfm}

procedure TfrmOpr.InsertData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into operasional');
    SQL.Add('(faktur,tanggal,waktu,kasir,kategori,keterangan,debet,kredit) values');
    SQL.Add('(' + Quotedstr(OprTxtNo.Text) + ',');
    SQL.Add(Quotedstr(FormatDateTime('yyyy-MM-dd',OprTxtTgl.Date)) + ',');
    SQL.Add(Quotedstr(FormatDateTime('hh:nn:ss',Now)) + ',');
    SQL.Add(Quotedstr(UserName) + ',');
//    SQL.Add(Quotedstr('OPERASIONAL') + ',');
    SQL.Add(Quotedstr(uppercase(RGkategori.Items.Strings[RGkategori.itemindex])) + ',');
    SQL.Add(Quotedstr(OprTxtKeterangan.Text) + ',');
    SQL.Add(Quotedstr(FloatToStr(OprTxtDebet.Value)) + ',');
    SQL.Add(Quotedstr(FloatToStr(OprTxtBiaya.Value)) + ')');
    ExecSQL;
  end;
end;

procedure TfrmOpr.UpdateData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update operasional set');
    SQL.Add('tanggal = ' + Quotedstr(FormatDateTime('yyyy-MM-dd',OprTxtTgl.Date)) + ',');
//    SQL.Add('waktu = '   + Quotedstr(FormatDateTime('hh:mm:ss',Now)) + ',');
    SQL.Add('kasir = '   + Quotedstr(UserName) + ',');
//    SQL.Add('kategori = ' + Quotedstr('OPERASIONAL') + ',');
    SQL.Add('kategori = ' + Quotedstr(uppercase(RGkategori.Items.Strings[RGkategori.itemindex])) + ',');
    SQL.Add('keterangan = ' + Quotedstr(OprTxtKeterangan.Text) + ',');
    SQL.Add('debet = ' + Quotedstr(FloatToStr(OprTxtDebet.Value)) + ',');
    SQL.Add('kredit = ' + Quotedstr(FloatToStr(OprTxtBiaya.Value)) + ' ');
    SQL.Add('where faktur = ' + Quotedstr(OprTxtNo.Text) );
    ExecSQL;
  end;
end;

procedure TfrmOpr.DeleteData(NoFaktur: string);
var
  NamaFaktur: string;
  PosRecord: integer;
begin
  NamaFaktur := NoFaktur;
  LogInfo(UserName,'Menghapus operasional ' + NamaFaktur);
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from operasional');
    SQL.Add('where idoperasional = ' + DataModule1.ZQryFormOperasionalidoperasional.AsString + ' and faktur=' + QuotedStr(NamaFaktur));
    ExecSQL;
  end;
  PosRecord := DataModule1.ZQryFormOperasional.RecNo;
  DataModule1.ZQryFormOperasional.Close;
  DataModule1.ZQryFormOperasional.Open;
  DataModule1.ZQryFormOperasional.RecNo := PosRecord;
  InfoDialog('Faktur ' + NamaFaktur + ' berhasil dihapus !');
end;

procedure TfrmOpr.FormShow(Sender: TObject);
begin
  if OprLblCaption.Caption = 'Tambah Operasional' then
  begin
    OprTxtNo.Enabled := True;
    OprTxtNo.Text := '';
    OprTxtKeterangan.Text := '';
    RGkategori.ItemIndex := 0;
    OprTxtDebet.Value := 0;
    OprTxtBiaya.Value := 0;
    OprTxtTgl.Date := Tglskrg;
    OprTxtTgl.Enabled := True;
  end
  else
  begin
    OprTxtNo.Enabled := False;
    OprTxtNo.Text := DataModule1.ZQryFormOperasionalfaktur.Text;
    OprTxtTgl.Date := DataModule1.ZQryFormOperasionaltanggal.Value;
    OprTxtKeterangan.Text := DataModule1.ZQryFormOperasionalketerangan.Text;
    OldBiaya := DataModule1.ZQryFormOperasionalkredit.Value;
    OprTxtBiaya.Value := DataModule1.ZQryFormOperasionalkredit.Value;
    OprTxtDebet.Value := DataModule1.ZQryFormOperasionaldebet.Value;
    if DataModule1.ZQryFormOperasionalkategori.Value='OPERASIONAL' then RGkategori.ItemIndex := 0
    else if DataModule1.ZQryFormOperasionalkategori.Value='SETOR BANK' then RGkategori.ItemIndex := 1
    else if DataModule1.ZQryFormOperasionalkategori.Value='BANK' then RGkategori.ItemIndex := 2;
  end;
end;

procedure TfrmOpr.OprBtnAddClick(Sender: TObject);
var
  EmptyValue: Boolean;
begin
  if (OprTxtBiaya.Value=0)and(OprTxtDebet.Value=0) then
  begin
   ErrorDialog('Jumlah Debet atau Kredit salah satu harus lebih besar dari 0 (nol) !');
   Exit;
  end;

  if (OprTxtBiaya.Value<0)or(OprTxtDebet.Value<0) then
  begin
   ErrorDialog('Jumlah Debet atau Kredit tidak boleh lebih kecil dari 0 (nol) !');
   Exit;
  end;

  if (OprTxtBiaya.Value<>0)and(OprTxtDebet.Value<>0) then
  begin
   ErrorDialog('Jumlah Debet atau Kredit salah satu harus lebih besar dari 0 (nol) !');
   Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check if exists
    Close;
    SQL.Clear;
    SQL.Add('select * from operasional');
    SQL.Add('where faktur = ''' + OprTxtNo.Text + '''');
    Open;
    EmptyValue := IsEmpty;
  end;

  if OprLblCaption.Caption = 'Tambah Operasional' then
  begin
    if EmptyValue = False then
    begin
      InfoDialog('Faktur ' + OprTxtNo.Text + ' sudah terdaftar');
      Exit;
    end;
    InsertData;
    InfoDialog('Tambah Operasional ' + OprTxtNo.Text + ' berhasil');
    LogInfo(UserName,'Insert Operasional Faktur No. ' + OprTxtNo.Text + ',biaya: ' + FloatToStr(OprTxtBiaya.Value));
  end
  else
  begin
    UpdateData;
    InfoDialog('Edit Operasional ' + OprTxtNo.Text + ' berhasil');
    LogInfo(UserName,'Edit Operasional Faktur No. ' + OprTxtNo.Text + ',biaya awal: ' + FloatToStr(OldBiaya) + ',biaya baru: ' + FloatToStr(OprTxtBiaya.Value));
  end;
  Close;
end;

procedure TfrmOpr.OprBtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOpr.OprTxtBiayaChange(Sender: TObject);
begin
  OprLblBiaya.Caption := FormatCurr('Rp ###,###',OprTxtBiaya.Value);
end;

procedure TfrmOpr.OprTxtDebetChange(Sender: TObject);
begin
  OprLblDebet.Caption := FormatCurr('Rp ###,###',OprTxtDebet.Value);

end;

procedure TfrmOpr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 IF Frmoperasionalmaster=nil then
 application.CreateForm(TFrmoperasionalmaster,Frmoperasionalmaster);
 Frmoperasionalmaster.Align:=alclient;
 Frmoperasionalmaster.Parent:=Self.Parent;
 Frmoperasionalmaster.BorderStyle:=bsnone;
 Frmoperasionalmaster.FormShowFirst;
 Frmoperasionalmaster.Show;
end;

end.
