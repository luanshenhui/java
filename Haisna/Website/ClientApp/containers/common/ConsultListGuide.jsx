import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import ConsultListGuideHeaderForm from './ConsultListGuideHeaderForm';
import ConsultListGuideList from '../../components/common/ConsultListGuideList';
import GuideBase from '../../components/common/GuideBase';

import { getConsultListGuideRequest, getConsultGuideRequest, closeConsultListGuide } from '../../modules/reserve/consultModule';

const Wrapper = styled.div`
  height: 680px;
  margin-top: 10px;
`;

const ConsultListGuide = (props) => {
  // const { conditions, searched, totalCount, data, onSearch, onSelectRow, csldate } = props;
  const { conditions, searched, totalCount, data, onSearch, onSelectRow } = props;
  return (
    <GuideBase {...props} title="受診者の検索" page={conditions.page} limit={conditions.limit} usePagination >
      <ConsultListGuideHeaderForm onSubmit={onSearch} />
      <Wrapper>
        {searched && totalCount > 0 && (
          <div>
            <ConsultListGuideList data={data} onSelectRow={onSelectRow} />
          </div>
        )}
        {searched && totalCount === 0 && (
          <p>対象受診者は{totalCount}人です。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
ConsultListGuide.propTypes = {
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
  // csldate: PropTypes.isRequired,
};

// defaultPropsの定義
ConsultListGuide.defaultProps = {
  onSelected: undefined,
  selectedItem: undefined,
  // csldate: PropTypes.isRequired,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.reserve.consult.guide.visible,
  // 検索条件
  conditions: state.app.reserve.consult.guide.conditions,
  // 検索指示が行われたか
  searched: state.app.reserve.consult.guide.searched,
  // 総レコード数
  totalCount: state.app.reserve.consult.guide.totalCount,
  // 受診者一覧
  data: state.app.reserve.consult.guide.data,
  // 選択された要素
  selectedItem: state.app.reserve.consult.guide.selectedItem,
  // 選択時実行処理
  onSelected: state.app.reserve.consult.guide.onSelected,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // 検索時の処理
  onSearch: (conditions) => {
    const page = 1;
    const limit = 20;
    // 受診者一覧取得アクションを呼び出す
    dispatch(getConsultListGuideRequest({ conditions: { page, limit, ...conditions } }));
  },
  // 行選択時の処理
  onSelectRow: (rsvno) => {
    // 選択行の受診者情報取得アクションを呼び出す
    dispatch(getConsultGuideRequest({ rsvno }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeConsultListGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ConsultListGuide);
