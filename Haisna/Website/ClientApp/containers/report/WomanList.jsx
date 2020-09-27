/**
 * @file 女性受診者リスト
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = '女性受診者リスト';

// 初期値の設定
const initialValues = {
  csldate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'WomanListForm';

// 女性受診者リストレイアウト
const WomanList = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="csldate" component={DatePicker} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(WomanList, TITLE, 'womanlist'));
