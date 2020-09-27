import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import RptSetOptionGuideBodyForm from './RptSetOptionGuideBodyForm';
import GuideBase from '../../../components/common/GuideBase';
import MessageBanner from '../../../components/MessageBanner';

import { closeOrgRptSetOptionGuide, getOrgRptSetOptionGuideRequest, registerOrgRptOptRequest } from '../../../modules/preference/organizationModule';

const RptSetOptionGuide = (props) => {
  const {
    conditions,
    onLoad,
    onSave,
    onClose,
    messages,
    orgName,
  } = props;

  return (
    <GuideBase {...props} title="成績書オプション管理" usePagination>
      <MessageBanner messages={messages} />
      <RptSetOptionGuideBodyForm onLoad={onLoad} onSave={onSave} onClose={onClose} conditions={conditions} orgName={orgName} />
    </GuideBase>
  );
};

// propTypesの定義
RptSetOptionGuide.propTypes = {
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  messages: PropTypes.arrayOf(PropTypes.string).isRequired,
  // actionと紐付けされた項目
  onLoad: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  orgName: PropTypes.string,
};

RptSetOptionGuide.defaultProps = {
  orgName: '',
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  // 検索条件
  conditions: state.app.preference.organization.organizationRptOptionGuide.conditions,
  // ガイドの表示状態
  visible: state.app.preference.organization.organizationRptOptionGuide.visible,
  // メッセージ
  messages: state.app.preference.organization.organizationRptOptionGuide.messages,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  onLoad: (conditions, formName) => {
    // 画面を初期化
    const { orgcd1, orgcd2 } = conditions;
    // 団体コード1、団体コード2がなければ以降何もしない
    if (orgcd1 === undefined || orgcd2 === undefined) {
      return;
    }
    dispatch(getOrgRptSetOptionGuideRequest({ orgcd1, orgcd2, formName }));
  },
  // 成績書オプション管理ガイド保存処理
  onSave: (values) => {
    const { orgcd1, orgcd2, orgrptoptrptd, orgrptoptrptv } = values;
    dispatch(registerOrgRptOptRequest({ orgcd1, orgcd2, data: [...orgrptoptrptd, ...orgrptoptrptv] }));
    dispatch(closeOrgRptSetOptionGuide());
  },
  // 成績書オプション管理ガイドクローズ処理
  onClose: () => {
    dispatch(closeOrgRptSetOptionGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RptSetOptionGuide);
