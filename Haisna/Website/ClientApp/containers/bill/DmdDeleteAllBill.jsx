import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, getFormValues } from 'redux-form';
import PageLayout from '../../layouts/PageLayout';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import DatePicker from '../../components/control/datepicker/DatePicker';
import OrgGuide from '../common/OrgGuide';
import OrgParameter from './OrgParameter';
import MessageBanner from '../../components/MessageBanner';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import { openOrgGuide } from '../../modules/preference/organizationModule';
import { deleteAllBillRequest, initializeDelAllBill } from '../../modules/bill/demandModule';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;
const formName = 'DmdDeleteAllBill';
class DmdDeleteAllBill extends React.Component {
  constructor(props) {
    super(props);
    const { match, conditions } = this.props;
    this.closeDate = match.params.closeDate;
    if (this.closeDate !== undefined) {
      conditions.closeDate = this.closeDate;
    }
  }
  componentDidMount() {
    const { initializePage, location } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    // オブジェクトが空の場合は何もしない
    if (!Object.keys(params).length) {
      initializePage();
    }
  }
  // 描画処理
  render() {
    const { message, err } = this.props;
    return (
      <PageLayout title="請求書削除">
        <ListHeaderFormBase {...this.props} >
          <div>
            <Font color={err === 'err' ? 'FF0000' : 'FF9900'} size="14"><MessageBanner messages={message} /></Font>
            <FieldGroup itemWidth={70}>
              <FieldSet>
                <FieldItem>締め日</FieldItem>
                <Field name="closeDate" component={DatePicker} id="closeDate" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求先</FieldItem>
                <OrgParameter {...this.props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgname" />
              </FieldSet>
              <div style={{ paddingLeft: 300 }}>
                <Button value="削 除" type="submit" />
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
DmdDeleteAllBill.propTypes = {
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  onOpenOrgGuide: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  initializePage: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
  err: PropTypes.string.isRequired,
};
// defaultPropsの定義
DmdDeleteAllBill.defaultProps = {
};

const DmdDeleteAllBillForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdDeleteAllBill);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      closeDate: state.app.bill.demand.demandDelete.conditions.closeDate,
      orgCd1: state.app.bill.demand.demandDelete.conditions.orgCd1,
      orgCd2: state.app.bill.demand.demandDelete.conditions.orgCd2,
      orgname: state.app.bill.demand.demandDelete.conditions.orgname,
    },
    formValues,
    conditions: state.app.bill.demand.demandDelete.conditions,
    message: state.app.bill.demand.demandDelete.message,
    err: state.app.bill.demand.demandDelete.err,
  };
};
const mapDispatchToProps = (dispatch) => ({
  initializeList: () => {
  },
  // 画面初期化
  initializePage: () => {
    dispatch(initializeDelAllBill());
  },
  onOpenOrgGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openOrgGuide());
  },
  // 条件に合致する請求情報を検索
  onSearch: (data) => {
    dispatch(deleteAllBillRequest({ data }));
  },

});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdDeleteAllBillForm));
