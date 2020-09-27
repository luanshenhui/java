import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import qs from 'qs';

import CircularProgress from '../../../components/control/CircularProgress/CircularProgress';
import PageLayout from '../../../layouts/PageLayout';
import HainsLogHeaderForm from './HainsLogHeaderForm';
import HainsLogBody from './HainsLogBody';
import Pagination from '../../../components/Pagination';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const HainsLog = (props) => {
  const { conditions, totalCount, history, match, isLoading } = props;
  return (
    <PageLayout title="システムログの表示">
      <div>
        <HainsLogHeaderForm {...this.props} />
        {totalCount !== null && (
          <div>
            <div>
              検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
            </div>
            {totalCount > 0 &&
              <HainsLogBody />
            }
            {totalCount > conditions.limit && (
              <Pagination
                startPos={Number.parseInt(conditions.startPos, 10)}
                rowsPerPage={Number.parseInt(conditions.limit, 10)}
                totalCount={totalCount}
                onSelect={(page) => {
                  // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
                  const startPos = ((page - 1) * conditions.limit) + 1;
                  // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
                  history.push({
                    pathname: match.url,
                    search: qs.stringify({ ...conditions, startPos }),
                  });
                }}
              />
            )}
          </div>
        )}
        {isLoading && <CircularProgress />}
      </div>
    </PageLayout>
  );
};

// propTypesの定義
HainsLog.propTypes = {
  conditions: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  isLoading: PropTypes.bool,

};

// defaultPropsの定義
HainsLog.defaultProps = {
  totalCount: null,
  isLoading: false,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.hainsLog.hainsLogList.conditions,
  totalCount: state.app.preference.hainsLog.hainsLogList.totalCount,
  isLoading: state.app.preference.hainsLog.hainsLogList.isLoading,
});

export default withRouter(connect(mapStateToProps)(HainsLog));
