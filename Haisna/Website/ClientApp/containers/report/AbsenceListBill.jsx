/**
 * @file 団体請求データCSV出力（経理システム連携用）
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
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '団体請求データCSV出力（経理システム連携用）';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  ispayment: 2,
  // ファイル名
  fileName: 'ORG_BILL.csv',
};

// 請求書発送
const billSendItems = [
  { name: '未発送のみ', value: 2 },
  { name: '発送済みのみ', value: 1 },
];

// 未収
const accruedItems = [
  { name: '未収のみ', value: 2 },
  { name: '入金済みのみ', value: 1 },
];

// フォーム名
const formName = 'AbsenceListBillForm';

// 団体請求データCSV出力（経理システム連携用）レイアウト
const AbsenceListBill = (props) => (
  <div>
    <ReportParameter label="締め日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="請求先１">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd12" orgNameField="orgname1" />
    </ReportParameter>
    <ReportParameter label="請求先２">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd21" orgCd2Field="orgcd22" orgNameField="orgname2" />
    </ReportParameter>
    <ReportParameter label="請求先３">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd31" orgCd2Field="orgcd32" orgNameField="orgname3" />
    </ReportParameter>
    <ReportParameter label="請求先４">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd41" orgCd2Field="orgcd42" orgNameField="orgname4" />
    </ReportParameter>
    <ReportParameter label="請求先５">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd51" orgCd2Field="orgcd52" orgNameField="orgname5" />
    </ReportParameter>
    <ReportParameter label="請求書No.">
      <Field name="billno" component={TextBox} />
    </ReportParameter>
    <ReportParameter label="請求書発送">
      <Field name="isdispatch" component={DropDown} items={billSendItems} addblank />
    </ReportParameter>
    <ReportParameter label="未収">
      <Field name="ispayment" component={DropDown} items={accruedItems} addblank />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListBill, TITLE, 'absencelistbill'));
