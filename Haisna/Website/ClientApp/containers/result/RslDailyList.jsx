import React from 'react';
import moment from 'moment';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import qs from 'qs';
import { withRouter } from 'react-router-dom';
import Pagination from '../../components/Pagination';
import RslDailyListBody from './RslDailyListBody';
import RslDailyListHeader from './RslDailyListHeader';

const RslDailyList = ({ conditions, history, match, totalCount, csldate }) => (
  <div style={{ width: '300px' }}>
    <RslDailyListHeader {...this.props} />
    <span style={{ color: '#ff6600' }}>「{moment(csldate).format('YYYY年MM月DD日')}」</span>
    <span>の来院済み受診者一覧を表示しています。</span>
    {totalCount !== null && totalCount !== undefined && (
      <div>
        <span>対象者数は</span>
        <span style={{ color: '#ff6600' }}>{totalCount}</span>
        <span>人です。</span>
        <RslDailyListBody />
        {conditions !== undefined && (totalCount > conditions.limit) && (
          <Pagination
            startPos={((conditions.page - 1) * conditions.limit) + 1}
            rowsPerPage={conditions.limit}
            totalCount={totalCount}
            onSelect={(page) => {
              // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
              // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
              history.push({
                pathname: match.url,
                search: qs.stringify({ ...conditions, page }),
              });
            }}
          />
        )}
      </div>
    )}
  </div>
);

// propTypesの定義
RslDailyList.propTypes = {
  onLoad: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  csldate: PropTypes.string,
};

RslDailyList.defaultProps = {
  totalCount: null,
  csldate: null,
};


const mapStateToProps = (state) => ({
  conditions: state.app.result.result.rslMain.conditions,
  totalCount: state.app.result.result.rslDailyList.totalCount,
  csldate: state.app.result.result.rslMain.conditions.csldate,
});

export default withRouter(connect(mapStateToProps)(RslDailyList));
