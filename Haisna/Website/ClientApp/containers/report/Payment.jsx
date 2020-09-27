/**
 * @file 入金ジャーナル・入金台帳
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '入金ジャーナル・入金台帳';

// 初期値の設定
const initialValues = {
  paymentdate: moment().format('YYYY/MM/DD'),
  outputcls: 0,
  outputcls2: 0,
};

// 端末名
const outputclsItems = [
  { name: '全指定', value: 0 },
  { name: '端末1', value: 1 },
  { name: '端末2', value: 2 },
  { name: '端末3', value: 3 },
];

// 帳票選択
const reportnameItems = [
  { name: '入金ジャーナル', value: 'paymentja' },
  { name: '入金台帳', value: 'paymentdai' },
];

// フォーム名
const formName = 'PaymentForm';

// 入金ジャーナル・入金台帳レイアウト
const PaymentJa = () => (
  <div>
    { /* 計上日 */ }
    <ReportParameter label="計上日" isRequired>
      <Field name="paymentdate" component={DatePicker} />
    </ReportParameter>
    { /* 端末名 */ }
    <ReportParameter label="端末名">
      <Field name="outputcls" component={DropDown} items={outputclsItems} />
    </ReportParameter>
    { /* 帳票選択 */ }
    <ReportParameter label="帳票選択">
      <Field name="reportName" component={DropDown} items={reportnameItems} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PaymentJa, TITLE, 'paymentja'));
