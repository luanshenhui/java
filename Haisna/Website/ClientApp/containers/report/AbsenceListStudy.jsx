/**
 * @file 事前チャートスタディ用受診者リストCSV出力
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = '事前チャートスタディ用受診者リストCSV出力';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'AbsenceListStudyForm';

// 事前チャートスタディ用受診者リストCSV出力レイアウト
const AbsenceListStudy = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListStudy, TITLE, 'absenceliststudy'));
