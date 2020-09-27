/**
 * @file 請求書（団体）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';

import moment from 'moment';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';

// 団体ガイド
import ReportOrgParameter from './ReportOrgParameter';

// テキストボックス
import TextBox from '../../components/control/TextBox';

// カスタムドロップダウン
import DropDown from '../../components/control/dropdown/DropDown';

// テキストエリア
import TextArea from '../../components/control/TextArea';

// ラジオボタン
import Radio from '../../components/control/Radio';

// ページタイトル
const TITLE = '請求書（団体）';

// 案内文１
const noteText1 = `拝啓${'　'}貴社ますますご清祥のこととお喜び申し上げます。
いつも当院人間ドックをご利用いただきありがとうございます。
さて、先月にお受けいただいた人間ドックの請求書をお送り申し上げます。
ご確認の上、指定口座までご入金下さいますようお願い申し上げます。
今後とも、より一層のご厚情を賜りますようお願い申し上げます。
${'　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　'}敬具`;

const noteText2 = `拝啓${'　'}貴社ますますご清祥のこととお喜び申し上げます。
いつも当院人間ドックをご利用いただきありがとうございます。
さて、先月にお受けいただいた人間ドックの請求書をお送り申し上げます。
ご確認の上、指定口座までご入金下さいますようお願い申し上げます。
勝手ながら、支払期日はご受診月の翌月末までとさせていただきます。
今後とも、より一層のご厚情を賜りますようお願い申し上げます。
${'　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　'}敬具`;

// 初期値の 設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  billno: '',
  object: 1,
  delflg: 2,
  noteKbn: 1,
  billnote: noteText1,
  kbn: 0,
};

// カスタムドロップダウン（請求対象）
const objectItems = [
  { name: '全て出力', value: 1 },
  { name: '未印刷のみ', value: 2 },
  { name: '印刷済のみ', value: 3 },
];

// カスタムドロップダウン（取消伝票）
const delflgItems = [
  { name: '出力しない', value: 2 },
  { name: '出力する', value: 1 },
];

// カスタムドロップダウン（案内文）
const noteKbnItems = [
  { name: '案内文１', value: 1 },
  { name: '案内文２', value: 2 },
];

// フォーム名
const formName = 'OrgBillForm';

// 請求書（団体）レイアウト
const OrgBill = (props) => (
  <div>
    { /* 請求日 */ }
    <ReportParameter label="請求日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    { /* 請求先 */ }
    <ReportParameter label="請求先">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgName" />
    </ReportParameter>
    { /* 請求書番号 */ }
    <ReportParameter label="請求書番号">
      <Field name="billno" component={TextBox} style={{ width: 175 }} />
    </ReportParameter>
    { /* 請求対象 */ }
    <ReportParameter label="請求対象">
      <Field name="object" component={DropDown} items={objectItems} />
    </ReportParameter>
    { /* 取消伝票 */ }
    <ReportParameter label="取消伝票">
      <Field name="delflg" component={DropDown} items={delflgItems} />
    </ReportParameter>
    { /* 案内文選択 */ }
    <ReportParameter label="案内文選択">
      <Field
        name="noteKbn"
        component={DropDown}
        items={noteKbnItems}
        onChange={(event) => {
          if (event.target.value === '1') {
            props.change('billnote', noteText1);
          } else if (event.target.value === '2') {
            props.change('billnote', noteText2);
          }
        }}
      />
    </ReportParameter>
    { /* 案内文 */ }
    <ReportParameter label="案内文">
      <Field name="billnote" component={TextArea} style={{ width: 700, height: 180 }} />
    </ReportParameter>
    { /* 区分 */ }
    <ReportParameter label="区分">
      <Field name="kbn" component={Radio} label="１次" checkedValue={0} />
      <Field name="kbn" component={Radio} label="２次" checkedValue={1} />
      <Field name="kbn" component={Radio} label="全て" checkedValue={2} />
    </ReportParameter>
  </div>
);

OrgBill.propTypes = {
  change: PropTypes.func.isRequired,
};

export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(OrgBill, TITLE, 'orgbill'));
