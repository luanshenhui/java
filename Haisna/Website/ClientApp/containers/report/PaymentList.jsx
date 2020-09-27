/**
 * @file 団体入金台帳
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '団体入金台帳';

// 出力区分選択肢
const outStatusItems = [
  { value: 1, name: '未収' },
  { value: 2, name: '入金済' },
];

// 並び順選択肢
const SortItems = [
  { value: 1, name: '請求番号順' },
  { value: 2, name: '団体名称順' },
];

// 初期値の設定
const initialValues = {
  s_startymd: moment().format('YYYY/MM/DD'),
  s_endymd: moment().format('YYYY/MM/DD'),
  sortkind: 1,
};

// フォーム名
const formName = 'PaymentListForm';

// 団体入金台帳レイアウト
const PaymentList = () => (
  <div>
    <ReportParameter label="締め日" isRequired>
      <Field name="s_startymd" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="s_endymd" component={DatePicker} />
    </ReportParameter>
    <div style={{ paddingTop: 5 , paddingBottom: 5 }}>
      <ReportParameter label="出力区分" isRequired>
        <Field name="outputcls" component={DropDown} items={outStatusItems} addblank blankname="すべて" />
      </ReportParameter>
    </div>
    <ReportParameter label="入金日">
      <Field name="n_startymd" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="n_endymd" component={DatePicker} />
    </ReportParameter>
    <div style={{ color: 'gray', paddingLeft: 15 }}>※出力区分が入金済みのとき入金日範囲が有効となります。</div>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="並び順" isRequired>
        <Field name="sortkind" component={DropDown} items={SortItems} />
      </ReportParameter>
    </div>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PaymentList, TITLE, 'paymentlist'));
