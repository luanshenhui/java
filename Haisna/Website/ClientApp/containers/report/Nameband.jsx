/**
 * @file ネームバンド印刷
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// コース
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = 'ネームバンド印刷';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  cscd: '',
  strDayid: '',
  endDayid: '',
};

// フォーム名
const formName = 'NamebandForm';

// ネームバンド印刷レイアウト
const Nameband = () => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
    </ReportParameter>
    { /* コース */ }
    <ReportParameter label="コース">
      <Field name="cscd" component={DropDownCourse} addblank blankname="" />
    </ReportParameter>
    { /* 当日ID */ }
    <ReportParameter label="当日ID">
      <Field name="strDayid" component={TextBox} style={{ width: 60 }} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="endDayid" component={TextBox} style={{ width: 60 }} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Nameband, TITLE, 'nameband'));
