/**
 * @file ご案内書送付チェックリスト
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

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// ページタイトル
const TITLE = 'ご案内書送付チェックリスト';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  cscd: '',
};

// フォーム名
const formName = 'InstructionListForm';

// ご案内書送付チェックリストレイアウト
const InstructionList = (props) => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* コース */ }
    <ReportParameter label="コース">
      <Field name="cscd" component={DropDownCourse} addblank />
    </ReportParameter>
    { /* 団体 */ }
    <ReportParameter label="団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgName" />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(InstructionList, TITLE, 'instructionlist'));
