/**
 * @file 個人受診金額一覧
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import ReportOrgParameter from '../report/ReportOrgParameter';
import CheckBox from '../../components/control/CheckBox';
import TextBox from '../../components/control/TextBox';
import Radio from '../../components/control/Radio';

// ページタイトル
const TITLE = '個人受診金額一覧';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  startcdate: moment().format('YYYY/MM/DD'),
  endcdate: moment().format('YYYY/MM/DD'),
  mode: 0,
  allowunreceipt: 1,
  // ファイル名
  fileName: '個人受診金額一覧.csv',
  // CSVの値をダブルクォーテーションで囲む
  addQuotes: 1,
};

// フォーム名
const formName = 'CslMoneyListForm';

// 個人受診金額一覧レイアウト
const CslMoneyList = (props) => (
  <div>
    <Field name="mode" component={Radio} label="受診期間で抽出" checkedValue={0} />
    <div style={{ paddingLeft: 25 }}>
      <ReportParameter label="受診日" isRequired >
        <Field name="startdate" component={DatePicker} />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
        <Field name="enddate" component={DatePicker} />
      </ReportParameter>
      <ReportParameter label="コース">
        <Field component={DropDownCourse} name="cscd" addblank />
      </ReportParameter>
      <ReportParameter label="団体">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgname" />
      </ReportParameter>
      <ReportParameter label="対象データ" isRequired>
        <Field name="allowunreceipt" component={CheckBox} label="未来院のデータは出力しない" checkedValue={1} />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 10 }}>
      <Field name="mode" component={Radio} label="締め日範囲で抽出" checkedValue={1} />
    </div>
    <div style={{ paddingLeft: 25 }}>
      <ReportParameter label="締め日" isRequired>
        <Field name="startcdate" component={DatePicker} />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
        <Field name="endcdate" component={DatePicker} />
      </ReportParameter>
      <ReportParameter label="負担元団体">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgbcd1" orgCd2Field="orgbcd2" orgNameField="orgbname" />
      </ReportParameter>
      <ReportParameter label="請求書番号">
        <Field name="billno" component={TextBox} />
      </ReportParameter>
      <div style={{ color: 'gray', paddingLeft: 25 }}> ※請求書番号を指定した場合、締め日範囲、負担元は無視されます。 </div>
    </div>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(CslMoneyList, TITLE, 'cslmoneylist'));
