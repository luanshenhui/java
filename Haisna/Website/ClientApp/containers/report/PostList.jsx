/**
 * @file 郵便物受領書(団体請求書、成績表)
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = '郵便物受領書(団体請求書、成績表)';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: '',
  reportName: 'postbill',
  cscd: '',
  loginId: '',
};

// 郵便物選択
const reportNameItems = [
  { name: '(団体)請求書', value: 'postbill' },
  { name: '成績表', value: 'postreport' },
];

// コース選択
const cscdItems = [
  { name: '1日人間ドック', value: '100' },
  { name: '企業健診', value: '110' },
  { name: '渡航内科', value: '170' },
  { name: '肺ドック', value: '150' },
  { name: 'その他', value: '999' },
];

// フォーム名
const formName = 'PostListForm';

// 郵便物受領書(団体請求書、成績表)レイアウト
const PostList = () => (
  <div>
    { /* 発送日 */ }
    <ReportParameter label="発送日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* 郵便物選択 */ }
    <ReportParameter label="郵便物選択">
      <Field name="reportName" component={DropDown} items={reportNameItems} isRequired />
    </ReportParameter>
    { /* コース選択 */ }
    <ReportParameter label="コース選択">
      <Field name="cscd" component={DropDown} items={cscdItems} addblank />　成績表のみ対応
    </ReportParameter>
    <div>※空欄の場合、すべてのコースが対象</div>
    <div>※その他の場合、1日人間ドック、企業健診、渡航内科、肺ドック以外のコースが対象</div>
    <br />
    { /* 発送者ID */ }
    <ReportParameter label="発送者ID">
      <Field name="loginId" component={TextBox} style={{ width: 140 }} />　発送処理を行った担当者IDを入力（ 例：425XXX ）
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PostList, TITLE, 'postbill'));
