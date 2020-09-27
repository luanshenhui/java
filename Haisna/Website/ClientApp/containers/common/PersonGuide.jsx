import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import PersonGuideHeaderForm from './PersonGuideHeaderForm';
import PersonGuideList from '../../components/common/PersonGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getPersonGuideListRequest, getPersonGuideRequest, closePersonGuide } from '../../modules/preference/personModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const PersonGuide = (props) => {
  const { conditions, searched, totalcount, data, onSearch, onSelectRow } = props;
  return (
    <GuideBase {...props} title="受診者の検索" page={conditions.page} limit={conditions.limit} usePagination >
      <PersonGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalcount > 0 && (
          <div>
            <p>検索結果は{totalcount}件ありました。</p>
            <PersonGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalcount === 0 && (
          <p>検索条件を満たす受診者情報は存在しません。<br />キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
PersonGuide.propTypes = {
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  totalcount: PropTypes.number.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  selectedItem: PropTypes.shape(),
  onSelected: PropTypes.func,
  // actionと紐付けされた項目
  onSearch: PropTypes.func.isRequired,
  onSelectRow: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
PersonGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.person.personGuide.visible,
  // 検索条件
  conditions: state.app.preference.person.personGuide.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.person.personGuide.searched,
  // 総レコード数
  totalcount: state.app.preference.person.personGuide.totalcount,
  // 個人一覧
  data: state.app.preference.person.personGuide.data,
  // 選択された要素
  selectedItem: state.app.preference.person.personGuide.selectedItem,
  // ガイドから受診者を選択した後の処理
  onSelected: state.app.preference.person.personGuide.onSelected,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    // 個人一覧取得アクションを呼び出す
    dispatch(getPersonGuideListRequest({ page: 1, limit: 20, ...conditions }));
  },
  // 行選択時の処理
  onSelectRow: (perid) => {
    // 選択行の個人情報取得アクションを呼び出す
    dispatch(getPersonGuideRequest({ perid }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closePersonGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PersonGuide);
