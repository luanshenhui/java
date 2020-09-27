import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import RslCmtGuideHeaderForm from './RslCmtGuideHeaderForm';
import RslCmtGuideList from '../../components/common/RslCmtGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getRslCmtList, getRslCmt, closeRslCmtGuide } from '../../modules/preference/rslCmtModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const RslCmtGuide = (props) => {
  const { conditions, searched, totalCount, data, onSearch, onSelectRow } = props;
  return (
    <GuideBase {...props} title="結果コメントガイド" page={conditions.page} limit={conditions.limit} usePagination >
      <RslCmtGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <RslCmtGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>結果コメント情報は存在しません。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
RslCmtGuide.propTypes = {
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
RslCmtGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.rslCmt.guide.visible,
  // 検索条件
  conditions: state.app.preference.rslCmt.guide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.rslCmt.guide.searched,
  // 総レコード数
  totalCount: state.app.preference.rslCmt.guide.totalCount,
  // 結果コメント一覧
  data: state.app.preference.rslCmt.guide.data,
  // 選択された要素
  selectedItem: state.app.preference.rslCmt.guide.selectedItem,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    // 結果コメント一覧取得アクションを呼び出す
    dispatch(getRslCmtList(conditions));
  },
  // 行選択時の処理
  onSelectRow: (rslcmtCd) => {
    // 選択行の結果コメント情報取得アクションを呼び出す
    dispatch(getRslCmt(rslcmtCd));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeRslCmtGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RslCmtGuide);
