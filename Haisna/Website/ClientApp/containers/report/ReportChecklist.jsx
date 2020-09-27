/**
 * @file 成績表チェックリスト
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

// ページタイトル
const TITLE = '成績表チェックリスト';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: '',
  outputcls: 0,
};

// 端末名
const reportnameItems = [
  { name: '総合判定連絡表作成用', value: 'repchecklist' },
  { name: '婦人科コメントチェックリスト', value: 'reportgynechecklist' },
  { name: '眼底チェックリスト', value: 'repretiphotochecklist' },
  { name: '腹部超音波チェックリスト', value: 'repabdoechochecklist' },
  { name: '胸部X線チェックリスト', value: 'reportchestxchecklist' },
  { name: '上部消化管（胃Ｘ線）チェックリスト', value: 'reportgastrochecklist' },
  { name: '上部消化管（内視鏡）チェックリスト', value: 'reportendochecklist' },
  { name: '胸部CTチェックリスト', value: 'reportctchecklist' },
  { name: '乳房Ｘ線チェックリスト', value: 'reportmammochecklist' },
  { name: '乳房超音波チェックリスト', value: 'repbreastsechochklist' },
  /* { name: '乳房触診チェックリスト', value: 10 }, */
  { name: '心電図判定所見リスト', value: 'reportecglist' },
  /* { name: 'メタボリックシンドローム', value: 12 }, */
  /* { name: '胸部CT再検査対象リスト', value: 13 }, */
  /* { name: 'GF生検実施者リスト', value: 14 }, */
  /* { name: '骨密度チェックリスト', value: 15 }, */
];

// フォーム名
const formName = 'ReportChecklistForm';

// 成績表チェックリストレイアウト
const RepChecklist = () => (
  <div>
    { /* 作成日 */ }
    <ReportParameter label="作成日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* チェックリスト選択 */ }
    <ReportParameter label="チェックリスト選択">
      <Field name="reportName" component={DropDown} items={reportnameItems} isRequired />
    </ReportParameter>

  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(RepChecklist, TITLE, 'repchecklist'));
