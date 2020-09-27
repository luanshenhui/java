import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeFollowReqHistoryGuide } from '../../modules/followup/followModule';
import GuideBase from '../../components/common/GuideBase';
import FollowupHeader from '../../containers/common/FollowupHeader';
import FollowReqHistoryHeaderFrom from './FollowReqHistoryHeaderFrom';
import FollowReqHistoryBody from './FollowReqHistoryBody';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const Wrapper = styled.div`
  height: 600px;
  width: 1150px;
  margin-top: 10px;
  overflow-y: auto;
`;

const FollowReqHistoryGuide = (props) => {
  const { rsvno, folReqHistory, totalcount } = props;
  return (
    <GuideBase {...props} title="依頼状印刷履歴" usePagination={false} >
      <Wrapper>
        <FollowupHeader rsvno={rsvno} />
        <FollowReqHistoryHeaderFrom rsvno={rsvno} />
        <div style={{ marginTop: '30px' }}>
          <p><TotalCount>印刷履歴は {totalcount} 件です。</TotalCount></p>
          <FollowReqHistoryBody data={folReqHistory} />
        </div>
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
FollowReqHistoryGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  rsvno: PropTypes.number,
  folReqHistory: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalcount: PropTypes.number.isRequired,
};

FollowReqHistoryGuide.defaultProps = {
  rsvno: undefined,
};

const mapStateToProps = (state) => ({
  // 検索条件
  visible: state.app.followup.follow.folReqHistoryGuide.visible,
  rsvno: state.app.followup.follow.folReqHistoryGuide.rsvno,
  folReqHistory: state.app.followup.follow.folReqHistoryGuide.folReqHistory,
  totalcount: state.app.followup.follow.folReqHistoryGuide.totalcount,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFollowReqHistoryGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowReqHistoryGuide);
