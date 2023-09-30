unit frmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzBckgnd, StdCtrls, RzLabel, RzStatus, AdvSmoothButton, Mask,
  RzEdit;

type
  TfrmLoginID = class(TForm)
    RzBackground1: TRzBackground;
    LblCaption: TRzLabel;
    RzClockStatus1: TRzClockStatus;
    RzLabel5: TRzLabel;
    RzLabel2: TRzLabel;
    LoginTxtName: TRzEdit;
    LoginTxtPass: TRzEdit;
    LoginBtnLogin: TAdvSmoothButton;
    RzLabel105: TRzLabel;
    RzLabel108: TRzLabel;
    LoginBtnExit: TAdvSmoothButton;
    procedure LoginBtnLoginClick(Sender: TObject);
    procedure LoginBtnExitClick(Sender: TObject);
    procedure LoginTxtPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    procedure DisabledAllMenu;
    procedure EnabledAllMenu;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoginID: TfrmLoginID;

implementation

uses Data, frmMain, DB, SparePartFunction;

{$R *.dfm}

procedure TfrmLoginID.DisabledAllMenu;
begin
  with frmUtama do
  begin
    ImgCabang.Enabled := False;
    ImgGudang.Enabled := False;
    ImgProduct.Enabled := False;
    ImgJasa.Enabled := False;
    ImgCustomer.Enabled := False;
    ImgSupplier.Enabled := False;
    ImgPenjualan.Enabled := False;
    ImgPembelian.Enabled := False;
    ImgOperasional.Enabled := False;
    ImgReport.Enabled := False;
  end;
end;

procedure TfrmLoginID.EnabledAllMenu;
begin
  with frmUtama do
  begin
    ImgCabang.Enabled := True;
    ImgGudang.Enabled := True;
    ImgProduct.Enabled := True;
    ImgJasa.Enabled := True;
    ImgCustomer.Enabled := True;
    ImgSupplier.Enabled := True;
    ImgPenjualan.Enabled := True;
    ImgPembelian.Enabled := True;
    ImgOperasional.Enabled := True;
    ImgReport.Enabled := True;
  end;
end;

procedure TfrmLoginID.LoginBtnLoginClick(Sender: TObject);
var
  Rights: string;
begin
  ///Bypass for 1st time
  if DataModule1.ZQryUser.Active = False then
    DataModule1.ZQryUser.Open;
  if DataModule1.ZQryUser.IsEmpty then
  begin
    with frmUtama do
    begin
      UserName := '1st Install';
      UserRight := 'Administrator';
      LoginStatus.Caption := 'Login : 1st Install';
      DisabledAllMenu;
    end;
  end
  else
  begin
    if LoginTxtPass.Text = '' then Exit;
    Rights := CheckLoginExists(LoginTxtName.Text,LoginTxtPass.Text);
    if Rights = '' then
    begin
      ErrorDialog('Nama atau Password salah !');
      LoginTxtName.SetFocus;
      Exit;
    end;
    with frmUtama do
    begin
      UserName := LoginTxtName.Text;
      UserRight := Rights;
      LoginStatus.Caption := 'Login : ' + LoginTxtName.Text;
      if FileExists(frmUtama.ConfigPath) then
      begin
        EnabledAllMenu;
        if GetWorkDate <> Null then
          TglSkrg := Now;
        GetCompanyProfile;
      end
      else
      begin
        DisabledAllMenu;
        TglSkrg := Now;
      end;
    end;
  end;
  DataModule1.ZQryUser.Close;
  Close;
end;

procedure TfrmLoginID.LoginBtnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLoginID.LoginTxtPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    LoginBtnLoginClick(Self);
end;

procedure TfrmLoginID.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

end.
