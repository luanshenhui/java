// @flow

/**
 * @file 文章ガイド
 */

import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { reduxForm, Field, type FormProps } from 'redux-form';

import Dialog from '@material-ui/core/Dialog';
import DialogTitle from '@material-ui/core/DialogTitle';

// コンポーネントのインポート
import ModalContents from '../../components/control/ModalContents/ModalContents';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';
import Label from '../../components/control/Label';
import DropDown from '../../components/control/dropdown/DropDown';
import Button from '../../components/control/Button';
import SentenceList from '../../components/common/SentenceGuide/SentenceList';

// Action Creator、Stateタイプ定義のインポート
import { actions as sentenceGuideAction, type SentenceGuideState, type PayloadSentenceGuideSearchRequest } from '../../modules/common/sentenceGuideModule';
import type { StateSentenceClass } from '../../types/common/sentenceGuide';

// 検索フォームの定義
const SentenceGuideCondition = ({
  handleSubmit,
  sentenceClasses,
  onSubmit,
}: {
  sentenceClasses: Array<StateSentenceClass>,
  onSubmit: (param: PayloadSentenceGuideSearchRequest) => void,
} & FormProps) => {
  // 文章分類をドロップダウンリストのprops形式に変換
  const items: Array<{ value: string, name: string }> = sentenceClasses.map((rec) => ({
    value: rec.stcClassCd,
    name: rec.stcClassName,
  }));
  return (
    <form
      onSubmit={handleSubmit((values) => {
        const { stcClassCd } = values;
        onSubmit({ stcClassCd });
      })}
    >
      <Label>文章分類</Label>
      <Field component={DropDown} items={items} name="stcClassCd" addblank />
      <Button type="submit" value="表示" />
    </form>
  );
};

// Redux-Form化
const SentenceGuideConditionForm = reduxForm({
  form: 'sentenceGuideForm',
})(SentenceGuideCondition);

// コンポーネントの定義
const SentenceGuide = ({ sentenceGuide, actions }: {
  sentenceGuide: SentenceGuideState,
  actions: typeof sentenceGuideAction,
}) => (
  <Dialog
    maxWidth={false}
    open={sentenceGuide.open}
    onClose={() => {
      actions.sentenceGuideClose();
    }}
  >
    <DialogTitle>文章ガイド</DialogTitle>
    <ModalContents>
      <SentenceGuideConditionForm
        sentenceClasses={sentenceGuide.sentenceClasses}
        onSubmit={(params) => {
          actions.sentenceGuideSearchSentenceRequest(params);
        }}
      />
      <SentenceList
        sentences={sentenceGuide.sentences}
        onSelect={(stcCd) => {
          actions.sentenceGuideSelectSentenceRequest({ stcCd });
        }}
      />
      {sentenceGuide.isLoading && <CircularProgress />}
    </ModalContents>
  </Dialog>
);

// コンポーネントとstateとの接続
export default connect(
  (state) => ({
    sentenceGuide: state.app.common.sentenceGuide,
  }),
  (dispatch) => ({
    actions: bindActionCreators(sentenceGuideAction, dispatch),
  }),
)(SentenceGuide);
