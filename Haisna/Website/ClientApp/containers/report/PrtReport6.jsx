import React from 'react';
import moment from 'moment';
import { Field, reduxForm } from 'redux-form';
import DatePicker from '../../components/control/datepicker/DatePicker';
import Radio from '../../components/control/Radio';
import CheckBox from '../../components/control/CheckBox';
import ReportForm from '../../containers/report/ReportForm';
import ReportParameter from '../../components/report/field/ReportParameter';
import TextBox from '../../components/control/TextBox';
import ReportOrgParameter from './ReportOrgParameter';
import DropDownFreeValue from '../../components/control/dropdown/DropDownFreeValue';
import DropDownBillPrint from '../../components/control/dropdown/DropDownBillPrint';
import DropDownReportList from '../../components/control/dropdown/DropDownReportList';
import DropDownOrgGrpP from '../../components/control/dropdown/DropDownOrgGrpP';

// ページタイトル
const TITLE = '成績書';
// フォーム名
const formName = 'PrtReport6';

const PrtReport6 = (props) => (
  <div>
    <ReportParameter label="受診日" isRequired>
      <Field name="strClsDate" component={DatePicker} /> ～
      <Field name="endClsDate" component={DatePicker} />
    </ReportParameter>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="当日ID">
        <Field name="dayid" component={TextBox} id="" style={{ width: 800 }} />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="団体グループ">
        <Field name="orggrpcd" component={DropDownOrgGrpP} addblank />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="団体1">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd11" orgCd2Field="orgcd12" orgNameField="orgname1" />
      </ReportParameter>
      <ReportParameter label="団体2">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd21" orgCd2Field="orgcd22" orgNameField="orgname2" />
      </ReportParameter>
      <ReportParameter label="団体3">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd31" orgCd2Field="orgcd32" orgNameField="orgname3" />
      </ReportParameter>
      <ReportParameter label="団体4">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd41" orgCd2Field="orgcd42" orgNameField="orgname4" />
      </ReportParameter>
      <ReportParameter label="団体5">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd51" orgCd2Field="orgcd52" orgNameField="orgname5" />
      </ReportParameter>
      <ReportParameter label="団体6">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd61" orgCd2Field="orgcd62" orgNameField="orgname6" />
      </ReportParameter>
      <ReportParameter label="団体7">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd71" orgCd2Field="orgcd72" orgNameField="orgname7" />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="出力様式" isRequired>
        <Field name="reportcd" component={DropDownReportList} addblank />
      </ReportParameter>
    </div>
    <div style={{ paddingTop: 5 }}>
      <ReportParameter label="出力順" isRequired>
        <Field component={Radio} name="sort" checkedValue={0} label="受診日＋当日ID  " />
        <Field component={Radio} name="sort" checkedValue={1} label="団体＋受診日＋当日ID  " />
      </ReportParameter>
    </div>
    <ReportParameter label="印刷ページ" isRequired>
      <Field component={CheckBox} name="checkpage1" checkedValue={1} label="1page " />
      <Field component={CheckBox} name="checkpage2" checkedValue={1} label="2page " />
      <Field component={CheckBox} name="checkpage3" checkedValue={1} label="3page " />
      <Field component={CheckBox} name="checkpage4" checkedValue={1} label="4page " />
      <Field component={CheckBox} name="checkpage5" checkedValue={1} label="5page " />
      <Field component={CheckBox} name="checkpage6" checkedValue={1} label="6page " />
      <Field component={CheckBox} name="checkpage7" checkedValue={1} label="7page " />
      <Field component={CheckBox} name="checkpage8" checkedValue={1} label="8page " />
      <Field component={CheckBox} name="checkpage9" checkedValue={1} label="9page " />
      <Field component={CheckBox} name="checkpage10" checkedValue={1} label="10page " />
    </ReportParameter>
    <div style={{ paddingTop: 5 }}>
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

// 初期値の設定
const initialValues = {
  strClsDate: moment().format('YYYY/MM/DD'),
  sort: 0,
  checkpage1: 1,
  checkpage2: 1,
  checkpage3: 1,
  checkpage4: 1,
  checkpage5: 1,
  checkpage6: 1,
  checkpage7: 1,
  checkpage8: 1,
  checkpage9: 1,
  checkpage10: 1,
};

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(PrtReport6, TITLE, 'prtreport6'));
