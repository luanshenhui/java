import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeFollowInfoEditGuide } from '../../modules/followup/followModule';
import FollowupHeader from '../../containers/common/FollowupHeader';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import SectionBar from '../../components/SectionBar';
import FollowInfoEditFrom from './FollowInfoEditFrom';
import FollowRslEditGuide from './FollowRslEditGuide';

const Wrapper = styled.div`
  height: 850px;
  width: 1300px;
  margin-top: 10px;
  overflow-y: auto;
`;

const FollowInfoEditGuide = (props) => {
  const { rsvno, judclasscd, message } = props;
  return (
    <GuideBase {...props} title="二次検診情報登録" usePagination={false} >
      <Wrapper>
        <SectionBar title="フォローアップ情報登録" />
        <FollowupHeader rsvno={rsvno} />
        <MessageBanner messages={message} />
        <FollowInfoEditFrom rsvNo={rsvno} judClassCd={judclasscd} />
      </Wrapper>
      <FollowRslEditGuide />
    </GuideBase>
  );
};

// propTypesの定義
FollowInfoEditGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  rsvno: PropTypes.number,
  judclasscd: PropTypes.number,
};

FollowInfoEditGuide.defaultProps = {
  rsvno: undefined,
  judclasscd: undefined,
};

const mapStateToProps = (state) => ({
  // 検索条件
  visible: state.app.followup.follow.followInfoEditGuide.visible,
  message: state.app.followup.follow.followInfoEditGuide.message,
  rsvno: state.app.followup.follow.followInfoEditGuide.rsvno,
  judclasscd: state.app.followup.follow.followInfoEditGuide.judclasscd,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFollowInfoEditGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowInfoEditGuide);
