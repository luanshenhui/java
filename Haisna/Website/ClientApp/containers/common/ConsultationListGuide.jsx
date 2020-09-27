/**
 * @file 受診者検索画面（gdeConsultList.asp）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { bindActionCreators } from 'redux';
import moment from 'moment';

import ConsultationListGuideHeaderForm from './ConsultationListGuideHeaderForm';
import ConsultationListGuideList from '../../components/common/ConsultationListGuideList';
import GuideBase from '../../components/common/GuideBase';

import * as consultModule from '../../modules/reserve/consultModule';

const Wrapper = styled.div`
  height: 600px;
  margin-top: 10px;
`;

const ConsultationListGuide = (props) => {
  // const { conditions, searched, totalCount, data, onSearch, onSelectRow, csldate } = props;
  const { guideState, consultActions } = props;

  // 検索結果読み込み処理
  const handleSubmitContent = (conditions) => {
    const page = 1;
    const limit = 20;
    consultActions.getConsultationListGuideRequest({ page, limit, ...conditions });
  };

  // 自分自身の受診情報は一覧に表示しないようにする
  const data = Array.isArray(guideState.data) ? guideState.data.filter((rec) => rec.perid !== guideState.perid) : [];
  // 件数は自分自身を省いたものを表示
  const count = data.length;

  // 行選択時処理、Trueであればガイドを閉じる
  const handleSelectRow = (values) => {
    if (guideState.onSelected(values)) {
      consultActions.closeConsultationListGuide();
    }
  };

  return (
    <GuideBase
      {...props}
      visible={guideState.visible}
      title="受診者の検索"
      page={guideState.conditions.page}
      limit={guideState.conditions.limit}
      usePagination
      onClose={() => consultActions.closeConsultationListGuide()}
    >
      <ConsultationListGuideHeaderForm onSubmit={handleSubmitContent} />
      <Wrapper>
        {guideState.searched && count > 0 && (
          <div>
            <p>「{moment(guideState.conditions.csldate).format('YYYY年M月D日')}」の受診者一覧を表示しています。</p>
            <p>対象受診者は{count}人です。</p>
            <ConsultationListGuideList data={data} onSelectRow={handleSelectRow} />
          </div>
        )}
        {guideState.searched && count <= 0 && (
          <p>検索条件を満たす受診情報は存在しません。</p>
        )}
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
ConsultationListGuide.propTypes = {
  // stateと紐付けされた項目
  guideState: PropTypes.shape().isRequired,
  // actionと紐付けされた項目
  consultActions: PropTypes.shape().isRequired,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  guideState: state.app.reserve.consult.consultationGuide,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModule, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(ConsultationListGuide);
