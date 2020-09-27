/**
 * @file 新患登録リスト
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import ReportPersonParameter from './ReportPersonParameter';

// ページタイトル
const TITLE = '新患登録リスト';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  perid: '',
};

// フォーム名
const formName = 'PatientListForm';

// 新患登録リストレイアウト
const PatientList = (props) => (
  <div>
    <ReportParameter label="開始年月日">
      <Field name="startdate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="終了年月日">
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="個人ID">
      <ReportPersonParameter {...props} formName={formName} perIdField="perid" perNameField="pername" />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PatientList, TITLE, 'patientlist'));
