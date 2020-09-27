/**
 * @file 契約団体調査票出力
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// ラジオボタン
import Radio from '../../components/control/Radio';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '契約団体調査票出力';

// 初期値の 設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
  orgSel: 0,
  csKbn: 0,
};

// カスタムドロップダウン（コース区分）
const csKbnItems = [
  { name: '全て', value: 0 },
  { name: '1日ドック', value: 1 },
  { name: '企業健診', value: 2 },
];

// フォーム名
const formName = 'CompanyconductForm';

// 契約団体調査票出力レイアウト
const Companyconduct = (props) => (
  <div>
    { /* 基準日 */ }
    <ReportParameter label="基準日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
    { /* 団体指定方法 */ }
    <ReportParameter label="団体指定方法" isRequired>
      <Field name="orgSel" component={Radio} label="個別" checkedValue={0} />
      <Field name="orgSel" component={Radio} label="全て" checkedValue={2} />
    </ReportParameter>
    { /* 団体1～10 */ }
    <ReportParameter label="団体１">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd21" orgNameField="orgName1" />
    </ReportParameter>
    <ReportParameter label="団体２">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd12" orgCd2Field="orgcd22" orgNameField="orgName2" />
    </ReportParameter>
    <ReportParameter label="団体３">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd13" orgCd2Field="orgcd23" orgNameField="orgName3" />
    </ReportParameter>
    <ReportParameter label="団体４">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd14" orgCd2Field="orgcd24" orgNameField="orgName4" />
    </ReportParameter>
    <ReportParameter label="団体５">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd15" orgCd2Field="orgcd25" orgNameField="orgName5" />
    </ReportParameter>
    <ReportParameter label="団体６">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd16" orgCd2Field="orgcd26" orgNameField="orgName6" />
    </ReportParameter>
    <ReportParameter label="団体７">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd17" orgCd2Field="orgcd27" orgNameField="orgName7" />
    </ReportParameter>
    <ReportParameter label="団体８">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd18" orgCd2Field="orgcd28" orgNameField="orgName8" />
    </ReportParameter>
    <ReportParameter label="団体９">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd19" orgCd2Field="orgcd29" orgNameField="orgName9" />
    </ReportParameter>
    <ReportParameter label="団体10">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd110" orgCd2Field="orgcd210" orgNameField="orgName10" />
    </ReportParameter>
    { /* コース区分 */ }
    <ReportParameter label="コース区分" isRequired>
      <Field name="csKbn" component={DropDown} items={csKbnItems} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Companyconduct, TITLE, 'companyconduct'));
