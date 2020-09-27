/**
 * @file 団体健診金額CSV出力
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

// 団体グループ
import DropDownOrgGrpP from '../../components/control/dropdown/DropDownOrgGrpP';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '団体健診金額CSV出力';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  orggrpcd: '',
  cscd: '',
  addQuotes: '',
};

// カスタムドロップダウン（健診コース区分）
const cscdItems = [
  { name: '一日人間ドック', value: 100 },
  { name: '企業健診', value: 110 },
];

// フォーム名
const formName = 'AbsenceListKenForm';

// 団体健診金額CSV出力レイアウト
const AbsenceListKen = (props) => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* 団体1～5 */ }
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
    { /* 団体グループ */ }
    <ReportParameter label="団体グループ">
      <Field name="orggrpcd" component={DropDownOrgGrpP} addblank />
    </ReportParameter>
    { /* 健診コース区分 */ }
    <ReportParameter label="健診コース区分">
      <Field name="cscd" component={DropDown} items={cscdItems} addblank />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListKen, TITLE, 'absencelistken'));
