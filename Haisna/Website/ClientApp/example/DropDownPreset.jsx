import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm } from 'redux-form';
import styled from 'styled-components';

import DatePicker from '../components/control/datepicker/DatePicker';
import TextBox from '../components/control/TextBox';

import DropDownRegisterNo from '../components/control/dropdown/DropDownRegisterNo';
import DropDownCourse from '../components/control/dropdown/DropDownCourse';
import DropDownFreeValue from '../components/control/dropdown/DropDownFreeValue';
import DropDownSetClass from '../components/control/dropdown/DropDownSetClass';
import DropDownDestination from '../components/control/dropdown/DropDownDestination';
import DropDownPrintStartPosition from '../components/control/dropdown/DropDownPrintStartPosition';
import DropDownCopyCount from '../components/control/dropdown/DropDownCopyCount';
import DropDownGender from '../components/control/dropdown/DropDownGender';
import DropDownGrpI from '../components/control/dropdown/DropDownGrpI';
import DropDownCourseDiv from '../components/control/dropdown/DropDownCourseDiv';
import DropDownFollowUpItem from '../components/control/dropdown/DropDownFollowUpItem';
import DropDownDelFlg from '../components/control/dropdown/DropDownDelFlg';
import DropDownCslDiv from '../components/control/dropdown/DropDownCslDiv';
import DropDownReportStyle from '../components/control/dropdown/DropDownReportStyle';
import DropDownBillPrint from '../components/control/dropdown/DropDownBillPrint';
import DropDownPastCourse from '../components/control/dropdown/DropDownPastCourse';
import DropDownOrgGrpP from '../components/control/dropdown/DropDownOrgGrpP';
import DropDownRsvGrp from '../components/control/dropdown/DropDownRsvGrp';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const ExampleForm = ({ formValues }) => (
  <div>
    <form>
      <Caption>レジ番号</Caption>
      <Field name="registerNo" component={DropDownRegisterNo} />
      <Caption>コース</Caption>
      <Field name="csCd" component={DropDownCourse} blankname="すべて" />
      <Caption>コース（東急の例？？？？）</Caption>
      <Field name="csCd" component={DropDownCourse} tokyu />
      <Caption>セット分類</Caption>
      <Field name="setClassCd" component={DropDownSetClass} />
      <Caption>宛先</Caption>
      <Field name="destination" component={DropDownDestination} />
      <Caption>印刷開始位置</Caption>
      <Field name="printStartPosition" component={DropDownPrintStartPosition} />
      <Caption>印刷部数</Caption>
      <Field name="copyCount" component={DropDownCopyCount} />
      <Caption>結果グループ</Caption>
      <Field name="grpcd" component={DropDownGrpI} />
      <Caption>コース区分</Caption>
      <Field name="csDiv" component={DropDownCourseDiv} />
      <Caption>フォローアップ用検査分類</Caption>
      <Field name="followUpItem" component={DropDownFollowUpItem} />
      <Caption>使用状態</Caption>
      <Field name="delFlg" component={DropDownDelFlg} />
      <Caption>予約群</Caption>
      <Field name="rsvGrpCd" component={DropDownRsvGrp} />
      <Caption>予約群（コース条件付き）</Caption>
      <Field name="rsvGrpCd2" component={DropDownRsvGrp} cscdrequired />
      <Caption>受診区分・予約群</Caption>
      <p>受診日：<Field name="csldate" component={DatePicker} /></p>
      <p>団体コード：<Field name="orgcd1" component={TextBox} style={{ width: 65 }} />-<Field name="orgcd2" component={TextBox} style={{ width: 65 }} /></p>
      <p>コースコード：<Field name="cslcscd" component={DropDownCourse} addblank /></p>
      <p>受診区分：<Field name="cslDiv" component={DropDownCslDiv} orgcd1={formValues.orgcd1} orgcd2={formValues.orgcd2} cscd={formValues.cslcscd} csldate={formValues.csldate} /></p>
      <p>予約群：<Field name="cslRsvGrpCd" component={DropDownRsvGrp} cscd={formValues.cslcscd} csldate={formValues.csldate} /></p>
      <Caption>性別</Caption>
      <Field name="gender" component={DropDownGender} />
      <Caption>出力様式</Caption>
      <Field name="reportCd" component={DropDownReportStyle} />
      <Caption>請求書出力</Caption>
      <Field name="billPrint" component={DropDownBillPrint} />
      <Caption>前回値対象コース</Caption>
      <Field name="lastCourse" component={DropDownPastCourse} />
      <Caption>団体グループ</Caption>
      <Field name="orgGrpCd" component={DropDownOrgGrpP} />
      <Caption>団体グループ（使用区分指定例）</Caption>
      <Field name="orgGrpCd" component={DropDownOrgGrpP} usegrp="3" />
      <Caption>汎用情報（銀行）</Caption>
      <Field name="bankCd" component={DropDownFreeValue} freecd="bank" />
      <Caption>汎用情報（予約者一覧出力順）</Caption>
      <Field name="rsvList" component={DropDownFreeValue} freecd="rsvlist" />
    </form>
  </div>
);

// propTypesの定義
ExampleForm.propTypes = {
  formValues: PropTypes.shape().isRequired,
};

const form = 'dropDownPresetExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    initialValues: {
      orgcd1: null,
      orgcd2: null,
      cslcscd: null,
      csldate: null,
    },
    formValues,
  };
})(reduxForm({ form })(ExampleForm));
