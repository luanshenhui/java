import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeFollowRslEditGuide } from '../../modules/followup/followModule';
import FollowupHeader from '../../containers/common/FollowupHeader';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import SectionBar from '../../components/SectionBar';
import FollowRslEditFrom from './FollowRslEditFrom';

const Wrapper = styled.div`
  height: 850px;
  width: 1400px;
  margin-top: 10px;
  overflow-y: auto;
`;

const FollowRslEditGuide = (props) => {
  const { rsvno, judclasscd, seq, message } = props;
  return (
    <GuideBase {...props} title="二次検診結果登録" usePagination={false} >
      <Wrapper>
        <SectionBar title="フォローアップ結果登録" />
        <FollowupHeader rsvno={rsvno} />
        <MessageBanner messages={message} />
        <FollowRslEditFrom rsvno={rsvno} judclasscd={judclasscd} seq={seq} />
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
FollowRslEditGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  rsvno: PropTypes.number,
  judclasscd: PropTypes.number,
  seq: PropTypes.number,
};

FollowRslEditGuide.defaultProps = {
  rsvno: undefined,
  judclasscd: undefined,
  seq: undefined,
};

const mapStateToProps = (state) => ({
  // 検索条件
  visible: state.app.followup.follow.followRslEditGuide.visible,
  message: state.app.followup.follow.followRslEditGuide.message,
  rsvno: state.app.followup.follow.followRslEditGuide.rsvno,
  judclasscd: state.app.followup.follow.followRslEditGuide.judclasscd,
  seq: state.app.followup.follow.followRslEditGuide.seq,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFollowRslEditGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowRslEditGuide);
