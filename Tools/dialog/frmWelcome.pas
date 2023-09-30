unit frmWelcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzEdit, AdvSmoothButton, Mask, RzLabel, ExtCtrls,
  RzPanel, RzTabs, RzCmboBx;

type
  TfrmTutorial = class(TForm)
    PanelTutorial: TRzPanel;
    RzPanel36: TRzPanel;
    RzLabel1: TRzLabel;
    TutorialTab: TRzTabControl;
    TutorialBtnNext: TAdvSmoothButton;
    TutorialBtnPrevious: TAdvSmoothButton;
    TutorialGrpWelcome: TRzGroupBox;
    RzMemo1: TRzMemo;
    TutorialGrpUser: TRzGroupBox;
    RzMemo2: TRzMemo;
    RzLabel137: TRzLabel;
    RzLabel143: TRzLabel;
    TutorialTxtNama: TRzEdit;
    TutorialTxtPass: TRzEdit;
    RzLabel2: TRzLabel;
    TutorialTxtKonfirm: TRzEdit;
    RzLabel3: TRzLabel;
    RzEdit1: TRzEdit;
    TutorialGrpDate: TRzGroupBox;
    RzLabel4: TRzLabel;
    RzMemo3: TRzMemo;
    TutorialTxtSetDate: TRzDateTimeEdit;
    TutorialGrpFinish: TRzGroupBox;
    TutorialMemoFinish: TRzMemo;
    TutorialGrpPosisi: TRzGroupBox;
    RzMemo4: TRzMemo;
    Label1: TLabel;
    TutorialTxtSetCabang: TRzComboBox;
    TutorialSubGrpPosisi: TRzGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    TutorialTxtSetNamaCabang: TRzEdit;
    TutorialTxtSetKodeCabang: TRzEdit;
    Label4: TLabel;
    TutorialTxtSetAlmCabang: TRzEdit;
    Label5: TLabel;
    TutorialTxtSetKotaCabang: TRzEdit;
    Label6: TLabel;
    TutorialTxtSetMAC: TRzEdit;
    procedure FormCreate(Sender: TObject);
    procedure InvisibleGroups;
    procedure TutorialShow(Index: integer);
    procedure TutorialBtnPreviousClick(Sender: TObject);
    procedure TutorialBtnNextClick(Sender: TObject);
    procedure TutorialTabChange(Sender: TObject);
    procedure TutorialTxtSetCabangChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    TutorialIndex: integer;
    { Private declarations }
  public
    Status: string;
    { Public declarations }
  end;

var
  frmTutorial: TfrmTutorial;

implementation

uses frmLogin, frmMain, Data, SparePartFunction;

{$R *.dfm}

procedure TfrmTutorial.FormCreate(Sender: TObject);
begin
  TutorialIndex := 1;
  TutorialShow(TutorialIndex);
  Status := 'terminate';
end;

procedure TfrmTutorial.InvisibleGroups;
begin
  TutorialGrpWelcome.Visible := False;
  TutorialGrpPosisi.Visible := False;
  TutorialGrpUser.Visible := False;
  TutorialGrpDate.Visible := False;
  TutorialGrpFinish.Visible := False;
end;

procedure TfrmTutorial.TutorialShow(Index: integer);
begin
  frmUtama.UserName := '1st install';
  InvisibleGroups;
  Case Index of
  1: TutorialGrpWelcome.Visible := True;
  2: begin
      TutorialGrpPosisi.Visible := True;
      if Application.Title = 'Spare Part Inventory Basic' then
      begin
        TutorialTxtSetCabang.Enabled := False;
        TutorialTxtSetCabang.ItemIndex := 0;
      end
      else
      begin
        TutorialTxtSetCabang.Enabled := True;
      end;
     end;
  3: begin
      TutorialGrpUser.Visible := True;
      TutorialGrpUser.Caption := 'Konfigurasi User';
      TutorialTxtNama.Text := '';
      TutorialTxtPass.Text := '';
      TutorialTxtKonfirm.Text := '';
      TutorialTab.Enabled := True;
      TutorialTxtNama.SetFocus;
     end;
  4: begin
      if TutorialTxtNama.Text = '' then
      begin
        TutorialGrpUser.Visible := True;
        TutorialTxtNama.SetFocus;
        TutorialGrpUser.Caption := 'Konfigurasi User Salah ! (Nama Kosong)';
        TutorialIndex := TutorialIndex - 1;
        Exit;
      end
      else
      if TutorialTxtPass.Text = '' then
      begin
        TutorialGrpUser.Visible := True;
        TutorialTxtPass.SetFocus;
        TutorialGrpUser.Caption := 'Konfigurasi User Salah ! (Password kosong)';
        TutorialIndex := TutorialIndex - 1;
        Exit;
      end
      else
      if TutorialTxtPass.Text <> TutorialTxtKonfirm.Text then
      begin
        TutorialGrpUser.Visible := True;
        TutorialTxtKonfirm.SetFocus;
        TutorialGrpUser.Caption := 'Konfigurasi User Salah ! (Password tidak sama)';
        TutorialIndex := TutorialIndex - 1;
        Exit;
      end
      else
      begin
        TutorialGrpDate.Visible := True;
        TutorialTxtSetDate.Date := Now;
        TutorialTxtSetDate.SetFocus;
      end;
     end;
  5: begin
      TutorialGrpFinish.Visible := True;
      TutorialMemoFinish.Lines.Strings[2] := '   Nama     :    ' + TutorialTxtNama.Text;
      TutorialMemoFinish.Lines.Strings[3] := '   Password :    ' + TutorialTxtPass.Text;
      TutorialMemoFinish.Lines.Strings[4] := '   Tanggal  :    ' + FormatDateTime('dd MMM yyyy',TutorialTxtSetDate.Date);
      TutorialMemoFinish.Lines.Strings[5] := '   Posisi   :    ' + TutorialTxtSetCabang.Value;
     end;
  end;
  TutorialTab.TabIndex := Index - 1;
  if Index = 1 then TutorialBtnPrevious.Visible := False else TutorialBtnPrevious.Visible := True;
  if Index = 5 then TutorialBtnNext.Caption := 'Selesai' else TutorialBtnNext.Caption := 'Berikut';
end;

procedure TfrmTutorial.TutorialBtnPreviousClick(Sender: TObject);
begin
  TutorialIndex := TutorialIndex - 1;
  TutorialShow(TutorialIndex);
end;

procedure TfrmTutorial.TutorialBtnNextClick(Sender: TObject);
begin
  if TutorialBtnNext.Caption = 'Selesai' then
  begin
    Status := '';
    DeleteUser(TutorialTxtNama.Text,'');
    InsertUser(TutorialTxtNama.Text,TutorialTxtPass.Text,'Administrator');
    SetWorkDate(FormatDateTime('yyyy-MM-dd',TutorialTxtSetDate.Date));
    Hide;
    frmUtama.TglSkrg := TutorialTxtSetDate.Date;
    with frmLoginID do
    begin
      LoginTxtName.Text := TutorialTxtNama.Text;
      LoginTxtPass.Text := TutorialTxtPass.Text;
      ShowModal;
    end;
    Close;
  end;
  TutorialIndex := TutorialIndex + 1;
  TutorialShow(TutorialIndex);
end;

procedure TfrmTutorial.TutorialTabChange(Sender: TObject);
begin
  TutorialTab.TabIndex := TutorialIndex - 1;
end;

procedure TfrmTutorial.TutorialTxtSetCabangChange(Sender: TObject);
begin
  if TutorialTxtSetCabang.ItemIndex = 0 then
    TutorialSubGrpPosisi.Visible := False
  else
  begin
    TutorialSubGrpPosisi.Visible := True;
    TutorialTxtSetKodeCabang.SetFocus;
  end;
end;

procedure TfrmTutorial.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Status = 'terminate' then
    Application.Terminate;
end;

end.
