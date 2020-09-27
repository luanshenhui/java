import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import qs from 'qs';
import { Field, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import { getDmdBurdenListRequest, initializeDmdBurdenList, openDmdOrgMasterBurden, getNowTaxRequest } from '../../modules/bill/demandModule';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import OrgGuide from '../../containers/common/OrgGuide';
import OrgParameter from './OrgParameter';
import DmdOrgMasterBurden from './DmdOrgMasterBurden';
import MessageBanner from '../../components/MessageBanner';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import DmdBurdenModify from './DmdBurdenModify';

const delflgItemsDispatch = [{ value: 0, name: '' },
  { value: 2, name: '未発送のみ' },
  { value: 1, name: '発送済みのみ' }];
const delflgItemsPayment = [{ value: 0, name: '' },
  { value: 2, name: '未収のみ' },
  { value: 1, name: '入金済みのみ' }];
const delflgItems2 = [{ value: '*', name: '全データ' },
  { value: 10, name: '10件ずつ' },
  { value: 20, name: '20行ずつ' },
  { value: 50, name: '50行ずつ' }];
const formName = 'DmdBurdenListHeader';
const Font = styled.span`
    color:#${(props) => props.color};
`;
class DmdBurdenListHeader extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      // selectedItem: null,
    };
    this.handleDmdOrgMasterBurdenClick = this.handleDmdOrgMasterBurdenClick.bind(this);
  }
  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { location, onInitializeDmdBurdenList } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const qsparams = qs.parse(location.search, { ignoreQueryPrefix: true });
    // オブジェクトが空の場合は何もしない
    if (!Object.keys(qsparams).length) {
      onInitializeDmdBurdenList();
    }
    // オブジェクトが空でなければonSearchアクションの引数として渡す
    // onSearch(params);
  }
  // 請求書基本情報登録ガイドを開く
  handleDmdOrgMasterBurdenClick() {
    const { onOpenDmdOrgMasterBurden, onGetNowTax } = this.props;
    onGetNowTax();
    onOpenDmdOrgMasterBurden();
  }

  // 描画処理
  render() {
    const { message } = this.props;
    return (
      <div>
        <div>
          {message && message.map((rec) => (
            <Font key={rec} color="ff0000"><MessageBanner messages={rec} /></Font>
          ))}
        </div>
        <ListHeaderFormBase {...this.props} >
          <div>
            <FieldGroup>
              <FieldSet>
                <FieldItem>締め日</FieldItem>
                <Field name="strDate" component={DatePicker} id="" />
                <Label>～</Label>
                <Field name="endDate" component={DatePicker} id="" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求先</FieldItem>
                <OrgParameter {...this.props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgname" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求書No</FieldItem>
                <Field name="billNo" component={TextBox} id="" maxLength="14" style={{ imeMode: 'disabled', width: 180 }} />
                <Label name="">{} </Label>
                <FieldItem>請求書発送</FieldItem>
                <Field name="isDispatch" component={DropDown} items={delflgItemsDispatch} selectedValue="isDispatch" />
                <Label name=""> {}</Label>
                <FieldItem>未収</FieldItem>
                <Field name="isPayment" component={DropDown} items={delflgItemsPayment} selectedValue="isPayment" />
              </FieldSet>
              <FieldSet>
                <FieldItem>取消伝票</FieldItem>
                <Field component={CheckBox} name="isCancel" checkedValue="1" label="取消伝票も表示する" />
                <Label name="">{} </Label>
                <Field name="getCount" component={DropDown} items={delflgItems2} id="" />
              </FieldSet>
              <FieldSet>
                <Button type="submit" value="検 索" />
                <Button onClick={this.handleDmdOrgMasterBurdenClick} value="新 規" />
              </FieldSet>
            </FieldGroup>
          </div>
        </ListHeaderFormBase>
        <OrgGuide />
        <DmdOrgMasterBurden />
        <DmdBurdenModify />
      </div>
    );
  }
}

// propTypesの定義
DmdBurdenListHeader.propTypes = {
  onGetNowTax: PropTypes.func.isRequired,
  onOpenDmdOrgMasterBurden: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.array).isRequired,
  onInitializeDmdBurdenList: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
};

const DmdBurdenListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdBurdenListHeader);

const mapStateToProps = (state) => ({
  conditions: state.app.bill.demand.dmdBurdenList.conditions,
  message: state.app.bill.demand.dmdBurdenList.message,
  initialValues: {
    strDate: state.app.bill.demand.dmdBurdenList.conditions.strDate,
    endDate: state.app.bill.demand.dmdBurdenList.conditions.endDate,
    billNo: state.app.bill.demand.dmdBurdenList.conditions.billNo,
    orgCd1: state.app.bill.demand.dmdBurdenList.conditions.orgCd1,
    orgCd2: state.app.bill.demand.dmdBurdenList.conditions.orgCd2,
    isDispatch: state.app.bill.demand.dmdBurdenList.conditions.isDispatch,
    isPayment: state.app.bill.demand.dmdBurdenList.conditions.isPayment,
    isCancel: state.app.bill.demand.dmdBurdenList.conditions.isCancel,
    getCount: state.app.bill.demand.dmdBurdenList.conditions.getCount,
    sortName: state.app.bill.demand.dmdBurdenList.conditions.sortName,
    sortType: state.app.bill.demand.dmdBurdenList.conditions.sortType,
    orgname: state.app.bill.demand.dmdBurdenList.conditions.orgname,
  },

});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 請求書基本情報登録の適用税率取得
  onGetNowTax: () => {
    dispatch(getNowTaxRequest());
  },

  // 請求書基本情報登録 オープン
  onOpenDmdOrgMasterBurden: () => {
    dispatch(openDmdOrgMasterBurden());
  },
  onSearch: (conditions) => {
    const page = 1;
    const startPos = 1;
    if (!conditions.strDate) {
      dispatch(blur(formName, 'strDate', conditions.endDate));
    }
    if (!conditions.endDate) {
      dispatch(blur(formName, 'endDate', conditions.strDate));
    }
    dispatch(getDmdBurdenListRequest({ page, startPos, ...conditions }));
  },
  onLoad: (qsparams) => {
    dispatch(getDmdBurdenListRequest(qsparams));
  },
  onInitializeDmdBurdenList: () => {
    dispatch(initializeDmdBurdenList());
  },
  initializeList: () => {
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdBurdenListHeaderForm));
