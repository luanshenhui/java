/**
 * @file 未収金
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// ページタイトル
const TITLE = '未収金';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  cscd: '',
};

// フォーム名
const formName = 'ReceivableForm';

// 未収金レイアウト
const Receivable = () => (
  <div>
    { /* 請求日 */ }
    <ReportParameter label="請求日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Receivable, TITLE, 'receivable'));
