/**
 * @file グループガイドフィールド
 */
import React from 'react';
import { connect } from 'react-redux';
import { Field, formValueSelector } from 'redux-form';
import { bindActionCreators } from 'redux';

// 共通コンポーネント
import TextBox from '../../components/control/TextBox';
import Chip from '../../components/Chip';
import GuideButton from '../../components/GuideButton';

// グループガイドコンポーネント
import * as GroupModules from '../../modules/preference/groupModule';

// レイアウト
const GrpParameter = (props) => {
  // eslint-disable-next-line react/prop-types
  const { change, grpName, grpCd, grpdiv, groupActions, grpCdField, grpNameField } = props;
  // 団体ガイド選択後の処理
  const onSelected = (data) => {
    change(grpCdField, data.grpcd);
    change(grpNameField, data.grpname);
  };

  // グループコードをフォーカスアウトしたときの処理
  const handleBlurGrpCd = (e) => {
    // 値がセットされていなければグループ名をクリア
    if (!e.target.value) {
      return change(grpNameField, null);
    }

    // グループ情報を取得するAPIを呼ぶ
    return groupActions.getGroupParamRequest({
      grpcd: e.target.value,
      successCallback: (data) => {
        // データを取得できればグループ名をセットする
        if (data) {
          return change(grpNameField, data.grpname);
        }
        return change(grpNameField, null);
      },
      // エラーになった場合グループ名をクリアする
      failureCallback: () => change(grpNameField, null),
    });
  };

  return (
    <div style={{ display: 'flex' }}>
      <GuideButton onClick={() => groupActions.openGroupGuide({ grpdiv, onSelected })} />
      <Field name={grpCdField} style={{ width: 70 }} component={TextBox} onBlur={(e) => handleBlurGrpCd(e)} />
      { grpCd && grpName && <Chip
        label={grpName}
        onDelete={() => {
          change(grpCdField, null);
          change(grpNameField, null);
        }}
      />}
    </div>
  );
};

export default connect(
  // redux-formのstateをpropsで参照する
  (state, ownProps) => {
    const { formName, grpCdField, grpNameField } = ownProps;
    const selector = formValueSelector(formName);
    return {
      // グループコード
      grpCd: selector(state, grpCdField),
      // グループ名
      grpName: selector(state, grpNameField),
    };
  },
  (dispatch) => ({
    // グループアクション
    groupActions: bindActionCreators(GroupModules, dispatch),
  }),
)(GrpParameter);
