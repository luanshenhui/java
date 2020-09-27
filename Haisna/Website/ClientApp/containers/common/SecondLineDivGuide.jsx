import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import SecondLineDivGuideHeaderForm from './SecondLineDivGuideHeaderForm';
import SecondLineDivGuideList from '../../components/common/SecondLineDivGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getSecondLineDivList, getSecondLineDiv, closeSecondLineDivGuide } from '../../modules/preference/secondLineDivModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const SecondLineDivGuide = (props) => {
  const { conditions, searched, totalCount, data, onSearch, onSelectRow } = props;
  // ページネーション用検索処理
  const onPagination = (page) => {
    conditions.page = page;
    onSearch(conditions);
  };
  return (
    <GuideBase {...props} title="2次請求明細ガイド" onSearch={onPagination} page={conditions.page} limit={conditions.limit} usePagination >
      <SecondLineDivGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <SecondLineDivGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>2次請求明細情報は存在しません。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
SecondLineDivGuide.propTypes = {
  // 親からpropsとして渡される項目
  onSelected: PropTypes.func,
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  totalCount: PropTypes.number.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  selectedItem: PropTypes.shape(),
  // actionと紐付けされた項目
  onSearch: PropTypes.func.isRequired,
  onSelectRow: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
SecondLineDivGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.secondLineDiv.guide.visible,
  // 検索条件
  conditions: state.app.preference.secondLineDiv.guide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.secondLineDiv.guide.searched,
  // 総レコード数
  totalCount: state.app.preference.secondLineDiv.guide.totalCount,
  // 2次請求明細一覧
  data: state.app.preference.secondLineDiv.guide.data,
  // 選択された要素
  selectedItem: state.app.preference.secondLineDiv.guide.selectedItem,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    // 2次請求明細一覧取得アクションを呼び出す
    dispatch(getSecondLineDivList(conditions));
  },
  // 行選択時の処理
  onSelectRow: (secondLineDivCd) => {
    // 選択行の2次請求明細情報取得アクションを呼び出す
    dispatch(getSecondLineDiv(secondLineDivCd));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeSecondLineDivGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(SecondLineDivGuide);
