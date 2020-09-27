/**
 * @file フォローアップ対象者リスト
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = 'フォローアップ対象者リスト';

// 初期値の設定
const initialValues = {
  ssenddate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'FollowListForm';

// フォローアップ対象者リストレイアウト
const FollowList = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="ssenddate" component={DatePicker} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(FollowList, TITLE, 'followlist'));
