import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import qs from 'qs';

import PageLayout from '../../../layouts/PageLayout';
import OrgListHeaderForm from './OrgListHeaderForm';
import OrgListBody from './OrgListBody';
import Pagination from '../../../components/Pagination';
import { setOrgTarget } from '../../../modules/preference/organizationModule';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class OrgList extends React.Component {
  componentWillMount() {
    const { setTarget, target } = this.props;
    if (target) {
      setTarget(target);
    }
  }

  render() {
    const { conditions, history, match, totalCount } = this.props;

    return (
      <PageLayout title="団体一覧">
        <div>
          <OrgListHeaderForm {...this.props} />
          {totalCount !== null && (
            <div>
              <div>
                {conditions.keyword && conditions.keyword !== '' && <span>「<SearchedKeyword>{conditions.keyword}</SearchedKeyword>」の</span>}
                検索結果は<TotalCount>{totalCount}</TotalCount>件ありました。
              </div>
              <OrgListBody />
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
OrgList.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  setTarget: PropTypes.func.isRequired,
  target: PropTypes.string,
};

// defaultPropsの定義
OrgList.defaultProps = {
  totalCount: null,
  target: undefined,
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.organization.organizationList.conditions,
  totalCount: state.app.preference.organization.organizationList.totalCount,
});

const mapDispatchToProps = (dispatch) => ({
  setTarget: (target) => {
    if (target === undefined) {
      return;
    }
    dispatch(setOrgTarget(target));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(OrgList));
