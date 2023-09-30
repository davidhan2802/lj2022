unit Golongan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG, DB,
  RzButton, RzRadChk;

type
  TfrmGolongan = class(TForm)
    Panelsales: TRzPanel;
    RzPanel2: TRzPanel;
    LblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    BtnAdd: TAdvSmoothButton;
    BtnDel: TAdvSmoothButton;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    GolonganTxtNama: TRzEdit;
    GolonganTxtKode: TRzEdit;
    procedure FormActivate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure InsertData;
    procedure UpdateData;
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  frmGolongan: TfrmGolongan;

implementation

uses SparePartFunction, Data, golonganmaster;

{$R *.dfm}

procedure TfrmGolongan.InsertData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into Golongan');
    SQL.Add('(kode,nama) values ');
    SQL.Add('(' + QuotedStr(trim(GolonganTxtKode.Text)) + ',');
    SQL.Add( QuotedStr(trim(GolonganTxtNama.Text)) + ')');
    ExecSQL;
  end;
end;

procedure TfrmGolongan.UpdateData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update Golongan set ');
    SQL.Add('nama = ' + QuotedStr(GolonganTxtNama.Text) + ' ');
    SQL.Add('where kode = ' + QuotedStr(GolonganTxtKode.Text));
    ExecSQL;
  end;
end;


procedure TfrmGolongan.FormActivate(Sender: TObject);
begin
{  frmGolongan.Top := frmGolonganmaster.PanelGolongan.Top + 26;
  frmGolongan.Height := frmGolonganmaster.PanelGolongan.Height;
  frmGolongan.Width := frmGolonganmaster.PanelGolongan.Width;
  frmGolongan.Left := 1;     }
end;

procedure TfrmGolongan.FormShowFirst;
begin
  if LblCaption.Caption = 'Tambah Golongan' then
  begin
    GolonganTxtKode.Enabled := True;
    GolonganTxtKode.Text := '';
    GolonganTxtNama.Text := '';
  end
  else
  begin
    GolonganTxtKode.Text := '';
    GolonganTxtNama.Text := '';

    GolonganTxtKode.Enabled := False;

    if DataModule1.ZQryGolongankode.IsNull=false then
    GolonganTxtKode.Text := DataModule1.ZQryGolongankode.Text;

    if DataModule1.ZQryGolongannama.IsNull=false then
    GolonganTxtNama.Text := DataModule1.ZQryGolongannama.Text;
  end;
end;

procedure TfrmGolongan.BtnAddClick(Sender: TObject);
var
  EmptyValue: Boolean;
begin
  if GolonganTxtKode.Text = '' then
  begin
    ErrorDialog('Kode harus diisi!');
    GolonganTxtKode.SetFocus;
    Exit;
  end;

  if GolonganTxtnama.Text = '' then
  begin
    ErrorDialog('Nama harus diisi!');
    GolonganTxtNama.SetFocus;
    Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check if exists
    Close;
    SQL.Clear;
    SQL.Add('select idGolongan from Golongan');
    SQL.Add('where kode = ' + QuotedStr(GolonganTxtKode.Text)+' or nama = ' + QuotedStr(GolonganTxtNama.Text) );
    Open;
    EmptyValue := IsEmpty;
  end;

  if LblCaption.Caption = 'Tambah Golongan' then
  begin
    if EmptyValue = False then
    begin
      InfoDialog('Kode ' + GolonganTxtKode.Text + ' atau Nama '+ GolonganTxtNama.Text +' sudah terdaftar');
      Exit;
    end;
    InsertData;
    InfoDialog('Tambah Golongan ' + GolonganTxtNama.Text + ' berhasil');
    LogInfo(UserName,'Insert Golongan kode: ' + GolonganTxtKode.Text + ',nama: ' + GolonganTxtNama.Text);
  end
  else
  begin
    UpdateData;
    InfoDialog('Edit Golongan ' + GolonganTxtNama.Text + ' berhasil');
    LogInfo(UserName,'Edit Golongan kode: ' + GolonganTxtKode.Text + ',nama: ' + GolonganTxtNama.Text);
  end;
  Close;
end;

procedure TfrmGolongan.BtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGolongan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 IF FrmGolonganmaster=nil then
 application.CreateForm(TFrmGolonganmaster,FrmGolonganmaster);
 FrmGolonganmaster.Align:=alclient;
 FrmGolonganmaster.Parent:=Self.Parent;
 FrmGolonganmaster.BorderStyle:=bsnone;
 FrmGolonganmaster.FormShowFirst;
 FrmGolonganmaster.Show;


end;

end.
