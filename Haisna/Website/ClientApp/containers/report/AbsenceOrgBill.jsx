/**
 * @file 請求書明細抽出（三井物産健保フォーマット）
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import ReportOrgParameter from '../report/ReportOrgParameter';
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = '請求書明細抽出（三井物産健保フォーマット）';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  // ファイル名
  fileName: '団体請求明細.csv',
};

// フォーム名
const formName = 'AbsenceOrgBillForm';

// 請求書明細抽出（三井物産健保フォーマット）レイアウト
const AbsenceOrgBill = (props) => (
  <div>
    <ReportParameter label="締め日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="請求書番号">
      <Field name="billno" component={TextBox} />
    </ReportParameter>
    <div style={{ color: 'gray', paddingLeft: 25 }}> ※請求書番号を指定した場合、締め日範囲は無視されます。 </div>
    <ReportParameter label="負担元団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgname" />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceOrgBill, TITLE, 'absenceorgbill'));
