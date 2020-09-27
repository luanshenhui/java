import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import Button from '../../../components/control/Button';
import SectionBar from '../../../components/SectionBar';
import DropDownCourse from '../../../components/control/dropdown/DropDownCourse';
import DropDownFreeValue from '../../../components/control/dropdown/DropDownFreeValue';
import DropDownSetClass from '../../../components/control/dropdown/DropDownSetClass';
import DropDown from '../../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import CtrSetGuide from './CtrSetGuide';
import { getPriceOptAllRequest, getCtrPtOrgPriceRequest, openCtrSetGuide } from '../../../modules/preference/contractModule';
import { getOrgRequest } from '../../../modules/preference/organizationModule';

const Wrapper = styled.div`
   margin-right:10px;
`;

const formName = 'CtrDetailListSetPtHeader';
// 性別
const genderItems = [{ value: 0, name: '男女共通' }, { value: 1, name: '男性のみ' }, { value: 2, name: '女性のみ' }];
// 年齢
const ageItems = [...Array(150)].map((v, i) => ({ value: i + 1, name: (i + 1).toString() }));

class CtrDetailListSetPtHeader extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
    this.ctrptcd = match.params.ctrptcd;
    this.cscd = match.params.cscd;
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { detailRefresh, onSubmit, formValues } = this.props;
    if (nextProps.detailRefresh !== detailRefresh && nextProps.detailRefresh) {
      const { params } = this.props.match;
      onSubmit(params.ctrptcd, formValues);
    }
  }

  // 表示ボタンクリック時の処理
  handleSubmit(values) {
    const { match, onSubmit } = this.props;
    onSubmit(match.params.ctrptcd, values);
  }

  render() {
    const { match, handleSubmit, onOpenCtrSetGuide } = this.props;

    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <SectionBar title="検査セットの一覧" />
          <div>
            <Button onClick={() => { onOpenCtrSetGuide('INS', null, null); }} value="新 規" />
            <Button type="submit" value="表示" />
          </div>
          <FieldGroup itemWidth={90}>
            <FieldSet>
              <FieldItem>管理コース</FieldItem>
              <Field name="csCd" component={DropDownCourse} mode={2} addblank blankname="すべて" /><Wrapper />
              <FieldItem> セット分類</FieldItem>
              <Field name="setClassCd" component={DropDownSetClass} addblank blankname="すべて" /><Wrapper />
              <FieldItem>受診区分</FieldItem>
              <Field name="cslDivCd" component={DropDownFreeValue} freecd="cslDiv" addblank blankname="すべて" /><Wrapper />
            </FieldSet>
          </FieldGroup>
          <FieldGroup itemWidth={90}>
            <FieldSet>
              <FieldItem>性別</FieldItem>
              <Field name="gender" component={DropDown} items={genderItems} /><Wrapper />
              <FieldItem>年齢</FieldItem>
              <Field name="strAge" component={DropDown} items={ageItems} addblank />～ <Field name="endAge" component={DropDown} items={ageItems} addblank />
            </FieldSet>
          </FieldGroup>
        </form>
        <CtrSetGuide orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} ctrptcd={match.params.ctrptcd} />
      </div>
    );
  }
}

// propTypesの定義
CtrDetailListSetPtHeader.propTypes = {
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onOpenCtrSetGuide: PropTypes.func.isRequired,
  detailRefresh: PropTypes.bool.isRequired,
  formValues: PropTypes.shape(),
};

CtrDetailListSetPtHeader.defaultProps = {
  formValues: undefined,
};

const CtrDetailListSetPtHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
})(CtrDetailListSetPtHeader);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    csCd: state.app.preference.contract.ctrDetailList.csCd,
    setClassCd: state.app.preference.contract.ctrDetailList.setClassCd,
    gender: state.app.preference.contract.ctrDetailList.gender,
    cslDivCd: state.app.preference.contract.ctrDetailList.cslDivCd,
    strAge: state.app.preference.contract.ctrDetailList.strAge,
    endAge: state.app.preference.contract.ctrDetailList.endAge,
    message: state.app.preference.contract.ctrDetailList.message,
    detailRefresh: state.app.preference.contract.ctrDetailList.detailRefresh,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    // オプション検査情報読み込み
    const priceOptAlparams = { ctrptcd: params.ctrptcd };
    dispatch(getPriceOptAllRequest(priceOptAlparams));
    // 負担元読み込み
    dispatch(getCtrPtOrgPriceRequest(params));
    // 自団体略称の読み込み
    dispatch(getOrgRequest({ params }));
  },
  // 表示ボタンクリック時の処理
  onSubmit: (params, data) => {
    // オプション検査情報読み込み
    dispatch(getPriceOptAllRequest({ ctrptcd: params, ...data }));
  },
  // 検査セット登録画面を表示
  onOpenCtrSetGuide: (mode, optcd, optbranchno) => {
    dispatch(openCtrSetGuide({ mode, optcd, optbranchno }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrDetailListSetPtHeaderForm));
