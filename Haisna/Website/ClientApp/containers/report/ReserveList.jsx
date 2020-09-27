/**
 * @file 予約者一覧表
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = '予約者一覧表';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
};

// フォーム名
const formName = 'ReserveListForm';

// 予約者一覧表レイアウト
const ReserveList = () => (
  <div>
    <ReportParameter label="開始年月日" isRequired>
      <Field name="startdate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="終了年月日">
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(ReserveList, TITLE, 'reservelist'));
