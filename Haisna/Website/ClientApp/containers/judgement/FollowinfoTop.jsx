import React from 'react';
import { connect } from 'react-redux';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import GuideBase from '../../components/common/GuideBase';
import FollowInfoHeader from './FollowInfoHeader';
import FollowInfoBody from './FollowInfoBody';
import FollowupHeader from '../../containers/common/FollowupHeader';
import { closeFollowInfoGuide } from '../../modules/followup/followModule';

const FollowInfoDiv = styled.div`
   height:680px;
   overflow-y: auto
`;

const FollowinfoTop = (props) => {
  const { match, rsvNo } = props;
  const { winmode } = match.params;
  if (rsvNo !== undefined && rsvNo !== null) {
    match.params.rsvno = rsvNo;
  }
  return (

    <div>
      {(winmode === '1') && (
        <GuideBase {...props} title="フォローアップ検索" usePagination={false}>
          <FollowupHeader rsvno={match.params.rsvno} />
          <FollowInfoHeader />
          <FollowInfoDiv>
            <FollowInfoBody {...props} winmode={winmode} />
          </FollowInfoDiv>
        </GuideBase>
       )}
      {(winmode === '0') && (
        <div>
          <FollowInfoHeader {...props} winmode={winmode} />
          <FollowInfoBody {...props} winmode={winmode} />
        </div>
      )}
    </div>
  );
};

// propTypesの定義
FollowinfoTop.propTypes = {
  match: PropTypes.shape().isRequired,
  visible: PropTypes.bool,
  onClose: PropTypes.func.isRequired,
  rsvNo: PropTypes.number,
};

// defaultPropsの定義
FollowinfoTop.defaultProps = {
  visible: false,
  rsvNo: undefined,
};

const mapStateToProps = (state) => ({
  visible: state.app.followup.follow.followInfo.visible,
  rsvNo: state.app.followup.follow.followInfo.rsvNo,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFollowInfoGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowinfoTop);
