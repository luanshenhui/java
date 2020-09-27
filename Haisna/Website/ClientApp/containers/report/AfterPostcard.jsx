/**
 * @file 一年目はがき
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

import YearMonthParameter from '../../components/common/YearMonthParameter';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// テキストエリア
import TextArea from '../../components/control/TextArea';

// ページタイトル
const TITLE = '一年目はがき';

// 初期値の 設定
const initialValues = {
  startymd: moment().subtract(9, 'month').format('YYYY/MM/DD'),
  endymd: moment().subtract(9, 'month').format('YYYY/MM/DD'),
  start_ym_y: moment().subtract(4, 'month').format('YYYY'),
  start_ym_m: moment().subtract(4, 'month').format('M'),
  end_ym_y: moment().add(4, 'month').format('YYYY'),
  end_ym_m: moment().add(4, 'month').format('M'),
  notes: `その後いかがお過ごしでしょうか。
前回ご受診日よりもうすぐ１年となります。
ご予約は裏面の電話またはインターネットにて
承っております。
皆様からのご予約をお待ちしております。
`,
};

// フォーム名
const formName = 'AfterPostcardForm';

// 一年目はがきレイアウト
const AfterPostcard = (props) => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startymd" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="endymd" component={DatePicker} />
    </ReportParameter>
    { /* 予約年月 */ }
    <ReportParameter label="予約年月">
      <YearMonthParameter {...props} yearField="start_ym_y" monthField="start_ym_m" />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <YearMonthParameter {...props} yearField="end_ym_y" monthField="end_ym_m" />
    </ReportParameter>
    { /* 団体 */ }
    <ReportParameter label="団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgName" />
    </ReportParameter>
    { /* コメント */ }
    <ReportParameter label="コメント">
      <Field name="notes" component={TextArea} style={{ width: 500, height: 150 }} />
    </ReportParameter>

  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AfterPostcard, TITLE, 'afterpostcard'));
