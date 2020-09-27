import React from 'react';
import { reduxForm, Field, getFormValues, blur } from 'redux-form';
import moment from 'moment';

import { withRouter } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import DatePicker from '../../../components/control/datepicker/DatePicker';
import OrgParameter from './OrgParameter';
import PersonParameter from './PersonParameter';
import DropDown from '../../../components/control/dropdown/DropDown';
import DropDownCourse from '../../../components/control/dropdown/DropDownCourse';
import DropDownOrgGrpP from '../../../components/control/dropdown/DropDownOrgGrpP';

import Button from '../../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';

import OrgGuide from '../../../containers/common/OrgGuide';
import PersonGuide from '../../../containers/common/PersonGuide';
import { getReportSendDateListRequest, initialReportSendDateList } from '../../../modules/report/reportSendDateModule';

const sendModeItems = [
  { value: '0', name: 'すべて' },
  { value: '1', name: '発送済みのみ' },
  { value: '2', name: '未発送のみ' },
];
const pageMaxLineItems = [
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 999, name: 'すべて' },
];

const formName = 'InqReportsInfoHeaderForm';

class InqReportsInfoHeader extends React.Component {
  componentWillUnmount() {
    const { initializeList } = this.props;
    initializeList();
  }
  // 描画処理
  render() {
    return (
      <div>
        <ListHeaderFormBase {...this.props} >
          <FieldGroup itemWidth={100}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Field name="strCslDate" component={DatePicker} id="strCslDate" />
              ~
              <Field name="endCslDate" component={DatePicker} id="endCslDate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>コース</FieldItem>
              <Field name="csCd" component={DropDownCourse} mode={1} addblank blankname="" />
            </FieldSet>
            <FieldSet>
              <FieldItem>団体</FieldItem>
              <div style={{ width: '320px', display: 'flex' }}>
                <OrgGuide />
                <OrgParameter formName="InqReportsInfoHeaderForm" {...this.props} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgname" />
              </div>
              <FieldItem>団体グループ</FieldItem>
              <Field name="orgGrpCd" component={DropDownOrgGrpP} addblank blankname="" />
            </FieldSet>
            <FieldSet>
              <FieldItem>個人ID</FieldItem>
              <div style={{ width: '320px', display: 'flex' }}>
                <PersonGuide />
                <PersonParameter formName="InqReportsInfoHeaderForm" {...this.props} peridField="perid" lastNameField="lastname" firstNameField="firstname" />
              </div>
              <Field name="sendMode" component={DropDown} id="sendMode" items={sendModeItems} />
              <Field name="limit" component={DropDown} id="limit" items={pageMaxLineItems} />
              <Button type="submit" value="検索" />
            </FieldSet>
          </FieldGroup>
        </ListHeaderFormBase>
      </div>
    );
  }
}

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      strCslDate: state.app.report.reportSendDate.ReportSendDateList.conditions.strCslDate,
      limit: state.app.report.reportSendDate.ReportSendDateList.conditions.limit,
      endCslDate: state.app.report.reportSendDate.ReportSendDateList.conditions.endCslDate,
      csCd: state.app.report.reportSendDate.ReportSendDateList.conditions.csCd,
      orgGrpCd: state.app.report.reportSendDate.ReportSendDateList.conditions.orgGrpCd,
      sendMode: state.app.report.reportSendDate.ReportSendDateList.conditions.sendMode,
      orgcd1: state.app.report.reportSendDate.ReportSendDateList.conditions.orgcd1,
      orgcd2: state.app.report.reportSendDate.ReportSendDateList.conditions.orgcd2,
      orgname: state.app.report.reportSendDate.ReportSendDateList.conditions.orgname,
      perid: state.app.report.reportSendDate.ReportSendDateList.conditions.perid,
      lastname: state.app.report.reportSendDate.ReportSendDateList.conditions.lastname,
      firstname: state.app.report.reportSendDate.ReportSendDateList.conditions.firstname,
    },
  };
};

// propTypesの定義
InqReportsInfoHeader.propTypes = {
  initializeList: PropTypes.func.isRequired,
};

// defaultPropsの定義
InqReportsInfoHeader.defaultProps = {
};

const InqReportsInfoHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(InqReportsInfoHeader);

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    let params = {};
    if (!conditions.strCslDate) {
      const strCslDate = moment().format('YYYY/MM/DD');
      params = { ...conditions, strCslDate };
      dispatch(blur('hainsLogHeader', 'strCslDate', strCslDate));
    } else {
      params = { ...conditions };
    }
    if (!conditions.endCslDate) {
      const endCslDate = moment().format('YYYY/MM/DD');
      params = { ...params, endCslDate };
      dispatch(blur('hainsLogHeader', 'endCslDate', endCslDate));
    } else {
      params = { ...params };
    }
    if (!conditions.limit) {
      const limit = 50;
      const sendMode = 0;
      params = { ...params, sendMode, limit };
    }
    params = { startPos: 1, ...params };
    dispatch(getReportSendDateListRequest(params));
  },
  initializeList: () => {
    dispatch(initialReportSendDateList());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(InqReportsInfoHeaderForm));
