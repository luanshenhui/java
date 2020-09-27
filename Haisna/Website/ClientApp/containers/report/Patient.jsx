/**
 * @file 個人票
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = '個人票';

// 初期値の設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
  dayid: '',
};

// フォーム名
const formName = 'PatientForm';

// 個人票レイアウト
const Patient = () => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
    { /* 当日ID */ }
    <ReportParameter label="当日ID">
      <Field name="dayid" component={TextBox} style={{ width: 60 }} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Patient, TITLE, 'patient'));
