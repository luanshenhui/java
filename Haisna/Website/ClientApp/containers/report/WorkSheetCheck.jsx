/**
 * @file ワークシート８項目
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = 'ワークシート８項目';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'WorkSheetCheckForm';

// ワークシート８項目レイアウト
const WorkSheetCheck = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
        <div style={{ marginLeft: '10px', marginRight: '10px' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(WorkSheetCheck, TITLE, 'worksheetcheck'));
