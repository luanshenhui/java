/**
 * @file ２重ＩＤ登録チェックリスト
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '２重ＩＤ登録チェックリスト';

// 予約状況選択肢
const rsvStatusItems = [
  { value: 0, name: '確定' },
  { value: 1, name: '保留' },
  { value: 2, name: '未確定' },
  { value: 3, name: 'すべて' },
];

// 初期値の設定
const initialValues = {
  startdate: moment({ y: moment().year(), m: 1, d: 1 }).format('YYYY/MM/DD'),
  enddate: moment({ y: moment().year(), m: 1, d: 1 }).format('YYYY/MM/DD'),
  rsvstatus: 0,
};

// フォーム名
const formName = 'CheckdoubleIDForm';

// ２重ＩＤ登録チェックリストレイアウト
const CheckdoubleID = () => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="予約状況選択" isRequired>
      <Field name="rsvstatus" component={DropDown} items={rsvStatusItems} />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(CheckdoubleID, TITLE, 'checkdoubleid'));
