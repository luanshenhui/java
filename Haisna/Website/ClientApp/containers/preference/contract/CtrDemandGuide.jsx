import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import GuideBase from '../../../components/common/GuideBase';
import { getCtrPtOrgPriceRequest, closeDemandGuide, initializeDemand,
  insertContractRequest, updateContractRequest } from '../../../modules/preference/contractModule';
import CtrDemandBody from './CtrDemandBody';
import CtrDemandHeader from './CtrDemandHeader';

const formName = 'ctrCreateForm';


class CtrDemandGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad, params, formValues, newmode } = this.props;
    // 新規モードの場合
    if (newmode) {
      // onLoadアクションの引数として渡す
      params.cscd = formValues.cscd;
      onLoad(params);
    }
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { onLoad, visible, params, newmode } = this.props;
    // 編集モードの場合
    if (!newmode) {
      if (nextProps.visible !== visible && !visible) {
        // onLoadアクションの引数として渡す
        params.cscd = nextProps.csCd;
        params.ctrptcd = nextProps.ctrPtCd;
        params.orgcd1 = nextProps.orgCd1;
        params.orgcd2 = nextProps.orgCd2;
        onLoad(params);
      }
    }
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  // 保存
  handleSubmit(values) {
    const { match, onSubmit, initialValues, params } = this.props;

    const burdens = [];

    const objValues = {};

    objValues.orgcd1 = params.orgcd1;
    objValues.orgcd2 = params.orgcd2;
    objValues.csCd = params.cscd;
    objValues.ctrPtCd = params.ctrptcd;
    objValues.strdate = moment(values.strdate).format('YYYY/MM/DD');
    objValues.enddate = moment(values.enddate).format('YYYY/MM/DD');

    let seqMax = 0;

    for (let i = 0; i < initialValues.orgcd1.length; i += 1) {
      if (initialValues.seq[i] != null && initialValues.seq[i] !== undefined) {
        burdens.push({
          apdiv: initialValues.apdiv[i],
          seq: initialValues.seq[0] + seqMax,
          orgcd1: initialValues.orgcd1[i],
          orgcd2: initialValues.orgcd2[i],
          price: initialValues.price[i],
          taxflg: initialValues.taxflg[i],
        });
        seqMax += 1;
      }
    }
    objValues.burdens = burdens;

    onSubmit(match.params, objValues);
  }

  render() {
    const { handleSubmit, message, newmode, onBack, params, formValues } = this.props;

    return (
      <div>
        {
          newmode ?
            <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
              <div>
                <Button onClick={onBack} value="戻 る" />
                <Button type="submit" value="保存" />
              </div>
              <MessageBanner messages={message} />
              <CtrDemandHeader params={{ ...params, cscd: formValues.cscd, strdate: formValues.strdate, enddate: formValues.enddate }} newmode />
              <CtrDemandBody params={{ ...params, cscd: formValues.cscd }} newmode />
            </form >
            :
            <GuideBase {...this.props} title="負担元の設定" usePagination={false}>
              <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
                <div>
                  <Button onClick={this.handleCancelClick} value="キャンセル" />
                  <Button type="submit" value="保存" />
                </div>
                <MessageBanner messages={message} />
                <CtrDemandHeader params={{ ...params, cscd: formValues.cscd, strdate: formValues.strdate, enddate: formValues.enddate }} newmode />
                <CtrDemandBody params={{ ...params, cscd: formValues.cscd }} newmode />
              </form>
            </GuideBase>
        }
      </div>
    );
  }
}
const CtrCreateForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(CtrDemandGuide);

// propTypesの定義
CtrDemandGuide.propTypes = {
  onBack: PropTypes.func,
  newmode: PropTypes.bool,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  match: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  initialValues: PropTypes.shape().isRequired,
  ctrPtCd: PropTypes.string,
  orgCd1: PropTypes.string,
  orgCd2: PropTypes.string,
  csCd: PropTypes.string,
  visible: PropTypes.bool,
  formValues: PropTypes.shape(),
  params: PropTypes.shape(),
};

CtrDemandGuide.defaultProps = {
  formValues: {},
  params: {},
  newmode: false,
  visible: false,
  orgCd1: null,
  orgCd2: null,
  ctrPtCd: null,
  csCd: null,
  onBack: () => ({}),
};


const mapStateToProps = (state, props) => {
  const formValues = getFormValues(formName)(state);
  return {
    visible: state.app.preference.contract.ctrDemandGuide.visible,
    message: state.app.preference.contract.ctrDemandGuide.message,
    formValues,
    initialValues: {
      rowCount: state.app.preference.contract.ctrDemandGuide.rowCount,
      selectedCount: state.app.preference.contract.ctrDemandGuide.selectedCount,
      selectedContent: state.app.preference.contract.ctrDemandGuide.selectedContent,
      selectedNowCount: state.app.preference.contract.ctrDemandGuide.selectedNowCount,
      apdiv: state.app.preference.contract.ctrDemandGuide.apdiv,
      strOptBurden: state.app.preference.contract.ctrDemandGuide.strOptBurden,
      strLimitPriceFlg: state.app.preference.contract.ctrDemandGuide.strLimitPriceFlg,
      orgcd1: state.app.preference.contract.ctrDemandGuide.orgcd1,
      orgcd2: state.app.preference.contract.ctrDemandGuide.orgcd2,
      seq: state.app.preference.contract.ctrDemandGuide.seq,
      price: state.app.preference.contract.ctrDemandGuide.price,
      taxflg: state.app.preference.contract.ctrDemandGuide.taxflg,
      deleteflg: state.app.preference.contract.ctrDemandGuide.deleteflg,
      strdate: formValues ? formValues.strdate : props.strdate,
      enddate: formValues ? formValues.enddate : props.enddate,
      cscd: formValues ? formValues.cscd : props.csCd,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    dispatch(initializeDemand());
    // 閉じるアクションを呼び出す
    dispatch(closeDemandGuide());
  },
  // 保存ボタン押下時の処理
  onSubmit: (params, data) => {
    if (params.ctrptcd !== null && params.ctrptcd !== undefined && params.ctrptcd !== '') {
      dispatch(updateContractRequest({ ...params, data }));
    } else {
      dispatch(insertContractRequest({ ...params, data }));
    }
  },
  // 画面を初期化
  onLoad: (params) => {
    dispatch(initializeDemand());
    if (params.ctrptcd != null && params.ctrptcd !== undefined && params.ctrptcd !== '') {
      dispatch(getCtrPtOrgPriceRequest({ ...params }));
    }
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrCreateForm));
