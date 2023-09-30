unit frmDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothButton, StdCtrls, RzLabel, ExtCtrls, RzPanel,
  frxpngimage;

type
  TfrmMessage = class(TForm)
    PanelMessage: TRzPanel;
    RzPanel1: TRzPanel;
    MsgLbl: TRzLabel;
    ImgOK: TImage;
    ImgBatal: TImage;
    LblOK: TRzLabel;
    LblBatal: TRzLabel;
    RzPanel2: TRzPanel;
    MsgMemo: TRzLabel;
    RzPanel3: TRzPanel;
    ImgError: TImage;
    ImgWarning: TImage;
    ImgQuestion: TImage;
    ImgInfo: TImage;
    procedure ImgOKClick(Sender: TObject);
    procedure ImgBatalClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure HideIcons;
    { Private declarations }
  public
    MsgValues: Boolean;
    procedure MsgInfo(Msg: string);
    procedure MsgQuestion(Msg: string);
    procedure MsgWarning(Msg: string);
    procedure MsgError(Msg: string);
    { Public declarations }
  end;

var
  frmMessage: TfrmMessage;

implementation

{$R *.dfm}

procedure TfrmMessage.HideIcons;
begin
  ImgInfo.Visible := False;
  ImgQuestion.Visible := False;
  ImgWarning.Visible := False;
  ImgError.Visible := False;
  ImgBatal.Visible := False;
  LblBatal.Visible := False;
end;

procedure TfrmMessage.MsgInfo(Msg: string);
begin
  HideIcons;
  ImgInfo.Visible := True;
  MsgLbl.Caption := 'Informasi';
  MsgMemo.Caption := Msg;
end;

procedure TfrmMessage.MsgQuestion(Msg: string);
begin
  HideIcons;
  ImgQuestion.Visible := True;
  MsgLbl.Caption := 'Konfirmasi';
  MsgMemo.Caption := Msg;
  ImgBatal.Visible := True;
  LblBatal.Visible := True;
end;

procedure TfrmMessage.MsgWarning(Msg: string);
begin
  HideIcons;
  ImgWarning.Visible := True;
  MsgLbl.Caption := 'Peringatan!';
  MsgMemo.Caption := Msg;
  ImgBatal.Visible := True;
  LblBatal.Visible := True;
end;

procedure TfrmMessage.MsgError(Msg: string);
begin
  HideIcons;
  ImgError.Visible := True;
  MsgLbl.Caption := 'Kesalahan';
  MsgMemo.Caption := Msg;
end;

procedure TfrmMessage.ImgOKClick(Sender: TObject);
begin
  MsgValues := True;
  Close;
end;

procedure TfrmMessage.ImgBatalClick(Sender: TObject);
begin
  MsgValues := False;
  Close;
end;

procedure TfrmMessage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ImgOKClick(Self);
  if Key = VK_ESCAPE then
    ImgBatalClick(Self);
end;

end.
