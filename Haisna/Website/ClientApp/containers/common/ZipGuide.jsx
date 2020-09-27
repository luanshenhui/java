import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import ZipGuideHeaderForm from './ZipGuideHeaderForm';
import ZipGuideList from './ZipGuideList';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';

import { getZipListRequest, getZip, closeZipGuide } from '../../modules/preference/zipModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const ZipGuide = (props) => {
  const {
    conditions,
    searched,
    totalCount,
    data,
    onSearch,
    onSelectRow,
    messages,
  } = props;

  // ページネーション用検索処理
  const onPagination = (page) => {
    onSearch({ ...conditions, page });
  };

  return (
    <GuideBase
      {...props}
      title="住所の検索"
      page={conditions.page}
      limit={conditions.limit}
      onSearch={onPagination}
      usePagination
    >
      <MessageBanner messages={messages} />
      <ZipGuideHeaderForm onSubmit={onSearch} conditions={conditions} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <p>検索結果は{totalCount}件ありました。</p>
            <ZipGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>検索条件を満たす郵便番号は存在しません。<br />キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
ZipGuide.propTypes = {
  // 親からpropsとして渡される項目
  onSelected: PropTypes.func,
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  totalCount: PropTypes.number.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  selectedItem: PropTypes.shape(),
  messages: PropTypes.arrayOf(PropTypes.string).isRequired,
  // actionと紐付けされた項目
  onSearch: PropTypes.func.isRequired,
  onSelectRow: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
ZipGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 検索条件
  conditions: state.app.preference.zip.conditions,
  // 検索指示が行われたか
  searched: state.app.preference.zip.searched,
  // 総レコード数
  totalCount: state.app.preference.zip.totalCount,
  // 郵便番号一覧
  data: state.app.preference.zip.data,
  // 選択された要素
  selectedItem: state.app.preference.zip.selectedItem,
  // ガイドの表示状態
  visible: state.app.preference.zip.visible,
  // メッセージ
  messages: state.app.preference.zip.messages,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索要求処理
  onSearch: (conditions) => {
    // 郵便番号一覧取得アクションを呼び出す
    const [page, limit] = [1, 20];
    dispatch(getZipListRequest({ page, limit, ...conditions }));
  },
  // 行選択処理
  onSelectRow: (selectedItem) => {
    dispatch(getZip({ selectedItem }));
  },
  // 郵便番号ガイドクローズ処理
  onClose: () => {
    dispatch(closeZipGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ZipGuide);
