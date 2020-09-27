import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { getConsultLogListRequest } from '../../modules/reserve/consultModule';
import MessageBanner from '../../components/MessageBanner';
import Pagination from '../../components/Pagination';
import PageLayout from '../../layouts/PageLayout';
import RsvLogListHeaderFrom from './RsvLogListHeaderFrom';
import RsvLogListBody from './RsvLogListBody';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const BodyWrapper = styled.div`
  height: 680px;
  margin-top: 30px;
  overflow-y: auto;
`;

const searchRet = (message, totalcount) => {
  let res;
  if (totalcount > 0) {
    res = <span>検索結果は<TotalCount>{totalcount}</TotalCount>件ありました。</span>;
  } else {
    res = <MessageBanner messages={message} />;
  }
  return res;
};

const RsvLogList = (props) => {
  const { consultLogList, conditions, totalcount, message, onOpenGuide, onSearch } = props;
  return (
    <PageLayout title="変更履歴">
      <div>
        <RsvLogListHeaderFrom />
        <BodyWrapper>
          {searchRet(message, totalcount)}
          {totalcount > 0 &&
            <RsvLogListBody data={consultLogList} onOpenGuide={onOpenGuide} />
          }
          {totalcount > conditions.getCount && (
            <Pagination
              startPos={(conditions.startPos - 1) * conditions.getCount + 1}
              rowsPerPage={parseInt(conditions.getCount, 10)}
              totalCount={totalcount}
              onSelect={(startPos) => { onSearch({ ...conditions, startPos }); }}
            />
          )}
        </BodyWrapper>
      </div>
    </PageLayout>
  );
};

// propTypesの定義
RsvLogList.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  consultLogList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalcount: PropTypes.number.isRequired,
  conditions: PropTypes.shape().isRequired,
  onOpenGuide: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  // 検索条件
  message: state.app.reserve.consult.rsvLogList.message,
  consultLogList: state.app.reserve.consult.rsvLogList.consultLogList,
  totalcount: state.app.reserve.consult.rsvLogList.totalcount,
  conditions: state.app.reserve.consult.rsvLogList.conditions,

});

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getConsultLogListRequest(conditions));
  },

  onOpenGuide: () => {
    // TODO
    // 予約更新情報の表示
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RsvLogList);
