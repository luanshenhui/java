import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeFolUpdateHistoryGuide, getFollowLogListRequest } from '../../modules/followup/followModule';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import Pagination from '../../components/Pagination';
import SectionBar from '../../components/SectionBar';
import FolUpdateHistoryHeaderFrom from './FolUpdateHistoryHeaderFrom';
import FollowupHeader from '../../containers/common/FollowupHeader';
import FolUpdateHistoryBody from './FolUpdateHistoryBody';

const Wrapper = styled.div`
  height: 600px;
  width: 1150px;
  margin-top: 10px;
`;

const BodyWrapper = styled.div`
  height: 260px;
  margin-top: 10px;
  overflow-y: auto; 
`;

const Color = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const FolUpdateHistoryGuide = (props) => {
  const { rsvno, winmode, conditions, followLogList, totalcount, message, actions, onSearch } = props;
  return (
    <GuideBase {...props} title="変更履歴" usePagination >
      <Wrapper>
        {winmode === '1' &&
          <FollowupHeader rsvno={rsvno} />
        }
        <SectionBar title="変更履歴" />
        <FolUpdateHistoryHeaderFrom rsvno={rsvno} />
        {actions === 'search' &&
          <div style={{ marginTop: '20px' }}>
            <MessageBanner messages={message} />
            {totalcount > 0 &&
              <BodyWrapper>
                <span>検索結果は<Color>{totalcount}</Color>件ありました。</span>
                <FolUpdateHistoryBody data={followLogList} />
              </BodyWrapper>
            }
          </div>
        }
        {totalcount > conditions.limit && (
          <Pagination
            startPos={(conditions.page - 1) * conditions.limit + 1}
            rowsPerPage={parseInt(conditions.limit, 10)}
            totalCount={totalcount}
            onSelect={(page) => { onSearch({ ...conditions, page }); }}
          />
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
FolUpdateHistoryGuide.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  visible: PropTypes.bool.isRequired,
  onSearch: PropTypes.func.isRequired,
  followLogList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsvno: PropTypes.number,
  winmode: PropTypes.string.isRequired,
  actions: PropTypes.string.isRequired,
  totalcount: PropTypes.number.isRequired,
  conditions: PropTypes.shape().isRequired,
};

FolUpdateHistoryGuide.defaultProps = {
  rsvno: undefined,
};

const mapStateToProps = (state) => ({
  // 検索条件
  visible: state.app.followup.follow.folUpdateHistoryGuide.visible,
  message: state.app.followup.follow.folUpdateHistoryGuide.message,
  followLogList: state.app.followup.follow.folUpdateHistoryGuide.followLogList,
  rsvno: state.app.followup.follow.folUpdateHistoryGuide.rsvno,
  winmode: state.app.followup.follow.folUpdateHistoryGuide.winmode,
  actions: state.app.followup.follow.folUpdateHistoryGuide.actions,
  totalcount: state.app.followup.follow.folUpdateHistoryGuide.totalcount,
  conditions: state.app.followup.follow.folUpdateHistoryGuide.conditions,
});

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getFollowLogListRequest({ conditions }));
  },
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeFolUpdateHistoryGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FolUpdateHistoryGuide);
