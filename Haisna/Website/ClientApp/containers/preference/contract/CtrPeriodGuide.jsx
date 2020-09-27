import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, getFormValues, initialize } from 'redux-form';
import { connect } from 'react-redux';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import GuideBase from '../../../components/common/GuideBase';
import CtrPeriodBody from './CtrPeriodBody';

import { getCtrPtRequest, getCtrMngWithPeriodRequest, closePeriodGuide, updatePeriodRequest } from '../../../modules/preference/contractModule';
import { getCourseHistoryRequest } from '../../../modules/preference/courseModule';

const formName = 'ctrCreateForm';

class CtrPeriodGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmitClick = this.handleSubmitClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
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
        params.orgcd1 = nextProps.orgcd1;
        params.orgcd2 = nextProps.orgcd2;
        onLoad(params);
      }
    }
  }

  // 「キャンセル」「戻る」ボタンクリック時の処理
  handleCancelClick() {
    const { onClose, newmode, onBack } = this.props;
    if (newmode) {
      onBack();
    } else {
      onClose();
    }
  }

  // 「次へ」「保存」ボタン押下時の処理
  handleSubmitClick() {
    const { onSubmit, onNext, params, newmode, formValues } = this.props;

    const data = { cscd: formValues.cscd, strdate: formValues.strdate, enddate: formValues.enddate };
    if (newmode) {
      onNext(params, data);
    } else {
      onSubmit(params, data);
    }
  }

  render() {
    const { handleSubmit, message, dtmArrDate, courseHistoryData, params, formValues, newmode } = this.props;

    return (
      <div>
        {
          newmode ?
            <div style={{ height: '600px', overflow: 'auto' }}>
              <form>
                <div>
                  <Button onClick={this.handleCancelClick} value="戻 る" />
                  <Button onClick={this.handleSubmitClick} value="次 へ" />
                </div>
                <MessageBanner messages={message} />
                <CtrPeriodBody courseHistoryData={courseHistoryData} dtmArrDate={dtmArrDate} params={{ ...params, cscd: formValues.cscd }} newmode />
              </form >
            </div>
            :
            <GuideBase {...this.props} title="契約期間の指定" usePagination={false}>
              <div style={{ height: '600px', overflow: 'auto' }}>
                <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
                  <MessageBanner messages={message} />
                  <div>
                    <Button onClick={this.handleCancelClick} value="キャンセル" />
                    <Button onClick={this.handleSubmitClick} value="保存" />
                  </div>
                  <CtrPeriodBody courseHistoryData={courseHistoryData} dtmArrDate={dtmArrDate} params={params} />
                </form>
              </div>
            </GuideBase>
        }
      </div>
    );
  }
}

const CtrCreateForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(CtrPeriodGuide);

// propTypesの定義
CtrPeriodGuide.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  dtmArrDate: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  courseHistoryData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  orgcd1: PropTypes.string,
  orgcd2: PropTypes.string,
  visible: PropTypes.bool,
  formValues: PropTypes.shape(),
  params: PropTypes.shape(),
  csCd: PropTypes.string,
  ctrPtCd: PropTypes.string,
  onNext: PropTypes.func,
  onBack: PropTypes.func,
  newmode: PropTypes.bool,
};

CtrPeriodGuide.defaultProps = {
  formValues: {
    strdate: undefined,
    enddate: undefined,
  },
  params: {},
  orgcd1: null,
  orgcd2: null,
  ctrPtCd: null,
  csCd: null,
  newmode: false,
  visible: false,
  onBack: () => { },
  onNext: () => { },
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state, props) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    visible: state.app.preference.contract.ctrPeriodGuide.visible,
    message: state.app.preference.contract.ctrPeriodGuide.message,
    courseHistoryData: state.app.preference.course.courseHistory.courseHistoryData,
    dtmArrDate: state.app.preference.contract.ctrPeriodGuide.dtmArrDate,
    initialValues: {
      cscd: formValues ? formValues.cscd : props.csCd,
      strdate: state.app.preference.contract.ctrPeriodGuide.ctrPtData.strdate,
      enddate: state.app.preference.contract.ctrPeriodGuide.ctrPtData.enddate,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  // 画面を初期化
  onLoad: (params) => {
    const { newmode } = props;
    // 編集モードの場合
    if (!newmode) {
      dispatch(getCtrPtRequest({ ...params }));
    }
    dispatch(getCtrMngWithPeriodRequest({ ...params }));
    dispatch(getCourseHistoryRequest({ ...params }));
  },
  // 編集モードの場合クローズ時の処理
  onClose: () => {
    const { initialValues } = props;
    dispatch(initialize(formName, initialValues));
    // 閉じるアクションを呼び出す
    dispatch(closePeriodGuide());
  },
  // 次へボタン押下時(即ち新規時)の処理
  onNext: (params, data) => {
    const { onNext } = props;
    // 新規時(guide)
    const actmode = 'guide';
    Object.assign(data, params);
    // 新規契約作成時は負担元・負担金額の設定へ
    dispatch(updatePeriodRequest({ onNext, data, actmode }));
  },
  // 保存ボタン押下時の処理
  onSubmit: (params, data) => {
    const { orgcd1, orgcd2, cscd, ctrptcd } = params;
    // 契約期間の更新
    dispatch(updatePeriodRequest({ params, data: { ...data, orgcd1, orgcd2, cscd, ctrptcd } }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrCreateForm);
