object frmTutorial: TfrmTutorial
  Left = 245
  Top = 148
  Width = 696
  Height = 480
  Caption = 'Tutorial'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTutorial: TRzPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    Align = alClient
    BorderOuter = fsFlatBold
    Color = 33023
    TabOrder = 0
    DesignSize = (
      688
      446)
    object RzLabel1: TRzLabel
      Left = 1
      Top = 16
      Width = 688
      Height = 45
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Menara Spare Part'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -37
      Font.Name = 'Garamond'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object RzPanel36: TRzPanel
      Left = 11
      Top = 83
      Width = 662
      Height = 350
      BorderInner = fsFlatRounded
      BorderOuter = fsFlatRounded
      Color = 52479
      TabOrder = 0
      object TutorialTab: TRzTabControl
        Left = 8
        Top = 8
        Width = 641
        Height = 337
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        ParentFont = False
        TabIndex = 0
        TabOrder = 0
        TabOrientation = toBottom
        Tabs = <
          item
            Caption = 'Welcome'
          end
          item
            Caption = 'Posisi'
          end
          item
            Caption = 'User'
          end
          item
            Caption = 'Date'
          end
          item
            Caption = 'Finish'
          end>
        TabStyle = tsCutCorner
        OnChange = TutorialTabChange
        FixedDimension = 25
        object TutorialGrpPosisi: TRzGroupBox
          Left = 8
          Top = 0
          Width = 633
          Height = 273
          Caption = 'Install sebagai Cabang atau Pusat ?'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Georgia'
          Font.Style = [fsBold]
          GroupStyle = gsUnderline
          ParentFont = False
          TabOrder = 4
          Transparent = True
          object Label1: TLabel
            Left = 56
            Top = 80
            Width = 51
            Height = 18
            Caption = 'Pilihan '
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object RzMemo4: TRzMemo
            Left = 11
            Top = 32
            Width = 614
            Height = 50
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 52479
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            Lines.Strings = (
              'Apakah program ini akan diinstall di Pusat atau di Cabang. '
              'Untuk versi Basic hanya tersedia versi Pusat saja.')
            ParentFont = False
            TabOrder = 0
          end
          object TutorialTxtSetCabang: TRzComboBox
            Left = 168
            Top = 77
            Width = 145
            Height = 24
            Style = csDropDownList
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = []
            ItemHeight = 16
            ParentFont = False
            TabOrder = 1
            Text = 'Pusat'
            OnChange = TutorialTxtSetCabangChange
            Items.Strings = (
              'Pusat'
              'Cabang')
            ItemIndex = 0
          end
          object TutorialSubGrpPosisi: TRzGroupBox
            Left = 48
            Top = 112
            Width = 425
            Height = 153
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            GroupStyle = gsUnderline
            ParentFont = False
            TabOrder = 2
            Transparent = True
            Visible = False
            object Label3: TLabel
              Left = 8
              Top = 11
              Width = 88
              Height = 18
              Caption = 'Kode Cabang'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label2: TLabel
              Left = 8
              Top = 35
              Width = 101
              Height = 18
              Caption = 'Nama Cabang '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label4: TLabel
              Left = 8
              Top = 59
              Width = 108
              Height = 18
              Caption = 'Alamat Cabang '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label5: TLabel
              Left = 8
              Top = 83
              Width = 90
              Height = 18
              Caption = 'Kota Cabang '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label6: TLabel
              Left = 8
              Top = 107
              Width = 158
              Height = 18
              Caption = 'Database MAC  Address'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object TutorialTxtSetNamaCabang: TRzEdit
              Left = 120
              Top = 31
              Width = 289
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object TutorialTxtSetKodeCabang: TRzEdit
              Left = 120
              Top = 6
              Width = 143
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object TutorialTxtSetAlmCabang: TRzEdit
              Left = 120
              Top = 55
              Width = 289
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object TutorialTxtSetKotaCabang: TRzEdit
              Left = 120
              Top = 79
              Width = 289
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
            end
            object TutorialTxtSetMAC: TRzEdit
              Left = 176
              Top = 103
              Width = 233
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Georgia'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
            end
          end
        end
        object TutorialGrpUser: TRzGroupBox
          Left = 8
          Top = 0
          Width = 633
          Height = 281
          Caption = 'Konfigurasi User'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Georgia'
          Font.Style = [fsBold]
          GroupStyle = gsUnderline
          ParentFont = False
          TabOrder = 1
          Transparent = True
          object RzLabel137: TRzLabel
            Left = 49
            Top = 90
            Width = 42
            Height = 16
            Alignment = taCenter
            Caption = 'Nama'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object RzLabel143: TRzLabel
            Left = 49
            Top = 114
            Width = 68
            Height = 16
            Alignment = taCenter
            Caption = 'Password'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object RzLabel2: TRzLabel
            Left = 49
            Top = 139
            Width = 81
            Height = 16
            Alignment = taCenter
            Caption = 'Konfirmasi'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object RzLabel3: TRzLabel
            Left = 49
            Top = 163
            Width = 46
            Height = 16
            Alignment = taCenter
            Caption = 'Group'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object RzMemo2: TRzMemo
            Left = 11
            Top = 40
            Width = 614
            Height = 41
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 52479
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            Lines.Strings = (
              
                'Untuk memulai pekerjaan kita membutuhkan user silahkan buat user' +
                ' yang akan bertindak '
              'sebagai administrator (penanggung jawab) program ini')
            ParentFont = False
            TabOrder = 0
          end
          object TutorialTxtNama: TRzEdit
            Left = 168
            Top = 87
            Width = 241
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object TutorialTxtPass: TRzEdit
            Left = 168
            Top = 111
            Width = 241
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            PasswordChar = '*'
            TabOrder = 2
          end
          object TutorialTxtKonfirm: TRzEdit
            Left = 168
            Top = 135
            Width = 241
            Height = 24
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            PasswordChar = '*'
            TabOrder = 3
          end
          object RzEdit1: TRzEdit
            Left = 168
            Top = 159
            Width = 241
            Height = 24
            Text = 'Administrator'
            DisabledColor = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
        end
        object TutorialGrpDate: TRzGroupBox
          Left = 8
          Top = 0
          Width = 633
          Height = 281
          Caption = 'Konfigurasi Tanggal Kerja'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Georgia'
          Font.Style = [fsBold]
          GroupStyle = gsUnderline
          ParentFont = False
          TabOrder = 2
          Transparent = True
          object RzLabel4: TRzLabel
            Left = 49
            Top = 90
            Width = 61
            Height = 16
            Alignment = taCenter
            Caption = 'Tanggal '
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Georgia'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object RzMemo3: TRzMemo
            Left = 11
            Top = 40
            Width = 614
            Height = 41
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 52479
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            Lines.Strings = (
              
                'Silahkan tetapkan tanggal kerja untuk membatasi user dengan hak ' +
                'lebih rendah supaya '
              'tidak menginput transaksi diluar tanggal yang ditetapkan')
            ParentFont = False
            TabOrder = 0
          end
          object TutorialTxtSetDate: TRzDateTimeEdit
            Left = 116
            Top = 87
            Width = 197
            Height = 24
            EditType = etDate
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object TutorialGrpFinish: TRzGroupBox
          Left = 8
          Top = 1
          Width = 633
          Height = 281
          Caption = 'Selamat Anda sudah menyelesaikan setting awal'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Georgia'
          Font.Style = [fsBold]
          GroupStyle = gsUnderline
          ParentFont = False
          TabOrder = 3
          Transparent = True
          object TutorialMemoFinish: TRzMemo
            Left = 11
            Top = 32
            Width = 614
            Height = 225
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 52479
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            Lines.Strings = (
              'Ini adalah setting awal anda. Mohon dicek kembali. '
              '    '
              '    Nama '
              '    Pass'
              '    Tanggal Awal'
              '    Posisi'#9
              ''
              
                'Tekan tombol Finish maka anda akan dibawa ke layar login dimana ' +
                'anda dapat login '
              'untuk mengatur program dengan lebih detail lagi.'
              '')
            ParentFont = False
            TabOrder = 0
          end
        end
        object TutorialGrpWelcome: TRzGroupBox
          Left = 8
          Top = 0
          Width = 633
          Height = 273
          Caption = 'Selamat Datang !'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Georgia'
          Font.Style = [fsBold]
          GroupStyle = gsUnderline
          ParentFont = False
          TabOrder = 0
          Transparent = True
          object RzMemo1: TRzMemo
            Left = 11
            Top = 40
            Width = 614
            Height = 225
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 52479
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Georgia'
            Font.Style = []
            Lines.Strings = (
              
                'Terima kasih atas kepercayaan anda untuk menggunakan software ka' +
                'mi.'
              
                'Untuk proses pertama kali kami akan memandu dalam penggunaan pro' +
                'gram ini.'
              'Tekan Tombol Berikut untuk melanjutkan.')
            ParentFont = False
            TabOrder = 0
          end
        end
      end
      object TutorialBtnNext: TAdvSmoothButton
        Left = 559
        Top = 280
        Width = 82
        Height = 33
        Cursor = crHandPoint
        Caption = 'Berikut'
        Color = clGreen
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        TabOrder = 1
        Version = '1.0.0.0'
        OnClick = TutorialBtnNextClick
      end
      object TutorialBtnPrevious: TAdvSmoothButton
        Left = 473
        Top = 280
        Width = 82
        Height = 33
        Cursor = crHandPoint
        Caption = 'Sebelum'
        Color = clGreen
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        TabOrder = 2
        Version = '1.0.0.0'
        OnClick = TutorialBtnPreviousClick
      end
    end
  end
end
