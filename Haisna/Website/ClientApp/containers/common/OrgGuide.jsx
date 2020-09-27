import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import OrgGuideHeaderForm from './OrgGuideHeaderForm';
import OrgGuideList from '../../components/common/OrgGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getOrgGuideListRequest, getOrgGuideValueRequest, closeOrgGuide } from '../../modules/preference/organizationModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const OrgGuide = (props) => {
  const { conditions, searched, totalCount, data, onSearch, onSelectRow } = props;

  // ページネーション用検索処理
  const onPagination = (page) => {
    onSearch({ ...conditions, page });
  };

  return (
    <GuideBase {...props} title="団体の検索" page={conditions.page} limit={conditions.limit} onSearch={onPagination} usePagination >
      <OrgGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <p>検索結果は{totalCount}件ありました。</p>
            <OrgGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>検索条件を満たす団体情報は存在しません。<br />キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
OrgGuide.propTypes = {
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  totalCount: PropTypes.number.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  selectedItem: PropTypes.shape(),
  onSelected: PropTypes.func,
  // actionと紐付けされた項目
  onSearch: PropTypes.func.isRequired,
  onSelectRow: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
OrgGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.organization.organizationGuide.visible,
  // 検索条件
  conditions: state.app.preference.organization.organizationGuide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.organization.organizationGuide.searched,
  // 総レコード数
  totalCount: state.app.preference.organization.organizationGuide.totalCount,
  // 団体一覧
  data: state.app.preference.organization.organizationGuide.data,
  // 選択された要素
  selectedItem: state.app.preference.organization.organizationGuide.selectedItem,
  // ガイドから団体を選択した後の処理
  onSelected: state.app.preference.organization.organizationGuide.onSelected,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    // 団体一覧取得アクションを呼び出す
    dispatch(getOrgGuideListRequest(conditions));
  },
  // 行選択時の処理
  onSelectRow: (orgCd1, orgCd2) => {
    const params = { orgcd1: orgCd1, orgcd2: orgCd2 };
    // 選択行の団体情報取得アクションを呼び出す
    dispatch(getOrgGuideValueRequest(params));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeOrgGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OrgGuide);
