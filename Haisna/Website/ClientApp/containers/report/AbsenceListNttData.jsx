/**
 * @file 聖路加フォーマット健診結果CSV出力（ＮＴＴデータ形式）④
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DropDownOrgGrpP from '../../components/control/dropdown/DropDownOrgGrpP';
import ReportOrgParameter from './ReportOrgParameter';
import Radio from '../../components/control/Radio';
import CheckBox from '../../components/control/CheckBox';
import DropDownFreeValue from '../../components/control/dropdown/DropDownFreeValue';
import DropDownBillPrint from '../../components/control/dropdown/DropDownBillPrint';

// ページタイトル
const TITLE = '聖路加フォーマット健診結果CSV出力（ＮＴＴデータ形式）④';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  ocrcheck: 1,
  noHeader: 1,
  // ファイル名
  fileName: 'NTTデータ標準FPD.csv',
};

// フォーム名
const formName = 'AbsenceListNttDataForm';

// 聖路加フォーマット健診結果CSV出力（ＮＴＴデータ形式）④レイアウト
const AbsenceListNttDataForm = (props) => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="問診項目" isRequired>
      <Field name="ocrcheck" component={Radio} label="あり" checkedValue={1} />
      <Field name="ocrcheck" component={Radio} label="なし" checkedValue={2} />
    </ReportParameter>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="団体１">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd12" orgNameField="orgname1" />
      </ReportParameter>
    </div>
    <ReportParameter label="団体２">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd21" orgCd2Field="orgcd22" orgNameField="orgname2" />
    </ReportParameter>
    <ReportParameter label="団体３">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd31" orgCd2Field="orgcd32" orgNameField="orgname3" />
    </ReportParameter>
    <ReportParameter label="団体４">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd41" orgCd2Field="orgcd42" orgNameField="orgname4" />
    </ReportParameter>
    <ReportParameter label="団体５">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd51" orgCd2Field="orgcd52" orgNameField="orgname5" />
    </ReportParameter>
    <ReportParameter label="団体グループ">
      <Field name="orggrpcd" component={DropDownOrgGrpP} addblank />
    </ReportParameter>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="団体請求対象">
        <Field name="orgbill" component={CheckBox} label="団体請求対象のみ" checkedValue={1} />
      </ReportParameter>
    </div>
    <ReportParameter label="請求対象団体">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="billorgcd1" orgCd2Field="billorgcd2" orgNameField="billOrgName" />
    </ReportParameter>
    <div style={{ paddingTop: 15 }}>
      <ReportParameter label="受診区分">
        <Field name="csldivcd" component={DropDownFreeValue} freecd="CSLDIV" addblank />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="請求書出力">
        <Field name="billPrint" component={DropDownBillPrint} addblank />
      </ReportParameter>
    </div>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListNttDataForm, TITLE, 'absencelistnttdata'));
