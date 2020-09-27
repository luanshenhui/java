import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import Button from '../../components/control/Button';
import BulletedLabel from '../../components/control/BulletedLabel';
import ChangeOptionGuideHeaderForm from './ChangeOptionGuideHeaderForm';
import ChangeOptionGuideBody1 from './ChangeOptionGuideBody1';
import ChangeOptionGuideBody2 from './ChangeOptionGuideBody2';
import { openRslCmtGuide } from '../../modules/preference/rslCmtModule';
import RslCmtGuide from '../common/RslCmtGuide';
import { updateResultForChangeSetRequest, clearRslCmtInfo, closeChangeOptionGuide } from '../../modules/reserve/consultModule';
import { initOcrNyuryoku } from '../../modules/dailywork/questionnaireModule';

const formName = 'ChangeOptionGuideForm';

const WrapperButton = styled.div`
  margin-top: 5px;
  margin-bottom: 10px;
`;

const WrapperBulleted = styled.div`
  .bullet {   
    color: #ffa500;
    position: relative;
    top: -0.09em ; 
  };
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

class ChangeOptionGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.clearRslCmtInfo = this.clearRslCmtInfo.bind(this);
    this.handleClickGuide = this.handleClickGuide.bind(this);
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 結果コメント情報のクリア
  clearRslCmtInfo(index) {
    const { onClearRslCmtInfo } = this.props;
    onClearRslCmtInfo(index);
  }
  // 結果コメント画面呼び出し
  handleClickGuide(index, rsvno) {
    const { onOpenRslCmtGuide } = this.props;
    onOpenRslCmtGuide({ index, rsvno });
  }

  // 登録
  handleSubmit() {
    const { onSubmit, rsvno, changesetdata } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(rsvno, changesetdata);
  }

  render() {
    const { handleSubmit, message, consultdata, optfromconsultdata, optiondata, changesetdata, realage } = this.props;
    return (
      <GuideBase {...this.props} title="受診セット変更" usePagination={false}>
        <MainDiv>
          <MessageBanner messages={message} />
          <form onSubmit={handleSubmit(() => this.handleSubmit())}>
            <ChangeOptionGuideHeaderForm data={consultdata} realage={realage} />
            <WrapperButton><Button type="submit" value="保存" /></WrapperButton>
            <WrapperBulleted><BulletedLabel>検査セットに結果コメントをセットすることにより、結果が空白でも未入力になりません（金額に変更はありません）。</BulletedLabel></WrapperBulleted>
            <div>
              <WrapperMargin><ChangeOptionGuideBody1 optfromconsultdata={optfromconsultdata} optiondata={optiondata} /></WrapperMargin>
              <WrapperMargin>
                <ChangeOptionGuideBody2
                  changesetdata={changesetdata}
                  handleClickGuide={this.handleClickGuide}
                  onDelete={this.clearRslCmtInfo}
                />
              </WrapperMargin>
            </div>
          </form>
        </MainDiv>
        <RslCmtGuide />
      </GuideBase>
    );
  }
}

const ChangeOptionGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(ChangeOptionGuide);

// propTypesの定義
ChangeOptionGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  consultdata: PropTypes.shape().isRequired,
  optfromconsultdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  realage: PropTypes.number,
  reset: PropTypes.func.isRequired,
  optiondata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  changesetdata: PropTypes.shape().isRequired,
  onClearRslCmtInfo: PropTypes.func.isRequired,
  onOpenRslCmtGuide: PropTypes.func.isRequired,
  rsvno: PropTypes.string,
};

// defaultPropsの定義
ChangeOptionGuide.defaultProps = {
  realage: null,
  rsvno: null,
};

const mapStateToProps = (state) => ({
  message: state.app.reserve.consult.changeOptionGuide.message,
  visible: state.app.reserve.consult.changeOptionGuide.visible,
  consultdata: state.app.reserve.consult.changeOptionGuide.consultdata,
  optfromconsultdata: state.app.reserve.consult.changeOptionGuide.optfromconsultdata,
  optiondata: state.app.reserve.consult.changeOptionGuide.optiondata,
  changesetdata: state.app.reserve.consult.changeOptionGuide.changesetdata,
  realage: state.app.reserve.consult.changeOptionGuide.realage,
  index: state.app.reserve.consult.changeOptionGuide.index,
  rsvno: state.app.reserve.consult.changeOptionGuide.rsvno,
});

const mapDispatchToProps = (dispatch) => ({
  // todo
  onOpenRslCmtGuide: () => {
    dispatch(openRslCmtGuide());
  },

  // 結果コメント情報のクリア
  onClearRslCmtInfo: (index) => {
    dispatch(clearRslCmtInfo({ index, formName }));
  },

  onSubmit: (params, data) => {
    dispatch(updateResultForChangeSetRequest({ params, data }));
  },

  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeChangeOptionGuide());
    dispatch(initOcrNyuryoku());
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(ChangeOptionGuideForm);

