import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import MessageBanner from '../../components/MessageBanner';
import * as Contants from '../../constants/common';
import SectionBar from '../../components/SectionBar';

import SpecialJudViewBody1 from './SpecialJudViewBody1';
import SpecialJudViewBody2 from './SpecialJudViewBody2';
import SpecialJudViewBody3 from './SpecialJudViewBody3';
import {
  getSpecialRslViewRequest, getSpecialJudCmtRequest, getSpecialResultRequest, getRslRequest,
  getSubSpecialJudCmtRequest, getSubEntitySpJudRequest,
} from '../../modules/judgement/specialInterviewModule';

class SpecialJudView extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.rsvno = match.params.rsvno;
  }
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  render() {
    const { message, rslviewdataLeft, rslviewdataRight, judcmtdata, resultdata, rsldata, onOpenSpJudCommentGuide, onOpenEntitySpJudGuide, match } = this.props;
    return (
      <div>
        <SectionBar title="特定健診専用面接" />
        <div>
          <MessageBanner messages={message} />
          <SpecialJudViewBody1 dataLeft={rslviewdataLeft} dataRight={rslviewdataRight} resultdata={resultdata} />
          <SpecialJudViewBody2 data={judcmtdata} onOpenSpJudCommentGuide={onOpenSpJudCommentGuide} rsvno={match.params.rsvno} />
          <SpecialJudViewBody3 data={rsldata} onOpenEntitySpJudGuide={onOpenEntitySpJudGuide} rsvno={match.params.rsvno} />
        </div>
      </div>
    );
  }
}
// propTypesの定義
SpecialJudView.propTypes = {
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  rslviewdataLeft: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rslviewdataRight: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  judcmtdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  resultdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsldata: PropTypes.number,
  onOpenSpJudCommentGuide: PropTypes.func.isRequired,
  onOpenEntitySpJudGuide: PropTypes.func.isRequired,
};
// defaultPropsの定義
SpecialJudView.defaultProps = {
  rsldata: 0,
};
const mapStateToProps = (state) => ({
  message: state.app.judgement.specialInterview.specialJudViewList.message,
  rslviewdataLeft: state.app.judgement.specialInterview.specialJudViewList.rslviewdataLeft,
  rslviewdataRight: state.app.judgement.specialInterview.specialJudViewList.rslviewdataRight,
  judcmtdata: state.app.judgement.specialInterview.specialJudViewList.judcmtdata,
  resultdata: state.app.judgement.specialInterview.specialJudViewList.resultdata,
  rsldata: state.app.judgement.specialInterview.specialJudViewList.rsldata,
});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(getSpecialRslViewRequest(params));
    dispatch(getSpecialJudCmtRequest({ ...params, dispmode: Contants.DISP_MODE }));
    dispatch(getSpecialResultRequest({ ...params, grpcd: Contants.GRPCD_LEVEL }));
    dispatch(getRslRequest({ ...params, itemcd: Contants.GUIDANCE_ITEMCD, suffix: Contants.GUIDANCE_SUFFIX }));
  },
  // 特定健診コメント
  onOpenSpJudCommentGuide: (params) => {
    // 開くアクションを呼び出す
    dispatch(getSubSpecialJudCmtRequest({ ...params, dispmode: Contants.DISP_MODE }));
  },
  // 特定保健指導区分登録
  onOpenEntitySpJudGuide: (params) => {
    // 開くアクションを呼び出す
    dispatch(getSubEntitySpJudRequest({ ...params, itemcd: Contants.GUIDANCE_ITEMCD, suffix: Contants.GUIDANCE_SUFFIX }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(SpecialJudView));
