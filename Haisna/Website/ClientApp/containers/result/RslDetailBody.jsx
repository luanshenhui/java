import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, FieldArray, blur, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import SearchResult from './SearchResult';
import RslCmtGuide from '../../containers/common/RslCmtGuide';
import { openRslCmtGuide } from '../../modules/preference/rslCmtModule';


const formName = 'RslDetailBody';

class RslDetailBody extends React.Component {
  constructor(props) {
    super(props);

    this.handleonOpenRslCmtGuide = this.handleonOpenRslCmtGuide.bind(this);
    this.handleSelectedRslCmtGuide = this.handleSelectedRslCmtGuide.bind(this);
    this.callStcGuide = this.callStcGuide.bind(this);
    this.handleResultChange = this.handleResultChange.bind(this);
    this.handleRslcmtcd1Change = this.handleRslcmtcd1Change.bind(this);
    this.handleRslcmtcd2Change = this.handleRslcmtcd2Change.bind(this);
  }

  // 結果コメントガイド呼び出し
  handleonOpenRslCmtGuide(rslCmtGuideTargets) {
    const { onOpenRslCmtGuide } = this.props;
    onOpenRslCmtGuide(rslCmtGuideTargets);
  }
  // 定性ガイド呼び出し
  callStcGuide(itemgrpdata, sentenceGuideOpenTargets) {
    const { setValue } = this.props;
    setValue(sentenceGuideOpenTargets.result, itemgrpdata.stcCd);
    setValue(sentenceGuideOpenTargets.shortstc, itemgrpdata.shortStc);
  }
  // 検査結果の編集
  handleResultChange(event, index) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`rslListData.[${index}].result`, target.value);
  }
  // コメント1の編集
  handleRslcmtcd1Change(event, index) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`rslListData.[${index}].rslcmtcd1`, target.value);
  }
  // コメント2の編集
  handleRslcmtcd2Change(event, index) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`rslListData.[${index}].rslcmtcd2`, target.value);
  }

  handleSelectedRslCmtGuide(item) {
    const { setValue, rslCmtGuideTargets } = this.props;
    setValue(rslCmtGuideTargets.rslcmtcd, item.rslcmtcd);
    setValue(rslCmtGuideTargets.rslcmtname, item.rslcmtname);
  }

  // 描画処理
  render() {
    const { formValues } = this.props;
    return (
      <div>
        <FieldArray
          name="rslListData"
          component={SearchResult}
          handleonOpenRslCmtGuide={this.handleonOpenRslCmtGuide}
          handleResultChange={this.handleResultChange}
          handleRslcmtcd1Change={this.handleRslcmtcd1Change}
          handleRslcmtcd2Change={this.handleRslcmtcd2Change}
          callStcGuide={this.callStcGuide}
          callTseGuide={this.callTseGuide}
          formValues={formValues}
        />
        <RslCmtGuide onSelected={this.handleSelectedRslCmtGuide} />
      </div>
    );
  }
}

// propTypesの定義
RslDetailBody.propTypes = {
  onOpenRslCmtGuide: PropTypes.func.isRequired,
  rslCmtGuideTargets: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  setValue: PropTypes.func.isRequired,

};

RslDetailBody.defaultProps = {
  formValues: undefined,
};

const RslDetailBodyForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslDetailBody);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      rslListData: state.app.result.result.rslDailyList.rslListData.item,
      resultFlg: state.app.result.result.rslDetail.resultFlg,
      resulterror: state.app.result.result.rslDetail.resulterror,
      rslcmterror1: state.app.result.result.rslDetail.rslcmterror1,
      rslcmterror2: state.app.result.result.rslDetail.rslcmterror2,
      lastInfo: state.app.result.result.rslDailyList.lastInfo,
    },
    rslListData: state.app.result.result.rslDailyList.rslListData.item,
    rslCmtGuideTargets: state.app.preference.rslCmt.guide.rslCmtGuideTargets,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onOpenRslCmtGuide: (rslCmtGuideTargets) => {
    // 開くアクションを呼び出す
    dispatch(openRslCmtGuide({ rslCmtGuideTargets }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslDetailBodyForm));
