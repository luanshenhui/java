/**
 * @file 未請求受診情報一覧
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import CheckBox from '../../components/control/CheckBox';
import TextBox from '../../components/control/TextBox';
import Radio from '../../components/control/Radio';

// ページタイトル
const TITLE = '未請求受診情報一覧';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  mode: 0,
  nodemanddata: 1,
  // ファイル名
  fileName: '請求情報一覧.csv',
  // CSVの値をダブルクォーテーションで囲む
  addQuotes: 1,
};

// フォーム名
const formName = 'BillConsultListForm';

// 未請求受診情報一覧レイアウト
const BillConsultList = () => (
  <div>
    <Field name="mode" component={Radio} label="受診期間で抽出" checkedValue={0} />
    <div style={{ paddingLeft: 25 }}>
      <ReportParameter label="受診日" isRequired>
        <Field name="startdate" component={DatePicker} />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
        <Field name="enddate" component={DatePicker} />
      </ReportParameter>
    </div>
    <div style={{ paddingLeft: 25 }}>
      <ReportParameter label="対象データ" isRequired>
        <Field name="nodemanddata" component={CheckBox} label="未請求データのみ出力" checkedValue={1} />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 10 }}>
      <Field name="mode" component={Radio} label="請求書Noで抽出" checkedValue={1} />
    </div>
    <div style={{ paddingLeft: 25 }}>
      <ReportParameter label="請求書番号" isRequired>
        <Field name="billno" component={TextBox} />
      </ReportParameter>
    </div>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(BillConsultList, TITLE, 'billconsultlist'));
