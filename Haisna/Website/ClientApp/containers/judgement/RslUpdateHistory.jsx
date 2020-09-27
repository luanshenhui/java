import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import Pagination from '../../components/Pagination';
import RslUpdateHistoryHeaderForm from './RslUpdateHistoryHeaderForm';
import RslUpdateHistoryBody from './RslUpdateHistoryBody';
import { closeUpdateLogGuide, getUpdateLogListRequest } from '../../modules/judgement/interviewModule';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const OverFlow = styled.div`
  overflow-y: auto;
  height: 380px;
  width: 1025px;
`;

const RslUpdateHistory = ({ conditions, searched, totalCount, data, match, onSearch }) => {
  const { params } = match;
  return (
    <div>
      <RslUpdateHistoryHeaderForm />
      {searched && totalCount > 0 && (
        <div>
          <div>
            検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
          </div>
          {params.winmode === '1' ?
            <OverFlow>
              <RslUpdateHistoryBody data={data} />
            </OverFlow>
            :
            <RslUpdateHistoryBody data={data} />
          }
          {totalCount > conditions.limit && (
            <Pagination
              startPos={((conditions.page - 1) * Number(conditions.limit)) + 1}
              rowsPerPage={Number(conditions.limit)}
              totalCount={totalCount}
              onSelect={(page) => onSearch({ ...conditions, page })}
            />
          )}
        </div>
      )}
      {searched && totalCount === 0 && (
        <div>検索条件を満たす履歴は存在しませんでした。<br /></div>
      )}
    </div>
  );
};

// propTypesの定義
RslUpdateHistory.propTypes = {
  conditions: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  onSearch: PropTypes.func,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  searched: PropTypes.bool.isRequired,
};

// defaultPropsの定義
RslUpdateHistory.defaultProps = {
  totalCount: null,
  onSearch: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.judgement.interview.rslUpdateHistoryList.conditions,
  totalCount: state.app.judgement.interview.rslUpdateHistoryList.totalCount,
  data: state.app.judgement.interview.rslUpdateHistoryList.data,
  // 検索指示が行われたか
  searched: state.app.judgement.interview.rslUpdateHistoryList.searched,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 編集モードの場合クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUpdateLogGuide());
  },
  onSearch: (conditions) => {
    dispatch(getUpdateLogListRequest({ ...conditions }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RslUpdateHistory);
