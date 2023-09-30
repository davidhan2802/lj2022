unit merk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG, DB,
  RzButton, RzRadChk;

type
  Tfrmmerk = class(TForm)
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
    MerkTxtmerk: TRzEdit;
    MerkTxtkategori: TRzComboBox;
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
  frmmerk: Tfrmmerk;

implementation

uses SparePartFunction, Data, merkmaster;

{$R *.dfm}

procedure Tfrmmerk.InsertData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into merk');
    SQL.Add('(merk,kategori) values ');
    SQL.Add('(' + QuotedStr(trim(merkTxtmerk.Text)) + ',');
    SQL.Add( QuotedStr(trim(MerkTxtkategori.Text)) + ')');
    ExecSQL;
  end;
end;

procedure Tfrmmerk.UpdateData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update merk set ');
    SQL.Add('merk = ' + QuotedStr(merkTxtmerk.Text) + ' ');
    SQL.Add(',kategori = ' + QuotedStr(merkTxtkategori.Text) + ' ');
    SQL.Add('where id = ' + DataModule1.ZQrymerkid.AsString );
    ExecSQL;
  end;
end;


procedure Tfrmmerk.FormActivate(Sender: TObject);
begin
{  frmGolongan.Top := frmGolonganmaster.PanelGolongan.Top + 26;
  frmGolongan.Height := frmGolonganmaster.PanelGolongan.Height;
  frmGolongan.Width := frmGolonganmaster.PanelGolongan.Width;
  frmGolongan.Left := 1;     }
end;

procedure Tfrmmerk.FormShowFirst;
begin
  if LblCaption.Caption = 'Tambah Merk' then
  begin
    MerkTxtmerk.Text := '';
    MerkTxtkategori.ItemIndex := -1;
    MerkTxtkategori.Text := '';
  end
  else
  begin
    MerkTxtmerk.Text := '';
    MerkTxtkategori.ItemIndex := -1;
    MerkTxtkategori.Text := '';

    if DataModule1.ZQrymerkmerk.IsNull=false then
    MerkTxtmerk.Text := DataModule1.ZQrymerkmerk.Text;

    if DataModule1.ZQrymerkkategori.IsNull=false then
    MerkTxtkategori.itemindex := MerkTxtkategori.items.indexof(DataModule1.ZQrymerkkategori.AsString);
  end;
end;

procedure Tfrmmerk.BtnAddClick(Sender: TObject);
var
  EmptyValue: Boolean;
begin
  if MerkTxtmerk.Text = '' then
  begin
    ErrorDialog('Merk harus diisi!');
    MerkTxtmerk.SetFocus;
    Exit;
  end;

  if MerkTxtkategori.Text = '' then
  begin
    ErrorDialog('Divisi harus diisi!');
    MerkTxtkategori.SetFocus;
    Exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check if exists
    Close;
    SQL.Clear;
    SQL.Add('select id from merk');
    SQL.Add('where merk = ' + QuotedStr(MerkTxtmerk.Text) );
    Open;
    EmptyValue := IsEmpty;
  end;

  if LblCaption.Caption = 'Tambah Merk' then
  begin
    if EmptyValue = False then
    begin
      InfoDialog('Merk ' + MerkTxtmerk.Text +' sudah terdaftar');
      Exit;
    end;
    InsertData;
    InfoDialog('Tambah Merk ' + MerkTxtmerk.Text + ' berhasil');
    LogInfo(UserName,'Insert Merk merk: ' + MerkTxtmerk.Text + ',Divisi: ' + MerkTxtkategori.Text);
  end
  else
  begin
    UpdateData;
    InfoDialog('Edit Merk ' + MerkTxtmerk.Text + ' berhasil');
    LogInfo(UserName,'Edit Merk merk: ' + MerkTxtmerk.Text + ',Divisi: ' + MerkTxtkategori.Text);
  end;
  Close;
end;

procedure Tfrmmerk.BtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrmmerk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 IF Frmmerkmaster=nil then
 application.CreateForm(TFrmmerkmaster,Frmmerkmaster);
 Frmmerkmaster.Align:=alclient;
 Frmmerkmaster.Parent:=Self.Parent;
 Frmmerkmaster.BorderStyle:=bsnone;
 Frmmerkmaster.FormShowFirst;
 Frmmerkmaster.Show;


end;

end.
