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
import DropDown from '../../components/control/dropdown/DropDown';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import DropDownGender from '../../components/control/dropdown/DropDownGender';

import ReportOrgParameter from '../report/ReportOrgParameter';

// 年齢年ドロップダウンアイテム
const ageYItems = Array.from({ length: 151 }, (_, i) => ({ name: i, value: i }));
// 年齢月ドロップダウンアイテム
const ageMItems = Array.from({ length: 12 }, (_, i) => ({ name: i, value: i }));

// ページタイトル
const TITLE = '個人情報の抽出';

// 初期値の設定
const initialValues = {
  // 開始受診日
  startDate: moment().format('YYYY/MM/DD'),
  // 終了受診日
  endDate: moment().format('YYYY/MM/DD'),
  // 開始年齢年
  startAgeY: 0,
  // 終了年齢年
  endAgeY: 150,
  // ファイル名
  fileName: 'datPerList.csv',
  // CSVの値をダブルクォーテーションで囲む
  addQuotes: 1,
};

// フォーム名
const formName = 'PersonCsvForm';

// 個人情報画面レイアウト
const PersonCsv = (props) => (
  <div>
    <ReportParameter label="開始受診日" isRequired>
      <Field name="startDate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="終了受診日" isRequired>
      <Field name="endDate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="コース">
      <Field component={DropDownCourse} name="csCd" addblank blankname="すべて" />
    </ReportParameter>
    <ReportParameter label="団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgName" />
    </ReportParameter>
    <ReportParameter label="開始年齢">
      <Field component={DropDown} name="startAgeY" items={ageYItems} addblank /><span>.</span>
      <Field component={DropDown} name="startAgeM" items={ageMItems} addblank />
    </ReportParameter>
    <ReportParameter label="終了年齢">
      <Field component={DropDown} name="endAgeY" items={ageYItems} addblank /><span>.</span>
      <Field component={DropDown} name="endAgeM" items={ageMItems} addblank />
    </ReportParameter>
    <ReportParameter label="性別">
      <Field component={DropDownGender} name="gender" addblank blankname="男女" />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PersonCsv, TITLE, 'personcsv'));
