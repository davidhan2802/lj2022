object Frmreport: TFrmreport
  Left = 175
  Top = 155
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Frmreport'
  ClientHeight = 725
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_choosereport: TRzPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 57
    Align = alTop
    TabOrder = 0
    VisualStyle = vsGradient
    object RzLabel1: TRzLabel
      Left = 8
      Top = 16
      Width = 74
      Height = 19
      Caption = 'Pilih Report'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object lbl_periode: TRzLabel
      Left = 441
      Top = 14
      Width = 46
      Height = 19
      Caption = 'Periode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object lbl_sd: TRzLabel
      Left = 642
      Top = 13
      Width = 21
      Height = 19
      Caption = 's/d'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object cbreport: TRzComboBox
      Left = 96
      Top = 14
      Width = 313
      Height = 26
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FlatButtons = True
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = 'BUKTI MASUK BARANG'
      OnChange = cbreportChange
      Items.Strings = (
        'BUKTI MASUK BARANG'
        'BUKTI PENGAMBILAN BARANG'
        'STOCK OPNAME'
        'PRODUCT URAI'
        'MUTASI STOCK'
        'STOCK PER TANGGAL'
        'PEMBELIAN'
        'PEMBELIAN PEMBAYARAN'
        'SUPPLIER'
        'PENJUALAN'
        'CUSTOMER'
        'PENJUALAN PEMBAYARAN'
        'ITEM')
    end
    object DT_Start: TRzDateTimeEdit
      Left = 504
      Top = 11
      Width = 129
      Height = 26
      EditType = etTime
      Format = 'dd/mm/yyyy'
      FlatButtons = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ParentFont = False
      TabOrder = 1
    end
    object DT_End: TRzDateTimeEdit
      Left = 672
      Top = 11
      Width = 129
      Height = 26
      EditType = etDate
      Format = 'dd/mm/yyyy'
      FlatButtons = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnl_AccessReport: TRzPanel
    Left = 0
    Top = 57
    Width = 817
    Height = 48
    Align = alTop
    BorderOuter = fsLowered
    TabOrder = 1
    VisualStyle = vsClassic
    object RzBitBtn1: TRzBitBtn
      Left = 152
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Zoom In'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = RzBitBtn1Click
      ImageIndex = 27
      Images = DM.ImageList2
    end
    object RzBitBtn2: TRzBitBtn
      Left = 278
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Zoom Out'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = RzBitBtn2Click
      ImageIndex = 28
      Images = DM.ImageList2
    end
    object RzBitBtn3: TRzBitBtn
      Left = 338
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Ke Hal Awal'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = RzBitBtn3Click
      ImageIndex = 19
      Images = DM.ImageList2
    end
    object RzBitBtn4: TRzBitBtn
      Left = 384
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Ke Hal Sebelumnya'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = RzBitBtn4Click
      ImageIndex = 17
      Images = DM.ImageList2
    end
    object RzBitBtn5: TRzBitBtn
      Left = 486
      Top = 4
      Width = 45
      Height = 40
      Hint = 'Ke Hal Sesudahnya'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = RzBitBtn5Click
      ImageIndex = 16
      Images = DM.ImageList2
    end
    object RzBitBtn6: TRzBitBtn
      Left = 532
      Top = 4
      Width = 45
      Height = 40
      Hint = 'Ke Hal. Akhir'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = RzBitBtn6Click
      ImageIndex = 18
      Images = DM.ImageList2
    end
    object edtPageNum: TRzEdit
      Left = 431
      Top = 6
      Width = 54
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ParentFont = False
      TabOrder = 6
    end
    object RzBitBtn8: TRzBitBtn
      Left = 5
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Save as EXCELL'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = RzBitBtn8Click
      ImageIndex = 35
      Images = DM.ImageList2
    end
    object EdtZoom: TRzEdit
      Left = 197
      Top = 6
      Width = 81
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ParentFont = False
      TabOrder = 8
    end
    object RzBitBtn9: TRzBitBtn
      Left = 97
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Cetak'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = RzBitBtn9Click
      ImageIndex = 13
      Images = DM.ImageList2
    end
    object pnl_preview: TRzPanel
      Left = 584
      Top = 2
      Width = 231
      Height = 44
      Align = alRight
      BorderOuter = fsNone
      BorderSides = []
      TabOrder = 10
      Transparent = True
      VisualStyle = vsGradient
      DesignSize = (
        231
        44)
      object BTNPREVIEW: TRzBitBtn
        Left = 19
        Top = 2
        Width = 92
        Height = 40
        FrameColor = 7617536
        Anchors = [akTop, akRight]
        Caption = '&Preview'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        HotTrack = True
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        OnClick = BTNPREVIEWClick
        ImageIndex = 26
        Images = DM.ImageList2
      end
      object btn_filtering: TRzBitBtn
        Left = 123
        Top = 2
        Width = 92
        Height = 40
        FrameColor = 7617536
        Anchors = [akTop, akRight]
        Caption = '&Filtering'
        Color = 16759260
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        HotTrack = True
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = btn_filteringClick
        ImageIndex = 10
        Images = DM.ImageList2
      end
    end
    object RzBitBtn10: TRzBitBtn
      Left = 51
      Top = 5
      Width = 45
      Height = 40
      Hint = 'Save as TEXT'
      FrameColor = 7617536
      Color = 15791348
      HotTrack = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = RzBitBtn10Click
      ImageIndex = 37
      Images = DM.ImageList2
    end
  end
  object frxPreview1: TfrxPreview
    Left = 0
    Top = 105
    Width = 817
    Height = 620
    Align = alClient
    OutlineVisible = True
    OutlineWidth = 0
    ThumbnailVisible = False
    OnPageChanged = frxPreview1PageChanged
    UseReportHints = True
  end
  object GB_Filter: TRzGroupBox
    Left = 352
    Top = 112
    Width = 457
    Height = 177
    BevelWidth = 2
    BorderColor = clBlack
    BorderInner = fsRaised
    BorderWidth = 3
    Caption = 'Filter Condition'
    Color = 9619913
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Comic Sans MS'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    VisualStyle = vsClassic
    DesignSize = (
      455
      175)
    object RzLabel4: TRzLabel
      Left = 16
      Top = 32
      Width = 45
      Height = 19
      Caption = 'Gudang'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object RzLabel5: TRzLabel
      Left = 16
      Top = 97
      Width = 48
      Height = 19
      Caption = 'Product'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object RzLabel6: TRzLabel
      Left = 16
      Top = 65
      Width = 57
      Height = 19
      Caption = 'Kelompok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      BlinkIntervalOff = 2000
      BlinkIntervalOn = 1000
    end
    object cb_gudang: TRzComboBox
      Left = 80
      Top = 29
      Width = 321
      Height = 26
      Color = clInfoBk
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
    object cb_kode: TRzComboBox
      Left = 80
      Top = 93
      Width = 105
      Height = 26
      Color = clInfoBk
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnChange = cb_kodeChange
    end
    object cb_nama: TRzComboBox
      Left = 184
      Top = 93
      Width = 257
      Height = 26
      Color = clInfoBk
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      OnChange = cb_namaChange
    end
    object cb_nama_group: TRzComboBox
      Left = 184
      Top = 61
      Width = 257
      Height = 26
      Color = clInfoBk
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
    end
    object cb_kode_group: TRzComboBox
      Left = 80
      Top = 61
      Width = 105
      Height = 26
      Color = clInfoBk
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Book Antiqua'
      Font.Style = [fsBold]
      FrameColor = clNavy
      FrameVisible = True
      ItemHeight = 18
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
    end
    object RzBitBtn7: TRzBitBtn
      Left = 348
      Top = 131
      Width = 92
      Height = 40
      FrameColor = 7617536
      Anchors = [akTop, akRight]
      Caption = '&Tutup'
      Color = 10329599
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HotTrack = True
      ParentFont = False
      TabOrder = 5
      OnClick = RzBitBtn7Click
      ImageIndex = 33
      Images = DM.ImageList2
    end
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 160
    Top = 152
  end
  object frxSimpleTextExport1: TfrxSimpleTextExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Frames = False
    EmptyLines = False
    OEMCodepage = False
    Left = 224
    Top = 200
  end
end
