/**
 * @file 団体ダイレクトメール
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// コースドロップダウン
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';

// ラジオボタン
import Radio from '../../components/control/Radio';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// ページタイトル
const TITLE = '団体ダイレクトメール';

// 初期値の 設定
const initialValues = {
  orgAddr: 4,
  orgDiv: 0,
  present: 0,
  orgSel: 0,
  sort: 1,
  pos: 1,
  busu: 1,
};

// カスタムドロップダウン（宛先）
const orgAddrItems = [
  { name: 'ＤＭ適用住所', value: 4 },
  { name: '請求書適用住所', value: 0 },
  { name: '住所1', value: 1 },
  { name: '住所2', value: 2 },
  { name: '住所3', value: 3 },
];

// カスタムドロップダウン（団体種別）
const orgDivItems = [
  { name: '全て', value: 0 },
  { name: '健保連', value: 1 },
  { name: '直接契約', value: 2 },
  { name: '直接契約(関連会社)', value: 3 },
  { name: '使用せず', value: 4 },
];

// カスタムドロップダウン（年始・中元・歳暮）
const presentItems = [
  { name: '全て', value: 0 },
  { name: '対象のみ', value: 1 },
];

// カスタムドロップダウン（ソート）
const sortItems = [
  { name: '団体コード順', value: 1 },
  { name: '団体カナ順', value: 2 },
];

// カスタムドロップダウン（印刷開始位置）
const posItems = [
  { name: '1', value: 1 },
  { name: '2', value: 2 },
  { name: '3', value: 3 },
  { name: '4', value: 4 },
  { name: '5', value: 5 },
  { name: '6', value: 6 },
  { name: '7', value: 7 },
  { name: '8', value: 8 },
  { name: '9', value: 9 },
  { name: '10', value: 10 },
  { name: '11', value: 11 },
  { name: '12', value: 12 },
];

// カスタムドロップダウン（部数）
const busuItems = [
  { name: '1', value: 1 },
  { name: '2', value: 2 },
  { name: '3', value: 3 },
  { name: '4', value: 4 },
  { name: '5', value: 5 },
  { name: '6', value: 6 },
  { name: '7', value: 7 },
  { name: '8', value: 8 },
  { name: '9', value: 9 },
  { name: '10', value: 10 },
  { name: '11', value: 11 },
  { name: '12', value: 12 },
];

// フォーム名
const formName = 'DirectMailForm';

// 団体ダイレクトメールレイアウト
const DirectMail = (props) => (
  <div>
    { /* 宛先 */ }
    <ReportParameter label="宛先" isRequired>
      <Field name="orgAddr" component={DropDown} items={orgAddrItems} />

    </ReportParameter>
    { /* 団体種別 */ }
    <ReportParameter label="団体種別" isRequired>
      <Field name="orgDiv" component={DropDown} items={orgDivItems} />
    </ReportParameter>

    { /* 年始・中元・歳暮 */ }
    <ReportParameter label="年始・中元・歳暮">
      <Field name="present" component={DropDown} items={presentItems} />
    </ReportParameter>

    { /* 団体指定方法 */ }
    <ReportParameter label="団体指定方法" isRequired>
      <Field name="orgSel" component={Radio} label="全て" checkedValue={0} />
      <Field name="orgSel" component={Radio} label="個別" checkedValue={2} />
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
    <ReportParameter label="団体11">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd111" orgCd2Field="orgcd211" orgNameField="orgName11" />
    </ReportParameter>
    <ReportParameter label="団体12">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd112" orgCd2Field="orgcd212" orgNameField="orgName12" />
    </ReportParameter>

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

    { /* ソート */ }
    <ReportParameter label="ソート" isRequired>
      <Field name="sort" component={DropDown} items={sortItems} />
    </ReportParameter>

    { /* 印刷開始位置 */ }
    <ReportParameter label="印刷開始位置" isRequired>
      <Field name="pos" component={DropDown} items={posItems} />
    </ReportParameter>

    { /* 印刷部数 */ }
    <ReportParameter label="印刷部数" isRequired>
      <Field name="busu" component={DropDown} items={busuItems} />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(DirectMail, TITLE, 'dm'));
