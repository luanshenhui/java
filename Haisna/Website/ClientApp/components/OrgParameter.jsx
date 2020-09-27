/**
 * @file 団体ガイドフィールド
 */
import React from 'react';
import { connect } from 'react-redux';
import { formValueSelector } from 'redux-form';

// 共通コンポーネント
import Chip from './Chip';
import GuideButton from './GuideButton';

// 団体ガイドコンポーネント
import { openOrgGuide } from '../modules/preference/organizationModule';

// レイアウト
const OrgParameter = (props) => {
  // eslint-disable-next-line react/prop-types
  const { change, orgName, orgCd1, orgCd2, onOpen, orgCd1Field, orgCd2Field, orgNameField } = props;
  // 団体ガイド選択後の処理
  const onSelected = (data) => {
    change(orgCd1Field, data.org.orgcd1);
    change(orgCd2Field, data.org.orgcd2);
    change(orgNameField, data.org.orgname);
  };
  return (
    <div style={{ display: 'flex' }}>
      <GuideButton onClick={() => onOpen({ onSelected })} />
      {orgCd1 && orgCd2 && <Chip
        label={orgName}
        onDelete={() => {
          change(orgCd1Field, null);
          change(orgCd2Field, null);
          change(orgNameField, null);
        }}
      />}
    </div>
  );
};

export default connect(
  // redux-formのstateをpropsで参照する
  (state, ownProps) => {
    const { formName, orgCd1Field, orgCd2Field, orgNameField } = ownProps;
    const selector = formValueSelector(formName);
    return {
      // 団体名
      orgName: selector(state, orgNameField),
      // 団体コード1
      orgCd1: selector(state, orgCd1Field),
      // 団体コード2
      orgCd2: selector(state, orgCd2Field),
    };
  },
  (dispatch) => ({
    // 団体ガイドを開く
    onOpen: (payload) => dispatch(openOrgGuide(payload)),
  }),
)(OrgParameter);
