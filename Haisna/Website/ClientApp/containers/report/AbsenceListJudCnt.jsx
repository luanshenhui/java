/**
 * @file 団体・判定ランク別受診者人数CSV出力
 */
import React from 'react';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DropDownFreeValue from '../../components/control/dropdown/DropDownFreeValue';
import ReportOrgParameter from './ReportOrgParameter';

// ページタイトル
const TITLE = '団体・判定ランク別受診者人数CSV出力';

// 初期値の設定
const initialValues = {
  startdate: moment().format('YYYY/MM/DD'),
  enddate: moment().format('YYYY/MM/DD'),
  // ファイル名
  fileName: '団体判定ランク別人数.csv',
};

// フォーム名
const formName = 'AbsenceListJudCntForm';

// 団体・判定ランク別受診者人数CSV出力レイアウト
const AbsenceListJudCnt = (props) => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="startdate" component={DatePicker} />
      <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
      <Field name="enddate" component={DatePicker} />
    </ReportParameter>
    <ReportParameter label="団体１">
      <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd12" orgNameField="orgname1" />
    </ReportParameter>
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
    <ReportParameter label="受診区分">
      <Field name="csldivcd" component={DropDownFreeValue} freecd="CSLDIV" addblank />
    </ReportParameter>
  </div>
);

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AbsenceListJudCnt, TITLE, 'absencelistjudcnt'));
