import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import * as Contants from '../../constants/common';
import SectionBar from '../../components/SectionBar';

import DiseaseHistoryBody1 from './DiseaseHistoryBody1';
import { getHistoryRslListRequest, closeDiseaseHistoryGuide } from '../../modules/judgement/interviewModule';

const WrapperTable1 = styled.div`
   margin-right:10px;
   float:left;
   width: 350px;
`;

const MainDiv = styled.div`
   width: 960px;
   height:480px;
   overflow-y: auto
`;

class DiseaseHistory extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.winmode = match.params.winmode;
    this.rsvno = match.params.rsvno;
    this.grpcd = match.params.grpno;
    this.cscd = match.params.cscd;
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    if (this.winmode === '0') {
      onLoad(match.params);
    }
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad } = this.props;
    if (!visible && nextProps.visible !== visible) {
      if (this.winmode === '1') {
        const { match } = nextProps;
        // onLoadアクションの引数として渡す
        onLoad(match.params);
      }
    }
  }

  render() {
    const { message, historydata, match } = this.props;
    const { params } = match;
    return (
      <div>
        {params.winmode === '1' && (
          <GuideBase {...this.props} title="病歴情報" usePagination={false}>
            <SectionBar title="病歴情報" />
            <MainDiv>
              <div>
                <MessageBanner messages={message} />
                <WrapperTable1><DiseaseHistoryBody1 data={historydata} rsvno={this.rsvno} /></WrapperTable1>
              </div>
            </MainDiv>
          </GuideBase>
        )}
        {params.winmode === '0' && (
          <div>
            <SectionBar title="病歴情報" />
            <MainDiv>
              <div>
                <MessageBanner messages={message} />
                <WrapperTable1><DiseaseHistoryBody1 data={historydata} rsvno={this.rsvno} /></WrapperTable1>
              </div>
            </MainDiv>
          </div>
        )}
      </div>
    );
  }
}
// propTypesの定義
DiseaseHistory.propTypes = {
  onLoad: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  historydata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  visible: state.app.judgement.interview.diseaseHistoryList.visible,
  message: state.app.judgement.interview.diseaseHistoryList.message,
  historydata: state.app.judgement.interview.diseaseHistoryList.historydata,
});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    const csgrp = params.cscd;
    dispatch(getHistoryRslListRequest({ ...params, hiscount: Contants.HISCOUNT, grpcd: Contants.GRPCD, lastdspmode: Contants.LAST_DSP_MODE, csgrp, getseqmode: Contants.GETSEQMODE }));
  },

  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDiseaseHistoryGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(DiseaseHistory);
