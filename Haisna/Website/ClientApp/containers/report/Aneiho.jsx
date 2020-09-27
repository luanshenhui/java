/**
 * @file 労働基準監督署統計
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// コースドロップダウン
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// ページタイトル
const TITLE = '労働基準監督署統計';

// 初期値の 設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  method: 0,
};

// カスタムドロップダウン（団体コード選択）
const methodItems = [
  { name: '団体コード　1-2', value: 0 },
  { name: '団体コード　1　のみ', value: 1 },
];

// フォーム名
const formName = 'AneihoForm';

// 労働基準監督署統計レイアウト
const Aneiho = (props) => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* 団体コード選択 */ }
    <ReportParameter label="団体コード選択" isRequired>
      <Field name="method" component={DropDown} items={methodItems} />
    </ReportParameter>
    { /* 団体1～12 */ }
    <ReportParameter label="団体１">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd21" orgNameField="orgName1" />
    </ReportParameter>
    <ReportParameter label="団体２">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd12" orgCd2Field="orgcd22" orgNameField="orgName2" />
    </ReportParameter>
    <ReportParameter label="団体３">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd13" orgCd2Field="orgcd23" orgNameField="orgName3" />
    </ReportParameter>
    <ReportParameter label="団体４">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd14" orgCd2Field="orgcd24" orgNameField="orgName4" />
    </ReportParameter>
    <ReportParameter label="団体５">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd15" orgCd2Field="orgcd25" orgNameField="orgName5" />
    </ReportParameter>
    <ReportParameter label="団体６">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd16" orgCd2Field="orgcd26" orgNameField="orgName6" />
    </ReportParameter>
    <ReportParameter label="団体７">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd17" orgCd2Field="orgcd27" orgNameField="orgName7" />
    </ReportParameter>
    <ReportParameter label="団体８">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd18" orgCd2Field="orgcd28" orgNameField="orgName8" />
    </ReportParameter>
    <ReportParameter label="団体９">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd19" orgCd2Field="orgcd29" orgNameField="orgName9" />
    </ReportParameter>
    <ReportParameter label="団体10">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd110" orgCd2Field="orgcd210" orgNameField="orgName10" />
    </ReportParameter>
    { /* 団体コード（手入力） 1-5 */ }
    <ReportParameter label="団体コード（手入力） 1-5">
      <div style={{ paddingLeft: 9 }}>
        <Field name="orgcd_s1" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s2" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s3" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s4" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s5" component={TextBox} style={{ width: 70 }} />
      </div>
    </ReportParameter>
    <div style={{ paddingTop: 3 }}>
      { /* 団体コード（手入力） 6-10 */ }
      <ReportParameter label="団体コード（手入力） 6-10">
        <Field name="orgcd_s6" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s7" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s8" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s9" component={TextBox} style={{ width: 70 }} />&nbsp;
        <Field name="orgcd_s10" component={TextBox} style={{ width: 70 }} />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 15 }}>
      <span style={{ color: 'red' }}>※ コースコード未指定の場合、「1日人間ドック」、「職員定期健康診断（ドック）」、「企業健診」のみ対象とします。</span>
    </div>
    { /* コース1～10 */ }
    <ReportParameter label="コースコード 1-2">
      <div style={{ paddingLeft: 9 }}>
        <Field name="cscd1" component={DropDownCourse} addblank />&nbsp;
        <Field name="cscd2" component={DropDownCourse} addblank />
      </div>
    </ReportParameter>
    <div style={{ paddingTop: 3 }}>
      <ReportParameter label="コースコード 3-4">
        <div style={{ paddingLeft: 9 }}>
          <Field name="cscd3" component={DropDownCourse} addblank />&nbsp;
          <Field name="cscd4" component={DropDownCourse} addblank />
        </div>
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 3 }}>
      <ReportParameter label="コースコード 5-6">
        <div style={{ paddingLeft: 9 }}>
          <Field name="cscd5" component={DropDownCourse} addblank />&nbsp;
          <Field name="cscd6" component={DropDownCourse} addblank />
        </div>
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 3 }}>
      <ReportParameter label="コースコード 7-8">
        <div style={{ paddingLeft: 9 }}>
          <Field name="cscd7" component={DropDownCourse} addblank />&nbsp;
          <Field name="cscd8" component={DropDownCourse} addblank />
        </div>
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 3 }}>
      <ReportParameter label="コースコード 9-10">
        <Field name="cscd9" component={DropDownCourse} addblank />&nbsp;
        <Field name="cscd10" component={DropDownCourse} addblank />
      </ReportParameter>
    </div>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(Aneiho, TITLE, 'aneiho'));
