import React from 'react';
import PropTypes from 'prop-types';
import { PageHeader } from 'react-bootstrap';
import qs from 'qs';

import Pagination from './Pagination';

const ListBase = ({ history, match, conditions, totalCount, title, limit, page, children }) => (
  <div>
    <PageHeader>{title}</PageHeader>
    {children}
    {/* ページネーションは総ページ数が2ページ以上になる場合、即ち総ページ数＞1ページ当たりの検索件数になる場合にのみ表示 */}
    {/* react本家でもこのような条件指定を行う記述方法が紹介されている */}
    {totalCount > limit && (
      <Pagination
        page={page}
        limit={limit}
        totalCount={totalCount}
        conditions={conditions}
        onSearch={(newConditions) => {
          // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
          // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
          history.push({
            pathname: match.url,
            search: qs.stringify({ ...newConditions }),
          });
        }}
      />
    )}
  </div>
);

// propTypesの定義
ListBase.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  totalCount: PropTypes.number.isRequired,
  limit: PropTypes.number.isRequired,
  page: PropTypes.number.isRequired,
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.node),
    PropTypes.node,
  ]).isRequired,
  title: PropTypes.string.isRequired,
};

export default ListBase;
