/**
 * @file 請求書チェックリスト（成績書）
 */
import React from 'react';
import { reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import YearMonthParameter from '../../components/common/YearMonthParameter';

// ページタイトル
const TITLE = '請求書チェックリスト（成績書）';

// 初期値の設定
const initialValues = {
  year: moment().format('YYYY'),
  month: moment().format('M'),
};

// フォーム名
const formName = 'BillRepCheckForm';

// 請求書チェックリスト（成績書）レイアウト
const BillRepCheck = (props) => (
  <div>
    { /* 受診月 */ }
    <ReportParameter label="受診月" isRequired>
      <YearMonthParameter {...props} yearField="year" monthField="month" />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(BillRepCheck, TITLE, 'billrepcheck'));
