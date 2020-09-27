/**
 * @file 団体別契約セット情報CSV出力
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

// 健診コースドロップダウン
import DropDownCourseDiv from '../../components/control/dropdown/DropDownCourseDiv';

// ラジオボタン
import Radio from '../../components/control/Radio';

// ページタイトル
const TITLE = '団体別契約セット情報CSV出力';

// 初期値の設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
  cscd: '100',
  priceflg: 0,
  noHeader: 1,
  detailNoHeader: 0,
};

// フォーム名
const formName = 'AbsenceCompanyForm';

// 団体別契約セット情報CSV出力レイアウト
const AbsenceCompany = (props) => (
  <div>
    { /* 基準日 */ }
    <ReportParameter label="基準日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
    { /* 団体 */ }
    <ReportParameter label="団体" isRequired>
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgName1" />
    </ReportParameter>
    { /* 健診コース */ }
    <ReportParameter label="コース区分" isRequired>
      <Field name="cscd" component={DropDownCourseDiv} />
    </ReportParameter>
    { /* 「0」金額セット出力 */ }
    <ReportParameter label="「0」金額セット出力" isRequired>
      <Field name="priceflg" component={Radio} label="しない" checkedValue={0} />
      <Field name="priceflg" component={Radio} label="する" checkedValue={1} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceCompany, TITLE, 'absencecompany'));
