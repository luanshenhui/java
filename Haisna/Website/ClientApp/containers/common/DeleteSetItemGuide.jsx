/**
 * @file 受付ガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { reduxForm, Field, FormSection } from 'redux-form';
import styled from 'styled-components';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import Checkbox from '../../components/control/CheckBox';
import MessageBanner from '../../components/MessageBanner';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 800px;
  width: 650px;
`;

// レイアウト
const Section = styled.div`
  margin-top: 10px;
`;
const ItemField = styled.div`
  display: inline-block;
  width: 50%;
`;
const Line = styled.div`
`;

const formName = 'deleteSetItemGUide';

const mapStateToProps = (state) => ({
  initialValues: state.app.reserve.consult.consultItemDeleteGuide.initialValues,
  guideState: state.app.reserve.consult.consultItemDeleteGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

// 表示処理
const DeleteSetItemGUide = (props) => {
  const { guideState, consultActions, handleSubmit, reset } = props;

  // ガイドを閉じる処理
  const handleClose = () => {
    // 画面を閉じる
    consultActions.closeConsultDeleteItemGuide();
    // redux-formのstateを初期化
    reset();
  };

  // submit時の処理
  const handleSubmitContent = (values) => {
    const { rsvno } = guideState;
    const { items } = values;
    // 検査状態登録処理実行
    consultActions.registerContractOptionItemsDeleteItemGuideRequest({
      data: { rsvno, items },
      callback: () => {
        // 受付キャンセルガイドを閉じる
        handleClose();
      },
    });
  };

  return (
    <Modal
      caption="セット内項目の削除"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        <form onSubmit={handleSubmit((values) => handleSubmitContent(values))}>
          <DialogActions>
            <Button
              value="保存"
              type="submit"
            />
            <Button
              value="キャンセル"
              onClick={() => handleClose()}
            />
          </DialogActions>
          <Section>
            検査セット名：{guideState.data.optname}
          </Section>
          <Section>
            <Line>●セット内受診項目の一覧を表示しています。</Line>
            <Line>●受診を行わない項目については<Checkbox name="dummy" checked />マークを外して下さい。</Line>
          </Section>
          <Section>
            <FormSection name="items">
              { !guideState.optionItems && 'このセットの受診項目は存在しません。' }
              {
                guideState.optionItems && guideState.optionItems.map((rec) => (
                  <ItemField key={rec.itemcd}>
                    <Field component={Checkbox} name={rec.itemcd} label={rec.requestname} checkedValue={1} />
                  </ItemField>
                ))
              }
            </FormSection>
          </Section>
        </form>
      </Content>
    </Modal>
  );
};

DeleteSetItemGUide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const DeleteSetItemGUideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(DeleteSetItemGUide);

export default connect(mapStateToProps, mapDispatchToProps)(DeleteSetItemGUideForm);
