import React from 'react';
import moment from 'moment';
import qs from 'qs';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import PageLayout from '../../layouts/PageLayout';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import DatePicker from '../../components/control/datepicker/DatePicker';
import TextBox from '../../components/control/TextBox';
import MessageBanner from '../../components/MessageBanner';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import { openOrgGuide } from '../../modules/preference/organizationModule';
import OrgGuide from '../common/OrgGuide';
import { dmdAddUpRequest, initializeAddUp } from '../../modules/bill/dmdAddUpModule';
import OrgParameter from './OrgParameter';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;

const formName = 'DmdAddUp';
class DmdAddUp extends React.Component {
  constructor(props) {
    super(props);
    const { match, conditions } = this.props;
    conditions.orgCd5Char = match.params.orgCd5Char;
    const myDate = new Date();
    const date = new Date(myDate.getFullYear(), myDate.getMonth(), 0);
    if (match.params.closeDate === undefined) {
      // 締め日のデフォルト値(前月の末日)を設定 ..... updated by C's
      conditions.closeDate = moment(`${myDate.getFullYear()}/${myDate.getMonth()}/${date.getDate()}`).format('YYYY/MM/DD');
      // 受診日(開始)のデフォルト値(前月の先頭日)を設定
      conditions.strDate = moment(`${myDate.getFullYear()}/${myDate.getMonth()}/1`).format('YYYY/MM/DD');
      // 受診日(終了)のデフォルト値(前月の末日)を設定
      conditions.endDate = moment(`${myDate.getFullYear()}/${myDate.getMonth()}/${date.getDate()}`).format('YYYY/MM/DD');
    } else {
      conditions.closeDate = moment(match.params.closeDate).format('YYYY/MM/DD');
      conditions.strDate = moment(match.params.strDate).format('YYYY/MM/DD');
      conditions.endDate = moment(match.params.endDate).format('YYYY/MM/DD');
    }
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handClick = this.handClick.bind(this);
  }

  componentDidMount() {
    const { location, initializeDmdAddUp, setValues } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    // オブジェクトが空の場合は何もしない
    if (!Object.keys(params).length) {
      // 初期化
      initializeDmdAddUp();
    } else if (!(params.orgCd5Char && params.checkboxOrgCd5Char)) {
      setValues('orgCd5Char', '');
      setValues('checkboxOrgCd5Char', null);
    }
  }
  componentWillReceiveProps(nextProps) {
    const { formValues, setValues } = this.props;
    if (formValues) {
      if (nextProps.formValues.orgCd1 && nextProps.formValues.orgCd1 !== formValues.orgCd1) {
        setValues('orgCd5Char', nextProps.formValues.orgCd1);
        setValues('checkboxOrgCd5Char', null);
      }
    }
  }
  // 「団体コードの先頭５桁を指定する」が変更された時の処理
  handClick() {
    const { formValues, setValues } = this.props;
    if (formValues.checkboxOrgCd5Char === '1') {
      setValues('orgCd5Char', null);
    }
    setValues('orgCd1', null);
    setValues('orgCd2', null);
    setValues('orgname', null);
    setValues('checkboxOrgCd5Char', formValues.checkboxOrgCd5Char === '1' ? null : '1');
  }
  // ログ参照ボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    const date = moment().format('YYYY/MM/DD');
    const [year, mon, day] = [date.substring(0, 4), date.substring(5, 7), date.substring(8, 10)];
    history.push(`/contents/preference/hainslog?transactionDiv=LOGBILLC&mode=print&insDate=${year}%2F${mon}%2F${day}`);
  }

  // 描画処理
  render() {
    const { message, err } = this.props;
    return (
      <PageLayout title="請求締め処理">
        <ListHeaderFormBase {...this.props} >
          <div>
            <Font color={err === 'err' ? 'FF0000' : 'FF6600'}>
              <MessageBanner messages={message} />
            </Font>
            <FieldGroup itemWidth={100}>
              <FieldSet>
                <FieldItem>締め日</FieldItem>
                <Field name="closeDate" component={DatePicker} id="closeDate" />
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日範囲</FieldItem>
                <Field name="strDate" component={DatePicker} id="strDate" />
                <Label>～</Label>
                <Field name="endDate" component={DatePicker} id="endDate" />
              </FieldSet>
              <FieldSet>
                <FieldItem name="">負担団体</FieldItem>
                <FieldSet>
                  <OrgParameter {...this.props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgname" />
                </FieldSet>
              </FieldSet>
              <FieldSet>
                <div style={{ marginLeft: '85px' }} >
                  <Field component={CheckBox} name="checkboxOrgCd5Char" checkedValue="1" label="団体コードの先頭５桁を指定する" style={{ imeMode: 'disabled' }} onChange={this.handClick} />
                  <Field name="orgCd5Char" component={TextBox} id="orgCd5Char" maxLength="5" style={{ imeMode: 'disabled', width: 80 }} />
                </div>
              </FieldSet>
              <FieldSet>
                <FieldItem >コース</FieldItem>
                <Field name="courseCd" component={DropDownCourse} id="csCd" blankname="全てのコース" addblank />
              </FieldSet>
              <div style={{ paddingTop: 20 }}>
                <FieldSet>
                  <Button value="ログ参照" onClick={this.handleCancelClick} />
                  <div style={{ paddingLeft: 20 }}>
                    <Button type="submit" value="確 定" />
                  </div>
                </FieldSet>
              </div>
            </FieldGroup>
          </div>
        </ListHeaderFormBase>
        <OrgGuide />
      </PageLayout>
    );
  }
}

// propTypesの定義
DmdAddUp.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  err: PropTypes.string.isRequired,
  formValues: PropTypes.shape(),
  onOpenOrgGuide: PropTypes.func.isRequired,
  initializeDmdAddUp: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
  setValues: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
};
// defaultPropsの定義
DmdAddUp.defaultProps = {
  formValues: undefined,
};

const DmdAddUpForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdAddUp);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      closeDate: state.app.bill.dmdAddUp.demandAddUp.conditions.closeDate,
      strDate: state.app.bill.dmdAddUp.demandAddUp.conditions.strDate,
      endDate: state.app.bill.dmdAddUp.demandAddUp.conditions.endDate,
      orgCd1: state.app.bill.dmdAddUp.demandAddUp.conditions.orgCd1,
      orgCd2: state.app.bill.dmdAddUp.demandAddUp.conditions.orgCd2,
      orgname: state.app.bill.dmdAddUp.demandAddUp.conditions.orgname,
      checkboxOrgCd5Char: state.app.bill.dmdAddUp.demandAddUp.conditions.checkboxOrgCd5Char,
      orgCd5Char: state.app.bill.dmdAddUp.demandAddUp.conditions.orgCd5Char,
      courseCd: state.app.bill.dmdAddUp.demandAddUp.conditions.courseCd,
    },
    formValues,
    conditions: state.app.bill.dmdAddUp.demandAddUp.conditions,
    message: state.app.bill.dmdAddUp.demandAddUp.message,
    err: state.app.bill.dmdAddUp.demandAddUp.err,
    data: state.app.bill.dmdAddUp.demandAddUp.data,
  };
};
const mapDispatchToProps = (dispatch) => ({
  initializeDmdAddUp: () => {
    dispatch(initializeAddUp());
  },
  initializeList: () => {
  },
  // 入力チェックの処理
  onSearch: (values) => {
    const blur1 = (formname, name, value) => {
      dispatch(blur(formname, name, value));
    };
    dispatch(dmdAddUpRequest({ values, blur1 }));
  },
  onOpenOrgGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openOrgGuide());
  },
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdAddUpForm));
