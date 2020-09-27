import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import PageLayout from '../../../layouts/PageLayout';
import RsvFraCopyHeadForm from './RsvFraCopyHeadForm';
import RsvFraCopyBody from './RsvFraCopyBody';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const RsvFraCopy2 = (props) => {
  const { conditions, totalCount, data } = props;
  return (
    <PageLayout title="予約枠の検索">
      <div>
        <RsvFraCopyHeadForm {...props} />
        <div style={{ marginTop: 15 }}>
          <span style={{ fontSize: 16 }}>
            <span style={{ color: '#cc9999' }}>●</span>（コピー元情報）
            「<SearchedKeyword>{moment(conditions.startcsldate).format('YYYY年M月D日')}</SearchedKeyword>」
            {conditions.cscd && conditions.cscd !== '' && data && data.length !== 0 &&
              <span>「<SearchedKeyword>{data[0].csname}</SearchedKeyword>」</span>
            }
            {conditions.rsvgrpcd && conditions.rsvgrpcd !== '' && data && data.length !== 0 &&
              <span>「<SearchedKeyword>{data[0].rsvgrpname}</SearchedKeyword>」</span>
            }
            の予約枠一覧
            <br /><TotalCount>{totalCount}</TotalCount>件のレコードがありました。
          </span>
        </div>
        <RsvFraCopyBody />
      </div>
    </PageLayout>
  );
};

// propTypesの定義
RsvFraCopy2.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalCount: PropTypes.number,
};

// defaultPropsの定義
RsvFraCopy2.defaultProps = {
  totalCount: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.schedule.rsvfraList.conditions,
  totalCount: state.app.preference.schedule.rsvfraList.totalCount,
  data: state.app.preference.schedule.rsvfraList.data,
});

export default connect(mapStateToProps)(RsvFraCopy2);
