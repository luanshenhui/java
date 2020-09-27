/**
 * @file 個人異常値一覧表
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = '個人異常値一覧表';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'WarningListNewForm';

// 個人異常値一覧表レイアウト
const WarningListNew = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="当日ID">
      <Field name="dayid" component={TextBox} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(WarningListNew, TITLE, 'warninglistnew'));
