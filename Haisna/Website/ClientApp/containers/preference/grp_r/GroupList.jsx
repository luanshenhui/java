import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import qs from 'qs';

import PageLayout from '../../../layouts/PageLayout';
import Pagination from '../../../components/Pagination';

import GroupListHeader from './GroupListHeader';
import GroupListBody from './GroupListBody';

const GroupList = ({ history, match, conditions, totalCount }) => (
  <PageLayout title="グループ一覧">
    <GroupListHeader />
    <GroupListBody />
    {/* ページネーションは総ページ数が2ページ以上になる場合、即ち総ページ数＞1ページ当たりの検索件数になる場合にのみ表示 */}
    {/* react本家でもこのような条件指定を行う記述方法が紹介されている */}
    {totalCount > conditions.limit && (
      <Pagination
        onSelect={(page) => {
          // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
          // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
          history.push({
            pathname: match.url,
            search: qs.stringify({ ...conditions, page }),
          });
        }}
        totalCount={totalCount}
        startPos={((conditions.page - 1) * conditions.limit) + 1}
        rowsPerPage={conditions.limit}
      />
    )}
  </PageLayout>
);

// propTypesの定義
GroupList.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  totalCount: PropTypes.number.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  conditions: state.app.preference.group.groupList.conditions,
  totalCount: state.app.preference.group.groupList.totalCount,
});

export default connect(mapStateToProps)(GroupList);
