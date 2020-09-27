/**
 * @file 未収団体一覧
 */
import React from 'react';
import { reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import YearMonthParameter from '../../components/common/YearMonthParameter';

// ページタイトル
const TITLE = '未収団体一覧';

// 初期値の設定
const initialValues = {
  year: moment().format('YYYY'),
  month: moment().format('M'),
};

// フォーム名
const formName = 'OrgArrearsForm';

// 未収団体一覧レイアウト
const OrgArrears = (props) => (
  <div>
    { /* 対象年月 */ }
    <ReportParameter label="対象年月" isRequired>
      <YearMonthParameter {...props} yearField="year" monthField="month" />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(OrgArrears, TITLE, 'orgarrears'));
