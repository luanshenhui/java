import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import UserGuideHeaderForm from './UserGuideHeaderForm';
import UserGuideList from '../../components/common/UserGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getUserList, getUser, closeUserGuide } from '../../modules/preference/hainsUserModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const UserGuide = (props) => {
  const { conditions, searched, totalCount, data, onSearch, onSelectRow } = props;
  return (
    <GuideBase {...props} title="ユーザガイド" page={conditions.page} limit={conditions.limit} usePagination >
      <UserGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <UserGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>ユーザ情報は存在しません。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
UserGuide.propTypes = {
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
UserGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.hainsUser.guide.visible,
  // 検索条件
  conditions: state.app.preference.hainsUser.guide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.hainsUser.guide.searched,
  // 総レコード数
  totalCount: state.app.preference.hainsUser.guide.totalCount,
  // ユーザ一覧
  data: state.app.preference.hainsUser.guide.data,
  // 選択された要素
  selectedItem: state.app.preference.hainsUser.guide.selectedItem,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    // ユーザ一覧取得アクションを呼び出す
    dispatch(getUserList(conditions));
  },
  // 行選択時の処理
  onSelectRow: (userCd) => {
    // 選択行の結果コメント情報取得アクションを呼び出す
    dispatch(getUser(userCd));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUserGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(UserGuide);
