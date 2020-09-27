import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import qs from 'qs';

import PageLayout from '../../../layouts/PageLayout';
import CtrBrowseOrgHeaderForm from './CtrBrowseOrgHeaderForm';
import CtrBrowseOrgBody from './CtrBrowseOrgBody';
import Pagination from '../../../components/Pagination';

import { getOrgListRequest } from '../../../modules/preference/organizationModule';


const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class CtrBrowseOrg extends React.Component {
  componentDidMount() {
    const { match, onLoad } = this.props;
    onLoad(match.params);
  }

  render() {
    const { conditions, history, match, totalCount } = this.props;

    return (
      <PageLayout title="参照先契約団体の検索">
        <div>
          <CtrBrowseOrgHeaderForm {...this.props} />
          {totalCount !== null && (
            <div>
              <div>
                {conditions.keyword && conditions.keyword !== '' && <span>「<SearchedKeyword>{conditions.keyword}</SearchedKeyword>」の</span>}
                検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
              </div>
              <CtrBrowseOrgBody {...this.props} />
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
        </div>
      </PageLayout>
    );
  }
}

// propTypesの定義
CtrBrowseOrg.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  onLoad: PropTypes.func.isRequired,
};

// defaultPropsの定義
CtrBrowseOrg.defaultProps = {
  totalCount: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.organization.organizationList.conditions,
  totalCount: state.app.preference.organization.organizationList.totalCount,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (conditions) => {
    // 画面を初期化
    const [page, limit] = [1, 20];
    dispatch(getOrgListRequest({ page, limit, ...conditions }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrBrowseOrg));
