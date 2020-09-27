/**
 * @file 管理端末一覧
 */
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';

// 標準コンポーネント
import PageLayout from '../../../layouts/PageLayout';

// 固有コンポーネント
import WorkStationListHeaderForm from './WorkStationListHeaderForm';
import WorkstationListBody from './WorkStationListBody';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

// 管理端末一覧
const WorkStationList = (props) => {
  const { totalCount } = props;
  return (
    <PageLayout title="管理端末一覧">
      <WorkStationListHeaderForm {...props} />
      {totalCount !== null && (
        <div>
          <div>
            検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
          </div>
          <WorkstationListBody />
        </div>
      )}
    </PageLayout>
  );
};

// propTypesの定義
WorkStationList.propTypes = {
  // 総件数
  totalCount: PropTypes.number,
};

// defaultPropsの定義
WorkStationList.defaultProps = {
  // 総件数
  totalCount: null,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  // 総件数
  totalCount: state.app.preference.workstation.list.totalcount,
});

export default withRouter(connect(mapStateToProps)(WorkStationList));
