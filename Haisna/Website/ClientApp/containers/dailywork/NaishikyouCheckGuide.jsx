import React from 'react';
import PropTypes from 'prop-types';
import { blur, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import Button from '../../components/control/Button';
import NaishikyouCheckGuideHeader from './NaishikyouCheckGuideHeader';
import NaishikyouCheckGuideBody from './NaishikyouCheckGuideBody';
import { updateResultNoCmtRequest, closeNaishikyouCheckGuide } from '../../modules/result/resultModule';
import { initOcrNyuryoku } from '../../modules/dailywork/questionnaireModule';

const formName = 'NaishikyouCheckGuideForm';

const WrapperButton = styled.div`
  margin-top: 5px;
  margin-bottom: 10px;
`;

const MainDiv = styled.div`
   width: 960px;
   height:880px;
   overflow-y: auto
`;

const WrapperMargin = styled.div`
   margin-right:20px;
   float:left;
`;

class NaishikyouCheckGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 登録
  handleSubmit(values) {
    const { onSubmit, rsvno, historyrsldata } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit({ rsvno, historyrsldata }, values);
  }

  render() {
    const { handleSubmit, message, consultdata, realage } = this.props;
    return (
      <GuideBase {...this.props} title="内視鏡チェックリスト入力" usePagination={false}>
        <MainDiv>
          <MessageBanner messages={message} />
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <NaishikyouCheckGuideHeader data={consultdata} realage={realage} />
            <WrapperButton><Button type="submit" value="保存" /></WrapperButton>
            <div>
              <WrapperMargin><NaishikyouCheckGuideBody {...this.props} /></WrapperMargin>
            </div>
          </form>
        </MainDiv>
      </GuideBase>
    );
  }
}

const NaishikyouCheckGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(NaishikyouCheckGuide);

// propTypesの定義
NaishikyouCheckGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  consultdata: PropTypes.shape().isRequired,
  historyrsldata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  realage: PropTypes.number,
  reset: PropTypes.func.isRequired,
  rsvno: PropTypes.string,
  setValue: PropTypes.func.isRequired,
};

// defaultPropsの定義
NaishikyouCheckGuide.defaultProps = {
  realage: null,
  rsvno: null,
};

const mapStateToProps = (state) => ({
  initialValues: state.app.result.result.naishikyouCheckGuide.checkitems,
  message: state.app.result.result.naishikyouCheckGuide.message,
  visible: state.app.result.result.naishikyouCheckGuide.visible,
  consultdata: state.app.result.result.naishikyouCheckGuide.consultdata,
  historyrsldata: state.app.result.result.naishikyouCheckGuide.historyrsldata,
  realage: state.app.result.result.naishikyouCheckGuide.realage,
  rsvno: state.app.result.result.naishikyouCheckGuide.rsvno,
  checkitems: state.app.result.result.naishikyouCheckGuide.checkitems,
});

const mapDispatchToProps = (dispatch) => ({

  onSubmit: (params, data) => {
    dispatch(updateResultNoCmtRequest({ params, data }));
  },

  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeNaishikyouCheckGuide());
    dispatch(initOcrNyuryoku());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(NaishikyouCheckGuideForm);

