import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import qs from 'qs';

import PageLayout from '../../../layouts/PageLayout';
import MntSearchPersonHeaderForm from './MntSearchPersonHeaderForm';
import MntSearchPersonBody from './MntSearchPersonBody';
import Pagination from '../../../components/Pagination';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;
const MntSearchPerson = (props) => {
  const { conditions, history, match, totalCount } = props;
  return (
    <PageLayout title="個人の検索">
      <MntSearchPersonHeaderForm {...props} />
      {totalCount !== null && (
        <div>
          <div>
            {conditions.keyword && conditions.keyword !== '' && <span>「<SearchedKeyword>{conditions.keyword}</SearchedKeyword>」の</span>}
            検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
          </div>
          <MntSearchPersonBody />
          {totalCount > conditions.limit && (
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
    </PageLayout>
  );
};

// propTypesの定義
MntSearchPerson.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
};

// defaultPropsの定義
MntSearchPerson.defaultProps = {
  totalCount: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.person.personList.conditions,
  totalCount: state.app.preference.person.personList.totalCount,
});

export default withRouter(connect(mapStateToProps)(MntSearchPerson));
