/**
 * @file 個人ガイドフィールド
 */
import React from 'react';
import { connect } from 'react-redux';
import { formValueSelector } from 'redux-form';

// 共通コンポーネント
import Chip from '../../../components/Chip';
import GuideButton from '../../../components/GuideButton';

// 個人ガイドコンポーネント
import { openPersonGuide } from '../../../modules/preference/personModule';

// レイアウト
const PersonParameter = (props) => {
  // eslint-disable-next-line react/prop-types
  const { change, lastname, firstname, perid, onOpen, peridField, lastNameField, firstNameField } = props;
  // 個人ガイド選択後の処理
  const onSelected = (data) => {
    change(peridField, data.perid);
    change(lastNameField, data.lastname);
    change(firstNameField, data.firstname);
  };
  return (
    <div style={{ display: 'flex' }}>
      <GuideButton onClick={() => onOpen({ onSelected })} />
      {perid && <Chip
        label={`${lastname}  ${firstname}`}
        onDelete={() => {
          change(peridField, null);
          change(lastNameField, null);
          change(firstNameField, null);
        }}
      />}
    </div>
  );
};

export default connect(
  // redux-formのstateをpropsで参照する
  (state, ownProps) => {
    const { formName, peridField, lastNameField, firstNameField } = ownProps;
    const selector = formValueSelector(formName);
    return {
      // 個人姓名
      lastname: selector(state, lastNameField),
      firstname: selector(state, firstNameField),
      // 個人コード
      perid: selector(state, peridField),
    };
  },
  (dispatch) => ({
    // 個人ガイドを開く
    onOpen: (payload) => dispatch(openPersonGuide(payload)),
  }),
)(PersonParameter);
