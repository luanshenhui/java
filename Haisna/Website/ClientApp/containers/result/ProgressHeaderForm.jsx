import React from 'react';
import moment from 'moment';
import { reduxForm, Field, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';
import TextBox from '../../components/control/TextBox';
import * as constants from '../../constants/common';

import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import DropDownRsvGrp from '../../components/control/dropdown/DropDownRsvGrp';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import { getProgressListRequest, initializeProgressList } from '../../modules/result/resultModule';

const formName = 'ProgressHeaderForm';
const modeItems = [
  { value: 1, name: '未検査が存在する受診者のみ' },
  { value: 2, name: '全て完了している受診者のみ' },
];

const ProgressHeader = (props) => (
  <ListHeaderFormBase {...props} >
    <FieldGroup>
      <FieldSet>
        <FieldItem>受診日</FieldItem>
        <Field name="cslDate" component={DatePicker} />
      </FieldSet>
      <FieldSet>
        <FieldItem>コース</FieldItem>
        <Field name="csCd" component={DropDownCourse} mode={1} addblank blankname="すべて" />
        <FieldItem>表示形式</FieldItem>
        <Field name="entryStatus" component={DropDown} items={modeItems} addblank blankname="すべて" />
      </FieldSet>
      <FieldSet>
        <FieldItem>予約群</FieldItem>
        <Field name="rsvGrpCd" component={DropDownRsvGrp} addblank blankname="すべて" />
        <FieldItem>予約番号</FieldItem>
        <Field name="rsvNo" component={TextBox} id="rsvNo" style={{ width: 100 }} maxLength={constants.LENGTH_CONSULT_RSVNO} />
        <Button type="submit" value="表示" />
      </FieldSet>
    </FieldGroup>
  </ListHeaderFormBase>
);

const ProgressHeaderForm = reduxForm({
  form: formName,
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(ProgressHeader);

// propTypesの定義
ProgressHeader.propTypes = {
};

const mapStateToProps = (state) => ({
  initialValues: {
    cslDate: state.app.result.result.progressList.conditions.cslDate,
    csCd: state.app.result.result.progressList.conditions.csCd,
    entryStatus: state.app.result.result.progressList.conditions.entryStatus,
    rsvGrpCd: state.app.result.result.progressList.conditions.rsvGrpCd,
    rsvNo: state.app.result.result.progressList.conditions.rsvNo,
  },
});


const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    let params = {};
    if (!conditions.cslDate) {
      const cslDate = moment().format('YYYY/M/D');
      params = { ...conditions, cslDate };
      dispatch(blur('ProgressHeaderForm', 'conditions.cslDate', cslDate));
    } else {
      params = { ...conditions };
    }
    if (conditions.rsvNo) {
      const r = /^\d+$/;
      if (r.test(conditions.rsvNo)) {
        const rsvNo = parseInt(conditions.rsvNo, 10);
        params = { ...params, rsvNo };
        dispatch(blur('ProgressHeaderForm', 'conditions.rsvNo', rsvNo));
      }
    }
    params = { startPos: 1, ...params };
    dispatch(getProgressListRequest(params));
  },
  initializeList: () => {
    dispatch(initializeProgressList());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ProgressHeaderForm));
