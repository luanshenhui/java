import React from 'react';
import { Link } from 'react-router-dom';
import SectionBar from '../../components/SectionBar';
import MenuItem from '../../components/MenuItem';

import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="印刷・ダウンロードメニュー">
    <SectionBar title="健診準備処理" />
    <ul>
      <li><Link to="/contents/report/afterpostcard">一年目はがき </Link></li>
      <li><Link to="/contents/report/invitation">一括送付案内 </Link></li>
      <li><Link to="/contents/report/instructionlist">ご案内書送付チェックリスト </Link></li>
      <li><Link to="/contents/report/checkdoubleid">２重ＩＤ登録チェックリスト </Link></li>
      <li><Link to="/contents/report/patientlist">新患登録リスト </Link></li>
      <li><Link to="/contents/report/absenceliststudy">事前チャートスタディ用受診者リストCSV出力 </Link></li>
      <li><Link to="/contents/report/nameband">ネームバンド印刷</Link></li>
    </ul>
    <SectionBar title="当日処理" />
    <ul>
      <li><Link to="/contents/report/reservelist">予約者一覧表 </Link></li>
      <li><Link to="/contents/report/consultcheck">受診予定者チェックシート </Link></li>
      <li><Link to="/contents/report/endoscopelist">内視鏡受付一覧 </Link></li>
      <li><Link to="/contents/report/endoscopedisinfection">内視鏡洗浄消毒履歴 </Link></li>
      <li><Link to="/contents/report/nursecheck">ナースチェックリスト </Link></li>
      <li><Link to="/contents/report/worksheetcheck">ワークシート８項目 </Link></li>
      <li><Link to="/contents/report/payment">入金ジャーナル・入金台帳 </Link></li>
      <li><Link to="/contents/report/worksheetptn">ワークシート個人票チェックリスト </Link></li>
      <li><Link to="/contents/report/patient">個人票 </Link></li>
      <li><Link to="/contents/report/womanlist">女性受診者リスト </Link></li>
      <li><Link to="/contents/report/speciallist">特定健診受診者リスト </Link></li>
      <li><Link to="/contents/report/followlist">フォローアップ対象者リスト </Link></li>
    </ul>
    <SectionBar title="健診結果関連" />
    <ul>
      <li><Link to="/contents/report/worksheetlast">ワークシート前回値参照(血清) </Link></li>
      <li><Link to="/contents/report/endoscopecheck2">内視鏡チェックシート </Link></li>
      <li><Link to="/contents/report/warninglistnew">個人異常値リスト </Link></li>
      <li><Link to="/contents/report/report6">成績書 </Link></li>
      <li><Link to="/contents/report/reportchecklist">成績表チェックリスト </Link></li>
      <li><Link to="/contents/report/postlist">郵便物受領書 </Link></li>
    </ul>
    <SectionBar title="後日処理" />
    <ul>
      <li><Link to="/contents/report/receivable">未収金 </Link></li>
      <li><Link to="/contents/report/orgbill">請求書 </Link></li>
      <li><Link to="/contents/report/billcheck">請求書チェックリスト </Link></li>
      <li><Link to="/contents/report/billrepcheck">請求書チェックリスト（成績書） </Link></li>
      <li><Link to="/contents/report/paymentlist">団体入金台帳 </Link></li>
      <li><Link to="/contents/report/orgarrears">未収団体一覧 </Link></li>
      <li><Link to="/contents/report/directmail">団体ダイレクトメール </Link></li>
      <li><Link to="/contents/report/absencelistjudcnt">総合判定別人数CSV出力 </Link></li>
      <li><Link to="/contents/report/absencelistjud">団体別判定結果CSV出力 </Link></li>
      <li><Link to="/contents/report/absencelistbasic">団体別受診者（健診基本情報）CSV </Link></li>
      <li><Link to="/contents/report/spexmldata">特定健診ＸＭＬ作成</Link></li>
      <li><Link to="/contents/report/absencelistnttdata">聖路加フォーマット健診結果CSV出力（ＮＴＴデータ形式）④ </Link></li>
      <li><Link to="/contents/report/absencelistken">団体健診金額CSV出力 </Link></li>
      <li><Link to="/contents/report/absencelistresi">聖路加レジデンス提供用CSV出力 </Link></li>
    </ul>
    <SectionBar title="団体契約関連" />
    <ul>
      <li><Link to="/contents/report/companyconduct">契約団体調査票</Link></li>
      <li><Link to="/contents/report/absencecompany">団体別契約セット情報CSV出力</Link></li>
    </ul>
    <SectionBar title="データ抽出" />
    <ul>
      <MenuItem
        title="結果、判定抽出"
        link="/contents/report/csvdatconsult"
        description="指定した日付、検査結果値などからデータをCSV形式で抽出します。"
        image=""
      />
      <MenuItem
        title="個人情報"
        link="/contents/report/personcsv"
        description="登録されている個人情報をCSV形式で出力します。"
        image=""
      />
      <MenuItem
        title="団体情報"
        link="/contents/report/organizationcsv"
        description="登録されている団体情報をCSV形式で出力します。"
        image=""
      />
      <MenuItem
        title="個人明細別請求情報抽出"
        link="/contents/report/cslmoneylist"
        description="受診期間もしくは締め日などから、対象となる個人毎項目毎の金額明細を抽出します。"
        image=""
      />
      <MenuItem
        title="未請求受診情報一覧"
        link="/contents/report/billconsultlist"
        description="請求書を作成されていない受診者の情報を取得します。請求済みデータも抽出可能です。"
        image=""
      />
      <MenuItem
        title="請求書明細情報抽出"
        link="/contents/report/billdetaillist"
        description="作成済み請求書情報の詳細情報を抽出します。"
        image=""
      />
      <MenuItem
        title="請求書情報抽出（ＣＯＭＰＡＮＹ連携用）"
        link="/contents/report/absencelistbill"
        description="経理システム（ＣＯＭＰＡＮＹ）連携用請求書情報を抽出します。"
        image=""
      />
      <MenuItem
        title="請求明細情報抽出（三井物産健保フォーマット）"
        link="/contents/report/absenceorgbill"
        description="三井物産健保フォーマットの請求明細情報を抽出します。"
        image=""
      />
    </ul>
    <SectionBar title="統計関連" />
    <ul>
      <li><Link to="/contents/report/aneiho">労働基準監督署統計</Link></li>
    </ul>
    <SectionBar title="台帳関連" />
    <ul>
      <li><Link to="/contents/report/accountbook">会計台帳</Link></li>
    </ul>
    <SectionBar title="印刷ログ" />
    <ul>
      <li><Link to="/contents/report/reportLog">印刷ログ</Link></li>
    </ul>
  </PageLayout>
);

export default Menu;
