/**
 * @file 内視鏡チェックシート（同意書）
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
const TITLE = '内視鏡チェックシート（同意書）';

// 初期値の設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'EndoscopeCheckForm';

// 内視鏡チェックシート（同意書）レイアウト
const EndoscopeCheck = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="当日ID" isRequired>
      <Field name="dayid" component={TextBox} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(EndoscopeCheck, TITLE, 'endoscopecheck2'));
