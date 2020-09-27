// 個人受診用の団体コード1, 2
export const ORGCD1_PERSON = 'XXXXX';
export const ORGCD2_PERSON = 'XXXXX';

// web予約用の団体コード1, 2
export const ORGCD1_WEB = 'WWWWW';
export const ORGCD2_WEB = 'WWWWW';

// 結果入力印刷ボタン表示文字列
export const isPrintButton = {
  // 超音波検査表
  echo: {
    value: 1,
    name: '超音波検査表印刷ボタン表示',
  },
  // 口腔疾患検査結果表
  oralExamination: {
    value: 2,
    name: '口腔疾患検査結果表印刷ボタン表示',
  },
};

// グループ区分
export const grpdiv = {
  // 依頼項目
  grpR: 1,
  // 検査項目
  grpI: 2,
};

// 性別
export const Gender = {
  Male: 1,
  Female: 2,
};

// 汎用コード
export const FreeCd = {
  Cancel: 'CANCEL',
  Chgsetgrp: 'CHGSETGRP',
};

// 時間枠:終日（時間枠管理しない）
export const TIME_FRA_NON = 0;
// 休診日:未設定
export const HOLIDAY_NON = 0;
// 休診日:休診日
export const HOLIDAY_CLS = 1;
// 休診日:祝日
export const HOLIDAY_HOL = 2;

// 有効年の規定値
export const YEARRANGE_MIN = 1970;
export const YEARRANGE_MAX = 2200;

// 個人検査結果情報の検査日
export const DATERANGE_MIN = '1970/01/01';
export const DATERANGE_MAX = '2200/12/31';

// 個人検査結果情報の定性ガイド表示
export const RESULTTYPE_TEISEI1 = 1;
export const RESULTTYPE_TEISEI2 = 2;

// 個人検査結果情報の文章ガイド表示
export const RESULTTYPE_SENTENCE = 4;

// 個人検査結果情報は計算結果の場合
export const RESULTTYPE_CALC = 5;

// 個人負担
export const APDIV_PERSON = 0;
// 自社負担
export const APDIV_MYORG = 1;
// 指定団体負担
export const APDIV_ORG = 2;

// 処理モード(複写)
export const OPMODE_BROWSE = 'browse';
// 処理モード(コピー)
export const OPMODE_COPY = 'copy';

// 汎用マスタの設定がない場合用
export const CHECK_CSLDATE2 = '2010/01/01';

// 変更日付取得用
export const FREECLASSCD_CHG = 'CHG';

// 負担金額
export const LENGTH_CTRPT_PRICE_PRICE = 7;

// web予約情報登録用
// '本登録フラグ(未登録者)
export const REGFLG_UNREGIST = '1';
// '本登録フラグ(編集済み受診者)
export const REGFLG_REGIST = '2';

// デフォルト表示行数
export const DEFAULT_ROW = 5;

// 表示行数の増分単位
export const INCREASE_COUNT = 5;

// 性別名称の配列
export const genderName = ['男性', '女性'];

// 指定対象受診者の検査結果歴を取得(グループコード)
export const GRPCD = 'X026';

// 指定対象受診者の検査結果歴を取得(表示歴数)
export const HISCOUNT = '1';

// 指定対象受診者の検査結果歴を取得(前回歴表示モード)
export const LAST_DSP_MODE = 1;
export const LAST_DSP_MODE_ZERO = 0;

// 指定対象受診者の検査結果歴を取得(取得順)
export const GETSEQMODE = 0;

// 指定対象受診者の検査結果歴を取得(全件取得モード)
export const ALLDATAMODE = 1;

// 処理モード
// 挿入
export const MODE_INSERT = 'INS';
// 更新
export const MODE_UPDATE = 'UPD';
// コピー
export const MODE_COPY = 'COPY';

// 表示タイプ１
export const INTERVIEWRESULT_TYPE1 = 1;
// 表示タイプ２
export const INTERVIEWRESULT_TYPE2 = 2;
// 表示タイプ３
export const INTERVIEWRESULT_TYPE3 = 3;
// 参照モード
export const INTERVIEWRESULT_REFER = 0;
// 更新モード
export const INTERVIEWRESULT_ENTRY = 1;

// 年齢(契約パターンオプション管理・基準値詳細)
// 最小値
export const AGE_MINVALUE = 0;
// 最大値
export const AGE_MAXVALUE = 999;

// 日曜日
export const VBSUNDAY = 1;
// 土曜日
export const VBSATURDAY = 7;

// 受診情報使用中フラグ - 使用中
export const CONSULT_USED = 0;

// チャート情報ノート分類コード
export const CHART_NOTEDIV = '500';
// 注意事項ノート分類コード
export const CAUTION_NOTEDIV = '100';

// 特定健診専用面接用
// 保健指導レベルグループコード
export const GRPCD_LEVEL = 'X090';

// 特定保健指導(検査項目コード)
export const GUIDANCE_ITEMCD = '64074';
// 特定保健指導(サフィックス)
export const GUIDANCE_SUFFIX = '00';

// 表示分類：特定健診
export const DISPMODE_SPADVICE = 5;

// 階層化コメントを取得(表示分類)
export const DISP_MODE = 5;

// オプションコードの項目長
export const LENGTH_OPTCD = 4;
// オプション枝番の項目長
export const LENGTH_OPTBRANCHNO = 2;
// オプション名の項目長
export const LENGTH_OPTNAME = 30;
// オプション略称の項目長
export const LENGTH_OPTSNAME = 20;

// 食習慣コメントを取得(表示分類)
export const DISPMODE_FOODADVICE = 3;
// 201210食習慣コメントを取得(表示分類)
export const DISPMODE_FOODADVICE201210 = 6;
// 献立コメントを取得(表示分類)
export const DISPMODE_MENUADVICE = 4;

// 2012年対応変更日付取得用
export const FREECD_CHG201210 = 'CHG201210';

export const RECENTCONSULT_RANGE_OF_MONTH = 3;

// カレンダー検索ガイド日付状態
export const RsvCalendarGuideStatus = {
  // 過去・強制予約可能
  Past: '0',
  // 空きあり
  Normal: '1',
  // オーバだが予約可能
  Over: '2',
  // 空きなし・強制予約可能
  Full: '3',
  // 枠なし・枠なし強制予約なら可能
  NoRsvfra: '4',
  // 契約なし・予約不能
  NoContract: '5',
  // セット差異あり・予約不能
  DifferSet: '6',
};

// 結果問診フラグ検査結果
export const RSLQUE_R = 0;
// 結果問診フラグ問診結果
export const RSLQUE_Q = 1;

// 受診情報予約番号
export const LENGTH_CONSULT_RSVNO = 9;

// 当日ID
export const LENGTH_RECEIPT_DAYID = 4;

// 内視鏡チェックリスト入力画面切替受診日
export const CHANGE_CSLDATE = '2016/06/13';
// 内視鏡チェックリスト入力グループコード
export const GRPCD_NAISHIKYOU = 'X024';
// 内視鏡チェックリスト入力グループコード
export const GRPCD_NAISHIKYOU_NEW = 'X0241';

// ベセスダ分類
export const ITEM_BETHESDA = '27050';
// ＨＰＶ
export const ITEM_HPV = '59510';
// 乳房Ｘ線カテゴリー
export const ITEM_MMG_CATE = '27770';
// 乳房超音波カテゴリー
export const ITEM_BECHO_CATE = '28700';
// 乳房超音波所見
export const ITEM_BECHO_OBS = '28820';
// 乳房触診
export const ITEM_BREAST_PAL = '27520';

export const OcrNyuryokuBody = {
  // OcrNyuryokuSpBody201210取得した検査結果の先頭位置[0～]
  OcrNyuryokuSpBody201210: {
    GRPCD_OCRNYURYOKU2: 'X0342', // OCR入力結果確認グループコード
    GRPCD_ALLERGY: 'X052', // 薬アレルギーグループコード
    OCRGRP_START1: 0, // 現病歴既往歴
    OCRGRP_START2: 90, // 生活習慣問診１
    OCRGRP_START3: 137, // 生活習慣問診２
    OCRGRP_START4: 159, // 婦人科問診
    OCRGRP_START5: 273, // 食習慣問診
    OCRGRP_START9: 295, // 特定健診
    OCRGRP_START10: 297, // OCR入力担当者
    OCRGRP_START_Z: 298, // 前コード用 前回値出力用(一部の項目)
    NOWDISEASE_COUNT: 6, // 現病歴の件数
    DISEASEHIST_COUNT: 6, // 既往歴の件数
    FAMILYHIST_COUNT: 6, // 家族歴の件数
    JIKAKUSHOUJYOU_COUNT: 6, // 自覚症状の件数
  },
  // OcrNyuryokuBody取得した検査結果の先頭位置[0～]
  OcrNyuryokuBody: {
    GRPCD_OCRNYURYOKU: 'X023', // OCR入力結果確認グループコード
    GRPCD_ALLERGY: 'X052', // 薬アレルギーグループコード
    OCRGRP_START1: 0, // 現病歴既往歴
    OCRGRP_START2: 86, // 生活習慣問診１
    OCRGRP_START3: 149, // 生活習慣問診２
    OCRGRP_START4: 174, // 婦人科問診
    OCRGRP_START5: 239, // 食習慣問診
    OCRGRP_START6: 275, // 朝食
    OCRGRP_START7: 358, // 昼食
    OCRGRP_START8: 441, // 夕食
    OCRGRP_START9: 524, // OCR入力担当者
    NOWDISEASE_COUNT: 6, // 現病歴の件数
    DISEASEHIST_COUNT: 6, // 既往歴の件数
    FAMILYHIST_COUNT: 6, // 家族歴の件数
    JIKAKUSHOUJYOU_COUNT: 6, // 自覚症状の件数
  },
  // OcrNyuryokuSpBody取得した検査結果の先頭位置[0～]
  OcrNyuryokuSpBody: {
    GRPCD_OCRNYURYOKU: 'X034', // OCR入力結果確認グループコード
    GRPCD_ALLERGY: 'X052', // 薬アレルギーグループコード
    OCRGRP_START1: 0, // 現病歴既往歴
    OCRGRP_START2: 86, // 生活習慣問診１
    OCRGRP_START3: 149, // 生活習慣問診２
    OCRGRP_START4: 174, // 婦人科問診
    OCRGRP_START5: 239, // 食習慣問診
    OCRGRP_START6: 275, // 朝食
    OCRGRP_START7: 358, // 昼食
    OCRGRP_START8: 441, // 夕食
    OCRGRP_START9: 524, // 特定健診
    OCRGRP_START10: 526, // OCR入力担当者
    NOWDISEASE_COUNT: 6, // 現病歴の件数
    DISEASEHIST_COUNT: 6, // 既往歴の件数
    FAMILYHIST_COUNT: 6, // 家族歴の件数
    JIKAKUSHOUJYOU_COUNT: 6, // 自覚症状の件数
  },
  // OcrNyuryokuSpBody2取得した検査結果の先頭位置[0～]
  OcrNyuryokuSpBody2: {
    GRPCD_OCRNYURYOKU2: 'X0341', // OCR入力結果確認グループコード
    GRPCD_ALLERGY: 'X052', // 薬アレルギーグループコード
    OCRGRP_START1: 0, // 現病歴既往歴
    OCRGRP_START2: 90, // 生活習慣問診１
    OCRGRP_START3: 151, // 生活習慣問診２
    OCRGRP_START4: 176, // 婦人科問診
    OCRGRP_START5: 290, // 食習慣問診
    OCRGRP_START6: 326, // 朝食
    OCRGRP_START7: 409, // 昼食
    OCRGRP_START8: 492, // 夕食
    OCRGRP_START9: 575, // 特定健診
    OCRGRP_START10: 577, // OCR入力担当者
    OCRGRP_START_Z: 578, // 前コード用 前回値出力用(一部の項目)
    NOWDISEASE_COUNT: 6, // 現病歴の件数
    DISEASEHIST_COUNT: 6, // 既往歴の件数
    FAMILYHIST_COUNT: 6, // 家族歴の件数
    JIKAKUSHOUJYOU_COUNT: 6, // 自覚症状の件数
  },
};

// OcrNyuryokuSpBody2取得した検査結果の先頭位置[0～]
// 現病歴既往歴
export const OCRGRP_SP2_START1 = 0;
// 生活習慣問診１
export const OCRGRP_SP2_START2 = 90;
// 生活習慣問診２
export const OCRGRP_SP2_START3 = 151;
// 婦人科問診
export const OCRGRP_SP2_START4 = 176;
// 食習慣問診
export const OCRGRP_SP2_START5 = 290;
// 朝食
export const OCRGRP_SP2_START6 = 326;
// 昼食
export const OCRGRP_SP2_START7 = 409;
// 夕食
export const OCRGRP_SP2_START8 = 492;
// 特定健診
export const OCRGRP_SP2_START9 = 575;
// OCR入力担当者
export const OCRGRP_SP2_START10 = 577;
// 前コード用、前回値出力用(一部の項目)
export const OCRGRP_SP2_START_Z = 578;

// 問診情報確認画面切替基準日
export const CHECK_CSLDATE = '2008/04/01';
// 問診情報確認画面切替基準コースコード（1日人間ドック）
export const CHECK_CSCD = '100';
// 問診情報確認画面切替基準コースコード（職員定期健康診断（ドック））
export const CHECK_CSCD_COMP = '105';

// リストボックスの数
// 現病歴の件数
export const NOWDISEASE_COUNT = 6;
// 既往歴の件数
export const DISEASEHIST_COUNT = 6;
// 家族歴の件数
export const FAMILYHIST_COUNT = 6;
// 自覚症状の件数
export const JIKAKUSHOUJYOU_COUNT = 6;
