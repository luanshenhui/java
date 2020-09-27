import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import PageLayout from '../../../layouts/PageLayout';
import RsvFraSearchHeaderForm from './RsvFraSearchHeaderForm';
import RsvFraSearchBody from './RsvFraSearchBody';
import CircularProgress from '../../../components/control/CircularProgress/CircularProgress';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
  marging-left: 5px;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const RsvFraSearch = (props) => {
  const { conditions, totalCount, isLoading } = props;
  return (
    <PageLayout title="予約枠の検索">
      <div>
        {isLoading && <CircularProgress />}
        <RsvFraSearchHeaderForm {...props} />
        {totalCount !== null && (
          <div>
            <div style={{ marginBottom: 10 }}>
              {conditions.startcsldate && conditions.startcsldate !== '' &&
                <span>
                  「<SearchedKeyword>{moment(conditions.startcsldate).format('YYYY年MM月DD日')}～{moment(conditions.endcsldate).format('YYYY年MM月DD日')}</SearchedKeyword>」
                  の予約枠一覧を表示しています。
                </span>
              }
              <br />対象予約枠は<TotalCount>&nbsp;{totalCount}</TotalCount>件ありました。
            </div>
            <RsvFraSearchBody />
          </div>
        )}
      </div>
    </PageLayout>
  );
};

// propTypesの定義
RsvFraSearch.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  isLoading: PropTypes.bool.isRequired,
};

// defaultPropsの定義
RsvFraSearch.defaultProps = {
  totalCount: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.schedule.rsvfraList.conditions,
  totalCount: state.app.preference.schedule.rsvfraList.totalCount,
  isLoading: state.app.preference.schedule.rsvfraList.isLoading,
});

export default connect(mapStateToProps)(RsvFraSearch);
