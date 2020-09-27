/**
 * @file 聖路加レジデンス提供用CSV出力
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// 個人ガイド
import ReportPersonParameter from './ReportPersonParameter';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// 団体グループ
import DropDownOrgGrpP from '../../components/control/dropdown/DropDownOrgGrpP';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// チェックボックス
import CheckBox from '../../components/control/CheckBox';

// 汎用ドロップダウン
import DropDownFreeValue from '../../components/control/dropdown/DropDownFreeValue';

// ページタイトル
const TITLE = '聖路加レジデンス提供用CSV出力';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: '',
  orggrpcd: '',
  cscd: '',
  spItem: 'A-RES-RES',
  cslDiv: '',
  orgBill: 0,
  addQuotes: '',
};

// カスタムドロップダウン（健診コース区分）
const cscdItems = [
  { name: '一日人間ドック', value: '100' },
  { name: '職員定期健診（ドック）', value: '105' },
  { name: '企業健診', value: '110' },
  { name: 'レジデンス簡易健診', value: '133' },
];

// カスタムドロップダウン（出力項目区分）
const spItems = [
  { name: '聖路加レジデンス', value: 'A-RES-RES' },
  { name: 'サントリー健保', value: 'A-RES-SAN' },
];
// フォーム名
const formName = 'AbsenceListResiForm';

// 聖路加レジデンス提供用CSV出力レイアウト
const AbsenceListResi = (props) => (
  <div>
    { /* 受診日 */ }
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* 個人ID */ }
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="個人ID">
        <ReportPersonParameter {...props} formName={formName} perIdField="perid" perNameField="perName" />
      </ReportParameter>
    </div>
    { /* 団体1～5 */ }
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="団体１" isRequired>
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd21" orgNameField="orgName1" />
      </ReportParameter>
    </div>
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
    { /* 団体グループ */ }
    <ReportParameter label="団体グループ">
      <Field name="orggrpcd" component={DropDownOrgGrpP} addblank />
    </ReportParameter>
    { /* 健診コース区分 */ }
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="健診コース区分">
        <Field name="cscd" component={DropDown} items={cscdItems} addblank />
      </ReportParameter>
    </div>
    { /* 出力項目区分 */ }
    <ReportParameter label="出力項目区分">
      <Field name="spItem" component={DropDown} items={spItems} />
    </ReportParameter>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="受診区分">
        <Field name="cslDiv" component={DropDownFreeValue} freecd="CSLDIV" addblank />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="団体請求対象">
        <Field name="orgBill" component={CheckBox} label="団体請求対象のみ" checkedValue={1} />
      </ReportParameter>
    </div>
    <ReportParameter label="請求対象団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="billOrgcd1" orgCd2Field="billOrgcd2" orgNameField="billOrgName" />
    </ReportParameter>
  </div>
);

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListResi, TITLE, 'absencelistresi'));
