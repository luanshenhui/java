import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeFollowReqEditGuide } from '../../modules/followup/followModule';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import FollowupHeader from '../../containers/common/FollowupHeader';
import FollowReqEditFrom from './FollowReqEditFrom';

const Wrapper = styled.div`
  height: 600px;
  width: 1150px;
  margin-top: 10px;
  overflow-y: auto;
`;

const FollowReqEditGuide = (props) => {
  const { rsvno, message } = props;
  return (
    <GuideBase {...props} title="依頼状作成" usePagination={false} >
      <Wrapper>
        <FollowupHeader rsvno={rsvno} />
        <MessageBanner messages={message} />
        <FollowReqEditFrom rsvno={rsvno} />
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
FollowReqEditGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  rsvno: PropTypes.number,
};

FollowReqEditGuide.defaultProps = {
  rsvno: undefined,
};

const mapStateToProps = (state) => ({
  // 検索条件
  visible: state.app.followup.follow.followReqEditGuide.visible,
  message: state.app.followup.follow.followReqEditGuide.message,
  rsvno: state.app.followup.follow.followReqEditGuide.rsvno,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFollowReqEditGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowReqEditGuide);
