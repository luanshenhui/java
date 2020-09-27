/**
 * @file 一括送付案内
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import CheckBox from '../../components/control/CheckBox';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import Radio from '../../components/control/Radio';

// ページタイトル
const TITLE = '一括送付案内';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  object: 1,
};

// フォーム名
const formName = 'InvitationForm';

// 一括送付案内レイアウト
const Invitation = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="コース">
      <Field name="cscd" component={DropDownCourse} addblank />
    </ReportParameter>
    <ReportParameter label="その他">
      <Field name="object" component={CheckBox} label="一度出力した受診者は対象外" checkedValue={1} />
    </ReportParameter>
    <ReportParameter label="その他">
      <Field name="printMode" component={Radio} label="印刷" checkedValue={0} />
      <Field name="printMode" component={Radio} label="プレビュー" checkedValue={1} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Invitation, TITLE, 'invitation'));
