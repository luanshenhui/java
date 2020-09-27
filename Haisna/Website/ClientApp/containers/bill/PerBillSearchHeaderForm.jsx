import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import qs from 'qs';
import moment from 'moment';
import { Field, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import { getPerBillListRequest, initializePerBillSearch, getUrlValues } from '../../modules/bill/perBillModule';
import OrgGuide from '../common/OrgGuide';
import OrgParameter from './OrgParameter';
import PersonParameter from './PersonParameter';
import PersonGuide from '../common/PersonGuide';
import MessageBanner from '../../components/MessageBanner';

const delflgItems = [
  { value: 0, name: 'すべて' },
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 200, name: '200行ずつ' },
  { value: 300, name: '300行ずつ' }];
// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;
const formName = 'PerBillSearchHeaderForm';

class PerBillSearchHeaderForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { };
  }
  // 最初のクエリ
  componentDidMount() {
    const { onLoad, location, initializePerBill } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    // オブジェクトが空の場合は何もしない
    if (!Object.keys(params).length) {
      initializePerBill();
      onLoad({ paymentflg: null, delDisp: '1', branchNos: '', pageMaxLine: 0, startDmdDate: moment().format('YYYY/MM/DD'), endDmdDate: moment().format('YYYY/MM/DD') });
    }
  }
  componentWillUnmount() {
    const { location, getUrlParams } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    getUrlParams(params);
  }

  // 描画処理
  render() {
    const { message } = this.props;
    return (
      <div>
        <ListHeaderFormBase {...this.props} >
          <div>
            <FieldGroup itemWidth={100}>
              <Font color="FF0000" size="14"><MessageBanner messages={message} /></Font>
              <FieldSet>
                <FieldItem >請求日範囲</FieldItem>
                <Field name="startDmdDate" component={DatePicker} id="startDmdDate" />
                <Label>～</Label>
                <Field name="endDmdDate" component={DatePicker} id="endDmdDate" />
              </FieldSet>
              <FieldSet >
                <FieldItem >団体コード</FieldItem>
                <FieldSet>
                  <OrgParameter {...this.props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgname" />
                </FieldSet>
              </FieldSet>
              <FieldSet>
                <FieldItem >個人ＩＤ</FieldItem>
                <FieldSet>
                  <PersonParameter {...this.props} formName={formName} peridField="perId" lastNameField="lastName" firstNameField="firstName" />
                </FieldSet>
              </FieldSet>
              <FieldSet>
                <FieldItem >請求書No</FieldItem>
                <Field name="branchNos" component={TextBox} id="branchNos" style={{ width: 180 }} />
                <Label>{}</Label>
                <Field component={CheckBox} name="paymentflg" checkedValue="1" label="未収請求書のみ表示" />
                <Label>{}</Label>
                <Field component={CheckBox} name="delDisp" checkedValue="1" label="取消伝票は表示しない" />
                <Label>{}</Label>
                <Field name="pageMaxLine" component={DropDown} items={delflgItems} id="pageMaxLine" />
                <Label>{}</Label>
                <Button type="submit" value="検 索" />
              </FieldSet>
            </FieldGroup>
          </div>
        </ListHeaderFormBase>
        <OrgGuide />
        <PersonGuide />
      </div>
    );
  }
}

// propTypesの定義
PerBillSearchHeaderForm.propTypes = {
  match: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  initializePerBill: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  location: PropTypes.shape().isRequired,
  initializeList: PropTypes.func.isRequired,
  getUrlParams: PropTypes.func.isRequired,
};

const PerBillSearchHeaderform = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(PerBillSearchHeaderForm);

const mapStateToProps = (state) => ({
  message: state.app.bill.perBill.perBillSearch.message,
  initialValues: {
    startDmdDate: state.app.bill.perBill.perBillSearch.conditions.startDmdDate,
    endDmdDate: state.app.bill.perBill.perBillSearch.conditions.endDmdDate,
    branchNos: state.app.bill.perBill.perBillSearch.conditions.branchNos,
    paymentflg: state.app.bill.perBill.perBillSearch.conditions.paymentflg,
    delDisp: state.app.bill.perBill.perBillSearch.conditions.delDisp,
    pageMaxLine: state.app.bill.perBill.perBillSearch.conditions.pageMaxLine,
    orgCd1: state.app.bill.perBill.perBillSearch.conditions.orgCd1,
    orgCd2: state.app.bill.perBill.perBillSearch.conditions.orgCd2,
    orgname: state.app.bill.perBill.perBillSearch.conditions.orgname,
    perId: state.app.bill.perBill.perBillSearch.conditions.perId,
    lastName: state.app.bill.perBill.perBillSearch.conditions.lastName,
    firstName: state.app.bill.perBill.perBillSearch.conditions.firstName,
  },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const page = 1;
    if (!conditions.startDmdDate) {
      dispatch(blur(formName, 'startDmdDate', moment().format('YYYY/MM/DD')));
    }
    if (!conditions.endDmdDate) {
      dispatch(blur(formName, 'endDmdDate', moment().format('YYYY/MM/DD')));
    }
    dispatch(getPerBillListRequest({ page, ...conditions }));
  },
  onLoad: (conditions) => {
    const page = 1;
    dispatch(getPerBillListRequest({ page, ...conditions }));
  },
  initializeList: () => {
  },
  initializePerBill: () => {
    dispatch(initializePerBillSearch());
  },
  getUrlParams: (params) => {
    dispatch(getUrlValues(params));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(PerBillSearchHeaderform));
