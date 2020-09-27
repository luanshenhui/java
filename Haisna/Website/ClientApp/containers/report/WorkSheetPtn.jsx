/**
 * @file ワークシート個人票チェックリスト
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// ページタイトル
const TITLE = 'ワークシート個人票チェックリスト';

// 初期値の設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'WorkSheetPtnForm';

// ワークシート個人票チェックリストレイアウト
const WorkSheetPtn = () => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(WorkSheetPtn, TITLE, 'worksheetptn'));
