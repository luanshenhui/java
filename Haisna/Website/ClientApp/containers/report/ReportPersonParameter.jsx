/**
 * @file 受診者ガイドフィールド
 */
import React from 'react';
import { connect } from 'react-redux';
import { formValueSelector } from 'redux-form';

// 共通コンポーネント
import Chip from '../../components/Chip';
import GuideButton from '../../components/GuideButton';

// 受診者ガイドコンポーネント
import { openPersonGuide } from '../../modules/preference/personModule';

// レイアウト
const ReportPersonParameter = (props) => {
  // eslint-disable-next-line react/prop-types
  const { change, perName, perId, onOpen, perIdField, perNameField } = props;
  // 受診者ガイド選択後の処理
  const onSelected = (data) => {
    change(perIdField, data.perid);
    change(perNameField, `${data.lastname}${'　'}${data.firstname}`.trim());
  };
  return (
    <div style={{ display: 'flex' }}>
      <GuideButton onClick={() => onOpen({ onSelected })} />
      { perId && <Chip
        label={perName}
        onDelete={() => {
          change(perIdField, null);
          change(perNameField, null);
        }}
      />}
    </div>
  );
};

export default connect(
  // redux-formのstateをpropsで参照する
  (state, ownProps) => {
    const { formName, perIdField, perNameField } = ownProps;
    const selector = formValueSelector(formName);
    return {
      // 氏名
      perName: selector(state, perNameField),
      // 個人ID
      perId: selector(state, perIdField),
    };
  },
  (dispatch) => ({
    // 受診者ガイドを開く
    onOpen: (payload) => dispatch(openPersonGuide(payload)),
  }),
)(ReportPersonParameter);
