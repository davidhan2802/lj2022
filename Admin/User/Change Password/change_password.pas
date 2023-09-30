unit change_password;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Mask, RzEdit, ExtCtrls, ComCtrls, frxpngimage;

type
  TFrmchangepasswd = class(TForm)
    GBAccess: TGroupBox;
    Label2: TLabel;
    edt_old_passwd: TRzEdit;
    Label1: TLabel;
    edt_nama: TRzEdit;
    ImgOK: TImage;
    ImgBatal: TImage;
    Label3: TLabel;
    Label4: TLabel;
    edt_new_passwd: TRzEdit;
    edt_confirm_passwd: TRzEdit;
    procedure ImgBatalClick(Sender: TObject);
    procedure ImgOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_namaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmchangepasswd: TFrmchangepasswd;

implementation

uses Sparepartfunction, Data;

{$R *.dfm}

procedure TFrmchangepasswd.FormShowFirst;
begin
 GBAccess.Top  := round(Self.Height/2) - 108;
 GBAccess.Left := round(Self.Width/2)  - 234;

 edt_nama.Text       := '';
 edt_old_passwd.Text := '';
 edt_new_passwd.Text := '';
 edt_confirm_passwd.Text := '';

 edt_nama.SetFocus;
end;

procedure TFrmchangepasswd.ImgBatalClick(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmchangepasswd.ImgOKClick(Sender: TObject);
begin
 if (edt_nama.Text <> UserName)or(edt_old_passwd.Text<>Passwd) then
 begin
  ErrorDialog('Isi dulu User Name dan Password lama sesuai Login-nya dengan Benar!');
  edt_nama.SetFocus;
  exit;
 end;

 if (edt_new_passwd.Text='') then
 begin
  ErrorDialog('Isi dahulu Password Baru!');
  edt_new_passwd.SetFocus;
  exit;
 end;

 if (edt_old_passwd.Text=edt_new_passwd.Text) then
 begin
  ErrorDialog('Password Baru tidak boleh sama dengan Password yang lama!');
  edt_new_passwd.SetFocus;
  exit;
 end;

 if (edt_new_passwd.Text<>edt_confirm_passwd.Text) then
 begin
  ErrorDialog('Confirm Password Baru Tidak Benar!');
  edt_confirm_passwd.SetFocus;
  exit;
 end;

 if DataModule1.ZConnection1.ExecuteDirect('update user set password='+QuotedStr(edt_new_passwd.Text)+' where IDuser='+IntToStr(IDUserLogin)) then
 begin
  passwd := edt_new_passwd.Text;
  Infodialog('Berhasil Ubah Password!');

  FormShowFirst;
 end
 else
 begin
  ErrorDialog('Gagal Ubah Password!');
  edt_new_passwd.SetFocus;
 end;
end;

procedure TFrmchangepasswd.FormShow(Sender: TObject);
begin
 edt_nama.SetFocus;
end;

procedure TFrmchangepasswd.edt_namaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_RETURN then ImgOKClick(Sender);

end;

end.
