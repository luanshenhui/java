import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import GrpGuideHeaderForm from './GrpGuideHeaderForm';
import GrpGuideList from '../../components/common/GrpGuideList';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';

import { getGroupGuideListRequest, getGroupGuideItem, closeGroupGuide } from '../../modules/preference/groupModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const GrpGuide = (props) => {
  const {
    conditions,
    searched,
    totalCount,
    data,
    onSearch,
    onSelectRow,
    message,
    grpDiv,
  } = props;

  // 検索処理
  const handleSearch = (values) => {
    const [page, limit] = [1, 20];
    onSearch({ page, limit, ...values, grpDiv });
  };

  // ページネーション用検索処理
  const onPagination = (page) => {
    handleSearch({ ...conditions, page });
  };

  return (
    <GuideBase
      {...props}
      title="グループの検索"
      page={conditions.page}
      limit={conditions.limit}
      onSearch={onPagination}
      usePagination
    >
      <MessageBanner messages={message} />
      <GrpGuideHeaderForm onSubmit={handleSearch} conditions={conditions} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <p>検索結果は{totalCount}件ありました。</p>
            <GrpGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>検索条件を満たすグループ情報は存在しません。<br />キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
GrpGuide.propTypes = {
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  totalCount: PropTypes.number,
  data: PropTypes.arrayOf(PropTypes.shape()),
  selectedItem: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSelected: PropTypes.func,
  grpDiv: PropTypes.number,
  // actionと紐付けされた項目
  onSearch: PropTypes.func.isRequired,
  onSelectRow: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
GrpGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
  totalCount: 0,
  data: [],
  grpDiv: null,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 検索条件
  conditions: state.app.preference.group.groupGuide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.group.groupGuide.searched,
  // 総レコード数
  totalCount: state.app.preference.group.groupGuide.totalcount,
  // グループ一覧
  data: state.app.preference.group.groupGuide.data,
  // 選択された要素
  selectedItem: state.app.preference.group.groupGuide.selectedItem,
  // ガイドの表示状態
  visible: state.app.preference.group.groupGuide.visible,
  // メッセージ
  message: state.app.preference.group.groupGuide.message,
  // グループ区分
  grpDiv: state.app.preference.group.groupGuide.grpdiv,
  // 選択後の処理
  onSelected: state.app.preference.group.groupGuide.onSelected,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索要求処理
  onSearch: (payload) => {
    dispatch(getGroupGuideListRequest(payload));
  },
  // 行選択処理
  onSelectRow: (payload) => {
    dispatch(getGroupGuideItem(payload));
  },
  // グループガイドクローズ処理
  onClose: () => {
    dispatch(closeGroupGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(GrpGuide);
