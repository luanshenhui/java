/**
 * @file 特定健診ＸＭＬ出力
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// チェックボックス
import CheckBox from '../../components/control/CheckBox';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// 団体グループ
import DropDownOrgGrpP from '../../components/control/dropdown/DropDownOrgGrpP';

// 健診コース区分
import DropDownCourseDiv from '../../components/control/dropdown/DropDownCourseDiv';

// 受診区分
import DropDownCslDiv from '../../components/control/dropdown/DropDownFreeValue';

// 請求書出力区分
import DropDownBillPrint from '../../components/control/dropdown/DropDownBillPrint';

// カスタムドロップダウン
import DropDownCustom from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '特定健診ＸＭＬ出力';

// 初期値の設定
const initialValues = {
  // 受診日
  strcsldate: moment().format('YYYY/MM/DD'),
  endcsldate: moment().format('YYYY/MM/DD'),
  // 出力項目区分(JLAC10CONV CONVPT)
  spitem: '2',
  // シーケンス
  seq: '0',
  // ファイル名
  fileName: 'SpeXmlData.zip',
};

// 出力項目区分
const spitemkbn = [
  { name: '特定健診項目', value: 1 },
  { name: '聖路加指定項目', value: 2 },
  { name: '聖路加指定項目 + 一部オプション検査項目', value: 3 },  
];

// フォーム名
const formName = 'speXMLdataForm';

// 特定健診ＸＭＬ出力レイアウト
const speXMLdata = (props) => (
<div>
  { /* 受診日 */}
  <ReportParameter label="受診日" isRequired>
    <Field name="strcsldate" component={DatePicker} />
    <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
    <Field name="endcsldate" component={DatePicker} />
  </ReportParameter>

  { /* 団体１～５ */}
  <div style={{ paddingTop: 15 }}>
    <ReportParameter label="団体１">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd12" orgNameField="orgname1" />
    </ReportParameter>
  </div>
  <ReportParameter label="団体２">
    <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd21" orgCd2Field="orgcd22" orgNameField="orgName2" />
  </ReportParameter>
  <ReportParameter label="団体３">
    <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd31" orgCd2Field="orgcd32" orgNameField="orgName3" />
  </ReportParameter>
  <ReportParameter label="団体４">
    <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd41" orgCd2Field="orgcd42" orgNameField="orgName4" />
  </ReportParameter>
  <ReportParameter label="団体５">
    <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd51" orgCd2Field="orgcd52" orgNameField="orgName5" />
  </ReportParameter>

  { /* 団体グループ */}
  <div style={{ paddingTop: 5 }}>
    <ReportParameter label="団体グループ">
      <Field name="orggrpcd" component={DropDownOrgGrpP} addblank />
    </ReportParameter>
  </div>

  { /* 健診コース区分 */}
  <div style={{ paddingTop: 15 }}>
    <ReportParameter label="健診コース区分">
      <Field name="coursecd" component={DropDownCourseDiv} addblank />
    </ReportParameter>
  </div>

  { /* 出力項目区分(JLAC10CONV CONVPT) */}
  <div style={{ paddingTop: 5 }}>
    <ReportParameter label="出力項目区分">
      <Field name="spitem" component={DropDownCustom} items={spitemkbn} />
    </ReportParameter>
  </div>

  { /* 団体請求対象 */}
  <div style={{ paddingTop: 15 }}>
    <ReportParameter label="団体請求対象">
      <Field name="orgbill" component={CheckBox} label="団体請求対象者のみ" checkedValue={1} />
    </ReportParameter>
  </div>

  { /* 請求対象団体 */}
  <ReportParameter label="請求対象団体">
    <ReportOrgParameter {...props} formName={formName} orgCd1Field="billorgcd1" orgCd2Field="billorgcd2" orgNameField="billorgName" />
  </ReportParameter>

  { /* 受診区分 */}
  <div style={{ paddingTop: 15 }}>
    <ReportParameter label="受診区分">
      <Field name="csldiv" component={DropDownCslDiv} freecd="CSLDIV" addblank />
    </ReportParameter>
  </div>

  { /* 請求書出力区分 */}
  <div style={{ paddingTop: 5 }}>
    <ReportParameter label="請求書出力">
      <Field name="billprint" component={DropDownBillPrint} addblank />
    </ReportParameter>
  </div>

  { /* シーケンス */}
  <div style={{ paddingTop: 15 }}>
    <ReportParameter label="シーケンス">
      <Field name="seq" component={TextBox} />
    </ReportParameter>
  </div>
</div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(speXMLdata, TITLE, 'spexmldata'));
